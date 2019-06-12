/* 	File Name: main_text.do
	Data: SFGSII_mdr_exp_paper.dta
	Author: Mark Richardson
	Purpose: Execute analysis for "Politicization and Expertise: Exit, Effort, and Investment"
	Output: Tables for the main text of the paper
	Date: 05/13/2017
*/

use "G:\Data\mdr\expertise_paper\SFGSII_mdr_exp_paper.dta", clear

*label variables
label var politicized_app "Politicization"
label var div_ip "Preference Divergence"
label var retire "Eligible to Retire"
label var yrs_all_pos "Agency Tenure"
label var ses "SES"
label var as_exp "Agency-Specific Expertise"
label var contact_app "Frequency of Contact with Appointees"
label var approach_job "Approached about a Job"
label var value_policy "Value Policy Influence"
label var value_move_higher "Value Gov't Promotion"
label var value_move_pvt "Value Pvt. Sector Job"
label var value_salary "Value Salary \& Benefits"
label var div_reg "Pref. Divergence (Regs.)"
label var div_obama "Pref. Divergence from Pres. Obama"

*get typical civil servant from the data
tab politicized_app if other==0 & exp_drop==0
sum div_ip if other==0 & exp_drop==0
tab approach_job if other==0 & exp_drop==0
sum as_exp if other==0 & exp_drop==0
tab appointee if other==0 & exp_drop==0
tab ses if other==0 & exp_drop==0
sum yrs_all_pos if other==0 & exp_drop==0
tab contact_app if other==0 & exp_drop==0
sum retire if other==0 & exp_drop==0
tab value_policy if other==0 & exp_drop==0
tab value_salary if other==0 & exp_drop==0
tab value_move_higher if other==0 & exp_drop==0
tab value_move_pvt if other==0 & exp_drop==0

***************************************************************************************************************************
*Table 1
*Model 1
oprobit politicized_app div_ip ses yrs_all_pos contact_app if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_1
gen sample1 = e(sample)

margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(0))
margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(1))
margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(2))
margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(3))
margins, at(div_ip = (0 1 2 3) ses=0 yrs_all_pos=17.32 contact_app=4) predict(outcome(4))

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if sample1==1, o(#`i')
}

egen max=rowmax(m1-m9) if sample1==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & sample1==1
}

gen match=0 if sample1==1
replace match=1 if pred==politicized_app & sample1==1
sum match

drop m1-m9 match pred max

*Model 2
oprobit politicized_app c.div_ip##c.div_ip ses yrs_all_pos contact_app if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_2
gen sample2 = e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if sample2==1, o(#`i')
}

egen max=rowmax(m1-m9) if sample2==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & sample2==1
}

gen match=0 if sample1==1
replace match=1 if pred==politicized_app & sample2==1
sum match

drop m1-m9 match pred max

***************************************************************************************************************************
outreg2 [model_1 model_2] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\table1",  tex(frag) replace dec(2) ///
label sortvar(politicized_app div_ip ses yrs_all_pos contact_app)
***************************************************************************************************************************

*Table2
*Model 3
oprobit leave_likelihood politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app retire ///
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_3
gen sample3 = e(sample)

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(2)) 

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(3))

margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(2)) level(90)

margins, dydx(politicized_app) at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 retire=0 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(3)) level(90)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if sample3==1, o(#`i')
}

egen max=rowmax(m1-m4) if sample3==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & sample3==1
}

gen match=0 if sample3==1
replace match=1 if pred==leave_like & sample3==1
sum match

drop m1-m4 match pred max

*Member of SES for discussion
*get typical SES
tab politicized_app if other==0 & exp_drop==0 & ses==1
sum div_ip if other==0 & exp_drop==0 &ses==1
tab approach_job if other==0 & exp_drop==0 & ses==1
sum as_exp if other==0 & exp_drop==0 & ses==1
sum yrs_all_pos if other==0 & exp_drop==0 & ses==1
tab contact_app if other==0 & exp_drop==0 & ses==1
sum retire if other==0 & exp_drop==0 & ses==1
tab value_policy if other==0 & exp_drop==0 & ses==1
tab value_salary if other==0 & exp_drop==0 & ses==1
tab value_move_higher if other==0 & exp_drop==0 & ses==1
tab value_move_pvt if other==0 & exp_drop==0 & ses==1

margins, at(politicized_app = (0 1 2 3) div_ip = 0.86 approach_job=0 as_exp=.1244 ses=1 yrs_all_pos=18.67 contact_app=4 retire=0 ///
value_policy=4 value_move_higher=3 value_move_pvt=1) predict(outcome(2))
margins, at(politicized_app = (0 1 2 3) div_ip = 0.86 approach_job=0 as_exp=.1244 ses=1 yrs_all_pos=18.67 contact_app=4 retire=0 ///
value_policy=4 value_move_higher=3 value_move_pvt=1) predict(outcome(3))

*change in predicted probabilites
di .0698345 + .0375227 //level at pol=0
di .0770428 + .0434456 //level at pol=1

di (.0770428 - .0698345) + (.0434456 - .0375227)

*Model 4
reg workhours politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_4
gen sample4 = e(sample)

*footnote about extreme responses
reg workhours politicized_app div_ip value_policy value_move_pvt value_move_higher approach_job as_exp ses yrs_all_pos contact_app /// 
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0 & workhours>=40 & workhours <=80, cluster(office)

*Model 5
oprobit inv_outside politicized_app div_ip value_policy value_move_higher value_move_pvt approach_job ses as_exp yrs_all_pos contact_app ///
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_outside_exp
gen sample_inv_outside_exp = e(sample)
gen sample_pr = e(sample)

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(0))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(1))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(2))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(3))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(4))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(5))


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
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_sme
gen sample_inv_sme = e(sample)
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
if prop_app_ip>=0.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_inv_training
gen sample_inv_training = e(sample)
gen sample_pr = e(sample)

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(0))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(1))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(2))

margins, at(politicized_app = (0 1 2 3) div_ip = 0.87 approach_job=0 as_exp=0.1372 ses=0 yrs_all_pos=17.32 contact_app=4 value_policy=4 ///
value_move_higher=3 value_move_pvt=1) predict(outcome(3))

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
if prop_app_ip>=.15 & prop_app_ip!=. & other==0 & exp_drop==0, cluster(office)
est store model_fact_all
gen sample_fact_all = e(sample)

***************************************************************************************************************************
outreg2 [model_3 model_4 model_inv_* model_fact_all] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\table2",  tex(frag) replace dec(2) ///
 label sortvar(politicized_app div_ip value_* approach_job as_exp ses yrs_all_pos contact_app)
***************************************************************************************************************************

*save a data set for bootstrapping and making figures
save "G:\Data\mdr\expertise_paper\SFGSII_mdr_exp_paper_forR.dta", replace
