global x "$masterpath/datafiles/"
global a "$masterpath/dofiles/"
global b "$masterpath/autor/"
global c "$masterpath/bea/"
global d "$masterpath/prices/"

clear
set mem 1g

#delimit;

use ${x}micro_man7090, clear;
sort man7090 year;
merge man7090 year using ${d}man7090_sic3;
tab _merge;
drop if _merge==1|_merge==2;
drop _merge;
sort occ8090 year;
merge occ8090 year using ${x}premium_occ8090_mfg; /*changed premium_occ8090 to premium_occ8090_mfg 5/27/10*/
tab _merge;
drop if _merge==1;
drop _merge;

sort man7090 year;
merge man7090 year using ${x}cew_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

sort man7090 year;
merge man7090 year using ${x}trade_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

***********************************************************************;
* Recode man7090 to eliminate categories not available in the BEA data ;
***********************************************************************;

gen man7090_orig=man7090;
do ${a}man7090_bea.do;
do ${a}labels_man7090_orig.do;

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

save ${x}temp_premium_prices3dig.dta, replace;

*******************************************************************;
* Create two datasets, at man7090 x year and occ8090 x year level *;
*******************************************************************;
* man7090 x year level dataset *;
********************************;
use ${x}temp_premium_prices3dig.dta, clear;
collapse age female state union ehf finger dcp sts math routine higheduc educ exper lwage nonwhite ihwt sic3dig expfin impfin lwage10 lwage25 lwage50 lwage75 lwage90 lwageres lwageres10 lwageres25 lwageres50 lwageres75 lwageres90 lwageres_unskill lwageres_unskill10 lwageres_unskill25 lwageres_unskill50 lwageres_unskill75 lwageres_unskill90 lwageres_skill lwageres_skill10 lwageres_skill25 lwageres_skill50 lwageres_skill75 lwageres_skill90 emp_cps wages_cps respondents penmod79 expmod79 vsh79 psh79 piinv79 tfp579 rpiship79 lowincemp highincemp, by(man7090 year);
save ${x}premium_prices3dig_man7090.dta, replace;

***********************************;
* occupation x year level dataset *;
***********************************;
use ${x}temp_premium_prices3dig.dta, clear;
collapse age female state union ehf finger dcp sts math routine higheduc educ exper lwage nonwhite ihwt sic3dig expfin impfin lwage10 lwage25 lwage50 lwage75 lwage90 lwageres lwageres10 lwageres25 lwageres50 lwageres75 lwageres90 lwageres_unskill lwageres_unskill10 lwageres_unskill25 lwageres_unskill50 lwageres_unskill75 lwageres_unskill90 lwageres_skill lwageres_skill10 lwageres_skill25 lwageres_skill50 lwageres_skill75 lwageres_skill90 emp_cps wages_cps respondents penmod79 expmod79 vsh79 psh79 piinv79 tfp579 rpiship79 lowincemp highincemp, by(occ8090 year);
save ${x}premium_prices3dig_occ8090.dta, replace;

*erase ${x}temp_premium_prices3dig.dta;
*erase ${x}man7090_sic3.dta;

exit;
