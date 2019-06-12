/* 	File Name: appendix.do
	Data: SFGSII_mdr_exp_paper_forR.dta
	Author: Mark Richardson
	Purpose: Execute analysis for the appendix to "Politicization and Expertise: Exit, Effort, and Investment"
	Output: Tables for the appendix
	Date: 05/13/2017
*/

*Note: Code is in order by section of the appendix, except code for Sections 9 and 10 are in a seperate do file and code for Section 12 is at the end of this do file.


use G:/Data/mdr/expertise_paper/SFGSII_mdr_exp_paper_forR.dta, clear

*********************************************************
*Tables of joint distributions - Section 3
*********************************************************

*politicization and exit
tab politicized_app leave_like if exp_drop==0, row
oprobit politicized_app leave_like if exp_drop==0, cluster(office)

*politicization and exit, model
tab politicized_app leave_like if sample3==1, row
oprobit politicized_app leave_like if sample3==1, cluster(office)

*politicization and investment - all
tab politicized_app inv_outside  if exp_drop==0, row
oprobit inv_outside politicized_app if exp_drop==0, cluster(office)

*politicization and sme - all
tab politicized_app inv_sme  if exp_drop==0, row
oprobit inv_sme politicized_app if exp_drop==0, cluster(office)

*politicization and training - all
tab politicized_app inv_train  if exp_drop==0, row
oprobit inv_train politicized_app if exp_drop==0, cluster(office)

*politicization and investment - all, model
tab politicized_app inv_outside  if sample_inv_out==1, row
oprobit inv_outside politicized_app if sample_inv_out==1, cluster(office)

*politicization and sme - all, model
tab politicized_app inv_sme  if sample_inv_sme==1, row
oprobit inv_sme politicized_app if sample_inv_sme==1, cluster(office)

*politicization and training - all, model
tab politicized_app inv_train  if sample_inv_train==1, row
oprobit inv_train politicized_app if sample_inv_train==1, cluster(office)

*********************************************************
*Controlling for the Value of Salary - Section 7
*********************************************************

*Table2
*Model 3
oprobit leave_likelihood politicized_app div_ip value_policy value_salary approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_3
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample3==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample3==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & sample3==1
sum match

drop m1-m4 match pred max sample_pr

*Model 4
reg workhours politicized_app div_ip value_policy value_salary approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_4

*Model 5
oprobit inv_outside politicized_app div_ip value_policy value_salary approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_pr = e(sample)


foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 6
oprobit inv_sme politicized_app div_ip value_policy value_salary approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 7
oprobit inv_training politicized_app div_ip value_policy value_salary approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr


*Model 8
reg investment_all politicized_app div_ip value_policy value_salary approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\apdx_salary",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*********************************************************
*Investment Models not in main text - Section 8
*********************************************************

*read
oprobit inv_read politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_read
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*academic
oprobit inv_academic politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_academic
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*conferences
oprobit inv_conferences politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_conferences
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

***************************************************************************************************************************
outreg2 [model_inv_read model_inv_academic model_inv_conferences] using "C:\Users\mdr\Dropbox\Papers\expertise\Paper\Tables\apdx_inv_main",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*control for salary
oprobit inv_read politicized_app div_ip value_policy value_salary approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)

oprobit inv_academic politicized_app div_ip value_policy value_salary  approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)

oprobit inv_conferences politicized_app div_ip value_policy value_salary  approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)

*********************************************************
*Subsetting to rulemakers - Section 13.1
*********************************************************

*table of participation by rulemakers
tab job_rule inv_read if exp_drop==0, chi2 row
tab job_rule inv_outside if exp_drop==0, chi2 row
tab job_rule inv_sme if exp_drop==0, chi2 row
tab job_rule inv_academic if exp_drop==0, chi2 row
tab job_rule inv_training if exp_drop==0, chi2 row
tab job_rule inv_conferences if exp_drop==0, chi2 row


