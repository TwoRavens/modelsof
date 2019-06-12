******************************************************
*
* This Stata .do file performs all of the analyses
* and recreates the tables in both the main text and
* supplemental appendix.
*
******************************************************

log using logs/analysis_usingperturbedpublicfiles_log.txt, text replace
set more off
clear

use data/ct_felon_reintegration_experiment_final-anonymized_perturbedage_sentlength_timesincerelease.dta, clear

*generate treatment and control indicators
gen control = 1 if treat_combined == 0 & returntoprison == 0
gen assur = 1 if treat1 == 1 & returntoprison == 0
gen expand_assur = 1 if treat2 == 1 & returntoprison == 0
gen pool_assur = 1 if treat_combined == 1 & returntoprison == 0

*treatment indicators by subgroups defined by returned mail
gen pool_assurMR = 1 if treat_combined == 1 & returned == 1 & returntoprison == 0
gen pool_assurMNR = 1 if treat_combined == 1 & returned == 0 & returntoprison == 0

gen assur_pr = treat1
replace assur_pr = . if treat2 == 1
replace assur_pr = . if returntoprison == 1

gen expand_assur_pr = treat2
replace expand_assur_pr = . if treat1 == 1
replace expand_assur_pr = . if returntoprison == 1

gen pool_assur_pr = treat_combined
replace pool_assur_pr = . if returntoprison == 1

gen pool_assur_prMR = treat_combined
replace pool_assur_prMR = . if returned == 0 & treat_combined == 1
replace pool_assur_prMR = . if returntoprison == 1

gen assur_pr2 = treat1
replace assur_pr2 = . if control == 1
replace assur_pr2 = . if returntoprison == 1

*Table 1: 2012 Registration and Turnout by Experimental Condition
file open myfile using tables_using_perturbedpublicfiles/table01.out, write replace
file write myfile "Table 1: 2012 Registration and Turnout by Experimental Condition" _n
file write myfile _n
file write myfile _tab "Control" _tab "Assurance" _tab "Expanded Assurance" _tab "Pooled Assurance" _tab "Pooled Assurance Mail Returned" _tab "Pooled Assurance Mail Not Returned" _n
file write myfile _n

