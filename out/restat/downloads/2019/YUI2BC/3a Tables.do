***Last Updated: 12/14/2018 using Stata14
/*==========================================*
Paper:			Breaking the Cycle? Education and the Intergenerational Transmission of Violence

Purpose:        Produce the results in Tables 1-8 and Online Appendix Tables A1-A17.

To re-run our analysis, please install a folder "Domestic Violence". There should be 5 subfolders in order for do-files to run:

"originals"
"created"
"do files"
"graphs"
"output"

Before you run this do file, please change the path of the working directory in line 24 and run all of the data cleaning do files.
*==========================================*/
clear
set more off 
set matsize 8000
cap log close
#delimit ;

global dir="XXX\Domestic Violence";
cd "$dir";

use "created/women_data_for_analysis_2014.dta", clear
log using "output/results.log", replace

global contr="month_* noturkish2 region_pre12_* region_pre12i* rural_pre12"
global se "cluster modate"	
global slvl "starlevels(* 0.10 ** 0.05 *** 0.01)"

********** TABLE 1: RD TREATMENT EFFECTS ON SCHOOLING BY REGION OF CHILDHOOD
********** TABLE 1, PANEL A: RURAL-URBAN CHILDHOOD REGION
foreach x in schooling{

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & rural_pre12==1, vce($se)
outreg2 using "output/t4a_`x'", excel  replace ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons
	
**linear RD, 0.75 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*0.75 & rural_pre12==1, vce($se)
outreg2 using "output/t4a_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*1.5 & rural_pre12==1, vce($se)
outreg2 using "output/t4a_`x'", excel  append ctitle(Linear RD, 1.5h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
outreg2 using "output/t4a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & rural_pre12==1
outreg2 using "output/t4a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85*0.75 & rural_pre12==1
outreg2 using "output/t4a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85*1.5 & rural_pre12==1
outreg2 using "output/t4a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

foreach x in schooling{

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & rural_pre12==0, vce($se)
outreg2 using "output/t4a_`x'", excel  append ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons
	
**linear RD, 0.75 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*0.75 & rural_pre12==0, vce($se)
outreg2 using "output/t4a_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*1.5 & rural_pre12==0, vce($se)
outreg2 using "output/t4a_`x'", excel  append ctitle(Linear RD, 1.5h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
outreg2 using "output/t4a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & rural_pre12==0
outreg2 using "output/t4a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85*0.75 & rural_pre12==0
outreg2 using "output/t4a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85*1.5 & rural_pre12==0
outreg2 using "output/t4a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE 1, PANEL B: RURAL-URBAN CHILDHOOD REGION (SAMPLE OF WOMEN WITH CHILDREN) 
foreach x in schooling{

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t4b_`x'", excel  replace ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons
	
**linear RD, 0.75 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*0.75 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t4b_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*1.5 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t4b_`x'", excel  append ctitle(Linear RD, 2h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/t4b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & rural_pre12==1 & has_children==1
outreg2 using "output/t4b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85*0.75 & rural_pre12==1 & has_children==1
outreg2 using "output/t4b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85*1.5 & rural_pre12==1 & has_children==1
outreg2 using "output/t4b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

foreach x in schooling{

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==0, vce($se)
outreg2 using "output/t4b_`x'", excel  append ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons
	
**linear RD, 0.75 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*0.75 & has_children==1& rural_pre12==0, vce($se)
outreg2 using "output/t4b_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*1.5 & has_children==1& rural_pre12==0, vce($se)
outreg2 using "output/t4b_`x'", excel  append ctitle(Linear RD, 1.5 bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
outreg2 using "output/t4b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & rural_pre12==0 & has_children==1
outreg2 using "output/t4b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85*0.75 & rural_pre12==0 & has_children==1
outreg2 using "output/t4b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85*1.5 & rural_pre12==0 & has_children==1
outreg2 using "output/t4b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE 2: EDUCATION EFFECTS ON VIOLENCE AGAINST CHILDREN BY CHILDHOOD REGION
********** TABLE 2, PANEL A: RD TREATMENT EFFECTS

foreach x in hit_child hit_child_often{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t5a_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t5a_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t5a_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<85 & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/t5a_`x'", excel  append ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/t5a_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/t5a_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/t5a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/t5a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1
outreg2 using "output/t5a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & rural_pre12==1 & has_children==1
outreg2 using "output/t5a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE 2, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE
foreach x in hit_child hit_child_often{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t5b_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t5b_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t5b_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t5b_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t5b_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t5b_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/t5b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/t5b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1
outreg2 using "output/t5b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1
outreg2 using "output/t5b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE 3: EFFECTS OF EDUCATION ON ATTITUDES TOWARDS VIOLENCE
foreach x in agree_beat agree_childbeat{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t7_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t7_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t7_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t7_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t7_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t7_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/t7_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/t7_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1
outreg2 using "output/t7_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1
outreg2 using "output/t7_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE 4: EFFECTS OF EDUCATION ON MENTAL HEALTH OUTCOMES
foreach x in z_depression z_somatic z_nonsomatic{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t8_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t8_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t8_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t8_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t8_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t8_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/t8_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/t8_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1
outreg2 using "output/t8_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1
outreg2 using "output/t8_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE 5: EFFECTS OF EDUCATION ON FERTILITY OUTCOMES
foreach x in pregnancy_age num_children{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 , vce($se)
outreg2 using "output/t9_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 , vce($se)
outreg2 using "output/t9_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 , vce($se)
outreg2 using "output/t9_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 &  rural_pre12==1, vce($se)
outreg2 using "output/t9_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 &  rural_pre12==1, vce($se)
outreg2 using "output/t9_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 &  rural_pre12==1, vce($se)
outreg2 using "output/t9_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif, bwselect(IK)
outreg2 using "output/t9_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif if  rural_pre12==1, bwselect(IK)
outreg2 using "output/t9_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif , bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 
outreg2 using "output/t9_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if  rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 &  rural_pre12==1
outreg2 using "output/t9_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE 6: EFFECTS OF EDUCATION ON LABOR MARKET OUTCOMES
foreach x in work_lastweek service z_income {

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t10_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t10_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t10_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t10_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t10_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t10_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/t10_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/t10_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1
outreg2 using "output/t10_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1
outreg2 using "output/t10_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE 7: EFFECTS OF EDUCATION ON PARTNER CHARACTERISTICS AND MARRIAGE MARKET OUTCOMES
foreach x in schooling_partner z_malereligious marriage_age{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t11_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t11_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t11_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t11_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t11_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t11_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/t11_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/t11_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1
outreg2 using "output/t11_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1
outreg2 using "output/t11_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE 8: EFFECTS OF EDUCATION ON SPOUSAL VIOLENCE
foreach x in z_physical z_emotional z_financial{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t12_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t12_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t12_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t12_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t12_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t12_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/t12_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/t12_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1
outreg2 using "output/t12_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1
outreg2 using "output/t12_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

*-------------------------
********** APPENDIX TABLES
*-------------------------


********** TABLE A1: SUMMARY STATISTICS FOR 20-34 YEAR-OLD WOMEN WHO HAVE CHILDREN
**Sample of Women Who Have Children
foreach x in schooling jhighschool highschool primaryschool hit_child hit_child_often agree_beat agree_childbeat work_lastweek service social_security z_income z_asset schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced z_physical z_emotional z_financial z_depression z_somatic z_nonsomatic child_aggressive child_cry_aggressive child_nightmare child_peebed child_shy rural_pre12 noturkish violence_family{ 
qui regress `x' dif if abs(dif)<85 & has_children==1 
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1
outreg2 using "output/t1_`x'", excel replace ctitle(Mean) addstat(Mean, r(mean), Standard deviation, r(sd)) adec(2) nonotes nocons
}

foreach x in schooling jhighschool highschool primaryschool hit_child hit_child_often agree_beat agree_childbeat work_lastweek service social_security z_income z_asset schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced z_physical z_emotional z_financial z_depression z_somatic z_nonsomatic child_aggressive child_cry_aggressive child_nightmare child_peebed child_shy rural_pre12 noturkish violence_family{ 
qui regress `x' dif if abs(dif)<85 & has_children==1 & rural_pre12==1
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1 & rural_pre12==1
outreg2 using "output/t1_`x'", excel append ctitle(Mean) addstat(Mean, r(mean), Standard deviation, r(sd)) adec(2) nonotes nocons
}

foreach x in schooling jhighschool highschool primaryschool hit_child hit_child_often agree_beat agree_childbeat work_lastweek service social_security z_income z_asset schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced z_physical z_emotional z_financial z_depression z_somatic z_nonsomatic child_aggressive child_cry_aggressive child_nightmare child_peebed child_shy rural_pre12 noturkish violence_family{ 
qui regress `x' dif if abs(dif)<85 & has_children==1 & rural_pre12==0
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1 & rural_pre12==0
outreg2 using "output/t1_`x'", excel append ctitle(Mean) addstat(Mean, r(mean), Standard deviation, r(sd)) adec(2) nonotes nocons
}

svyset HHID [pw=womenweight], strata(region26)

foreach x in schooling jhighschool highschool primaryschool hit_child hit_child_often agree_beat agree_childbeat work_lastweek service social_security z_income z_asset schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced z_physical z_emotional z_financial z_depression z_somatic z_nonsomatic child_aggressive child_cry_aggressive child_nightmare child_peebed child_shy noturkish violence_family{ 

svy: mean `x' if abs(dif)<85 & has_children==1, over(rural_pre12)
lincom [`x']0 - [`x']1
local tstat=r(estimate)/r(se)
local pval = tprob(r(df), abs(`tstat'))
outreg2 using "output/t1_`x'", excel append ctitle(Difference) addstat(difference, r(estimate), standard, r(se), pval, `pval') adec(2) nonotes nocons
}

**Whole sample of women
foreach x in pregnancy_age num_children{ 
qui regress `x' dif if abs(dif)<85 
qui sum `x' [aw=womenweight] if abs(dif)<85 
outreg2 using "output/t1_`x'", excel replace ctitle(Mean) addstat(Mean, r(mean), Standard deviation, r(sd)) adec(2) nonotes nocons
}

foreach x in pregnancy_age num_children{ 
qui regress `x' dif if abs(dif)<85  & rural_pre12==1
qui sum `x' [aw=womenweight] if abs(dif)<85  & rural_pre12==1
outreg2 using "output/t1_`x'", excel append ctitle(Mean) addstat(Mean, r(mean), Standard deviation, r(sd)) adec(2) nonotes nocons
}

foreach x in pregnancy_age num_children {
qui regress `x' dif if abs(dif)<85  & rural_pre12==0
qui sum `x' [aw=womenweight] if abs(dif)<85  & rural_pre12==0
outreg2 using "output/t1_`x'", excel append ctitle(Mean) addstat(Mean, r(mean), Standard deviation, r(sd)) adec(2) nonotes nocons
}
svyset HHID [pw=womenweight], strata(region26)
foreach x in pregnancy_age num_children{ 
svy: mean `x' if abs(dif)<85 , over(rural_pre12)
lincom [`x']0 - [`x']1
local tstat=r(estimate)/r(se)
local pval = tprob(r(df), abs(`tstat'))
outreg2 using "output/t1_`x'", excel append ctitle(Difference) addstat(difference, r(estimate), standard, r(se), pval, `pval') adec(2) nonotes nocons
}

********** TABLE A2: EFFECTS OF THE REFORM ON CHILDHOOD VIOLENCE 
foreach x in violence_family violence_family_often{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<85 , vce($se)
outreg2 using "output/t2_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85 , vce($se)
outreg2 using "output/t2_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<85 , vce($se)
outreg2 using "output/t2_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<85 &rural_pre12==1, vce($se)
outreg2 using "output/t2_`x'", excel  append ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85 &rural_pre12==1, vce($se)
outreg2 using "output/t2_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<85 &rural_pre12==1, vce($se)
outreg2 using "output/t2_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**URBAN SAMPLE
**OLS, h bandwidth, with controls
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<85 &rural_pre12==0, vce($se)
outreg2 using "output/t2_`x'", excel  append ctitle(Urban sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85 &rural_pre12==0, vce($se)
outreg2 using "output/t2_`x'", excel append ctitle(Urban sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<85 &rural_pre12==0, vce($se)
outreg2 using "output/t2_`x'", excel  append ctitle(Urban sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif , bwselect(IK)
outreg2 using "output/t2_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif & rural_pre12==1, bwselect(IK)
outreg2 using "output/t2_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif & rural_pre12==0, bwselect(IK)
outreg2 using "output/t2_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif , bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 
outreg2 using "output/t2_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif & rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & rural_pre12==1 
outreg2 using "output/t2_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif & rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & rural_pre12==0
outreg2 using "output/t2_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A3: RD TREATMENT EFFECTS ON SCHOOLING (SAMPLE OF ALL WOMEN) 
foreach x in schooling jhighschool highschool primaryschool{

**linear RD, h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85, vce($se)
outreg2 using "output/t3_`x'", excel  replace ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, 0.75 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*0.75, vce($se)
outreg2 using "output/t3_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<85*1.5, vce($se)
outreg2 using "output/t3_`x'", excel  append ctitle(Linear RD, 1.5h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif, bwselect(IK)
outreg2 using "output/t3_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85
outreg2 using "output/t3_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A4: RD TREATMENT EFFECTS ON SCHOOLING OUTCOMES USING A QUADRATIC POLYNOMIAL IN THE FORCING VARIABLE 
foreach x in schooling jhighschool highschool primaryschool{

**quadratic RD, h bandwidth, with controls
qui rdrobust `x' dif, bwselect(IK)
qui regress `x' after1986 di1 di2 $contr [aw=womenweight] if abs(dif)<85, vce($se)
outreg2 using "output/ta1_`x'", excel  replace ctitle(Quadratic RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**quadratic RD, h bandwidth, with controls
qui rdrobust `x' dif, bwselect(IK)
qui regress `x' after1986 di1 di2 $contr [aw=womenweight] if abs(dif)<e(h_bw), vce($se)
outreg2 using "output/ta1_`x'", excel  append ctitle(Quadratic RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif, bwselect(IK)
outreg2 using "output/ta1_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif , bwselect(IK)
outreg2 using "output/ta1_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85
outreg2 using "output/ta1_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif , bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)
outreg2 using "output/ta1_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A5: RD TREATMENT EFFECTS ON SCHOOLING (OPTIMAL BANDWIDTH) 
foreach x in schooling jhighschool highschool primaryschool{

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw), vce($se)
outreg2 using "output/ta2_`x'", excel  replace ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, 0.75 h bandwidth, with controls
qui rdrobust `x' dif, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*0.75, vce($se)
outreg2 using "output/ta2_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui rdrobust `x' dif, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*1.5, vce($se)
outreg2 using "output/ta2_`x'", excel  append ctitle(Linear RD, 1.5h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif, bwselect(IK)
outreg2 using "output/ta2_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)
outreg2 using "output/ta2_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A6: RD TREATMENT EFFECTS ON SCHOOLING BY REGION OF CHILDHOOD (OPTIMAL BANDWIDTH)
********** TABLE A6, PANEL A: RURAL-URBAN CHILDHOOD REGION
foreach x in schooling jhighschool highschool primaryschool{

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1, vce($se)
outreg2 using "output/ta3a_`x'", excel  replace ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, 0.75 h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*0.75 & rural_pre12==1, vce($se)
outreg2 using "output/ta3a_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*1.5 & rural_pre12==1, vce($se)
outreg2 using "output/ta3a_`x'", excel  append ctitle(Linear RD, 1.5h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
outreg2 using "output/ta3a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1
outreg2 using "output/ta3a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)*0.75 & rural_pre12==1
outreg2 using "output/ta3a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)*1.5 & rural_pre12==1
outreg2 using "output/ta3a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}


foreach x in schooling jhighschool highschool primaryschool{

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==0, vce($se)
outreg2 using "output/ta3a_`x'", excel  append ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, 0.75 h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*0.75 & rural_pre12==0, vce($se)
outreg2 using "output/ta3a_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*1.5 & rural_pre12==0, vce($se)
outreg2 using "output/ta3a_`x'", excel  append ctitle(Linear RD, 1.5h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
outreg2 using "output/ta3a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==0
outreg2 using "output/ta3a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)*0.75 & rural_pre12==0
outreg2 using "output/ta3a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)*1.5 & rural_pre12==0
outreg2 using "output/ta3a_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A6, PANEL B: RURAL-URBAN CHILDHOOD REGION (SAMPLE OF WOMEN WITH CHILDREN) 
foreach x in schooling  jhighschool highschool primaryschool{

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta3b_`x'", excel  replace ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, 0.75 h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*0.75 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta3b_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*1.5 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta3b_`x'", excel  append ctitle(Linear RD, 2h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta3b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1 & has_children==1
outreg2 using "output/ta3b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)*0.75 & rural_pre12==1 & has_children==1
outreg2 using "output/ta3b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)*1.5 & rural_pre12==1 & has_children==1
outreg2 using "output/ta3b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

foreach x in schooling jhighschool highschool primaryschool{

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==0, vce($se)
outreg2 using "output/ta3b_`x'", excel  append ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, 0.75 h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*0.75 & has_children==1& rural_pre12==0, vce($se)
outreg2 using "output/ta3b_`x'", excel  append ctitle(Linear RD, 0.75h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

** linear RD, 1.5 h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw)*1.5 & has_children==1& rural_pre12==0, vce($se)
outreg2 using "output/ta3b_`x'", excel  append ctitle(Linear RD, 1.5 bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
outreg2 using "output/ta3b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==0 & has_children==1
outreg2 using "output/ta3b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)*0.75 & rural_pre12==0 & has_children==1
outreg2 using "output/ta3b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==0, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw)*1.5 & rural_pre12==0 & has_children==1
outreg2 using "output/ta3b_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A7: RD TREATMENT EFFECTS ON RELIGIOSITY
use "created/TNSA2013_Analysis.dta", clear

global contr="month_* noturkish2 region_pre12_* region_pre12i* rural_pre12"
global se "cluster modate"	
global slvl "starlevels(* 0.10 ** 0.05 *** 0.01)"

foreach x in fast headscarf namaz z_religious religious_course{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling $contr [aw=weight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta4_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=weight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta4_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=weight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta4_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' schooling $contr [aw=weight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta4_`x'", excel  append ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=weight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta4_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=weight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta4_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta4_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta4_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=weight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta4_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=weight] if abs(dif)<e(h_bw) & rural_pre12==1 & has_children==1
outreg2 using "output/ta4_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A8: EDUCATION EFFECTS ON VIOLENCE AGAINST CHILDREN (OPTIMAL BANDWIDTH)
********** TABLE A8, PANEL A: RD TREATMENT EFFECTS
use "created/women_data_for_analysis_2014.dta", clear

global contr="month_* noturkish2 region_pre12_* region_pre12i* rural_pre12"
global se "cluster modate"	
global slvl "starlevels(* 0.10 ** 0.05 *** 0.01)"

foreach x in hit_child hit_child_often{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta5a_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta5a_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta5a_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta5a_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta5a_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta5a_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta5a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta5a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta5a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1 & has_children==1
outreg2 using "output/ta5a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A8, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE
foreach x in hit_child hit_child_often{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta5b_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta5b_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta5b_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta5b_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta5b_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta5b_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta5b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta5b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta5b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1
outreg2 using "output/ta5b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A9: EFFECTS OF EDUCATION ON CHILD BEHAVIOR
foreach x in child_aggressive child_cry_aggressive child_nightmare child_peebed child_shy{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t6_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t6_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1, vce($se)
outreg2 using "output/t6_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t6_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t6_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/t6_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/t6_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/t6_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), 85) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1
outreg2 using "output/t6_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<85 & has_children==1& rural_pre12==1
outreg2 using "output/t6_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A10: EFFECTS OF EDUCATION ON VIOLENCE AGAINST CHILDREN (OVERALL AND WITNESSED VIOLENCE)
********** TABLE A10, PANEL A: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE (OVERALL)
foreach x in hit_child hit_child_often{

**FULL, with interaction, others
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling schooling_others violence_others $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta7a_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_others violence_others) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986_others violence_others after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta7a_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_others violence_others after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_others=after1986 after1986_others) violence_others di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta7a_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_others violence_others) se bdec(3) sdec(3) nor2 nonotes nocons

**Rural, with interaction, others
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' schooling schooling_others violence_others $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta7a_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_others violence_others) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986_others violence_others after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta7a_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_others violence_others after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_others=after1986 after1986_others) violence_others di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta7a_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_others violence_others) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta7a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta7a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta7a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1
outreg2 using "output/ta7a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A10, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO HAVING WITNESSED VIOLENCE
foreach x in hit_child hit_child_often{

**FULL, with interaction, mother
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling schooling_mother mother_violence $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta7b_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_mother mother_violence) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986_mother mother_violence after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta7b_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_mother mother_violence after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_mother=after1986 after1986_mother) mother_violence di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta7b_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_mother mother_violence) se bdec(3) sdec(3) nor2 nonotes nocons

**Rural, with interaction, mother
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' schooling schooling_mother mother_violence $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta7b_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_mother mother_violence) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986_mother mother_violence after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta7b_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_mother mother_violence after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_mother=after1986 after1986_mother) mother_violence di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta7b_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_mother mother_violence) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta7b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta7b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta7b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1
outreg2 using "output/ta7b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

/*
********** TABLE A11: RD TREATMENT EFFECTS IN RURAL CHILDHOOD REGIONS WITH DIFFERENT OPTIMAL BANDWIDTH SELECTION METHODS (FIRST 3 COLUMNS) 
****Note: Please install CCT bandwidth code from: net install rdrobust, from(https://sites.google.com/site/rdpackages/rdrobust/stata) replace
foreach x in schooling{

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==1, bwselect(mserd) scaleregul(0) kernel(uniform)
qui regress `x' after1986 di1* $contr [aw=womenweight] if dif>-e(h_l) & dif<e(h_r) & rural_pre12==1, vce($se)
outreg2 using "output/ta8_`x'", excel  replace ctitle(Linear RD, h bandwidth) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons
	
**reporting bandwidth
qui rdrobust `x' dif if rural_pre12==1, bwselect(mserd) scaleregul(0) kernel(uniform)
outreg2 using "output/ta8_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_l)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if rural_pre12==1, bwselect(mserd) scaleregul(0) kernel(uniform)
qui sum `x' [aw=womenweight] if dif>-e(h_l) & dif<e(h_r) & rural_pre12==1
outreg2 using "output/ta8_`x'", excel append ctitle(Mean) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

/*
foreach x in hit_child hit_child_often agree_beat agree_childbeat pregnancy_age num_children work_lastweek z_income schooling_partner marriage_decision z_physical z_emotional z_depression z_somatic z_nonsomatic{

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(mserd) scaleregul(0) kernel(uniform)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if dif>-e(h_l) & dif<e(h_r) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta8_`x'", excel  replace ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(mserd) scaleregul(0) kernel(uniform)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if dif>-e(h_l) & dif<e(h_r) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta8_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(mserd) scaleregul(0) kernel(uniform)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if dif>-e(h_l) & dif<e(h_r) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta8_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(mserd) scaleregul(0) kernel(uniform)
outreg2 using "output/ta8_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_l)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(mserd) scaleregul(0) kernel(uniform)
qui sum `x' [aw=womenweight] if dif>-e(h_l) & dif<e(h_r) & has_children==1& rural_pre12==1
outreg2 using "output/ta8_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}
*/
*/

********** TABLE A12: EFFECTS OF EDUCATION ON ATTITUDES TOWARD VIOLENCE
********** TABLE A12, PANEL A: RD TREATMENT EFFECTS
foreach x in agree_beat agree_childbeat{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta9a_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta9a_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta9a_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta9a_`x'", excel  append ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta9a_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta9a_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta9a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta9a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta9a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1 & has_children==1
outreg2 using "output/ta9a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A12, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE (OPTIMAL BANDWIDTH)
foreach x in agree_beat agree_childbeat{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta9b_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta9b_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta9b_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta9b_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta9b_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta9b_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta9b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta9b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta9b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1
outreg2 using "output/ta9b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A13: EFFECTS OF EDUCATION ON MENTAL HEALTH OUTCOMES
********** TABLE A13, PANEL A: RD TREATMENT EFFECTS
foreach x in z_depression z_somatic z_nonsomatic{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta10a_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta10a_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta10a_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta10a_`x'", excel  append ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta10a_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta10a_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta10a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta10a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta10a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1 & has_children==1
outreg2 using "output/ta10a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A13, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE (OPTIMAL BANDWIDTH)

foreach x in z_depression z_somatic z_nonsomatic{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta10b_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta10b_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta10b_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta10b_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta10b_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta10b_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta10b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta10b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta10b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1
outreg2 using "output/ta10b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A14: EFFECTS OF EDUCATION ON FERTILITY OUTCOMES
********** TABLE A14, PANEL A: RD TREATMENT EFFECTS
foreach x in pregnancy_age num_children{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif , bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) , vce($se)
outreg2 using "output/ta11a_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif , bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) , vce($se)
outreg2 using "output/ta11a_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif , bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) , vce($se)
outreg2 using "output/ta11a_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) &rural_pre12==1, vce($se)
outreg2 using "output/ta11a_`x'", excel  append ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) &rural_pre12==1, vce($se)
outreg2 using "output/ta11a_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) &rural_pre12==1, vce($se)
outreg2 using "output/ta11a_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif , bwselect(IK)
outreg2 using "output/ta11a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
outreg2 using "output/ta11a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif , bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) 
outreg2 using "output/ta11a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1 
outreg2 using "output/ta11a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A14, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE (OPTIMAL BANDWIDTH)
foreach x in pregnancy_age num_children{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif , bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) , vce($se)
outreg2 using "output/ta11b_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif , bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) , vce($se)
outreg2 using "output/ta11b_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif , bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) , vce($se)
outreg2 using "output/ta11b_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if  rural_pre12==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) &  rural_pre12==1, vce($se)
outreg2 using "output/ta11b_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if  rural_pre12==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) &  rural_pre12==1, vce($se)
outreg2 using "output/ta11b_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if  rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) &  rural_pre12==1, vce($se)
outreg2 using "output/ta11b_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif, bwselect(IK)
outreg2 using "output/ta11b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if  rural_pre12==1, bwselect(IK)
outreg2 using "output/ta11b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif , bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) 
outreg2 using "output/ta11b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if  rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) &  rural_pre12==1
outreg2 using "output/ta11b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A15: EFFECTS OF EDUCATION ON LABOR MARKET OUTCOMES
********** TABLE A15: PANEL A: RD TREATMENT EFFECTS
foreach x in work_lastweek service social_security z_income z_asset{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta12a_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta12a_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta12a_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta12a_`x'", excel  append ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta12a_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta12a_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta12a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta12a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta12a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1 & has_children==1
outreg2 using "output/ta12a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A15, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE (OPTIMAL BANDWIDTH)
foreach x in work_lastweek service social_security z_income z_asset{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta12b_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta12b_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta12b_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta12b_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta12b_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta12b_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta12b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta12b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta12b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1
outreg2 using "output/ta12b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A16: EFFECTS OF EDUCATION ON ON PARTNER CHARACTERISTICS AND MARRIAGE MARKET OUTCOMES
********** TABLE A16, PANEL A: RD TREATMENT EFFECTS
foreach x in schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta13a_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta13a_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta13a_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta13a_`x'", excel  append ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta13a_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta13a_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta13a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta13a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta13a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1 & has_children==1
outreg2 using "output/ta13a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A16, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE (OPTIMAL BANDWIDTH)
foreach x in schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta13b_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta13b_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta13b_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta13b_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta13b_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta13b_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta13b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta13b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta13b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1
outreg2 using "output/ta13b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A17: EFFECTS OF EDUCATION ON SPOUSAL VIOLENCE
********** TABLE A17, PANEL A: RD TREATMENT EFFECTS
foreach x in z_physical z_emotional z_financial{

**FULL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta14a_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta14a_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta14a_`x'", excel  append ctitle(Full sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL SAMPLE
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' schooling $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta14a_`x'", excel  append ctitle(Full sample, OLS) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui regress `x' after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta14a_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1&rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling=after1986) di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1&rural_pre12==1, vce($se)
outreg2 using "output/ta14a_`x'", excel  append ctitle(Rural sample, IV) keep(schooling) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta14a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta14a_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta14a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & rural_pre12==1 & has_children==1
outreg2 using "output/ta14a_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

********** TABLE A17, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE (OPTIMAL BANDWIDTH)
foreach x in z_physical z_emotional z_financial{

**FULL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta14b_`x'", excel  replace ctitle(Full sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta14b_`x'", excel append ctitle(Full sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1, vce($se)
outreg2 using "output/ta14b_`x'", excel  append ctitle(Full sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' schooling schooling_family violence_family $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta14b_`x'", excel  append ctitle(Rural sample, OLS) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui regress `x' after1986_family violence_family after1986 di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta14b_`x'", excel append ctitle(Rural sample, Linear RD) keep(after1986_family violence_family after1986) se bdec(3) sdec(3) nor2 nonotes nocons

**linear RD-2SLS, h bandwidth, with controls
qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui ivregress 2sls `x' (schooling schooling_family=after1986 after1986_family) violence_family di1* $contr [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1, vce($se)
outreg2 using "output/ta14b_`x'", excel  append ctitle(Rural sample, IV) keep(schooling schooling_family violence_family) se bdec(3) sdec(3) nor2 nonotes nocons

**reporting bandwidth
qui rdrobust `x' dif if has_children==1, bwselect(IK)
outreg2 using "output/ta14b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
outreg2 using "output/ta14b_`x'", excel append ctitle(Bandwidth) addstat(BW Loc. Poly. (h), e(h_bw)) adec(0) nonotes nocons

**reporting mean
qui rdrobust `x' dif if has_children==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1
outreg2 using "output/ta14b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons

qui rdrobust `x' dif if has_children==1& rural_pre12==1, bwselect(IK)
qui sum `x' [aw=womenweight] if abs(dif)<e(h_bw) & has_children==1& rural_pre12==1
outreg2 using "output/ta14b_`x'", excel append ctitle(Mean) keep(schooling) addstat(Mean, r(mean)) adec(2) nonotes nocons
}

