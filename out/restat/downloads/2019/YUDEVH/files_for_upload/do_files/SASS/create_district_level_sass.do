#delimit;
clear all;
set more off;

/********************************************
This do file appends all of the district-level waves of the SASS
together to create the district-year level SASS data for the unions
and school finance reform project

********************************************/

*START LOG FILE;
capture log using "${log}create_district_level_sass.log", replace;

*CREATE DIRECTORY NAMES;
global log "C:\Users\Hyman\Desktop\unions_sfr\do_files\";
global input "C:\Users\Hyman\Desktop\SASS\";
global output "C:\Users\Hyman\Desktop\unions_sfr\data\";


*BRING IN 2011 WAVE;
use "${input}2011-12\District11", clear;
keep CCDIDLEA D0416 D0418 D0440 D0503 D0505 D0506 D0507 D0508 D0509 D0510 D0511 D0512
	D0513 D0514 D0515 D0516 D0517 D0518 D0519 D0520 D0521 D0522 DFNLWGT D0435 D0452;
	
*DROP ABOUT 50 DISTRICTS THAT HAVE "ST" and "CH" in the CCD ID, but try to figure out later what these are;
drop if strpos(CCDIDLEA,"ST")~=0 | strpos(CCDIDLEA,"CH")~=0;

*DESTRICT CCD ID;	
destring CCDIDLEA, replace;

*MAKE MISSINGS MISSING INSTEAD OF NEGATIVE NUMBERS;
foreach x of var * {; 
	replace `x' = . if `x'<0;
};

*RENAME VARIABLES; 
rename D0416 enr_tot;
rename D0418 enr_k12;
rename CCDIDLEA ncesid;
rename D0440 teach_fte;
rename D0435 length_year;
rename D0452 teachers_union;

rename D0503 has_sal_sched;
rename D0505 sal_ba_0exp;
rename D0506 sal_ba_10exp;
rename D0507 sal_ma_0exp;
rename D0508 sal_ma_10exp;
rename D0509 sal_ma_15exp;
rename D0510 sal_top_step;
rename D0511 sal_lowest;
rename D0512 sal_highest;
 
rename D0513 benft_medical;
rename D0514 benft_dental;
rename D0515 benft_life;
rename D0516 benft_defnd_retire;
rename D0517 benft_contrib_retire;
rename D0518 benft_empl_pay_retire;
rename D0519 benft_tuition;
rename D0520 benft_housing;
rename D0521 benft_meals;
rename D0522 benft_trnsprtn;
rename DFNLWGT dist_weight; 

/*NOTES ON LABELS
1-yes, 2-no
teachers union: 1-meet&confer, 2-collective bargaining, 3-Other, 4-None
*/

*CREATE NEW TEACHERS UNION CODING;
gen temp = 0 if teachers_union==4;
replace temp = 1 if teachers_union==1; 
replace temp = 2 if teachers_union==2 | teachers_union==3; 
drop teachers_union;
rename temp teach_union;

*RECODE ALL BENEFITS;
foreach x of var has_sal_sched benft* {;
	replace `x' = 0 if `x'==2;
};

*CREATE RETIREMENT VARIABLE;
gen benft_retire = 0 if benft_defnd_retire==0 & benft_contrib_retire==0;
replace benft_retire = 1 if benft_defnd_retire==1 | benft_contrib_retire==1;
drop benft_defnd_retire benft_contrib_retire benft_empl_pay_retire;

*SAVE CLEAN 2011 FILE;
gen year=2011;
quietly compress;
save "${input}2011-12\dist11_clean", replace;


*USE 2007 FILE;

use "${input}2007-08\District07", clear;

keep D0275 D0276 CCDIDLEA D0289 D0288 D0296 D0328 D0330 D0331 D0332 D0333 D0334 
	D0335 D0336 D0337 D0338 D0339 D0340 D0341 D0342 D0343 D0344 D0345 D0346 DFNLWGT; 
	
*DROP ABOUT 30 DISTRICTS THAT HAVE "SR" and "CH" in the CCD ID, but try to figure out later what these are;
drop if strpos(CCDIDLEA,"SR")~=0 | strpos(CCDIDLEA,"CH")~=0;

*DESTRICT CCD ID;	
destring CCDIDLEA, replace;

