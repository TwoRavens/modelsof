set mem 550m
set matsize 5000
log using "G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\table10_m1.log", replace
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
gen ECFET3d1p = ECFET3d1 / 1000; 
drop ECFET3d1;
rename ECFET3d1p ECFET3d1;
gen ECFET3d3p = ECFET3d3 / 1000; 
drop ECFET3d3;
rename ECFET3d3p ECFET3d3;
gen endowl4_spindexd3d1_1 = endowl4_spindexd3d1 / 1000;
drop endowl4_spindexd3d1;
rename endowl4_spindexd3d1_1 endowl4_spindexd3d1;
*
* PART (1): DO REGRESSIONS WITH TRIMMING EXTREME VALUES
*;
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET3d1 endowl4_spindexd3d1 i.year [fw=semp81] if trim_ECFET3d1 == 1, cluster(FIPSCOUNTY);
test endowl4_spindexd3d1 ;
xi: reg ECFET3d1 endowl4_spindexd3d1 i.year [fw=semp81] if trim_lincome3d1 == 1, cluster(FIPSCOUNTY);
test endowl4_spindexd3d1 ;
*
* PART (B1): INCOME
*;
xi: reg lincome3d1 ECFET3d1 i.year [fw=semp81] if endowl4_spindexd3d1 !=. & trim_ECFET3d1 == 1, cluster(FIPSCOUNTY); 
xi: ivreg lincome3d1 (ECFET3d1=endowl4_spindexd3d1 ) i.year [fw=semp81] if trim_ECFET3d1 == 1, cluster(FIPSCOUNTY);
sum lincome3d1 if endowl4_spindexd3d1 !=. & trim_ECFET3d1 == 1;
xi: reg lincome3d1 ECFET3d1 i.year [fw=semp81] if endowl4_spindexd3d1 !=. & trim_lincome3d1 == 1, cluster(FIPSCOUNTY); 
xi: ivreg lincome3d1 (ECFET3d1=endowl4_spindexd3d1 ) i.year [fw=semp81] if  trim_lincome3d1 == 1, cluster(FIPSCOUNTY);
sum lincome3d1 if endowl4_spindexd3d1 !=. & trim_lincome3d1 == 1;
*
* PART (2): CLUSTER AT YEAR-COUNTY LEVEL
*;
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: ivreg2 ECFET3d1 endowl4_spindexd3d1 i.year [fw=semp81], cluster(year FIPSCOUNTY);
test endowl4_spindexd3d1;
*
* PART (B1): INCOME
*;
xi: ivreg2 lincome3d1 (ECFET3d1=endowl4_spindexd3d1 ) i.year [fw=semp81], cluster(year FIPSCOUNTY); 
sum lincome3d1 if endowl4_spindexd3d1 !=.;
*
* PART (3): DO REGRESSIONS UNWEIGHTED
*;
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET3d1 endowl4_spindexd3d1 i.year , cluster(FIPSCOUNTY);
test endowl4_spindexd3d1;
*
* PART (B1): INCOME
*;
xi: ivreg lincome3d1 (ECFET3d1=endowl4_spindexd3d1 ) i.year, cluster(FIPSCOUNTY); 
*
* PART (4): DO BASELINE REGS AT COUNTY LEVEL
*;
collapse (mean) ECFET3d1 endowl4_spindexd3d1 lincome3d1 lemp3d1 (sum) semp81, by(year FIPSCOUNTY); 
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET3d1 endowl4_spindexd3d1 i.year [fw=semp81], cluster(FIPSCOUNTY);
test endowl4_spindexd3d1;
*
* PART (B1): INCOME
*;
xi: ivreg lincome3d1 (ECFET3d1=endowl4_spindexd3d1 ) i.year [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome3d1 if endowl4_spindexd3d1 != .;
*
* CLOSE LOG, CLEAR AND END
*;
log close;
*clear;