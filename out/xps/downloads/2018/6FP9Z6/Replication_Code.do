******ANALYSIS FILE****
clear all
set mem 500m
//cd "C:\Users\David\Dropbox\My Work Documents\Field v. Survey Experiment Paper\Replication Archive"
cd "C:\Users\ddoherty\Dropbox\My Work Documents\Field v. Survey Experiment Paper\Replication Archive"
****USE MASTER FIELD EXP. DATA FILE
use "field_experiments_replication_data.dta", clear

*drop .03% of cases where no record of voting in past 4 GEs according to post-election voter file (not used in Field Experiments as originally reported)
drop if voterscoregeneral==0

**generate IDs for individual voters
gen respid=_n+1000

** relationship between contact and turnout noted in second to last paragraph of article
reg voted contact
reg voted contact_2

***RECODE OUTCOME MEASURE (for Field Exp. 1)
recode liklihood_fe1 (1=4) (2=3) (3=2) (4=1) (*=.), gen(likely_to_vote)
label var likely_to_vote "Intent to Vote (1=Definitely not; 4=Definitely will)"

*** TREATMENT INDICATORS
tab treat, gen(treat_)
drop treat_1
rename treat_2 treat_pos
rename treat_3 treat_neg
label var treat_pos "Positive Mailer Treatment"
label var treat_neg "Negative Mailer Treatment"

**Senate District Indicators
tab sdname, gen(dist_)
drop dist_1
rename dist_2 dist_26
rename dist_3 dist_35
//Drop cases from CO Senate District 35 (see note to Table 1)
drop if dist_35
label var dist_26 "District 26 (1=yes)"

******************************************
*** output FIELD EXPERIMENT 1 sample. 
******************************************
preserve
//Only keep cases surveyed in first field experiment 
reg likely_to_vote  if contact==1
keep if e(sample)
//drop respondents who did not affirm that they were reigstered to vote
drop if registered_fe1==2 | registered_fe1==0 |registered_fe1==.
keep respid treat_neg treat_pos likely_to_vote dist_26 voted
//generate variable to identify experiment (1 = Field Exp. 1)
gen exp=1
save "scratch_data\fe_1.dta", replace
restore

***RECODE OUTCOME MEASURE (for Field Exp. 2)
//first drop FE 1 outcome measure
drop likely_to_vote
recode liklihood (1=4) (2=3) (3=2) (4=1) (*=.), gen(likely_to_vote)
label var likely_to_vote "Intent to Vote (1=Definitely not; 4=Definitely will)"

*** TREATMENT INDICATORS for SECOND EXPERIMENT 
//GENERATE INDICATORS for TREATMENT ASSIGNMENT FROM FIELD EXPERIMENT 1 FOR FIELD EXPERIMENT 2 OBSERVATIONS (Note: Same pool of voters targeted in FE 1 and FE 2; Doherty and Adler find no evidence of FE 1 treatment FX enduring to FE 2)
rename treat_pos first_treat_pos
rename treat_neg first_treat_neg
replace first_treat_pos=0 if first_treat_pos==.
replace first_treat_neg=0 if first_treat_neg==.
label var first_treat_pos "Positive Mailer Treatment (1st round)"
label var first_treat_neg "Negative Mailer Treatment (1st round)"

//THEN GENERATE INDICATORS FOR TREATMENT ASSIGNMENT IN FIELD EXPERIMENT 2
tab treat_new, gen(treat_)
drop treat_1
rename treat_2 treat_pos
rename treat_3 treat_neg
rename treat_4 treat_con
label var treat_pos "Positive Mailer Treatment"
label var treat_neg "Negative Mailer Treatment"

//DROP RESPONDENTS ASSIGNED TO "CONTRAST MAILER" CONDITION in FE 2 (SEE Note to Table 1)
drop if treat_con==1