*MAKE MISSINGS MISSING INSTEAD OF NEGATIVE NUMBERS;
foreach x of var * {; 
	replace `x' = . if `x'<0;
};

*RENAME VARIABLES; 
rename D0275 enr_tot;
rename D0276 enr_k12;
rename CCDIDLEA ncesid;
rename D0289 teach_fte;
rename D0288 length_year;
rename D0296 teachers_union;

rename D0328 has_sal_sched;
rename D0330 sal_ba_0exp;
rename D0331 sal_ba_10exp;
rename D0332 sal_ma_0exp;
rename D0333 sal_ma_10exp;
rename D0334 sal_top_step;
rename D0335 sal_lowest;
rename D0336 sal_highest;
 
rename D0337 benft_medical;
rename D0338 benft_dental;
rename D0339 benft_life;
rename D0340 benft_retire;
rename D0341 benft_contrib_retire;
rename D0342 benft_empl_pay_retire;
rename D0343 benft_tuition;
rename D0344 benft_housing;
rename D0345 benft_meals;
rename D0346 benft_trnsprtn;
rename DFNLWGT dist_weight; 

*MAKE EMPLOYEE PAY RETIRE BINARY;
recode benft_empl_pay_retire (2 = 1) (3 = 2);

/*NOTES ON LABELS
1-yes, 2-no
teachers union: 1-meet&confer, 2-collective bargaining, 3-None
*/

*CREATE NEW TEACHERS UNION CODING;
gen temp = 0 if teachers_union==3;
replace temp = 1 if teachers_union==1; 
replace temp = 2 if teachers_union==2; 
drop teachers_union;
rename temp teach_union;

*RECODE ALL BENEFITS;
foreach x of var has_sal_sched benft* {;
	replace `x' = 0 if `x'==2;
};

*CREATE RETIREMENT VARIABLE;
gen benft_retire2 = 0 if benft_retire==0 & benft_contrib_retire==0;
replace benft_retire2 = 1 if benft_retire==1 | benft_contrib_retire==1;
drop benft_retire benft_contrib_retire benft_empl_pay_retire;
rename benft_retire2 benft_retire;

*SAVE CLEAN 2007 FILE;
gen year=2007;
quietly compress;
save "${input}2007-08\dist07_clean", replace;


*USE 2003 FILE;

use "${input}2003-04\public_district_03", clear;

keep d0050 d0051 ccdidlea d0064 d0063 d0094 d0113 d0114 d0115 d0117 d0119 d0121 d0122 d0123
	d0124 d0125 d0126 d0127 d0128 d0129 d0130 d0131 dfnlwgt;
	
*DROP 1 DISTRICT WITH "B" IN THE CCD ID;
drop if strpos(ccdidlea,"B")~=0;

*DESTRICT CCD ID;	
destring ccdidlea, replace;

*DROP 2 OBS WITH CCD WITH INSANELY HIGH NUMBER;
drop if ccdidlea>999999999;

*MAKE MISSINGS MISSING INSTEAD OF NEGATIVE NUMBERS;
foreach x of var * {; 
	replace `x' = . if `x'<0;
};

*RENAME VARIABLES; 
rename d0050 enr_tot;
rename d0051 enr_k12;
rename ccdidlea ncesid;
rename d0064 teach_fte;
rename d0063 length_year;
rename d0094 teachers_union;

rename d0113 has_sal_sched;
rename d0114 sal_ba_0exp;
rename d0115 sal_ba_10exp;
rename d0117 sal_ma_0exp;
rename d0119 sal_ma_10exp;
rename d0121 sal_top_step;
rename d0122 sal_lowest;
rename d0123 sal_highest;
 
rename d0124 benft_medical;
rename d0125 benft_dental;
rename d0126 benft_life;
rename d0127 benft_retire;
rename d0128 benft_tuition;
rename d0129 benft_housing;
rename d0130 benft_meals;
rename d0131 benft_trnsprtn;
rename dfnlwgt dist_weight; 

/*NOTES ON LABELS
1-yes, 2-no
teachers union: 1-collective bargaining, 2-meet&confer, 3-None
*/

*CREATE NEW TEACHERS UNION CODING;
gen temp = 0 if teachers_union==3;
replace temp = 1 if teachers_union==2; 
replace temp = 2 if teachers_union==1; 
drop teachers_union;
rename temp teach_union;

