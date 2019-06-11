cd "~/Dropbox/Shared Folder - J. Ladd & M (1). Meredith/Replication Files/"
cap log close
log using "LogFiles/FigureA1.log", replace

clear all
set more off

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

egen total_partisan_female_col = sum(partisan * (female == 1) * (education == 5) * final_weight) , by (series)
egen total_partisan_male_col = sum(partisan * (female == 0) * (education == 5) * final_weight), by (series)
egen total_obs_female_col = sum((female == 1) * (education == 5) * (final_weight)), by (series)
egen total_obs_male_col = sum((female == 0) * (education == 5) * (final_weight)), by (series)
gen partisan_female_col = total_partisan_female_col / total_obs_female_col
gen partisan_male_col = total_partisan_male_col / total_obs_male_col
gen partisan_difference_col = partisan_female_col - partisan_male_col 
egen total_partisan_female_ncol = sum(partisan * (female == 1) * (education ~= 5) * final_weight) , by (series)
egen total_partisan_male_ncol = sum(partisan * (female == 0) * (education ~= 5) * final_weight), by (series)
egen total_obs_female_ncol = sum((female == 1) * (education ~= 5) * (final_weight)), by (series)
egen total_obs_male_ncol = sum((female == 0) * (education ~= 5) * (final_weight)), by (series)
gen partisan_female_ncol = total_partisan_female_ncol / total_obs_female_ncol
gen partisan_male_ncol = total_partisan_male_ncol / total_obs_male_ncol
gen partisan_difference_ncol = partisan_female_ncol - partisan_male_ncol 
keep if obs_num == 1

// Only keeps polls from 1970s and 1980s in memory
keep if year(middle_date) >= 1970 & year(middle_date) <= 1989

matrix mse = J(12, 5, 0)
levelsof series if year(middle_date) >= 1975 & year(middle_date) <= 1984, local (poll)
local count = 0
forvalues j = 25(25)300{
display `j'
qui forvalues i = 1(1)4 {
gen forecasterror`i' = .
}
qui foreach i of local poll {
lpoly partisan_female_col middle_date if series ~= "`i'", at(middle_date) bwidth(`j') generate(lpoly_fitted) noscatter nograph
replace forecasterror1 = partisan_female_col - lpoly_fitted if series == "`i'" 
drop lpoly_fitted
lpoly partisan_male_col middle_date if series ~= "`i'", at(middle_date) bwidth(`j') generate(lpoly_fitted) noscatter nograph
replace forecasterror2 = partisan_male_col - lpoly_fitted if series == "`i'" 
drop lpoly_fitted
lpoly partisan_female_ncol middle_date if series ~= "`i'", at(middle_date) bwidth(`j') generate(lpoly_fitted) noscatter nograph
replace forecasterror3 = partisan_female_ncol - lpoly_fitted if series == "`i'" 
drop lpoly_fitted
lpoly partisan_male_ncol middle_date if series ~= "`i'", at(middle_date) bwidth(`j') generate(lpoly_fitted) noscatter nograph
replace forecasterror4 = partisan_male_ncol - lpoly_fitted if series == "`i'" 
drop lpoly_fitted
}
local count = `count' + 1 
matrix mse[`count', 1] = `j'
gen temp = .
forvalues i = 1(1)4 {
replace temp = forecasterror`i'^2
qui sum temp
matrix mse[`count', 1 + `i']= r(mean)
}
drop temp forecasterror*
}

clear
svmat mse
rename mse1 Bandwidth
rename mse2 MSEFemale1
rename mse3 MSEMale1
rename mse4 MSEFemale2
rename mse5 MSEMale2
gen MSELevel = (MSEFemale1 + MSEMale1 + MSEFemale2 + MSEMale2) / 4

twoway (scatter MSELevel Bandwidth, mcolor(black) mfcolor(white) msize(large) /*
*/ ytitle("Average Squared Forecast Error (1975 - 1984)") color(black) scale(.8) graphregion(fcolor(white)))
graph export "TablesFigures/FigureA1.eps", as(eps) replace

log close
