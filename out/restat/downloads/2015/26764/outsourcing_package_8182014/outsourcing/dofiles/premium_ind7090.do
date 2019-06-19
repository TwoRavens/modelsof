#delimit;
clear;
set more off;
set matsize 800;

global temp /Sastemp;
global path ~/research;
set mem 5000m;

capture log close;
*log using $masterpath/premium_data.log, replace;

/*================================================
 Program: premium_data.do
 Author:  Avi Ebenstein
 Created: March 2007
 Purpose: Prepare wage data from CPS MORG respondents
          and store individual-level data in wage_data.dta.
          Collapse by industry and year into premium_ind7090.dta.

=================================================*/

use $masterpath/cpsfiles/morg_data, clear;
drop if year>=2003;

keep if empl==1 & uhourse>0;

***********************************;
* Lemieux Code taken from 2006 AER ;
* to prepare for wage regressions  ;
***********************************;

**** Adjust regressors to be consistent over sample period;
*if educ<=4 then educ=3;
*else if 5<=educ<=8 then educ=7;
*else if 13<=educ<=15 then educ=14;
*else if educ>=17 then educ=18;
*agedum=age;
*age2=age*age/100;
*age3=age2*age/10;
*age4=age2*age2;
*yr00=(year=100);
*********************************************************;

gen lyrsed=yrsed;
replace lyrsed=3  if yrsed<=4;
replace lyrsed=7  if yrsed>=5  & yrsed<=8;
replace lyrsed=14 if yrsed>=13 & yrsed<=15;
replace lyrsed=18 if yrsed>=17;

gen agedum=age;
gen age2=age*age/100;
gen age3=age2*age/10;
gen age4=age2*age2;
gen yr00=(year==2000);

gen leduc=lyrsed;
gen leduc1=lyrsed*age;
gen leduc2=lyrsed*age2;
gen leduc3=lyrsed*age3;
gen leduc4=lyrsed*age4;

**************************************************;
* Workers weighted by CPS earnings weight * hours ;
**************************************************;

gen hwt=orgwgt*uhourse;
gen ihwt=round(hwt);

****************************;
* New Mincer specification  ;
****************************;
egen expergp=cut(exper), at(0(3)45 100);
xi i.educ*i.expergp i.year i.state;

reg lwage _Ieduc* _Iexper* _IeduXexp* female nonwhite _Iyear* _Istate* [w=ihwt];
predict yhat;
gen myresid=lwage-yhat;

gen yhat_year=.;
local X=1982;
while `X'<=2002 {;
  reg lwage _Ieduc* _Iexper* _IeduXexp* female nonwhite _Istate* if year==`X' [w=ihwt];
  predict yhat`X' if year==`X';
  replace yhat_year=yhat`X' if year==`X';
local X=`X'+1;
};
gen myresid_year=lwage-yhat_year;

drop _I*;

label var lwage "Log of Real Hourly Wage";
label var myresid "Predcited-Actual Log of Real Hourly Wage";

label var ehf "Eye hand foot (nonroutine manual)";
label var finger "Finger dexterity (routine manual)";
label var dcp "Direction, Control, Planning (nonroutine interactive)";
label var sts "Set limits, Tolerances, or Standards (routine cognitive)";
label var math "General educational development, mathematics (nonroutine analytic)";

*****************;
* Save microdata ;
*****************;

save $masterpath/datafiles/micro_ind7090, replace;

**************************************************;
* The MORG files are 12 times the true population ;
**************************************************;

bysort ind7090 year: egen emp=sum(orgwgt/12);
bysort ind7090 year: egen wages=sum(w_ln_ot*uhourse*52*orgwgt/12);

gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);

**************************;
* Collapse the micro data ;
**************************;

gen dummy=1;
collapse (mean) lwage (p10) lwage10=lwage (p25) lwage25=lwage (p50) lwage50=lwage (p75) lwage75=lwage (p90) lwage90=lwage
(mean) myresid (p10) myresid10=myresid (p25) myresid25=myresid (p50) myresid50=myresid (p75) myresid75=myresid (p90) myresid90=myresid
(mean) myresid_year (p10) myresid10_year=myresid_year (p25) myresid25_year=myresid_year (p50) myresid50_year=myresid_year (p75) myresid75_year=myresid_year (p90) myresid90_year=myresid_year
(mean) ehf (mean) finger (mean) dcp (mean) sts (mean) math (mean) routine
(mean) emp_cps=emp (mean) wages_cps=wages (sum) respondents=dummy [w=ihwt],by(ind7090 year) fast;

label var lwage "CPS MORG mean Log Hourly Wage within industry X year";
label var lwage10 "10th percentile of lwage within industry X year";
label var lwage25 "25th percentile of lwage within industry X year";
label var lwage50 "50th percentile of lwage within industry X year";
label var lwage75 "75th percentile of lwage within industry X year";
label var lwage90 "90th percentile of lwage within industry X year";

label var myresid "CPS MORG mean wage residual (Predicted-Actual Log Hourly Wage)";
label var myresid10 "10th percentile of myresid within industry X year";
label var myresid25 "25th percentile of myresid within industry X year";
label var myresid50 "50th percentile of myresid within industry X year";
label var myresid75 "75th percentile of myresid within industry X year";
label var myresid90 "90th percentile of myresid within industry X year";
label var myresid_year "CPS MORG mean yearly wage residual (Predicted Yearly-Actual Log Hourly Wage)";
label var myresid10_year "10th percentile of myresid_year within industry X year";
label var myresid25_year "25th percentile of myresid_year within industry X year";
label var myresid50_year "50th percentile of myresid_year within industry X year";
label var myresid75_year "75th percentile of myresid_year within industry X year";
label var myresid90_year "90th percentile of myresid_year within industry X year";

label var ehf "Eye hand foot (nonroutine manual)";
label var finger "Finger dexterity (routine manual)";
label var dcp "Direction, Control, Planning (nonroutine interactive)";
label var sts "Set limits, Tolerances, or Standards (routine cognitive)";
label var math "General educational development, mathematics (nonroutine analytic)";
label var emp_cps "CPS MORG earnings weight employment";
label var wages_cps "CPS MORG total wages";
label var respondents "CPS MORG # of respondents";

save $masterpath/datafiles/premium_ind7090, replace;

*********************************;
