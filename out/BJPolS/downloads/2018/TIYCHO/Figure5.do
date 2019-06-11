cd "~/Dropbox/Shared Folder - J. Ladd & M (1). Meredith/Replication Files/"
cap log close
log using "LogFiles/Figure5.log", replace

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

// ANES

use "RawData/anes_timeseries_cdf.dta", clear

gen wt=VCF0009z
gen pid=VCF0301
recode pid 0=.5 1=0 2=0 3=.5 4=.5 5=.5 6=1 7=1
gen year=VCF0004
gen female=VCF0104
recode female 0=. 1=0 2=1
gen male=VCF0104==1
gen college=(VCF0110==4)
gen femaleXcollege = female * college

matrix ANES = J(24, 4, 0)
local j = 0
forvalues i = 1952(2)1998 {
local j = `j' + 1
qui regress pid female college femaleXcollege [pweight = wt] if year == `i', robust
matrix ANES[`j', 1] = mdy(10, 1, `i')
matrix ANES[`j', 2] = _b[femaleXcollege] + invttail(e(df_r),.975)*_se[femaleXcollege]
matrix ANES[`j', 3] = _b[femaleXcollege] 
matrix ANES[`j', 4] = _b[femaleXcollege] + invttail(e(df_r),.025)*_se[femaleXcollege]
}

// GSS

use year sex partyid educ wtssall using "RawData/GSS7212_R2.dta", clear

gen pid=partyid
recode pid 1=0 2=.5 3=.5 4=.5 5=1 6=1 7=.5
gen female=sex-1
gen college = (educ >= 16 & educ <= 20)
gen femaleXcollege = female * college

matrix GSS = J(22, 4, 0)
local j = 0
foreach i in 1972 1973 1974 1975 1976 1977  1978  1980  1982  1983  1984  1985  1986  1987  1988  1989  1990  1991  1993  1994  1996  1998   {
local j = `j' + 1
qui regress pid female college femaleXcollege [pweight = wtssall] if year == `i', robust
matrix GSS[`j', 1] = mdy(3, 15, `i')
matrix GSS[`j', 2] = _b[femaleXcollege] + invttail(e(df_r),.975)*_se[femaleXcollege]
matrix GSS[`j', 3] = _b[femaleXcollege]
matrix GSS[`j', 4] = _b[femaleXcollege] + invttail(e(df_r),.025)*_se[femaleXcollege]
}

// Gallup

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

gen partisan_difference = (partisan_female_college - partisan_male_college) - /*
*/ (partisan_female_nocollege - partisan_male_nocollege)
keep if obs_num == 1

// Smoothed Partisan Difference in In-Person Polls
lpoly partisan_difference middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthdifference') /*
*/ nograph at(middle_date) generate(fitted)

svmat ANES
svmat GSS

twoway (line fitted middle_date, lcolor(black) lpattern(solid) lwidth(thick)) /*
*/ (scatter ANES3 ANES1, mcolor(black) mfcolor(black) msize(medium)) /*
*/ (rspike ANES2 ANES4 ANES1, lcolor(black) lwidth(medium) lpattern(dash)) /*
*/ (scatter GSS3 GSS1, mcolor(gray) mfcolor(gray) msize(medium)) /*
*/ (rspike GSS2 GSS4 GSS1, lcolor(gray) lwidth(medium) lpattern(dash)), /*
*/ xtitle({stSerif: Survey Date}) ytitle("{stSerif: Difference in Women's Minus Men's Partisanship Level}" "{stSerif: College Graduates and Non-College Graduates}") scale(.7) graphregion(fcolor(white)) ylabel(0, labsize(small) tstyle(minor) glcolor(gs8)) /*
*/ ymlabel(-.35(.05).35, labsize(small)) /*
*/ legend(rows(2) order (1 "Gallup In Person" 2 "ANES" 3 "ANES 95% CI" 4 "GSS" 5 "GSS 95% CI")) /*
*/ xlabel(`date1'(1461)`date3', format(%td) alternate)
graph export "TablesFigures/Figure5.eps", as(eps) replace 

// Generates Point Estimates to Compare to ANES/GSS

lpoly partisan_difference middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthdifference') /*
*/ nograph at(ANES1) generate(ANES_COMPARE_INPERSON) se(ANES_COMPARE_INPERSON_se)
// Is the Gallup In Person Estimate in the 95% CI of the ANES?
gen CI_INPERSON = (ANES2 <= ANES_COMPARE_INPERSON & ANES_COMPARE_INPERSON <= ANES4)

format ANES1 %td
list ANES1 ANES3 ANES2 ANES4 ANES_COMPARE_INPERSON ANES_COMPARE_INPERSON_se /*
*/ CI_INPERSON if missing(ANES1) == 0
tab ANES1 CI_INPERSON if missing(ANES_COMPARE_INPERSON) == 0 & /*
*/ year(ANES1) >= 1953 & year(ANES1) <= 1996
drop ANES* CI_*

lpoly partisan_difference middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthdifference') /*
*/ nograph at(GSS1) generate(GSS_COMPARE_INPERSON) se(GSS_COMPARE_INPERSON_se)
// Is the Gallup In Person Estimate in the 95% CI of the GSS?
gen CI_INPERSON = (GSS2 <= GSS_COMPARE_INPERSON & GSS_COMPARE_INPERSON <= GSS4)

lpoly partisan_difference middle_date, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthdifference') /*
*/ nograph at(GSS1) generate(GSS_COMPARE_PHONE) se(GSS_COMPARE_PHONE_se)
// Is the Gallup Phone Estimate in the 95% CI of the GSS?
gen CI_PHONE = (GSS2 <= GSS_COMPARE_PHONE & GSS_COMPARE_PHONE <= GSS4)

format GSS1 %td
list GSS1 GSS3 GSS2 GSS4 GSS_COMPARE_INPERSON GSS_COMPARE_INPERSON_se /*
*/ CI_INPERSON if missing(GSS1) == 0
tab GSS1 CI_INPERSON if missing(GSS_COMPARE_INPERSON) == 0 & /*
*/ year(GSS1) >= 1953 & year(GSS1) <= 1996
drop GSS* CI_*

log close