*participation read
gen rn_read = 0 if inv_read==0|inv_read==1
replace rn_read=1 if inv_read==2|inv_read==3|inv_read==4|inv_read==5

tab inv_read rn_read if exp_drop==0

prtest rn_read  if exp_drop==0, by(job_rule)

*participation outside
gen rn_outside = 0 if inv_outside==0|inv_outside==1
replace rn_outside=1 if inv_outside==2|inv_outside==3|inv_outside==4|inv_outside==5

tab inv_outside rn_outside if exp_drop==0

prtest rn_outside  if exp_drop==0, by(job_rule)

*participation sme
gen rn_sme = 0 if inv_sme==0|inv_sme==1
replace rn_sme=1 if inv_sme==2|inv_sme==3|inv_sme==4|inv_sme==5

tab inv_sme rn_sme if exp_drop==0

prtest rn_sme  if exp_drop==0, by(job_rule)

*participation academic
gen rn_academic = 0 if inv_academic==0|inv_academic==1
replace rn_academic=1 if inv_academic==2|inv_academic==3|inv_academic==4|inv_academic==5

tab inv_academic rn_academic if exp_drop==0

prtest rn_academic  if exp_drop==0, by(job_rule)

*participation conferences
gen rn_conf = 0 if inv_conferences==0|inv_conferences==1
replace rn_conf=1 if inv_conferences==2|inv_conferences==3

tab inv_conf rn_conf if exp_drop==0

prtest rn_conf  if exp_drop==0, by(job_rule)

*participation training
gen rn_train = 0 if inv_training==0|inv_training==1
replace rn_train=1 if inv_training==2|inv_training==3

tab inv_train rn_train if exp_drop==0

prtest rn_train  if exp_drop==0, by(job_rule)

*Table of investment for rulemakers ********************
*read
oprobit inv_read politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)
est store model_read
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*outside
oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)
est store model_outside
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*sme
oprobit inv_sme politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)
est store model_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*academic
oprobit inv_academic politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)
est store model_academic
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*training
oprobit inv_training politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)
est store model_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

*conferences
oprobit inv_conferences politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)
est store model_conferences
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

reg investment_rule politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)
est store model_fact_rule

***************************************************************************************************************************
outreg2 [model_read model_outside model_sme model_academic model_training model_conferences model_fact_rule] using "C:\Users\mdr\Dropbox\Papers\expertise\Paper\Tables\apdx_rule",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*estiamte individual investment models with an interaction*************************
*read
oprobit inv_read c.politicized_app##i.job_rule div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_read
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*outside
oprobit inv_outside c.politicized_app##i.job_rule div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_outside
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*sme
oprobit inv_sme c.politicized_app##i.job_rule div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*academic
oprobit inv_academic c.politicized_app##i.job_rule div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_academic
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*training
oprobit inv_training c.politicized_app##i.job_rule div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

*conferences
oprobit inv_conferences c.politicized_app##i.job_rule div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_conferences
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

***************************************************************************************************************************
outreg2 [model_read model_outside model_sme model_academic model_training model_conferences] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\apdx_rule_intx",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************


*relax appointee response rate restriction

*outside
oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.1 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)

oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if other==0 & exp_drop==0 & job_rule==1, cluster(office)

*conferences
oprobit inv_conferences politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.1 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)

oprobit inv_conferences politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if other==0 & exp_drop==0 & job_rule==1, cluster(office)

*factor
reg investment_rule politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.1 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, cluster(office)

reg investment_rule politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if other==0 & exp_drop==0 & job_rule==1, cluster(office)

*********************************************************
*Agency mission - Section 13.1
*********************************************************

rename office agency

*merge in mission
merge m:1 agency using C:/Users/richar33/Dropbox/Papers/expertise/Data/mission.dta

tab agency if _merge==2 //okay

rename agency office

xtset mission

*estimate models with mission fe
oprobit leave_likelihood politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire i.mission ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust
est store model_3
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample3==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample3==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & sample3==1
sum match

