*------------------------------------------------------------------------------------------------------------------------------------------*
*This program construct Figures 2a, 2b, 2c and A.5 of Berman, Rebeyrol, Vicard "Demand learning and firm dynamics: evidence from exporters"	
*This version: September 2017
*------------------------------------------------------------------------------------------------------------------------------------------*

cap log close
log using "$results\Figure2.log", replace


/// Without FE: Figure 2a

use "$Output\dataset_brv_fe", clear
tab age_ele1, gen(aged)
replace aged10 = 1 if age_ele1>=10
drop aged11
tab year, gen(yeard)
*
global condition     "entry_ele!=1994 & entry_ele!=1995 "
*
eststo: reg res_fe_qty    		aged2-aged10     if $condition, ro cluster(i)
forvalues x=2(1)10{
	lincom aged`x'
	g beta_age_q_`x' = r(estimate)
	g se_age_q_`x'   = r(se) 
}
eststo: reg res_fe_uv_nojkt 	aged2-aged10 	 if $condition  & e(sample), ro cluster(i)
forvalues x=2(1)10{
	lincom aged`x'
	g beta_age_p_`x' = r(estimate)
	g se_age_p_`x'   = r(se) 
}
forvalues x=1(1)1{
	g beta_age_p_`x' = 0
	g beta_age_q_`x' = 0
	g se_age_p_`x'   = 0
	g se_age_q_`x'   = 0 
}

keep if _n == 1

collapse (max) beta_age_* se_age_*, by(age_ele1)

g obs = 1
reshape long beta_age_q_ beta_age_p_ se_age_q_ se_age_p_, i(obs) j(experience)
drop age_ele1
rename  beta_age_q_ beta_age_q
rename  beta_age_p_  beta_age_p
rename  se_age_q_   se_age_q
rename  se_age_p_  se_age_p
*
g zero = 0
local zero = 0 
*
global bandwidth = 0.66
gen beta_bench = 0
local beta_bench = beta_bench

g beta_age_q_min = beta_age_q-1.96*se_age_q
g beta_age_q_max = beta_age_q+1.96*se_age_q
g beta_age_p_min = beta_age_p-1.96*se_age_p
g beta_age_p_max = beta_age_p+1.96*se_age_p
				
label define experience 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10"
label values experience experience
label list
label var beta_age_q "quantities"
label var beta_age_p "prices"
*
twoway scatter beta_age_q experience,  lwidth(thin) c(l) lpattern(dash) sort  xlabel(1 2 3 4 5 6 7 8 9 10,  valuelabel) ylabel(-0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8)  ///
|| scatter beta_age_p experience,   lwidth(thin) lpattern(solid) c(l) xtitle("# years since last entry") ///
|| line beta_bench experience, color(gs5) ///
legend(on order(1 2)) bgcolor(white) graphregion(color(white)) ysize(2) xsize(2) ysc(r(-0.2 0.8))
graph export "$results\Figure2a.eps", as(eps) replace

eststo clear

/// With FE: Figure 2b

use "$Output\dataset_brv_fe", clear
tab age_ele1, gen(aged)
replace aged10 = 1 if age_ele1>=10
drop aged11
tab year, gen(yeard)
*
global condition     "entry_ele!=1994 & entry_ele!=1995 "
*
eststo: areg res_fe_qty    		aged2-aged10     if $condition , a(ijk) cluster(i)
forvalues x=2(1)10{
	lincom aged`x'
	g beta_age_q_`x' = r(estimate)
	g se_age_q_`x'   = r(se) 
}
eststo: areg res_fe_uv_nojkt   	aged2-aged10     if $condition  & e(sample), a(ijk) cluster(i)
forvalues x=2(1)10{
	lincom aged`x'
	g beta_age_p_`x' = r(estimate)
	g se_age_p_`x'   = r(se) 
}
forvalues x=1(1)1{
	g beta_age_p_`x' = 0
	g beta_age_q_`x' = 0
}

keep if _n == 1

collapse (max) beta_age_* se_age_*, by(age_ele1)

g obs = 1
reshape long beta_age_q_ beta_age_p_ se_age_q_ se_age_p_, i(obs) j(experience)
drop age_ele1
rename  beta_age_q_ beta_age_q
rename  beta_age_p_  beta_age_p
rename  se_age_q_   se_age_q
rename  se_age_p_  se_age_p
*
g zero = 0
local zero = 0 
*
global bandwidth = 0.66
gen beta_bench = 0
local beta_bench = beta_bench

g beta_age_q_min = beta_age_q-1.64*se_age_q
g beta_age_q_max = beta_age_q+1.64*se_age_q
g beta_age_p_min = beta_age_p-1.64*se_age_p
g beta_age_p_max = beta_age_p+1.64*se_age_p
				
label define experience 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10"
label values experience experience
label list
label var beta_age_q "quantities"
label var beta_age_p "prices"
*
twoway scatter beta_age_q experience,  c(l) lpattern(dash) lwidth(thin) sort  xlabel(1 2 3 4 5 6 7 8 9 10,  valuelabel)  ylabel(-0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8) ///
|| scatter beta_age_p experience,  lwidth(thin) lpattern(solid) c(l) xtitle("# years since last entry")  ///
|| line beta_bench experience, color(gs5) ///
legend(on order(1 2)) bgcolor(white) graphregion(color(white)) ysize(2) xsize(2) ysc(r(-0.2 0.68)) 
graph export "$results\Figure_2b.eps", as(eps) replace

