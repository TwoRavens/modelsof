/* 	File Name: appendix_sections_9_10.do
	Data: Multiple
	Author: Mark Richardson
	Purpose: Code SFGS1 and perform analysis for Sections 9 and 10 of the appendix
	Output: Tables for sections of the appendix replicating results using the 2007-2008 survey
	Date: 06/14/2017
*/

*prepare sfgs1 and sfgs2 ideal points
use G:\Data\mdr\sfgs1_sfgs2_altogether_free.dta, clear

destring id, replace
destring respnum, replace

keep if icpsr_id==""

save G:\Data\mdr\expertise_paper\ip12.dta, replace

******************************************************************

cd Z:\

*merging surveys for r&r
use z:\Merge_SFGSI_SFGSII\sfgs1_crosswalk.dta, clear

rename fybid leadershippeopleid

*merge in SFGS1 population
merge 1:1 respnum using Z:\finaldispos4_18v2.dta
drop _merge

*merge in SFGS1 survey responses
merge 1:1 respnum using Z:\SFGS_AllCases.dta
drop _merge

tab status, m
tab consent, m
sum respnum, d

*merge in SFGS1 ideal points
merge 1:1 respnum using Z:\idealpoint09.dta
drop _merge

*merge in SFGS1 office coding
tostring leadershippeopleid, replace

merge m:1 leadershippeopleid using Z:\Merge_SFGSI_SFGSII/sfgs1_office_key.dta
drop if _merge==1  //drop respondents that self-selected into the survey; use merge not respnum because 3 respondents in targeted sample and have respnums > 30000;
drop _merge

*merge in crosswalk
merge 1:m respnum using Z:\Merge_SFGSI_SFGSII\sfgs1_sfgs2_individual_key.dta
drop _merge

*rename variables from both surveys
foreach i of varl appointee eop usda doc dod ed doe hhs dhs hud doi doj dol dos dot treas va office bureau dept consent workplace startdate enddate retire age{
rename `i' `i'_sfgs1
}

*merge in SFGSII
merge m:1 id using G:\Data\SFGSII.dta
drop _merge

*rename variables from both surveys
foreach i of varl appointee eop usda doc dod ed doe hhs dhs hud doi doj dol dos dot treas va office bureau dept consent workplace startdate enddate retire age{
rename `i' `i'_sfgs2
}

*merge in ideal points from sfgs1 and sfgs2
merge 1:1 id respnum using G:\Data\mdr\expertise_paper\ip12.dta // 4,766 matched, correct

drop ideal_point_lb ideal_point_ub ideal_point_sd icpsr_id name h113 h109 _merge
rename ideal_point ideal_point_all

*create appointee indicators
gen app_sfgs1=1 if appointee_sfgs1=="na"|appointee_sfgs1=="pa"|appointee_sfgs1=="pas"|appointee_sfgs1=="sc"
replace app_sfgs1=0 if appointee_sfgs1=="ca"|appointee_sfgs1=="careerist"|appointee_sfgs1=="sfs"

tab appointee_sfgs1 app_sfgs1

gen app_sfgs2=1 if appointee_sfgs2=="na"|appointee_sfgs2=="pa"|appointee_sfgs2=="pas"|appointee_sfgs2=="sc"
replace app_sfgs2=0 if appointee_sfgs2=="ca"|appointee_sfgs2=="careerist"|appointee_sfgs2=="sfs"

tab appointee_sfgs2 app_sfgs2

*create divergence measures for sfgs1 and sfgs2 using ideal points from both surveys
gen app_ip1 = ideal_point_all if app_sfgs1==1
gen app_ip2 = ideal_point_all if app_sfgs2==1

egen ip_app_sfgs1=mean(app_ip1) if respnum!=., by(office_sfgs1)
egen ip_app_sfgs2=mean(app_ip2) if id!=., by(office_sfgs2)

gen pop1=1 if app_sfgs1==1
gen pop2=1 if app_sfgs2==1

egen n_app_sfgs1=count(pop1), by(office_sfgs1)
egen n_app_sfgs2=count(pop2), by(office_sfgs2)

egen n_app_ip_sfgs1=count(app_ip1), by(office_sfgs1)
egen n_app_ip_sfgs2=count(app_ip2), by(office_sfgs2)

gen prop_app_ip1 = n_app_ip_sfgs1/n_app_sfgs1
gen prop_app_ip2 = n_app_ip_sfgs2/n_app_sfgs2

gen div_ip_sfgs1=abs(ideal_point_all-ip_app_sfgs1)
gen div_ip_sfgs2=abs(ideal_point_all-ip_app_sfgs2)