drop m1-m4 match pred max sample_pr

xtreg workhours politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust fe
est store model_4

oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app  i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust
est store model_inv_outside_exp
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

oprobit inv_sme politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app  i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

oprobit inv_training politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app  i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

xtreg investment_all politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust fe
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\apdx_t2_mission",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*check other investment behavior - baseline
oprobit inv_read politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app  i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust
est store model_inv_training

oprobit inv_academic politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app  i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust
est store model_inv_training

oprobit inv_conferences politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app  i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust
est store model_inv_training

*look for conditional effects for above average

*create averages
foreach i of varl inv_*{
egen avg_`i' = mean(`i') if exp_drop==0
egen mavg_`i' = mean(`i') if exp_drop==0, by(mission)
}

*create difference
foreach i of varl inv_*{
gen dif_`i' = mavg_`i' - avg_`i'
}

oprobit inv_read c.politicized_app##c.dif_inv_read div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_read
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*outside
oprobit inv_outside c.politicized_app##c.dif_inv_outside div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_outside
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*sme
oprobit inv_sme c.politicized_app##c.dif_inv_sme div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*academic
oprobit inv_academic c.politicized_app##c.dif_inv_academic div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_academic
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*training
oprobit inv_training c.politicized_app##c.dif_inv_training div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

*conferences
oprobit inv_conferences c.politicized_app##c.dif_inv_conferences div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_conferences
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

***************************************************************************************************************************
outreg2 [model_read model_outside model_sme model_academic model_training model_conferences] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\apdx_mission_intx",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************


*robustness of rulemaker models
oprobit inv_read politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_sme politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_academic politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_training politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_conferences politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

xtreg investment_rule politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, vce(robust)

*robustness of rulemaker models - relax appointee restriction to solve chi2 var-cov matrix problem
oprobit inv_read politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.10 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.10 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_sme politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.10 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_academic politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.10 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_training politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.10 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

oprobit inv_conferences politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.mission ///
if prop_app_ip>=0.10 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, robust

xtreg investment_rule politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.10 & prop_app_ip!=. & other==0 & exp_drop==0 & job_rule==1, vce(robust)

*create mission-level data set for plotting
keep if exp_drop==0
gen pop=1
collapse inv_* (count) n_read=inv_read n_outside=inv_outside_exp n_sme=inv_sme n_academic=inv_academic n_training=inv_training n_conferences=inv_conferences pop ///
(semean) se_read=inv_read se_outside=inv_outside_exp se_sme=inv_sme se_academic=inv_academic se_training=inv_training se_conferences=inv_conferences, by(mission)

list mission pop

drop if mission==.

decode mission, gen(m_text)

save G:\Data\mdr\expertise_paper\SFGSII_mdr_exp_mission.dta, replace

use G:/Data/mdr/expertise_paper/SFGSII_mdr_exp_paper_forR.dta, clear

*********************************************************
*Appointee response rate - Section 14.1
*********************************************************

*models of politicization - no restriction
oprobit politicized_app div_ip ses yrs_all_pos contact_app if other==0 & exp_drop==0, cluster(office)
est store model_1
gen pr_sample=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m9) if pr_sample==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & pr_sample==1
}

gen match=0 if pr_sample==1
replace match=1 if pred==politicized_app & pr_sample==1
sum match

drop m1-m9 match pred max pr_sample

*model2
oprobit politicized_app c.div_ip##c.div_ip ses yrs_all_pos contact_app if other==0 & exp_drop==0, cluster(office)
est store model_2
gen pr_sample=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m9) if pr_sample==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & pr_sample==1
}

gen match=0 if pr_sample==1
replace match=1 if pred==politicized_app & pr_sample==1
sum match

drop m1-m9 match pred max pr_sample