*** SAMPLE RESTRICTION FOR FIELD EXPERIMENT 2. 
//restrict to those contacted w/Outcome measure available
reg likely_to_vote if contact_2==1
keep if e(sample)
//as in Doherty/Adler 2014, drop observations where telephone respondent did not confirm they were registered to vote
drop if registered==2 | registered==0 |registered==.
//drop variables not needed for analysis
keep respid treat_neg treat_pos first_treat_pos first_treat_neg likely_to_vote dist_26 voted
//generate variable to identify experiment (2 = Field Exp. 2)
gen exp=2
append using "scratch_data\fe_1.dta"
label var voted "Validated Turnout (1=yes)"
save "scratch_data\fe_data.dta", replace

//APPENDIX Table A1: Relationship between Intent to Turnout and Validated Turnout: Field Experiments
table likely_to_vote exp, c(mean voted)
//statistically significant relationships
pwcorr voted likely_to_vote if exp==1, sig
pwcorr voted likely_to_vote if exp==2, sig


****************************************
****** MTURK EXPERIMENT ****************
****************************************
use "mturk_replication_data.dta", clear

keep yob educ income r_* female pid_stem turnout_2008 turnout_2010 likely_to_vote condition image reg_vote already_voted mail_last_month respid pid_lean


** DEMOGRAPHICS
gen age=2012-yob
label var age "Age (in years)"

label var educ "Education (1=No HS; 6=post-grad)"
gen income_mis=income==15
label var income "Income (1-14; 15=RF)"
label var income_mis "Income Refused"

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

label var female "Female=1"

** Political Pre-treatment
tab pid_stem, gen(pid_)
rename pid_1 democrat
label var democrat "Democrat (1=yes)"
rename pid_2 republican
label var republican "Republican (1=yes)"
gen independent=pid_3+pid_4
drop pid_3 pid_4
label var independent "Independent/Other (1=yes)"

*** past turnout
gen likely_voter=(turnout_2008==1)|(turnout_2010==1)
label var likely_voter "Voted in 2008 or 2010 (1=yes)"

gen vote_2008=turnout_2008==1
gen vote_2010=turnout_2010==1
label var vote_2008 "Voted in 2008 (1=yes)"
label var vote_2010 "Voted in 2010 (1=yes)"

label var mail_last_month "Pieces of political mail each week? (0 = None; 4 = 10+)"

*** OUTCOME
replace likely_to_vote=abs(likely_to_vote-5)
label var likely_to_vote "Likely to Vote in 2012 (1=Definitely no; 4=definitely yes)"

** TREATMENTS
tab condition, gen(treat_)
gen lang=0
gen newell=0
gen kerber=0
gen hudak=0
replace lang=1 if image=="<img src=https://surveygizmolibrary.s3.amazonaws.com/library/71534/lang.gif />"
replace newell=1 if image=="<img src=https://surveygizmolibrary.s3.amazonaws.com/library/71534/newell.gif />"
replace kerber=1 if image=="<img src=https://surveygizmolibrary.s3.amazonaws.com/library/71534/kerber.gif />"
replace hudak=1 if image=="<img src=https://surveygizmolibrary.s3.amazonaws.com/library/71534/hudak.gif />"
replace lang=0 if treat_2==1
replace newell=0 if treat_2==1
replace kerber=0 if treat_2==1
replace hudak=0 if treat_2==1

gen treat_neg=newell+hudak
gen treat_pos=lang+kerber
label var treat_neg "Negative Mailer Treatment"
label var treat_pos "Positive Mailer Treatment"


**survey experiment sample restrictions
gen insample=1
* exclude from core sample if not registered
replace insample=0 if already_voted==1
replace insample=0 if reg_vote!=1
* exclude from core sample if demographics or outcome missing
reg likely_to_vote female age pid_stem turnout_2010 turnout_2008 educ income income_mis r_*  mail_last_month
replace insample=0 if e(sample)==0

//set directorty to output tables
cd "tables"


