set more off
//SET DIRECTORY TO TABLES FOLDER
cd "...\tables"
//Open data, one directory up from tables
use "..\replication_Conditional_Norms_JOP.dta", clear

***DEMOGRAPHICS
gen age=2011-yob if replication==0
replace age=2016-yob if replication==1
label var age "Age (in years)"

label var educ "Education (1=No HS; 6=post-grad)"

foreach i in white black hispanic asian nativeam mixed other{
 replace r_`i'=0 if r_`i'==.
 replace r_`i'=1 if r_`i'!=0
 label var r_`i' "`i' = 1"
}
replace r_other=r_asian+r_nativeam+r_mixed+r_other
replace r_other=1 if r_other>1
label var r_other "Other race=1"
label var r_white "White = 1"
label var r_black "Black = 1"
label var r_hispanic "Hispanic = 1"
drop r_asian r_nativeam r_mixed 
recode female (1=0) (2=1) if replication
label var female "Female=1"

label var polinterest "Interest in Politics (1-3)"


******************************************
** BALANCE TESTS *************************
******************************************
* define samples
foreach i in battleground competitive social{
reg eval_`i' female educ r_white polinterest pid age
gen insample_`i'=e(sample)
}
gen insample=insample_battleground+insample_competitive+ insample_social
replace insample=1 if insample==2
foreach i in female educ r_white polinterest pid age{
count if `i'==.
}


foreach i in battleground competitive social{
local d=4
if ("`i'"=="competitive"){
local d=3
}
gen cond_`i'=.
forvalues c=1/`d'{
replace cond_`i'=`c' if `i'_1_D`c'==1
}
}

* Balance tests
foreach i in battleground competitive social {
mlogit cond_`i' female educ r_white polinterest pid age if insample_`i'==1 & replication==0
mlogit cond_`i' female educ r_white polinterest pid age if insample_`i'==1 & replication==1
}

***********ATTRITION CHECKS
*generate indicators for being assigned to particular vignette
gen assign_social=(vignette_order==0 &  votingbehavior1_treat==1)|(vignette_order==1 &  votingbehavior1_treat==1)
gen assign_battleground=(vignette_order==1 &  votingbehavior2_treat==0)|(vignette_order==0 &  votingbehavior2_treat==0)
gen assign_competitive=(vignette_order==1 &  votingbehavior2_treat==1)|(vignette_order==0 &  votingbehavior2_treat==1)

foreach i in battleground competitive social{
gen attrit_`i'=assign_`i' & eval_`i'==. 
}
foreach i in battleground competitive social{
reg attrit_`i' `i'_1_D*  if replication==0
reg attrit_`i' `i'_1_D*  if replication==1
}

foreach i in battleground competitive social{
qui count if insample_`i'==0 & replication==0 & assign_`i'==1
local exclude=r(N)
qui count if replication==0 & assign_`i'==1
disp `exclude'/r(N) 
qui count if insample_`i'==0 & replication==1 & assign_`i'==1
local exclude=r(N)
qui count if replication==1 & assign_`i'==1
disp `exclude'/r(N) 
}


******************************************
** BASIC REGRESSIONS *********************
******************************************
*test "only vote in BG" v. "don't vote if not BG"
reg eval_battleground battleground_1_D* battleground_oth_D1 battleground_oth_D13 battleground_oth_D2 battleground_oth_D4 battleground_oth_D3 battleground_oth_D5 battleground_oth_D6 battleground_oth_D8 battleground_oth_D7 battleground_oth_D12 battleground_oth_D9 battleground_oth_D11 battleground_oth_D14 battleground_oth_D15 battleground_oth_D10 if insample_battleground==1 & replication==0, r
test battleground_1_D1==battleground_1_D3
reg eval_battleground battleground_1_D* battleground_oth_D1 battleground_oth_D13 battleground_oth_D2 battleground_oth_D4 battleground_oth_D3 battleground_oth_D5 battleground_oth_D6 battleground_oth_D8 battleground_oth_D7 battleground_oth_D12 battleground_oth_D9 battleground_oth_D11 battleground_oth_D14 battleground_oth_D15 battleground_oth_D10 if insample_battleground==1 & replication==1, r
test battleground_1_D1==battleground_1_D3

* no difference between "only vote in BG" and "don't vote if not BG" so collapse
replace battleground_1_D1=battleground_1_D1+battleground_1_D3
drop battleground_1_D3
label var battleground_1_D1 "Vote When State Likely to Determine Outcome"

* Drop seemingly least favorable behaviors
drop competitive_1_D1 
drop battleground_1_D2
drop social_1_D1

outsum eval_1 r_white r_black r_hispanic r_other age female educ pid using "A1_summary_stats" if insample & replication==0, bracket replace
outsum eval_1 r_white r_black r_hispanic r_other age female educ pid using "A1_summary_stats" if insample & replication==1, bracket append

