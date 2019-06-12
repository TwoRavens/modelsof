*-------------------------------------------------------------------------------------------------------------------------------------------------*
*This program performs the estimations shown in Table 2 of Berman, Rebeyrol, Vicard "Demand learning and firm dynamics: evidence from exporters"
*This version: March 2017
*
	/* A- Compute uncertainty measure*/
	/* B- Results table 3 */
	/* C- Figure A.4 (web appendix) */
*
*-------------------------------------------------------------------------------------------------------------------------------------------------*

cap log close
log using "$results\Table3.log", replace

***************************
* A - UNCERTAINTY MEASURE *
***************************

** By country/product hs6 ** 

use "$Output\dataset_brv_fe", clear
keep prod country shock_nojkt_trim sigma_sign_nojkt
g exp_shock_nojkt_trim  = sigma_sign_nojkt*exp(shock_nojkt_trim)
replace shock_nojkt_trim = shock_nojkt_trim*sigma_sign_nojkt
collapse (sd) sd_lres_v = shock_nojkt_trim sd_res_v = exp_shock_nojkt_trim , by(country prod)
sort country prod
save "$Output\sd_res_jk", replace


***************
* B - TABLE 3 *
***************

use "$Output\dataset_brv_fe", clear

global condition  "entry_ele!=1994 & entry_ele!=1995"
keep if $condition
tsset ijk year 

sort  country prod
merge country prod using "$Output\sd_res_jk", nokeep
tab  _merge
drop _merge

foreach sd in sd_lres_v{
	rename `sd' sd_jk

	gen diff_sd   	  = diff*sd_jk
	gen diff_sd_ele1  = diff*sd_jk*age_ele1
	gen age_ele1_sd   = age_ele1*sd_jk

	egen jk = group(prod country)

	egen median_sd_jk = pctile(sd_jk), p(50)
	
foreach var in diff {

		eststo: reg dprior `var' age_ele1  sd_jk  `var'_ele1 `var'_sd 							if $condition, r cluster(jk)
		*quantif
		sum sd_jk, d
		scalar sd_mean = r(mean)
		scalar sd_sd = r(sd)
		lincom `var'+`var'_sd*sd_mean
		lincom `var'+`var'_sd*(sd_mean+sd_sd)
		eststo: reg dprior `var' age_ele1  sd_jk  `var'_ele1 `var'_sd age_ele1_sd `var'_sd_ele1 if $condition, r cluster(jk)
		eststo: reg dprior `var'  age_ele1 `var'_ele1 											if sd_jk>median_sd_jk & sd_jk!=., r cluster(jk)
		eststo: reg dprior `var'  age_ele1 `var'_ele1 											if sd_jk<median_sd_jk & sd_jk!=., r cluster(jk)

		set linesize 250
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
		eststo clear
					
	}
}

	
*********************************
* B - FIGURE A.4 (web appendix) *
*********************************

use "$Output\dataset_brv_fe", clear

global condition  "entry_ele!=1994 & entry_ele!=1995"
keep if $condition

sort  country prod
merge country prod using "$Output\sd_res_jk", nokeep
tab  _merge
drop _merge

rename sd_lres_v sd_jk

gen diff_sd   	= diff*sd_jk
gen diff_sd_ele1  = diff*sd_jk*age_ele1

gen age_ele1_sd      			= age_ele1*sd_jk

egen median_sd_jk = pctile(sd_jk), p(50)
egen p25_sd_jk = pctile(sd_jk), p(25)
egen p75_sd_jk = pctile(sd_jk), p(75)

egen jk = group(prod country)
*
eststo: reg dprior diff_ele1_2-diff_ele1_10 ele1_* 	   												if $condition & sd_jk>p75_sd_jk & sd_jk!=., r cluster(jk)

forvalues x=2(1)10{
	lincom diff_ele1_`x'
	g beta_age_high_`x' = r(estimate)
	g se_age_high_`x'   = r(se) 
}

eststo: reg dprior diff_ele1_2-diff_ele1_10 ele1_* 	   												if $condition & sd_jk<p25_sd_jk & sd_jk!=., r cluster(jk)

set linesize 250
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear

forvalues x=2(1)10{
	lincom diff_ele1_`x'
	g beta_age_low_`x' = r(estimate) 
	g se_age_low_`x'   = r(se) 
}

keep if _n == 1

collapse (max) beta_age_* se_age_*, by(age_ele1)

g obs = 1
reshape long beta_age_high_ beta_age_low_ se_age_high_ se_age_low_, i(obs) j(experience)
drop age_ele1
rename  beta_age_high_ beta_age_high
rename  beta_age_low_  beta_age_low
rename  se_age_high_   se_age_high
rename  se_age_low_  se_age_low
*
g zero = 0
local zero = 0 
*
global bandwidth = 0.66
gen beta_bench = 0
local beta_bench = beta_bench

g beta_age_high_min = beta_age_high-1.64*se_age_high
g beta_age_high_max = beta_age_high+1.64*se_age_high
g beta_age_low_min = beta_age_low-1.64*se_age_low
g beta_age_low_max = beta_age_low+1.64*se_age_low
				
label define experience 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7+" 8 "8" 9 "9" 10 "10"
label values experience experience
label list
label var beta_age_high "High uncertainty"
label var beta_age_low  "Low uncertainty"
*
twoway rarea  beta_age_low_min beta_age_low_max experience,  fintensity(inten30) bsty(ci) sort  xlabel(2 3 4 5 6 7 8 9 10,  valuelabel) ///
|| scatter beta_age_low experience, scheme(s2gmanual) lpattern(dash)  msymbol(O) c(l) xtitle("# years since last entry") ///
|| rarea  beta_age_high_min beta_age_high_max experience,  fintensity(inten30) bsty(ci) sort  xlabel(2 3 4 5 6 7 8 9 10,  valuelabel) ///
|| scatter beta_age_high experience,   msymbol(O) c(l) xtitle("# years since last entry") ///
title("Belief updating", pos(11) ring(0) size(medium)) legend(on order(2 4)) bgcolor(white) graphregion(color(white)) ysize(4) xsize(4) scale(0.8)
graph export $results\Figure_A4.eps, as(eps) replace


erase "$Output\sd_res_jk.dta"

log close

