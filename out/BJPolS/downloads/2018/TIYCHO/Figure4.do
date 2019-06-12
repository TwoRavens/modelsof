cd "~/Dropbox/Shared Folder - J. Ladd & M (1). Meredith/Replication Files/"
cap log close
log using "LogFiles/Figure4.log", replace

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
local bandwidthdifference = 100

use "RawData/GallupDataBJPS.dta", clear
// Drops Unrepresentative Series
drop if drops == "All" | regexm(drops, "Party")
// Drops Obs. w/o Gender
drop if female < 0
// Drops Obs. w/o Weights
drop if final_weight < 0
// Drops Obs. w/o Dem., Ind., or Rep.
keep if party == -1 | party == 0 | party == 1
// Drops Obs. w/o Education
drop if education < 0
// Drops Phone Surveys
keep if survey == 1

// Gets Count of Obs. and Surveys
unique series
tab female

// Sets the Survey Date as the Mid-Point in Field
gen middle_date = .
replace middle_date = floor((start_date + end_date) / 2)
sort middle_date
format middle_date %td

// Codes Dem. as 0, Ind. as 1/2, and Rep. as 1
gen partisan = 0 if party == -1
replace partisan = 1 if party == 1
replace partisan = .5 if party == 0

// College Gradudates
gen college = (education == 5)

// Aggregates Weighted Partisanship for Females
egen total_partisan_female_college = sum(partisan * (female == 1) * (college == 1) * final_weight) , by (series)
// Aggregates Weighted Partisanship for Males
egen total_partisan_male_college = sum(partisan * (female == 0) * (college == 1) * final_weight), by (series)
// Weighted Female Count
egen total_obs_female_college = sum((female == 1) * (college == 1) * (final_weight)), by (series)
// Weighted Male Count
egen total_obs_male_college = sum((female == 0) * (college == 1) * (final_weight)), by (series)
// Average Female Partisanship
gen partisan_female_college = total_partisan_female_college / total_obs_female_college
// Average Male Partisanship
gen partisan_male_college = total_partisan_male_college / total_obs_male_college 

// Non-College Gradudates

// Aggregates Weighted Partisanship for Females
egen total_partisan_female_nocollege = sum(partisan * (female == 1) * (college == 0) * final_weight) , by (series)
// Aggregates Weighted Partisanship for Males
egen total_partisan_male_nocollege = sum(partisan * (female == 0) * (college == 0) * final_weight), by (series)
// Weighted Female Count
egen total_obs_female_nocollege = sum((female == 1) * (college == 0) * (final_weight)), by (series)
// Weighted Male Count
egen total_obs_male_nocollege = sum((female == 0) * (college == 0) * (final_weight)), by (series)
// Average Female Partisanship
gen partisan_female_nocollege = total_partisan_female_nocollege / total_obs_female_nocollege
// Average Male Partisanship
gen partisan_male_nocollege = total_partisan_male_nocollege / total_obs_male_nocollege 

keep if obs_num == 1

// Constructs Weighted Average of Partisanship for Males and Females 
// Seperates College Graduates and Non-College Graduates

lpoly partisan_male_college middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthdifference') /*
*/ nograph at(middle_date) generate(male_college_fitted)
lpoly partisan_male_nocollege middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (``bandwidthdifference'') /*
*/ nograph at(middle_date) generate(male_nocollege_fitted)
lpoly partisan_female_college middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (``bandwidthdifference'') /*
*/ nograph at(middle_date) generate(female_college_fitted)
lpoly partisan_female_nocollege middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (``bandwidthdifference'') /*
*/ nograph at(middle_date) generate(female_nocollege_fitted)