*require 5 appointees
oprobit politicized_app div_ip ses yrs_all_pos contact_app if n_app_ip>=5 & n_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_3
gen pr_sample=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m9) if pr_sample==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & pr_sample==1
}

gen match=0 if pr_sample==1
replace match=1 if pred==politicized_app & pr_sample==1
sum match

drop m1-m9 match pred max pr_sample

*model 2
oprobit politicized_app c.div_ip##c.div_ip ses yrs_all_pos contact_app if n_app_ip>=5 & n_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_4
gen pr_sample=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m9) if pr_sample==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & pr_sample==1
}

gen match=0 if pr_sample==1
replace match=1 if pred==politicized_app & pr_sample==1
sum match

drop m1-m9 match pred max pr_sample

***************************************************************************************************************************
outreg2 [model_1 model_2 model_3 model_4] using "C:\Users\mdr\Dropbox\Papers\expertise\Paper\Tables\apdx_pol_app_restriction",  tex(frag) replace dec(2) ///
label sortvar(politicized_app div_ip ses yrs_all_pos contact_app)
***************************************************************************************************************************

*Table2 - no restriction
*Model 3
oprobit leave_likelihood politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if other==0 & exp_drop==0, cluster(office)
est store model_3
gen pr_sample = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m4) if pr_sample==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & pr_sample==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & pr_sample==1
sum match

drop m1-m4 match pred max pr_sample

*Model 4
reg workhours politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if other==0 & exp_drop==0, cluster(office)
est store model_4

*Model 5
oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if other==0 & exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 6
oprobit inv_sme politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if other==0 & exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 7
oprobit inv_training politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if other==0 & exp_drop==0, cluster(office)
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr


*Model 8
reg investment_all politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if other==0 & exp_drop==0, cluster(office)
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\mdr\Dropbox\Papers\expertise\Paper\Tables\apdx_inv_no_rest",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*Table2 - at least 5 appointees
*Model 3
oprobit leave_likelihood politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if n_app_ip>=5 & n_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_3
gen pr_sample = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m4) if pr_sample==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & pr_sample==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & pr_sample==1
sum match

drop m1-m4 match pred max pr_sample

*Model 4
reg workhours politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if n_app_ip>=5 & n_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_4

*Model 5
oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if n_app_ip>=5 & n_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 6
oprobit inv_sme politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if n_app_ip>=5 & n_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 7
oprobit inv_training politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if n_app_ip>=5 & n_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr


*Model 8
reg investment_all politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if n_app_ip>=5 & n_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\mdr\Dropbox\Papers\expertise\Paper\Tables\apdx_5_app",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************


*********************************************************
*Agency fixed effects - Section 14.1
*********************************************************

*encode office for fe
encode office, gen(office_fe)

*set the panel variable
xtset office_fe

*model1
oprobit politicized_app div_ip ses yrs_all_pos contact_app i.office_fe if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust
est store model_1

meoprobit politicized_app div_ip ses yrs_all_pos contact_app if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0 || office:, vce(robust)

*model2
oprobit politicized_app c.div_ip##c.div_ip ses yrs_all_pos contact_app i.office_fe if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust
est store model_2

meoprobit politicized_app c.div_ip##c.div_ip ses yrs_all_pos contact_app if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0 || office:, vce(robust)

***************************************************************************************************************************
outreg2 [model_1 model_2] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\apdx_fe_t1",  tex(frag) replace dec(2) ///
label sortvar(politicized_app div_ip ses yrs_all_pos contact_app)
***************************************************************************************************************************

*model 3
egen x=count(sample3) if sample3==1, by(office)

oprobit leave_likelihood politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire i.office_fe ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0 & x>=5 & x!=., robust
est store model_3

*get number of groups
meoprobit leave_likelihood politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0 & x>=5 & x!=. || office:, vce(robust)

drop x

*model 4
xtreg workhours politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust fe
est store model_4

*model 5
egen x=count(sample_inv_outside) if sample_inv_outside==1, by(office)

oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.office_fe ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & x>=5 & x!=., robust
est store model_inv_outside_exp

meoprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & x>=5 & x!=. || office: , vce(robust)

drop x

*model 6
egen x=count(sample_inv_sme) if sample_inv_sme==1, by(office)

oprobit inv_sme politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.office_fe ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & x>=5 & x!=., robust
est store model_inv_sme

meoprobit inv_sme politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & x>=5 & x!=. || office: , vce(robust)

drop x

*model 7
egen x=count(sample_inv_training) if sample_inv_training==1, by(office)

oprobit inv_training politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app i.office_fe ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & x>=5 & x!=., robust
est store model_inv_training

meoprobit inv_training politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0 & x>=5 & x!=. || office:, vce(robust)

drop x

*model 8
xtreg investment_all politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust fe
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\mdr\Dropbox\Papers\expertise\Paper\Tables\apdx_fe_t2",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*********************************************************
*Alternative measures of preference divergence - Section 14.3
*********************************************************

*models of politicization - divergence with obama
oprobit politicized_app div_obama ses yrs_all_pos contact_app if exp_drop==0, cluster(office)
est store model_1
gen pr_sample=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m9) if pr_sample==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & pr_sample==1
}

gen match=0 if pr_sample==1
replace match=1 if pred==politicized_app & pr_sample==1
sum match

drop m1-m9 match pred max pr_sample

*model2
oprobit politicized_app c.div_obama##c.div_obama ses yrs_all_pos contact_app if exp_drop==0, cluster(office)
est store model_2
gen pr_sample=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m9) if pr_sample==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & pr_sample==1
}

gen match=0 if pr_sample==1
replace match=1 if pred==politicized_app & pr_sample==1
sum match

drop m1-m9 match pred max pr_sample

*models of politicization - divergence regulations
oprobit politicized_app div_reg ses yrs_all_pos contact_app if prop_app_reg>=0.15 & prop_app_reg!=. & exp_drop==0, cluster(office)
est store model_3
gen pr_sample=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m9) if pr_sample==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & pr_sample==1
}

gen match=0 if pr_sample==1
replace match=1 if pred==politicized_app & pr_sample==1
sum match

drop m1-m9 match pred max pr_sample

*model2
oprobit politicized_app c.div_reg##c.div_reg ses yrs_all_pos contact_app if prop_app_reg>=0.15 & prop_app_reg!=. & exp_drop==0, cluster(office)
est store model_4
gen pr_sample=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m9) if pr_sample==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & pr_sample==1
}

gen match=0 if pr_sample==1
replace match=1 if pred==politicized_app & pr_sample==1
sum match

drop m1-m9 match pred max pr_sample

***************************************************************************************************************************
outreg2 [model_1 model_2 model_3 model_4] using "C:\Users\mdr\Dropbox\Papers\expertise\Paper\Tables\apdx_pol_div_obama",  tex(frag) replace dec(2) ///
label sortvar(politicized_app div_ip ses yrs_all_pos contact_app)
***************************************************************************************************************************

*Table2
*Model 3
oprobit leave_likelihood politicized_app div_obama value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if exp_drop==0, cluster(office)
est store model_3
gen pr_sample = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m4) if pr_sample==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & pr_sample==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & pr_sample==1
sum match

drop m1-m4 match pred max pr_sample

*Model 4
reg workhours politicized_app div_obama value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if exp_drop==0, cluster(office)
est store model_4

*Model 5
oprobit inv_outside politicized_app div_obama value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 6
oprobit inv_sme politicized_app div_obama value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 7
oprobit inv_training politicized_app div_obama value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if exp_drop==0, cluster(office)
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr


*Model 8
reg investment_all politicized_app div_obama value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if exp_drop==0, cluster(office)
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\mdr\Dropbox\Papers\expertise\Paper\Tables\apdx_inv_div_obama",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*Table2
*Model 3
oprobit leave_likelihood politicized_app div_reg value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_reg>=.15 & prop_app_reg!=. & other==0 & exp_drop==0, cluster(office)
est store model_3
gen pr_sample = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m4) if pr_sample==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & pr_sample==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & pr_sample==1
sum match

