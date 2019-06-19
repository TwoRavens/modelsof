/*doing the analysis for Table 3*/


#delimit ;
clear; program drop _all; drop _all;
set mem 2000m;
set matsize 2000;
cap log close;
set more off;
*global datadir="H:\DHS\data";
global datadir="L:\MacroCrises&DHS\";
global tablesdir="H:\DHS\Tables\Jed";
global logsdir="H:\DHS\Tables\Jed";
log using "$logsdir\onestepTable6.log", replace;

*local country count to take advantage of missing countries;
local numcountry = 59;

use "$datadir\data_for_onestage.dta", clear;

local covars "wb_aob wb_aob2 wb_aob3 wb_bord wb_bord2 wb_bord3 wb_years_edu wb_years_edu2 wb_years_edu3 wb_gender wb_twin wb_rural";


*rescaling;
replace wb_infant_mortality = 1000*wb_infant_mortality;
compress wb_infant_mortality;


*boy IMR;
sum wb_infant_mortality if wb_gender == 0;
*girl IMR;
sum wb_infant_mortality if wb_gender == 1;

gen byte wb_lowed = .;
replace wb_lowed = 1 if wb_years_edu < 6;
replace wb_lowed = 0 if wb_years_edu >= 6;

*low ED IMR;
sum wb_infant_mortality if wb_lowed == 1;
*high ED IMR;
sum wb_infant_mortality if wb_lowed == 0;

*rural IMR;
sum wb_infant_mortality if wb_rural == 1;
*urban IMR;
sum wb_infant_mortality if wb_rural == 0;

*young middle older mother;
sum wb_infant_mortality if wb_aob < 20;
sum wb_infant_mortality if wb_aob >= 20 & wb_aob < 34;
sum wb_infant_mortality if wb_aob >= 35;

*first  middle and later births;
sum wb_infant_mortality if wb_bord == 1;
sum wb_infant_mortality if wb_bord > 1 & wb_bord < 5;
sum wb_infant_mortality if wb_bord >= 5;

*NEED TO ADD IMR BY INCOME HERE;

***GENDER***;
*generating the GDP interaction;
generate Xgdp = ln_gdp_pc*wb_gender;
compress Xgdp;

*now creating the gender interaction terms;
local i = 1;
while `i' <= `numcountry' {;
	di "COUNTRY `i'";
	gen Xdcountry`i' = dcountry`i'*wb_gender;
	gen Xtcountry`i' = tcountry`i'*wb_gender;
	gen Xt2country`i' = t2country`i'*wb_gender;
	gen Xt3country`i' = t3country`i'*wb_gender;
	compress Xdcountry`i' Xtcountry`i' Xt2country`i' Xt3country`i';
	local i = `i'+1;
};

*dropping the omitted var;
drop Xdcountry59;

reg wb_infant_mortality ln_gdp_pc Xgdp wb_gender dcountry* Xdcountry* tcountry* Xtcountry* t2country* Xt2country* t3country* Xt3country*, robust cluster(country);
*outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6.out", nocons nolabel bdec(2) 3aster se br replace;

drop X*;


***GENDER***;
*generating the GDP interaction;
generate Xgdp = ln_gdp_pc*wb_gender;
compress Xgdp;

*now creating the genderinteraction terms;
local i = 1;
while `i' <= `numcountry' {;
	di "COUNTRY `i'";
	gen Xdcountry`i' = dcountry`i'*wb_gender;
	gen Xtcountry`i' = tcountry`i'*wb_gender;
	gen Xt2country`i' = t2country`i'*wb_gender;
	gen Xt3country`i' = t3country`i'*wb_gender;
	compress Xdcountry`i' Xtcountry`i' Xt2country`i' Xt3country`i';
	local i = `i'+1;
};

*dropping the omitted var;
drop Xdcountry59;

reg wb_infant_mortality ln_gdp_pc Xgdp wb_gender dcountry* Xdcountry* tcountry* Xtcountry* t2country* Xt2country* t3country* Xt3country*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6.out", nocons nolabel bdec(2) 3aster se br replace;

