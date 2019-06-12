/***
 This program generates raw causal estimates at the county level for all outcomes
 Inputs: raw estimates by CTY sent out of IRS
 Output: raw causal place effects at the county level
 
 	Note: the input data to this script is not publicly available.
	All variable inputs come from the output of %make_beta_js() in beta_macros_public.sas
***/

clear all 
set matsize 11000
set maxvar 32000
set more off

global db "${user}/Dropbox"
cd "$db/movers/analysis"


********************************************************************************
* OUTCOMES USED IN FINAL_CTY
********************************************************************************

* kr26: baseline 

foreach outcome in kr26  { 
foreach spec in _cc2 _cc _cc3 _am_cc2 _bm_cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2 _pbo_cc2 _pmi_cc2 { 
foreach ppp in 1 25 50 75 99{

di in red "Outcome `outcome'`spec' Parent Rank P`ppp'"

use irsdata/cty_1step_final/betaj_v7_cty_cz_`outcome'`spec', clear

* generate beta j 
gen  Bj_p`ppp'_cty_`outcome'`spec' = -(ageatmove +`ppp'/100*ageatmove_par_rank_n)
				
* generate variance
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen Bj_p`ppp'_cty_`outcome'`spec'_se = sqrt(( var_ageatmove + ((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov))

* set CTY estimates as missing if se is missing 
replace Bj_p`ppp'_cty_`outcome'`spec'=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.	
replace Bj_p`ppp'_cty_`outcome'`spec'_se=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.
	
tempfile temp`ppp'
save `temp`ppp''	
}
	
* merge percentiles
use `temp1' , clear
qui merge 1:1 cty using `temp25' , nogen
qui merge 1:1 cty using `temp50' , nogen
qui merge 1:1 cty using `temp75' , nogen
qui merge 1:1 cty using `temp99' , nogen
	
drop *ageatmove* *ageatmove_par_rank_n* cov
	
tempfile out_`outcome'`spec'
save `out_`outcome'`spec''
	
compress
save "beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'.dta", replace
}
}


* c1823: baseline 

foreach outcome in c1823  { 
foreach spec in _cc2 _f_cc2 _m_cc2 _sp_cc2 _tp_cc2  { 
foreach ppp in 1 25 50 75 99{

di in red "Outcome `outcome'`spec' Parent Rank P`ppp'"

use irsdata/cty_1step_final/betaj_v7_cty_cz_`outcome'`spec', clear

*generate beta j
gen  Bj_p`ppp'_cty_`outcome'`spec' = -(ageatmove +`ppp'/100*ageatmove_par_rank_n)
			
* generate variance
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen Bj_p`ppp'_cty_`outcome'`spec'_se = sqrt(( var_ageatmove + ((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov))
	
* set CTY estimates as missing if se is missing 
replace Bj_p`ppp'_cty_`outcome'`spec'=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.	
replace Bj_p`ppp'_cty_`outcome'`spec'_se=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.
	
tempfile temp`ppp'
save `temp`ppp''	
}
	
* merge percentiles
use `temp1' , clear
qui merge 1:1 cty using `temp25' , nogen
qui merge 1:1 cty using `temp50' , nogen
qui merge 1:1 cty using `temp75' , nogen
qui merge 1:1 cty using `temp99' , nogen
	
drop *ageatmove* *ageatmove_par_rank_n* cov
	
tempfile out_`outcome'`spec'
save `out_`outcome'`spec''
	
compress
save "beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'.dta", replace
}
}


* Other Outcomes

foreach outcome in kir26 kir26_f kir26_m km26  ///
 kfi26 kfi26_m kfi26_f kii26 kii26_f kii26_m ///
 krg26 krg26_m krg26_f kr26_coli1996 kr26_sq ///
 tlpbo_16 {
foreach spec in _cc2 {
foreach ppp in 1 25 50 75 99 {

di in red "Outcome `outcome'`spec' Parent Rank P`ppp'"

* Quadratic Spec
if  "`outcome'"=="kr26_sq"  {
	use irsdata/cty_1step_final/betaj_v7_cty_cz_`outcome'`spec', clear

	* generate beta j 
	g   Bj_p`ppp'_cty_`outcome'`spec' = -(ageatmove + (`ppp'/100) * ageatmove_par_rank_n+ (`ppp'/100)^2 * ageatmove_par_rank_n_2 )

	* generate variance
	gen var_ageatmove = se_ageatmove^2
	gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
	gen var_ageatmove_par_rank_n_2 = se_ageatmove_par_rank_n_2^2
	gen Bj_p`ppp'_cty_`outcome'`spec'_se  = sqrt(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n+((`ppp'/100)^4)*var_ageatmove_par_rank_n_2 + 2*(`ppp'/100)*cov_a_ap+2*(`ppp'/100)^2*cov_a_ap2+2*(`ppp'/100)^3*cov_ap_ap2)

	* set CTY estimates as missing if se is missing 
	replace Bj_p`ppp'_cty_`outcome'`spec'=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | se_ageatmove_par_rank_n_2==. | cov_a_ap==.	| cov_a_ap2==.	| cov_ap_ap2==.	
	replace Bj_p`ppp'_cty_`outcome'`spec'_se=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | se_ageatmove_par_rank_n_2==. | cov_a_ap==.	| cov_a_ap2==.	| cov_ap_ap2==.	
}

*Non-Quadratic Specs
else {
	use irsdata/cty_1step_final/betaj_v7_cty_cz_`outcome'`spec', clear
	gen  Bj_p`ppp'_cty_`outcome'`spec' = -(ageatmove +`ppp'/100*ageatmove_par_rank_n)
					
	* generate variance
	gen var_ageatmove = se_ageatmove^2
	gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
	gen Bj_p`ppp'_cty_`outcome'`spec'_se = sqrt(( var_ageatmove + ((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov))

	* set CTY estimates as missing if se is missing 
	replace Bj_p`ppp'_cty_`outcome'`spec'=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.	
	replace Bj_p`ppp'_cty_`outcome'`spec'_se=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.
	
}

tempfile temp`ppp'
save `temp`ppp''	
}
	
* merge percentiles
use `temp1' , clear
qui merge 1:1 cty using `temp25' , nogen
qui merge 1:1 cty using `temp50' , nogen
qui merge 1:1 cty using `temp75' , nogen
qui merge 1:1 cty using `temp99' , nogen
	
drop *ageatmove* *ageatmove_par_rank_n* cov*
	
tempfile out_`outcome'`spec'
save `out_`outcome'`spec''
	
compress
save "beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'.dta", replace
}
}
	


* Split Sample: kr26 
		
foreach outcome in kr26 { 
foreach spec in _cc2 {
foreach splitsample in _c0 _c1 {
foreach ppp in 1 25 50 75 99 {
di in red "Outcome `outcome'`spec' Parent Rank P`ppp'"

use irsdata/cty_1step_final/betaj_v7_cty_cz_`outcome'`spec', clear

* generate beta j 
gen  Bj_p`ppp'_cty_`outcome'`spec'`splitsample' = -(ageatmove +`ppp'/100*ageatmove_par_rank_n)
				
* generate variance
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen Bj_p`ppp'_cty_`outcome'`spec'`splitsample'_se = sqrt(( var_ageatmove + ((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov))

* set CTY estimates as missing if se is missing 
replace Bj_p`ppp'_cty_`outcome'`spec'`splitsample'=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.		
replace Bj_p`ppp'_cty_`outcome'`spec'`splitsample'_se=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.	
	
tempfile temp`ppp'
save `temp`ppp''	
}
	
* merge percentiles
use `temp1' , clear
qui merge 1:1 cty using `temp25' , nogen
qui merge 1:1 cty using `temp50' , nogen
qui merge 1:1 cty using `temp75' , nogen
qui merge 1:1 cty using `temp99' , nogen
	
drop *ageatmove* *ageatmove_par_rank_n* cov 
	
tempfile out_`outcome'`spec'
save `out_`outcome'`spec''
	
compress
save "beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'`splitsample'.dta", replace
}
}
}


* Split Sample: TLPBO
		
foreach outcome in tlpbo_16 kr26_16 { 
foreach spec in _cc2 {
foreach splitsample in _ss2 _ss1 {
foreach ppp in 1 25 50 75 99 {
di in red "Outcome `outcome'`spec' Parent Rank P`ppp'"

use irsdata/cty_1step_final/betaj_v7_cty_cz_`outcome'`spec'`splitsample', clear

* generate beta j 
gen  Bj_p`ppp'_cty_`outcome'`spec'`splitsample' = -(ageatmove +`ppp'/100*ageatmove_par_rank_n)
				
* generate variance
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen Bj_p`ppp'_cty_`outcome'`spec'`splitsample'_se = sqrt(( var_ageatmove + ((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov))

* set CTY estimates as missing if se is missing 
replace Bj_p`ppp'_cty_`outcome'`spec'`splitsample'=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.		
replace Bj_p`ppp'_cty_`outcome'`spec'`splitsample'_se=. if se_ageatmove==. | se_ageatmove_par_rank_n==. | cov==.	
	
tempfile temp`ppp'
save `temp`ppp''	
}
	
* merge percentiles
use `temp1' , clear
qui merge 1:1 cty using `temp25' , nogen
qui merge 1:1 cty using `temp50' , nogen
qui merge 1:1 cty using `temp75' , nogen
qui merge 1:1 cty using `temp99' , nogen
	
drop *ageatmove* *ageatmove_par_rank_n* cov 
	
tempfile out_`outcome'`spec'
save `out_`outcome'`spec''
	
compress
save "beta/beta_final/CTY/used_specs/cty_in_cz_`outcome'`spec'`splitsample'.dta", replace
}
}
}

