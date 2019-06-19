#delimit;
clear;
set more off;
set matsize 800;

global temp /Sastemp;
global path ~/research;

set mem 5000m;

capture log close;
*log using $masterpath/logfiles/trade_data.log, replace;

/*================================================
 Program: cew_trade.do
 Author:  Avi Ebenstein
 Created: June 2008
 Purpose: Take in the raw CEW data and
          merge with the trade data
=================================================*/

**********************************************************************;
* Prepare the 4-digit SIC crosswalk for manufacturing from NBER data  ;
**********************************************************************;

use $masterpath/crosswalk/conch_sh;
gsort sic72 -sh7287;

*************************************************************;
* Keep the sic87 which receives the largest share from sic72 ;
*************************************************************;

by sic72: keep if _n==1;
sort sic72;
rename sic87 sic_87;

label data "SIC72 -> SIC87 (when you have sic72, this gives you sic87)";
save $masterpath/crosswalk/sic7287, replace;

*************************************************************************;
* Take data from 1975-2000, and convert from SIC72 -> SIC87 (year<=1986) ;
*************************************************************************;

use $masterpath/cew/cew_75_00;
/* Only keep private enterprises */
keep if own==5;
drop if nd==9;
/* Manufacturing only */
keep if sic>=2000 & sic<=4000;
gen sic72=sic;

/* Only merge the observations prior to switch */
replace sic72=. if year>=1988;

sort sic72;
merge sic72 using $masterpath/crosswalk/sic7287;
tab _merge if year<=1987;
tab _merge if year>=1988;
keep if _merge==1|_merge==3;

/* Create consistent SIC variable*/  
gen sic87=.;
replace sic87=sic_87 if year<=1987;
replace sic87=sic    if year>=1988;

collapse (sum) emp (sum) wages, by(sic87 year);
save $masterpath/cew/cew_4digit, replace;

**********************************************************;
* Use the CEW data to weight the trade up to the 1987 SIC ;
**********************************************************;

use $masterpath/cew/cew_4digit, clear;

********************************;
* Add 2 additional years to CEW ;
********************************;

expand 3 if year==2000;
sort sic87 year;
by sic87: replace year=2001 if year[_n-1]==2000;
by sic87: replace year=2002 if year[_n-2]==2000;

******************************;
* Trade and investment prices ;
******************************;

sort sic87 year;
merge sic87 year using $masterpath/trade/trade_update_new.dta;
tab _merge;
keep if _merge==3;
drop _merge;

save $masterpath/trade/trade_4digit, replace;

*****************************************************;
* Aggregate these up to a 3-digit SIC (not used)     ;
*****************************************************;

use $masterpath/trade/trade_4digit,clear;
gen sic3=floor(sic87/10);
capture gen psh=0; /* new line of code */

bysort sic3 year: gen cellsize=_N;
bysort sic3 year: egen totemp=sum(emp);
bysort sic3 year: egen totwages=sum(wages);
bysort sic3 year: egen penmod_m=sum(penmod*emp/totemp);
bysort sic3 year: egen expmod_m=sum(expmod*emp/totemp);
bysort sic3 year: egen vsh_m=sum(vsh*emp/totemp);
bysort sic3 year: egen psh_m=sum(psh*emp/totemp);
bysort sic3 year: egen t_m=sum(t*emp/totemp);
bysort sic3 year: egen f_m=sum(f*emp/totemp);
bysort sic3 year: egen piinv_m=sum(piinv*emp/totemp);
bysort sic3 year: egen tfp5_m=sum(tfp5*emp/totemp);
bysort sic3 year: egen rpiship_m=sum(rpiship*emp/totemp);

bysort sic3 year: egen labor_m=sum(labor*emp/totemp);
bysort sic3 year: egen cap_m=sum(cap*emp/totemp);


collapse penmod=penmod_m expmod=expmod_m vsh=vsh_m psh=psh_m t=t_m f=f_m piinv=piinv_m tfp5=tfp5_m rpiship=rpiship_m cap=cap_m labor_m

totemp totwages cellsize,by(sic3 year);
label data "Trade variables and CEW data at 3-digit SIC87";
save $masterpath/trade/trade_3digit, replace;

******************************************************;
* Put these in the units of man7090 (taken from autor);
******************************************************; 

use $masterpath/trade/trade_4digit,clear;
bysort sic87: egen emp79=max(emp*(year==1979));

gen sic3=floor(sic87/10);
capture gen psh=0; /* new line of code */

capture drop sic87;
rename sic3 sic87;
sort sic87;
merge sic87 using $masterpath/autor/sic87_3-man7090;
keep if _merge==3;

bysort man7090 year: egen totemp=sum(emp);