*************************************************************************
*create divergence measures from sfgs1 - clinton et al.
gen app_ip09 = idealpoint if app_sfgs1==1

egen ip_app_09=mean(app_ip09) if respnum!=., by(office_sfgs1)

egen n_app_ip_09=count(app_ip09), by(office_sfgs1)

gen prop_app_ip09 = n_app_ip_09/n_app_sfgs1

gen div_ip_09=abs(idealpoint-ip_app_09)
								
*************************************************************************
drop app_ip1 app_ip2 pop1 pop2 

*************************************************************************

*recode survey variables

*exit - sfgs1
tab leave
tab leave, nol

recode leave 5=.

gen leave1 = (leave-4)*-1
tab leave1

*exit - sfgs2
tab leave_like
recode leave_like 99=.

*exit - fd
gen exit_fd=leave_like-leave1

*politicization - sfgs1
tab grpinflu7
tab grpinflu7, nol
recode grpinflu7 6=.

gen infl_app1 = (grpinflu7-5)*-1
tab infl_app1

tab grpinflu6
tab grpinflu6, nol
recode grpinflu6 6=.

gen infl_car1 = (grpinflu6-5)*-1

gen pol_app1 = infl_app1-infl_car1

tab pol_app1

*politicization - sfgs2

tab policy_appointees
tab policy_appointees, nol

recode policy_appointees 99=.

tab policy_senior
tab policy_senior, nol

recode policy_senior 99=.

gen pol_app2 = policy_appointees-policy_senior

*politicization - fd
gen pol_fd = pol_app2-pol_app1
tab pol_fd

*divergence - fd
gen div_fd = div_ip_sfgs2-div_ip_sfgs1

*ses indicator variable
gen ses1 = 0 if respnum!=.
replace ses1=1 if appointee_sfgs1=="ca"

gen ses2 = 0 if id!=.
replace ses2=1 if appointee_sfgs2=="ca"

gen fd_ses = ses2-ses1

*contact with appointees - sfgs1
tab group2_6
tab group2_6, nol

recode group2_6 6=.
gen contact_app1 = (group2_6-5)*-1
tab contact_app1

*contact with appointees - sfgs2
tab contact_appointees
tab contact_appointees, nol

recode contact_appointees 99=.

*contact - fd

gen fd_contact = contact_appointees-contact_app1

*time in agency - sfgs1
tab yremp2
rename yremp2 yrs_all_pos1

*time in agency - sfgs2
tab yrs_all_pos
rename yrs_all_pos yrs_all_pos2

gen fd_yrs = yrs_all_pos2-yrs_all_pos1

tab fd_yrs

*time in government - sfgs1
tab yremp3

*time in government - sfgs2
tab yrs_fed_gov

gen fd_yrs_fed = yrs_fed_gov-yremp3

tab fd_yrs_fed //Some changes too small and too large - confirmed one outlier is match, seems to be survey response error


*agency specific expertise/approached by outside - sfgs1
tab workset1
tab workset1, nol
recode workset1 5=.

gen agency_specific1 = (workset1-4)*-1
tab agency_specific1

tab workset6
tab workset6, nol
recode workset6 5=.

gen approach_job1 = (workset6-4)*-1
tab approach_job1

*agency specific expertise/approached by outside - sfgs2

tab approach_job
tab approach_job, nol

rename approach_job approach_job2

*retirement elegibility - sfgs1
tab retire_sfgs1
tab retire_sfgs1, nol

recode retire_sfgs1 3=.

gen retire1 = (retire_sfgs1-2)*-1
tab retire1


*retirement elegibility - sfgs2
tab retire_sfgs2
tab retire_sfgs2, nol

recode retire_sfgs2 99=.

rename retire_sfgs2 retire2

gen fd_retire = retire2-retire1

*competence - sfgs1
tab comp2
rename comp2 comp_snr

tab comp3
rename comp3 comp_lm

*control for policy motivation, salary, and desire to advance - sfgs1
tab decision2_1
tab decision2_1, nol

gen imp_salary = (decision2_1-5)*-1
tab imp_salary

tab decision2_4
tab decision2_4, nol

gen imp_advancement = (decision2_4-5)*-1
tab imp_advancement

tab decision2_7
tab decision2_7, nol

gen imp_policy = (decision2_7-5)*-1
tab imp_policy

tab decision2_10
tab decision2_10, nol

gen imp_serve = (decision2_10-5)*-1
tab imp_serve

tab decision2_2
tab decision2_2, nol

gen imp_difference = (decision2_2-5)*-1
tab imp_difference

*****************************************************
*keep if app_sfgs1==0 | app_sfgs2==0

gen other1=0 if office_sfgs1!=""
gen other2=0 if office_sfgs2!=""