*** Table A2: Summary Statistics: Survey Experiment
outsum likely_to_vote treat_pos treat_neg female age educ income income_mis r_* vote_2008 vote_2010 mail_last_month if insample==1 using "A2_summary_mturk", replace bracket ctitle(Full Sample) 
outsum likely_to_vote treat_pos treat_neg female age educ income income_mis r_* vote_2008 vote_2010 mail_last_month if likely_voter==1 & insample==1 using "A2_summary_mturk", append bracket ctitle(Likely Voters [Voted in 2008 or 2010]) 

***BALANCE TEST (see note to Table A2)
*balance check outcome variable
gen balance_treat=0
replace balance_treat=1 if treat_neg==1
replace balance_treat=2 if treat_pos==1
//Balance test: core sample
mlogit balance_treat democrat republican vote_2008 vote_2010 female age educ income income_mis r_* mail_last_month if insample==1
//Balance test: likely voters only
mlogit balance_treat democrat republican vote_2008 vote_2010 female age educ income income_mis r_* mail_last_month if likely_voter & insample==1

**STACK Field Exp DATA
append using "..\scratch_data\fe_data.dta"

//replace variable identifying experiments with 0 for survey experiment
replace exp=0 if exp==.
//create indicators for experiments 
tab exp, gen(exp_)
rename exp_1 survey_experiment
rename exp_2 fe_1
rename exp_3 fe_2
label var fe_1 "First Field Experiment"
label var fe_2 "Second Field Experiment"

*** Treatment x Experiment Interactions 
foreach i in treat_pos treat_neg{
gen `i'Xfe_1=`i'*fe_1
gen `i'Xfe_2=`i'*fe_2
}
label var treat_posXfe_1 "Positive Mailer x Field Experiment 1"
label var treat_posXfe_2 "Positive Mailer x Field Experiment 2"
label var treat_negXfe_1 "Negative Mailer x Field Experiment 1"
label var treat_negXfe_2 "Negative Mailer x Field Experiment 2"

***dummy regression used to improve formatting of figures by making space between markers presented in in figure; no estimates actually reported in figures
reg likely_to_vote age, r
eststo blank

****** REGRESSIONS *******
*** Table A3: Models Mirroring OLS Models Presented in Table A7 (No Sample Restrictions for Survey Experiment)
reg likely_to_vote treat_pos* treat_neg* fe_1 fe_2, r
outreg using "A3_no_sample_restrict", se bracket tdec(3) replace label 

reg likely_to_vote treat_pos* treat_neg* fe_1 fe_2 if (likely_voter==1 | likely_voter==.), r
outreg using "A3_no_sample_restrict", se bracket tdec(3) append label 

reg likely_to_vote treat_pos* treat_neg* fe_1 fe_2 if (democrat==0 | democrat==.) & (republican==0 | republican==.), r
outreg using "A3_no_sample_restrict", se bracket tdec(3) append label 

reg likely_to_vote treat_pos* treat_neg* fe_1 fe_2 if (likely_voter==1 | likely_voter==.) & (democrat==0 | democrat==.) & (republican==0 | republican==.), r
outreg using "A3_no_sample_restrict", se bracket tdec(3) append label 

//restrict sample to those who did not affirm that they were registered to vote and those who did not provide responses to all balance test items
drop if insample==0

//preserve so can return to core set of interactions
preserve
*****Table A4: Regression Models (Party Moderation; Survey Experiment Only)
**survey exp only interactions
drop treat_posX* treat_negX*
foreach i in democrat republican independent income income_mis educ female age r_white mail_last_month{
gen treat_posX`i'=treat_pos*`i'
gen treat_negX`i'=treat_neg*`i'
local label : variable label `i'
label var treat_posX`i' "Positive Mailer x `label'"
label var treat_negX`i' "Negative Mailer x `label'"
}

