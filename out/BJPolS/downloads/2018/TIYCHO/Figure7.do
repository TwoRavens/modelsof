cd "~/Dropbox/Shared Folder - J. Ladd & M (1). Meredith/Replication Files/"
cap log close
log using "LogFiles/Figure7.log", replace

clear all
set more off

matrix Results = J(20, 10, -9)

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

gen year = -9
replace year = year(middle_date)  

// Codes Dem. as 0, Ind. as 1/2, and Rep. as 1
gen partisan = 0 if party == -1
replace partisan = 1 if party == 1
replace partisan = .5 if party == 0

gen yearbin = .
replace yearbin = 1 if year >= 1953 & year <= 1962
replace yearbin = 2 if year >= 1963 & year <= 1972
replace yearbin = 3 if year >= 1973 & year <= 1982
replace yearbin = 4 if year >= 1983 & year <= 1992
replace yearbin = 5 if year >= 1993 & year <= 1997
drop if missing(yearbin)

drop if age == -99 | age == -9
drop if age <= 24
gen decade_birth = floor((year - age) / 10) * 10
gen agebin = .
replace agebin = 1 if decade_birth == 1880
replace agebin = 2 if decade_birth == 1890
replace agebin = 3 if decade_birth == 1900
replace agebin = 4 if decade_birth == 1910
replace agebin = 5 if decade_birth == 1920
replace agebin = 6 if decade_birth == 1930
replace agebin = 7 if decade_birth == 1940
replace agebin = 8 if decade_birth == 1950
replace agebin = 9 if decade_birth == 1960
replace agebin = 10 if decade_birth == 1970
drop if missing(agebin)

gen college = 0
replace college = 1 if education == 5

// Estimates Jointly w/ Survey FEs

forvalues i = 1(1)5 {
local k = max(`i' - 1, 1)
local l = `i' + 5
drop if yearbin == `i' & (agebin < `k' | agebin > `l')
forvalues j = `k'(1)`l' {
gen ageXyear`j'`i'Xnc= (agebin == `j') * (yearbin == `i') * (1 - college)
gen ageXyear`j'`i'Xc = (agebin == `j') * (yearbin == `i') * college
gen ageXyear`j'`i'XncXfemale = (agebin == `j') * (yearbin == `i') * (1 - college) * female
gen ageXyear`j'`i'Xcxfemale = (agebin == `j') * (yearbin == `i') * college * female
}
drop ageXyear`k'`i'Xnc
}

areg partisan ageXyear* [pweight = final_weight], robust absorb(series) 
forvalues i = 1(1)5 {
local k = max(`i' - 1, 1)
local l = `i' + 5
forvalues j = `k'(1)`l' {
mat Results[2*(`j' - 1) + 1, `i'] = _b[ageXyear`j'`i'Xcxfemale]
mat Results[2*(`j' - 1) + 2, `i'] = -_se[ageXyear`j'`i'Xcxfemale]
mat Results[2*(`j' - 1) + 1, `i' + 5] = _b[ageXyear`j'`i'XncXfemale]
mat Results[2*(`j' - 1) + 2, `i' + 5] = -_se[ageXyear`j'`i'XncXfemale]
}
}

clear
svmat Results
drop if mod(_n, 2) == 0
gen cohort = _n
reshape long Results, i(cohort) j(crap)
drop if Results == -9
gen college = (crap <= 5)
gen time = 1 + mod(crap - 1, 5)
drop crap

twoway (line Results time if college == 1 & cohort == 1, lcolor(gs0) lpattern(solid)) /*
*/ (line Results time if college == 1 & cohort == 2, lcolor(gs6) lpattern(shortdash)) /*
*/ (line Results time if college == 1 & cohort == 3, lcolor(gs12) lpattern(longdash)) /*
*/ (line Results time if college == 1 & cohort == 4, lcolor(gs0) lpattern(shortdash)) /*
*/ (line Results time if college == 1 & cohort == 5, lcolor(gs6) lpattern(longdash)) /*
*/ (line Results time if college == 1 & cohort == 6, lcolor(gs12) lpattern(solid)) /*
*/ (line Results time if college == 1 & cohort == 7, lcolor(gs0) lpattern(longdash)) /*
*/ (line Results time if college == 1 & cohort == 8, lcolor(gs6) lpattern(solid)) /*
*/ (line Results time if college == 1 & cohort == 9, lcolor(gs12) lpattern(shortdash)), /*
*/ legend(off) xtitle("Survey Year") ytitle("Partisan Gender Gap") /*
*/ ylabel(-.12(.04).04) /*
*/ xlabel(0.75 " " 1 "1953-1962"  2 "1963-1972"  3 "1973-1982"  4 "1982-1992"  /*
*/ 5 "1993-1997" 5.25 " ", notick) xmtick(1(1)5) graphregion(fcolor(white)) ylabel(,nogrid) 
graph export "TablesFigures/Figure7a.eps", as(eps) replace  

twoway (line Results time if college == 0 & cohort == 1, lcolor(gs0) lpattern(solid)) /*
*/ (line Results time if college == 0 & cohort == 2, lcolor(gs6) lpattern(shortdash)) /*
*/ (line Results time if college == 0 & cohort == 3, lcolor(gs12) lpattern(longdash)) /*
*/ (line Results time if college == 0 & cohort == 4, lcolor(gs0) lpattern(shortdash)) /*
*/ (line Results time if college == 0 & cohort == 5, lcolor(gs6) lpattern(longdash)) /*
*/ (line Results time if college == 0 & cohort == 6, lcolor(gs12) lpattern(solid)) /*
*/ (line Results time if college == 0 & cohort == 7, lcolor(gs0) lpattern(longdash)) /*
*/ (line Results time if college == 0 & cohort == 8, lcolor(gs6) lpattern(solid)) /*
*/ (line Results time if college == 0 & cohort == 9, lcolor(gs12) lpattern(shortdash)), /*
*/ legend(label(1 "1880s") label(2 "1890s") label(3 "1900s") label(4 "1910s") /*
*/ label(5 "1920s") label(6 "1930s") label(7 "1940s") label(8 "1950s") /*
*/ label(9 "1960s") rows(3)) xtitle("Survey Year") ytitle("Partisan Gender Gap") /*
*/ ylabel(-.12(.04).04) /*
*/ xlabel(0.75 " " 1 "1953-1962"  2 "1963-1972"  3 "1973-1982"  4 "1982-1992"  /*
*/ 5 "1993-1997" 5.25 " ", notick) xmtick(1(1)5) graphregion(fcolor(white)) ylabel(,nogrid) 
graph export "TablesFigures/Figure7b.eps", as(eps) replace  

log close