eststo clear

/// With FE & reconstructed years: Figure 2c

use "$Output\dataset_brv_fe_reconstr", clear
tab age_ele1, gen(aged)
replace aged10 = 1 if age_ele1>=10
drop aged11
tab year, gen(yeard)
*
global condition     "entry_ele!=1994 & entry_ele!=1995 "
*
eststo: areg res_fe_qty    		aged2-aged9     if $condition , a(ijk) cluster(i)
forvalues x=2(1)9{
	lincom aged`x'
	g beta_age_q_`x' = r(estimate)
	g se_age_q_`x'   = r(se) 
}
eststo: areg res_fe_uv_nojkt   	aged2-aged9     if $condition  & e(sample), a(ijk) cluster(i)
forvalues x=2(1)9{
	lincom aged`x'
	g beta_age_p_`x' = r(estimate)
	g se_age_p_`x'   = r(se) 
}
forvalues x=1(1)1{
	g beta_age_p_`x' = 0
	g beta_age_q_`x' = 0
}

keep if _n == 1

collapse (max) beta_age_* se_age_*, by(age_ele1)

g obs = 1
reshape long beta_age_q_ beta_age_p_ se_age_q_ se_age_p_, i(obs) j(experience)
drop age_ele1
rename  beta_age_q_ beta_age_q
rename  beta_age_p_  beta_age_p
rename  se_age_q_   se_age_q
rename  se_age_p_  se_age_p
*
g zero = 0
local zero = 0 
*
global bandwidth = 0.66
gen beta_bench = 0
local beta_bench = beta_bench

g beta_age_q_min = beta_age_q-1.64*se_age_q
g beta_age_q_max = beta_age_q+1.64*se_age_q
g beta_age_p_min = beta_age_p-1.64*se_age_p
g beta_age_p_max = beta_age_p+1.64*se_age_p
				
label define experience 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 
label values experience experience
label list
label var beta_age_q "quantities"
label var beta_age_p "prices"
*
twoway scatter beta_age_q experience,  c(l) lpattern(dash) lwidth(thin) sort  xlabel(1 2 3 4 5 6 7 8 9 ,  valuelabel)  ylabel(-0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8) ///
|| scatter beta_age_p experience,  lwidth(thin) lpattern(solid) c(l) xtitle("# years since last entry")  ///
|| line beta_bench experience, color(gs5) ///
legend(on order(1 2)) bgcolor(white) graphregion(color(white)) ysize(2) xsize(2) ysc(r(-0.2 0.68)) 
graph export "$results\Figure_2c.eps", as(eps) replace

eststo clear

/// survivors 10 years: Figure A.5 (web appendix)

use "$Output\dataset_brv_fe", clear
tab age_ele1, gen(aged)
replace aged10 = 1 if age_ele1>=10
drop aged11
tab year, gen(yeard)
*
global condition     "entry_ele!=1994 & entry_ele!=1995 "
*
eststo: reg res_fe_qty    		aged2-aged10     if $condition & age_ele1_max==10, ro cluster(i)
forvalues x=2(1)10{
	lincom aged`x'
	g beta_age_q_`x' = r(estimate)
	g se_age_q_`x'   = r(se) 
}
eststo: reg res_fe_uv_nojkt 	aged2-aged10 	 if $condition  & e(sample) & age_ele1_max==10, ro cluster(i)
forvalues x=2(1)10{
	lincom aged`x'
	g beta_age_p_`x' = r(estimate)
	g se_age_p_`x'   = r(se) 
}
forvalues x=1(1)1{
	g beta_age_p_`x' = 0
	g beta_age_q_`x' = 0
	g se_age_p_`x'   = 0
	g se_age_q_`x'   = 0 
}

keep if _n == 1

collapse (max) beta_age_* se_age_*, by(age_ele1)

g obs = 1
reshape long beta_age_q_ beta_age_p_ se_age_q_ se_age_p_, i(obs) j(experience)
drop age_ele1
rename  beta_age_q_ beta_age_q
rename  beta_age_p_  beta_age_p
rename  se_age_q_   se_age_q
rename  se_age_p_  se_age_p
*
g zero = 0
local zero = 0 
*
global bandwidth = 0.66
gen beta_bench = 0
local beta_bench = beta_bench

g beta_age_q_min = beta_age_q-1.96*se_age_q
g beta_age_q_max = beta_age_q+1.96*se_age_q
g beta_age_p_min = beta_age_p-1.96*se_age_p
g beta_age_p_max = beta_age_p+1.96*se_age_p
				
label define experience 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10"
label values experience experience
label list
label var beta_age_q "quantities"
label var beta_age_p "prices"
*
twoway scatter beta_age_q experience,  lwidth(thin) c(l) lpattern(dash) sort  xlabel(1 2 3 4 5 6 7 8 9 10,  valuelabel) ylabel(-0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8)  ///
|| scatter beta_age_p experience,   lwidth(thin) lpattern(solid) c(l) xtitle("# years since last entry") ///
|| line beta_bench experience, color(gs5) ///
legend(on order(1 2)) bgcolor(white) graphregion(color(white)) ysize(2) xsize(2) ysc(r(-0.2 0.8))
graph export "$results\Figure_A5.eps", as(eps) replace

log close









