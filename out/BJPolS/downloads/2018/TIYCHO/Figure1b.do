cd "~/Dropbox/Shared Folder - J. Ladd & M (1). Meredith/Replication Files/"
cap log close
log using "LogFiles/Figure1b.log", replace

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
// Differece in Female and Male Partisanship
gen partisan_difference = partisan_female - partisan_male 

// Only Keeps One Obs. Per Survey
keep if obs_num == 1 

// Smoothed Partisan Difference in In-Person Polls
lpoly partisan_difference middle_date if phone == 0, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(middle_date) generate(inperson_fitted) se(inperson_fitted_se)

gen lower_bound_inperson = inperson_fitted - inperson_fitted_se*invnorm(.025) 
gen upper_bound_inperson = inperson_fitted + inperson_fitted_se*invnorm(.025) 
drop inperson_fitted_se

// Smoothed Partisan Difference in Phone Polls
lpoly partisan_difference middle_date if phone == 1, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(middle_date) generate(phone_fitted) se(phone_fitted_se)

gen lower_bound_phone = phone_fitted - phone_fitted_se*invnorm(.025) 
gen upper_bound_phone = phone_fitted + phone_fitted_se*invnorm(.025) 
drop phone_fitted_se

twoway (line inperson_fitted middle_date if middle_date <= `date3', lcolor(black) lpattern(solid) lwidth(thick)) /*
*/ (line lower_bound_inperson middle_date if middle_date <= `date3', lcolor(black) lpattern(vshortdash) lwidth(thick)) /*
*/ (line upper_bound_inperson middle_date if middle_date <= `date3', lcolor(black) lpattern(vshortdash) lwidth(thick)) /*
*/ (line phone_fitted middle_date if middle_date >= `date4', lcolor(gray) lpattern(solid) lwidth(thick)) /*
*/ (line lower_bound_phone middle_date if middle_date >= `date4', lcolor(gray) lpattern(vshortdash) lwidth(thick)) /*
*/ (line upper_bound_phone middle_date if middle_date >= `date4', lcolor(gray) lpattern(vshortdash) lwidth(thick)), /*
*/ xtitle({stSerif: Survey Date}) ytitle({stSerif: Women's Minus Men's Partisanship Level}) /*
*/ scale(.7) graphregion(fcolor(white)) ylabel(0, labsize(small) tstyle(minor) glcolor(gs8)) ymlabel(-.10 -.05 .05, labsize(small)) /*
*/ legend(rows(2) order (1 "Gallup In Person" 2 "Gallup In Person 95% CI" 4 "Gallup Phone" 5 "Gallup Phone 95% CI")) /*
*/ xlabel(`date1'(1461)`date2', format(%td) alternate)

graph export "TablesFigures/Figure1b.eps", replace

log close
