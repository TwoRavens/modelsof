#delimit;
clear;
set more off;
set matsize 800;

global temp /Sastemp;
global path ~/research;
set mem 5000m;

capture log close;

/*================================================
 Program: premium_occ8090_all.do
 Author:  Shannon Phillips, from Avi Ebenstein's premium_man7090.do
 Created: December 2009
 Purpose: Prepare wage data from CPS MORG respondents
          and store individual-level data in wage_data.dta.
          Collapse by industry and year into premium_occ8090_all.dta.

=================================================*/

use $masterpath/cpsfiles/morg_data, clear;
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

***********************************************;
* Year, occupation, age, education fixed-effects ;
***********************************************;
/* xi i.year i.state i.educ i.man7090 i.agedum */;

************************;
* Lemieux specification ;
************************;
/*
reg lwage _Iyear* _Iagedum* _Ieduc* sex nonwhite educ1 educ2 educ3 educ4 [w=ihwt];
predict yhat;
gen myresid=lwage-yhat;
label var myresid "Actual Log Hourly Wage - Predicted (Lemieux)";
*/
  
************************;
* Mincer specification  ;
************************;

***************************************************;
* Decide whether to add experience, location, 	  *;
* and all the other things we usually control for *;
***************************************************;
* reg lwage age age2 _Ieduc* female nonwhite _Iyear* [w=ihwt];
***************************************************;
* ==> Added location, made linear in educ level	  *; 
***************************************************;
*reg lwage age age2 educ female nonwhite _Iyear* _Istate* [w=ihwt];
*predict yhat;
*gen lwageres=lwage-yhat;

****************************;
* New Mincer specification  ;
****************************;
egen expergp=cut(exper), at(0(3)45 100);
xi i.educ*i.expergp i.year i.state;

reg lwage _Ieduc* _Iexper* _IeduXexp* female nonwhite _Iyear* _Istate* [w=ihwt];
predict yhat;
gen lwageres=lwage-yhat;

gen yhat_year=.;
local X=1982;
while `X'<=2002 {;
  reg lwage _Ieduc* _Iexper* _IeduXexp* female nonwhite _Istate* if year==`X' [w=ihwt];
  predict yhat`X' if year==`X';
  replace yhat_year=yhat`X' if year==`X';
local X=`X'+1;
};
gen lwageres_year=lwage-yhat_year;

*************************************************************************;
* Get two wage residuals, one for skilled and one for unskilled workers *;
*************************************************************************;
* Unskilled workers: Less than High School or High School degree *;
******************************************************************;
*reg lwage age age2 educ female nonwhite _Iyear* _Istate* if educ==1 | educ==2 [w=ihwt];

reg lwage _Ieduc* _Iexper* _IeduXexp* female nonwhite _Iyear* _Istate* if educ==1 | educ==2 [w=ihwt];
predict yhat_unskill;
gen lwageres_unskill=lwage-yhat_unskill;

gen yhat_unsk_yr=.;
local X=1982;
while `X'<=2002 {;
  reg lwage _Ieduc* _Iexper* _IeduXexp* female nonwhite _Istate* if year==`X' & (educ==1 | educ==2) [w=ihwt];
  predict yhat_unsk`X' if year==`X';
  replace yhat_unsk_yr=yhat_unsk`X' if year==`X';
local X=`X'+1;
};
gen lwageres_unsk_yr=lwage-yhat_unsk_yr;

**************************************************************;
* Skilled workers: Some College, College, or Advanced degree *;
**************************************************************;
*reg lwage age age2 educ female nonwhite _Iyear* _Istate* if educ==3 | educ==4 | educ==5 [w=ihwt];

reg lwage _Ieduc* _Iexper* _IeduXexp* female nonwhite _Iyear* _Istate* if educ==3 | educ==4 | educ==5 [w=ihwt];
predict yhat_skill;
gen lwageres_skill=lwage-yhat_skill;

gen yhat_sk_yr=.;
local X=1982;
while `X'<=2002 {;
  reg lwage _Ieduc* _Iexper* _IeduXexp* female nonwhite _Istate* if year==`X' & (educ==3 | educ==4 | educ==5) [w=ihwt];
  predict yhat_sk`X' if year==`X';
  replace yhat_sk_yr=yhat_sk`X' if year==`X';
