cd "~/Dropbox/Shared Folder - J. Ladd & M (1). Meredith/Replication Files/"
cap log close
log using "LogFiles/Figure1a.log", replace

clear all
set more off

// Start Date for Scatter
local date1 = mdy(1, 1, 1953)
// End Date for Scatter
local date2 = mdy(1, 1, 2014)
// End Date for In Person Surveys
local date3 = mdy(1, 1, 1997)
// Start Date for Phone Surveys
local date4 = mdy(1, 1, 1989)

// Kernel Bandwidth
local bandwidthlevel = 100

use "RawData/GallupDataBJPS.dta", clear
// Drops Unrepresentative Series
drop if drops == "All" | regexm(drops, "Party")
// Drops Obs. w/o Gender
drop if female < 0
// Drops Obs. w/o Weights
drop if final_weight < 0
// Drops Obs. w/o Dem., Ind., or Rep.
keep if party == -1 | party == 0 | party == 1

// Gets Count of Obs. and Surveys
unique series
tab female

// Sets the Survey Date as the Mid-Point in Field
gen middle_date = .
replace middle_date = floor((start_date + end_date) / 2)
sort middle_date
format middle_date %td

// Phone Poll Indicator
gen phone = (survey ~= 1)

// Codes Dem. as 0, Ind. as 1/2, and Rep. as 1
gen partisan = 0 if party == -1
replace partisan = 1 if party == 1
replace partisan = .5 if party == 0

// Aggregates Weighted Partisanship for Females by Series
egen total_partisan_female = sum(partisan * (female == 1) * final_weight), by(series)
// Aggregates Weighted Partisanship for Males by Series
egen total_partisan_male = sum(partisan * (female == 0) * final_weight), by(series)
// Weighted Female Count by Series
egen total_obs_female = sum((female == 1) * (final_weight)), by (series)
// Weighted Male Count by Series
egen total_obs_male = sum((female == 0) * (final_weight)), by (series)
// Avg. Female Partisanship by Series
gen partisan_female = total_partisan_female / total_obs_female
// Avg. Male Partisanship by Series
gen partisan_male = total_partisan_male / total_obs_male 

// Only Keeps One Obs. Per Survey
keep if obs_num == 1 

// Smoothed Male Partisanship in In-Person Polls
lpoly partisan_male middle_date if phone == 0, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(middle_date) generate(male_inperson_fitted)
// Smoothed Male Partisanship in Phone Polls
lpoly partisan_male middle_date if phone == 1, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(middle_date) generate(male_phone_fitted)
// Smoothed Female Partisanship in In-Person Polls
lpoly partisan_female middle_date if phone == 0, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(middle_date) generate(female_inperson_fitted)
// Smoothed Female Partisanship in Phone Polls
lpoly partisan_female middle_date if phone == 1, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(middle_date) generate(female_phone_fitted)

// Plots Fitted Values from Above Analysis
twoway (line male_inperson_fitted middle_date if middle_date <= `date3', lcolor(gs8) lwidth(thick) lpattern(solid)) /* 
*/ (line male_phone_fitted middle_date if middle_date >= `date4', lcolor(gs8) lwidth(thick) lpattern(shortdash)) /*
*/ (line female_inperson_fitted middle_date if middle_date <= `date3', lcolor(gs0) lwidth(thick) lpattern(solid)) /*
*/ (line female_phone_fitted middle_date if middle_date >= `date4', lcolor(gs0) lwidth(thick) lpattern(shortdash)), /* 
*/ legend(rows(1) order(1 "Males (In Person)" 2 "Males (Phone)" 3 "Females (In Person)" 4 "Females (Phone)")) /*
*/ xsize(14) ysize(8) scale(.8) xtitle({stSerif: Survey Date}) ytitle("{stSerif: Local Weighted Average Partisanship Level}" "{stSerif: Higher Values = More Republican}") /*  
*/ graphregion(fcolor(white)) xlabel(`date1'(1461)`date2', format(%td) alternate) ylabel(,nogrid) 

graph export "TablesFigures/Figure1a.eps", replace

log close
