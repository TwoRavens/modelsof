cd "~/Dropbox/Shared Folder - J. Ladd & M (1). Meredith/Replication Files/"
cap log close
log using "LogFiles/Figure2.log", replace

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

// ANES

use "RawData/anes_timeseries_cdf.dta", clear

gen wt=VCF0009z
gen pid=VCF0301
recode pid 0=.5 1=0 2=0 3=.5 4=.5 5=.5 6=1 7=1
gen year=VCF0004
gen female=VCF0104
recode female 0=. 1=0 2=1

matrix ANES = J(29, 4, 0)
local j = 0
forvalues i = 1952(2)2004 {
local j = `j' + 1
qui regress pid female [pweight = wt] if year == `i', robust
matrix ANES[`j', 1] = mdy(10, 1, `i')
matrix ANES[`j', 2] = _b[female] + invttail(e(df_r),.975)*_se[female]
matrix ANES[`j', 3] = _b[female] 
matrix ANES[`j', 4] = _b[female] + invttail(e(df_r),.025)*_se[female]
}

qui regress pid female [pweight = wt] if year == 2008, robust
matrix ANES[28, 1] = mdy(10, 1, 2008)
matrix ANES[28, 2] = _b[female] + invttail(e(df_r),.975)*_se[female]
matrix ANES[28, 3] = _b[female] 
matrix ANES[28, 4] = _b[female] + invttail(e(df_r),.025)*_se[female]

qui regress pid female [pweight = wt] if year == 2012, robust
matrix ANES[29, 1] = mdy(10, 1, 2012)
matrix ANES[29, 2] = _b[female] + invttail(e(df_r),.975)*_se[female]
matrix ANES[29, 3] = _b[female] 
matrix ANES[29, 4] = _b[female] + invttail(e(df_r),.025)*_se[female]

// GSS

use year sex partyid wtssall using "RawData/GSS7212_R2.dta", clear

gen pid=partyid
recode pid 1=0 2=.5 3=.5 4=.5 5=1 6=1 7=.5
gen female=sex-1

matrix GSS = J(29, 4, 0)
local j = 0
foreach i in 1972 1973 1974 1975 1976 1977  1978  1980  1982  1983  1984  1985 /*
*/ 1986  1987  1988  1989  1990  1991  1993  1994  1996  1998  2000  2002  /*
*/ 2004  2006  2008  2010  2012  {
local j = `j' + 1
qui regress pid female [pweight = wtssall] if year == `i', robust
matrix GSS[`j', 1] = mdy(3, 15, `i')
matrix GSS[`j', 2] = _b[female] + invttail(e(df_r),.975)*_se[female]
matrix GSS[`j', 3] = _b[female]
matrix GSS[`j', 4] = _b[female] + invttail(e(df_r),.025)*_se[female]
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
// Differece in Female and Male Partisanship
gen partisan_difference = partisan_female - partisan_male 

// Only Keeps One Obs. Per Survey
keep if obs_num == 1 

// Smoothed Partisan Difference in In-Person Polls
lpoly partisan_difference middle_date if phone == 0, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(middle_date) generate(inperson_fitted)

// Smoothed Partisan Difference in Phone Polls
lpoly partisan_difference middle_date if phone == 1, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(middle_date) generate(phone_fitted)

svmat ANES
svmat GSS

twoway (line inperson_fitted middle_date if middle_date <= `date3', lcolor(black) lpattern(solid) lwidth(thick)) /*
*/ (line phone_fitted middle_date if middle_date >= `date4', lcolor(gray) lpattern(solid) lwidth(thick)) /*
*/ (scatter ANES3 ANES1, mcolor(black) msize(medium)) /*
*/ (rspike ANES2 ANES4 ANES1, lcolor(black) lwidth(medium) lpattern(dash)) /*
*/ (scatter GSS3 GSS1, mcolor(gray) msize(medium)) /*
*/ (rspike GSS2 GSS4 GSS1, lcolor(gray) lwidth(medium) lpattern(dash)), /*
*/ xtitle({stSerif: Survey Date}) ytitle({stSerif: Women's Minus Men's Partisanship Level}) /*
*/ scale(.7) graphregion(fcolor(white)) ylabel(0, labsize(small) tstyle(minor) glcolor(gs8)) ymlabel(-.15 -.10 -.05 .05 .1, labsize(small))/*
*/ legend(rows(3) order (1 "Gallup In Person" 2 "Gallup Phone" /*
*/ 3 "ANES" 4 "ANES 95% CI" 5 "GSS" 6 "GSS 95% CI")) /*
*/ xlabel(`date1'(1461)`date2', format(%td) alternate)

graph export "TablesFigures/Figure2.eps", replace

// Looks at whether Gallup point estimates are in the ANES/GSS 95% CI

lpoly partisan_difference middle_date if phone == 0, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(ANES1) generate(ANES_COMPARE_INPERSON)
// Is the Gallup In Person Estimate in the 95% CI of the ANES?
gen CI_INPERSON = (ANES2 <= ANES_COMPARE_INPERSON & ANES_COMPARE_INPERSON <= ANES4)

lpoly partisan_difference middle_date if phone == 1, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(ANES1) generate(ANES_COMPARE_PHONE)
// Is the Gallup Phone Estimate in the 95% CI of the ANES?
gen CI_PHONE = (ANES2 <= ANES_COMPARE_PHONE & ANES_COMPARE_PHONE <= ANES4)

format ANES1 %td
list ANES1 ANES3 ANES2 ANES4 ANES_COMPARE_INPERSON  /*
*/ CI_INPERSON ANES_COMPARE_PHONE CI_PHONE if missing(ANES1) == 0
tab ANES1 CI_INPERSON if missing(ANES_COMPARE_INPERSON) == 0 & /*
*/ year(ANES1) >= 1953 & year(ANES1) <= 1996 
tab ANES1 CI_PHONE if missing(ANES_COMPARE_PHONE) == 0 & /*
*/ year(ANES1) >= 1989 & year(ANES1) <= 2012
drop ANES* CI_*

lpoly partisan_difference middle_date if phone == 0, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(GSS1) generate(GSS_COMPARE_INPERSON)
// Is the Gallup In Person Estimate in the 95% CI of the GSS?
gen CI_INPERSON = (GSS2 <= GSS_COMPARE_INPERSON & GSS_COMPARE_INPERSON <= GSS4)

lpoly partisan_difference middle_date if phone == 1, /*
*/ degree(0) kernel(epanechnikov) bwidth (`bandwidthlevel') /*
*/ nograph at(GSS1) generate(GSS_COMPARE_PHONE)
// Is the Gallup Phone Estimate in the 95% CI of the GSS?
gen CI_PHONE = (GSS2 <= GSS_COMPARE_PHONE & GSS_COMPARE_PHONE <= GSS4)

format GSS1 %td
list GSS1 GSS3 GSS2 GSS4 GSS_COMPARE_INPERSON  /*
*/ CI_INPERSON GSS_COMPARE_PHONE CI_PHONE if missing(GSS1) == 0
tab GSS1 CI_INPERSON if missing(GSS_COMPARE_INPERSON) == 0 & /*
*/ year(GSS1) >= 1953 & year(GSS1) <= 1996 
tab GSS1 CI_PHONE if missing(GSS_COMPARE_PHONE) == 0 & /*
*/ year(GSS1) >= 1989 & year(GSS1) <= 2012
drop GSS* CI_*

log close