*RECODE ALL BENEFITS;
foreach x of var has_sal_sched benft* {;
	replace `x' = 0 if `x'==2;
};

*SAVE CLEAN 2003 FILE;
gen year=2003;
quietly compress;
save "${input}2003-04\dist03_clean", replace;



*USE 1999 FILE;
use "${input}1999-00\District99", clear;

*DROP UNNCESSARY VARS;
drop D0497 D0498 D0499 D0509;

*DESTRICT CCD ID;	
destring CCDIDLEA, replace;

*DROP ONE OBS WITH MISSING CCD ID;
drop if CCDIDLEA<0;

*MAKE MISSINGS MISSING INSTEAD OF NEGATIVE NUMBERS;
foreach x of var * {; 
	replace `x' = . if `x'<0;
};

*RENAME VARIABLES; 
rename D0456 enr_tot;
rename D0457 enr_k12;
rename CCDIDLEA ncesid;
rename D0476 teach_fte;
rename D0470 length_year;
rename COLBARG teach_union;

rename D0500 has_sal_sched;
rename D0501 sal_ba_0exp;
rename D0502 sal_ba_10exp;
rename D0503 sal_ma_0exp;
rename D0504 sal_ma_30cred;
rename D0505 sal_ma_20exp;
rename D0506 sal_top_step;
rename D0507 sal_lowest;
rename D0508 sal_highest;
 
rename D0517 benft_medical;
rename D0518 benft_dental;
rename D0519 benft_life;
rename D0520 benft_housing;
rename D0521 benft_meals;
rename D0522 benft_trnsprtn;
rename DFNLWGT dist_weight; 

/*NOTES ON LABELS
1-yes, 2-no
teachers union: 0-none, 1-meet&confer, 2-collective bargaining
*/

*RECODE ALL BENEFITS;
foreach x of var has_sal_sched benft* {;
	replace `x' = 0 if `x'==2;
};

*SAVE CLEAN 1999 FILE;
gen year=1999;
quietly compress;
save "${input}1999-00\dist99_clean", replace;



*USE 1993 FILE;
use "${input}1993-94\District93", clear;

*DESTRICT CCD ID;	
destring CCDIDLEA, replace;

*RENAME VARIABLES;
rename D0255 enr_tot;
rename CCDIDLEA ncesid;
rename D1010 teach_fte;
rename D0465 length_year;
rename D2085 teachers_union_temp1;
rename D2090 teachers_union_temp2;

rename D2095 has_sal_sched;
rename D2100 sal_ba_0exp;
rename D2105 sal_ma_0exp;
rename D2110 sal_ma_30cred;
rename D2115 sal_ma_20exp;
rename D2120 sal_top_step;
rename D2125 sal_lowest;
rename D2130 sal_highest;
 
rename D2140 benft_retire;
rename LEAWGT dist_weight; 

*CREATE TEACHERS UNION VARIABLE;
gen teach_union = 0 if teachers_union_temp1==2;
replace teach_union = 1 if teachers_union_temp2==2;
replace teach_union = 2 if teachers_union_temp2==1;
drop teachers_union_temp1 teachers_union_temp2;

/*NOTES ON LABELS
1-yes, 2-no
teachers union: 0-none, 1-meet&confer, 2-collective bargaining
*/

*RECODE BENEFITS;
foreach x of var has_sal_sched benft* {;
	replace `x' = 0 if `x'==2;
};

*SAVE CLEAN 1993 FILE;
gen year=1993;
quietly compress;
save "${input}1993-94\dist93_clean", replace;



*USE 1990 FILE;
use "${input}1990-91\District90", clear;

*DESTRICT CCD ID;	
destring CCDIDLEA, replace;

*RENAME VARIABLES;
rename NOWTOT enr_tot;
rename CCDIDLEA ncesid;
rename TTOTNOW teach_fte;
rename LNGTHYR length_year;

rename SALSCHED has_sal_sched;
rename MINBACH sal_ba_0exp;
rename MINMASTR sal_ma_0exp;
rename MAXMASTR sal_ma_20exp;
rename HIGHSAL sal_top_step;
rename MINSALRY sal_lowest;
rename MAXSALRY sal_highest;
 