bysort man7090 year: egen vsh_m=sum(vsh*emp/totemp);
bysort man7090 year: egen psh_m=sum(psh*emp/totemp);
bysort man7090 year: egen penmod_m=sum(penmod*emp/totemp);
bysort man7090 year: egen expmod_m=sum(expmod*emp/totemp);
bysort man7090 year: egen t_m=sum(t*emp/totemp);
bysort man7090 year: egen f_m=sum(f*emp/totemp);
bysort man7090 year: egen piinv_m=sum(piinv*emp/totemp);
bysort man7090 year: egen tfp5_m=sum(tfp5*emp/totemp);
bysort man7090 year: egen rpiship_m=sum(rpiship*emp/totemp);
bysort man7090 year: egen labor_m=sum(labor*emp/totemp);
bysort man7090 year: egen cap_m=sum(cap*emp/totemp);
 
*********************************************;
* Assemble trade data at alternative weights ;
*********************************************;

bysort man7090 year: egen totemp79=sum(emp79);

bysort man7090 year: egen vsh79_m=sum(vsh*emp79/totemp79);
bysort man7090 year: egen psh79_m=sum(psh*emp79/totemp79);
bysort man7090 year: egen penmod79_m=sum(penmod*emp79/totemp79);
bysort man7090 year: egen expmod79_m=sum(expmod*emp79/totemp79);
bysort man7090 year: egen t79_m=sum(t*emp79/totemp79);
bysort man7090 year: egen f79_m=sum(f*emp79/totemp79);
bysort man7090 year: egen piinv79_m=sum(piinv*emp79/totemp79);
bysort man7090 year: egen tfp579_m=sum(tfp5*emp79/totemp79);
bysort man7090 year: egen rpiship79_m=sum(rpiship*emp79/totemp79);
bysort man7090 year: egen labor79_m=sum(labor*emp79/totemp79);
bysort man7090 year: egen cap79_m=sum(cap*emp79/totemp79);

*********************************************;
* Track wage bill and # of 4-digit SIC codes ;
*********************************************;

bysort man7090 year: egen totwages=sum(wages);
bysort man7090 year: gen cellsize=_N;

collapse penmod=penmod_m expmod=expmod_m vsh=vsh_m psh=psh_m t=t_m f=f_m
penmod79=penmod79_m expmod79=expmod79_m vsh79=vsh79_m psh79=psh79_m t79=t79_m f79=f79_m
piinv=piinv_m piinv79=piinv79_m tfp579=tfp579_m rpiship=rpiship_m rpiship79=rpiship79_m labor=labor_m labor79=labor_m cap=cap_m cap79=cap79_m
totemp79
totemp totwages cellsize
,by(man7090 year);

label data "Trade variables at man7090 (67 categories)";
label var vsh "Low Wage Country Import Value Share";
label var psh "Low Wage Country Import Number Share";
label var penmod "Imports/(Imports+Production)";
label var expmod "Exports/Shipments";
label var t "Import Weighted Tariff";
label var f "Import Weighted CIF/Customs-1 at 1979 weights";
label var piinv "Price of investment (NBER)";
label var tfp5  "Total factor productivity (5 factor)";
label var rpiship "Real shipments";
label var labor "Total employment in 1000s (nber)";
label var cap "Total real capital stock in $1m (nber)";
label var vsh79 "Low Wage Country Import Value Share at 1979 weights";
label var psh79 "Low Wage Country Import Number Share at 1979 weights";
label var penmod79 "Imports/(Imports+Production) at 1979 weights";
label var expmod79 "Exports/Shipments at 1979 weights";
label var t79 "Import Weighted Tariff at 1979 weights";
label var f79 "Import Weighted CIF/Customs-1 at 1979 weights";
label var piinv79 "Price of investment at 1979 weights";
label var tfp579 "Total factor productivity (5 factor) at 1979 weights";
label var rpiship79 "Real shipments at 1979 weights";
label var labor79 "Total employment in 1000s at 1979 weights (nber)";
label var cap79 "Total real capital stock in $1m at 1979 weights (nber)";

label var totemp "Employment (CEW 4-digit aggregated)";
label var totwages "Total Wages (CEW 4-digit aggregated)";

label var totemp79 "Employment (CEW 4-digit aggregated) at 1979 weights";

tab cellsize;
drop cellsize;

*drop totemp totwages;

do $masterpath/dofiles/labels_man7090.do;

*****************************************************************************;
* Special fix for incomplete trade series data - not currently doing this!!! ;
*****************************************************************************;

*replace penmod=. if penmod==0 & (year>=1997) & (man7090==6|man7090==35|man7090==20|man7090==21|man7090==43|man7090==62|man7090==64);
*replace penmod79=. if penmod==. & (year>=1997) & (man7090==6|man7090==35|man7090==20|man7090==21|man7090==43|man7090==62|man7090==64);
save $masterpath/datafiles/trade_man7090, replace;

*************************;
