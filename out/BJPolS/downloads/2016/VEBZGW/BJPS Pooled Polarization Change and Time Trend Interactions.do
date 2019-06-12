
*******************************************************************************
*
*	BJPS TIME POLARIZATION CHANGE AND TREND INTERACTION MODELS
*	REPLICATES MAIN MODELS USING POLARIZATION CHANGE, TIME TREND,
*	AND INTERACTS BOTH OF THESE VARIABLES WITH INDIVIDUAL IDEOLOGY SCORES
*
*******************************************************************************

clear all
cd "/Users/michaelflynn/Dropbox/Projects/Public Opinion and Foreign Policy/BJPS R&R/Data and Analysis/"
use "/Users/michaelflynn/Dropbox/Projects/Public Opinion and Foreign Policy/Data and Do Files/ANES_POST_FACTOR_COMBINED.dta"
set more off 

* VCF0301 is presidential vote
* Lib_Con_Scale is ideology
* PartyGap is in-party vs out-party evals

label var F1_Adj "Individual First Dimension"
label var F2_Adj "Individual Second Dimension"
label var dwnom1_cmean "Mean Congressional Ideology"
label var dwnom1_difference "Congressional Polarization"
label var dwnom1_dvar "Democratic Variance"
label var dwnom1_rvar "Republican Variance"
label var inter1 "First Dimension * Polarization"
label var inter2 "Second Dimension * Polarization"
label var education_4cat "Education"
recode Pres_Vote (3 = .) (2 = 0) 
gen trend = year
gen inter10 = trend*F1_Adj
gen inter11 = trend*F2_Adj
label var inter10 "First Dimension * Time Trend"
label var inter11 "Second Dimension * Time Trend"
label var trend "Time Trend"
replace inter1 = polar_change*F1_Adj
replace inter2 = polar_change*F2_Adj
label var polar_change "Polarization"

eststo clear
* Model Group 1 - Party ID Dependent Variable
	* Difference in NOMINATE Mean Between Parties
	eststo: reg PID polar_change dwnom1_cmean F1_Adj F2_Adj inter1 inter2 trend inter10 inter11  education_4cat Income South NonWhite dem_voteshare, robust

* Model Group 2 - Ideology Score Dependent Variable
	* Difference in NOMINATE Mean Between Parties
	eststo: reg Lib_Con_Scale polar_change dwnom1_cmean F1_Adj F2_Adj inter1 inter2 trend inter10 inter11 education_4cat Income South NonWhite dem_voteshare, robust

* Model Group 3 - Party Gap Dependent Variable
	* Difference in NOMINATE Mean Between Parties
	eststo: reg PartyGap polar_change dwnom1_cmean F1_Adj F2_Adj inter1 inter2 trend inter10 inter11 education_4cat Income South NonWhite dem_voteshare, robust

* Model Group 4 - Vote Choice Dependent Variable
	* Difference in NOMINATE Mean Between Parties
	eststo: probit Pres_Vote polar_change dwnom1_cmean F1_Adj F2_Adj inter1 inter2 trend inter10 inter11 education_4cat Income South NonWhite dem_voteshare, robust


esttab _all using BJPS_models_time_main.csv, star(* .10 ** .05 *** .01) nogaps label ///
	title(Polarization Change Models with Time Interactions) mgroups("Party ID" "Ideology" "Affect Polarization" "Vote Choice", pattern(1 1 1 1)) ///
	order(polar_change dwnom1_cmean F1_Adj F2_Adj inter1 inter2 trend inter10 inter11 education_4cat Income South NonWhite dem_voteshare) ///
	scalars("r2 R-Squared" "ll Log-Likelihood") se nomtitles compress replace ///
	addnote("Robust standard errors in parentheses: * p<.10 ** p<.05 *** p<.01")


eststo clear
gen ps0 = 0
replace ps0 = 1 if PS_tertile == 1 | PS_tertile == 2 | PS_tertile == 3
gen ps1 = 0 
replace ps1 = 1 if PS_tertile == 1 
gen ps2 = 0
replace ps2 = 1 if PS_tertile == 2
gen ps3 = 0 
replace ps3 = 1 if PS_tertile == 3

foreach DV of varlist PID Lib_Con_Scale PartyGap {
foreach ps of varlist ps0 ps1 ps2 ps3 {
eststo: reg `DV' dwnom1_difference dwnom1_cmean F1_Adj F2_Adj inter1 inter2 trend inter10 inter11  education_4cat Income South NonWhite dem_voteshare if `ps'==1, robust
}
}

foreach DV of varlist Pres_Vote {
foreach ps of varlist ps0 ps1 ps2 ps3 {
eststo: probit `DV' dwnom1_difference dwnom1_cmean F1_Adj F2_Adj inter1 inter2 trend inter10 inter11  education_4cat Income South NonWhite dem_voteshare if `ps'==1, robust
}
}


esttab _all using BJPS_models_time_sophistication.csv, star(* .10 ** .05 *** .01) nogaps label ///
	title(Base Models) mgroups("Party ID" "Ideology" "Polarization" "Vote Choice", pattern(1 0 0 0 1 0 0 0 1 0 0 0  1 0 0 0 )) ///
	order(dwnom1_difference dwnom1_cmean F1_Adj F2_Adj inter1 inter2 trend inter10 inter11  education_4cat Income South NonWhite dem_voteshare) ///
	scalars("r2 R-Squared" "ll Log-Likelihood") se nomtitles compress replace
