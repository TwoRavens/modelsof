*--------------------------------------------------------------------------------------------------------------------------*
* This program computes the descriptive stats shown Table 1 of "Demand learning and firm dynamics: evidence from exporters"
* This version: November 08, 2016
*--------------------------------------------------------------------------------------------------------------------------*


* section 2.1: database *

log using $statdes\statdes.txt, text replace

** nbr of firms, ctry, prod... **
use $Output\dataset_brv_fe, clear
keep if entry_ele!=1994 & entry_ele!=1995
codebook siren
codebook country
codebook prod

log close


** Table 1: stat des **

foreach var in ln_export ln_qty ln_uv dln_export {
use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"
keep if $condition
tsset ijk year 
collapse (count) N = `var' (mean) mean = `var' (median) median = `var' (sd) sd = `var' (p25) p25 = `var' (p75) p75 = `var'
g name = "`var'" 
save "$results\stats_`var'", replace
}

foreach var in dprior diff dres_fe_uv_nojkt shock_nojkt_trim sigma_nojkt sigma_sign_nojkt sigma_sign_nojkt_trim age_ele1 age_ele2 age_ele3 {
use $Output\dataset_brv_fe, clear
tsset ijk year 
gen dres_fe_uv_nojkt = d.res_fe_uv_nojkt
global condition  "entry_ele!=1994 & entry_ele!=1995"
qui: reg dprior shock_nojkt_trim	if $condition, r
keep if e(sample)
tsset ijk year 
collapse (count) N = `var' (mean) mean = `var' (median) median = `var' (sd) sd = `var' (p25) p25 = `var' (p75) p75 = `var'
g name = "`var'" 
save "$results\stats_`var'", replace
}

use "$results\stats_ln_export", clear
foreach var in ln_qty ln_uv dln_export dprior dres_fe_uv_nojkt diff shock_nojkt_trim sigma_nojkt sigma_sign_nojkt sigma_sign_nojkt_trim age_ele1 age_ele2 age_ele3  {
append using "$results\stats_`var'"
}
*
order name N mean sd p25 median p75
save "$results/decriptive_stats", replace
*
foreach var in ln_export ln_qty ln_uv dln_export dprior dres_fe_uv_nojkt diff shock_nojkt_trim age_ele1 age_ele2 age_ele3 sigma_nojkt sigma_sign_nojkt sigma_sign_nojkt_trim {
erase "$results\stats_`var'.dta"
}