drop m1-m4 match pred max pr_sample

*Model 4
reg workhours politicized_app div_reg value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_reg>=.15 & prop_app_reg!=. & other==0 & exp_drop==0, cluster(office)
est store model_4

*Model 5
oprobit inv_outside politicized_app div_reg value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_reg>=.15 & prop_app_reg!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 6
oprobit inv_sme politicized_app div_reg value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_reg>=.15 & prop_app_reg!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 7
oprobit inv_training politicized_app div_reg value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_reg>=.15 & prop_app_reg!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr


*Model 8
reg investment_all politicized_app div_reg value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_reg>=.15 & prop_app_reg!=. & other==0 & exp_drop==0, cluster(office)
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\mdr\Dropbox\Papers\expertise\Paper\Tables\apdx_inv_div_reg",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*********************************************************
*Alternative measures of politicization - Section 14.4
*********************************************************
*opm measure
merge m:1 office using C:/Users/richar33/Dropbox/Papers/expertise/Data/opm_pct_app_tech.dta

tab office if _merge==1

tab office if _merge==2

*failures to match are okay

*Table2
*Model 3
oprobit leave_likelihood opm_pct_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_3
gen pr_sample = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m4) if pr_sample==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & pr_sample==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & pr_sample==1
sum match

drop m1-m4 match pred max pr_sample

*Model 4
reg workhours opm_pct_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_4

*Model 5
oprobit inv_outside opm_pct_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 6
oprobit inv_sme opm_pct_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 7
oprobit inv_training opm_pct_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

*Model 8
reg investment_all opm_pct_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\apdx_pol_opm",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************
*fyb measure

use G:/Data/mdr/expertise_paper/SFGSII_mdr_exp_paper_forR.dta, clear

merge m:1 office using G:/Data/mdr/expertise_paper/fyb_pct_app.dta

tab office if _merge==1 //offices of the secretary - okay

tab office if _merge==2 //agencies with no respondents or incongruent aggregation - okay

*Table2
*Model 3
oprobit leave_likelihood fyb_pct_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_3
gen pr_sample = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m4) if pr_sample==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & pr_sample==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & pr_sample==1
sum match

drop m1-m4 match pred max pr_sample

*Model 4
reg workhours fyb_pct_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_4

*Model 5
oprobit inv_outside fyb_pct_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 6
oprobit inv_sme fyb_pct_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 7
oprobit inv_training fyb_pct_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

*Model 8
reg investment_all fyb_pct_app div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\apdx_pol_fyb",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

use G:/Data/mdr/expertise_paper/SFGSII_mdr_exp_paper_forR.dta, clear

*********************************************************
*Parallel regression assumption - Section 14.5
*********************************************************

*use gologit2 package to evaluate and relax the assumption; tests at the 95% confidence level

*Table1
*Model 1
gologit2 politicized_app div_ip ses yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office) link(probit) auto //one observations predicted probability less than 0

gen pol_app_trunc = 0 if politicized_app<=1 & politicized_app!=.
replace pol_app_trunc=1 if politicized_app>1 & politicized_app!=.

probit pol_app_trunc div_ip ses yrs_all_pos contact_app if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)

*Model2
gologit2 politicized_app div_ip ses yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, robust link(probit) auto //okay

*check predicted probabilites
margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(0))
margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(1))
margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(2))
margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(3))
margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(4))

*check marginal effects
margins, dydx(div_ip) at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(0))
margins, dydx(div_ip) at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(1))
margins, dydx(div_ip) at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(2))
margins, dydx(div_ip) at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(3))
margins, dydx(div_ip) at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(4))

gologit2 politicized_app c.div_ip##c.div_ip ses yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office) link(probit) auto //okay

