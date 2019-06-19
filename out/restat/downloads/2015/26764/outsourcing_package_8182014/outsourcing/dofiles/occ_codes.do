#delimit;
clear all;
set mem 5g;
set more off;
cap log close;

global path ~/research/services;
global path2 $masterpath;


*** Step 1: recreate occ80 ***;
use $path/rawfiles/ipums_cps.dta, clear;
keep if year>=1983 &  year<=1991;
bysort occ: keep if _n==1;
keep year occ occ1990;
gen occ80=occ;
sort occ year;
save $path/datafiles/occ80.dta, replace;

*** Step 2: recreate occ90 ***;
use $path/rawfiles/ipums_cps.dta, clear;
keep if year>=1992 & year<=2002;
bysort occ: keep if _n==1;
keep year occ occ1990;
gen occ90=occ;
sort occ year;
save $path/datafiles/occ90.dta, replace;

*** Step 3: Append data sets ****;
use $path/datafiles/occ90.dta, clear;
append using $path/datafiles/occ80.dta;
sort occ80 occ90;
save $path/datafiles/occ_full.dta, replace;


**** Step 4: confirm exercise ***;
use $path2/datafiles/offshore_exposure.dta, clear;
keep if year>=1983 &  year<=1991;
bysort occ80: keep if _n==1;
keep year occ80  ;
save $path2/datafiles/occ80_test.dta, replace;

use $path2/datafiles/offshore_exposure.dta, clear;
keep if year>=1992 & year<=2002;
bysort occ90: keep if _n==1;
keep year occ90;
sort occ year;
save $path2/datafiles/occ90_test.dta, replace;

use $path2/datafiles/occ90_test.dta, clear;
append using $path2/datafiles/occ80_test.dta;
sort occ80 occ90;
save $path2/datafiles/occ_full_test.dta, replace;

use $path2/datafiles/occ_full_test.dta, clear;
merge occ80 occ90 using $path/datafiles/occ_full.dta;
tab _merge;
keep if _merge==3 /* perfect merge */;
drop occ;
drop _merge;

**** Step 5: Bring in occ1990dd and other variables ****;
use $path/datafiles/occ_full.dta, clear;
do $path/dofiles/occ1990dd.do;
sort occ1990dd;
*** Bring in Autor vraibles ****;
merge occ1990dd using $path/occ/datafiles/occ1990dd_complete.dta;
tab _merge;
keep if _merge==3;
drop _merge;
gen manager=.;
replace manager=1 if occ1990_1dig>=1 & occ1990_1dig<=3;
replace manager=0 if occ1990_1dig>=4 & occ1990_1dig<=17;
gen production=.;
replace production=1 if occ1990_1dig>=12 & occ1990_1dig<=17;
replace production=0 if occ1990_1dig>=1 & occ1990_1dig<=11;
sort occ80;
merge occ80 using $path2/autor/occ80.dta;
tab _merge;
drop _merge;
rename occ8090 occ8090_1;
sort occ90;
merge occ90 using $path2/autor/occ90.dta;
tab _merge;
drop _merge;
rename occ8090 occ8090_2;
gen occ8090=.;
replace occ8090=occ8090_1 if occ80~=.;
replace occ8090=occ8090_2 if occ90~=.;
keep occ1990* task* manager production occ8090 year;

save $path/datafiles/occ1990dd_full.dta, replace;

*** Step 6 : Create different data sets to merge in ***;
use $path/datafiles/occ1990dd_full.dta, clear;
rename occ8090 occ80901;
keep if year >=1983 & year<=1991;
drop year;
sort occ80901;
save $path/datafiles/occ80901_t1.dta, replace;

use $path/datafiles/occ1990dd_full.dta, clear;
rename occ8090 occ80901;
keep if year >=1992 & year<=2002;
drop year;
sort occ80901;
save $path/datafiles/occ80901_t2.dta, replace;

use $path/datafiles/occ1990dd_full.dta, clear;
rename occ8090 occ80902;
keep if year >=1983 & year<=1991;
drop year;
sort occ80902;
save $path/datafiles/occ80902_t1.dta, replace;

use $path/datafiles/occ1990dd_full.dta, clear;
rename occ8090 occ80902;
keep if year >=1992 & year<=2002;
drop year;
sort occ80902;
save $path/datafiles/occ80902_t2.dta, replace;

**** Step 7: Merge into match_correct.dta ***;
use $path2/datafiles/match_correct.dta, clear; 
keep if year1 >=1983 & year1<=1991;
drop if year1==.;
sort occ80901 ;
merge occ80901  using $path/datafiles/occ80901_t1.dta;
tab _merge;
keep if _merge==3;
drop _merge;
display _N;
save $path2/datafiles/match_correct_01_t1.dta, replace;

use $path2/datafiles/match_correct.dta, clear;
keep if year1 >=1992 & year1<=2002;
sort occ80901 ;
merge occ80901  using $path/datafiles/occ80901_t2.dta;
tab _merge;
drop _merge;
display _N;
save $path2/datafiles/match_correct_01_t2.dta, replace;
append using $path2/datafiles/match_correct_01_t1.dta;
display _N;
for var occ1990* task* manager production: rename X X_t1;
sort occ80901;
save $path2/datafiles/match_correct_occ80901_all.dta, replace;

use $path2/datafiles/match_correct.dta, clear;
keep if year2 >=1983 & year2<=1991;
sort occ80902 ;
drop if year2==.;
merge occ80902  using $path/datafiles/occ80902_t1.dta;
tab _merge;
keep if _merge==3;
drop _merge;
display _N;
save $path2/datafiles/match_correct_02_t1.dta, replace;

use $path2/datafiles/match_correct.dta, clear;
keep if year2 >=1992 & year2<=2002;
sort occ80902 ;
merge occ80902  using $path/datafiles/occ80902_t2.dta;
tab _merge;
drop _merge;
display _N;
save $path2/datafiles/match_correct_02_t2.dta, replace;
append using $path2/datafiles/match_correct_02_t1.dta;
display _N;
for var occ1990* task* manager production: rename X X_t2;
sort occ80901;
save $path2/datafiles/match_correct_occ80902_all.dta, replace;

use $path2/datafiles/match_correct_occ80901_all.dta, clear;

merge occ80901 using $path2/datafiles/match_correct_occ80902_all.dta;
tab _merge;
keep if _merge==3;
drop _merge;
save $path2/datafiles/match_correct_mf.dta, replace;