replace other1 = 1 if regexm(office_sfgs1,"Other \(")
replace other2 = 1 if regexm(office_sfgs2,"Other \(")

gen obama = -0.7913
egen ip_obama = max(obama)
gen div_obama = abs(ideal_point_all-ip_obama)

gen bush = 1.5251
egen ip_bush = max(bush)
gen div_bush = abs(ideal_point_all-ip_bush)

gen div_bush09 = abs(idealpoint-0.85)

gen fd_div_pres = div_obama-div_bush

gen fd_div = div_ip_sfgs2 - div_ip_sfgs1

*Code pid_5 from the last survey
tab polparty
tab polparty, nol

tab polpartylean
tab polpartylean, nol

tab polparty polpartylean, m
tab polparty polpartylean, m nol

gen pid5_sfgs1 = 4 if polparty==1 //republican
replace pid5_sfgs1 = 3 if polpartylean==1 //lean republican
replace pid5_sfgs1 = 1 if polpartylean==2 //lean democrat
replace pid5_sfgs1 = 0 if polparty==2 //democrat

replace pid5_sfgs1 = 2 if polparty==3 & (polpartylean==3|polpartylean==.) //independent

tab polview
tab polview, nol

recode polview 8=.
recode ideology 99=.

recode pid_5 99=.

*create three point pid scale
gen pid3_1 = pid5_sfgs1
recode pid3_1 (0=-1) (1=-1) (2=0) (3=1) (4=1)

gen pid3_2 = pid_5
recode pid3_2 (0=-1) (1=-1) (2=0) (3=1) (4=1)


*replicate regressions using sfgs1 data ***************************************************************
label var pol_app1 "Politicization"
label var div_ip_09 "Preference Divergence"
label var ses1 "SES"
label var contact_app1 "Frequency of Contact with Appointees"
label var yrs_all_pos1 "Agency Tenure"
label var div_bush09 "Divergence from Pres. Bush"
label var imp_policy "Value Policy"
label var imp_salary "Value Salary \& Benefits"
label var imp_advancement "Value Advancement"
label var agency_specific1 "Agency-Specific Exp."
label var approach_job1 "Often Approached about a Job"
label var retire1 "Eligible to Retire"

*at least 15% response rate for appointee ideal points - 09
oprobit pol_app1 div_ip_09 ses1 contact_app1 yrs_all_pos1 if app_sfgs1==0 & other1==0 & prop_app_ip09>=.15, cluster(office_sfgs1)
est store model1
gen s=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m9) if s==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==pol_app1 & s==1
sum match

drop m1-m9 max match pred s

oprobit pol_app1 c.div_ip_09##c.div_ip_09 ses1 contact_app1 yrs_all_pos1 if app_sfgs1==0 & other1==0 & prop_app_ip09>=.15, cluster(office_sfgs1)
est store model2
gen sample2 = e(sample)
gen s=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m9) if s==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==pol_app1 & s==1
sum match

drop m1-m9 max match pred s

margins, at(div_ip_09 = (0 1 2 3)) predict(outcome(0))
margins, at(div_ip_09 = (0 1 2 3)) predict(outcome(1))
margins, at(div_ip_09 = (0 1 2 3)) predict(outcome(2))
margins, at(div_ip_09 = (0 1 2 3)) predict(outcome(3))
margins, at(div_ip_09 = (0 1 2 3)) predict(outcome(4))

oprobit pol_app1 div_bush09 ses1 contact_app1 yrs_all_pos1 if app_sfgs1==0, cluster(office_sfgs1)
est store model3
gen s=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m9) if s==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==pol_app1 & s==1
sum match

drop m1-m9 max match pred s

oprobit pol_app1 c.div_bush09##c.div_bush09 ses1 contact_app1 yrs_all_pos1 if app_sfgs1==0, cluster(office_sfgs1)
est store model4
gen s=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m9) if s==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==pol_app1 & s==1
sum match

drop m1-m9 max match pred s

***************************************************************************************************************************
outreg2 [model1 model2 model3 model4] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\sfgs1_div",  tex(frag) replace dec(2) ///
label sortvar(pol_app1 div_ip_09 div_bush09 ses1 yrs_all_pos1 contact_app1)
***************************************************************************************************************************

*exit
oprobit leave1 pol_app1 div_ip_09 imp_policy imp_salary agency_specific1 approach_job1 ses1 contact_app1 yrs_all_pos1 retire1 if app_sfgs1==0 & other1==0 & prop_app_ip1>=.15, cluster(office_sfgs1)
est store model1
gen s=e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m4) if s==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==leave1 & s==1
sum match

drop m1-m4 max match pred s

