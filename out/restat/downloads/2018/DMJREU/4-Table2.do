*----------------------------------------------------------------------------------------------------------------------------------------------*
*This program performs the estimations shown in Table 2 of Berman, Rebeyrol, Vicard "Demand learning and firm dynamics: evidence from exporters"
*This version: September 2017
*----------------------------------------------------------------------------------------------------------------------------------------------*

log using "$results\Table2.log", replace

***************
* A - Table 2 *
***************

use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"

foreach def in ele1{

	foreach var in diff {

		eststo: reg dprior `var' age_`def'					    if $condition, r cluster(i)
		eststo: reg dprior `var' age_`def' `var'_`def' 			if $condition, r cluster(i)
		eststo: reg dprior `var' age_`def' `var'_`def' 			if $condition, vce(bootstrap) 
		eststo: reg dprior `var'_`def'_* `def'_* 	   			if $condition, r cluster(i)
		test diff_ele1_2 = diff_ele1_3 
		test diff_ele1_3 = diff_ele1_4
		test diff_ele1_4 = diff_ele1_5
		test diff_ele1_5 = diff_ele1_6
		test diff_ele1_6 = diff_ele1_7
		test diff_ele1_7 = diff_ele1_8
		test diff_ele1_8 = diff_ele1_9
		test diff_ele1_9 = diff_ele1_10
		eststo: reg dprior `var'_`def'_* `def'_* 	   			if $condition, vce(bootstrap) 
		test diff_ele1_2 = diff_ele1_3 
		test diff_ele1_3 = diff_ele1_4
		test diff_ele1_4 = diff_ele1_5
		test diff_ele1_5 = diff_ele1_6
		test diff_ele1_6 = diff_ele1_7
		test diff_ele1_7 = diff_ele1_8
		test diff_ele1_8 = diff_ele1_9
		test diff_ele1_9 = diff_ele1_10
		drop `var'_`def'_10	`def'_10	
		eststo: reg dprior `var' `var'_`def'_* `def'_* 	   		if $condition, r cluster(i)
		eststo: reg dprior `var' `var'_`def'_* `def'_* 	   		if $condition, vce(bootstrap) 
		
		set linesize 250
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
		eststo clear
	}
}


**********************************
* B - Figure A.3 (web appendix)  *
**********************************
*
use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"
*
reg dprior diff_ele1_* ele1_*  if $condition, r cluster(i)
*
forvalues x=2(1)10{
lincom diff_ele1_`x'
g beta_age_`x' = r(estimate) 
g se_age_`x'   = r(se) 
}
keep if _n == 1
collapse (max) beta_age_* se_age_*, by(age_ele1)

g obs = 1
reshape long beta_age_  se_age_ , i(obs) j(experience)
drop age_ele1
rename  beta_age_  beta_age
rename  se_age_    se_age
*
g beta_age_min = beta_age-1.96*se_age
g beta_age_max = beta_age+1.96*se_age
*
g zero = 0
local zero = 0 
*
global bandwidth = 0.66
gen beta_bench = 0
local beta_bench = beta_bench

label define experience 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10"
label values experience experience
label list
*
twoway rarea beta_age_min beta_age_max experience,  fintensity(inten30) bsty(ci) sort  xlabel(2 3 4 5 6 7 8 9 10,  valuelabel) ///
|| scatter beta_age experience, scheme(s2color) c(l) xtitle("# years since last entry") ///
title("Belief updating", pos(11) ring(0) size(medium)) legend(off) bgcolor(white) graphregion(color(white)) ysize(4) xsize(4) scale(0.8)
graph export $results\Figure_A3.eps, as(eps) replace

*With functional form assumtion

use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"
keep if $condition

*solve equation to know x in 1/(x+t) for t=2 (shape the coefficients should have) (first coefficient as benchmark)
reg dprior diff_ele1_2-diff_ele1_10 ele1_2-ele1_9 , r cluster(i)

g coeff_ur = .
forvalues y = 2(1)10{
replace coeff_ur = _b[diff_ele1_`y'] if age_ele1 == `y'
}

g high_ur = .
forvalues y = 2(1)10{
replace high_ur = _b[diff_ele1_`y']+1.96*_se[diff_ele1_`y'] if age_ele1 == `y'
}


g low_ur = .
forvalues y = 2(1)10{
replace low_ur = _b[diff_ele1_`y']-1.96*_se[diff_ele1_`y'] if age_ele1 == `y'
}


g coeff_r = .
scalar x = (1-2*_b[diff_ele1_2])/_b[diff_ele1_2]

forvalues y = 2(1)10{
replace coeff_r = 1/(x+`y') if age_ele1 == `y'
}

collapse (max) coeff_ur coeff_r high_ur low_ur, by(age_ele1)
drop if age_ele1==1
twoway rarea  high_ur low_ur age_ele1,  fintensity(inten30) bsty(ci) sort  xlabel(2 3 4 5 6 7 8 9 10,  valuelabel) ///
|| scatter coeff_ur age_ele1 , scheme(s2gmanual) lpattern(dash)  msymbol(O) c(l) xtitle("# years since last entry") ///
|| scatter coeff_r age_ele1,   msymbol(O) c(l) xtitle("# years since last entry")
graph export $results\functional_form.eps, as(eps) replace


log close
