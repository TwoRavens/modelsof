set mem 550m
set matsize 5000
log using "G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\table10_m2.log", replace
#delimit ;
set more 1;
*
* TABLE10_M1.DO
* BY Alex Whalley
* VERSION OF 07/10/09
*
*;
use "G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\main_data.dta", replace;
*
* DROP SMALL COUNTIES
*;
drop if totpop < 250000;
*
* REORMALIZE TOTAL EXPENDITURE
*;
gen ECFET5d1p = ECFET5d1 / 1000; 
drop ECFET5d1;
rename ECFET5d1p ECFET5d1;
gen ECFET3d3p = ECFET3d3 / 1000; 
drop ECFET3d3;
rename ECFET3d3p ECFET3d3;
gen endowl6_spindexd5d1_1 = endowl6_spindexd5d1 / 1000;
drop endowl6_spindexd5d1;
rename endowl6_spindexd5d1_1 endowl6_spindexd5d1;
*
* PART (1): DO REGRESSIONS WITH TRIMMING EXTREME VALUES
*;
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET5d1 endowl6_spindexd5d1 i.year [fw=semp81] if trim_ECFET5d1 == 1, cluster(FIPSCOUNTY);
test endowl6_spindexd5d1 ;
xi: reg ECFET5d1 endowl6_spindexd5d1 i.year [fw=semp81] if trim_lincome5d1 == 1, cluster(FIPSCOUNTY);
test endowl6_spindexd5d1 ;
*
* PART (B1): INCOME
*;
xi: reg lincome5d1 ECFET5d1 i.year [fw=semp81] if endowl6_spindexd5d1 !=. & trim_ECFET5d1 == 1, cluster(FIPSCOUNTY); 
xi: ivreg lincome5d1 (ECFET5d1=endowl6_spindexd5d1 ) i.year [fw=semp81] if trim_ECFET5d1 == 1, cluster(FIPSCOUNTY);
sum lincome5d1 if endowl6_spindexd5d1 !=. & trim_ECFET5d1 == 1;
xi: reg lincome5d1 ECFET5d1 i.year [fw=semp81] if endowl6_spindexd5d1 !=. & trim_lincome5d1 == 1, cluster(FIPSCOUNTY); 
xi: ivreg lincome5d1 (ECFET5d1=endowl6_spindexd5d1 ) i.year [fw=semp81] if  trim_lincome5d1 == 1, cluster(FIPSCOUNTY);
sum lincome5d1 if endowl6_spindexd5d1 !=. & trim_lincome5d1 == 1;
*
* PART (2): CLUSTER AT YEAR-COUNTY LEVEL
*;
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: ivreg2 ECFET5d1 endowl6_spindexd5d1 i.year [fw=semp81], cluster(year FIPSCOUNTY);
test endowl6_spindexd5d1;
*
* PART (B1): INCOME
*;
xi: ivreg2 lincome5d1 (ECFET5d1=endowl6_spindexd5d1 ) i.year [fw=semp81], cluster(year FIPSCOUNTY); 
sum lincome5d1 if endowl6_spindexd5d1 !=.;
*
* PART (3): DO REGRESSIONS UNWEIGHTED
*;
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET5d1 endowl6_spindexd5d1 i.year , cluster(FIPSCOUNTY);
test endowl6_spindexd5d1;
*
* PART (B1): INCOME
*;
xi: ivreg lincome5d1 (ECFET5d1=endowl6_spindexd5d1 ) i.year , cluster(FIPSCOUNTY); 
*
* PART (4): DO BASELINE REGS AT COUNTY LEVEL
*;
collapse (mean) ECFET5d1 endowl6_spindexd5d1 lincome5d1 lemp5d1 (sum) semp81, by(year FIPSCOUNTY); 
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET5d1 endowl6_spindexd5d1 i.year [fw=semp81], cluster(FIPSCOUNTY);
test endowl6_spindexd5d1;
*
* PART (B1): INCOME
*;
xi: ivreg lincome5d1 (ECFET5d1=endowl6_spindexd5d1 ) i.year [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome5d1 if endowl6_spindexd5d1 != .;
*
* CLOSE LOG, CLEAR AND END
*;
log close;
*clear;