foreach outcome in registered v_pres_general_12 {

  local outcome_label : variable label `outcome'

  * write out means
  file write myfile "`outcome_label'"
  foreach condition in "control==1"  "assur==1"  "expand_assur==1"  "pool_assur==1" "pool_assurMR==1" "pool_assurMNR==1" {
    sum `outcome' if `condition'
	file write myfile _tab %5.3f (r(mean))
  }
  file write myfile _n

  * write out sds
  file write myfile ""
  foreach condition in  "control==1"  "assur==1"  "expand_assur==1"  "pool_assur==1" "pool_assurMR==1" "pool_assurMNR==1" {
    sum `outcome' if `condition'
	file write myfile _tab "[" %5.3f (sqrt((r(mean))*(1-r(mean))/r(N))) "]"
  }
  file write myfile _n
  
  * perform tests of conditions relative to control
  file write myfile "Difference of proportion tests relative to control `outcome_label'" _tab
  foreach condition in "assur_pr" "expand_assur_pr" "pool_assur_pr" "pool_assur_prMR" {
    prtest `outcome', by(`condition')
    local temp = `r(P_2)'-`r(P_1)'
	file write myfile _tab %5.3f "`temp'"
  }
  file write myfile _n
  
  file write myfile _tab
  foreach condition in "assur_pr" "expand_assur_pr" "pool_assur_pr" "pool_assur_prMR" {
    prtest `outcome', by(`condition')
    local temp = 1 - normal(abs(`r(z)'))
	file write myfile _tab %5.3f "`temp'"
  }
  file write myfile _n
  file write myfile _n

}
qui sum registered if control == 1
local ncontrol = `r(N)'
qui sum registered if assur == 1
local nassur = `r(N)'
qui sum registered if expand_assur == 1
local nexpand_assur = `r(N)'
qui sum registered if pool_assur == 1
local npool_assur = `r(N)'
qui sum registered if pool_assurMR == 1
local npool_assurMR = `r(N)'
qui sum registered if pool_assurMNR == 1
local npool_assurMNR = `r(N)'
file write myfile "Number of Observations" _tab "`ncontrol'" _tab "`nassur'" _tab "`nexpand_assur'" _tab "`npool_assur'" _tab "`npool_assurMR'" _tab "`npool_assurMNR'" _n
file close myfile

*difference of proportions tests reported in Table 1 note
prtest registered, by(assur_pr2)
prtest v_pres_general_12, by(assur_pr2)

clear

*for footnote 12 - add prior registrants to the control group and recalculate the control group's participation rates
use data/ct_felon_reintegration_experiment_final-anonymized_perturbedage_sentlength_timesincerelease.dta, clear
append using data/ct_felon_reintegration_experiment_felon_record_priorregistrantsonly-anonymized.dta

sum registered if treat_combined == 0 & returntoprison == 0
sum v_pres_general_12 if treat_combined == 0 & returntoprison == 0

clear

*remaining analyses
use data/ct_felon_reintegration_experiment_final-anonymized_perturbedage_sentlength_timesincerelease.dta, clear

encode f_contype, gen(crime)

*label var f_daysserved "Days Served"
gen log_daysserved = log(f_daysserved + 1)
label var log_daysserved "Log Days Served"

*gen ageonelecday = (mdy(11, 6, 2012) - f_dob) / 365.25
*label var ageonelecday "Age on Election Day (years)"
gen ageonelecday2 = ageonelecday^2
label var ageonelecday2 "Age Squared"

*gen timesincerelease = (mdy(11, 6, 2012) - f_reldate) / 365.25
*label var timesincerelease "Time Since Release (years)"
gen timesincerelease2 = timesincerelease^2
label var timesincerelease2 "Time Since Release Squared"

gen v08yes = 0
replace v08yes = 1 if v08 == 1
label var v08yes "Eligible and Voted, 2008"
gen v08no = 0
replace v08no = 1 if v08 == 0
label var v08no "Eligible and Did Not Vote, 2008"
gen v_noteligible = 0
replace v_noteligible = 1 if v08 == .

gen treat_v08yes = treat_combined * v08yes
label var treat_v08yes "SoS Letters Combined * Voted 2008"
gen treat_v08no = treat_combined * v08no
label var treat_v08no "SoS Letters Combined * Did Not Vote (but Eligible) 2008"
gen treat_vnoelig = treat_combined * v_noteligible
label var treat_vnoelig "SoS Letters Combined * Did Not Vote (and Not Eligible) 2008"

label var crime "Fixed Effects Units (Crimes)"

*balance tests
qui sum log_daysserved if treatment_ordered == 1
local meanlds1 = round(`r(mean)', .001)
local sdlds1 = round(`r(sd)', .001)

qui sum ageonelecday if treatment_ordered == 1
local meanage1 = round(`r(mean)', .001)
local sdage1 = round(`r(sd)', .001)

qui sum timesincerelease if treatment_ordered == 1
local meantsr1 = round(`r(mean)', .001)
local sdtsr1 = round(`r(sd)', .001)

qui sum v08yes if treatment_ordered == 1
local meanv08yes1 = round(`r(mean)', .001)
local sdv08yes1 = round(`r(sd)', .001)

qui sum v08no if treatment_ordered == 1
local meanv08no1 = round(`r(mean)', .001)
local sdv08no1 = round(`r(sd)', .001)

local n1 = `r(N)'

qui sum log_daysserved if treatment_ordered == 2
local meanlds2 = round(`r(mean)', .001)
local sdlds2 = round(`r(sd)', .001)

qui sum ageonelecday if treatment_ordered == 2
local meanage2 = round(`r(mean)', .001)
local sdage2 = round(`r(sd)', .001)

qui sum timesincerelease if treatment_ordered == 2
local meantsr2 = round(`r(mean)', .001)
local sdtsr2 = round(`r(sd)', .001)

qui sum v08yes if treatment_ordered == 2
local meanv08yes2 = round(`r(mean)', .001)
local sdv08yes2 = round(`r(sd)', .001)

qui sum v08no if treatment_ordered == 2
local meanv08no2 = round(`r(mean)', .001)
local sdv08no2 = round(`r(mean)', .001)

local n2 = `r(N)'

qui sum log_daysserved if treatment_ordered == 3
local meanlds3 = round(`r(mean)', .001)
local sdlds3 = round(`r(sd)', .001)

qui sum ageonelecday if treatment_ordered == 3
local meanage3 = round(`r(mean)', .001)
local sdage3 = round(`r(sd)', .001)

qui sum timesincerelease if treatment_ordered == 3
local meantsr3 = round(`r(mean)', .001)
local sdtsr3 = round(`r(sd)', .001)

qui sum v08yes if treatment_ordered == 3
local meanv08yes3 = round(`r(mean)', .001)
local sdv08yes3 = round(`r(sd)', .001)

qui sum v08no if treatment_ordered == 3
local meanv08no3 = round(`r(mean)', .001)
local sdv08no3 = round(`r(sd)', .001)

local n3 = `r(N)'

mlogit treatment_ordered log_daysserved ageonelecday timesincerelease v08yes v08no, baseoutcome(1)

qui test [SOS_Registration]log_daysserved
qui test [SOS_Registration]ageonelecday, accum
qui test [SOS_Registration]timesincerelease, accum
qui test [SOS_Registration]v08yes, accum
test [SOS_Registration]v08no, accum
local balancechi1 = round(`r(chi2)', .01)
local balancep1 = round(`r(p)', .01)

qui test [SOS_Registration_with_no_intimid]log_daysserved
qui test [SOS_Registration_with_no_intimid]ageonelecday, accum
qui test [SOS_Registration_with_no_intimid]timesincerelease, accum
qui test [SOS_Registration_with_no_intimid]v08yes, accum
test [SOS_Registration_with_no_intimid]v08no, accum
local balancechi2 = round(`r(chi2)', .01)
local balancep2 = round(`r(p)', .01)

qui test [SOS_Registration]log_daysserved = [SOS_Registration_with_no_intimid]log_daysserved
qui test [SOS_Registration]ageonelecday = [SOS_Registration_with_no_intimid]ageonelecday, accum
qui test [SOS_Registration]timesincerelease = [SOS_Registration_with_no_intimid]timesincerelease, accum
qui test [SOS_Registration]v08yes = [SOS_Registration_with_no_intimid]v08yes, accum
test [SOS_Registration]v08no = [SOS_Registration_with_no_intimid]v08no, accum
local balancechi3 = round(`r(chi2)', .01)
local balancep3 = round(`r(p)', .01)

*Table SI.2.1: Test of Balance for Experimental Treatment Assignment
file open myfile using tables_using_perturbedpublicfiles/tableSI.2.1.out, write replace
file write myfile "Table SI.2.1: Test of Balance for Experimental Treatment Assignment" _n
file write myfile _tab "Control" _tab "Assurance" _tab "Expanded Assurance" _n
file write myfile "Log Days Served" _tab "`meanlds1'" _tab "`meanlds2'" _tab "`meanlds3'" _n
file write myfile _tab "[`sdlds1']" _tab "[`sdlds2']" _tab "[`sdlds3']" _n
file write myfile "Age on Election Day (years)" _tab "`meanage1'" _tab "`meanage2'" _tab "`meanage3'" _n
file write myfile _tab "[`sdage1']" _tab "[`sdage2']" _tab "[`sdage3']" _n
file write myfile "Time Since Release (years)" _tab "`meantsr1'" _tab "`meantsr2'" _tab "`meantsr3'" _n
file write myfile _tab "[`sdtsr1']" _tab "[`sdtsr2']" _tab "[`sdtsr3']" _n
file write myfile "Eligible and Voted, 2008" _tab "`meanv08yes1'" _tab "`meanv08yes2'" _tab "`meanv08yes3'" _n
file write myfile _tab "[`sdv08yes1']" _tab "[`sdv08yes2']" _tab "[`sdv08yes3']" _n
file write myfile "Eligible and Did Not Vote, 2008" _tab "`meanv08no1'" _tab "`meanv08no2'" _tab "`meanv08no3'" _n
file write myfile _tab "[`sdv08no1']" _tab "[`sdv08no2']" _tab "[`sdv08no3']" _n
file write myfile "Observations" _tab "`n1'" _tab "`n2'" _tab "`n3'" _n
file write myfile _n
file write myfile "Balance Tests" _n
file write myfile "Assurance = Control = 0" _tab "chi2(5) = `balancechi1'" _tab "p = `balancep1'" _n
file write myfile "Expanded Assurance = Control = 0" _tab "chi2(5) = `balancechi2'" _tab "p = `balancep2'" _n
file write myfile "Assurance = Expanded Assurance = 0" _tab "chi2(5) = `balancechi3'" _tab "p = `balancep3'" _n
file close myfile

*Table 2: Effect of Outreach on 2012 Registration, Experimental Results
quietly regress registered treat_combined if returntoprison == 0, robust
sum registered if e(sample) == 1 & treat_combined == 0
local mean_dv_control1 = round(`r(mean)', .001)

regress registered treat_combined if returntoprison == 0, robust
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table02.out, title("Table 2: Effect of Outreach on 2012 Registration, Experimental Results") label bracket dec(3) replace
xtreg registered treat_combined if returntoprison==0, robust fe i(crime)
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table02.out, label bracket dec(3) addstat("R-squared Within", `e(r2_w)') adec(3) append
regress registered treat_combined log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 if returntoprison == 0, robust
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table02.out, label bracket dec(3) append
xtreg registered treat_combined log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 if returntoprison == 0, robust fe i(crime)
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table02.out, label bracket dec(3) addstat("R-squared Within", `e(r2_w)') adec(3) append
xtreg registered treat_combined log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no if returntoprison == 0, robust fe i(crime)
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table02.out, label bracket dec(3) addstat("R-squared Within", `e(r2_w)') adec(3) append
xtreg registered log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no treat_v08yes treat_v08no treat_vnoelig if returntoprison == 0, robust fe i(crime)
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table02.out, label bracket dec(3) addstat("R-squared Within", `e(r2_w)', "Mean of DV in Control Group", `mean_dv_control1') adec(3) append

*Table 3: Effect of Outreach on 2012 Voting, Experimental Results
quietly regress v_pres_general_12 treat_combined if returntoprison == 0, robust
sum v_pres_general_12 if e(sample) == 1 & treat_combined == 0
local mean_dv_control2 = round(`r(mean)', .001)

regress v_pres_general_12 treat_combined if returntoprison == 0, robust
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table03.out, title("Table 3: Effect of Outreach on 2012 Voting, Experimental Results") label bracket dec(3) replace
xtreg v_pres_general_12 treat_combined if returntoprison==0, robust fe i(crime)
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table03.out, label bracket dec(3) addstat("R-squared Within", `e(r2_w)') adec(3) append
regress v_pres_general_12 treat_combined log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 if returntoprison == 0, robust
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table03.out, label bracket dec(3) append
xtreg v_pres_general_12 treat_combined log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 if returntoprison == 0, robust fe i(crime)
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table03.out, label bracket dec(3) addstat("R-squared Within", `e(r2_w)') adec(3) append
xtreg v_pres_general_12 treat_combined log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no if returntoprison==0, robust fe i(crime)
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table03.out, label bracket dec(3) addstat("R-squared Within", `e(r2_w)') adec(3) append
xtreg v_pres_general_12 log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no treat_v08yes treat_v08no treat_vnoelig if returntoprison==0, robust fe i(crime)
matrix list r(table) /*to calculate one-sided p-values*/
outreg2 using tables_using_perturbedpublicfiles/table03.out, label bracket dec(3) addstat("R-squared Within", `e(r2_w)', "Mean of DV in Control Group", `mean_dv_control2') adec(3) append

*subgroup comparisons from column 6 of Table 2
xtreg registered log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no treat_v08yes treat_v08no treat_vnoelig if returntoprison == 0, robust fe i(crime)
test treat_v08yes == treat_v08no
test treat_v08yes == treat_vnoelig
test treat_v08no == treat_vnoelig

*subgroup comparisons from column 6 of Table 3
xtreg v_pres_general_12 log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no treat_v08yes treat_v08no treat_vnoelig if returntoprison==0, robust fe i(crime)
test treat_v08yes == treat_v08no
test treat_v08yes == treat_vnoelig
test treat_v08no == treat_vnoelig

sum v_pres_general_12 if treat_combined == 0 & returntoprison == 0 & v08 == 1
sum v_pres_general_12 if treat_combined == 1 & returntoprison == 0 & v08 == 1

*Table SI.3.1: Crimes for Those Included in the Field Experiment
file open myfile using tables_using_perturbedpublicfiles/tableSI.3.1.out, write replace
file write myfile "Table SI.3.1: Crimes for Those Included in Field Experiment" _n
file write myfile "Crime" _tab "Number in Field Experiment" _n
tab crime if returntoprison == 0, sort matcell(freq) matrow(names)
local rows = rowsof(names)
forvalues i = 1/`rows' {
  local val = names[`i', 1]
  local val_lab : label (crime) `val'
  local freq_val = freq[`i', 1]
  file write myfile "`val_lab'" _tab "`freq_val'" _n
}
file write myfile "Total" _tab "`r(N)'"
file close myfile

clear

use data/ct_felon_reintegration_experiment_final-anonymized_perturbedage_sentlength_timesincerelease.dta, clear

encode f_contype, gen(crime)

*label var f_daysserved "Days Served"
gen log_daysserved = log(f_daysserved + 1)
label var log_daysserved "Log Days Served"

*gen ageonelecday = (mdy(11, 6, 2012) - f_dob) / 365.25
*label var ageonelecday "Age on Election Day (years)"
gen ageonelecday2 = ageonelecday^2
label var ageonelecday2 "Age Squared"

*gen timesincerelease = (mdy(11, 6, 2012) - f_reldate) / 365.25
*label var timesincerelease "Time Since Release (years)"
gen timesincerelease2 = timesincerelease^2
label var timesincerelease2 "Time Since Release Squared"

gen v08yes = 0
replace v08yes = 1 if v08 == 1
label var v08yes "Eligible and Voted, 2008"
gen v08no = 0
replace v08no = 1 if v08 == 0
label var v08no "Eligible and Did Not Vote, 2008"
gen v_noteligible = 0
replace v_noteligible = 1 if v08 == .

gen treat_v08yes = treat_combined * v08yes
label var treat_v08yes "SoS Letters Combined * Voted 2008"
gen treat_v08no = treat_combined * v08no
label var treat_v08no "SoS Letters Combined * Did Not Vote (but Eligible) 2008"
gen treat_vnoelig = treat_combined * v_noteligible
label var treat_vnoelig "SoS Letters Combined * Did Not Vote (and Not Eligible) 2008"

label var crime "Fixed Effects Units (Crimes)"

*drop those who returned to prison (excluded)
keep if returntoprison == 0

*new variable labels for Table 4
gen treat_combinedXnreturn = treat_combined * (1 - returned)
label var treat_combinedXnreturn "Sent Letter * Mail Not Returned"
gen treat_v08yesXnreturn = treat_v08yes * (1 - returned)
label var treat_v08yesXnreturn "Sent Letter * Mail Not Returned * Voted 2008"
gen treat_v08noXnreturn = treat_v08no * (1 - returned)
label var treat_v08noXnreturn "Sent Letter * Mail Not Returned * Did Not Vote (but Eligible) 2008"
gen treat_vnoeligXnreturn = treat_vnoelig * (1 - returned)
label var treat_vnoeligXnreturn "Sent Letter * Mail Not Returned * Did Not Vote (and Not Eligible) 2008"

qui tab crime, gen(crimdum_)
drop crimdum_1

*Table 4: Complier Average Causal Effects (Adjusting for Returned Mail) of Outreach on 2012 Participation
ivregress 2sls registered (treat_combinedXnreturn = treat_combined) log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no crimdum_*, robust
outreg2 treat_combinedXnreturn log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no using tables_using_perturbedpublicfiles/table04.out, title("Table 4: Complier Average Causal Effects (Adjusting for Returned Mail) of Outreach on 2012 Participation") label bracket dec(3) replace

xtivreg registered (treat_v08yesXnreturn treat_v08noXnreturn treat_vnoeligXnreturn = treat_v08yes treat_v08no treat_vnoelig) log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no, fe i(crime)
test treat_v08yesXnreturn = treat_v08noXnreturn 
local p1=`r(p)'
test treat_v08yesXnreturn = treat_vnoeligXnreturn
local p2=`r(p)'
test treat_v08noXnreturn = treat_vnoeligXnreturn
local p3=`r(p)'
outreg2 log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no treat_v08yesXnreturn treat_v08noXnreturn treat_vnoeligXnreturn using tables_using_perturbedpublicfiles/table04.out, label bracket dec(3) addstat("P-value, treatment 08 voters = treatment 08 non-voters", `p1', "P-value, treatment 08 voters = treatment 08 not eligible", `p2',"P-value, treatment 08 non-voters = treatment 08 not eligible", `p3') adec(3) append

ivregress 2sls registered (treat_v08yesXnreturn treat_v08noXnreturn treat_vnoeligXnreturn = treat_v08yes treat_v08no treat_vnoelig) log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no crimdum_*, robust
test treat_v08yesXnreturn = treat_v08noXnreturn 
local p1=`r(p)'
test treat_v08yesXnreturn = treat_vnoeligXnreturn
local p2=`r(p)'
test treat_v08noXnreturn = treat_vnoeligXnreturn
local p3=`r(p)'
outreg2 log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no treat_v08yesXnreturn treat_v08noXnreturn treat_vnoeligXnreturn using tables_using_perturbedpublicfiles/table04.out, label bracket dec(3) addstat("P-value, treatment 08 voters = treatment 08 non-voters", `p1', "P-value, treatment 08 voters = treatment 08 not eligible", `p2',"P-value, treatment 08 non-voters = treatment 08 not eligible", `p3') adec(3) append

ivregress 2sls v_pres_general_12 (treat_combinedXnreturn = treat_combined) log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no crimdum_*, robust
outreg2 treat_combinedXnreturn log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no using tables_using_perturbedpublicfiles/table04.out, label bracket dec(3) append

xtivreg v_pres_general_12 (treat_v08yesXnreturn treat_v08noXnreturn treat_vnoeligXnreturn = treat_v08yes treat_v08no treat_vnoelig) log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no, fe i(crime)
test treat_v08yesXnreturn = treat_v08noXnreturn 
local p1=`r(p)'
test treat_v08yesXnreturn = treat_vnoeligXnreturn
local p2=`r(p)'
test treat_v08noXnreturn = treat_vnoeligXnreturn
local p3=`r(p)'
outreg2 log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no treat_v08yesXnreturn treat_v08noXnreturn treat_vnoeligXnreturn using tables_using_perturbedpublicfiles/table04.out, label bracket dec(3) addstat("P-value, treatment 08 voters = treatment 08 non-voters", `p1', "P-value, treatment 08 voters = treatment 08 not eligible", `p2',"P-value, treatment 08 non-voters = treatment 08 not eligible", `p3') adec(3) append

ivregress 2sls v_pres_general_12 (treat_v08yesXnreturn treat_v08noXnreturn treat_vnoeligXnreturn = treat_v08yes treat_v08no treat_vnoelig) log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no crimdum_*, robust
test treat_v08yesXnreturn = treat_v08noXnreturn 
local p1=`r(p)'
test treat_v08yesXnreturn = treat_vnoeligXnreturn
local p2=`r(p)'
test treat_v08noXnreturn = treat_vnoeligXnreturn
local p3=`r(p)'
outreg2 log_daysserved ageonelecday ageonelecday2 timesincerelease timesincerelease2 v08yes v08no treat_v08yesXnreturn treat_v08noXnreturn treat_vnoeligXnreturn using tables_using_perturbedpublicfiles/table04.out, label bracket dec(3) addstat("P-value, treatment 08 voters = treatment 08 non-voters", `p1', "P-value, treatment 08 voters = treatment 08 not eligible", `p2',"P-value, treatment 08 non-voters = treatment 08 not eligible", `p3') adec(3) append

clear

*conviction data used for Footnote 5 and Table SI.3.2
use data/conviction_characteristics_2009july-2012june-anonymized.dta

*for footnote 5
tab longer_3year

*Table SI.3.2: Crimes Eliminated via Filtering Process
foreach i in 2 49 63 69 70 82 83 85 86 88 93 106 107 121 122 123 5 6 9 11 12 13 15 109 127 {
  qui count if contnum == `i'
  local count_`i' = `r(N)'
  local pct_`i' = 100 * (round(`r(N)' / 12126, .0001))
}
foreach i in 5 6 9 11 12 13 15 109 127 {
  qui count if contnum == `i' & longer_1year == 1
  local count2_`i' = `r(N)'
  local pct2_`i' = 100 * (round(`r(N)' / 12126, .0001))
}
local sum_count = `count_2' + `count_49' + `count_63' + `count_69' + `count_70' + `count_82' + `count_83' + `count_85' + `count_86' + `count_88' + /*
  */`count_93' + `count_106' + `count_107' + `count_121' + `count_122' + `count_123' + `count_5' + `count_6' + `count_9' + `count_11' + `count_12' + /*
  */`count_13' + `count_15' + `count_109' + `count_127'
local sum_pct = `pct_2' + `pct_49' + `pct_63' + `pct_69' + `pct_70' + `pct_82' + `pct_83' + `pct_85' + `pct_86' + `pct_88' + `pct_93' + `pct_106' + /*
  */`pct_107' + `pct_121' + `pct_122' + `pct_123' + `pct_5' + `pct_6' + `pct_9' + `pct_11' + `pct_12' + `pct_13' + `pct_15' + `pct_109' + `pct_127'
local sum_count2 = `count_2' + `count_49' + `count_63' + `count_69' + `count_70' + `count_82' + `count_83' + `count_85' + `count_86' + `count_88' + /*
  */`count_93' + `count_106' + `count_107' + `count_121' + `count_122' + `count_123' + `count2_5' + `count2_6' + `count2_9' + `count2_11' + `count2_12' + /*
  */`count2_13' + `count2_15' + `count2_109' + `count2_127'
local sum_pct2 = `pct_2' + `pct_49' + `pct_63' + `pct_69' + `pct_70' + `pct_82' + `pct_83' + `pct_85' + `pct_86' + `pct_88' + `pct_93' + `pct_106' + /*
  */`pct_107' + `pct_121' + `pct_122' + `pct_123' + `pct2_5' + `pct2_6' + `pct2_9' + `pct2_11' + `pct2_12' + `pct2_13' + `pct2_15' + `pct2_109' + `pct2_127'

file open myfile using tables_using_perturbedpublicfiles/tableSI.3.2.out, write replace
  file write myfile "Table SI.3.2: Crimes Eliminated via Filtering Process" _n _n
  file write myfile _tab "Count" _tab "Percent of Initial Sample" _tab "Count Eliminated" _tab "Percent of Initial Sample Eliminated" _n
  file write myfile "Crime Coded as Involving Sex, Minors, or Death: All Cases Eliminated from Experiment Sample" _n
  file write myfile "   INJURY/RISK OF INJURY TO CHILD; SALE OF CHILD"       _tab "`count_2'" _tab "`pct_2'" _tab "`count_2'" _tab "`pct_2'" _n
  file write myfile "   FELONY MURDER"                                       _tab "`count_49'" _tab "`pct_49'" _tab "`count_49'" _tab "`pct_49'" _n
  file write myfile "   ILLEGAL POSS OF CHILD PORNOGRAPHY, 3RD DEG"          _tab "`count_63'" _tab "`pct_63'" _tab "`count_63'" _tab "`pct_63'" _n
  file write myfile "   INJURY/RISK OF INJURY TO MINOR"                      _tab "`count_69'" _tab "`pct_69'" _tab "`count_69'" _tab "`pct_69'" _n
  file write myfile "   INJURY/RISK OF INJURY TO MINOR-SEXUAL"               _tab "`count_70'" _tab "`pct_70'" _tab "`count_70'" _tab "`pct_70'" _n
  file write myfile "   MANSLAUGHTER W/ MOTOR VEHICLE WHILE INTOX, 2ND DEG"  _tab "`count_82'" _tab "`pct_82'" _tab "`count_82'" _tab "`pct_82'" _n
  file write myfile "   MANSLAUGHTER, 1ST DEG"                               _tab "`count_83'" _tab "`pct_83'" _tab "`count_83'" _tab "`pct_83'" _n
  file write myfile "   MANSLAUGHTER, 2ND DEG"                               _tab "`count_85'" _tab "`pct_85'" _tab "`count_85'" _tab "`pct_85'" _n
  file write myfile "   MISCONDUCT W/ MOTOR VEHICLE"                         _tab "`count_86'" _tab "`pct_86'" _tab "`count_86'" _tab "`pct_86'" _n
  file write myfile "   MURDER"                                              _tab "`count_88'" _tab "`pct_88'" _tab "`count_88'" _tab "`pct_88'" _n
  file write myfile "   POSSESSION OF CHILD PORNOGRAPHY"                     _tab "`count_93'" _tab "`pct_93'" _tab "`count_93'" _tab "`pct_93'" _n
  file write myfile "   REG SEX OFFENDER: OFFENSE AGAINST MINOR"             _tab "`count_106'" _tab "`pct_106'" _tab "`count_106'" _tab "`pct_106'" _n
  file write myfile "   REG SEX OFFENDER: VIOLENT SEXUAL OFFENSE"            _tab "`count_107'" _tab "`pct_107'" _tab "`count_107'" _tab "`pct_107'" _n
  file write myfile "   SEXUAL ASSAULT, 1ST DEG"                             _tab "`count_121'" _tab "`pct_121'" _tab "`count_121'" _tab "`pct_121'" _n
  file write myfile "   SEXUAL ASSAULT, 2ND DEG"                             _tab "`count_122'" _tab "`pct_122'" _tab "`count_122'" _tab "`pct_122'" _n
  file write myfile "   SEXUAL ASSAULT, 3RD DEG"                             _tab "`count_123'" _tab "`pct_123'" _tab "`count_123'" _tab "`pct_123'" _n _n
  file write myfile "Crime Coded as Possibly Involving Serious Injury: Eliminated from Experimental Sample if Sentence > 1 Year" _n
  file write myfile "   ARSON, 1ST DEG"                                      _tab "`count_5'" _tab "`pct_5'" _tab "`count2_5'" _tab "`pct2_5'" _n
  file write myfile "   ARSON, 2ND DEG"                                      _tab "`count_6'" _tab "`pct_6'" _tab "`count2_6'" _tab "`pct2_6'" _n
  file write myfile "   ASSAULT W/ MOTOR VEHICLE WHILE INTOXICATED, 2ND DEG" _tab "`count_9'" _tab "`pct_9'" _tab "`count2_9'" _tab "`pct2_9'" _n
  file write myfile "   ASSAULT ON POLICE OR FIRE OFFICER"                   _tab "`count_11'" _tab "`pct_11'" _tab "`count2_11'" _tab "`pct2_11'" _n
  file write myfile "   ASSAULT, 1ST DEG, VICTIM OVER 60"                    _tab "`count_12'" _tab "`pct_12'" _tab "`count2_12'" _tab "`pct2_12'" _n
  file write myfile "   ASSAULT, 1ST DEG"                                    _tab "`count_13'" _tab "`pct_13'" _tab "`count2_13'" _tab "`pct2_13'" _n
  file write myfile "   ASSAULT, 2ND DEG"                                    _tab "`count_15'" _tab "`pct_15'" _tab "`count2_15'" _tab "`pct2_15'" _n
  file write myfile "   ROBBERY, 1ST DEG"                                    _tab "`count_109'" _tab "`pct_109'" _tab "`count2_109'" _tab "`pct2_109'" _n
  file write myfile "   STRANGULATION, 2ND DEG"                              _tab "`count_127'" _tab "`pct_127'" _tab "`count2_127'" _tab "`pct2_127'" _n _n 
  file write myfile "Total"                                               _tab "`sum_count'" _tab "`sum_pct'" _tab "`sum_count2'" _tab "`sum_pct2'" _n
file close myfile

clear

log close
