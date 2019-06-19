
clear
set more off
set mem 200m
est clear


capture program drop add_param
program define add_param, eclass
 ereturn scalar `1' = `2'
end


clear
use aha_final_esr.dta


**
* get final sample
**

assert(ipdtot == 0) if year == 1979
replace ipdtot = . if year == 1979


global summ_list = ///
 "tot_size payroll num_employees exptot paytot admtot ipdtot bdtot fte log_frac_ern tech_max num_hosp pop_unweighted population "
replace tot_size = tot_size * 1e6
foreach var of varlist payroll pop_unweighted population num_employees exptot paytot ipdtot admtot {
 replace `var' = `var' / 1e6
}
replace bdtot = bdtot / 1000
replace fte = fte / 1000



**
* cross-sectional differences
**
preserve
keep if year == 1970 & log_payroll < . & log_exptot
summ tot_size, det
capture drop wage
gen wage = payroll / num_employees

keep if south == 1

summ pop_unweighted num_employees exptot bdtot payroll wage if tot_size > 0.001
summ pop_unweighted num_employees exptot bdtot payroll wage if tot_size == 0
summ pop_unweighted num_employees exptot bdtot payroll wage if tot_size > 0.001 & south == 1
summ pop_unweighted num_employees exptot bdtot payroll wage if tot_size == 0 & south == 1

capture drop oil_dummy
gen oil_dummy = (tot_size > 0 & tot_size < .)



**replace pop_unweighted = pop_unweighted * 1000
**replace num_employees  = num_employees * 1000
replace tot_size = tot_size / 1000

replace exptot = exptot / 1000
replace payroll = payroll / 1000

local depvars = "tot_size"
foreach depvar of local depvars {

 summ `depvar'
 replace `depvar' = `depvar' / r(sd)

est clear
foreach var of varlist pop_unweighted num_employees exptot bdtot payroll {

  gen `var'_orig = `var' 
  summ `var'
  replace `var' = `var' / r(sd)
  reg `depvar' `var', robust
  test `var'
  add_param "pval" r(p)

  summ `var'_orig if tot_size >  0, meanonly
  add_param "mean_w" r(mean)
  summ `var'_orig if tot_size == 0, meanonly
  add_param "mean_wo" r(mean)

  est store `var'
}
reg `depvar' pop_unweighted num_employees exptot bdtot payroll , robust
test pop_unweighted num_employees exptot bdtot payroll 
add_param "pval"  r(p)
add_param "Fstat" r(F)
est store all_wpop

reg `depvar' num_employees exptot bdtot payroll, robust
test num_employees exptot bdtot payroll 
add_param "pval"  r(p)
add_param "Fstat" r(F)
est store all_nopop

summ tot_size pop_unweighted payroll
estout * ///
 using table2_comparing_ESRs.txt, ///
    stats(mean_w mean_wo diff Fstat pval, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_cons) title("`title_str'")

** END FOR each depvars
}

restore




preserve 


keep if year >= 1970 & year <= 1990 & log_payroll < . & south == 1
keep if log_exptot < . 

matrix table1 = J(38, 10, 0)

local i = 1
foreach var of varlist $summ_list {

 di " - - - - - - "
 di "summarizing variables `var' ..."
 di " - - - - - - "

 summ `var', det
 matrix table1[`i', 1] = r(N)
 matrix table1[`i', 2] = r(mean)
 matrix table1[`i', 3] = r(sd)
 matrix table1[`i', 4] = r(min)
 matrix table1[`i', 5] = r(p5)
 matrix table1[`i', 6] = r(p25)
 matrix table1[`i', 7] = r(p50)
 matrix table1[`i', 8] = r(p75)
 matrix table1[`i', 9] = r(p95)
 matrix table1[`i', 10] = r(max)

 local i = `i' + 1
}

tab fipsStateCode, missing

matrix list table1
drop _all
svmat table1
rename table11 N_0
rename table12 mean_0
rename table13 sd_0
rename table14 p5_0
rename table15 p50_0
rename table16 p95_0

outsheet using table1_summ_stats.txt, replace

restore










	

clear
use aha_final_state.dta

**
* Merge in GSP data
**
sort  fipsStateCode year
capture drop _merge
merge fipsStateCode year using ./dta/state_GSP, uniqusing uniqmaster
list fipsStateCode year if _merge != 3
keep if _merge == 3

foreach var of varlist gdp_* {
  replace `var' = . if `var' < 0
}

assert(ipdtot == 0) if year == 1979
replace ipdtot = . if year == 1979
replace bdtot = bdtot / 1000
replace fte = fte / 1000

global summ_list = ///
 "tot_size payroll num_employees exptot paytot admtot ipdtot bdtot fte log_frac_ern tech_max num_hosp pop_unweighted population gsp gdp_health_servs gdp_amuse_servs gdp_hotels gdp_legal_servs gdp_other_servs gdp_food"

preserve 

replace tot_size = tot_size * 1e6

foreach var of varlist payroll pop_unweighted population num_employees exptot paytot ipdtot admtot {
 replace `var' = `var' / 1e6
}

keep if year >= 1970 & year <= 1990 & log_payroll < . & south == 1
keep if log_exptot < . 

matrix table1 = J(38, 10, 0)

local i = 1
foreach var of varlist $summ_list {

 di " - - - - - - "
 di "summarizing variables `var' ..."
 di " - - - - - - "

 summ `var', det
 matrix table1[`i', 1] = r(N)
 matrix table1[`i', 2] = r(mean)
 matrix table1[`i', 3] = r(sd)
 matrix table1[`i', 4] = r(min)
 matrix table1[`i', 5] = r(p5)
 matrix table1[`i', 6] = r(p25)
 matrix table1[`i', 7] = r(p50)
 matrix table1[`i', 8] = r(p75)
 matrix table1[`i', 9] = r(p95)
 matrix table1[`i', 10] = r(max)

 local i = `i' + 1
}

tab fipsStateCode, missing

matrix list table1
drop _all
svmat table1
rename table11 N_0
rename table12 mean_0
rename table13 sd_0
rename table14 p5_0
rename table15 p50_0
rename table16 p95_0

outsheet using table1_summ_stats_state.txt, replace

restore


	

