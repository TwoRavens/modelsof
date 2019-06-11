
****************************************************************
*
*	BJPS Pooled Polarization Change Models
*	Polarization change, interactions, and linear time trend
*
****************************************************************


clear all
cd "~/Dropbox/Projects/Public Opinion and Foreign Policy/BJPS R&R/Figures/"
use "~/Dropbox/Projects/Public Opinion and Foreign Policy/Data and Do Files/ANES_POST_FACTOR_COMBINED.dta"

label var polar_change "Polarization"
label var F1_Adj "Individual First Dimension"
label var F2_Adj "Individual Second Dimension"
label var dwnom1_cmean "Mean Congressional Ideology"
label var dwnom1_difference "Congressional Polarization"
label var dwnom1_dvar "Democratic Variance"
label var dwnom1_rvar "Republican Variance"
label var inter1 "First Dimension * Polarization"
label var inter2 "Second Dimension * Polarization"
label var education_4cat "Education"
label var dem_voteshare "Democratic Vote Share"
label var year "Time Trend"
recode Pres_Vote (3 = .) (2 = 0) 
replace inter1 = F1_Adj*polar_change
replace inter2 = F2_Adj*polar_change


eststo clear
* Model Group 1 - Party ID Dependent Variable
	* Difference in NOMINATE Mean Between Parties
	eststo: reg PID polar_change dwnom1_cmean F1_Adj F2_Adj  inter1 inter2  education_4cat Income South NonWhite dem_voteshare  year, robust

* Model Group 2 - Ideology Score Dependent Variable
	* Difference in NOMINATE Mean Between Parties
	eststo: reg Lib_Con_Scale polar_change dwnom1_cmean F1_Adj F2_Adj inter1 inter2  education_4cat Income South NonWhite dem_voteshare year, robust

* Model Group 3 - Party Gap Dependent Variable
	* Difference in NOMINATE Mean Between Parties
	eststo: reg PartyGap polar_change dwnom1_cmean F1_Adj F2_Adj inter1 inter2 education_4cat Income South NonWhite dem_voteshare year, robust

* Model Group 4 - Vote Choice Dependent Variable
	* Difference in NOMINATE Mean Between Parties
	eststo: probit Pres_Vote polar_change dwnom1_cmean F1_Adj F2_Adj inter1 inter2 education_4cat Income South NonWhite dem_voteshare year, robust


esttab _all using BJPS_models_polarchange.csv, star(* .10 ** .05 *** .01) nogaps label ///
	title(Polarization Change Models) mgroups("Party ID" "Ideology" "Affect Polarization" "Vote Choice", pattern(1 1 1 1)) ///
	order(polar_change dwnom1_cmean F1_Adj F2_Adj inter1 inter2 education_4cat Income South NonWhite dem_voteshare) ///
	scalars("r2 R-Squared" "ll Log-Likelihood") se nomtitles compress replace ///
	addnote("Robust standard errors in parentheses: * p<.10 ** p<.05 *** p<.01")

	