drop X*;


***EDUCATION***;
gen byte wb_lowed = .;
replace wb_lowed = 1 if wb_years_edu < 6;
replace wb_lowed = 0 if wb_years_edu >= 6;

*now creating the lowedinteraction terms;
local i = 1;
while `i' <= `numcountry' {;
	di "COUNTRY `i'";
	gen Xdcountry`i' = dcountry`i'*wb_lowed;
	gen Xtcountry`i' = tcountry`i'*wb_lowed;
	gen Xt2country`i' = t2country`i'*wb_lowed;
	gen Xt3country`i' = t3country`i'*wb_lowed;
	compress Xdcountry`i' Xtcountry`i' Xt2country`i' Xt3country`i';
	local i = `i'+1;
};

*generating the GDP interaction;
generate Xgdp = ln_gdp_pc*wb_lowed;
compress Xgdp;

*dropping the omitted var;
drop Xdcountry59;

reg wb_infant_mortality ln_gdp_pc Xgdp wb_gender dcountry* Xdcountry* tcountry* Xtcountry* t2country* Xt2country* t3country* Xt3country*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6.out", nocons nolabel bdec(2) 3aster se br append;

drop X*;


***RURAL***;
*now creating the ruralinteraction terms;
local i = 1;
while `i' <= `numcountry' {;
	di "COUNTRY `i'";
	gen Xdcountry`i' = dcountry`i'*wb_rural;
	gen Xtcountry`i' = tcountry`i'*wb_rural;
	gen Xt2country`i' = t2country`i'*wb_rural;
	gen Xt3country`i' = t3country`i'*wb_rural;
	compress Xdcountry`i' Xtcountry`i' Xt2country`i' Xt3country`i';
	local i = `i'+1;
};

*generating the GDP interaction;
generate Xgdp = ln_gdp_pc*wb_rural;
compress Xgdp;

*dropping the omitted var;
drop Xdcountry59;

reg wb_infant_mortality ln_gdp_pc Xgdp wb_gender dcountry* Xdcountry* tcountry* Xtcountry* t2country* Xt2country* t3country* Xt3country*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6.out", nocons nolabel bdec(2) 3aster se br append;

drop X*;


***YOUNGER AGES***;
gen byte wb_youngage = .;
replace wb_youngage = 0 if wb_aob < 20;
replace wb_youngage = 1 if wb_aob >= 20;

*now creating the youngageinteraction terms;
local i = 1;
while `i' <= `numcountry' {;
	di "COUNTRY `i'";
	gen Xdcountry`i' = dcountry`i'*wb_youngage;
	gen Xtcountry`i' = tcountry`i'*wb_youngage;
	gen Xt2country`i' = t2country`i'*wb_youngage;
	gen Xt3country`i' = t3country`i'*wb_youngage;
	compress Xdcountry`i' Xtcountry`i' Xt2country`i' Xt3country`i';
	local i = `i'+1;
};

*generating the GDP interaction;
generate Xgdp = ln_gdp_pc*wb_youngage;
compress Xgdp;

*dropping the omitted var;
drop Xdcountry59;

reg wb_infant_mortality ln_gdp_pc Xgdp wb_gender dcountry* Xdcountry* tcountry* Xtcountry* t2country* Xt2country* t3country* Xt3country*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6.out", nocons nolabel bdec(2) 3aster se br append;

drop X*;



***OLDER AGES***;
gen byte wb_oldage = .;
replace wb_oldage = 0 if wb_aob < 34;
replace wb_oldage = 1 if wb_aob >= 35;

*now creating the oldageinteraction terms;
local i = 1;
while `i' <= `numcountry' {;
	di "COUNTRY `i'";
	gen Xdcountry`i' = dcountry`i'*wb_oldage;
	gen Xtcountry`i' = tcountry`i'*wb_oldage;
	gen Xt2country`i' = t2country`i'*wb_oldage;
	gen Xt3country`i' = t3country`i'*wb_oldage;
	compress Xdcountry`i' Xtcountry`i' Xt2country`i' Xt3country`i';
	local i = `i'+1;
};