foreach i in battleground competitive social{
outsum eval_`i' r_white r_black r_hispanic r_other age female educ pid if insample_`i'==1 & replication==0 using "A1_summary_stats", bracket append
outsum eval_`i' r_white r_black r_hispanic r_other age female educ pid if insample_`i'==1 & replication==1 using "A1_summary_stats", bracket append

reg eval_`i' `i'_1_D* `i'_oth_D* if insample_`i'==1 & replication==0, r
if "`i'"=="battleground"{
outreg using "A2_experiments.out", bracket se replace rdec(3) 
}
else{
outreg using "A2_experiments.out", bracket se append rdec(3) 
}
reg eval_`i' `i'_1_D* `i'_oth_D* if insample_`i'==1 & replication==1, r
outreg using "A2_experiments.out", bracket se append rdec(3) 

reg eval_`i' `i'_1_D* `i'_oth_D* if insample_`i'==1 & replication==1, r
if "`i'"=="battleground"{
outreg using "M1_experiments_citizen.out", bracket se replace rdec(3) 
}
else{
outreg using "M1_experiments_citizen.out", bracket se append rdec(3) 
}
reg eval_`i'_citizen `i'_1_D* `i'_oth_D* if insample_`i'==1 & replication==1, r
outreg using "M1_experiments_citizen.out", bracket se append rdec(3) 


***robust to inclusion of all cases (no sample restrictions)
reg eval_`i' `i'_1_D* `i'_oth_D* if replication==0, r
if "`i'"=="battleground"{
outreg using "A3_experiments_robust.out", bracket se replace rdec(3) 
}
else{
outreg using "A3_experiments_robust.out", bracket se append rdec(3) 
}
reg eval_`i' `i'_1_D* `i'_oth_D* if replication==1, r
outreg using "A3_experiments_robust.out", bracket se append rdec(3) 
}

****INTERACTIONS BY DATASET (Variation in treatment FX across samples?)
foreach i in battleground competitive social{
foreach b of varlist `i'_1_D* `i'_oth_D* {
gen `b'XRep=`b'*replication
local label : variable label `b'
label var `b'XRep "`label' x Study 2"
}
reg eval_`i' `i'_1_D* `i'_oth_D* replication if insample_`i'==1 , r
if "`i'"=="battleground"{
test `i'_1_D1XRep `i'_1_D4XRep
}
if "`i'"=="competitive"{
test `i'_1_D2XRep `i'_1_D3XRep
}
if "`i'"=="social"{
test `i'_1_D2XRep `i'_1_D3XRep `i'_1_D4XRep
}
local pval=r(p)

if "`i'"=="battleground"{
outreg `i'_1_D* replication using "A5_experiments_interact.out", bracket se replace rdec(3) adec(3) addstat("Joint Significance of Interactions (p-value)",`pval')
}
else{
outreg `i'_1_D* replication using "A5_experiments_interact.out", bracket se append rdec(3) adec(3) addstat("Joint Significance of Interactions (p-value)",`pval')
}
drop *XRep
}

****** CIs FOR FIGURE
foreach i in battleground competitive social{
reg eval_`i' `i'_1_D* `i'_oth_D*  if insample_`i'==1 & replication==0, r
reg eval_`i' `i'_1_D* `i'_oth_D*  if insample_`i'==1 & replication==1, r
}


***FOR BENCHMARKING FX SIZES
foreach i in battleground competitive social{

reg eval_`i' `i'_1_D* `i'_oth_D*   if insample_`i'==1 & replication==0, r
if "`i'"=="battleground"{
disp "TAXES"
lincom `i'_oth_D15- `i'_oth_D14
test (`i'_oth_D15- `i'_oth_D14)==`i'_1_D4
}
if "`i'"=="competitive"{
disp "RECYCLING"
lincom -`i'_oth_D10
test (-`i'_oth_D10)==`i'_1_D2
disp "TAXES"
test (`i'_oth_D15- `i'_oth_D14)==`i'_1_D2
}
reg eval_`i' `i'_1_D* `i'_oth_D*  if insample_`i'==1 & replication==1, r
if "`i'"=="battleground"{
disp "TAXES"
lincom `i'_oth_D15- `i'_oth_D14
test (`i'_oth_D15- `i'_oth_D14)==`i'_1_D4
}
if "`i'"=="competitive"{
disp "RECYCLING"
lincom -`i'_oth_D10
test (-`i'_oth_D10)==`i'_1_D2
disp "TAXES"
test (`i'_oth_D15- `i'_oth_D14)==`i'_1_D2
}
}

**************MEAN REPLACEMENT ON MISSING
foreach i in battleground competitive social{
qui sum eval_`i'
replace eval_`i'=r(mean) if eval_`i'==.
reg eval_`i' `i'_1_D* `i'_oth_D* if replication==0, r
if "`i'"=="battleground"{
outreg using "A4_experiments_mean.out", bracket se replace rdec(3) 
}
else{
outreg using "A4_experiments_mean.out", bracket se append rdec(3) 
}
reg eval_`i' `i'_1_D* `i'_oth_D* if replication==1, r
outreg using "A4_experiments_mean.out", bracket se append rdec(3) 
}
