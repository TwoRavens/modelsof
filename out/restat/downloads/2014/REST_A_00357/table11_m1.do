set mem 550m
set matsize 5000
log using "G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\table11_m1.log", replace
#delimit ;
set more 1;
*
* TABLE11_M1.DO
* BY Alex Whalley
* VERSION OF 07/10/09
* 
* NOTE: ALL VALUES ARE NOMINAL
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
gen endowl4_spindexd3d1_1 = endowl4_spindexd3d1 / 1000;
drop endowl4_spindexd3d1;
rename endowl4_spindexd3d1_1 endowl4_spindexd3d1;
drop lendowl4_spindexd3d1;
gen lendowl4_spindexd3d1 = log(endowl4 / 1000) * spindex3d1;
gen endow81_spindexd3d1_1 = endow81_spindexd3d1 / 1000;
drop endow81_spindexd3d1;
rename endow81_spindexd3d1_1 endow81_spindexd3d1;
gen endowl4_sm_spindexd3d1_1 = endowl4_sm_spindexd3d1 / 1000;
drop endowl4_sm_spindexd3d1;
rename endowl4_sm_spindexd3d1_1 endowl4_sm_spindexd3d1;
gen endowl4_spindexd3d1_grad_1 = endowl4_spindexd3d1_grad/ 1000;
drop endowl4_spindexd3d1_grad;
rename endowl4_spindexd3d1_grad_1 endowl4_spindexd3d1_grad;
gen endowl4_spindexd3d1_rank_1 = endowl4_spindexd3d1_rank / 1000;
drop endowl4_spindexd3d1_rank;
rename endowl4_spindexd3d1_rank_1 endowl4_spindexd3d1_rank;
*
* PART (1): OTHER IVS
*;
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET3d1 endowl4_sm_spindexd3d1 i.year [fw=semp81], cluster(FIPSCOUNTY);
test endowl4_sm_spindexd3d1;
xi: reg ECFET3d1 endowl4_spindexd3d1 endowl4_spindexd3d1_grad endowl4_spindexd3d1_rank i.year*schoolrank i.year*frac_grad81 [fw=semp81], cluster(FIPSCOUNTY);
test endowl4_spindexd3d1 endowl4_spindexd3d1_grad endowl4_spindexd3d1_rank;
xi: reg ECFET3d1 endow81_spindexd3d1 i.year [fw=semp81], cluster(FIPSCOUNTY);
test endow81_spindexd3d1;
xi: reg ECFET3d1 lendowl4_spindexd3d1 i.year [fw=semp81], cluster(FIPSCOUNTY);
test lendowl4_spindexd3d1;
*
* PART (B1): INCOME
*; 
xi: ivreg lincome3d1 (ECFET3d1=endowl4_sm_spindexd3d1 ) i.year [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome3d1 if endowl4_sm_spindexd3d1 !=.;
xi: ivreg lincome3d1 (ECFET3d1=endowl4_spindexd3d1 endowl4_spindexd3d1_grad endowl4_spindexd3d1_rank ) i.year*schoolrank i.year*frac_grad81 [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome3d1 if endowl4_spindexd3d1 !=.;
xi: ivreg lincome3d1 (ECFET3d1=endow81_spindexd3d1 ) i.year [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome3d1 if endow81_spindexd3d1 !=.;
xi: ivreg lincome3d1 (ECFET3d1=lendowl4_spindexd3d1 ) i.year [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome3d1 if lendowl4_spindexd3d1 !=.;
*
* PART (2): DO REGRESSIONS WITH OTHER FIXED EFFECTS * YEAR FES
*;
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET3d1 endowl4_spindexd3d1 i.year*i.statefip [fw=semp81], cluster(FIPSCOUNTY);
test endowl4_spindexd3d1 ;
xi: reg ECFET3d1 endowl4_spindexd3d1 i.year*i.sic [fw=semp81], cluster(FIPSCOUNTY);
test endowl4_spindexd3d1 ;
*
* PART (B1): INCOME
*;
xi: ivreg lincome3d1 (ECFET3d1= endowl4_spindexd3d1 ) i.year*i.statefip [fw=semp81], cluster(FIPSCOUNTY);
sum lincome3d1 if endowl4_spindexd3d1 != .;
xi: ivreg lincome3d1 (ECFET3d1=endowl4_spindexd3d1 ) i.year*i.sic [fw=semp81], cluster(FIPSCOUNTY);
sum lincome3d1 if endowl4_spindexd3d1 != .;
*
* PART (3): DO REGRESSIONS WITH INITIAL CHARACTERISTICS * STOCK TRENDS
*;
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET3d1 endowl4_spindexd3d1 i.year*schoolrank [fw=semp81], cluster(FIPSCOUNTY);
test endowl4_spindexd3d1 ;
xi: reg ECFET3d1 endowl4_spindexd3d1 i.year*mhrent [fw=semp81], cluster(FIPSCOUNTY);
test endowl4_spindexd3d1 ;
xi: reg ECFET3d1 endowl4_spindexd3d1 i.year*totpop1900 i.year*mfgout_pc1900 [fw=semp81], cluster(FIPSCOUNTY);
test endowl4_spindexd3d1 ;
*
* PART (B1): INCOME
*;
xi: ivreg lincome3d1 (ECFET3d1=endowl4_spindexd3d1 ) i.year*schoolrank [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome3d1 if endowl4_spindexd3d1 != . & schoolrank != .;
xi: ivreg lincome3d1 (ECFET3d1=endowl4_spindexd3d1 ) i.year*mhrent [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome3d1 if endowl4_spindexd3d1 != . & mhrent != .;
xi: ivreg lincome3d1 (ECFET3d1=endowl4_spindexd3d1 ) i.year*totpop1900 i.year*mfgout_pc1900 [fw=semp81], cluster(FIPSCOUNTY);
sum lincome3d1 if endowl4_spindexd3d1 != . & totpop1900 != .;
*
* CLOSE LOG, CLEAR AND END
*;
log close;
*clear;