oprobit leave1 pol_app1 div_ip_09 imp_policy imp_advancement agency_specific1 approach_job1 ses1 contact_app1 yrs_all_pos1 retire1 if app_sfgs1==0 & other1==0 & prop_app_ip1>=.15, cluster(office_sfgs1)
est store model2
gen s=e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m4) if s==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==leave1 & s==1
sum match

drop m1-m4 max match pred s

oprobit leave1 pol_app1 div_bush09 imp_policy imp_salary agency_specific1 approach_job1 ses1 contact_app1 yrs_all_pos1 retire1 if app_sfgs1==0, cluster(office_sfgs1)
est store model3
gen s=e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m4) if s==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==leave1 & s==1
sum match

drop m1-m4 max match pred s

oprobit leave1 pol_app1 div_bush09 imp_policy imp_advancement agency_specific1 approach_job1 ses1 contact_app1 yrs_all_pos1 retire1 if app_sfgs1==0, cluster(office_sfgs1)
est store model4
gen s=e(sample)

foreach i of numl 1(1)4{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m4) if s==1

gen pred=.

foreach i of numl 1(1)4{
replace pred=(`i'-1) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==leave1 & s==1
sum match

drop m1-m4 max match pred s

***************************************************************************************************************************
outreg2 [model1 model2 model3 model4] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\sfgs1_exit",  tex(frag) replace dec(2) ///
label sortvar(pol_app1 div_ip_09 div_bush09 imp_policy imp_salary imp_advancement ses1 yrs_all_pos1 contact_app1 retire)
***************************************************************************************************************************

label var pol_fd  "$\Delta$ Politicization"
label var fd_div_pres "$\Delta$ Pref. Div. from Pres."
label var fd_div "$\Delta$ Pref. Div."
label var fd_ses "$\Delta$ SES"
label var fd_contact "$\Delta$ Freq. Contact w. Appointees"
label var fd_retire "$\Delta$ Retirement Eligibility"

*First difference models

oprobit pol_fd fd_div fd_ses fd_contact if other1==0 & other2==0 & app_sfgs1==0 & app_sfgs2==0, r
est store model1

oprobit pol_fd c.fd_div##c.fd_div fd_ses fd_contact if other1==0 & other2==0 & app_sfgs1==0 & app_sfgs2==0, r
est store model2

oprobit pol_fd fd_div_pres fd_ses fd_contact if app_sfgs1==0 & app_sfgs2==0, r
est store model3

oprobit pol_fd c.fd_div_pres##c.fd_div_pres fd_ses fd_contact if app_sfgs1==0 & app_sfgs2==0, r
est store model4

oprobit exit_fd pol_fd fd_div fd_ses fd_contact fd_retire if app_sfgs1==0 & app_sfgs2==0 & other1==0 & other2==0, r
est store model5

oprobit exit_fd pol_fd fd_div_pres fd_ses fd_contact fd_retire if app_sfgs1==0 & app_sfgs2==0, r
est store model6

***************************************************************************************************************************
outreg2 [model1 model2 model3 model4 model5 model6] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\fd_ind",  tex(frag) replace dec(2) ///
label sortvar(pol_fd fd_div fd_div_pres fd_ses fd_contact fd_retire)
***************************************************************************************************************************

*estimate regression of percieved politicization and preference divergence as a function of partisanship
reg div_ip_sfgs1 pid3_1 if other1==0 & prop_app_ip1>=.15, cluster(office_sfgs1)
est store model1

reg div_bush pid3_1, cluster(office_sfgs1)
est store model2

oprobit pol_app1 pid3_1, cluster(office_sfgs1)
est store model3
gen s=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m9) if s==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==pol_app1 & s==1
sum match

drop m1-m9 max match pred s

reg div_ip_sfgs2 pid3_2 if other2==0 & prop_app_ip2>=.15, cluster(office_sfgs2)
est store model4

reg div_obama pid3_2, cluster(office_sfgs2)
est store model5

oprobit pol_app2 pid3_2, cluster(office_sfgs2)
est store model6
gen s=e(sample)

foreach i of numl 1(1)9{ //get predicted probabilities
predict m`i' if s==1, o(#`i')
}

egen max=rowmax(m1-m9) if s==1

gen pred=.

foreach i of numl 1(1)9{
replace pred=(`i'-5) if m`i'==max & s==1
}

gen match=0 if s==1
replace match=1 if pred==pol_app2 & s==1
sum match

drop m1-m9 max match pred s

***************************************************************************************************************************
outreg2 [model1 model2 model3 model4 model5 model6] using "C:\Users\richar33\Dropbox\Papers\expertise\Paper\Tables\pid",  tex(frag) replace dec(2)
***************************************************************************************************************************

