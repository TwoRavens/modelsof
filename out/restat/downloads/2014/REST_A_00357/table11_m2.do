set mem 550m
set matsize 5000
log using "G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\table11_m2.log", replace
#delimit ;
set more 1;
*
* TABLE11_M2.DO
* BY Alex Whalley
* VERSION OF 07/10/09
* 
* NOTE: ALL VALUES ARE NOMINAL
*;
use "G:\whalley\projects\college_spending\data\clean\restat_randr\cbp_college_all_lmt_analysis_ld_v4.dta", replace;
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
gen endowl6_spindexd5d1_1 = endowl6_spindexd5d1 / 1000;
drop endowl6_spindexd5d1;
rename endowl6_spindexd5d1_1 endowl6_spindexd5d1;
drop lendowl6_spindexd5d1;
gen lendowl6_spindexd5d1 = log(endowl4 / 1000) * spindex5d1;
gen endow81_spindexd5d1_1 = endow81_spindexd5d1 / 1000;
drop endow81_spindexd5d1;
rename endow81_spindexd5d1_1 endow81_spindexd5d1;
gen endowl6_sm_spindexd5d1_1 = endowl6_sm_spindexd5d1 / 1000;
drop endowl6_sm_spindexd5d1;
rename endowl6_sm_spindexd5d1_1 endowl6_sm_spindexd5d1;
gen endowl6_spindexd5d1_grad_1 = endowl6_spindexd5d1_grad/ 1000;
drop endowl6_spindexd5d1_grad;
rename endowl6_spindexd5d1_grad_1 endowl6_spindexd5d1_grad;
gen endowl6_spindexd5d1_rank_1 = endowl6_spindexd5d1_rank / 1000;
drop endowl6_spindexd5d1_rank;
rename endowl6_spindexd5d1_rank_1 endowl6_spindexd5d1_rank;
*
* PART (1): OTHER IVS
*;
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET5d1 endowl6_sm_spindexd5d1 i.year [fw=semp81], cluster(FIPSCOUNTY);
test endowl6_sm_spindexd5d1;
xi: reg ECFET5d1 endowl6_spindexd5d1 endowl6_spindexd5d1_grad endowl6_spindexd5d1_rank i.year*schoolrank i.year*frac_grad81 [fw=semp81], cluster(FIPSCOUNTY);
test endowl6_spindexd5d1 endowl6_spindexd5d1_grad endowl6_spindexd5d1_rank;
xi: reg ECFET5d1 endow81_spindexd5d1 i.year [fw=semp81], cluster(FIPSCOUNTY);
test endow81_spindexd5d1;
xi: reg ECFET5d1 lendowl6_spindexd5d1 i.year [fw=semp81], cluster(FIPSCOUNTY);
test lendowl6_spindexd5d1;
*
* PART (B1): INCOME
*; 
xi: ivreg lincome5d1 (ECFET5d1=endowl6_sm_spindexd5d1 ) i.year [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome5d1 if endowl6_sm_spindexd5d1 !=.;
xi: ivreg lincome5d1 (ECFET5d1=endowl6_spindexd5d1 endowl6_spindexd5d1_grad endowl6_spindexd5d1_rank ) i.year*schoolrank i.year*frac_grad81 [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome5d1 if endowl6_spindexd5d1 !=.;
xi: ivreg lincome5d1 (ECFET5d1=endow81_spindexd5d1 ) i.year [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome5d1 if endow81_spindexd5d1 !=.;
xi: ivreg lincome5d1 (ECFET5d1=lendowl6_spindexd5d1 ) i.year [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome5d1 if lendowl6_spindexd5d1 !=.;
*
* PART (2): DO REGRESSIONS WITH OTHER FIXED EFFECTS * YEAR FES
*;
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET5d1 endowl6_spindexd5d1 i.year*i.statefip [fw=semp81], cluster(FIPSCOUNTY);
test endowl6_spindexd5d1 ;
xi: reg ECFET5d1 endowl6_spindexd5d1 i.year*i.sic [fw=semp81], cluster(FIPSCOUNTY);
test endowl6_spindexd5d1 ;
*
* PART (B1): INCOME
*;
xi: ivreg lincome5d1 (ECFET5d1= endowl6_spindexd5d1 ) i.year*i.statefip [fw=semp81], cluster(FIPSCOUNTY);
sum lincome5d1 if endowl6_spindexd5d1 != .;
xi: ivreg lincome5d1 (ECFET5d1=endowl6_spindexd5d1 ) i.year*i.sic [fw=semp81], cluster(FIPSCOUNTY);
sum lincome5d1 if endowl6_spindexd5d1 != .;
*
* PART (3): DO REGRESSIONS WITH INITIAL CHARACTERISTICS * STOCK TRENDS
*;
*
* PART (A): LOOK AT IV FIRST STAGE
*;
xi: reg ECFET5d1 endowl6_spindexd5d1 i.year*schoolrank [fw=semp81], cluster(FIPSCOUNTY);
test endowl6_spindexd5d1 ;
xi: reg ECFET5d1 endowl6_spindexd5d1 i.year*mhrent [fw=semp81], cluster(FIPSCOUNTY);
test endowl6_spindexd5d1 ;
xi: reg ECFET5d1 endowl6_spindexd5d1 i.year*totpop1900 i.year*mfgout_pc1900 [fw=semp81], cluster(FIPSCOUNTY);
test endowl6_spindexd5d1 ;
*
* PART (B1): INCOME
*;
xi: ivreg lincome5d1 (ECFET5d1=endowl6_spindexd5d1 ) i.year*schoolrank [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome5d1 if endowl6_spindexd5d1 != . & schoolrank != .;
xi: ivreg lincome5d1 (ECFET5d1=endowl6_spindexd5d1 ) i.year*mhrent [fw=semp81], cluster(FIPSCOUNTY); 
sum lincome5d1 if endowl6_spindexd5d1 != . & mhrent != .;
xi: ivreg lincome5d1 (ECFET5d1=endowl6_spindexd5d1 ) i.year*totpop1900 i.year*mfgout_pc1900 [fw=semp81], cluster(FIPSCOUNTY);
sum lincome5d1 if endowl6_spindexd5d1 != . & totpop1900 != .;
*
* CLOSE LOG, CLEAR AND END
*;
log close;
*clear;