rename PENSION benft_retire;
rename MEDICAL benft_medical;
rename DENTAL benft_dental;
rename LIFE benft_life;
rename HOUSING benft_housing;
rename MEALS benft_meals;
rename TRANSPT benft_trnsprtn;
rename TUITION benft_tuition;
rename LEAWGT dist_weight; 

/*NOTES ON LABELS
1-yes, 2-no
*/

*LENGTH OF SCHOOL YEAR IS IN MONTHS AND IS NOT USEABLE;
drop length_year;

*RECODE BENEFITS;
foreach x of var has_sal_sched benft* {;
	replace `x' = 0 if `x'==2;
};
foreach x in benft_retire benft_housing benft_meals benft_trnsprtn benft_tuition {;
	replace `x' = 0 if `x'==.;
};

*SAVE CLEAN 1990 FILE;
gen year=1990;
quietly compress;
save "${input}1990-91\dist90_clean", replace;


*USE 1987 FILE;
use "${input}1987-88\District87", clear;

*RENAME VARIABLES;
rename DSC021 enr_tot;
rename DSC031 teach_fte;
rename DSC080 length_year;

rename DSC082 sal_ba_0exp;
rename DSC083 sal_ma_0exp;
rename DSC084 sal_ma_20exp;
 
rename DSC073 benft_retire;
rename DSC070 benft_medical;
rename DSC071 benft_dental;
rename DSC072 benft_life;
rename DSC074 benft_housing;
rename DSC075 benft_meals;
rename DSC076 benft_trnsprtn;
rename DSC077 benft_tuition;
rename LEAWGTL dist_weight; 

drop DSC081 LEACNTL LEAWGTS;

/*NOTES ON LABELS
1-yes, 2-no
*/

*LENGTH OF SCHOOL YEAR IS IN MONTHS AND IS NOT USEABLE;
drop length_year;

*RECODE BENEFITS;
foreach x in medical dental life {;
	replace benft_`x' = 0 if benft_`x'==2 | benft_`x'==9;
};

foreach x in retire housing meals trnsprtn {;
	replace benft_`x' = 0 if benft_`x'==.;
};
drop benft_tuition;

*SAVE CLEAN 1987 FILE;
gen year=1987;
quietly compress;
save "${input}1987-88\dist87_clean", replace;


*APPEND FILES TOGETHER;
use "${input}1987-88\dist87_clean", clear;
append using "${input}1990-91\dist90_clean";
append using "${input}1993-94\dist93_clean";
append using "${input}1999-00\dist99_clean";
append using "${input}2003-04\dist03_clean";
append using "${input}2007-08\dist07_clean";
append using "${input}2011-12\dist11_clean";

*REPLACE BENEFITS TRANSPORTATION AS MISSING IN 1990 and 1999; 
replace benft_trnsprtn=. if inlist(year==1987,1990,1999);	

*REPLACE 1987 SAL MA PLUS 20 EXP TO SAL TOP STEP;
replace sal_top_step = sal_ma_20exp if year==1987;

*MAKE ALL SALARY VARIABLES INTO 2015 DOLLARS;
foreach x of var sal* {;
	replace `x' = `x' * (237.017/113.6) if year==1987;
	replace `x' = `x' * (237.017/130.7) if year==1990;
	replace `x' = `x' * (237.017/144.5) if year==1993;
	replace `x' = `x' * (237.017/166.6) if year==1999;
	replace `x' = `x' * (237.017/183.96) if year==2003;
	replace `x' = `x' * (237.017/207.342) if year==2007;
	replace `x' = `x' * (237.017/224.939) if year==2011;
};

*CREATE STUDENT/TEACHER RATIO;
gen stdnt_teach_ratio = enr_tot / teach_fte;
drop enr_tot enr_k12 teach_fte;

order ncesid year dist_weight stdnt_teach_ratio teach_union length_year 
	has_sal_sched sal_ba_0exp sal_ba_10exp sal_ma_0exp sal_ma_10exp sal_ma_30cred
	sal_ma_15exp  sal_ma_20exp sal_top_step sal_lowest sal_highest 
	benft_medical benft_dental benft_life benft_retire benft_housing benft_meals benft_trnsprtn benft_tuition;

	
*SAVE FINAL CLEAN DISTRCT-LEVEL SASS DATA;
compress;
save "${output}dist_level_sass", replace;

log close;


