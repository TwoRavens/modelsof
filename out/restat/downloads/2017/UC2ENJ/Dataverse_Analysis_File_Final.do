/********************************************************************************
*** NC-VA-SC-KY-MO-AR SBIR, State Match Program (SMP), DUNS/NETS Project-level dataset
*** Analysis do file ***
*** Stata 14 used for analysis ***
*******************************************************************************/

	* Step 1: import csv file "SBIR project level data.csv"
clear all
set more off
*import delimited "XXX/SBIR project level data.csv", encoding(ISO-8859-1)

use "XXX/SBIR project level data.dta"
global dir "XXX/*Adjust Accordingly*"

********************************************************************************
** Primary Variables -- labels
********************************************************************************
*lab var d2 "Post-period"
*lab var d1 "Pre-period"
*label variable dT "Treated state"
*lab var d2_dT "Policy Effect"
lab var phase2 "Binary: Phase II award"
lab var p1prior_capacity "Phase I prior capacity, count"
lab var p1year "Year firm secured SBIR Phase I award"
lab var p2year "Year firm secured SBIR Phase II award"
lab var smp1year "Year firm secured State Match award"
lab var WomanOwn_dum "Binary: Woman owned"
lab var HUB_dum "Binary: HUB Zone firm"
lab var Minority_dum "Binary: Minority owned"
lab var p1cbsa_capacity_annual "Spillover: SBIR Phase I activity"
lab var yr_est_full "Year Established"
lab var Emp_p1year "Employment level, annual"
lab var agency "SBIR mission agency"
lab var smp1amt_pd_10k "State Match Amount, defalted ($10,000)"
lab var statecode "AR (4); KY (18); MO (26); NC (34); SC (41); VA (47)"
lab var firm_id "Unique Firm ID, de-identified"
lab var ind_naics_1 "Scientific R&D services (5417*)"
lab var ind_naics_2 "Architectural & engineering services (5413*)"
lab var ind_naics_3 "Computer system services (5414*)"
lab var	ind_naics_4 "Other services (541* not 5417, 5413, 5414)"
lab var ind_naics_5 "Metal related manufacturing (33*)"
lab var	ind_naics_6 "non-metal related manufacturing (31*, 32*)"
lab var ind_naics_7 "other (not 31-33; 54)"
lab var state "state"
lab var OutofBis_NETS "Out of business, NETS"
lab var NETS_match "Matched firm to NETS data"
lab var DunNum_match "Matched firm to DUNS data"
lab var agency_group_id "SBIR mission agency"
lab var LastMove_NETS "Last move, NETS"
lab var MoveYear_NETS "Year move, NTES"
foreach var in MoveYear_move_yr2 MoveYear_move_yr3 MoveYear_move_yr4 {
lab var `var' "Move Year (nth time)"
}
lab var State_NETS "State, NETS"
lab var state_uc "State, vet"
lab var OriginState_NETS "State origin, NETS"
lab var tot_HE_RD_exp_pd_cbsa_ln "Total Higher Education R&D, deflated in log form (state level)"
lab var VCamt_C_level_RP_paper2_pd_ln "Venture Capital Financing, deflated in log form (state level) PWC"
lab var log_applied_RD_deflated "Federal R&D, applied - deflated in log form (state level)"
lab var cohort "NC-VA-SC == 0; KY-AR-MO == 1"
lab var emp1_impute "Employment levels, imputed by means"
lab var dod "Funded by DOD"
lab var nsf "Funded by NSF"
lab var hhs "Funded by HHS"
lab var year "Year of Phase I"
lab var smp1 "Binary: State Match Award"
*lab var emp_change_dum "Binary: Any employment change"

********************************************************************************
***						Primary Results for Manuscript						 ***
********************************************************************************

********************************************************************************
** Table 1: Descriptive statistics (2002 - 2010)
{
preserve 
drop if p1year == 2006
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen d1 = 1 if p1year < 2006
recode d1 (.=0)
lab var d1 "Pre-period"
gen dT = 1 if state=="nc"|state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
drop if p1year < 2002
sum phase2
sum phase2 if d1 == 1
sum phase2 if d2 == 1
sum smp1amt_pd_10k
global variables WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year  
sum $variables
restore
}

********************************************************************************
** TABLE 2: Differential Model -- Analysis for significant results 	
{
	* DD model: phase2 = B0+d2+dT+d2*dT + CONTROLS 
	** d2: post-policy time period change
	** dT: treatment group, state that ever had the policy
	** d2_dT: change in Phase II success rates due to the policy
preserve 
drop if p1year == 2006
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"|state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
global ddcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global y phase2
drop if p1year < 2002
	** Table 2: Column 1
	reg $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Sample, NSF*) 

	** Table 2: Column 2
	drop if p1prior_capacity > 5
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 

	** Table 2: Column 3
	drop if p1prior_capacity > 3
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
	
	** Table 2: Column 4
	drop if p1prior_capacity > 1
	reg $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior)
restore
}
********************************************************************************
** TABLE 3: Marginal Model -- Analysis for significant results
{
global y phase2
global controls WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global x c.smp1amt_pd_10k

preserve 
set more off
	** Table 3: Column 1
	reg $y $x $controls, cluster(firm_id)
	outreg2 $y $x $controls using "$dir/Results/marginal output.xls", se see label bdec(3) rdec(3) replace addtext(Sample, SMP)
	** Table 3: Column 2
	drop if p1prior_capacity > 9
	reg $y $x $controls, cluster(firm_id)
	outreg2 $y $x $controls using "$dir/Results/marginal output.xls", se see label bdec(3) rdec(3) append addtext(Sample, SMP Prior 9)
	** Table 3: Column 3
	drop if p1prior_capacity > 5
	reg $y $x $controls, cluster(firm_id)
	outreg2 $y $x $controls using "$dir/Results/marginal output.xls", se see label bdec(3) rdec(3) append addtext(Sample, SMP Prior 5)
	** Table 3: Column 4
	drop if p1prior_capacity > 3
	reg $y $x $controls, cluster(firm_id)
	outreg2 $y $x $controls using "$dir/Results/marginal output.xls", se see label bdec(3) rdec(3) append addtext(Sample, SMP Prior 3)
restore
}
********************************************************************************
** Table 4: Robustness checks for differential model
{
	*Row A & B; Row C is derived: (Row B - Row A)
	*Note: Rows D & E are computed above as post specification tests for Table 2 results
preserve
set more off 
drop if p1year == 2006
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"|state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
global ddcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global y phase2
drop if p1year < 2002
** Table 4, Column 1
	* Row A
	logit $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id)
	margins, dydx(*) post
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Logit) 
		*margins, dydx(d2) at(dT = (0 1)) coeflegend post
		*di _b[1.d2:2._at]-_b[1.d2:1bn._at]
		*test _b[1.d2:2._at]=_b[1.d2:1bn._at]
	* Row B
	reg $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(LPM_Table 2) 
	* Row D
		predict yhat 
		sum yhat if agency == "nsf"
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor if agency == "nsf"
		drop yhat oor
	* Row E
		*keep if agency == "nsf"
		*cgmwildboot $y d2 dT d2_dT $ddcontrol, cluster(statecode) bootcluster(statecode) reps(1500) null(0 0 0 0 0 0 0 0 0) 
		* ME (marginal effect) d2_dT = 0.620; p-value 0.049 (1500)
	
** Table 4, Column 2
	* Row A
	drop if p1prior_capacity > 5
	logit $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id)
	margins, dydx(*) post
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Logit) 
		*margins, dydx(d2) at(dT = (0 1)) coeflegend post
		*di _b[1.d2:2._at]-_b[1.d2:1bn._at]
		*test _b[1.d2:2._at]=_b[1.d2:1bn._at]
	* Row B
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(LPM_Table 2) 
	* Row D
		predict yhat 
		sum yhat if agency == "hhs"
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor if agency == "hhs"
		drop yhat oor
	* Row E
		*keep if agency == "hhs"
		*cgmwildboot $y d2 dT d2_dT $ddcontrol, cluster(statecode) bootcluster(statecode) reps(1500) null(0 0 0 0 0 0 0 0 0) 
		*ME d2_dT = 0.099; p-value: 0.124 (1500)
	
** Table 4, Column 3
	* Row A
	drop if p1prior_capacity > 3
	logit $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id)
	margins, dydx(*) post
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Logit) 
		*margins, dydx(d2) at(dT = (0 1)) coeflegend post
		*di _b[1.d2:2._at]-_b[1.d2:1bn._at]
		*test _b[1.d2:2._at]=_b[1.d2:1bn._at]
	* Row B
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(LPM_Table 2) 
	* Row D
		predict yhat 
		sum yhat if agency == "hhs"
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor if agency == "hhs"
		drop yhat oor
	* Row E
		*keep if agency == "hhs"
		*cgmwildboot $y d2 dT d2_dT $ddcontrol, cluster(statecode) bootcluster(statecode) reps(1500) null(0 0 0 0 0 0 0 0 0) 
		* ME d2_dT = 0.127; p-value = 0.104(1500 reps)
	
** Table 4, Column 4
	* Row A
	drop if p1prior_capacity > 1
	logit $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id)
	margins, dydx(*) post
		outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Logit) 
		*margins, dydx(d2) at(dT = (0 1)) coeflegend post
		*di _b[1.d2:2._at]-_b[1.d2:1bn._at]
		*test _b[1.d2:2._at]=_b[1.d2:1bn._at]
	* Row B
	reg $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(LPM_Table 2)
	* Row D
		predict yhat 
		sum yhat if agency == "nsf"
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor if agency == "nsf"
		drop yhat oor
	* Row E
		*keep if agency == "nsf"
		*cgmwildboot $y d2 dT d2_dT $ddcontrol, cluster(statecode) bootcluster(statecode) reps(1500) null(0 0 0 0 0 0 0 0 0) 
		* ME d2_dT = 0.691; p-value = 0.052
	restore
}
********************************************************************************
** Table 5: Robustness checks for marginal model
{
global y phase2
global controls WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global x c.smp1amt_pd_10k

preserve 
set more off
	drop if p1prior_capacity > 9
** Table 5: Row A, Column 1
	logit $y $x $controls, cluster(firm_id) nolog
	margins, dydx(*) post 
		** Row B, Column 1 (re-reported from Table 3: Column 2)
	reg $y $x $controls, cluster(firm_id)
		** Row D, Column 1: OOR Predictions
		predict yhat 
		sum yhat 
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor 
		drop yhat oor

** Table 5: Row A, Column 2
	drop if p1prior_capacity > 5
	logit $y $x $controls, cluster(firm_id) nolog
	margins, dydx(*) post 
		** Row B, Column 2 (re-reported Table 3: Column 3)
	reg $y $x $controls, cluster(firm_id)
		** Row D, Column 2: OOR Predictions
		predict yhat 
		sum yhat 
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor 
		drop yhat oor

** Table 5: Row A, Column 3
	drop if p1prior_capacity > 3
	logit $y $x $controls, cluster(firm_id) nolog
	margins, dydx(*) post 
		** Row B, Column 3 (re-reported Table 3: Column 4)
	reg $y $x $controls, cluster(firm_id)
		** Row D, Column 2: OOR Predictions
		predict yhat 
		sum yhat 
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor 
		drop yhat oor
restore
}
********************************************************************************
** Table 6: Sensitivity analysis for differential model
{
preserve 
drop if p1year == 2006
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"|state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
global ddcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global y phase2
drop if p1year < 2002

	* Data prep
	** Complete Case Analysis
		global cca_control WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year 
	** code for DVA: recode yr_est = p1year & Emp = 1; include dummy variable for missing
		gen emp_dva = Emp_p1year
		recode emp_dva (.=1)
		gen dva_emp_dum = 1 if Emp_p1year ==.
		recode dva_emp_dum (.=0)
		gen yr_dva = yr_est_full
		replace yr_dva = p1year if yr_est_full == .
		gen dva_yr_dum = 1 if yr_est_full ==.
		recode dva_yr_dum (.=0)
		global dvacontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_dva emp_dva dva_yr_dum dva_emp_dum
	** Mean Imputation
		gen yr_impute_mean = yr_est_full
		replace yr_impute_mean = p1year - 6 if yr_est_full == .
		global MIcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_impute_mean emp1_impute
	** Remove incomplete data (remove NETS)
		global SBIRcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual
	* control_set in cca_control dvacontrol MIcontrol SBIRcontrol
		global controls WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_impute_mean emp1_impute

** Table 6, Column 1
	* Row A
	reg $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Sample, NSF*) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF*) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF*) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF*) 

** Table 6: Column 2
	drop if p1prior_capacity > 5
	* Row A
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
	
** Table 6: Column 3
	drop if p1prior_capacity > 3
	* Row A
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
	
** Table 6: Column 4
	drop if p1prior_capacity > 1
	* Row A
	reg $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol if agency == "nsf", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior) 
restore
}
********************************************************************************
** Table 7 Sensitivity Analysis: Marginal Model
{
global y phase2
global controls WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global x c.smp1amt_pd_10k
** Table 7, Column 1
preserve
	
	* Data prep
	** Complete Case Analysis
		global cca_control WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year 
	** code for DVA: recode yr_est = p1year & Emp = 1; include dummy variable for missing
		gen emp_dva = Emp_p1year
		recode emp_dva (.=1)
		gen dva_emp_dum = 1 if Emp_p1year ==.
		recode dva_emp_dum (.=0)
		gen yr_dva = yr_est_full
		replace yr_dva = p1year if yr_est_full == .
		gen dva_yr_dum = 1 if yr_est_full ==.
		recode dva_yr_dum (.=0)
		global dvacontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_dva emp_dva dva_yr_dum dva_emp_dum
	** Mean Imputation
		gen yr_impute_mean = yr_est_full
		replace yr_impute_mean = p1year - 6 if yr_est_full == .
		global MIcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_impute_mean emp1_impute
	** Remove incomplete data (remove NETS)
		global SBIRcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual
	* control_set in cca_control dvacontrol MIcontrol SBIRcontrol
		global controls WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_impute_mean emp1_impute

	* Row A
	reg $y $x $ddcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Sample, Full) 
	* Row B (Dummy Variable Analysis)
	reg $y $x $dvacontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, Full) 
	* Row C (Mean Imputation)
	reg $y $x $MIcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, Full) 
	* Row D (Limited SBIR controls)
	reg $y $x $SBIRcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, Full) 

** Table 7: Column 2
	drop if p1prior_capacity > 9
	* Row A
	reg $y $x $ddcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 9 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y $x $dvacontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 9 Prior) 
	* Row C (Mean Imputation)
	reg $y $x $MIcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 9 Prior) 
	* Row D (Limited SBIR controls)
	reg $y $x $SBIRcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 9 Prior) 
	
** Table 7: Column 3
	drop if p1prior_capacity > 5
	* Row A
	reg $y $x $ddcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 5 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y $x $dvacontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 5 Prior) 
	* Row C (Mean Imputation)
	reg $y $x $MIcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 5 Prior) 
	* Row D (Limited SBIR controls)
	reg $y $x $SBIRcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 5 Prior) 
	
** Table 7: Column 4
	drop if p1prior_capacity > 3
	* Row A
	reg $y $x $ddcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 3 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y $x $dvacontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 3 Prior) 
	* Row C (Mean Imputation)
	reg $y $x $MIcontrol, cluster(firm_id) 
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 3 Prior) 
	* Row D (Limited SBIR controls)
	reg $y $x $SBIRcontrol, cluster(firm_id) 
	outreg2  using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 3 Prior) 
restore
}
********************************************************************************
** Appendices 
********************************************************************************

********************************************************************************
** Appendix A
{
	* Table A.1
	* Note that this table was computed using the publicly available award data from the sbir awards database.
	* These results did not utilize the primary database.	
	
	* Table A.2
	* Note for statecode: AR (4); KY (18); MO (26); NC (34); SC (41); VA (47)
preserve 
set more off
drop if year < 2002
drop if p1year == 2006
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen d1 = 1 if p1year < 2006
recode d1 (.=0)
lab var d1 "Pre-period"
sort statecode
by statecode: sum phase2 if d1 == 1
by statecode: sum phase2 if d2 == 1
restore
}
********************************************************************************
** Appendix B
********************************************************************************
	* Table B.1
{
	/** Appendix B: assessment of NAICS codes
	naics1: Scientific R&D services (5417*)
	naics2: Architectural & engineering services (5413*)
	naics3: Computer system services (5414*)
	naics4: Other services (541* not 5417, 5413, 5414)
	naics5: metal related manufacturing (33*)
	naics6: non-metal related manufacturing (31*, 32*)
	naics7: other (not 31-33; 54)
	*/	
preserve
collapse (max) statecode ind_naics_1 ind_naics_2 ind_naics_3 ind_naics_4 ind_naics_5 ind_naics_6 ind_naics_7, by(firm_id)
sort statecode
by statecode: sum ind_naics_1 ind_naics_2 ind_naics_3 ind_naics_4 ind_naics_5 ind_naics_6 ind_naics_7
restore
}
********************************************************************************
	* Table B.2
{
global observed WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity
		* Full Sample, Full (Row A, Column 1)
preserve
	drop if year < 2002
	drop if p1year == 2006
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen d1 = 1 if p1year < 2006
	recode d1 (.=0)
	lab var d1 "Pre-period"
	gen dT = 1 if state=="nc"|state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

		* Full Sample, HHS (Row A, Column 2)
preserve
	keep if agency == "hhs"
	drop if year < 2002
	drop if p1year == 2006
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen d1 = 1 if p1year < 2006
	recode d1 (.=0)
	lab var d1 "Pre-period"
	gen dT = 1 if state=="nc"|state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

		* Full Sample, NSF (Row A, Column 3)
preserve
	keep if agency == "nsf"
	drop if year < 2002
	drop if p1year == 2006
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen d1 = 1 if p1year < 2006
	recode d1 (.=0)
	lab var d1 "Pre-period"
	gen dT = 1 if state=="nc"|state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

	* Less than 5 prior Sample, Full (Row B, Column 1)
preserve
	drop if year < 2002
	drop if p1year == 2006
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen d1 = 1 if p1year < 2006
	recode d1 (.=0)
	lab var d1 "Pre-period"
	gen dT = 1 if state=="nc"|state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	drop if p1prior_capacity > 5
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

		*Less than 5 prior Sample, HHS (Row B, Column 2)
preserve
	keep if agency == "hhs"
	drop if year < 2002
	drop if p1year == 2006
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen d1 = 1 if p1year < 2006
	recode d1 (.=0)
	lab var d1 "Pre-period"
	gen dT = 1 if state=="nc"|state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	keep if p1prior_capacity < 6
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

		* Less than 5 prior Sample, NSF (Row A, Column 3)
preserve
	keep if agency == "nsf"
	drop if year < 2002
	drop if p1year == 2006
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen d1 = 1 if p1year < 2006
	recode d1 (.=0)
	lab var d1 "Pre-period"
	gen dT = 1 if state=="nc"|state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	keep if p1prior_capacity < 6
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore
}
********************************************************************************
	* Table B.3
{
	* Row A	
		* Full Sample, Full (NC & KY) Eligible (Row A, Column 1)
preserve
keep if state == "nc" | state == "ky"
gen stateNC = 1 if state == "nc"
recode stateNC (.=0)
keep if p1year > 2005
keep firm_id p1year smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC 
sort firm_id p1year
collapse (max) smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC, by (firm_id p1year)
global observed WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
** Full Sample
	drop if stateNC == 0 & p1year == 2006
ttest `x', by(smp1) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore
	
		* Full Sample, North Carolina Eligible (Row A, Column 2)
preserve
keep if state == "nc" | state == "ky"
gen stateNC = 1 if state == "nc"
recode stateNC (.=0)
keep if p1year > 2005
keep firm_id p1year smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC 
sort firm_id p1year
collapse (max) smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC, by (firm_id p1year)
global observed WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
** NC sample
	keep if stateNC == 1 
ttest `x', by(smp1) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore
		
		* Full Sample, Kentucky Eligible (Row A, Column 3)
preserve
keep if state == "nc" | state == "ky"
gen stateNC = 1 if state == "nc"
recode stateNC (.=0)
keep if p1year > 2005
keep firm_id p1year smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC 
sort firm_id p1year
collapse (max) smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC, by (firm_id p1year)
global observed WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
** KY Sample
	keep if p1year > 2006 & stateNC == 0
ttest `x', by(smp1) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore

	* Row B	
		* Less than 5 prior Sample, Full (NC & KY) Eligible (Row B, Column 1)
preserve
keep if state == "nc" | state == "ky"
gen stateNC = 1 if state == "nc"
recode stateNC (.=0)
keep if p1year > 2005
keep firm_id p1year smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC 
sort firm_id p1year
collapse (max) smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC, by (firm_id p1year)
global observed WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity
* Stratify
keep if p1prior_capacity < 6
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
** Full Sample
	drop if stateNC == 0 & p1year == 2006
ttest `x', by(smp1) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore
	
		* Less than 5 prior Sample, North Carolina Eligible (Row B, Column 2)
preserve
keep if state == "nc" | state == "ky"
gen stateNC = 1 if state == "nc"
recode stateNC (.=0)
keep if p1year > 2005
keep firm_id p1year smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC 
sort firm_id p1year
collapse (max) smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC, by (firm_id p1year)
global observed WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity
* Stratify
keep if p1prior_capacity < 6
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
** NC sample
	keep if stateNC == 1 
ttest `x', by(smp1) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore
		
		* Less than 5 prior Sample, Kentucky Eligible (Row B, Column 3)
preserve
keep if state == "nc" | state == "ky"
gen stateNC = 1 if state == "nc"
recode stateNC (.=0)
keep if p1year > 2005
keep firm_id p1year smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC 
sort firm_id p1year
collapse (max) smp1 WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity stateNC, by (firm_id p1year)
global observed WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity
* Stratify
keep if p1prior_capacity < 6
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
** KY Sample
	keep if p1year > 2006 & stateNC == 0
ttest `x', by(smp1) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 	
}	
	
********************************************************************************
** Appendix C: No regression results reported.
********************************************************************************
** Appendix D	
	* Figure D.1
{
	* Flatter line
preserve
quietly logit phase2 c.smp1amt_pd_10k, cluster(firm_id) nolog 
margins, dydx(*)
margins, at(smp1amt_pd_10k=(3(1)13)) vsquish
marginsplot
restore
	* Steeper line
preserve
keep if p1capacity_total < 2
quietly logit phase2 c.smp1amt_pd_10k, cluster(firm_id) nolog 
margins, dydx(*)
margins, at(smp1amt_pd_10k=(3(1)13)) vsquish
marginsplot
restore
}
********************************************************************************
	** Appendix D.1: Imputation Techniques
********************************************************************************
	* Table D.1: data prep
{	
preserve 
	drop if p1year < 2002
	drop if p1year == 2006
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="nc"|state=="ky"
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	
	** Complete Case Analysis
	global cca_control WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year 

	** Dummy Variable Analysis (DVA): recode yr_est = p1year & Emp = 1; include dummy variable for missing
	gen emp_dva = Emp_p1year
	recode emp_dva (.=1)
	gen dva_emp_dum = 1 if Emp_p1year ==.
	recode dva_emp_dum (.=0)
	gen yr_dva = yr_est_full
	replace yr_dva = p1year if yr_est_full == .
	gen dva_yr_dum = 1 if yr_est_full ==.
	recode dva_yr_dum (.=0)
	global dvacontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_dva emp_dva dva_yr_dum dva_emp_dum

	** Mean Imputation
	gen yr_impute_mean = yr_est_full
	replace yr_impute_mean = p1year - 6 if yr_est_full == .
	global MIcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_impute_mean emp1_impute

	** Remove incomplete data (remove NETS)
	global SBIRcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual

	* Table D.1: Descriptive Statistics
	sum yr_est_full yr_dva yr_impute_mean 
	sum Emp_p1year emp_dva emp1_impute 
restore
}

	
********************************************************************************
	* Table D.2: KY Comparison of means
{
global observed WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity
		* KY Sample, Full (Row A, Column 1)
preserve
	keep if cohort == 1
	drop if year < 2002
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

		* KY Sample, HHS (Row A, Column 2)
preserve
	keep if agency == "hhs"
	keep if cohort == 1
	drop if year < 2002
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

		* KY Sample, NSF (Row A, Column 3)
preserve
	keep if agency == "nsf"
	keep if cohort == 1
	drop if year < 2002
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

	* KY Less than 5 prior Sample, Full (Row B, Column 1)
preserve
	keep if cohort == 1
	drop if year < 2002
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	drop if p1prior_capacity > 5
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

	* KY Less than 5 prior Sample, HHS (Row B, Column 2)
preserve
	keep if agency == "hhs"
	keep if cohort == 1
	drop if year < 2002
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	keep if p1prior_capacity < 6
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

	* KY Less than 5 prior Sample, NSF (Row A, Column 3)
preserve
	keep if agency == "nsf"
	keep if cohort == 1
	drop if year < 2002
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="ky"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	keep if p1prior_capacity < 6
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore
}

********************************************************************************
	* Table D.3: NC Comparison of means
{
global observed WomanOwn_dum HUB_dum Minority_dum yr_est_full Emp_p1year p1cbsa_capacity_annual p1prior_capacity
	* NC Sample, Full (Row A, Column 1)
preserve
	keep if cohort == 0
	drop if year < 2002
	gen d2 = 1 if p1year > 2005
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="nc"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

	* NC Sample, HHS (Row A, Column 2)
preserve
	keep if agency == "hhs"
	keep if cohort == 0
	drop if year < 2002
	gen d2 = 1 if p1year > 2005
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="nc"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

	* NC Sample, NSF (Row A, Column 3)
preserve
	keep if agency == "nsf"
	keep if cohort == 0
	drop if year < 2002
	gen d2 = 1 if p1year > 2005
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="nc"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

	* NC Less than 5 prior Sample, Full (Row B, Column 1)
preserve
	keep if cohort == 0
	drop if year < 2002
	gen d2 = 1 if p1year > 2005
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="nc"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	drop if p1prior_capacity > 5
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

	* NC Less than 5 prior Sample, HHS (Row B, Column 2)
preserve
	keep if agency == "hhs"
	keep if cohort == 0
	drop if year < 2002
	gen d2 = 1 if p1year > 2005
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="nc"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	keep if p1prior_capacity < 6
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore 

	* NC Less than 5 prior Sample, NSF (Row A, Column 3)
preserve
	keep if agency == "nsf"
	keep if cohort == 0
	drop if year < 2002
	gen d2 = 1 if p1year > 2005
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="nc"	
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "Policy Effect"
	keep if p1prior_capacity < 6
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\.)
matrix m2 = m2\(r(mu_2)\.)
matrix m3 = m3\(r(t)\r(p))
}
matrix q1 = (m1[2..15,1..1],m2[2..15,1..1],m3[2..15,1..1])
matrix colnames q1 = control treat t-stat
matrix rownames q1 = Woman_own . HUBZone . Minority . yr_est . Employment . CBSA_SBIR . SBIR_prior . 
matrix drop m1 m2 m3
mat list q1
restore
}

********************************************************************************
	* Table D.4: NC Differential Model
{
preserve 
keep if cohort == 0
gen d2 = 1 if p1year > 2005
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
global ddcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global y phase2
drop if p1year < 2002

	** Table D.4, Column 1
	drop if p1prior_capacity > 5
	reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Sample, Full 5 Prior) 

	** Table D.4: Column 2
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
	
	** Table 2: Column 4
	drop if p1prior_capacity > 3
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior)
restore
}
	
********************************************************************************	
	* Table D.5: NC Robustness checks for differential model
{
	*Row A & B; Row C is derived: (Row B - Row A)
preserve
set more off
keep if cohort == 0
gen d2 = 1 if p1year > 2005
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
global ddcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global y phase2
drop if p1year < 2002
** Table D.5, Column 1
	* Row A
	drop if p1prior_capacity > 5
	logit $y d2 dT d2_dT $ddcontrol, cluster(firm_id)
	margins, dydx(*) post
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Logit) 
	* Row B
	reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(LPM) 
	* Row D
		predict yhat 
		sum yhat 
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor
		drop yhat oor
	
** Table D.5, Column 2
	* Row A
	logit $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id)
	margins, dydx(*) post
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Logit) 
	* Row B
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(LPM) 
	* Row D
		predict yhat 
		sum yhat if agency == "hhs"
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor if agency == "hhs"
		drop yhat oor

** Table D.5, Column 3
	* Row A
	drop if p1prior_capacity > 3
	logit $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id)
	margins, dydx(*) post
	outreg2 using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Logit) 
	* Row B
	reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(LPM) 
	* Row D
		predict yhat 
		sum yhat if agency == "hhs"
		gen oor=yhat<0|yhat>1 &yhat!=.
		tab oor if agency == "hhs"
		drop yhat oor
restore	
}
********************************************************************************
	* Table D.6: NC Sensitivity analysis for differential model
{
preserve 
set more off
keep if cohort == 0
gen d2 = 1 if p1year > 2005
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
global ddcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global y phase2
drop if p1year < 2002

	* Data prep
	** Complete Case Analysis
		global cca_control WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year 
	** code for DVA: recode yr_est = p1year & Emp = 1; include dummy variable for missing
		gen emp_dva = Emp_p1year
		recode emp_dva (.=1)
		gen dva_emp_dum = 1 if Emp_p1year ==.
		recode dva_emp_dum (.=0)
		gen yr_dva = yr_est_full
		replace yr_dva = p1year if yr_est_full == .
		gen dva_yr_dum = 1 if yr_est_full ==.
		recode dva_yr_dum (.=0)
		global dvacontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_dva emp_dva dva_yr_dum dva_emp_dum
	** Mean Imputation
		gen yr_impute_mean = yr_est_full
		replace yr_impute_mean = p1year - 6 if yr_est_full == .
		global MIcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_impute_mean emp1_impute
	** Remove incomplete data (remove NETS)
		global SBIRcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual
	* control_set in cca_control dvacontrol MIcontrol SBIRcontrol
		global controls WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_impute_mean emp1_impute

** Table D.6, Column 1
	drop if p1prior_capacity > 5
	* Row A
	reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Sample, Full 5 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, Full 5 Prior) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, Full 5 Prior) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, Full 5 Prior) 

** Table D.6: Column 2
	keep if agency == "hhs"
	* Row A
	reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
	
** Table D.6: Column 3
	drop if p1prior_capacity > 3
	* Row A
	reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
restore
}
********************************************************************************
	* Table D.7: KY Sensitivity analysis for differential model
{
preserve 
set more off
keep if cohort == 1
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
global ddcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global y phase2
drop if p1year < 2002

	* Data prep
	** Complete Case Analysis
		global cca_control WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year 
	** code for DVA: recode yr_est = p1year & Emp = 1; include dummy variable for missing
		gen emp_dva = Emp_p1year
		recode emp_dva (.=1)
		gen dva_emp_dum = 1 if Emp_p1year ==.
		recode dva_emp_dum (.=0)
		gen yr_dva = yr_est_full
		replace yr_dva = p1year if yr_est_full == .
		gen dva_yr_dum = 1 if yr_est_full ==.
		recode dva_yr_dum (.=0)
		global dvacontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_dva emp_dva dva_yr_dum dva_emp_dum
	** Mean Imputation
		gen yr_impute_mean = yr_est_full
		replace yr_impute_mean = p1year - 6 if yr_est_full == .
		global MIcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_impute_mean emp1_impute
	** Remove incomplete data (remove NETS)
		global SBIRcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual
	* control_set in cca_control dvacontrol MIcontrol SBIRcontrol
		global controls WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_impute_mean emp1_impute

** Table D.7, Column 1
	drop if agency != "nsf" 
	* Row A
	reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Sample, Full NSF) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, Full NSF) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, Full NSF) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, Full NSF) 

** Table D.7: Column 2
	drop if p1prior_capacity > 5
	* Row A
	reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 5 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 5 Prior) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 5 Prior) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 5 Prior) 
	
** Table D.7: Column 3
	drop if p1prior_capacity > 3
	* Row A
	reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 3 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 3 Prior) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 3 Prior) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 3 Prior) 
	
** Table D.7: Column 4
	drop if p1prior_capacity > 1
	* Row A
	reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior) 
	* Row B (Dummy Variable Analysis)
	reg $y d2 dT d2_dT $dvacontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $dvacontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior) 
	* Row C (Mean Imputation)
	reg $y d2 dT d2_dT $MIcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $MIcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior) 
	* Row D (Limited SBIR controls)
	reg $y d2 dT d2_dT $SBIRcontrol, cluster(firm_id) 
	outreg2 $y d2 dT d2_dT $SBIRcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior) 
restore
}
********************************************************************************
	* Table D.8 Firm survival
{	
	*Manuscript: Section 6.1 Other Considerations
	*Results: Appendix D, Section D.3

preserve
destring OutofBis_NETS, replace
sum OutofBis_NETS
drop if p1year == 2006
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"|state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
recode NETS_match (.=0)
count if NETS_match == 0
	*2558 projects out of 2882 have NETS (88.75 percent)
	*sans year 2006, 2341 out of 2637 have NETS (88.77 percent) 

		* Adjust data from project to firm-level
sort firm_id p1year
by firm_id: egen last_p1year = max(p1year)
drop if last_p1year != p1year
sort firm_id
collapse d2 dT d2_dT DunNum_match NETS_match OutofBis_NETS WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual p1year p1prior_capacity agency_group_id, by (firm_id)
sum d2 dT d2_dT DunNum_match NETS_match OutofBis_NETS WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual p1year p1prior_capacity
global ddcontrols WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual

	* Table D.8
ttest DunNum_match if dT == 1, by (d2_dT) unequal
ttest DunNum_match if dT == 0, by (d2) unequal


********************************************************************************
	*Additional assessment of firm survival
	*Manuscript: Section 6.1 Other Considerations
	*Results: Appendix D, Section D.3
	
drop if p1year < 2002
global y DunNum_match
reg $y d2 dT d2_dT $ddcontrols, cluster(firm_id)
reg $y d2 dT d2_dT $ddcontrols if p1prior_capacity < 6, cluster(firm_id)
reg $y d2 dT d2_dT $ddcontrols if agency_group_id == 10, cluster(firm_id)
reg $y d2 dT d2_dT $ddcontrols if agency_group_id == 8, cluster(firm_id)
global y NETS_match
reg $y d2 dT d2_dT $ddcontrols, cluster(firm_id)
reg $y d2 dT d2_dT $ddcontrols if p1prior_capacity < 6, cluster(firm_id)
reg $y d2 dT d2_dT $ddcontrols if agency_group_id == 10, cluster(firm_id)
reg $y d2 dT d2_dT $ddcontrols if agency_group_id == 8, cluster(firm_id)
restore	

}
********************************************************************************
	** Analysis fir references in text (not reported in tables or figures)
	
	***********************
	** Objective: Firm behavior: tracking firm movement either to or from treated states
	** Manuscript: Discussed in Manuscript Section 3.2.3
	** Results: Reported in text of manuscript
	***********************
{
preserve
destring LastMove_NETS MoveYear_NETS MoveYear_move_yr*, replace
drop if p1year < 2002
gen move_state1 = 1 if State_NETS != state_uc
lab var move_state1 "Binary: SBIR != NETS state identification"
recode move_state1 (.=0)
replace move_state1 = . if State_NETS == ""
keep if move_state1== 1
gen move_to_treated1 = 1 if state_uc == "KY" & move_state1 == 1 
replace move_to_treated1 = 1 if state_uc == "NC" & move_state1 == 1
replace move_to_treated1 = 1 if State_NETS == "KY" & move_state1 == 1 
replace move_to_treated1 = 1 if State_NETS == "NC" & move_state1 == 1 
recode move_to_treated1 (.=0)
sort firm_id
collapse move_to_treated1, by(firm_id)
	*19 firms moved either in or out of the treated states
	*20 firms moved either in or out of the nontreated states
restore
	* Compare NETS Origin to NETS
preserve
destring MoveYear_NETS, replace
gen move_state2 = 1 if State_NETS != OriginState_NETS 
replace move_state2 = . if OriginState_NETS == ""
replace move_state2 = . if State_NETS == ""
lab var move_state2 "Binary: OriginNETS != NETS state identification"
gen move_from_treated2 = 1 if OriginState_NETS == "KY" & move_state2== 1 
replace move_from_treated2 = 1 if OriginState_NETS == "NC" & move_state2== 1
	*17 proposals
gen move_to_treated2 = 1 if State_NETS == "KY" & move_state2== 1
replace move_to_treated2 = 1 if State_NETS == "NC" & move_state2== 1
	*40 proposals 
gen move_nontreated = 1 if move_state2 == 1 & move_from_treated != 1 & move_to_treated !=1
	*155 proposal
sort firm_id
collapse move_to_treated2 move_from_treated2 move_nontreated MoveYear_NETS, by(firm_id)
	* 12 firms moved to treated
	* 10 firms moved from treated
	* 23 firms moved to or from nontreated states
restore 
}

	***********************
	** Objective: Mechanisms of SMP regarding timing 
	** Manuscript: Discussed in section, 6. Discussion
	** Results: Reported in text of manuscript
	***********************
{
	gen timelag =p2year-p1year
	preserve 
	drop if p1year < 2006
	drop if state == "nc" & smp1 ==0
	drop if state == "ky" & smp1 ==0
	ttest timelag, by(smp1)
	restore
}	

	***********************
	** Objective: Analysis of Alternative Outcomes - Employment Change
	** Manuscript: Discussed in section, 6. Discussion & Appendix D, section D.3.1 - Employment Change
	** Results: Referenced in text of manuscript
	***********************
{
	** IMPUTE employment data
gen p2yr_impute = p2year
replace p2yr_impute = p1year+1 if p2yr_impute ==.
lab var p2yr_impute "Phase 2 yr, includes imputed values if missing: p1yr+1"
** the average time lag from Phase 1 to Phase 2 is 1.2 years, thus add 1 year for p2 is project not secure a phase 2.
gen yr_est_missing = 1 if yr_est_full == . 
replace yr_est_full = p1year if yr_est_missing == 1
gen yr_est_error = 1 if yr_est_full > p1year
replace yr_est_full = p1year if yr_est_full > p1year
gen firm_age_p1 = p1year - yr_est_full
gen firm_age_p2 = p2yr_impute - yr_est_full
** employment data: Emp_p1year, Emp_p2year_full
* impute missing values
drop emp1_impute
gen emp1_impute = Emp_p1year
*tab firm_age_p1 if emp1_impute == .
** 513 projects do not have employee information; impute the average employment for firms of the same age
** gather these variables from the following command: sum Emp_p1year if firm_age_p1 == `x'
replace emp1_impute = 3.08 if firm_age_p1 == 0 & Emp_p1year ==.
replace emp1_impute = 4.78 if firm_age_p1 == 1 & Emp_p1year ==.
replace emp1_impute = 5.68 if firm_age_p1 == 2 & Emp_p1year ==.
replace emp1_impute = 6.92 if firm_age_p1 == 3 & Emp_p1year ==.
replace emp1_impute = 8.87 if firm_age_p1 == 4 & Emp_p1year ==.
replace emp1_impute = 8.59 if firm_age_p1 == 5 & Emp_p1year ==.
replace emp1_impute = 11.57 if firm_age_p1 == 6 & Emp_p1year ==.
replace emp1_impute = 14.39 if firm_age_p1 == 7 & Emp_p1year ==.
replace emp1_impute = 13.23 if firm_age_p1 == 8 & Emp_p1year ==.
replace emp1_impute = 17.5 if firm_age_p1 == 9 & Emp_p1year ==.
replace emp1_impute = 19.58 if firm_age_p1 == 10 & Emp_p1year ==.
replace emp1_impute = 27.52 if firm_age_p1 == 11 & Emp_p1year ==.
replace emp1_impute = 30.47 if firm_age_p1 == 12 & Emp_p1year ==.
replace emp1_impute = 31.92 if firm_age_p1 == 13 & Emp_p1year ==.
replace emp1_impute = 35.22 if firm_age_p1 == 14 & Emp_p1year ==.
replace emp1_impute = 39.61 if firm_age_p1 == 15 & Emp_p1year ==.
replace emp1_impute = 38.85 if firm_age_p1 == 16 & Emp_p1year ==.
replace emp1_impute = 43.83 if firm_age_p1 == 18 & Emp_p1year ==.
replace emp1_impute = 29.03 if firm_age_p1 == 22 & Emp_p1year ==.
replace emp1_impute = 54.26 if firm_age_p1 == 26 & Emp_p1year ==.
replace emp1_impute = 65.31 if firm_age_p1 == 27 & Emp_p1year ==.
replace emp1_impute = 94.6 if firm_age_p1 == 29 & Emp_p1year ==.
replace emp1_impute = 27.44 if firm_age_p1 > 29 & Emp_p1year ==.


gen emp2_impute = Emp_p2year_full
*tab firm_age_p2 if emp2_impute == .
** 472 projects do not have employee information; impute the average employment for firms of the same age drawing upon Emp_p2year_full data
** gather these variables from the following command: sum Emp_p2year_full if firm_age_p2 == `x'
replace emp2_impute = 2.94 if firm_age_p2 == 0 & Emp_p2year_full == .
replace emp2_impute = 2.94 if firm_age_p2 == 1 & Emp_p2year_full == .
replace emp2_impute = 5.22 if firm_age_p2 == 2 & Emp_p2year_full == . 
replace emp2_impute = 6.88 if firm_age_p2 == 3 & Emp_p2year_full == . 
replace emp2_impute = 7.28 if firm_age_p2 == 4 & Emp_p2year_full == . 
replace emp2_impute = 11.85 if firm_age_p2 == 5 & Emp_p2year_full == . 
replace emp2_impute = 9.85 if firm_age_p2 == 6 & Emp_p2year_full == . 
replace emp2_impute = 13.31 if firm_age_p2 == 7 & Emp_p2year_full == . 
replace emp2_impute = 13.39 if firm_age_p2 == 8 & Emp_p2year_full == . 
replace emp2_impute = 12.74 if firm_age_p2 == 9 & Emp_p2year_full == . 
replace emp2_impute = 20.82 if firm_age_p2 == 10 & Emp_p2year_full == . 
replace emp2_impute = 23.87 if firm_age_p2 == 11 & Emp_p2year_full == . 
replace emp2_impute = 28.11 if firm_age_p2 == 12 & Emp_p2year_full == . 
replace emp2_impute = 30.86 if firm_age_p2 == 13 & Emp_p2year_full == . 
replace emp2_impute = 28.61 if firm_age_p2 == 14 & Emp_p2year_full == . 
replace emp2_impute = 35.65 if firm_age_p2 == 15 & Emp_p2year_full == . 
replace emp2_impute = 37.71 if firm_age_p2 == 16 & Emp_p2year_full == . 
replace emp2_impute = 37.82 if firm_age_p2 == 17 & Emp_p2year_full == . 
replace emp2_impute = 38.45 if firm_age_p2 == 22 & Emp_p2year_full == . 
replace emp2_impute = 34.95 if firm_age_p2 == 26 & Emp_p2year_full == .  
replace emp2_impute = 53.06 if firm_age_p2 == 27 & Emp_p2year_full == . 
replace emp2_impute = 78.63 if firm_age_p2 == 28 & Emp_p2year_full == . 
replace emp2_impute = 83 if firm_age_p2 == 30 & Emp_p2year_full == . 
replace emp2_impute = 27.69 if firm_age_p2 > 30 & Emp_p2year_full == . 
gen emp_change_impute = emp2_impute - emp1_impute
lab var emp_change_impute "Emp change, using imputed values"
gen emp_change_dum = 1 if emp_change_impute > 0
recode emp_change_dum (.=0) 
lab var emp_change_dum "Job Creation"

	
	preserve 
	drop if p1year == 2006
	gen d2 = 1 if p1year > 2006
	recode d2 (.=0)
	label var d2 "Post-period"
	gen dT = 1 if state=="nc"|state=="ky"
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT = d2*dT
	lab var d2_dT "SMP Policy Effect"
	global ddcontrol tot_HE_RD_exp_pd_cbsa_ln VCamt_C_level_RP_paper2_pd_ln log_applied_RD_deflated 
	global y emp_change_dum
	drop if p1year < 2002
	*drop if p1prior_capacity > 5

reg $y d2 dT d2_dT $ddcontrol, cluster(firm_id) 
reg $y d2 dT d2_dT $ddcontrol if agency == "dod", cluster(firm_id) 
reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
reg $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id) 
	restore

	preserve
	gen d2_nc = 1 if p1year > 2005
	recode d2_nc (.=0)
	label variable d2_nc "NC Post-period"
	gen dT = 1 if state=="nc"|state=="ky"
	recode dT (.=0)
	label variable dT "Treated state"
	gen d2_dT_nc = d2_nc*dT
	lab var d2_dT_nc "NC SMP-I policy"
	gen d2_ky = 1 if p1year > 2006
	recode d2_ky (.=0)
	label variable d2_ky "KY Post-period"
	gen d2_dT_ky = d2_ky*dT
	lab var d2_dT_ky "KY SMP-I policy"
	global y emp_change_dum
	global ddcontrol tot_HE_RD_exp_pd_cbsa_ln VCamt_C_level_RP_paper2_pd_ln log_applied_RD_deflated 
	drop if p1year < 2002

/* For NC cohort
reg $y d2_nc dT d2_dT_nc $ddcontrol if cohort == 0, cluster(firm_id) 
reg $y d2_nc dT d2_dT_nc $ddcontrol if cohort == 0 & agency == "dod", cluster(firm_id) 
reg $y d2_nc dT d2_dT_nc $ddcontrol if cohort == 0 & agency == "hhs", cluster(firm_id) 
	** in looking at the distribution the large majority takes place in DOD and HHS for NC* cohort (thus not report NSF)
restore 
*/

* For KY cohort
reg $y d2_ky dT d2_dT_ky $ddcontrol if cohort == 1, cluster(firm_id) 
reg $y d2_ky dT d2_dT_ky $ddcontrol if cohort == 1 & agency == "dod", cluster(firm_id) 
reg $y d2_ky dT d2_dT_ky $ddcontrol if cohort == 1 & agency == "hhs", cluster(firm_id) 
reg $y d2_ky dT d2_dT_ky $ddcontrol if cohort == 1 & agency == "nsf", cluster(firm_id) 

*/
restore 
	** note, not find results for this outcome. Why? likely related to the accuracy of the data (e.g. much is imputed)
}
	
	***********************
	** Objective: Review of time trends of outcome variable across treated and control geographies 
	***********************
{
		* outcome: phase2
		sort state p1year
		set more off
		by state p1year: sum phase2
		gen dT = 1 if state == "nc"|state =="ky"
		recode dT (.=0)
		sort dT p1year
		set more off
		by dT p1year: sum phase2
		by dT p1year: sum phase2 if p1prior_capacity < 6
		drop dT
}	
	
	***********************
	** Objective: Triple Difference
	** Manuscript: Discussed in section, 5.3 Robustness checks 
	** Results: Referenced in text of manuscript -- not reported
	***********************
{
********************************************************************************
*ROBUSTNESS* DDD (include agency in the analysis) 
* 1.a NSF vs. Non-NSF
* 1.b HHS vs. Non-HHS
* 1.c NSF_HHS vs. Non-NSF_HHS
********************************************************************************
preserve 
drop if p1year == 2006
gen d2 = 1 if p1year > 2006
foreach x in nsf_hhs {
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"|state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen d`x' = 1 if agency == "nsf" | agency == "hhs"
recode d`x' (.=0)
label variable d`x' "SBIR `x'"
gen dT_d`x' = dT * d`x'
lab var dT_d`x' "State_`x'"
gen d2_d`x' = d2*d`x'
lab var d2_d`x' "Post_`x'"
gen d2_dT = d2*dT
lab var d2_dT "Non_`x' Policy Effect"
gen d2_dT_d`x' = d2*dT*d`x'
lab var d2_dT_d`x' "`x' Policy Effect"
br d2 dT d`x' dT_d`x' d2_d`x' d2_dT d2_dT_d`x'
global y phase2
drop if p1year < 2002
*global ddcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full_impute emp1_impute 
global ddcontrol WomanOwn_dum HUB_dum Minority_dum 
reg $y d2 dT d`x' dT_d`x' d2_d`x' d2_dT d2_dT_d`x' $ddcontrol, cluster(firm_id) 
outreg2 $y d2 dT d`x' dT_d`x' d2_d`x' d2_dT d2_dT_d`x' $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Sample, Total*)
drop if p1prior_capacity > 5
reg $y d2 dT d`x' dT_d`x' d2_d`x' d2_dT d2_dT_d`x' $ddcontrol, cluster(firm_id) 
outreg2 $y d2 dT d`x' dT_d`x' d2_d`x' d2_dT d2_dT_d`x' $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 5 Prior)
drop if p1prior_capacity > 3
reg $y d2 dT d2 dT d`x' dT_d`x' d2_d`x' d2_dT d2_dT_d`x' $ddcontrol, cluster(firm_id) 
outreg2 $y d2 dT d`x' dT_d`x' d2_d`x' d2_dT d2_dT_d`x' $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 3 Prior)
drop if p1prior_capacity > 1
reg $y d2 dT d`x' dT_d`x' d2_d`x' d2_dT d2_dT_d`x' $ddcontrol, cluster(firm_id) 
outreg2 $y d2 dT d`x' dT_d`x' d2_d`x' d2_dT d2_dT_d`x' $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, 1 Prior)
}
restore

********************************************************************************
*ROBUSTNESS* DDD (include innovative activity in the analysis) 
* 2.a 5 Prior vs. More than 5
* 2.b 3 Prior vs. More than 3
* 2.c 1 Prior vs. More than 1
* note drop mills
********************************************************************************
preserve 
drop if p1year == 2006
drop if p1prior_capacity > 30
foreach x in 5 {
gen dprior = 1 if p1prior_capacity < 6
recode dprior (.=0)
lab var dprior "`x' Prior SBIR"
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"|state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen dT_dprior = dT * dprior
lab var dT_dprior "State_Prior SBIR"
gen d2_dprior = d2*dprior
lab var d2_dprior "Post_Prior SBIR"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect: More than `x' Prior"
gen d2_dT_dprior = d2*dT*dprior
lab var d2_dT_dprior "Policy Effect: `x' or Less Prior"
br d2 dT dprior dT_dprior d2_dprior d2_dT d2_dT_dprior
global y phase2
drop if p1year < 2002
** prior capacity: full; 5 (~65% of sample); 2 (~52% of sample); 0 (~33% of sample)
global ddcontrol WomanOwn_dum HUB_dum Minority_dum 
reg $y d2 dT dprior dT_dprior d2_dprior d2_dT d2_dT_dprior $ddcontrol, cluster(firm_id) 
outreg2 $y d2 dT dprior dT_dprior d2_dprior d2_dT d2_dT_dprior $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) replace addtext(Sample, Total*)
reg $y d2 dT dprior dT_dprior d2_dprior d2_dT d2_dT_dprior $ddcontrol if agency == "dod", cluster(firm_id) 
outreg2 $y d2 dT dprior dT_dprior d2_dprior d2_dT d2_dT_dprior $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, DOD)
reg $y d2 dT dprior dT_dprior d2_dprior d2_dT d2_dT_dprior $ddcontrol if agency == "hhs", cluster(firm_id) 
outreg2 $y d2 dT dprior dT_dprior d2_dprior d2_dT d2_dT_dprior $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS)
reg $y d2 dT dprior dT_dprior d2_dprior d2_dT d2_dT_dprior $ddcontrol if agency == "nsf", cluster(firm_id) 
outreg2 $y d2 dT dprior dT_dprior d2_dprior d2_dT d2_dT_dprior $ddcontrol using "$dir/Results/DD output.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF)
}
restore
}

	***********************
	** Objective: Propensity Matching Score 
	** Manuscript: Discussed in section, 5.3 Robustness checks 
	** Results: Referenced in text of manuscript -- not reported
	***********************
{	
*Observed variables: firm_age, Woman Owned, HUBZone, Minority, SBIR capacity, employment, agency

** ttest for treated and control groups **
global observed yr_est_full WomanOwn_dum HUB_dum Minority_dum p1prior_capacity emp1_impute dod nsf hhs
preserve
keep if cohort == 1
drop if p1year < 2002
keep if p1prior_capacity < 6
keep if agency == "nsf" 
*drop if p1year == 2006
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state == "ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
foreach x in $observed {
set more off
di "T-test of means for `x'"
ttest `x', by(d2_dT) unequal
matrix m1 = m1\(r(mu_1)\r(sd_1))
matrix m2 = m2\ (r(mu_2)\r(sd_2))
matrix m3 = m3\(r(t)\.)
}
* format the matrix * 6 variables (2 lines each plus header row = 13)
matrix q1 = (m1[2..19,1..1],m2[2..19,1..1],m3[2..19,1..1])
matrix colnames q1 = control treat t-stat
matrix drop m1 m2 m3
mat list q1
restore 

** estimate propensity scores & graph the overlap for different stratifications: these include -- FULL, FULL NSF, NC HHS, NC HHS_NSF, KY NSF
global observed yr_est_full WomanOwn_dum HUB_dum Minority_dum p1prior_capacity emp1_impute dod nsf hhs
preserve
set more off
keep if cohort == 1
drop if p1year < 2002
keep if agency == "nsf" 
*drop if p1year == 2006
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
global y phase2
logit d2_dT $observed  
predict ps1 if d2_dT !=.
twoway (histogram ps1 if d2_dT==1, start(0.0) width(0.05) fcolor(none) lcolor(gray)) (histogram ps1 if d2_dT==0, start(0.0) width(0.05) fcolor(none) lcolor(black) lpattern(dash)), legend(off) title("PS overlap") saving(Full, replace)
keep if p1prior_capacity < 6
logit d2_dT $observed  
predict ps2 if d2_dT !=.
twoway (histogram ps2 if d2_dT==1, start(0.0) width(0.05) fcolor(none) lcolor(gray)) (histogram ps2 if d2_dT==0, start(0.0) width(0.05) fcolor(none) lcolor(black) lpattern(dash)), legend(off) title("PS overlap") saving(5less, replace)
graph combine Full.gph 5less.gph, row(1) imargin(0 0 0 0) xcommon 
graph export fig1.png, replace
restore 

** PSM: nearest neighbor; kernel; llr
preserve
set seed 12345
gen sorter = uniform()
sort sorter
gen age2 = firm_age*firm_age
gen prior2 = p1prior_capacity*p1prior_capacity
global observed firm_age age2 WomanOwn_dum HUB_dum Minority_dum p1prior_capacity prior2 emp1_impute nsf hhs
set more off
*keep if cohort == 0
drop if p1year < 2002
keep if agency == "hhs"|agency=="nsf"
keep if p1prior_capacity < 5
drop if p1year == 2006
gen d2 = 1 if p1year > 2005
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc" | state == "ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
global y phase2
matrix m1=(1)
matrix m2=(1)
matrix m3=(1)
psmatch2 d2_dT $observed, out($y) common neighbor(1)
matrix m1 = m1\(r(att)\r(seatt)\(r(att)/r(seatt))) 
psmatch2 d2_dT $observed, out($y) common kernel bwidth(.2) kerneltype(normal)
matrix m2 = m2\(r(att)\r(seatt)\(r(att)/r(seatt))) 
psmatch2 d2_dT $observed, out($y) common llr bwidth(.2) kerneltype(normal)
matrix m3 = m3\(r(att)\r(seatt)\(r(att)/r(seatt))) 
*return list
matrix q1 = (m1[2..4,1..1],m2[2..4,1..1],m3[2..4,1..1])
matrix colnames q1 = Nearest Kernel LLR
matrix rownames q1 = ATT SE Tstat
matrix drop m1 m2 m3
mat list q1
restore 
}	

	***********************
	** Objective: Difference-in-Differences Linear Time Trend 
	** Manuscript: Not reported, conducted as additional checks 
	** Results: Not reported
	***********************
{
********************************************************************************
*** DD LINEAR TIME TRENDS *** Additional ROBUSTNESS CHECK ** 
********************************************************************************
preserve
drop if p1year == 2006
gen d2 = 1 if p1year > 2006
recode d2 (.=0)
label var d2 "Post-period"
gen dT = 1 if state=="nc"|state=="ky"
recode dT (.=0)
label variable dT "Treated state"
gen d2_dT = d2*dT
lab var d2_dT "Policy Effect"
drop if p1year < 2002
tab p1year, gen(T)
forvalues i = 1/8 {
gen T`i'dT = T`i'*dT
}
gen time = 1 if p1year == 2002
replace time = 2 if p1year == 2003
replace time = 3 if p1year == 2004
replace time = 4 if p1year == 2005
replace time = 5 if p1year == 2007
replace time = 6 if p1year == 2008
replace time = 7 if p1year == 2009
replace time = 8 if p1year == 2010
gen timetreat = time*dT
label var timetreat "Linear Time Trend"
*global ddcontrol WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year
global ddcontrol1 dT p1year timetreat T5 T5dT WomanOwn_dum HUB_dum Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year 
global y phase2
* Analysis for significant results
reg $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id) 
outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output LTT.xls", se see label bdec(3) rdec(3) replace addtext(Sample, NSF*) 
reg $y $ddcontrol1 if agency == "nsf", cluster(firm_id) 
outreg2 $y $ddcontrol1 using "$dir/Results/DD output LTT.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF*) 
drop if p1prior_capacity > 5
reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output LTT.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
reg $y $ddcontrol1 if agency == "hhs", cluster(firm_id) 
outreg2 $y $ddcontrol1 using "$dir/Results/DD output LTT.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 5 Prior) 
drop if p1prior_capacity > 3
reg $y d2 dT d2_dT $ddcontrol if agency == "hhs", cluster(firm_id) 
outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output LTT.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
reg $y $ddcontrol1 if agency == "hhs", cluster(firm_id) 
outreg2 $y $ddcontrol1 using "$dir/Results/DD output LTT.xls", se see label bdec(3) rdec(3) append addtext(Sample, HHS 3 Prior) 
drop if p1prior_capacity > 1
reg $y d2 dT d2_dT $ddcontrol if agency == "nsf", cluster(firm_id) 
outreg2 $y d2 dT d2_dT $ddcontrol using "$dir/Results/DD output LTT.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior)
reg $y $ddcontrol1 if agency == "nsf", cluster(firm_id) 
outreg2 $y $ddcontrol1 using "$dir/Results/DD output LTT.xls", se see label bdec(3) rdec(3) append addtext(Sample, NSF 1 Prior)
restore
}

log close
END
