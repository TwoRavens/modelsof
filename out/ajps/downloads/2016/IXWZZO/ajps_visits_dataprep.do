/****************************/
// Data Preparation File
// This do file uses Stata 14 to assemble the mayor visits dataset (Table 2) for
// Foreign Aid and the Politics of Undeserved Credit Claiming
// Prepared by Cesi Cruz [cesi.cruz@ubc.ca]
//
// Uses two datasets available from the World Bank:
// panelhh_2006.dta    Household-level survey data from the KALAHI Impact Evaluation 2006
// panelbar_2006.dta   Village-level survey data from the KALAHI Impact Evaluation 2006 
/****************************/


/****************************/
// Step 1: Generating village level poverty measure
// Primary measure is POOR: based on self-reported poverty ("Place your family on this card: poor, on the line, not poor")
/****************************/

clear matrix
set more off

//Load Kalahi Household Survey Data from Impact Evaluation (Available from the World Bank)
use panelhh_2006.dta, clear

//Clean poverty variable to use for village-level poverty measure 
gen poor = 0
replace poor = 1 if D132==3 //Place your family on this card: poor (vs. not poor or on the line)


//Generate village-level measures
collapse (mean) poor, by(BARANGAY)
rename BARANGAY barangay
sort barangay
save kc_visits_hh_avg, replace
saveold kc_visits_hh_avg_stata12, replace version(12)
saveold kc_visits_hh_avg_stata13, replace
/****************************/


/****************************/
// Step 2: Cleaning the village-level variables used in the analysis
// Merging the poverty measure from step 1
/****************************/

use panelbar_full_2006.dta, clear


gen treat =  0
replace treat = 1 if TREAT==1

label variable F39A "Mayor Visits"
label variable F39G "Midwife Visits"

rename F39A visits_mayor
rename F39G visits_midwife

rename B2 num_households
rename G40 ira
rename G54 bar_meetings
rename C13A road_dirt_pct


foreach var of varlist num_households ira {
	replace `var' = . if `var' == 9999 | `var' == 8888
}

foreach var of varlist num_households ira {
	gen log_`var' = log(`var') if `var'!=.
}


gen muni_funds = 0
foreach var of varlist G41*{
	replace muni_funds = 1 if `var'==2
}

//Recoding no response
foreach var of varlist visits_*{
	replace `var' = . if `var' == 999
}

rename BARANGAY barangay
sort barangay

//Merging village level poverty survey data from step 1
merge barangay using kc_visits_hh_avg

//Optional: check merge for problems; _merge==3 for all observations
//tab _merge 

//Dropping merge variable
drop _merge

//Labeling other variables
label var road_dirt_pct "Percent Dirt Roads"
label var log_ira "Internal Revenue Allotment"
label var bar_meetings "Barangay Meetings"
label var muni_funds "Received Funding from Mayor"
label var treat "KALAHI"
label var poor "Poverty"
label variable log_num_households "Number of Households (log)"

//Province Dummies
tabulate PROVINCE, gen(provis)
rename provis1 first_province_dummy //excluded



keep road_dirt_pct log_ira bar_meetings muni_funds treat poor provis* first_province_dummy visits_mayor visits_midwife log_num_households

/****************************/
// Saving Mayor Visits Datasets
/****************************/

save ajps_visits_data, replace
saveold ajps_visits_data_stata12, replace version(12)
saveold ajps_visits_data_stata13, replace