// Plots Fitted Values from Above Analysis
twoway (line female_college_fitted middle_date, lcolor(gs0) lwidth(thick) lpattern(solid)) /*
*/ (line male_college_fitted middle_date, lcolor(gs8) lwidth(thick) lpattern(solid)), /*
*/ legend(order(1 "Female College Graduates" 2 "Male College Graduates")) xtitle({stSerif: Survey Date}) ytitle("{stSerif: Average Partisanship Level}" "{stSerif: Higher Values = More Republican}") /*
*/ legend(rows(1)) xsize(14) ysize(8) scale(.8) graphregion(fcolor(white)) ylabel(,nogrid) xlabel(`date1'(1461)`date3', format(%td) alternate)
graph export "TablesFigures/Figure4a.eps", as(eps) replace 

twoway (line female_nocollege_fitted middle_date, lcolor(gs0) lwidth(thick) lpattern(solid)) /*
*/ (line male_nocollege_fitted middle_date, lcolor(gs8) lwidth(thick) lpattern(solid)), /*
*/ legend(order(1 "Female Non-College Graduates" 2 "Male Non-College Graduates")) xtitle({stSerif: Survey Date}) ytitle("{stSerif: Average Partisanship Level}" "{stSerif: Higher Values = More Republican}") /*
*/ legend(rows(1)) xsize(14) ysize(8) scale(.8) graphregion(fcolor(white)) ylabel(,nogrid) xlabel(`date1'(1461)`date3', format(%td) alternate)
graph export "TablesFigures/Figure4b.eps", as(eps) replace 

drop *_fitted

// Constructs Weighted Average of Difference in Partisanship for Males and Females 
// Separately Plots Difference for College Graduates and Non-College Graduates

gen partisan_difference_college = partisan_female_college - partisan_male_college 

lpoly partisan_difference_college middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthdifference') /*
*/ nograph at(middle_date) generate(fitted) se(fitted_se)

gen lower_bound_college = fitted - fitted_se*invnorm(.025) 
gen upper_bound_college = fitted + fitted_se*invnorm(.025) 
rename fitted fitted_college
drop fitted_se

// Difference in Female and Male Partisanship
gen partisan_difference_nocollege = partisan_female_nocollege - partisan_male_nocollege 

lpoly partisan_difference_nocollege middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthdifference') /*
*/ nograph at(middle_date) generate(fitted) se(fitted_se)

gen lower_bound_nocollege = fitted - fitted_se*invnorm(.025) 
gen upper_bound_nocollege = fitted + fitted_se*invnorm(.025) 
rename fitted fitted_nocollege
drop fitted_se

// Plots Fitted Value from Above Analyses
twoway (line fitted_college middle_date, lcolor(black) lpattern(solid) lwidth(thick)) /*
*/  (line lower_bound_college middle_date, lcolor(black) lpattern(vshortdash)) /*
*/ (line upper_bound_college middle_date, lcolor(black) lpattern(vshortdash)) /*
*/ (line fitted_nocollege middle_date, lcolor(gray) lpattern(solid) lwidth(thick)) /*
*/  (line lower_bound_nocollege middle_date, lcolor(gray) lpattern(vshortdash)) /*
*/ (line upper_bound_nocollege middle_date, lcolor(gray) lpattern(vshortdash)), /*
*/ xtitle({stSerif: Survey Date}) ytitle("{stSerif: Difference in Women's Minus Men's Partisanship Level}") scale(.7) graphregion(fcolor(white)) ylabel(0, labsize(small) tstyle(minor) glcolor(gs8)) /*
*/ ymlabel(-.24(.02).12, labsize(small)) /*
*/ legend(rows(2) order (1 "College Graduate Locally Weighted Average" 2 "College Graduate 95% CI" 4 "Non-College Graduate Locally Weighted Average" 5 "Non-College Graduate 95% CI")) /*
*/ xlabel(`date1'(1461)`date3', format(%td) alternate)
graph export "TablesFigures/Figure4c.eps", as(eps) replace 

drop fitted_c* lower_bound_* upper_bound_*

// Constructs Weighted Average of Difference-in-Difference in Partisanship for Males and Females 
// College Graduates vs. Non-College Graduates

gen partisan_difference = partisan_difference_college - partisan_difference_nocollege

lpoly partisan_difference middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthdifference') /*
*/ nograph at(middle_date) generate(fitted) se(fitted_se)

gen lower_bound = fitted - fitted_se*invnorm(.025) 
gen upper_bound = fitted + fitted_se*invnorm(.025) 
drop fitted_se

twoway (line fitted middle_date, lcolor(black) lpattern(solid) lwidth(thick)) /*
*/  (line lower_bound middle_date, lcolor(black) lpattern(vshortdash) lwidth(thick)) /*
*/ (line upper_bound middle_date, lcolor(black) lpattern(vshortdash) lwidth(thick)), /*
*/ xtitle({stSerif: Survey Date}) ytitle("{stSerif: Difference in Women's Minus Men's Partisanship Level}" /*
*/ "{stSerif: College Graduates and Non-College Graduates}") /*
*/ scale(.7) graphregion(fcolor(white)) ylabel(0, labsize(small) tstyle(minor) glcolor(gs8)) /*
*/ ymlabel(-.20(.05).10, labsize(small)) /*
*/ legend(order (1 "Locally Weighted Average" 2 "95% CI")) /*
*/ xlabel(`date1'(1461)`date3', format(%td) alternate)
graph export "TablesFigures/Figure4d.eps", as(eps) replace 

log close
