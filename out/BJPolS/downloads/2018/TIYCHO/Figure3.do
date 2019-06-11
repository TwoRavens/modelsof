cd "~/Dropbox/Shared Folder - J. Ladd & M (1). Meredith/Replication Files/"
cap log close
log using "LogFiles/Figure3.log", replace

clear all
set more off

mat results = J(18, 6, -9)

use "RawData/anes_timeseries_cdf.dta", clear

// Generates College Graduate Dummy Variables
tab VCF0110 
gen college = (VCF0110 == 4)
replace college = . if VCF0110 == 0

//
// Rescales Party Issue Positions
// 0 means the party is maximally liberal
// 1 means the party is maximally conservative
// Difference in Party Issue Positions
// 1 means Rep is maximally conservative, Dem is maximally liberal
// 0 means parties are the same ideologically
// -1 means Dem is maximally conservative, Rep is maximally liberal
//

foreach var of varlist VCF05* {
display "`var'"
tab `var'
tab `var' VCF0004
}

// Govt Health Insurance Scale
local variable1 = "VCF0508"
tab `variable1'
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0509"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem1 = `variable2' - `variable1'
tab VCF0004 if missing(repminusdem1) == 0

// Guaranteed Jobs Scale
local variable1 = "VCF0513"
tab `variable1'
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0514"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem2 = `variable2' - `variable1'
tab VCF0004 if missing(repminusdem2) == 0

// Aid to Blacks Scale
local variable1 = "VCF0517"
tab `variable1'
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0518"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem3 = `variable2' - `variable1'
tab VCF0004 if missing(repminusdem3) == 0

// Rights of Accused Scale
local variable1 = "VCF0524"
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0525"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem4 = `variable2' - `variable1'
tab VCF0004 if missing(repminusdem4) == 0

// Urban Unrest Scale
local variable1 = "VCF0528"
tab `variable1'
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0529"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem5 = `variable2' - `variable1'
tab VCF0004 if missing(repminusdem5) == 0

// Aid to Blacks Scale
local variable1 = "VCF0533"
tab `variable1'
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0534"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem6 = `variable2' - `variable1'
tab VCF0004 if missing(repminusdem6) == 0

// Gender Roles
local variable1 = "VCF0537"
tab `variable1'
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0538"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem7 = `variable2' - `variable1'
tab VCF0004 if missing(repminusdem7) == 0

// Govt Services/Spending Scale
local variable1 = "VCF0541"
tab `variable1'
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0542"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem8 = `variable1' - `variable2'  
tab VCF0004 if missing(repminusdem8) == 0

// Cooperation with U.S.S.R. Scale
local variable1 = "VCF0545"
tab `variable1'
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0546"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem9 = `variable2' - `variable1'
tab VCF0004 if missing(repminusdem9) == 0

// Defense Spending Scale 
local variable1 = "VCF0549"
tab `variable1'
replace `variable1' = . if `variable1' == 0 | `variable1' == 8 | `variable1' == 9
replace `variable1' = (`variable1' - 1) / 6
local variable2 = "VCF0550"
tab `variable2'
replace `variable2' = . if `variable2' == 0 | `variable2' == 8 | `variable2' == 9
replace `variable2' = (`variable2' - 1) / 6
gen repminusdem10 = `variable2' - `variable1'
tab VCF0004 if missing(repminusdem10) == 0

keep if (VCF0004 >= 1970 & VCF0004 <= 2000) | VCF0004 == 2004  | VCF0004 == 2012
keep repminusdem* VCF0009z VCF0004 college
gen ID = _n
reshape long repminusdem, i(ID VCF0009z VCF0004 college) j(question)
tab VCF0004, gen(yeardum)

regress repminusdem yeardum* [pweight = VCF0009z] if college == 1, noconst robust cluster(ID)
mat coeff = e(b)
mat var = e(V)
forvalues i = 1(1)18 {
mat results[`i', 1] = coeff[1, `i']
mat results[`i', 2] = coeff[1, `i'] - 1.96*var[`i',`i']^(1/2)
mat results[`i', 3] = coeff[1, `i'] + 1.96*var[`i',`i']^(1/2)
}

regress repminusdem yeardum* [pweight = VCF0009z] if college == 0, noconst robust cluster(ID)
mat coeff = e(b)
mat var = e(V)
forvalues i = 1(1)18 {
mat results[`i', 4] = coeff[1, `i']
mat results[`i', 5] = coeff[1, `i'] - 1.96*var[`i',`i']^(1/2)
mat results[`i', 6] = coeff[1, `i'] + 1.96*var[`i',`i']^(1/2)
}

matlist results

clear 
svmat results

gen year = 1970 + (_n - 1)*2
replace year = 2012 if year == 2004
replace year = 2004 if year == 2002

twoway (scatter results1 year, mcolor(black) mfcolor(white) msymbol(circle) msize(large)) /*
*/ (rspike results2 results3 year, lcolor(black)) /*
*/ (lfit results1 year, lcolor(gray)) /*
*/ (scatter results4 year, mcolor(black) mfcolor(black) msymbol(circle) msize(large)) /*
*/ (rspike results5 results6 year, lcolor(black)) /*
*/ (lfit results4 year, lcolor(gray)), /*
*/ legend(rows(1) label(1 "College Graduates") label(4 "Non-College Graduates") /*
*/ order(1 4)) /*
*/ xtitle("Survey Year") ytitle("Differences in Ideological" "Assessments of Parties' Issue Positions") /*
*/ xlabel(1970(4)2010) ylabel(0(.1).5) plotregion(color(white)) graphregion(color(white)) ylabel(,grid) 

graph export "TablesFigures/Figure3.eps", replace

regress results1 year
regress results4 year

log close