*generating the GDP interaction;
generate Xgdp = ln_gdp_pc*wb_oldage;
compress Xgdp;

*dropping the omitted var;
drop Xdcountry59;

reg wb_infant_mortality ln_gdp_pc Xgdp wb_gender dcountry* Xdcountry* tcountry* Xtcountry* t2country* Xt2country* t3country* Xt3country*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6.out", nocons nolabel bdec(2) 3aster se br append;

drop X*;


***FIRST BIRTH ORDER***;
gen byte wb_firstbo = .;
replace wb_firstbo = 0 if wb_bord > 1;
replace wb_firstbo = 1 if wb_bord == 1;

*now creating the firstbointeraction terms;
local i = 1;
while `i' <= `numcountry' {;
	di "COUNTRY `i'";
	gen Xdcountry`i' = dcountry`i'*wb_firstbo;
	gen Xtcountry`i' = tcountry`i'*wb_firstbo;
	gen Xt2country`i' = t2country`i'*wb_firstbo;
	gen Xt3country`i' = t3country`i'*wb_firstbo;
	compress Xdcountry`i' Xtcountry`i' Xt2country`i' Xt3country`i';
	local i = `i'+1;
};

*generating the GDP interaction;
generate Xgdp = ln_gdp_pc*wb_firstbo;
compress Xgdp;

*dropping the omitted var;
drop Xdcountry59;

reg wb_infant_mortality ln_gdp_pc Xgdp wb_gender dcountry* Xdcountry* tcountry* Xtcountry* t2country* Xt2country* t3country* Xt3country*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6.out", nocons nolabel bdec(2) 3aster se br append;

drop X*;


***LATER BIRTH ORDER***;
gen byte wb_laterbo = .;
replace wb_laterbo = 0 if wb_bord < 5;
replace wb_laterbo = 1 if wb_bord >= 5;

*now creating the laterbointeraction terms;
local i = 1;
while `i' <= `numcountry' {;
	di "COUNTRY `i'";
	gen Xdcountry`i' = dcountry`i'*wb_laterbo;
	gen Xtcountry`i' = tcountry`i'*wb_laterbo;
	gen Xt2country`i' = t2country`i'*wb_laterbo;
	gen Xt3country`i' = t3country`i'*wb_laterbo;
	compress Xdcountry`i' Xtcountry`i' Xt2country`i' Xt3country`i';
	local i = `i'+1;
};

*generating the GDP interaction;
generate Xgdp = ln_gdp_pc*wb_laterbo;
compress Xgdp;

*dropping the omitted var;
drop Xdcountry59;

reg wb_infant_mortality ln_gdp_pc Xgdp wb_gender dcountry* Xdcountry* tcountry* Xtcountry* t2country* Xt2country* t3country* Xt3country*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6.out", nocons nolabel bdec(2) 3aster se br append;

***1990 Low Cutoff***;
*generating the GDP interaction;
gen abovelow=.;
replace abovelow = 1 if yr1990 > 755;
replace abovelow = 0 if yr1990 <= 755;
generate Xgdp = ln_gdp_pc*abovelow;
replace Xgdp = . if abovelow == .;
compress Xgdp;

*excluded category;

reg wb_infant_mortality ln_gdp_pc Xgdp abovelow dcountry* tcountry*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6ByIncome.out", nocons nolabel bdec(2) 3aster se br append;

reg wb_infant_mortality ln_gdp_pc Xgdp abovelow dcountry* tcountry* t2country*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6ByIncome.out", nocons nolabel bdec(2) 3aster se br append;

reg wb_infant_mortality ln_gdp_pc Xgdp abovelow dcountry* tcountry* t2country* t3country*, robust cluster(country);
outreg ln_gdp_pc Xgdp using "$tablesdir\onestepTable6ByIncome.out", nocons nolabel bdec(2) 3aster se br append;

drop X*;

log close;

stop;