reg likely_to_vote treat_pos treat_neg democrat republican treat_posXdemocrat treat_negXdemocrat treat_posXrepublican treat_negXrepublican, r
outreg using "A4_party_regressions", se bracket tdec(3) replace label 

reg likely_to_vote treat_pos treat_neg democrat republican treat_posXdemocrat treat_negXdemocrat treat_posXrepublican treat_negXrepublican if likely_voter, r
outreg using "A4_party_regressions", se bracket tdec(3) append label 

reg likely_to_vote treat_pos treat_neg democrat republican treat_posXdemocrat treat_negXdemocrat treat_posXrepublican treat_negXrepublican *income *income_mis *educ *female *age *r_white *mail_last_month, r
outreg using "A4_party_regressions", se bracket tdec(3) append label 

reg likely_to_vote treat_pos treat_neg democrat republican treat_posXdemocrat treat_negXdemocrat treat_posXrepublican treat_negXrepublican *income *income_mis *educ *female *age *r_white *mail_last_month if likely_voter, r
outreg using "A4_party_regressions", se bracket tdec(3) append label 



****Figure A1: Treatment Effects by Partisanship (Survey Experiment)
reg likely_to_vote treat_pos treat_neg if republican==1, r
eststo republican

reg likely_to_vote treat_pos treat_neg if likely_voter & republican==1, r
eststo republican_lvs

reg likely_to_vote treat_pos treat_neg if democrat==1, r
eststo democrat

reg likely_to_vote treat_pos treat_neg if likely_voter & democrat==1, r
eststo democrat_lvs

reg likely_to_vote treat_pos treat_neg if independent==1, r
eststo indep
reg likely_to_vote treat_pos treat_neg if likely_voter==1 & independent==1, r
eststo indep_lvs

coefplot (indep, msymbol(T) connect(none) mcolor(black)  ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(Independents)) (indep_lvs, msymbol(T) connect(none) mcolor(gs10)  ciopts(lcolor(gs10) lwidth(thin) msize(vtiny))) (blank) (republican, msymbol(S) connect(none) mcolor(black)  ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(Republicans)) (republican_lvs, msymbol(S) connect(none) mcolor(gs10)  ciopts(lcolor(gs10) lwidth(thin) msize(vtiny))) (blank) (democrat, msymbol(D) connect(none) mcolor(black)  ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(Democrats)) (democrat, msymbol(D) connect(none) mcolor(gs10)  ciopts(lcolor(gs10) lwidth(thin) msize(vtiny))) (blank)  , vertical  keep(treat_pos treat_neg)  yline(0, lcolor(black)) legend(order(2 7 12) region(lcolor(white) color(none)) span cols(4)  size(small)) level(95) ytitle("Effect on Intent to Turnout",  size(medsmall)) graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) xscale(lw(none)) ylabel(-.75(.25).25) 
graph export "Fig_A1_treatment_fx_byparty.eps", as(eps) replace

//restore back to core set of interactions
restore

*** Table A5: Outcome Means and Standard Deviations by Experimental Condition
//0 indicator to use in table command
gen null=0
//build three category variable so columns define treatment conditions
gen fulltreat=0
replace fulltreat=1 if treat_pos
replace fulltreat=2 if treat_neg

table null fulltreat if fe_1==1, c(mean likely_to_vote sem likely_to_vote freq)
table null fulltreat if fe_2==1, c(mean likely_to_vote sem likely_to_vote freq)
table null fulltreat if survey_experiment==1, c(mean likely_to_vote sem likely_to_vote freq)
table null fulltreat if likely_voter==1, c(mean likely_to_vote sem likely_to_vote freq)
table null fulltreat if independent==1, c(mean likely_to_vote sem likely_to_vote freq)
table null fulltreat if likely_voter==1 & independent==1, c(mean likely_to_vote sem likely_to_vote freq)