*Table2
*model 3
gologit2 leave_likelihood politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0,  link(probit) auto cluster(office) //okay

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(2)) 

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(3))

*check marginal effects
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(0)) level(90)
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(1)) level(90)
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(2)) level(90)
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(3)) level(90)

*model 5
gologit2 inv_outside politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0,  link(probit) auto cluster(office) //okay

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(0))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(1))

*check marginal effects
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(0)) level(90)
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(1)) level(90)
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(2)) level(90)
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(3)) level(90)
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(4)) level(90)
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(5)) level(90)

*model 6
gologit2 inv_sme politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0,  link(probit) auto cluster(office) //okay

*model 7
gologit2 inv_training politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0,  link(probit) auto cluster(office)

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(0))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(1))

*check marginal effects
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(0))
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(1))
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(2))
margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(3))

*********************************************************
*Testing for Conditional Effects - Section 15
*********************************************************

*politicization conditional on pref div

*Table2
*Model 3
oprobit leave_likelihood c.politicized_app##c.div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_3
gen pr_sample = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m4) if pr_sample==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & pr_sample==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & pr_sample==1
sum match

drop m1-m4 match pred max pr_sample

*Model 4
reg workhours c.politicized_app##c.div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_4

*Model 5
oprobit inv_outside c.politicized_app##c.div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 6
oprobit inv_sme c.politicized_app##c.div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 7
oprobit inv_training c.politicized_app##c.div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

*Model 8
reg investment_all c.politicized_app##c.div_ip value_policy value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\apdx_cond_div",  tex(frag) replace dec(2) ///
 label sortvar(c.politicized_app##c.div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*politicization conditional on value of policy influence

*Table2
*Model 3
oprobit leave_likelihood c.politicized_app##c.value_policy div_ip value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_3
gen pr_sample = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if pr_sample==1, o(#`i')
}

egen max=rowmax(m1-m4) if pr_sample==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & pr_sample==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & pr_sample==1
sum match

drop m1-m4 match pred max pr_sample

*Model 4
reg workhours c.politicized_app##c.value_policy div_ip value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_4

*Model 5
oprobit inv_outside c.politicized_app##c.value_policy div_ip value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_outside & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 6
oprobit inv_sme c.politicized_app##c.value_policy div_ip value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_pr = e(sample)

foreach i of numl 1(1)6{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m6) if sample_pr==1

gen pred=.

foreach i of numl 1(1)6{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_sme & sample_pr==1
sum match

drop m1-m6 match pred max sample_pr

*Model 7
oprobit inv_training c.politicized_app##c.value_policy div_ip value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_training
gen sample_pr = e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample_pr==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample_pr==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample_pr==1
}

gen match=0 if sample_pr==1
replace match=1 if pred==inv_training & sample_pr==1
sum match

drop m1-m4 match pred max sample_pr

*Model 8
reg investment_all c.politicized_app##c.value_policy div_ip value_move_pvt value_move_higher approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_fact_all

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\apdx_cond_policy",  tex(frag) replace dec(2) ///
 label sortvar(c.politicized_app##c.div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*********************************************************
*Partisan Response Rates - Section 12
*********************************************************

use G:/Data/mdr/expertise_paper/pid_selection.dta, clear

*Compare private firm to self-reports

tab pid_5 v_pid2, col

*Test for a selection effect
recode pid_5 99=.

tab v_pid2 responded, col chi2

*omit "independents"
tab v_pid2 responded if v_pid2!="ind", col chi2

*omit "idependents" and inferred partisans
tab v_pid2 responded if v_pid2!="ind"&v_pid2!="inf dem"&v_pid2!="inf rep", col chi2

*collapse partisans and inferred partisans and omit "independents"
gen v_pid2_c = 0 if v_pid2=="dem"|v_pid2=="inf dem"
replace v_pid2_c =1 if v_pid2=="rep"|v_pid2=="inf rep"

tab v_pid2_c responded, col chi2