local X=`X'+1;
};
gen lwageres_sk_yr=lwage-yhat_sk_yr;

drop _I*;

label var lwage "Log of Real Hourly Wage";
label var lwageres "Residual of Log of Real Hourly Wage";

label var ehf "Eye hand foot (nonroutine manual)";
label var finger "Finger dexterity (routine manual)";
label var dcp "Direction, Control, Planning (nonroutine interactive)";
label var sts "Set limits, Tolerances, or Standards (routine cognitive)";
label var math "General educational development, mathematics (nonroutine analytic)";

*****************;
* Save microdata ;
*****************;

save $masterpath/datafiles/prices/micro_occ8090_all, replace;

**************************************************;
* The MORG files are 12 times the true population ;
**************************************************;

bysort ind7090 year: egen emp=sum(orgwgt/12);
bysort ind7090 year: egen wages=sum(w_ln_ot*uhourse*52*orgwgt/12);

**************************;
* Collapse the micro data ;
**************************;
gen dummy=1;
collapse (mean) lwage (p10) lwage10=lwage (p25) lwage25=lwage (p50) lwage50=lwage (p75) lwage75=lwage (p90) lwage90=lwage
(mean) lwageres (p10) lwageres10=lwageres (p25) lwageres25=lwageres (p50) lwageres50=lwageres (p75) lwageres75=lwageres (p90) lwageres90=lwageres
(mean) lwageres_year (p10) lwageres10_year=lwageres_year (p25) lwageres25_year=lwageres_year (p50) lwageres50_year=lwageres_year (p75) lwageres75_year=lwageres_year (p90) lwageres90_year=lwageres_year
(mean) lwageres_unskill (p10) lwageres_unskill10=lwageres_unskill (p25) lwageres_unskill25=lwageres_unskill (p50) lwageres_unskill50=lwageres_unskill (p75) lwageres_unskill75=lwageres_unskill (p90) lwageres_unskill90=lwageres_unskill
(mean) lwageres_unsk_yr (p10) lwageres_unsk10_yr=lwageres_unsk_yr (p25) lwageres_unsk25_yr=lwageres_unsk_yr (p50) lwageres_unsk50_yr=lwageres_unsk_yr (p75) lwageres_unsk75_yr=lwageres_unsk_yr (p90) lwageres_unsk90_yr=lwageres_unsk_yr
(mean) lwageres_skill (p10) lwageres_skill10=lwageres_skill (p25) lwageres_skill25=lwageres_skill (p50) lwageres_skill50=lwageres_skill (p75) lwageres_skill75=lwageres_skill (p90) lwageres_skill90=lwageres_skill
(mean) lwageres_sk_yr (p10) lwageres_sk10_yr=lwageres_sk_yr (p25) lwageres_sk25_yr=lwageres_sk_yr (p50) lwageres_sk50_yr=lwageres_sk_yr (p75) lwageres_sk75_yr=lwageres_sk_yr (p90) lwageres_sk90_yr=lwageres_sk_yr
(mean) ehf (mean) finger (mean) dcp (mean) sts (mean) math (mean) emp_cps=emp (mean) wages_cps=wages (sum) respondents=dummy [w=ihwt],by(occ8090 year) fast;

label var lwage "CPS MORG mean Log Hourly Wage within occupation X year";
label var lwage10 "10th percentile of lwage within occupation X year";
label var lwage25 "25th percentile of lwage within occupation X year";
label var lwage50 "50th percentile of lwage within occupation X year";
label var lwage75 "75th percentile of lwage within occupation X year";
label var lwage90 "90th percentile of lwage within occupation X year";

label var lwageres "CPS MORG mean log hourly wage residual within occupation X year";
label var lwageres10 "10th percentile of lwageres within occupation X year";
label var lwageres25 "25th percentile of lwageres within occupation X year";
label var lwageres50 "50th percentile of lwageres within occupation X year";
label var lwageres75 "75th percentile of lwageres within occupation X year";
label var lwageres90 "90th percentile of lwageres within occupation X year";
label var lwageres_year "CPS MORG mean yearly wage residual within occupation X year";
label var lwageres10_year "10th percentile of lwageres_year within occupation X year";
label var lwageres25_year "25th percentile of lwageres_year within occupation X year";
label var lwageres50_year "50th percentile of lwageres_year within occupation X year";
label var lwageres75_year "75th percentile of lwageres_year within occupation X year";
label var lwageres90_year "90th percentile of lwageres_year within occupation X year";

label var lwageres_skill "CPS MORG mean log hourly skilled wage premium within occupation X year";
label var lwageres_skill10 "10th percentile of log skilled wage premium within occupation X year";
label var lwageres_skill25 "25th percentile of log skilled wage premium within occupation X year";
label var lwageres_skill50 "50th percentile of log skilled wage premium within occupation X year";
label var lwageres_skill75 "75th percentile of log skilled wage premium within occupation X year";
label var lwageres_skill90 "90th percentile of log skilled wage premium within occupation X year";
label var lwageres_sk_yr "CPS MORG mean yearly skilled wage residual within occupation X year";
label var lwageres_sk10_yr "10th percentile of lwageres_sk_yr within occupation X year";
label var lwageres_sk25_yr "25th percentile of lwageres_sk_yr within occupation X year";
label var lwageres_sk50_yr "50th percentile of lwageres_sk_yr within occupation X year";
label var lwageres_sk75_yr "75th percentile of lwageres_sk_yr within occupation X year";
label var lwageres_sk90_yr "90th percentile of lwageres_sk_yr within occupation X year";

label var lwageres_unskill "CPS MORG mean log hourly unskilled wage premium within occupation X year";
label var lwageres_unskill10 "10th percentile of log unskilled wage premium within occupation X year";
label var lwageres_unskill25 "25th percentile of log unskilled wage premium within occupation X year";
label var lwageres_unskill50 "50th percentile of log unskilled wage premium within occupation X year";
label var lwageres_unskill75 "75th percentile of log unskilled wage premium within occupation X year";
label var lwageres_unskill90 "90th percentile of log unskilled wage premium within occupation X year";
label var lwageres_unsk_yr "CPS MORG mean yearly unskilled wage residual within occupation X year";
label var lwageres_unsk10_yr "10th percentile of lwageres_unsk_yr within occupation X year";
label var lwageres_unsk25_yr "25th percentile of lwageres_unsk_yr within occupation X year";
label var lwageres_unsk50_yr "50th percentile of lwageres_unsk_yr within occupation X year";
label var lwageres_unsk75_yr "75th percentile of lwageres_unsk_yr within occupation X year";
label var lwageres_unsk90_yr "90th percentile of lwageres_unsk_yr within occupation X year";

label var ehf "Eye hand foot (nonroutine manual)";
label var finger "Finger dexterity (routine manual)";
label var dcp "Direction, Control, Planning (nonroutine interactive)";
label var sts "Set limits, Tolerances, or Standards (routine cognitive)";
label var math "General educational development, mathematics (nonroutine analytic)";
label var emp_cps "CPS MORG earnings weight employment";
label var wages_cps "CPS MORG total wages";
label var respondents "CPS MORG # of respondents";

save $masterpath/datafiles/prices/premium_occ8090_all, replace;

global x "$masterpath/datafiles/prices/";
global y "$masterpath/datafiles/";
global a "$masterpath/dofiles/";
global b "$masterpath/autor/";
global c "$masterpath/bea/";

use ${y}micro_ind7090, clear;
sort occ8090 year;
merge occ8090 year using ${x}premium_occ8090_all;
tab _merge;
drop if _merge==1;
drop _merge;

sort man7090 year;
merge man7090 year using ${y}cew_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

sort man7090 year;
merge man7090 year using ${y}trade_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

***********************************************************************;
* Recode man7090 to eliminate categories not available in the BEA data ;
***********************************************************************;

gen man7090_orig=man7090;
do ${a}man7090_bea.do;
do $masterpath/dofiles/labels_man7090_orig.do;

sort man7090 year;
merge man7090 year using ${c}emp_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

***************************;
* China & India employment ;
***************************;

sort man7090 year;
merge man7090 year using ${c}china_india_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

label var man7090 "Consistent manufacturing industry code (adapted from Census Industry Class), adjusted for BEA";
label var man7090_orig "Consistent manufacturing industry code (adapted from Census Industry Class), 68 categories";
label data "Merged outsourcing data from CPS/CEW/TRADE/BEA sources, 1979-2002";
sort man7090_orig year;

*************************************************************************;
* Restrict the sample to years and observations with offshoring measures ;
*************************************************************************;
drop if year<=1981;

gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);
gen higheduc=(educ==3 | educ==4 | educ==5) if educ~=.;
label variable higheduc "Some college, college or advanced degree";

save ${x}temp_premium.dta, replace;

***********************************;
* occupation x year level dataset *;
***********************************;
use ${x}temp_premium.dta, clear;
collapse age female state union ehf finger dcp sts math routine higheduc educ exper lwage nonwhite ihwt lwage10 lwage25 lwage50 lwage75 lwage90 lwageres lwageres10 lwageres25 lwageres50 lwageres75 lwageres90 lwageres_unskill lwageres_unskill10 lwageres_unskill25 lwageres_unskill50 lwageres_unskill75 lwageres_unskill90 lwageres_skill lwageres_skill10 lwageres_skill25 lwageres_skill50 lwageres_skill75 lwageres_skill90 lwageres_year lwageres10_year lwageres25_year lwageres50_year lwageres75_year lwageres90_year lwageres_unsk_yr lwageres_unsk10_yr lwageres_unsk25_yr lwageres_unsk50_yr lwageres_unsk75_yr lwageres_unsk90_yr lwageres_sk_yr lwageres_sk10_yr lwageres_sk25_yr lwageres_sk50_yr lwageres_sk75_yr lwageres_sk90_yr emp_cps wages_cps respondents penmod79 expmod79 vsh79 psh79 piinv79 tfp579 rpiship79 lowincemp highincemp, by(occ8090 year);
save ${x}premium_occ8090_all.dta, replace;

erase ${x}temp_premium.dta;
exit;
