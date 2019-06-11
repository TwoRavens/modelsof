* This program reproduces preferred estimates of causal effects (Online Tables 1 and 2)
* The Impacts of Neighborhoods on Intergenerational Mobility II: County-Level Estimates 
* Raj Chetty and Nathaniel Hendren 

set more off

* Globals for data sets
global cz_data "${data}/online_table_3.dta"
global cty_data "${data}/online_table_4.dta"

* Causal Effects - Percentile to Percent Change in Earnings Conversion *
* Create percentile to Dollar Conversion 
set type double
global cz_pop_cutoff 25000
use "${cz_data}" if pop2000>=$cz_pop_cutoff, clear

matrix C = J(5,15,.)
local i = 1
foreach p of numlist 25 75{
	matrix C[`i',1] = `p'
	qui reg e_rank_b_kfi26_p`p' e_rank_b_kr26_p`p' [w=pop2000]
	qui su e_rank_b_kfi26_p`p' [w=pop2000]
	matrix C[`i',2] = r(mean)
	matrix C[`i',3] = 100*_b[e_rank_b_kr26_p`p']/r(mean)
	qui reg e_rank_b_kii26_p`p' e_rank_b_kir26_p`p' [w=pop2000]
	qui su e_rank_b_kii26_p`p' [w=pop2000]
	matrix C[`i',4] = r(mean)
	matrix C[`i',5] = 100*_b[e_rank_b_kir26_p`p']/r(mean)
	qui reg e_rank_b_kfi26_m_p`p' e_rank_b_kr26_m_p`p' [w=pop2000]
	qui su e_rank_b_kfi26_m_p`p' [w=pop2000]
	matrix C[`i',6] = r(mean)
	matrix C[`i',7] = 100*_b[e_rank_b_kr26_m_p`p']/r(mean)
	qui reg e_rank_b_kfi26_f_p`p' e_rank_b_kr26_f_p`p' [w=pop2000]
	qui su e_rank_b_kfi26_f_p`p' [w=pop2000]
	matrix C[`i',8] = r(mean)
	matrix C[`i',9] = 100*_b[e_rank_b_kr26_f_p`p']/r(mean)
	qui reg e_rank_b_kii26_m_p`p' e_rank_b_kir26_m_p`p' [w=pop2000]
	qui su e_rank_b_kii26_m_p`p' [w=pop2000]
	matrix C[`i',10] = r(mean)
	matrix C[`i',11] = 100*_b[e_rank_b_kir26_m_p`p']/r(mean)
	qui reg e_rank_b_kii26_f_p`p' e_rank_b_kir26_f_p`p' [w=pop2000]
	qui su e_rank_b_kii26_f_p`p' [w=pop2000]
	matrix C[`i',12] = r(mean)
	matrix C[`i',13] = 100*_b[e_rank_b_kir26_f_p`p']/r(mean)
	qui reg e_rank_b_kfi30_p`p' e_rank_b_kr30_p`p' [w=pop2000]
	qui su e_rank_b_kfi30_p`p' [w=pop2000]
	matrix C[`i',14] = r(mean)
	matrix C[`i',15] = 100*_b[e_rank_b_kr30_p`p']/r(mean)
	local i = `i' + 1
}

	svmat C
	list C* in 1/5
	keep C*
	keep if C1~=.

	rename C1 p
	rename C2 kr26_mean_inc
	rename C3 kr26_pctgain
	rename C4 kir26_mean_inc
	rename C5 kir26_pctgain
	rename C6 kr26_m_mean_inc
	rename C7 kr26_m_pctgain
	rename C8 kr26_f_mean_inc
	rename C9 kr26_f_pctgain
	rename C10 kir26_m_mean_inc
	rename C11 kir26_m_pctgain
	rename C12 kir26_f_mean_inc
	rename C13 kir26_f_pctgain
	rename C14 kr30_mean_inc
	rename C15 kr30_pctgain
	
	gen kr26_dollargain = kr26_mean_inc*kr26_pctgain*(1/100)
	gen kir26_dollargain = kir26_mean_inc*kir26_pctgain*(1/100)
	gen kr26_m_dollargain = kr26_m_mean_inc*kr26_m_pctgain*(1/100)
	gen kr26_f_dollargain = kr26_f_mean_inc*kr26_f_pctgain*(1/100)
	gen kir26_m_dollargain = kir26_m_mean_inc*kir26_m_pctgain*(1/100)
	gen kir26_f_dollargain = kir26_f_mean_inc*kir26_f_pctgain*(1/100)
	gen kr30_dollargain = kr30_mean_inc*kr30_pctgain*(1/100)
		
	tempfile conversion
	save `conversion'

	foreach outcome in kr26 kr26_m kr26_f kir26 kir26_m kir26_f kr30 {
	foreach p in 25 75  {

	* Use Conversion File
	use `conversion', clear
	
	* store Percentile Gain Conversion Factor 
	su  `outcome'_pctgain if p== `p'
	global pctgain_p`p'_`outcome' = r(mean)
	
	* Store Dollar Value Conversion Factor 
	su `outcome'_dollargain if p== `p'
	global dollargain_p`p'_`outcome' = r(mean)
	
}
}


*** Online Data Table 1 - Preferred Estimates of Causal Place Effects by Commuting Zone
global cz_pop_cutoff = 25000
global weight precwt
global var_cap = .
local pctile 25 75
foreach outcome in "kr26" "kr26_f" "kr26_m" "kir26" "kir26_f" "kir26_m" "km26"{
foreach spec in "_cc2" {
foreach p in "25" "75"  {

	use "${cz_data}", clear
	
	* Pretend to be using bootstrapped s.e.'s for gender specs
	if "`outcome'" == "kr26_f" | "`outcome'" == "kr26_m" | "`outcome'" == "kir26_f" | "`outcome'" == "kir26_m" | "`outcome'" == "km26"{
		gen Bj_p`p'_cz`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_se  
	}
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.
	
	* generate variances and precision weights 
	* pretend errors are bootstrapped (so we don't have to adjust the code)
	g Bj_var_p`p'_cz`outcome'`spec'_bs = (Bj_p`p'_cz`outcome'`spec'_bs_se)^2
	g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs
	
	* Estimate noise variances 
	qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)
	
	* stayers predictions
	reg Bj_p`p'_cz`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r
	
	* Shrunk estimates using stayers predictions 
	sum Bj_resid [w=${weight}]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	assert ${resid_sigvar}>0
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_cz`outcome'`spec'_bs)
	sum shrinkage [w=${weight}],d
	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0

	*Estimate precision of shrunk estimates
	g Bj_shrunk_rmse_`outcome'_p`p' = sqrt(1/(1/${resid_sigvar}+1/Bj_var_p`p'_cz`outcome'`spec'_bs))
	
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0&Bj_pred~=.
	replace Bj_shrunk_rmse_`outcome'_p`p' = sqrt(${resid_sigvar}) if shrinkage==0&Bj_pred~=.

	
	* Generate the causal impact in pct gain terms
	if "`outcome'" == "km26"{
	
		* Generate the causal impact in pct gain terms
		gen pct_causal_p`p'_`outcome' = Bj_shrunk_`outcome'_p`p' 

		* Generate predicted impact based on permanent residents only
		gen Bj_pred_`outcome'_`p' = Bj_pred
	}
	
	else{
		* Generate the causal impact in pct gain terms
		gen pct_causal_p`p'_`outcome' = Bj_shrunk_`outcome'_p`p' * ${pctgain_p`p'_`outcome'}

		* Generate predicted impact based on permanent residents only
		gen Bj_pred_`outcome'_`p' = Bj_pred * ${pctgain_p`p'_`outcome'}
	}
	
	
	* Keep only the variables of interest
	keep  cz czname pop2000 stateabbrv pct_causal_p`p'_`outcome' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' Bj_pred_`outcome'_`p'
	order cz czname pop2000 stateabbrv Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' pct_causal_p`p'_`outcome' Bj_pred_`outcome'_`p'
	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
	
}
}
}
	
* organize output
use "${cz_data}", clear

keep cz czname stateabbrv state_id
foreach p of local pctile {
	merge 1:1 cz using `kr26_m_cc2_p`p'', nogen 
	merge 1:1 cz using `kr26_f_cc2_p`p'', nogen 
	merge 1:1 cz using `kir26_m_cc2_p`p'', nogen 
	merge 1:1 cz using `kir26_f_cc2_p`p'', nogen 
	merge 1:1 cz using `kir26_cc2_p`p'', nogen 
	merge 1:1 cz using `km26_cc2_p`p'', nogen 
	merge 1:1 cz using `kr26_cc2_p`p'', nogen keepusing(Bj_shrunk_kr26_p`p' pct_causal_p`p'_kr26)
}

foreach p of local pctile {
	foreach outcome in "kr26" "kir26"{
		
		gen Bj_shrunk_`outcome'_p`p'_avg = 0.5*(Bj_shrunk_`outcome'_f_p`p' +  Bj_shrunk_`outcome'_m_p`p')
		gen Bj_shrunk_rmse_`outcome'_p`p'_avg = sqrt(Bj_shrunk_rmse_`outcome'_f_p`p'^2 + Bj_shrunk_rmse_`outcome'_m_p`p'^2)/2
		gen pct_causal_`outcome'_p`p'_avg = Bj_shrunk_`outcome'_p`p'_avg *${pctgain_p`p'_`outcome'}
	
}
}

	keep cz czname state_id stateabbrv pct_causal_* 
	rename pct_causal_p75_km26 pct_pt_causal_p75_km26
	rename pct_causal_p25_km26 pct_pt_causal_p25_km26
	order  cz czname state_id stateabbrv, first
	order pct_causal_p25_kr26 pct_causal_p75_kr26 pct_causal_p25_kr26_f ///
	pct_causal_p75_kr26_f pct_causal_p25_kr26_m pct_causal_p75_kr26_m ///
	pct_causal_kr26_p25_avg pct_causal_kr26_p75_avg ///
	pct_causal_p25_kir26 pct_causal_p75_kir26 pct_causal_p25_kir26_f ///
	pct_causal_p75_kir26_f pct_causal_p25_kir26_m pct_causal_p75_kir26_m ///
	pct_causal_kir26_p25_avg pct_causal_kir26_p75_avg ///
	pct_pt_causal_p25_km26 pct_pt_causal_p75_km26, last
	
	drop if mi(pct_causal_p25_kr26)
	gsort state_id cz
export excel using "${tables}/online_table_1", replace first(varlab)

*** Online Data Table 2 - Preferred Estimates of Causal Place Effects by County
macro drop cty_pop_cutoff cz_pop_cutoff  weight var_cap varlist 
global cty_pop_cutoff = 10000 
global cz_pop_cutoff = 25000
global weight precwt
global var_cap = .
local pctile 25 75
foreach outcome in "kr26" "kr26_f" "kr26_m" "kir26" "kir26_f" "kir26_m" "km26"{
foreach spec in "_cc2" {
foreach p in "25" "75"  {
	
    * use beta dataset
	use "${cty_data}", clear
	
	* merge on CTY standard errors 
	if "`outcome'" == "kr26_f" | "`outcome'" == "kr26_m" | "`outcome'" == "kir26_f" | "`outcome'" == "kir26_m" | "`outcome'" == "km26"{
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_se) nogen
	gen Bj_p`p'_cz`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_se 
	}
	else if "`outcome'" == "kr26" | "`outcome'" == "kir26"{
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_bs_se) nogen
	}

	* compute CZ plus CTY variance
	g Bj_p`p'_czct_`outcome'`spec'_bs_se = sqrt(Bj_p`p'_cty_`outcome'`spec'_se^2+(Bj_p`p'_cz`outcome'`spec'_bs_se^2))
	replace Bj_p`p'_czct_`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_bs_se if Bj_p`p'_czct_`outcome'`spec'_bs_se ==. & Bj_p`p'_cz_cty_`outcome'`spec'~=.
	rename Bj_p`p'_cz_cty_`outcome'`spec' Bj_p`p'_czct`outcome'`spec'
	
	* Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.

	* Generate variances and precision weights
	g Bj_var_p`p'_czct`outcome'`spec'_bs = Bj_p`p'_czct_`outcome'`spec'_bs_se ^2
	g precwt = 1/Bj_var_p`p'_czct`outcome'`spec'_bs
	
	* Estimate Noise Variances
	qui sum Bj_var_p`p'_czct`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)
	
	* Shrunk estimates using stayers predictions
	qui reg Bj_p`p'_czct`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r
	
	sum Bj_resid [w=${weight}]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	di $resid_sigvar
	assert ${resid_sigvar}>0
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_czct`outcome'`spec'_bs)
	sum shrinkage [w=${weight}],d
	
	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
	
	*Estimate precision of shrunk estimates
	g Bj_shrunk_rmse_`outcome'_p`p' = sqrt(1/(1/${resid_sigvar}+1/Bj_var_p`p'_czct`outcome'`spec'_bs))
	
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==.&Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0&Bj_pred~=.
	replace Bj_shrunk_rmse_`outcome'_p`p'  = sqrt(${resid_sigvar}) if shrinkage==0&Bj_pred~=.
	
	* Generate the causal impact in pct gain terms
	if "`outcome'" == "km26"{
	
		gen pct_causal_p`p'_`outcome' = Bj_shrunk_`outcome'_p`p'
		
		* Generate predicted impact based on permanent residents only
		gen Bj_pred_`outcome'_`p' = Bj_pred 
	
	}
	
	else{
		gen pct_causal_p`p'_`outcome' = Bj_shrunk_`outcome'_p`p' * ${pctgain_p`p'_`outcome'} 
	
		* Generate predicted impact based on permanent residents only
		gen Bj_pred_`outcome'_`p' = Bj_pred * ${pctgain_p`p'_`outcome'} 
	}
	
	* keep only variables of interest
	keep cty cty_pop2000 county_name stateabbrv pct_causal_p`p'_`outcome' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p'
	order cty cty_pop2000 county_name stateabbrv  Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' pct_causal_p`p'_`outcome'
	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
	
}
}
}
	
* organize output
use "${cty_data}", clear

keep cty county_name cz csa csa_name stateabbrv cz_name state_id
foreach p of local pctile {
	merge 1:1 cty using `kr26_m_cc2_p`p'', nogen 
	merge 1:1 cty using `kr26_f_cc2_p`p'', nogen 
	merge 1:1 cty using `kir26_m_cc2_p`p'', nogen 
	merge 1:1 cty using `kir26_f_cc2_p`p'', nogen 
	merge 1:1 cty using `kir26_cc2_p`p'', nogen 
	merge 1:1 cty using `km26_cc2_p`p'', nogen 
	merge 1:1 cty using `kr26_cc2_p`p'', nogen keepusing(Bj_shrunk_kr26_p`p' pct_causal_p`p'_kr26)
}

foreach p of local pctile {
	foreach outcome in "kr26" "kir26"{
		
		gen Bj_shrunk_`outcome'_p`p'_avg = 0.5*(Bj_shrunk_`outcome'_f_p`p' +  Bj_shrunk_`outcome'_m_p`p')
		gen Bj_shrunk_rmse_`outcome'_p`p'_avg = sqrt(Bj_shrunk_rmse_`outcome'_f_p`p'^2 + Bj_shrunk_rmse_`outcome'_m_p`p'^2)/2
		gen pct_causal_`outcome'_p`p'_avg = Bj_shrunk_`outcome'_p`p'_avg *${pctgain_p`p'_`outcome'}
	
}
}

	keep cty county_name cz cz_name csa csa_name stateabbrv state_id pct_causal_* 
	rename pct_causal_p75_km26 pct_pt_causal_p75_km26
	rename pct_causal_p25_km26 pct_pt_causal_p25_km26
	order cty county_name cz_name stateabbrv, first
	order pct_causal_p25_kr26 pct_causal_p75_kr26 pct_causal_p25_kr26_f ///
	pct_causal_p75_kr26_f pct_causal_p25_kr26_m pct_causal_p75_kr26_m ///
	pct_causal_kr26_p25_avg pct_causal_kr26_p75_avg ///
	pct_causal_p25_kir26 pct_causal_p75_kir26 pct_causal_p25_kir26_f ///
	pct_causal_p75_kir26_f pct_causal_p25_kir26_m pct_causal_p75_kir26_m ///
	pct_causal_kir26_p25_avg pct_causal_kir26_p75_avg ///
	pct_pt_causal_p25_km26 pct_pt_causal_p75_km26 cz csa csa_name, last
	
	drop if mi(pct_causal_p25_kr26)
	gen cty1990 = cty
	
	replace cty = 12086 if cty == 12025
	rename cty cty2000
	
	order cty1990 cty2000, first
	gsort state_id cz cty2000
	drop state_id
	export excel using "${tables}/online_table_2", replace first(varlab)
