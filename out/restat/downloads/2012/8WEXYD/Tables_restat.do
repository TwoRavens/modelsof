***************************************************************
*** Date: April, 2010
***************************************************************
*** This program recreates the results in 
*** "Trade Liberalization and Firm Productivity: The Case of India"
***  by Petia Topalova and Amit Khandelwal
**************************************************************

***************************************************************
*** SETUP
***************************************************************

clear all
# delimit;
capture log close;
set memory 400m;
set matsize 5000;
set more off;

*cd "e:\d\IMF\Productivity\RESTAT\";

tempfile dis;
tempfile a;
tempfile b;
tempfile c;

local table1 = 1;
local table2 = 1;
local table3 = 1;
local table4 = 1;
local table5 = 1;
local table6 = 1;
local table7 = 1;
local table8 = 1;
local table9 = 1;
local tableA3 = 1;

capture log close;
noisily log using Tables, replace text;

global cov2 "prgroup govown foreign medium small age age2";

if `table1' {;
*******************************************************************;
*** Table 1 ;
*******************************************************************;

use prod_dataregression, replace;
keep  yr tariff inputariff erp;
duplicates drop;
sort yr;
foreach X in tariff erp inputariff {;
	by yr: egen mn_`X' = mean(`X');
	by yr: egen sd_`X' = sd(`X');
};

foreach X in tariff erp inputariff {;
	egen mn96`X' = mean(`X') if yr<1997;
	egen sd96`X' = sd(`X') if yr<1997;
	egen mn96_`X' = max(mn96`X');
	egen sd96_`X' = max(sd96`X');
};

keep yr mn_* mn96_* sd_* sd96_*;
duplicates drop;

order yr mn_tariff sd_tariff mn_erp sd_erp mn_inputariff sd_inputariff
 mn96_tariff sd96_tariff mn96_erp sd96_erp mn96_inputariff sd96_inputariff;
outsheet using table1.csv, comma replace;

};

if `table2' {;
*******************************************************************;
*** Table 2 ;
*******************************************************************;

use industrydata, replace;

xi: reg tarchange logrealwage i.usebased [aw=no_factories], robust ;
	estimates store var_1; 
xi: reg tarchange nonworkempl i.usebased [aw=no_factories], robust ;
	estimates store var_2; 
xi: reg tarchange k_l i.usebased [aw=no_factories], robust ;
	estimates store var_3; 
xi: reg tarchange logoutput i.usebased [aw=no_factories], robust ;
	estimates store var_4; 
xi: reg tarchange sizefact i.usebased [aw=no_factories], robust ;
	estimates store var_5; 
xi: reg tarchange logemployment i.usebased [aw=no_factories], robust ;
	estimates store var_6; 
xi: reg tarchange growthoutput2 i.usebased [aw=no_factories], robust ;
	estimates store var_7; 
xi: reg tarchange growthempl2 i.usebased [aw=no_factories], robust ;
	estimates store var_8; 
estout var_1 var_2  var_3 var_4 var_5  var_6 var_7 var_8
	using tables_restat.txt, append preh(" " "Table 2. Declines in Trade Protection and Pre-Reform Industrial Characteristics, Panel A")
		keep(logrealwage nonworkempl k_l logoutput sizefact logemployment growthoutput2 growthempl2) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats (r2 N arm1 arm2, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;

xi: reg inputariffchange logrealwage i.usebased [aw=no_factories], robust ;
	estimates store var_1; 
xi: reg inputariffchange nonworkempl i.usebased [aw=no_factories], robust ;
	estimates store var_2; 
xi: reg inputariffchange k_l i.usebased [aw=no_factories], robust ;
	estimates store var_3; 
xi: reg inputariffchange logoutput i.usebased [aw=no_factories], robust ;
	estimates store var_4; 
xi: reg inputariffchange sizefact i.usebased [aw=no_factories], robust ;
	estimates store var_5; 
xi: reg inputariffchange logemployment i.usebased [aw=no_factories], robust ;
	estimates store var_6; 
xi: reg inputariffchange growthoutput2 i.usebased [aw=no_factories], robust ;
	estimates store var_7; 
xi: reg inputariffchange growthempl2 i.usebased [aw=no_factories], robust ;
	estimates store var_8; 
estout var_1 var_2  var_3 var_4 var_5  var_6 var_7 var_8
	using tables_restat.txt, append preh(" " "Table 2. Declines in Trade Protection and Pre-Reform Industrial Characteristics, Panel B")
		keep(logrealwage nonworkempl k_l logoutput sizefact logemployment growthoutput2 growthempl2) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats (r2 N arm1 arm2, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;

xi: reg erpchange logrealwage i.usebased [aw=no_factories], robust ;
	estimates store var_1; 
xi: reg erpchange nonworkempl i.usebased [aw=no_factories], robust ;
	estimates store var_2; 
xi: reg erpchange k_l i.usebased [aw=no_factories], robust ;
	estimates store var_3; 
xi: reg erpchange logoutput i.usebased [aw=no_factories], robust ;
	estimates store var_4; 
xi: reg erpchange sizefact i.usebased [aw=no_factories], robust ;
	estimates store var_5; 
xi: reg erpchange logemployment i.usebased [aw=no_factories], robust ;
	estimates store var_6; 
xi: reg erpchange growthoutput2 i.usebased [aw=no_factories], robust ;
	estimates store var_7; 
xi: reg erpchange growthempl2 i.usebased [aw=no_factories], robust ;
	estimates store var_8; 
estout var_1 var_2  var_3 var_4 var_5  var_6 var_7 var_8
	using tables_restat.txt, append preh(" " "Table 2. Declines in Trade Protection and Pre-Reform Industrial Characteristics, Panel C")
		keep(logrealwage nonworkempl k_l logoutput sizefact logemployment growthoutput2 growthempl2) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats (r2 N arm1 arm2, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;

};


if `table3' {;
*******************************************************************;
*** Table 3 ;
*******************************************************************;
use prod_dataregression, replace;
keep if tfp1000 !=.;
gen n=1;
sort industrycode yr;
by industrycode yr: egen ncompanies = sum(n);
collapse (mean) tariff_plus tfp1000 erp_plus inputariff_plus ncompanies [aw=rsales] , by(industrycode yr);