*** Table A6: Ordered Logit Models Mirroring OLS Models Presented in Table A7
ologit likely_to_vote treat_pos* treat_neg* fe_1 fe_2, r
outreg2 using "A6_ologit", se bracket tdec(3) replace label excel

ologit likely_to_vote treat_pos* treat_neg* fe_1 fe_2 if (likely_voter==1 | likely_voter==.), r
outreg2 using "A6_ologit", se bracket tdec(3) append label excel

ologit likely_to_vote treat_pos* treat_neg* fe_1 fe_2 if (democrat==0 | democrat==.) & (republican==0 | republican==.), r
outreg2 using "A6_ologit", se bracket tdec(3) append label excel

ologit likely_to_vote treat_pos* treat_neg* fe_1 fe_2 if (likely_voter==1 | likely_voter==.) & (democrat==0 | democrat==.) & (republican==0 | republican==.), r
outreg2 using "A6_ologit", se bracket tdec(3) append label excel


***Table A7: Regression Models for Estimates Reported in Figure 1 of Manuscript
reg likely_to_vote treat_pos* treat_neg* fe_1 fe_2, r
outreg using "A7_regressions", se bracket tdec(3) replace label 

reg likely_to_vote treat_pos* treat_neg* fe_1 fe_2 if (likely_voter==1 | likely_voter==.), r
outreg using "A7_regressions", se bracket tdec(3) append label 

reg likely_to_vote treat_pos* treat_neg* fe_1 fe_2 if (democrat==0 | democrat==.) & (republican==0 | republican==.), r
outreg using "A7_regressions", se bracket tdec(3) append label 

reg likely_to_vote treat_pos* treat_neg* fe_1 fe_2 if (likely_voter==1 | likely_voter==.) & (democrat==0 | democrat==.) & (republican==0 | republican==.), r
outreg using "A7_regressions", se bracket tdec(3) append label 


***ESTIMATES FOR FIGURE 1
reg likely_to_vote treat_pos treat_neg if fe_1==1, r
eststo fe1
reg likely_to_vote treat_pos treat_neg if fe_2==1, r
eststo fe2
reg likely_to_vote treat_pos treat_neg if survey_experiment==1, r
eststo pooled
reg likely_to_vote treat_pos treat_neg if likely_voter==1, r
eststo pooled_lvs
reg likely_to_vote treat_pos treat_neg if independent==1, r
eststo indep
reg likely_to_vote treat_pos treat_neg if likely_voter==1 & independent==1, r
eststo indep_lvs

***********Figure 1: Effects of Mailer Treatments on Intent to Turnout
coefplot (fe1,  msymbol(O) connect(none) mcolor(black) ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(Field Experiment 1)) (fe2,  msymbol(T) connect(none) mcolor(black) ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(Field Experiment 2)) (blank) (pooled,  msymbol(Oh) connect(none) mcolor(black) ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(Survey Experiment: Registered Voters)) (pooled_lvs,  msymbol(Oh) connect(none) mcolor(gs10) ciopts(lcolor(gs10) lwidth(thin) msize(vtiny)) label(Survey Exp.: Likely Voters)) (blank) (indep,  msymbol(Sh) connect(none) mcolor(black) ciopts(lcolor(black) lwidth(thin) msize(vtiny)) label(Survey Experiment: Independents)) (indep_lvs,  msymbol(Sh) connect(none) mcolor(gs10) ciopts(lcolor(gs10) lwidth(thin) msize(vtiny)) label(Survey Exp.: Independent Likely Voters))  , vertical  keep(treat_pos treat_neg)  yline(0, lcolor(black)) legend(order(2 7 4 12) region(lcolor(white) color(none)) span cols(2)  size(small)) level(95) ytitle("Effect on Intent to Turnout",  size(medsmall)) graphregion(fcolor(white) lcolor(none) ilcolor(none) color(white) lwidth(large)) xscale(lw(none))  ylabel(-.75(.25).25) 
graph export "fig_1_treatment_fx.eps", as(eps) replace