xi: areg tariff_plus tfp100  i.yr [aw=ncompanies], absorb(industrycode) robust cluster(industrycode);
	estimates store var_1; 

xi: areg tariff_plus tfp100  i.yr [aw=ncompanies] if yr<1997, absorb(industrycode) robust cluster(industrycode);
	estimates store var_2; 

xi: areg tariff_plus tfp100   i.yr [aw=ncompanies] if yr>=1997, absorb(industrycode) robust cluster(industrycode);
	estimates store var_3; 
estout var_1 var_2  var_3 
	using tables_restat.txt, append preh(" " "Table 3. Trade Policy Endogeneity: Current Productivity and Subsequent Trade Policy, Panel A")
		keep(tfp1000) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats (N, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;

xi: areg inputariff_plus tfp100  i.yr [aw=ncompanies], absorb(industrycode) robust cluster(industrycode);
	estimates store var_1; 

xi: areg inputariff_plus tfp100  i.yr [aw=ncompanies] if yr<1997, absorb(industrycode) robust cluster(industrycode);
	estimates store var_2; 

xi: areg inputariff_plus tfp100   i.yr [aw=ncompanies] if yr>=1997, absorb(industrycode) robust cluster(industrycode);
	estimates store var_3; 
estout var_1 var_2  var_3 
	using tables_restat.txt, append preh(" " "Table 3. Trade Policy Endogeneity: Current Productivity and Subsequent Trade Policy, Panel B")
		keep(tfp1000) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats (N, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;

xi: areg erp_plus tfp100  i.yr [aw=ncompanies], absorb(industrycode) robust cluster(industrycode);
	estimates store var_1; 

xi: areg erp_plus tfp100  i.yr [aw=ncompanies] if yr<1997, absorb(industrycode) robust cluster(industrycode);
	estimates store var_2; 

xi: areg erp_plus tfp100   i.yr [aw=ncompanies] if yr>=1997, absorb(industrycode) robust cluster(industrycode);
	estimates store var_3; 
estout var_1 var_2  var_3 
	using tables_restat.txt, append preh(" " "Table 3. Trade Policy Endogeneity: Current Productivity and Subsequent Trade Policy, Panel C")
		keep(tfp1000) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats (N, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;

};



if `table4' {;

*******************************************************************;
*** Table 4a ;
*******************************************************************;
#delim ;
use prod_dataregression, replace;
keep if yr<1997;
drop yeardum9-yeardum14 ;

tsset id yr;
xi: reg tfp1000 lagtariff  $cov2 i.yr , robust cluster(companyname);
	estimates store var_1; 

xi: areg tfp1000 lagtariff  $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var_2; 

xi: areg tfp1000 lagtariff  $cov2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_3; 

xi: areg tfp1000 lagtariff  $cov2 i.yr if  exist90_96==1, absorb(companyname) cluster(companyname);
	estimates store var_4; 

xi: areg tfp1000 lagtariff lagtfp1000  $cov2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_5; 

xtabond tfp1000 lagtariff yeardum* age age2, robust;
	estimates store var_6; 

xtabond tfp1000 lagtariff yeardum* age age2, robust lag(2);
	estimates store var_7; 
estout var_1 var_2  var_3 var_4 var_5  var_6 var_7
	using tables_restat.txt, append preh(" " "Table 4a. Output Tariffs and Total Factor Productivity")
		keep(lagtariff lagtfp1000 prgroup govown foreign medium small age age2) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats (r2 N arm1 arm2, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;

*******************************************************************;
*** Table 4b ;
*******************************************************************;

xi: reg tfp1000 lagerp  $cov2 i.yr , robust cluster(companyname);
	estimates store var_1; 

xi: areg tfp1000 lagerp  $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var_2; 

xi: areg tfp1000 lagerp  $cov2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_3; 

xi: areg tfp1000 lagerp  $cov2 i.yr if  exist90_96==1, absorb(companyname) cluster(companyname);
	estimates store var_4; 

xi: areg tfp1000 lagerp lagtfp1000  $cov2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_5; 

xtabond tfp1000 lagerp yeardum* age age2, robust;
	estimates store var_6; 

xtabond tfp1000 lagerp yeardum* age age2, robust lag(2);
	estimates store var_7; 
estout var_1 var_2  var_3 var_4 var_5  var_6 var_7
	using tables_restat.txt, append preh(" " "Table 4b. Effective Rates of Protection and Total Factor Productivity")
		keep(lagerp lagtfp1000 prgroup govown foreign medium small age age2) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats (r2 N arm1 arm2, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;

};

*******************************************************************;
*** TABLE 5 - Output and Input Tariffs on Total Factor Productivity; 
*******************************************************************;
if `table5' {;

use prod_dataregression, replace;
keep if yr<1997;
drop yeardum9-yeardum14 ;

tsset id yr;
xi: reg tfp1000 lagtariff laginputariff  $cov2 i.yr , robust cluster(companyname);
	estimates store var_1; 

xi: areg tfp1000 lagtariff laginputariff $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var_2; 

xi: areg tfp1000 lagtariff laginputariff $cov2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_3; 

xi: areg tfp1000 lagtariff laginputariff $cov2 i.yr if  exist90_96==1, absorb(companyname) cluster(companyname);
	estimates store var_4; 

xi: areg tfp1000 lagtariff laginputariff lagtfp1000  $cov2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_5; 

xtabond tfp1000 lagtariff laginputariff yeardum* age age2, robust;
	estimates store var_6; 

xtabond tfp1000 lagtariff laginputariff yeardum* age age2, robust lag(2);
	estimates store var_7; 
estout var_1 var_2  var_3 var_4 var_5  var_6 var_7
	using tables_restat.txt, append preh(" " "Table 5. Output and Input Tariffs on Total Factor Productivity")
		keep(lagtariff laginputariff lagtfp1000 prgroup govown foreign medium small age age2) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats (r2 N arm1 arm2, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;
};

***************************************************************;
* TABLE 6 - Trade Liberalization and Industry Characteristics ;
***************************************************************;
if `table6' {;

use prod_dataregression, replace;
keep if yr<1997;
drop yeardum9-yeardum14 ;

tsset id yr;

*** Panel A ;

xi: areg tfp1000 lagtariff age age2 i.yr if (use_B>=.75 | use_I>=.75 | use_C>=.75) & use_B!=., absorb(companyname) cluster(companyname);
	estimates store c_BCI; 
 xtabond tfp1000 lagtariff yeardum*  age age2 if (use_B>=.75 | use_I>=.75 | use_C>=.75)  & use_B!=., robust lag(2);
 	estimates store c_BCI2; 

xi: areg tfp1000 lagtariff  age age2 i.yr if  (use_CD>=.75 | use_CND>=.75)  & use_B!=., absorb(companyname) cluster(companyname);
	estimates store c_nonBCI; 
  xtabond tfp1000 lagtariff yeardum*  age age2 if  (use_CD>=.75 | use_CND>=.75)  & use_B!=., robust lag(2);
 	estimates store c_nonBCI2;  

xi: areg tfp1000 lagtariff  age age2 i.yr if  ( trade_E>=.75 & trade_E!=.), absorb(companyname) cluster(companyname);
	estimates store c_export; 
 xtabond tfp1000 lagtariff yeardum*  age age2 if  (trade_E>=.75 & trade_E!=.), robust lag(2);
 	estimates store c_export2; 
 
xi: areg tfp1000 lagtariff  age age2 i.yr if  (trade_IC>=.75 | trade_NCL>=.75) & trade_IC!=., absorb(companyname) cluster(companyname);
	estimates store c_nonexp; 
  xtabond tfp1000 lagtariff yeardum*  age age2 if  (trade_IC>=.75 | trade_NCL>=.75) & trade_IC!=., robust lag(2);
 	estimates store c_nonexp2; 

xi: areg tfp1000 lagtariff  age age2 i.yr if (license87>=.9 & license87!=.), absorb(companyname) cluster(companyname);
	estimates store c_reg; 
 xtabond tfp1000 lagtariff yeardum*  age age2 if ( license87>=.9 & license87!=.), robust lag(2);
 	estimates store c_reg2; 
 
xi: areg tfp1000 lagtariff  age age2 i.yr if ( license87<.9 & license87!=.), absorb(companyname) cluster(companyname);
	estimates store c_unreg; 
  xtabond tfp1000 lagtariff yeardum*  age age2 if ( license87<.9 & license87!=.), robust lag(2);
 	estimates store c_unreg2; 

 estout c_BCI c_BCI2 c_nonBCI c_nonBCI2 c_reg c_reg2  c_unreg c_unreg2 c_export c_export2 c_nonexp c_nonexp2  
 	using tables_restat.txt, append preh(" " "Table 6. Trade Liberalization and Industry Characteristics, Panel A")
 		keep(lagtariff) cells( b(star fmt(%-9.3f)) 
 		se(fmt(%-9.3f) par( [ ] )) blank) stats ( N , fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
 	cap estimates drop _all ;

*** Panel B ;

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (use_B>=.75 | use_I>=.75 | use_C>=.75) & use_B!=., absorb(companyname) cluster(companyname);
	estimates store c_BCI; 
 xtabond tfp1000 lagtariff laginputariff yeardum*  age age2 if (use_B>=.75 | use_I>=.75 | use_C>=.75)  & use_B!=., robust lag(2);
 	estimates store c_BCI2; 

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if  (use_CD>=.75 | use_CND>=.75)  & use_B!=., absorb(companyname) cluster(companyname);
	estimates store c_nonBCI; 
  xtabond tfp1000 lagtariff laginputariff yeardum*  age age2 if  (use_CD>=.75 | use_CND>=.75)  & use_B!=., robust lag(2);
 	estimates store c_nonBCI2;  

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if  ( trade_E>=.75 & trade_E!=.), absorb(companyname) cluster(companyname);
	estimates store c_export; 
 xtabond tfp1000 lagtariff laginputariff yeardum*  age age2 if  (trade_E>=.75 & trade_E!=.), robust lag(2);
 	estimates store c_export2; 
 
xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if  (trade_IC>=.75 | trade_NCL>=.75) & trade_IC!=., absorb(companyname) cluster(companyname);
	estimates store c_nonexp; 
  xtabond tfp1000 lagtariff laginputariff yeardum*  age age2 if  (trade_IC>=.75 | trade_NCL>=.75) & trade_IC!=., robust lag(2);
 	estimates store c_nonexp2; 

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (license87>=.9 & license87!=.), absorb(companyname) cluster(companyname);
	estimates store c_reg; 
 xtabond tfp1000 lagtariff laginputariff yeardum*  age age2 if ( license87>=.9 & license87!=.), robust lag(2);
 	estimates store c_reg2; 
 
xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if ( license87<.9 & license87!=.), absorb(companyname) cluster(companyname);
	estimates store c_unreg; 
  xtabond tfp1000 lagtariff laginputariff yeardum*  age age2 if ( license87<.9 & license87!=.), robust lag(2);
 	estimates store c_unreg2; 

 estout c_BCI c_BCI2 c_nonBCI c_nonBCI2 c_reg c_reg2  c_unreg c_unreg2 c_export c_export2 c_nonexp c_nonexp2  
 	using tables_restat.txt, append preh(" " "Table 6. Trade Liberalization and Industry Characteristics, Panel B")
 		keep(lagtariff laginputariff ) cells( b(star fmt(%-9.3f)) 
 		se(fmt(%-9.3f) par( [ ] )) blank) stats ( N , fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
 	cap estimates drop _all;

 	};
 	
***************************************************************;
* TABLE 7 - FIRM CHARACTERISTICS ;
***************************************************************;
if `table7' {;

use prod_dataregression, replace;
keep if yr<1997;
drop yeardum9-yeardum14 ;

tsset id yr;

*** Panel A ;


xi: areg tfp1000 lagtariff age age2 i.yr if type!=4, absorb(companyname) cluster(companyname);
	estimates store c_pub; 
 xtabond tfp1000 lagtariff age age2 yeardum* if type!=4, robust lag(2);
 	estimates store c_pub2; 
	
xi: areg tfp1000 lagtariff age age2 i.yr if (type==4), absorb(companyname) cluster(companyname);
	estimates store c_for; 
 xtabond tfp1000 lagtariff age age2 yeardum*  if (type==4), robust lag(2);
 	estimates store c_for2; 

xi: areg tfp1000 lagtariff age age2 i.yr if  (size==1), absorb(companyname) cluster(companyname);
	estimates store c_large; 
  xtabond tfp1000 lagtariff age age2 yeardum*  if  (size==1), robust lag(2);
 	estimates store c_large2; 

xi: areg tfp1000 lagtariff age age2 i.yr if (size==2), absorb(companyname) cluster(companyname);
	estimates store c_medium; 
  xtabond tfp1000 lagtariff age age2 yeardum*  if  (size==2), robust lag(2);
 	estimates store c_medium2; 

xi: areg tfp1000 lagtariff age age2 i.yr if (size==3), absorb(companyname) cluster(companyname);
	estimates store c_small; 
 xtabond tfp1000 lagtariff age age2 yeardum*  if  (size==3), robust lag(2);
 	estimates store c_small2; 

 estout  c_pub c_pub2  c_for c_for2  c_large c_large2 c_medium c_medium2 c_small c_small2    
 	using tables_restat.txt, append preh(" " "Table 7: Trade Liberalization and Firm Characteristics, Panel A")
 		keep(lagtariff ) cells( b(star fmt(%-9.3f)) 
 		se(fmt(%-9.3f) par( [ ] )) blank) stats ( N , fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
 	cap estimates drop _all ;

*** Panel B ;

 xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if type!=4, absorb(companyname) cluster(companyname);
 	estimates store c_pub; 
  xtabond tfp1000 lagtariff laginputariff age age2 yeardum* if type!=4, robust lag(2);
  	estimates store c_pub2; 
 	
 xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (type==4), absorb(companyname) cluster(companyname);
 	estimates store c_for; 
  xtabond tfp1000 lagtariff laginputariff age age2 yeardum*  if (type==4), robust lag(2);
  	estimates store c_for2; 
 
 xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if  (size==1), absorb(companyname) cluster(companyname);
 	estimates store c_large; 
   xtabond tfp1000 lagtariff laginputariff age age2 yeardum*  if  (size==1), robust lag(2);
  	estimates store c_large2; 
 
 xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (size==2), absorb(companyname) cluster(companyname);
 	estimates store c_medium; 
   xtabond tfp1000 lagtariff laginputariff age age2 yeardum*  if  (size==2), robust lag(2);
  	estimates store c_medium2; 
 
 xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (size==3), absorb(companyname) cluster(companyname);
 	estimates store c_small; 
  xtabond tfp1000 lagtariff laginputariff age age2 yeardum*  if  (size==3), robust lag(2);
  	estimates store c_small2; 

 estout c_pub c_pub2  c_for c_for2  c_large c_large2 c_medium c_medium2 c_small c_small2   
 	using tables_restat.txt, append preh(" " "Table 7: Trade Liberalization and Firm Characteristics, Panel B")
 		keep(lagtariff laginputariff) cells( b(star fmt(%-9.3f)) 
 		se(fmt(%-9.3f) par( [ ] )) blank) stats ( N , fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
 	cap estimates drop _all;
 	};
 
***************************************************************;
* TABLE 8 - ENVIRONMENT CHARACTERISTICS ;
***************************************************************;

if `table8' {;

use prod_dataregression, replace;
keep if yr<1997;
drop yeardum9-yeardum14 ;

tsset id yr;

*** Panel A ;

xi: areg tfp1000 lagtariff age age2 i.yr if state_sea==1, absorb(companyname) cluster(companyname);
	estimates store c_coastal; 
 xtabond tfp1000 lagtariff  yeardum* age age2 if state_sea==1, lag(2) robust;
 	estimates store c_coastal2; 

xi: areg tfp1000 lagtariff age age2 i.yr if (state_sea==0), absorb(companyname) cluster(companyname);
	estimates store c_nocoast; 
 xtabond tfp1000 lagtariff  yeardum* age age2 if ( state_sea==0), lag(2)  robust;
 	estimates store c_nocoast2; 

xi: areg tfp1000 lagtariff age age2 i.yr if (state_empl==1), absorb(companyname) cluster(companyname);
	estimates store c_flexlaw; 
 xtabond tfp1000 lagtariff  yeardum* age age2 if (state_empl==1),lag(2)  robust;
 	estimates store c_flexlaw2; 

xi: areg tfp1000 lagtariff age age2 i.yr if (state_neutr==1 | state_wrkr==1), absorb(companyname) cluster(companyname);
	estimates store c_infllaw; 
 xtabond tfp1000 lagtariff  yeardum* age age2 if (state_neutr==1 | state_wrkr==1), lag(2) robust;
 	estimates store c_infllaw2; 

xi: areg tfp1000 lagtariff age age2 i.yr if (findevhigh==1), absorb(companyname) cluster(companyname);
	estimates store c_highfin; 
 xtabond tfp1000 lagtariff  yeardum* age age2 if (findevhigh==1), lag(2) robust;
 	estimates store c_highfin2; 

xi: areg tfp1000 lagtariff age age2 i.yr if (findevlow==1), absorb(companyname) cluster(companyname);
	estimates store c_lowfin; 
 xtabond tfp1000 lagtariff  yeardum* age age2 if (findevlow==1), lag(2) robust;
 	estimates store c_lowfin2; 
 
 estout  c_coastal c_coastal2 c_nocoast c_nocoast2 c_flexlaw c_flexlaw2 c_infllaw c_infllaw2 c_highfin c_highfin2 c_lowfin c_lowfin2
 	using tables_restat.txt, append preh(" " "Table 8: Trade Liberalization and Environment Characteristics, Panel A")
 		keep(lagtariff ) cells( b(star fmt(%-9.3f)) 
 		se(fmt(%-9.3f) par( [ ] )) blank) stats ( N , fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
 	cap estimates drop _all ;

*** Panel B ;

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if state_sea==1, absorb(companyname) cluster(companyname);
	estimates store c_coastal; 
 xtabond tfp1000 lagtariff laginputariff yeardum* age age2 if state_sea==1, lag(2) robust;
 	estimates store c_coastal2; 

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (state_sea==0), absorb(companyname) cluster(companyname);
	estimates store c_nocoast; 
 xtabond tfp1000 lagtariff laginputariff yeardum* age age2 if ( state_sea==0), lag(2)  robust;
 	estimates store c_nocoast2; 

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (state_empl==1), absorb(companyname) cluster(companyname);
	estimates store c_flexlaw; 
 xtabond tfp1000 lagtariff laginputariff yeardum* age age2 if (state_empl==1),lag(2)  robust;
 	estimates store c_flexlaw2; 

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (state_neutr==1 | state_wrkr==1), absorb(companyname) cluster(companyname);
	estimates store c_infllaw; 
 xtabond tfp1000 lagtariff laginputariff yeardum* age age2 if (state_neutr==1 | state_wrkr==1), lag(2) robust;
 	estimates store c_infllaw2; 

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (findevhigh==1), absorb(companyname) cluster(companyname);
	estimates store c_highfin; 
 xtabond tfp1000 lagtariff laginputariff yeardum* age age2 if (findevhigh==1), lag(2) robust;
 	estimates store c_highfin2; 

xi: areg tfp1000 lagtariff laginputariff age age2 i.yr if (findevlow==1), absorb(companyname) cluster(companyname);
	estimates store c_lowfin; 
 xtabond tfp1000 lagtariff laginputariff yeardum* age age2 if (findevlow==1), lag(2) robust;
 	estimates store c_lowfin2; 

 estout  c_coastal c_coastal2 c_nocoast c_nocoast2 c_flexlaw c_flexlaw2 c_infllaw c_infllaw2 c_highfin c_highfin2 c_lowfin c_lowfin2
 	using tables_restat.txt, append preh(" " "Table 8: Trade Liberalization and Environment Characteristics, Panel B")
 		keep(lagtariff laginputariff ) cells( b(star fmt(%-9.3f)) 
 		se(fmt(%-9.3f) par( [ ] )) blank) stats (N , fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
 	cap estimates drop _all;
 	};

***************************************************************;
* TABLE 9 - OTHER REFORMS CHARACTERISTICS ;
***************************************************************;

if `table9' {;

use prod_dataregression, replace;
keep if yr<1997;
drop yeardum9-yeardum14 ;
tsset id yr;

xi: areg tfp1000 lagtariff lagfdi age age2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_1; 

xtabond tfp1000 lagtariff lagfdi age age2  yeardum* , robust lag(2);
	estimates store var_2; 


xi: areg tfp1000 lagtariff laglicense age age2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_3; 

xtabond tfp1000 lagtariff laglicense age age2  yeardum* , robust lag(2);
	estimates store var_4; 


xi: areg tfp1000 lagtariff lagfdi laglicense age age2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_5; 

xtabond tfp1000 lagtariff lagfdi laglicense age age2  yeardum* , robust lag(2);
	estimates store var_6; 


xi: areg tfp1000 lagtariff lagfdi laglicense lagtarifflagfdi lagtarifflaglicense age age2 i.yr , absorb(companyname) cluster(companyname);
	estimates store var_7; 

xtabond tfp1000 lagtariff lagfdi laglicense lagtarifflagfdi lagtarifflaglicense age age2  yeardum* , robust lag(2);
	estimates store var_8; 


estout var_1 var_2 var_3  var_4 var_5 var_6 var_7 var_8
	using tables_restat.txt, append preh(" " "Table 9:  Trade Liberalization Versus Other Reforms")
		keep(lagtariff lagfdi laglicense lagtarifflagfdi lagtarifflaglicense) cells( b(star fmt(%-9.3f)) 
		se(fmt(%-9.3f) par( [ ] )) blank) stats ( N , fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
	cap estimates drop _all;

};


***************************************************************;
* TABLE A3 - ROBUSTNESS ;
***************************************************************;
if `tableA3' {;

use prod_dataregression, replace;
keep if yr<1997;
drop yeardum9-yeardum14 ;
tsset id yr;

*** Panel A;

xi: areg tfp1 lagtariff  $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var_1; 

xi: areg tfp1 lagtariff i.yr  age age2, absorb(companyname) cluster(companyname);
	estimates store var_2; 

xtabond tfp1 lagtariff yeardum*  age age2 , robust;
	estimates store var_3; 

xtabond tfp1 lagtariff yeardum* age age2 , lag(2) robust;
	estimates store var_4; 

xi: areg tfp_share lagtariff  $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var2_1; 

xi: areg tfp_share lagtariff i.yr  age age2, absorb(companyname) cluster(companyname);
	estimates store var2_2; 

xtabond tfp_share lagtariff yeardum*  age age2 , robust;
	estimates store var2_3; 

xtabond tfp_share lagtariff yeardum* age age2 , lag(2) robust;
	estimates store var2_4; 

xi: areg laborprod lagtariff  $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var3_1; 

xi: areg laborprod lagtariff i.yr  age age2, absorb(companyname) cluster(companyname);
	estimates store var3_2; 

xtabond laborprod lagtariff yeardum*  age age2 , robust;
	estimates store var3_3; 

xtabond laborprod lagtariff yeardum* age age2 , lag(2) robust;
	estimates store var3_4; 

xi: areg logavedaysfinished lagtariff  $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var4_1; 

xi: areg logavedaysfinished lagtariff i.yr  age age2, absorb(companyname) cluster(companyname);
	estimates store var4_2; 

xtabond logavedaysfinished lagtariff yeardum*  age age2 , robust;
	estimates store var4_3; 

xtabond logavedaysfinished lagtariff yeardum* age age2 , lag(2) robust;
	estimates store var4_4; 


 estout var_1 var_2  var_3 var_4  var2_1 var2_2  var2_3 var2_4 var3_1 var3_2  var3_3 var3_4 var4_1 var4_2  var4_3 var4_4
 	using tables_restat.txt, append preh(" " "Table A3: Trade Liberalization and Total Factor Productivity: Alternative Productivity Measures, Panel A")
 		keep(lagtariff) cells( b(star fmt(%-9.3f)) 
 		se(fmt(%-9.3f) par( [ ] )) blank) stats (N, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
 	cap estimates drop _all;
 
 *** Panel B;
 
 xi: areg tfp1 lagerp  $cov2 i.yr , absorb(industrycode) cluster(companyname);
 	estimates store var_1; 
 
 xi: areg tfp1 lagerp i.yr  age age2, absorb(companyname) cluster(companyname);
 	estimates store var_2; 
 
 xtabond tfp1 lagerp yeardum*  age age2 , robust;
 	estimates store var_3; 
 
 xtabond tfp1 lagerp yeardum* age age2 , lag(2) robust;
 	estimates store var_4; 
 
 xi: areg tfp_share lagerp  $cov2 i.yr , absorb(industrycode) cluster(companyname);
 	estimates store var2_1; 
 
 xi: areg tfp_share lagerp i.yr  age age2, absorb(companyname) cluster(companyname);
 	estimates store var2_2; 
 
 xtabond tfp_share lagerp yeardum*  age age2 , robust;
 	estimates store var2_3; 
 
 xtabond tfp_share lagerp yeardum* age age2 , lag(2) robust;
 	estimates store var2_4; 
 
 xi: areg laborprod lagerp  $cov2 i.yr , absorb(industrycode) cluster(companyname);
 	estimates store var3_1; 
 
 xi: areg laborprod lagerp i.yr  age age2, absorb(companyname) cluster(companyname);
 	estimates store var3_2; 
 
 xtabond laborprod lagerp yeardum*  age age2 , robust;
 	estimates store var3_3; 
 
 xtabond laborprod lagerp yeardum* age age2 , lag(2) robust;
 	estimates store var3_4; 
 
 xi: areg logavedaysfinished lagerp  $cov2 i.yr , absorb(industrycode) cluster(companyname);
 	estimates store var4_1; 
 
 xi: areg logavedaysfinished lagerp i.yr  age age2, absorb(companyname) cluster(companyname);
 	estimates store var4_2; 
 
 xtabond logavedaysfinished lagerp yeardum*  age age2 , robust;
 	estimates store var4_3; 
 
 xtabond logavedaysfinished lagerp yeardum* age age2 , lag(2) robust;
 	estimates store var4_4; 
 
 
  estout var_1 var_2  var_3 var_4  var2_1 var2_2  var2_3 var2_4 var3_1 var3_2  var3_3 var3_4 var4_1 var4_2  var4_3 var4_4
  	using tables_restat.txt, append preh(" " "Table A3: Trade Liberalization and Total Factor Productivity: Alternative Productivity Measures, Panel A")
  		keep(lagerp) cells( b(star fmt(%-9.3f)) 
  		se(fmt(%-9.3f) par( [ ] )) blank) stats (N, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
  	cap estimates drop _all;
 
*** Panel C;

xi: areg tfp1 lagtariff  laginputariff $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var_1; 

xi: areg tfp1 lagtariff laginputariff i.yr  age age2, absorb(companyname) cluster(companyname);
	estimates store var_2; 

xtabond tfp1 lagtariff laginputariff yeardum*  age age2 , robust;
	estimates store var_3; 

xtabond tfp1 lagtariff laginputariff yeardum* age age2 , lag(2) robust;
	estimates store var_4; 

xi: areg tfp_share lagtariff laginputariff $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var2_1; 

xi: areg tfp_share lagtariff laginputariff i.yr  age age2, absorb(companyname) cluster(companyname);
	estimates store var2_2; 

xtabond tfp_share lagtariff laginputariff yeardum*  age age2 , robust;
	estimates store var2_3; 

xtabond tfp_share lagtariff laginputariff yeardum* age age2 , lag(2) robust;
	estimates store var2_4; 

xi: areg laborprod lagtariff laginputariff $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var3_1; 

xi: areg laborprod lagtariff laginputariff i.yr  age age2, absorb(companyname) cluster(companyname);
	estimates store var3_2; 

xtabond laborprod lagtariff laginputariff yeardum*  age age2 , robust;
	estimates store var3_3; 

xtabond laborprod lagtariff laginputariff yeardum* age age2 , lag(2) robust;
	estimates store var3_4; 

xi: areg logavedaysfinished lagtariff laginputariff $cov2 i.yr , absorb(industrycode) cluster(companyname);
	estimates store var4_1; 

xi: areg logavedaysfinished lagtariff laginputariff i.yr  age age2, absorb(companyname) cluster(companyname);
	estimates store var4_2; 

xtabond logavedaysfinished lagtariff laginputariff yeardum*  age age2 , robust;
	estimates store var4_3; 

xtabond logavedaysfinished lagtariff laginputariff yeardum* age age2 , lag(2) robust;
	estimates store var4_4; 


 estout var_1 var_2  var_3 var_4  var2_1 var2_2  var2_3 var2_4 var3_1 var3_2  var3_3 var3_4 var4_1 var4_2  var4_3 var4_4
 	using tables_restat.txt, append preh(" " "Table A3: Trade Liberalization and Total Factor Productivity: Alternative Productivity Measures, Panel A")
 		keep(lagtariff laginputariff) cells( b(star fmt(%-9.3f)) 
 		se(fmt(%-9.3f) par( [ ] )) blank) stats (N, fmt(%9.2f %9.0g)) style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);
 	cap estimates drop _all;
 };

the end



