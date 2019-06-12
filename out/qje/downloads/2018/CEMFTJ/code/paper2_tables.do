* This program reproduces figures from the paper 
* The Impacts of Neighborhoods on Intergenerational Mobility II: County-Level Estimates 
* Raj Chetty and Nathaniel Hendren 

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

* TABLE 2 : Magnitudes of Place Effects								

clear all 
set more off
macro drop cz_pop_cutoff weight var_cap scale_factor namelist 
global cz_pop_cutoff = 25000 
global weight precwt
global var_cap = .
global scale_factor 20

global namelist Raw_Exposure_Effect_(SD) Noise_(SD) Signal_of_Exposure_Effects_(SD) ///
	SE_of_SD Signal_to_Noise_Ratio Correlation_p25_p75  ///
	Causal_Effect_(SD_of_Signal) Permanent_Residents_(SD) ///
	Sorting_Component_(SD) Corr_Sorting_Causal Corr_Permanent_Res_CZ
	
* A. Commuting Zones
	
foreach outcome in "kr26" {
foreach spec in "_cc2"{
foreach p in "25" "75" {
	
	* Define Matrix
	mat define czvar`outcome'`spec'_p`p'=J(11,1,.)
	matrix rownames czvar`outcome'`spec'_p`p'= ${namelist}
	
	* Load data
	use "${cz_data}", clear
	keep if pop2000 >= $cz_pop_cutoff
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.
 
	*Generate variances and precision weights
	g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_bs_se^2
	g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs
	
	* estimate signal and noise variances 
	qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)
	qui sum Bj_p`p'_cz`outcome'`spec' [w=${weight}],d
	global totvar = r(Var)
	global sigvar = $totvar - $noisevar_bs
	assert ${sigvar}>0
	global sigsd = sqrt($sigvar)

	*Estimates of causal and sorting effects
	g causal_raw_`p' = ${scale_factor}*Bj_p`p'_cz`outcome'`spec'
	g sorting_raw_`p' = e_rank_b_`outcome'_p`p'-causal
	
	*Variance decomposition
	qui sum e_rank_b_`outcome'_p`p'[w=${weight}]
	global stayers_var = r(Var)

	*Signal variance of causal effects
	global causal_var = (${scale_factor} * ${sigsd})^2
	
	*Covariance of causal effects and sorting
	reg causal_raw e_rank_b_`outcome'_p`p' [w=${weight}]
	global covar_causal_sorting = _b[e_rank_b_`outcome'_p`p']*${stayers_var}-${causal_var}
	global sorting_var = ${stayers_var}-${causal_var}-2*${covar_causal_sorting}
	
	*Correlation with Permanent Residents
	corr Bj_p`p'_cz`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global sig_corr = r(rho) * sqrt($totvar) / sqrt($sigvar)
	
	su precwt if pop2000>=$cz_pop_cutoff, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd = sqrt(`n_c' / (2*${sigvar})) * (1/`prec_sum')
	
	global cz_raw_sd_p`p' = sqrt(${totvar})
	global cz_noise_sd_p`p' = sqrt(${noisevar_bs})
	global cz_signal_sd_p`p' = sqrt(${sigvar})
	
	* Putting together the matrix
	mat def czvar`outcome'`spec'_p`p'[1,1] = sqrt(${totvar})
	mat def czvar`outcome'`spec'_p`p'[2,1] = sqrt(${noisevar_bs})
	mat def czvar`outcome'`spec'_p`p'[3,1] = sqrt(${sigvar})
	mat def czvar`outcome'`spec'_p`p'[4,1] = ${se_sd}	
	mat def czvar`outcome'`spec'_p`p'[5,1] = ${sigvar}/$noisevar_bs
	
	mat def czvar`outcome'`spec'_p`p'[7,1] = sqrt(${causal_var})
	mat def czvar`outcome'`spec'_p`p'[8,1] = sqrt(${stayers_var})
	mat def czvar`outcome'`spec'_p`p'[9,1] = sqrt($sorting_var)
	mat def czvar`outcome'`spec'_p`p'[10,1] = ${covar_causal_sorting}/(sqrt(${sorting_var})*sqrt(${causal_var}))	
	mat def czvar`outcome'`spec'_p`p'[11,1] = ${sig_corr}
	
	* Putting together the Correlation 

	g v25 = Bj_p25_cz`outcome'_bm`spec'_se^2 
	g prec25 = 1/v25
	g v75 = Bj_p75_cz`outcome'_am`spec'_se^2 
	g prec75 = 1/v75
	g weight = 1/(v25 + v75)

	corr Bj_p25_cz`outcome'_bm`spec' Bj_p75_cz`outcome'_am`spec' [w=weight]  , cov
	global cov = r(cov_12)

	su v25 [w=prec25]
	global noise25 = r(mean)
	su Bj_p25_cz`outcome'_bm`spec' [w=prec25]
	global totvar25 = r(Var)
	global sd25 = sqrt($totvar25 - $noise25)

	su v75 [w=prec75]
	global noise75 = r(mean)
	su Bj_p75_cz`outcome'_am`spec' [w=prec75]
	global totvar75 = r(Var)
	global sd75 = sqrt($totvar75 - $noise75)

	global corr_cz = $cov / ($sd25 * $sd75)

	* store the correlation in the czreg matrix
	mat def czvar`outcome'`spec'_p`p'[6,1] = $corr_cz
		
	* store results in the czreg matrix
	clear
	svmat2 czvar`outcome'`spec'_p`p', rnames(variables)
	gen number = [_n]
	rename czvar`outcome'`spec'_p`p'1 cz_se_`outcome'`spec'_p`p'
	order number variables 
	tempfile czvar_`outcome'`spec'_p`p'
	save `czvar_`outcome'`spec'_p`p''
}
	
	* organizing the commuting zones part:
	use `czvar_`outcome'`spec'_p25', clear
	merge 1:1 number using `czvar_`outcome'`spec'_p75', nogen
	tempfile czvar_full
	sa `czvar_full'
	
}
}	
	
* B. Counties 

clear all
macro drop cty_pop_cutoff cz_pop_cutoff var_cap weight scale_factor namelist
global cty_pop_cutoff = 10000 
global cz_pop_cutoff = 25000
global var_cap = .
global weight precwt
global scale_factor 20
	
global namelist Raw_Exposure_Effect_(SD) Noise_(SD) Signal_of_Exposure_Effects_(SD) ///
	Signal_to_Noise_Ratio Correlation_p25_p75 /// 
	Causal_Effect_(SD_of_Signal) Permanent_Residents_(SD) ///
	Sorting_Component_(SD) Corr_Sorting_Causal Correlation_p25_p75_ctywithincz Corr_Permanent_Res_CTY
	
foreach outcome in "kr26" {
foreach spec in "_cc2"{
foreach p in "25" "75" {
	
	* Define Matrix
	mat define ctyvar`outcome'`spec'_p`p'=J(11,2,.)
	matrix rownames ctyvar`outcome'`spec'_p`p'= ${namelist}
	
	* use beta dataset
	use "${cty_data}", clear
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_bs_se Bj_p*_cz`outcome'_am`spec'_se Bj_p*_cz`outcome'_bm`spec'_se)
	
	keep if cty_pop2000 >= ${cty_pop_cutoff}
	keep if cz_pop2000 >= ${cz_pop_cutoff}
	
	* compute CZ plus CTY variance
	g Bj_p`p'_czct_`outcome'`spec'_bs_se = sqrt(Bj_p`p'_cty_`outcome'`spec'_se^2+(Bj_p`p'_cz`outcome'`spec'_bs_se^2))
	replace Bj_p`p'_czct_`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_bs_se if Bj_p`p'_czct_`outcome'`spec'_bs_se ==. & Bj_p`p'_cz_cty_`outcome'`spec'~=.
	rename Bj_p`p'_cz_cty_`outcome'`spec' Bj_p`p'_czct`outcome'`spec'
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.
	
	*Generate variances and precision weights
	g Bj_var_p`p'_czct`outcome'`spec'_bs = Bj_p`p'_czct_`outcome'`spec'_bs_se ^2
	g precwt = 1/Bj_var_p`p'_czct`outcome'`spec'_bs
	
	* estimate noise variances 
	qui sum Bj_var_p`p'_czct`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)
	
	*Calculate total variance, accounting for df correction due to CZ fixed effects
	su Bj_p`p'_czct`outcome'`spec' [w=${weight}], d
	global totvar=r(Var)

	global sigvar = $totvar-$noisevar_bs
	assert ${sigvar}>0
	global sigsd = sqrt($sigvar)
	
	*Estimates of causal and sorting effects
	g causal_raw_`p' = ${scale_factor}*Bj_p`p'_czct`outcome'`spec'
	g sorting_raw_`p' = e_rank_b_`outcome'_p`p'-causal
	
	*Variance decomposition
	sum e_rank_b_`outcome'_p`p' [w=precwt]
	global stayers_var = r(Var)
	
	*Signal variance of causal effects
	global causal_var = (${scale_factor}*${sigsd})^2	
	
	*Covariance of causal effects and sorting
	reg causal_raw e_rank_b_`outcome'_p`p' [w=precwt]
	global covar_causal_sorting = _b[e_rank_b_`outcome'_p`p']*${stayers_var}-${causal_var}
	global sorting_var = ${stayers_var}-${causal_var}-2*${covar_causal_sorting}

	*Correlation with Permanent Resident
	corr Bj_p`p'_czct`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global sig_corr = r(rho) * sqrt($totvar / ${sigvar})
	
	su precwt if cz_pop2000>=$cz_pop_cutoff, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd = sqrt(`n_c' / (2*${sigvar})) * (1/`prec_sum')
	
	global cty_raw_sd_p`p' = sqrt(${totvar})
	global cty_noise_sd_p`p' = sqrt(${noisevar_bs})
	global cty_signal_sd_p`p' = sqrt(${sigvar})
	
	* Putting together the matrix
	mat def ctyvar`outcome'`spec'_p`p'[1,1] = sqrt(${totvar})
	mat def ctyvar`outcome'`spec'_p`p'[2,1] = sqrt(${noisevar_bs})
	mat def ctyvar`outcome'`spec'_p`p'[3,1] = sqrt(${sigvar})
	mat def ctyvar`outcome'`spec'_p`p'[4,1] = ${se_sd}
	mat def ctyvar`outcome'`spec'_p`p'[5,1] = ${sigvar}/${noisevar_bs}
	
	mat def ctyvar`outcome'`spec'_p`p'[7,1] = sqrt(${causal_var})
	mat def ctyvar`outcome'`spec'_p`p'[8,1] = sqrt(${stayers_var})
	mat def ctyvar`outcome'`spec'_p`p'[9,1] = sqrt($sorting_var)
	mat def ctyvar`outcome'`spec'_p`p'[10,1] = ${covar_causal_sorting}/(sqrt(${sorting_var})*sqrt(${causal_var}))	
	mat def ctyvar`outcome'`spec'_p`p'[11,1] = ${sig_corr}
	
	
	* Putting together the Correlation 
	g v25 = Bj_p25_cz`outcome'_bm`spec'_se^2 + Bj_p25_cty_`outcome'_bm`spec'_se^2 
	g prec25 = 1/v25
	g v75 = Bj_p75_cz`outcome'_am`spec'_se^2 + Bj_p75_cty_`outcome'_am`spec'_se^2 
	g prec75 = 1/v75
	g weight = 1/(v25 + v75)
	
	corr Bj_p25_cz_cty_`outcome'_bm`spec' Bj_p75_cz_cty_`outcome'_am`spec' [w=weight]  , cov
	global cov = r(cov_12)
	
	su v25 [w=prec25] 
	global noise25 = r(mean)
	su Bj_p25_cz_cty_`outcome'_bm`spec' [w=prec25]
	global totvar25 = r(Var)
	global sd25 = sqrt($totvar25 - $noise25)

	su v75 [w=prec75] 
	global noise75 = r(mean)
	su Bj_p75_cz_cty_`outcome'_am`spec' [w=prec75] 
	global totvar75 = r(Var)
	global sd75 = sqrt($totvar75 - $noise75)

	global corr_cty = $cov / ($sd25 * $sd75)


	* Store the correlation in the ctyreg matrix
	mat def ctyvar`outcome'`spec'_p`p'[6,1] = ${corr_cty}
	
	* C. Counties within CZ 
	
	global ctycz_raw_sd_p`p' = sqrt(${cty_raw_sd_p`p'}^2-${cz_raw_sd_p`p'}^2)
	global ctycz_noise_sd_p`p' = sqrt(${cty_noise_sd_p`p'}^2-${cz_noise_sd_p`p'}^2)
	global ctycz_signal_sd_p`p' = sqrt(${cty_signal_sd_p`p'}^2-${cz_signal_sd_p`p'}^2)
	
	local sigvar = (${ctycz_signal_sd_p`p'})^2
	g prec = 1/(Bj_p`p'_cty_`outcome'`spec'_se^2)
	sum prec, d
	local prec_sum = r(sum)
	qui sum Bj_p`p'_cty_`outcome'`spec'_se, d
	local cty_n = r(N)

	preserve 
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff} 
	qui sum Bj_p`p'_cz`outcome'`spec'_bs_se, d
	local cz_n = r(N)
	restore
	
	local n_c = `cty_n' - `cz_n'
	global se_sd_p`p' = sqrt(`n_c' / (2*`sigvar')) * (1/`prec_sum')
	
	mat def ctyvar`outcome'`spec'_p`p'[1,2] = ${ctycz_raw_sd_p`p'}
	mat def ctyvar`outcome'`spec'_p`p'[2,2] = ${ctycz_noise_sd_p`p'}
	mat def ctyvar`outcome'`spec'_p`p'[3,2] = ${ctycz_signal_sd_p`p'}
	mat def ctyvar`outcome'`spec'_p`p'[4,2] = ${se_sd_p`p'}
	
	* Step 1: Compute covariance
	g weight_ctywincz = 1/(Bj_p25_cty_`outcome'_bm`spec'_se^2 + Bj_p75_cty_`outcome'_am`spec'_se^2 )
	areg Bj_p25_cz_cty_`outcome'_bm`spec' Bj_p75_cz_cty_`outcome'_am`spec' [w=weight_ctywincz]  , a(cz)
	global b_2575 = _b[Bj_p75_cz_cty_`outcome'_am`spec']
	areg Bj_p75_cz_cty_`outcome'_am`spec' [w=weight_ctywincz] , a(cz)
	global sd_raw_75_2weight = e(rmse)
	global cov_2575 = $sd_raw_75_2weight * $b_2575

	* Compute Signal SDs
	g v25_cty_win_cz = Bj_p25_cty_`outcome'_bm`spec'_se^2
	g v75_cty_win_cz = Bj_p75_cty_`outcome'_am`spec'_se^2
	areg Bj_p25_cz_cty_`outcome'_bm`spec' [w=1/v25_cty_win_cz] , a(cz)
	global sd_raw_25 = e(rmse)
	areg Bj_p75_cz_cty_`outcome'_am`spec' [w=1/v75_cty_win_cz] , a(cz)
	global sd_raw_75 = e(rmse)
	su v25_cty_win_cz [w=1/v25_cty_win_cz]
	global sd_noise_25 = r(mean)
	su v75_cty_win_cz [w=1/v75_cty_win_cz]
	global sd_noise_75 = r(mean)
	global sd_sig_25 = sqrt($sd_raw_25^2 - $sd_noise_25^2)
	global sd_sig_75 = sqrt($sd_raw_75^2 - $sd_noise_75^2)
	
	* Calculate implied correlation
	global corr_cty_win_cz = $cov_2575 / ($sd_sig_25 * $sd_sig_75)
	
	* Store the correlation in the ctyreg matrix
	mat def ctyvar`outcome'`spec'_p`p'[6,2] = $corr_cty_win_cz
		
	use "${cty_data}", clear
	*Generate variances and precision weights
	g Bj_var_p`p'_cty_`outcome'`spec'_se = Bj_p`p'_cty_`outcome'`spec'_se ^2
	g precwt = 1/Bj_var_p`p'_cty_`outcome'`spec'_se
	
	*Correlation with Permanent Residents
	* Generate total variance of betas	
	areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
	global totsd = e(rmse)
	areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
	predict Bj_czres, r
	areg e_rank_b_`outcome'_p`p' [w=${weight}], a(cz)
	predict erankb_czres, r
	corr erankb_czres Bj_czres [w=${weight}] 
	local corr_raw = r(rho) 
	global sig_corr = (`corr_raw') * ($totsd) / ${ctycz_signal_sd_p`p'}
	mat def ctyvar`outcome'`spec'_p`p'[11,2] = $sig_corr
	
	* store results in the ctyreg matrix
	clear
	svmat2 ctyvar`outcome'`spec'_p`p', rnames(variables)
	gen number = [_n]
	rename ctyvar`outcome'`spec'_p`p'1 cty_se_`outcome'`spec'_p`p'
	order number variables 
	tempfile ctyvar_`outcome'`spec'_p`p'
	save `ctyvar_`outcome'`spec'_p`p''
}
	
	* organizing the county part:
	use `ctyvar_`outcome'`spec'_p25', clear
	merge 1:1 number using `ctyvar_`outcome'`spec'_p75', nogen
	tempfile ctyvar_full
	sa `ctyvar_full'
	
}
}
	
* merge together table
use `czvar_full'
merge 1:1 number using `ctyvar_full', nogen
drop number
	
order ctyvarkr26_cc2_p252 ctyvarkr26_cc2_p752, last
	
rename (cz_se_kr26_cc2_p25 cz_se_kr26_cc2_p75 cty_se_kr26_cc2_p25 cty_se_kr26_cc2_p75 ///
		 ctyvarkr26_cc2_p252 ctyvarkr26_cc2_p752) ///
		(CZ_p25 CZ_p75 CTY_p25 CTY_p75 CZCTY_p25 CZCTY_p75)
	
export delimited using "${tables}/table2_raw", replace  

** TABLES 3-4 AND APPENDIX TABLES 3-10
** MSE-Minimizing Forecasts of Causal Effects
** By 50 largest CZs and 100 largest counties (by population)
** By Household income, family income
** BY gender, rates of marriage

** CZ level tables 
local outcome = "kr26"
local spec = "_cc2"
local pctile 25 75
	
** Table 3: MSE-Minimizing Forecasts of Causal Effects for 50 Largest Commuting Zones													
macro drop cz_pop_cutoff  weight var_cap varlist 
global cz_pop_cutoff = 25000 
global weight precwt
global var_cap = .
local pctile 25 75
	
foreach outcome in "kr26" {
foreach spec in "_cc2" {
foreach p of local pctile {
	
	* use beta dataset
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff}
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.
	
	* generate variances and precision weights 
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
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * ${pctgain_p`p'_`outcome'} * 20

	* Generate predicted impact based on permanent residents only
	gen Bj_pred_`outcome'_p`p' = Bj_pred * ${pctgain_p`p'_`outcome'} * 20

	rename shrinkage shrinkage_p`p'

	* Keep only the variables of interest
	keep  cz czname pop2000 stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' Bj_pred_`outcome'_p`p' shrinkage_p`p'
	order cz czname pop2000 stateabbrv Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p' Bj_pred_`outcome'_p`p' shrinkage_p`p'
	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
}
}
}
	
* organize output
use "${cz_data}", clear
keep if pop2000 >= ${cz_pop_cutoff}
keep cz
foreach p of local pctile {
		merge 1:1 cz using `kr26_cc2_p`p'', nogen
}

gsort -pop2000
keep in 1/50
	
drop pop2000 cz shrinkage*
gsort -Bj_shrunk_kr26_p25
order czname stateabbrv
export delimited "${tables}/table3_raw", replace  	

	
*** Appendix Table 3: MSE-Minimizing Forecasts of Causal Effects for 50 Largest Commuting Zones, Individual Income													
macro drop cz_pop_cutoff  weight var_cap varlist 
global cz_pop_cutoff = 25000 
global weight precwt
global var_cap = .
local pctile 25 75
	
foreach outcome in "kr26" "kir26" {
foreach spec in "_cc2" {
foreach p of local pctile {
	
	* use beta dataset
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff}
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.
	
	* generate variances and precision weights 
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
	di $resid_sigvar
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
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * ${pctgain_p`p'_`outcome'} * 20

	* Generate predicted impact based on permanent residents only
	gen Bj_pred_`outcome'_`p' = Bj_pred * ${pctgain_p`p'_`outcome'} * 20
	
	* Keep only the variables of interest
	keep  cz czname pop2000 stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' Bj_pred_`outcome'_`p'
	order cz czname pop2000 stateabbrv Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p' Bj_pred_`outcome'_`p'
	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
}
}
}
	
* organize output
use "${cz_data}", clear
keep if pop2000 >= ${cz_pop_cutoff}
keep cz
foreach outcome in "kr26" "kir26" {
	foreach p of local pctile {
		merge 1:1 cz using ``outcome'_cc2_p`p'', nogen
	}
}

drop *_kr26_*	
	
gsort -pop2000
keep in 1/50
drop pop2000 cz
gsort -Bj_shrunk_kir26_p25
order czname stateabbrv

export delimited "${tables}/app_tab_3_raw", replace  

** Appendix Table 7: MSE-Minimizing Forecasts of Causal Effects for 50 Largest Commuting Zones Broken Down by Gender																					
											
macro drop cz_pop_cutoff  weight var_cap varlist 
global cz_pop_cutoff = 25000 
	global weight precwt
	global var_cap = .
	local pctile 25 75
	
	foreach outcome in "kr26" "kr26_f" "kr26_m" {
	foreach spec in "_cc2" {
	foreach p of local pctile {
	
	* use beta dataset
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff}
	
	* Pretend to be using bootstrapped s.e.'s for gender specs
	if "`outcome'" == "kr26_f" | "`outcome'" == "kr26_m"  {
	gen Bj_p`p'_cz`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_se  
	}
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.
	
	* generate variances and precision weights 
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
	di $resid_sigvar
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
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * ${pctgain_p`p'_`outcome'} * 20

	* Generate predicted impact based on permanent residents only
	gen Bj_pred_`outcome'_`p' = Bj_pred * ${pctgain_p`p'_`outcome'} * 20
	
	* Keep only the variables of interest
	keep  cz czname pop2000 stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p'
	order cz czname pop2000 stateabbrv Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p'
	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
	}
	}
	}
	
	* organize output
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff}
	keep cz
	foreach p of local pctile {
		merge 1:1 cz using `kr26_m_cc2_p`p'', nogen
		merge 1:1 cz using `kr26_f_cc2_p`p'', nogen 
		merge 1:1 cz using `kr26_cc2_p`p'', nogen keepusing(Bj_shrunk_kr26_p`p')
	}

	gsort -pop2000
	keep in 1/50
	drop pop2000 cz
	gsort -Bj_shrunk_kr26_p25
	drop Bj_shrunk_kr26_p*
	order czname stateabbrv

	export delimited "${tables}/app_tab_7_raw", replace  

** Appendix Table 9: MSE-Minimizing Forecasts of Causal Effects for 50 Largest Commuting Zones Broken Down by Gender, Individual Income																					
																				
macro drop cz_pop_cutoff  weight var_cap varlist 
global cz_pop_cutoff = 25000 
global weight precwt
global var_cap = .
local pctile 25 75
	
foreach outcome in "kir26" "kir26_f" "kir26_m" {
foreach spec in "_cc2" {
foreach p of local pctile {
	
	* use beta dataset
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff}

	* Pretend to be using bootstrapped s.e.'s for gender specs
	if "`outcome'" == "kir26_f" | "`outcome'" == "kir26_m" {
		gen Bj_p`p'_cz`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_se  
	}
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.
	
	* generate variances and precision weights 
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
	di $resid_sigvar
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
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * ${pctgain_p`p'_`outcome'} * 20

	* Generate predicted impact based on permanent residents only
	gen Bj_pred_`outcome'_`p' = Bj_pred * ${pctgain_p`p'_`outcome'} * 20
	
	* Keep only the variables of interest
	keep  cz czname pop2000 stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p'
	order cz czname pop2000 stateabbrv Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p'
	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
}
}
}
	
* organize output
use "${cz_data}", clear
keep if pop2000 >= ${cz_pop_cutoff}
keep cz
foreach p of local pctile {
		merge 1:1 cz using `kir26_m_cc2_p`p'', nogen
		merge 1:1 cz using `kir26_f_cc2_p`p'', nogen 
		merge 1:1 cz using `kir26_cc2_p`p'', nogen keepusing(Bj_shrunk_kir26_p`p')
}

gsort -pop2000
keep in 1/50
drop pop2000 cz
gsort -Bj_shrunk_kir26_p25
drop Bj_shrunk_kir26_p*
order czname stateabbrv

export delimited "${tables}/app_tab_9_raw", replace  

*** Appendix Table 5: MSE-Minimizing Forecasts of Causal Effects for 50 Largest Commuting Zones, Rates of Marriage Before Age 26													
																					
macro drop cz_pop_cutoff  weight var_cap varlist 
global cz_pop_cutoff = 25000 
global weight precwt
global var_cap = .
local pctile 25 75
	
foreach outcome in "km26" {
foreach spec in "_cc2" {
foreach p of local pctile {
	
	* use beta dataset
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff}
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.
	
	* generate variances and precision weights 
	* pretend errors are bootstrapped (so we don't have to adjust the code)
	g Bj_var_p`p'_cz`outcome'`spec'_bs = (Bj_p`p'_cz`outcome'`spec'_se)^2
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
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20

	* Generate predicted impact based on permanent residents only
	gen Bj_pred_`outcome'_`p' = Bj_pred * 20
	
	* Keep only the variables of interest
	keep  cz czname pop2000 stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' Bj_pred_`outcome'_`p'
	order cz czname pop2000 stateabbrv Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p' Bj_pred_`outcome'_`p'
	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
}
}
}
	
* organize output
use "${cz_data}", clear
keep if pop2000 >= ${cz_pop_cutoff}

keep cz
foreach p of local pctile {
	merge 1:1 cz using `km26_cc2_p`p'', nogen
}
	
gsort -pop2000
keep in 1/50
drop pop2000 cz
gsort -Bj_shrunk_km26_p25
order czname stateabbrv

export delimited "${tables}/app_tab_5_raw", replace  

** County level tables 
		
** Table 4: MSE-Minimizing Forecasts of Causal Effects for 100 Largest Counties (Top and Bottom 25)													
foreach p in "25" "75" {
foreach outcome in "kr26" {
foreach spec in "_cc2" {
	use "${cty_data}", clear
	keep if cty_pop2000 >= ${cty_pop_cutoff}
	keep if cz_pop2000 >= ${cz_pop_cutoff}
	
	keep if e_rank_b_`outcome'_p`p'~=.
	
	g Bj_var_p`p'_cz_cty_`outcome'`spec'_bs = Bj_p`p'_cz_cty_`outcome'`spec'_bs_se^2
	g precwt = 1/Bj_var_p`p'_cz_cty_`outcome'`spec'
		
	* estimate signal and noise variances 
	qui sum Bj_var_p`p'_cz_cty_`outcome'`spec' [w=precwt]
	global noisevar_bs = r(mean)
	
	* stayers predictions
	qui reg Bj_p`p'_cz_cty_`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']

	predict Bj_pred, xb
	predict Bj_resid, r
	
	g Bj_residsigvar = Bj_resid^2 - Bj_p`p'_cz_cty_`outcome'`spec'_se^2
	reg Bj_residsigvar Bj_p`p'_cz_cty_`outcome'`spec'_se [w=${weight}]
	
	*Shrunk estimates using stayers predictions
	sum Bj_resid [w=${weight}]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	
	assert ${resid_sigvar}>0
	
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_cz_cty_`outcome'`spec')
	sum shrinkage [w=${weight}], d
	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
	
	*Estimate precision of shrunk estimates
	g Bj_shrunk_rmse_`outcome'_p`p' = sqrt(1/(1/${resid_sigvar}+1/Bj_var_p`p'_cz_cty_`outcome'`spec'))
	
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
	replace Bj_shrunk_rmse_`outcome'_p`p' = sqrt(${resid_sigvar}) if shrinkage==0&Bj_pred~=.

	gsort -cty_pop2000
	
	rename Bj_pred Bj_pred_p`p'
	
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20 * ${pctgain_p`p'_`outcome'}
	gen Bj_pred_`outcome'_`p' = Bj_pred * 20 * ${pctgain_p`p'_`outcome'}
	
	keep  cty county_name cty_pop2000 stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' Bj_pred_`outcome'_`p'
	order cty county_name cty_pop2000 stateabbrv Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p' Bj_pred_`outcome'_`p'
	
	tempfile temp`p'
	save `temp`p'', replace
}
}
}

use `temp25', clear
merge 1:1 cty using `temp75', nogen

gsort -cty_pop
keep if _n<=100

gsort -Bj_shrunk_kr26_p75
if _n==1 local top = county_name 
sum Bj_shrunk_kr26_p75 if _n==1
  
gsort Bj_shrunk_kr26_p75
if _n==1 local bottom = county_name 
sum Bj_shrunk_kr26_p75 if _n==1

gsort -Bj_shrunk_kr26_p25
drop if _n>25 & _n<75
drop cty cty_pop
export delimited "${tables}/table4_raw", replace  

*** Appendix Table 4: MSE-Minimizing Forecasts of Causal Effects for 100 Largest Counties (Top and Bottom 25), Individual Income													

macro drop cty_pop_cutoff cz_pop_cutoff weight var_cap scale_factor
global cty_pop_cutoff = 10000 
global cz_pop_cutoff = 25000
global weight precwt
global var_cap = .
global scale_factor 20

foreach outcome in "kir26"   {
foreach spec in "_cc2" {
foreach p in "25" "75" {
	
    * use beta dataset
	use "${cty_data}", clear
	
	* merge on CTY standard errors 
	
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_bs_se) nogen
	keep if cty_pop2000 >= ${cty_pop_cutoff}
	keep if cz_pop2000 >= ${cz_pop_cutoff}

	* compute CZ plus CTY variance
	g Bj_p`p'_czct_`outcome'`spec'_bs_se = sqrt(Bj_p`p'_cty_`outcome'`spec'_se^2+(Bj_p`p'_cz`outcome'`spec'_bs_se^2))
	replace Bj_p`p'_czct_`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_bs_se if Bj_p`p'_czct_`outcome'`spec'_bs_se ==. & Bj_p`p'_cz_cty_`outcome'`spec'~=.
	rename Bj_p`p'_cz_cty_`outcome'`spec' Bj_p`p'_czct`outcome'`spec'
	
	* Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.

	* Generate variances and precision weights
	g Bj_var_p`p'_czct`outcome'`spec'_bs = Bj_p`p'_czct_`outcome'`spec'_bs_se ^2
	g precwt = 1/Bj_var_p`p'_czct`outcome'`spec'_bs
	
	* Estimate Signal and Noise Variances
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
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * ${pctgain_p`p'_`outcome'} * 20

	* Generate predicted impact based on permanent residents only
	gen Bj_pred_`outcome'_`p' = Bj_pred * ${pctgain_p`p'_`outcome'} * 20
	
	* Keep only the variables of interest
	keep  cty county_name cty_pop2000 stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' Bj_pred_`outcome'_`p'
	order cty county_name cty_pop2000 stateabbrv Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p' Bj_pred_`outcome'_`p'

	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
	
}
}
}
		
* organize output
use "${cty_data}", clear	
keep if cty_pop2000 >= ${cty_pop_cutoff}
keep if cz_pop2000 >= ${cz_pop_cutoff}


keep cty
foreach p of local pctile {
	merge 1:1 cty using `kir26_cc2_p`p'', nogen 
}
	
gsort -cty_pop2000
g pop_rank = _n
keep if pop_rank<=100
gsort -Bj_shrunk_kir26_p25
gen effect_rank = _n
keep if effect_rank <= 25 | effect_rank >= 75
drop cty cty_pop2000
drop pop_rank effect_rank
	
export delimited "${tables}/app_tab_4_raw", replace  

** Appendix Table 8: FMSE-Minimizing Forecasts of Causal Effects for 100 Largest Counties (Top and Bottom 25) Broken Down By Gender																					

macro drop cty_pop_cutoff cz_pop_cutoff  weight var_cap varlist 
global cty_pop_cutoff = 10000 
global cz_pop_cutoff = 25000
global weight precwt
global var_cap = .

foreach outcome in "kr26" "kr26_f" "kr26_m"  {
foreach spec in "_cc2" {
foreach p in "25" "75"  {
	
    * use beta dataset
	use "${cty_data}", clear
	
	* merge on CTY standard errors 
	if "`outcome'" == "kr26_f" | "`outcome'" == "kr26_m" {
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_se) nogen
	gen Bj_p`p'_cz`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_se 
	}
	else if "`outcome'" == "kr26" {
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_bs_se) nogen
	}

	keep if cty_pop2000 >= ${cty_pop_cutoff}
	keep if cz_pop2000 >= ${cz_pop_cutoff}

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
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * ${pctgain_p`p'_`outcome'} * 20

	* Generate predicted impact based on permanent residents only
	gen Bj_pred_`outcome'_`p' = Bj_pred * ${pctgain_p`p'_`outcome'} * 20
	
	* keep only variables of interest
	keep cty cty_pop2000 county_name stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p'
	order cty cty_pop2000 county_name stateabbrv  Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p'
	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace	
	
}
}
}
	
	
* organize output
use "${cty_data}", clear
keep if cty_pop2000 >= ${cty_pop_cutoff}
keep if cz_pop2000 >= ${cz_pop_cutoff}

keep cty
foreach p of local pctile {
	merge 1:1 cty using `kr26_m_cc2_p`p'', nogen 
	merge 1:1 cty using `kr26_f_cc2_p`p'', nogen 
	merge 1:1 cty using `kr26_cc2_p`p'', nogen keepusing(Bj_shrunk_kr26_p`p')
}
	
gsort -cty_pop2000
g pop_rank = _n
keep if pop_rank<=100
gsort -Bj_shrunk_kr26_p25
gen effect_rank = _n
keep if effect_rank <= 25 | effect_rank >= 75
drop cty cty_pop2000 Bj_shrunk_kr26_p*
drop pop_rank effect_rank
	
export delimited "${tables}/app_tab_8_raw", replace  

** Appendix Table 10: MSE-Minimizing Forecasts of Causal Effects for 100 Largest Counties (Top and Bottom 25) Broken Down by Gender, Individual Income																					

macro drop cty_pop_cutoff cz_pop_cutoff  weight var_cap varlist 
global cty_pop_cutoff = 10000 
global cz_pop_cutoff = 25000
global weight precwt
global var_cap = .

foreach outcome in "kir26" "kir26_f" "kir26_m"  {
foreach spec in "_cc2" {
foreach p in "25" "75"  {
	
    * use beta dataset
	use "${cty_data}", clear
	
	if "`outcome'" == "kir26_f" | "`outcome'" == "kir26_m" {
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_se) nogen
	gen Bj_p`p'_cz`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_se 
	}
	else if "`outcome'" == "kir26" {
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_bs_se) nogen
	}

	keep if cty_pop2000 >= ${cty_pop_cutoff}
	keep if cz_pop2000 >= ${cz_pop_cutoff}

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
	qui sum Bj_var_p`p'_czct`outcome'`spec'_bs [w=precwt]
	global noisevar_bs = r(mean)
	
	* Shrunk estimates using stayers predictions
	qui reg Bj_p`p'_czct`outcome'`spec' e_rank_b_`outcome'_p`p' [w=precwt]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r
	
	sum Bj_resid [w=precwt]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	di $resid_sigvar
	assert ${resid_sigvar}>0
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_czct`outcome'`spec'_bs)
	sum shrinkage [w=precwt],d
	
	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
	
	*Estimate precision of shrunk estimates
	g Bj_shrunk_rmse_`outcome'_p`p' = sqrt(1/(1/${resid_sigvar}+1/Bj_var_p`p'_czct`outcome'`spec'_bs))
	
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==.&Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0&Bj_pred~=.
	replace Bj_shrunk_rmse_`outcome'_p`p'  = sqrt(${resid_sigvar}) if shrinkage==0&Bj_pred~=.
	
	* Generate the causal impact in pct gain terms
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * ${pctgain_p`p'_`outcome'} * 20

	* Generate predicted impact based on permanent residents only
	gen Bj_pred_`outcome'_`p' = Bj_pred * ${pctgain_p`p'_`outcome'} * 20
	
	* keep only variables of interest
	keep cty cty_pop2000 county_name stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' 
	order cty cty_pop2000 county_name stateabbrv  Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p'
	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
	
}
}
}
	
	
* organize output
use "${cty_data}", clear
keep if cty_pop2000 >= ${cty_pop_cutoff}
keep if cz_pop2000 >= ${cz_pop_cutoff}

keep cty
foreach p of local pctile {
	merge 1:1 cty using `kir26_m_cc2_p`p'', nogen 
	merge 1:1 cty using `kir26_f_cc2_p`p'', nogen 
	merge 1:1 cty using `kir26_cc2_p`p'', nogen keepusing(Bj_shrunk_kir26_p`p')
}
	
gsort -cty_pop2000
g pop_rank = _n
keep if pop_rank<=100
	
gsort -Bj_shrunk_kir26_p25
gen effect_rank = _n
keep if effect_rank <= 25 | effect_rank >= 75
drop cty cty_pop2000 Bj_shrunk_kir26_p*
drop pop_rank effect_rank
	
export delimited "${tables}/app_tab_10_raw", replace  

*** Appendix Table 6: MSE-Minimizing Forecasts of Causal Effects for 100 Largest Counties (Top and Bottom 25), Rates of Marriage Before Age 26													

macro drop cty_pop_cutoff cz_pop_cutoff weight var_cap scale_factor
global cty_pop_cutoff = 10000 
global cz_pop_cutoff = 25000
global weight precwt
global var_cap = .
global scale_factor 20

foreach outcome in "km26"   {
foreach spec in "_cc2" {
foreach p in "25" "75" {
	
    * use beta dataset
	use "${cty_data}", clear
	keep if cty_pop2000 >= ${cty_pop_cutoff}
	keep if cz_pop2000 >= ${cz_pop_cutoff}
		
	rename Bj_p`p'_cz_cty_`outcome'`spec' Bj_p`p'_czct`outcome'`spec'
	
	* Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.

	* Generate variances and precision weights
	g Bj_var_p`p'_czct`outcome'`spec' = Bj_p`p'_cz_cty_`outcome'`spec'_se ^2
	g precwt = 1/Bj_var_p`p'_czct`outcome'`spec'
	
	* Estimate Signal and Noise Variances
	qui sum Bj_var_p`p'_czct`outcome'`spec' [w=precwt]
	global noisevar_bs = r(mean)
	
	* Shrunk estimates using stayers predictions
	qui reg Bj_p`p'_czct`outcome'`spec' e_rank_b_`outcome'_p`p' [w=precwt]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r
	
	sum Bj_resid [w=precwt]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	di $resid_sigvar
	assert ${resid_sigvar}>0
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_czct`outcome'`spec')
	sum shrinkage [w=precwt],d
	
	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0

	*Estimate precision of shrunk estimates
	g Bj_shrunk_rmse_`outcome'_p`p' = sqrt(1/(1/${resid_sigvar}+1/Bj_var_p`p'_czct`outcome'`spec'))
	
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==.&Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0&Bj_pred~=.
	replace Bj_shrunk_rmse_`outcome'_p`p'  = sqrt(${resid_sigvar}) if shrinkage==0&Bj_pred~=.

	* Generate the causal impact in pct gain terms
	gen percentage_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20

	* Generate predicted impact based on permanent residents only
	gen Bj_pred_`outcome'_`p' = Bj_pred * 20
	
	* Keep only the variables of interest
	keep  cty county_name cty_pop2000 stateabbrv percentage_effect_`outcome'_p`p' Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' Bj_pred_`outcome'_`p'
	order cty county_name cty_pop2000 stateabbrv Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' percentage_effect_`outcome'_p`p' Bj_pred_`outcome'_`p'

	tempfile `outcome'`spec'_p`p'
	sa ``outcome'`spec'_p`p'', replace
	
}
}
}
		
* organize output
use "${cty_data}", clear
keep if cty_pop2000 >= ${cty_pop_cutoff}
keep if cz_pop2000 >= ${cz_pop_cutoff}

keep cty
foreach p in "25" "75" {
	merge 1:1 cty using `km26_cc2_p`p'', nogen 
}
	
gsort -cty_pop2000
g pop_rank = _n
keep if pop_rank<=100
gsort -Bj_shrunk_km26_p25
gen effect_rank = _n
keep if effect_rank <= 25 | effect_rank >= 75
drop cty cty_pop2000
drop pop_rank effect_rank
	
export delimited "${tables}/app_tab_6_raw", replace  


*** Appendix Table 1 and 2
* Exposure Effect Estimates: Sensitivity to Alternative Specifications							
* Magnitude of Place Effects: Heterogeneity by Gender and Family vs. Individual Income									
clear all

* population restrictions
global poptop 25000

*** 1) Baseline Outcome: kr26
foreach outcome in kr26 {
foreach spec in "_cc2" "_sq_cc2" "_cc1" "_cc3" "_coli_cc2" "_pmi_cc2" "_m_cc2" "_f_cc2"{
foreach ppp in "25" "75"{

	* Load data
	use "${cz_data}", clear
	keep if pop2000 >= ${poptop}

	if "`spec'" == "_coli_cc2" {
		rename *coli1996* *coli*
	}

	if "`spec'" == "_cc1" {
		rename Bj_p`ppp'_czkr26_cc Bj_p`ppp'_czkr26_cc1
		rename Bj_p`ppp'_czkr26_cc_se Bj_p`ppp'_czkr26_cc1_se
	}

	* Restrict to places with non-missing perm res outcomes
	keep if e_rank_b_`outcome'_p`ppp'~=.
	drop if Bj_p`ppp'_cz`outcome'`spec' == . | Bj_p`ppp'_cz`outcome'`spec'_se == .

	if "`spec'" == "_cc2" {
		drop if Bj_p`ppp'_cz`outcome'`spec'_bs_se == .
	}

	if "_cc2" != "`spec'" {
		g Bj_p`ppp'_cz`outcome'`spec'_bs_se = Bj_p`ppp'_cz`outcome'`spec'_se
	}

	* Calculate precision weights for regression
	g precwt_reg = 1/ (Bj_p`ppp'_cz`outcome'`spec'_bs_se^2 + Bj_p`ppp'_czkr26_cc2_bs_se^2)

	su Bj_p`ppp'_czkr26_cc2 [w=precwt_reg] if pop2000>=$poptop , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz`outcome'`spec' [w=precwt_reg] if pop2000>=$poptop , d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates to get correlation and SEs
	reg Bj_p`ppp'_cz`outcome'`spec' Bj_p`ppp'_czkr26_cc2 [w=precwt_reg] if pop2000>=$poptop
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz`outcome'`spec'_bs_se^2

	* Calculate Total Variance (=noise+signal)
	su Bj_p`ppp'_cz`outcome'`spec' [w=precwt]  if pop2000>= $poptop, d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz`outcome'`spec'_bs_se2 =Bj_p`ppp'_cz`outcome'`spec'_bs_se^2
	su Bj_p`ppp'_cz`outcome'`spec'_bs_se2 [w=precwt] if pop2000>= $poptop, d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}

	* Calculate SDs
	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if pop2000>= $poptop, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')
}
}
}

*** 2) Alternative Outcomes: kir26
foreach outcome in kir26 {
foreach spec in "_cc2" "_m_cc2" "_f_cc2" {
foreach ppp in "25" "75" {

	* Load data
	use "${cz_data}", clear
	keep if pop2000 >= ${poptop}

	* Restrict to places with non-missing perm res outcomes
	keep if e_rank_b_`outcome'_p`ppp'~=.
	drop if Bj_p`ppp'_cz`outcome'`spec' == . | Bj_p`ppp'_cz`outcome'`spec'_se == .

	* For alternative specifications, _bs_se = _se
	if "`spec'" == "_cc2"{
	replace Bj_p`ppp'_cz`outcome'`spec'_bs_se = Bj_p`ppp'_cz`outcome'`spec'_se
	}

	if "`spec'" != "_cc2"{
	g Bj_p`ppp'_cz`outcome'`spec'_bs_se = Bj_p`ppp'_cz`outcome'`spec'_se
	}

	* Calculate precision weights for regression 
	g precwt_reg = 1/ (Bj_p`ppp'_cz`outcome'`spec'_bs_se^2 + Bj_p`ppp'_czkr26_cc2_bs_se^2)

	su Bj_p`ppp'_czkr26_cc2 [w=precwt_reg] if pop2000>=$poptop , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz`outcome'`spec' [w=precwt_reg] if pop2000>=$poptop , d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates to get coeff SEs
	reg Bj_p`ppp'_cz`outcome'`spec' Bj_p`ppp'_czkr26_cc2 [w=precwt_reg] if pop2000>=$poptop
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz`outcome'`spec'_bs_se^2

	* Calculate Total Variance (=noise+signal)
	su Bj_p`ppp'_cz`outcome'`spec' [w=precwt]  if pop2000>= $poptop, d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz`outcome'`spec'_bs_se2 =Bj_p`ppp'_cz`outcome'`spec'_bs_se^2
	su Bj_p`ppp'_cz`outcome'`spec'_bs_se2 [w=precwt] if pop2000>= $poptop, d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}

	* Calculate SDs
	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if pop2000>= $poptop, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')
}
}
}

*** 3) Alternative Outcomes: kid family income and individual income ($ not rank)
foreach outcome in kfi26 kii26 km26{
foreach spec in "_cc2" {
foreach ppp in "25" "75" {

	* Load data
	use "${cz_data}", clear
	keep if pop2000 >= ${poptop}

	* Restrict to places with non-missing perm res outcomes
	keep if e_rank_b_`outcome'_p`ppp'~=.
	drop if Bj_p`ppp'_cz`outcome'`spec' == . | Bj_p`ppp'_cz`outcome'`spec'_se == .

	g Bj_p`ppp'_cz`outcome'`spec'_bs_se = Bj_p`ppp'_cz`outcome'`spec'_se

	* Calculate precision weights for regression
	g precwt_reg = 1/ (Bj_p`ppp'_cz`outcome'`spec'_bs_se^2 + Bj_p`ppp'_czkr26_cc2_bs_se^2)

	su Bj_p`ppp'_czkr26_cc2 [w=precwt_reg] if pop2000>=$poptop , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz`outcome'`spec' [w=precwt_reg] if pop2000>=$poptop , d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates to get coeff SEs
	reg Bj_p`ppp'_cz`outcome'`spec' Bj_p`ppp'_czkr26_cc2 [w=precwt_reg] if pop2000>=$poptop
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz`outcome'`spec'_bs_se^2

	* Calculate Total Variance (=noise+signal)
	su Bj_p`ppp'_cz`outcome'`spec' [w=precwt]  if pop2000>= $poptop, d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz`outcome'`spec'_bs_se2 =Bj_p`ppp'_cz`outcome'`spec'_bs_se^2
	su Bj_p`ppp'_cz`outcome'`spec'_bs_se2 [w=precwt] if pop2000>= $poptop, d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}

	* Calculate SDs
	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if pop2000>= $poptop, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')
}
}
}

*** 4) Placebo Moves > Age 23 - Signal Correlation
foreach outcome in kr26 {
foreach spec in "_pbo_cc2" {
foreach ppp in "25" "75"{

	* Load data
	use "${cz_data}", clear
	keep if pop2000 >= ${poptop}

	* Restrict to places with non-missing perm res outcomes
	keep if e_rank_b_`outcome'_p`ppp'~=.
	drop if Bj_p`ppp'_cz`outcome'`spec' == . | Bj_p`ppp'_cz`outcome'`spec'_se == .

	g Bj_p`ppp'_cz`outcome'`spec'_bs_se = Bj_p`ppp'_cz`outcome'`spec'_se

	* Calculate precision weights for regression
	g precwt_reg = 1/ (Bj_p`ppp'_cz`outcome'`spec'_bs_se^2 + Bj_p`ppp'_czkr26_cc2_bs_se^2)

	su Bj_p`ppp'_czkr26_cc2 [w=precwt_reg] if pop2000>=$poptop , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz`outcome'`spec' [w=precwt_reg] if pop2000>=$poptop , d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates to get correlation and SEs
	reg Bj_p`ppp'_cz`outcome'`spec' Bj_p`ppp'_czkr26_cc2 [w=precwt_reg] if pop2000>=$poptop
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd

	* Nathan - Adjust for the noise in kr26 // i think we should use the kr26 precision, not the kr26+placebo precision for this.
	su Bj_p`ppp'_czkr26_cc2 [w=1/Bj_p`ppp'_czkr26_cc2_bs_se^2] , d
	global totvar = r(Var)
	g kr26_var = Bj_p`ppp'_czkr26_cc2_bs_se^2
	su kr26_var [w=1/kr26_var] , d
	global noisevar = r(mean)
	global sigvar = $totvar - $noisevar 

	* We can construct the adjusted correlation and its s.e.:
	global x1_`outcome'`spec'_`ppp' = ${x1_`outcome'`spec'_`ppp'} * sqrt($totvar / $sigvar)
	global x2_`outcome'`spec'_`ppp' = ${x2_`outcome'`spec'_`ppp'} * sqrt($totvar / $sigvar)

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz`outcome'`spec'_bs_se^2

	* Calculate Total Variance (=noise+signal)
	su Bj_p`ppp'_cz`outcome'`spec' [w=precwt]  if pop2000>= $poptop, d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz`outcome'`spec'_bs_se2 =Bj_p`ppp'_cz`outcome'`spec'_bs_se^2
	su Bj_p`ppp'_cz`outcome'`spec'_bs_se2 [w=precwt] if pop2000>= $poptop, d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}
	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if pop2000>= $poptop, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')
}
}
}

*** 5) TLFP 16 - Signal Correlation
* Split Sample 1 for tlpbo_16 and 2 for kr26
foreach outcome in tlpbo_16 {
foreach spec in "_cc2" {
foreach ppp in "25" "75"{
	* Load data
	use "${cz_data}", clear
	keep if pop2000 >= ${poptop}

	* Restrict to non-missing
	*keep if e_rank_b_tl16_p`ppp'~=.
	drop if Bj_p`ppp'_cz`outcome'`spec'_ss1 == . | Bj_p`ppp'_cz`outcome'`spec'_ss1_se == .

	g Bj_p`ppp'_cz`outcome'`spec'_ss1_bs_se = Bj_p`ppp'_cz`outcome'`spec'_ss1_se

	* Calculate precision weights for regression
	g precwt_reg = 1/ (Bj_p`ppp'_cz`outcome'`spec'_ss1_bs_se^2 + Bj_p`ppp'_czkr26_cc2_16_ss2_se^2)

	su Bj_p`ppp'_czkr26_cc2_16_ss2 [w=precwt_reg] if pop2000>=$poptop , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz`outcome'`spec'_ss1 [w=precwt_reg] if pop2000>=$poptop , d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates to get correlation and SEs
	reg Bj_p`ppp'_cz`outcome'`spec'_ss1 Bj_p`ppp'_czkr26_cc2_16_ss2 [w=precwt_reg] if pop2000>=$poptop
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_czkr26_cc2_16_ss2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_czkr26_cc2_16_ss2] * $baseline_sd / $alternate_sd

	* Nathan - Adjust for the noise in kr26 // i think we should use the kr26 precision, not the kr26+placebo precision for this.
	su Bj_p`ppp'_czkr26_cc2_16_ss2 [w=1/Bj_p`ppp'_czkr26_cc2_16_ss2_se^2] , d
	global totvar = r(Var)
	g kr26_var = Bj_p`ppp'_czkr26_cc2_16_ss2_se^2
	su kr26_var [w=1/kr26_var] , d
	global noisevar = r(mean)
	global sigvar = $totvar - $noisevar 

	* We can construct the adjusted correlation and its s.e.:
	global x1_`outcome'`spec'_`ppp' = ${x1_`outcome'`spec'_`ppp'} * sqrt($totvar / $sigvar)
	global x2_`outcome'`spec'_`ppp' = ${x2_`outcome'`spec'_`ppp'} * sqrt($totvar / $sigvar)

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz`outcome'`spec'_ss1_bs_se^2

	* Calculate Total Variance (=noise+signal)
	su Bj_p`ppp'_cz`outcome'`spec'_ss1 [w=precwt]  if pop2000>= $poptop, d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz`outcome'`spec'_ss1_bs_se2 =Bj_p`ppp'_cz`outcome'`spec'_ss1_bs_se^2
	su Bj_p`ppp'_cz`outcome'`spec'_ss1_bs_se2 [w=precwt] if pop2000>= $poptop, d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}
	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if pop2000>= $poptop, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')
}
}
}

* Split Sample 2 for tlpbo_16 and 1 for kr26
foreach outcome in tlpbo_16 {
foreach spec in "_cc2" {
foreach ppp in "25" "75"{

	* Load data
	use "${cz_data}", clear
	keep if pop2000 >= ${poptop}

	* Restrict to non-missing
	*keep if e_rank_b_tl16_p`ppp'~=.
	drop if Bj_p`ppp'_cz`outcome'`spec'_ss2 == . | Bj_p`ppp'_cz`outcome'`spec'_ss2_se == .

	g Bj_p`ppp'_cz`outcome'`spec'_ss2_bs_se = Bj_p`ppp'_cz`outcome'`spec'_ss2_se

	* Calculate precision weights for regression
	g precwt_reg = 1/ (Bj_p`ppp'_cz`outcome'`spec'_ss2_bs_se^2 + Bj_p`ppp'_czkr26_cc2_16_ss1_se^2)

	su Bj_p`ppp'_czkr26_cc2_16_ss1 [w=precwt_reg] if pop2000>=$poptop , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz`outcome'`spec'_ss2 [w=precwt_reg] if pop2000>=$poptop , d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates to get correlation and SEs
	reg Bj_p`ppp'_cz`outcome'`spec'_ss2 Bj_p`ppp'_czkr26_cc2_16_ss1 [w=precwt_reg] if pop2000>=$poptop
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp'_ss2 = _b[Bj_p`ppp'_czkr26_cc2_16_ss1] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp'_ss2 = _se[Bj_p`ppp'_czkr26_cc2_16_ss1] * $baseline_sd / $alternate_sd

	* Nahan - Adjust for the noise in kr26 // i think we should use the kr26 precision, not the kr26+placebo precision for this.
	su Bj_p`ppp'_czkr26_cc2_16_ss1 [w=1/Bj_p`ppp'_czkr26_cc2_16_ss1_se^2] , d
	global totvar = r(Var)
	g kr26_var = Bj_p`ppp'_czkr26_cc2_16_ss1_se^2
	su kr26_var [w=1/kr26_var] , d
	global noisevar = r(mean)
	global sigvar = $totvar - $noisevar 

	* We can construct the adjusted correlation and its s.e.:
	global x1_`outcome'`spec'_`ppp'_ss2 = ${x1_`outcome'`spec'_`ppp'_ss2} * sqrt($totvar / $sigvar)
	global x2_`outcome'`spec'_`ppp'_ss2 = ${x2_`outcome'`spec'_`ppp'_ss2} * sqrt($totvar / $sigvar)

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz`outcome'`spec'_ss2_bs_se^2

	* Calculate Total Variance (=noise+signal)
	su Bj_p`ppp'_cz`outcome'`spec'_ss2 [w=precwt]  if pop2000>= $poptop, d
	global totvar_`outcome'`spec'_ss2 = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz`outcome'`spec'_ss2_bs_se2 =Bj_p`ppp'_cz`outcome'`spec'_ss2_bs_se^2
	su Bj_p`ppp'_cz`outcome'`spec'_ss2_bs_se2 [w=precwt] if pop2000>= $poptop, d
	global noisevar_`outcome'`spec'_ss2 = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp'_ss2 = ${totvar_`outcome'`spec'_ss2} - ${noisevar_`outcome'`spec'_ss2}
	global sigsd_`outcome'`spec'_`ppp'_ss2 = sqrt(${sigvar_`outcome'`spec'_`ppp'_ss2})
	global noisesd_`outcome'`spec'_`ppp'_ss2 = sqrt(${noisevar_`outcome'`spec'_ss2})

	* Calculate SE for Signal SD
	su precwt if pop2000>= $poptop, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp'_ss2 = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'_ss2})) * (1/`prec_sum')
}
}
}

*-------------------------------------------------------------------------------
* Make a table
*-------------------------------------------------------------------------------
*Create matrices to store results
matrix results_p25 = J(1,7,.)
matrix results_p75 = J(1,7,.)

*Baseline specs
foreach outcome in kr26 {
foreach spec in "_cc2" "_sq_cc2" "_cc1" "_cc3" "_coli_cc2" "_pmi_cc2" "_pbo_cc2" "_m_cc2" "_f_cc2"{
foreach ppp in 25 75 {
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'},${x2_`outcome'`spec'_`ppp'},${sigvar_`outcome'`spec'_`ppp'},${sigsd_`outcome'`spec'_`ppp'},${se_sd_`outcome'`spec'_`ppp'},${totvar_`outcome'`spec'},${noisevar_`outcome'`spec'}]
}
}
}

*Individual specs
foreach outcome in kir26 {
foreach spec in "_cc2" "_m_cc2" "_f_cc2" {
foreach ppp in 25 75 {
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'},${x2_`outcome'`spec'_`ppp'},${sigvar_`outcome'`spec'_`ppp'},${sigsd_`outcome'`spec'_`ppp'},${se_sd_`outcome'`spec'_`ppp'},${totvar_`outcome'`spec'},${noisevar_`outcome'`spec'}]
}
}
}
*$ outcomes (not ranks)
foreach outcome in kfi26 kii26 km26{
foreach spec in "_cc2" {
foreach ppp in "25" "75" {
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'},${x2_`outcome'`spec'_`ppp'},${sigvar_`outcome'`spec'_`ppp'},${sigsd_`outcome'`spec'_`ppp'},${se_sd_`outcome'`spec'_`ppp'},${totvar_`outcome'`spec'},${noisevar_`outcome'`spec'}]
}
}
}
*TLFP
foreach outcome in tlpbo_16{
foreach spec in "_cc2" {
foreach ppp in "25" "75" {
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'},${x2_`outcome'`spec'_`ppp'},${sigvar_`outcome'`spec'_`ppp'},${sigsd_`outcome'`spec'_`ppp'},${se_sd_`outcome'`spec'_`ppp'},${totvar_`outcome'`spec'},${noisevar_`outcome'`spec'}]
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'_ss2},${x2_`outcome'`spec'_`ppp'_ss2},${sigvar_`outcome'`spec'_`ppp'_ss2},${sigsd_`outcome'`spec'_`ppp'_ss2},${se_sd_`outcome'`spec'_`ppp'_ss2},${totvar_`outcome'`spec'_ss2},${noisevar_`outcome'`spec'_ss2}]
}
}
}

clear
svmat results_p25 
drop if results_p251 == .
rename (results_p251 results_p252 results_p253 results_p254 results_p255 results_p256 results_p257) ///
(corr std_err signal_var signal_sd signal_sd_se total_var noise_var)
g spec = "a"
scalar counter = 1
foreach try in "baseline" "_sq_cc2" "_cc1" "_cc3" "_coli_cc2" "_pmi_cc2" "_pbo_cc2" "_m_cc2" ///
	"_f_cc2" "kir_cc2" "kir_m_cc2" "kir_f_cc2" "kfi26" "kii26" "km26" "tlpbo_16" "tlpbo_16_ss2"{
	replace spec = "`try'" if _n == counter
	scalar counter = counter + 1
}

export delimited "${tables}/app_tab_1czp25_raw", replace  

clear
svmat results_p75 
drop if results_p751 == .
rename (results_p751 results_p752 results_p753 results_p754 results_p755 results_p756 results_p757) ///
(corr std_err signal_var signal_sd signal_sd_se total_var noise_var)
g spec = "a"
scalar counter = 1
foreach try in "baseline" "_sq_cc2" "_cc1" "_cc3" "_coli_cc2" "_pmi_cc2"  ///
	"_pbo_cc2" "_m_cc2" "_f_cc2" "kir_cc2" "kir_m_cc2" "kir_f_cc2" "kfi26" "kii26" "km26" "tlpbo_16" "tlpbo_16_ss2"{
	replace spec = "`try'" if _n == counter
	scalar counter = counter + 1
}

export delimited "${tables}/app_tab_1czp75_raw", replace  

** County Level
* population restrictions
global poptopcz 25000
global poptopcty 10000

clear all

*** 1) Baseline Outcome: kr26

foreach outcome in kr26 {
foreach spec in "_cc2" "_sq_cc2" "_cc1" "_cc3" "_coli_cc2" "_pmi_cc2" "_pbo_cc2" "_m_cc2" "_f_cc2" {
foreach ppp in "25" "75" {

	* Load data
	use "${cty_data}", clear
	keep if cz_pop2000>=$poptopcz 
	keep if cty_pop2000>=$poptopcty

	if "`spec'" == "_coli_cc2" {
		rename *coli1996* *coli*
	}

	if "`spec'" == "_cc1" {
		rename Bj_p`ppp'_cty_kr26_cc Bj_p`ppp'_cty_kr26_cc1
		rename Bj_p`ppp'_cty_kr26_cc_se Bj_p`ppp'_cty_kr26_cc1_se
		rename Bj_p`ppp'_cz_cty_kr26_cc Bj_p`ppp'_cz_cty_kr26_cc1
		rename Bj_p`ppp'_cz_cty_kr26_cc_se Bj_p`ppp'_cz_cty_kr26_cc1_se

	}

	* Restrict to places with non-missing perm res outcomes
	keep if e_rank_b_`outcome'_p`ppp'~=.
	drop if Bj_p`ppp'_cz_cty_`outcome'`spec' == . | Bj_p`ppp'_cz_cty_`outcome'`spec'_se == .

	* Calculate precision weights for regression 
	g precwt_reg = 1/ (Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2 + Bj_p`ppp'_cz_cty_kr26_cc2_bs_se^2)

	* Adjust raw correlation and se for ratio of sds
	su Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz_cty_`outcome'`spec' [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global alternate_sd = r(sd)

	* Regress on Baseline Estimates for SEs
	reg Bj_p`ppp'_cz_cty_`outcome'`spec' Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2

	* Calculate Total Variance (=noise+signal)
	qui su Bj_p`ppp'_cz_cty_`outcome'`spec' [w=precwt]  if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz_cty_`outcome'`spec'_se2 = Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2
	qui su Bj_p`ppp'_cz_cty_`outcome'`spec'_se2 [w=precwt] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}

	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')

}
}
}

*** 2) Other Outcomes: kir26
foreach outcome in kir26 {
foreach spec in "_cc2" "_m_cc2" "_f_cc2"{
foreach ppp in "25" "75" {

	* Load data
	use "${cty_data}", clear
	keep if cz_pop2000>=$poptopcz 
	keep if cty_pop2000>=$poptopcty

	* Restrict to places with non-missing perm res outcomes
	keep if e_rank_b_`outcome'_p`ppp'~=.
	drop if Bj_p`ppp'_cz_cty_`outcome'`spec' == . | Bj_p`ppp'_cz_cty_`outcome'`spec'_se == .

	* Calculate precision weights for regression
	g precwt_reg = 1/ (Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2 + Bj_p`ppp'_cz_cty_kr26_cc2_bs_se^2)

	su Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz_cty_`outcome'`spec' [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global alternate_sd = r(sd)

	* Regress on Baseline Estimates for raw correlation and SEs
	reg Bj_p`ppp'_cz_cty_`outcome'`spec' Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2

	* Calculate Total Variance (=noise+signal)
	qui su Bj_p`ppp'_cz_cty_`outcome'`spec' [w=precwt]  if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz_cty_`outcome'`spec'_se2 =Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2
	qui su Bj_p`ppp'_cz_cty_`outcome'`spec'_se2 [w=precwt] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}

	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')
}
}
}

*** 3) Alternative Outcomes: kid family income and individual income ($ not rank)
foreach outcome in kfi26 kii26 km26{
foreach spec in "_cc2" {
foreach ppp in "25" "75" {

	* Load data
	use "${cty_data}", clear
	keep if cz_pop2000>=$poptopcz 
	keep if cty_pop2000>=$poptopcty

	* Restrict to places with non-missing perm res outcomes
	keep if e_rank_b_`outcome'_p`ppp'~=.

	drop if Bj_p`ppp'_cz_cty_`outcome'`spec' == . | Bj_p`ppp'_cz_cty_`outcome'`spec'_se == .

	* Calculate precision weights for regression 
	g precwt_reg = 1/ (Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2 + Bj_p`ppp'_cz_cty_kr26_cc2_bs_se^2)

	su Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz_cty_`outcome'`spec' [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global alternate_sd = r(sd)

	* Regress on Baseline Estimates for SEs
	reg Bj_p`ppp'_cz_cty_`outcome'`spec' Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2

	* Calculate Total Variance (=noise+signal)
	qui su Bj_p`ppp'_cz_cty_`outcome'`spec' [w=precwt]  if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz_cty_`outcome'`spec'_se2 =Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2
	qui su Bj_p`ppp'_cz_cty_`outcome'`spec'_se2 [w=precwt] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}

	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')
}
}
}

*** 4) Placebo Moves > Age 23 - Signal Correlations
foreach outcome in kr26 {
foreach spec in "_pbo_cc2"{
foreach ppp in "25" "75" {

	* Load data
	use "${cty_data}", clear
	keep if cz_pop2000>=$poptopcz 
	keep if cty_pop2000>=$poptopcty

	* Restrict to places with non-missing perm res outcomes
	keep if e_rank_b_`outcome'_p`ppp'~=.
	drop if Bj_p`ppp'_cz_cty_`outcome'`spec' == . | Bj_p`ppp'_cz_cty_`outcome'`spec'_se == .

	* Calculate precision weights for regression 
	g precwt_reg = 1/ (Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2 + Bj_p`ppp'_cz_cty_kr26_cc2_bs_se^2)

	su Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz_cty_`outcome'`spec' [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global alternate_sd = r(sd)

	* Regress on Baseline Estimates for SEs
	reg Bj_p`ppp'_cz_cty_`outcome'`spec' Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd


	*Nathan - Adjust for the noise in kr26 // i think we should use the kr26 precision, not the kr26+placebo precision for this.
	su Bj_p`ppp'_cz_cty_kr26_cc2 [w=1/Bj_p`ppp'_cz_cty_kr26_cc2_bs_se^2] , d
	global totvar = r(Var)
	g kr26_var = Bj_p`ppp'_cz_cty_kr26_cc2_bs_se^2
	su kr26_var [w=1/kr26_var] , d
	global noisevar = r(mean)
	global sigvar = $totvar - $noisevar 

	* We can construct the adjusted correlation and its s.e.:
	global x1_`outcome'`spec'_`ppp' = ${x1_`outcome'`spec'_`ppp'} * sqrt($totvar / $sigvar)
	global x2_`outcome'`spec'_`ppp' = ${x2_`outcome'`spec'_`ppp'} * sqrt($totvar / $sigvar)

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2

	* Calculate Total Variance (=noise+signal)
	qui su Bj_p`ppp'_cz_cty_`outcome'`spec' [w=precwt]  if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cz_cty_`outcome'`spec'_se2 =Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2
	qui su Bj_p`ppp'_cz_cty_`outcome'`spec'_se2 [w=precwt] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}

	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')

}
}
}

*** TLFP 16 - Signal Correlation
* Split Sample 1 for tlpbo_16 and 2 for kr26
foreach outcome in tlpbo_16 {
foreach spec in "_cc2" {
foreach ppp in "25" "75"{

	* Load data
	use "${cty_data}", clear
	keep if cz_pop2000>=$poptopcz 
	keep if cty_pop2000>=$poptopcty

	* Restrict to non-missing
	drop if Bj_p`ppp'_czcty_`outcome'`spec'_ss1 == . | Bj_p`ppp'_czcty_`outcome'`spec'_ss1_se == .

	* Calculate precision weights for regression
	g precwt_reg = 1/ (Bj_p`ppp'_czcty_`outcome'`spec'_ss1_se^2 + Bj_p`ppp'_cz_cty_kr26_16_cc2_ss2_se^2)

	su Bj_p`ppp'_cz_cty_kr26_16_cc2_ss2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cty_`outcome'`spec'_ss1 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates to get correlation and SEs
	reg Bj_p`ppp'_czcty_`outcome'`spec'_ss1 Bj_p`ppp'_cz_cty_kr26_16_cc2_ss2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp' = _b[Bj_p`ppp'_cz_cty_kr26_16_cc2_ss2] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp' = _se[Bj_p`ppp'_cz_cty_kr26_16_cc2_ss2] * $baseline_sd / $alternate_sd

	* Nathan - Adjust for the noise in kr26 // i think we should use the kr26 precision, not the kr26+placebo precision for this.
	su Bj_p`ppp'_cz_cty_kr26_16_cc2_ss2 [w=1/Bj_p`ppp'_cz_cty_kr26_16_cc2_ss2_se^2] , d
	global totvar = r(Var)
	g kr26_var = Bj_p`ppp'_cz_cty_kr26_16_cc2_ss2_se^2
	su kr26_var [w=1/kr26_var] , d
	global noisevar = r(mean)
	global sigvar = $totvar - $noisevar 

	* We can construct the adjusted correlation and its s.e.:
	global x1_`outcome'`spec'_`ppp' = ${x1_`outcome'`spec'_`ppp'} * sqrt($totvar / $sigvar)
	global x2_`outcome'`spec'_`ppp' = ${x2_`outcome'`spec'_`ppp'} * sqrt($totvar / $sigvar)

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_czcty_`outcome'`spec'_ss1_se^2

	* Calculate Total Variance (=noise+signal)
	su Bj_p`ppp'_czcty_`outcome'`spec'_ss1 [w=precwt]  if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global totvar_`outcome'`spec' = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_czcty_`outcome'`spec'_ss1se2 =Bj_p`ppp'_czcty_`outcome'`spec'_ss1_se^2
	su Bj_p`ppp'_czcty_`outcome'`spec'_ss1se2 [w=precwt] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global noisevar_`outcome'`spec' = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp' = ${totvar_`outcome'`spec'} - ${noisevar_`outcome'`spec'}
	global sigsd_`outcome'`spec'_`ppp' = sqrt(${sigvar_`outcome'`spec'_`ppp'})
	global noisesd_`outcome'`spec'_`ppp' = sqrt(${noisevar_`outcome'`spec'})

	* Calculate SE for Signal SD
	su precwt if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp' = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'})) * (1/`prec_sum')

}
}
}

* Split Sample 2 for tlpbo_16 and 1 for kr26
foreach outcome in tlpbo_16 {
foreach spec in "_cc2" {
foreach ppp in "25" "75"{

	* Load data
	use "${cty_data}", clear
	keep if cz_pop2000>=$poptopcz 
	keep if cty_pop2000>=$poptopcty

	* Restrict to non-missing
	drop if Bj_p`ppp'_czcty_`outcome'`spec'_ss2 == . | Bj_p`ppp'_czcty_`outcome'`spec'_ss2_se == .

	* Calculate precision weights for regression
	g precwt_reg = 1/ (Bj_p`ppp'_czcty_`outcome'`spec'_ss2_se^2 + Bj_p`ppp'_cz_cty_kr26_16_cc2_ss1_se^2)

	su Bj_p`ppp'_cz_cty_kr26_16_cc2_ss1 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cty_`outcome'`spec'_ss2 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates to get correlation and SEs
	reg Bj_p`ppp'_czcty_`outcome'`spec'_ss2 Bj_p`ppp'_cz_cty_kr26_16_cc2_ss1 [w=precwt_reg] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty
	predict `outcome'`spec'_predict, xb
	global x1_`outcome'`spec'_`ppp'_ss2 = _b[Bj_p`ppp'_cz_cty_kr26_16_cc2_ss1] * $baseline_sd / $alternate_sd
	global x2_`outcome'`spec'_`ppp'_ss2 = _se[Bj_p`ppp'_cz_cty_kr26_16_cc2_ss1] * $baseline_sd / $alternate_sd

	* Nathan - Adjust for the noise in kr26 // i think we should use the kr26 precision, not the kr26+placebo precision for this.
	su Bj_p`ppp'_cz_cty_kr26_16_cc2_ss1 [w=1/Bj_p`ppp'_cz_cty_kr26_16_cc2_ss1_se^2] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global totvar = r(Var)
	g kr26_var = Bj_p`ppp'_cz_cty_kr26_16_cc2_ss1_se^2
	su kr26_var [w=1/kr26_var] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global noisevar = r(mean)
	global sigvar = $totvar - $noisevar 

	* We can construct the adjusted correlation and its s.e.:
	global x1_`outcome'`spec'_`ppp'_ss2 = ${x1_`outcome'`spec'_`ppp'_ss2} * sqrt($totvar / $sigvar)
	global x2_`outcome'`spec'_`ppp'_ss2 = ${x2_`outcome'`spec'_`ppp'_ss2} * sqrt($totvar / $sigvar)

	* Calculate precision weights for sums
	g precwt = 1/ Bj_p`ppp'_czcty_`outcome'`spec'_ss2_se^2

	* Calculate Total Variance (=noise+signal)
	su Bj_p`ppp'_cty_`outcome'`spec'_ss2 [w=precwt]  if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global totvar_`outcome'`spec'_ss2 = r(Var)

	* Calculate Noise Variance (=E[SE^2])
	g Bj_p`ppp'_cty_`outcome'`spec'_ss2se2 =Bj_p`ppp'_cty_`outcome'`spec'_ss2_se^2
	su Bj_p`ppp'_cty_`outcome'`spec'_ss2se2 [w=precwt] if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty , d
	global noisevar_`outcome'`spec'_ss2 = r(mean)

	* Calcuate Signal Variance
	global sigvar_`outcome'`spec'_`ppp'_ss2 = ${totvar_`outcome'`spec'_ss2} - ${noisevar_`outcome'`spec'_ss2}
	global sigsd_`outcome'`spec'_`ppp'_ss2 = sqrt(${sigvar_`outcome'`spec'_`ppp'_ss2})
	global noisesd_`outcome'`spec'_`ppp'_ss2 = sqrt(${noisevar_`outcome'`spec'_ss2})

	* Calculate SE for Signal SD
	su precwt if cz_pop2000>=$poptopcz & cty_pop2000>=$poptopcty, d
	local prec_sum = r(sum)
	local n_c = r(N)
	global se_sd_`outcome'`spec'_`ppp'_ss2 = sqrt(`n_c' / (2*${sigvar_`outcome'`spec'_`ppp'_ss2})) * (1/`prec_sum')
}
}
}

*-------------------------------------------------------------------------------
* Make a table
*-------------------------------------------------------------------------------
*Create matrices to store results
matrix results_p25 = J(1,5,.)
matrix results_p75 = J(1,5,.)

*Baseline specs
foreach outcome in kr26 {
foreach spec in "_cc2" "_sq_cc2" "_cc1" "_cc3" "_coli_cc2" "_pmi_cc2" "_pbo_cc2" "_m_cc2" "_f_cc2"{
foreach ppp in 25 75 {
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'},${x2_`outcome'`spec'_`ppp'},${sigvar_`outcome'`spec'_`ppp'},${sigsd_`outcome'`spec'_`ppp'},${se_sd_`outcome'`spec'_`ppp'}]
}
}
}

*Individual specs
foreach outcome in kir26 {
foreach spec in "_cc2" "_m_cc2" "_f_cc2" {
foreach ppp in 25 75 {
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'},${x2_`outcome'`spec'_`ppp'},${sigvar_`outcome'`spec'_`ppp'},${sigsd_`outcome'`spec'_`ppp'},${se_sd_`outcome'`spec'_`ppp'}]
}
}
}
*$ outcomes (not ranks)
foreach outcome in kfi26 kii26 km26{
foreach spec in "_cc2" {
foreach ppp in "25" "75" {
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'},${x2_`outcome'`spec'_`ppp'},${sigvar_`outcome'`spec'_`ppp'},${sigsd_`outcome'`spec'_`ppp'},${se_sd_`outcome'`spec'_`ppp'}]
}
}
}
*TLFP
foreach outcome in tlpbo_16{
foreach spec in "_cc2" {
foreach ppp in "25" "75" {
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'},${x2_`outcome'`spec'_`ppp'},${sigvar_`outcome'`spec'_`ppp'},${sigsd_`outcome'`spec'_`ppp'},${se_sd_`outcome'`spec'_`ppp'}]
	matrix results_p`ppp' = results_p`ppp' \ [${x1_`outcome'`spec'_`ppp'_ss2},${x2_`outcome'`spec'_`ppp'_ss2},${sigvar_`outcome'`spec'_`ppp'_ss2},${sigsd_`outcome'`spec'_`ppp'_ss2},${se_sd_`outcome'`spec'_`ppp'_ss2}]
}
}
}

clear
svmat results_p25 
drop if results_p251 == .
rename (results_p251 results_p252 results_p253 results_p254 results_p255) ///
(corr std_err signal_var signal_sd signal_sd_se)
g spec = "a"
scalar counter = 1
foreach try in "baseline" "_sq_cc2" "_cc1" "_cc3" "_coli_cc2" "_pmi_cc2" "_pbo_cc2" "_m_cc2" ///
	"_f_cc2" "kir_cc2" "kir_m_cc2" "kir_f_cc2" "kfi26" "kii26" "km26" "tlpbo_16" "tlpbo_16_ss2"{
	replace spec = "`try'" if _n == counter
	scalar counter = counter + 1
}

export delimited "${tables}/app_tab_1ctyp25_raw", replace  

clear
svmat results_p75 
drop if results_p751 == .
rename (results_p751 results_p752 results_p753 results_p754 results_p755) ///
(corr std_err signal_var signal_sd signal_sd_se)
g spec = "a"
scalar counter = 1
foreach try in "baseline" "_sq_cc2" "_cc1" "_cc3" "_coli_cc2" "_pmi_cc2" ///
	"_pbo_cc2" "_m_cc2" "_f_cc2" "kir_cc2" "kir_m_cc2" "kir_f_cc2" "kfi26" "kii26" "km26" "tlpbo_16" "tlpbo_16_ss2"{
	replace spec = "`try'" if _n == counter
	scalar counter = counter + 1
}

export delimited "${tables}/app_tab_1ctyp75_raw", replace  


** APPENDIX TABLES 11-14: CORRELATION WITH OBSERVABLES AT THE COUNTY AND CZ LEVEL

* Appendix Table 11: Associations Between Place Effects and Area-Level Characteristics Across Commuting Zones for Low-Income Families (p = 25)													
* Appendix Table 13: Associations Between Place Effects and Area-Level Characteristics Across Commuting Zones for High-Income Families (p = 75)													

clear all
macro drop pop_cutoff reg_weight weight clvar var_cap scale_factor varlist
global pop_cutoff 25000
global reg_weight pop2000
global weight precwt
global clvar state_id
global var_cap =.
global scale_factor 20

global varlist cs_race_bla poor_share cs_race_theil_2000 cs00_seg_inc cs00_seg_inc_pov25 cs00_seg_inc_aff75 frac_traveltime_lt15 log_pop_density ///
	hhinc00 gini inc_share_1perc gini99 frac_middleclass ///
	taxrate subcty_total_taxes_pc subcty_total_expenditure_pc eitc_exposure tax_st_diff_top20 ///
	ccd_exp_tot ccd_pup_tch_ratio score_r dropout_r ///
	num_inst_pc tuition gradrate_r ///
	cs_labforce cs_elf_ind_man d_tradeusch_pw_1990 frac_worked1416 ///
	mig_inflow mig_outflow cs_born_foreign ///
	scap_ski90pcm rel_tot crime_violent ///
	cs_fam_wkidsinglemom cs_divorced cs_married ///
	median_house_value median_rent

** Inflation scaling for rental data
import delimited "${dropbox}/movers/analysis/covariates/CPIAUCSL", clear
qui {
sum cpi if date == 2000
local 2000 = r(mean)
sum cpi if date == 2012
local 2012 = r(mean)
global inflate = `2012' / `2000'
}

foreach outcome in "kr26" {
foreach spec in "_cc2"{
foreach p in "25" "75"{
	
	* use beta dataset
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff}
	
	** Define median rent to be at given income level
	if "`p'" == "25" {
	gen median_rent = med_rent_bm 
	gen median_rent_st = med_rent_bm_st
	gen median_house_value = med_house_price_am
	gen median_house_value_st = med_house_price_am_st
	}
	else if "`p'" == "75" {
	gen median_rent = med_rent_am
	gen median_rent_st = med_rent_am_st
	gen median_house_value = med_house_price_bm
	gen median_house_value_st = med_house_price_bm_st
	}
	replace median_rent = median_rent * ${inflate}
	replace median_house_value = median_house_value * ${inflate}
	
	* define matrix to store results 
	mat define czreg`outcome'`spec'_p`p'=J(40,9,.)
	local row =1
	matrix rownames czreg`outcome'`spec'_p`p'= ${varlist}
	
	*Drop all obs with missing values of stayers, which are necessary for decomposition into sorting and causal
	keep if e_rank_b_`outcome'_p`p'~=.
	
	*Estimates of causal and sorting effects
	g causal_raw_`p' = ${scale_factor}*Bj_p`p'_cz`outcome'`spec'
	g sorting_raw_`p' = e_rank_b_`outcome'_p`p'-causal_raw_`p'

	*Generate variances and precision weights
	g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_bs_se^2
	g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs

	* estimate signal and noise variances 
	qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)
	qui sum Bj_p`p'_cz`outcome'`spec' [w=${weight}],d
	global totvar = r(Var)

	global sigvar = $totvar-$noisevar_bs
	assert ${sigvar}>0
	global sigsd = sqrt($sigvar)
	
	* Regressions with Observables
	foreach var of global varlist {
	
	sum `var' [w=${reg_weight}]
	global st_dev = r(sd)
	mat def czreg`outcome'`spec'_p`p'[`row',1] = ${st_dev}
	
	qui reg Bj_p`p'_cz`outcome'`spec' `var'_st [w=${reg_weight}], cluster(${clvar})
	mat def czreg`outcome'`spec'_p`p'[`row',2] = _b[`var'_st]/${sigsd}
	mat def czreg`outcome'`spec'_p`p'[`row',3] = _se[`var'_st]/${sigsd}
	
	qui reg e_rank_b_`outcome'_p`p' `var'_st [w=${reg_weight}], cluster(${clvar})
	mat def czreg`outcome'`spec'_p`p'[`row',4] = _b[`var'_st]
	mat def czreg`outcome'`spec'_p`p'[`row',5] = _se[`var'_st]
	
	qui reg causal_raw_`p' `var'_st [w=${reg_weight}], cluster(${clvar})
	mat def czreg`outcome'`spec'_p`p'[`row',6] = _b[`var'_st]
	mat def czreg`outcome'`spec'_p`p'[`row',7] = _se[`var'_st]
	
	qui reg sorting_raw_`p' `var'_st [w=${reg_weight}], cluster(${clvar})
	mat def czreg`outcome'`spec'_p`p'[`row',8] = _b[`var'_st]
	mat def czreg`outcome'`spec'_p`p'[`row',9] = _se[`var'_st]
	local row = `row'+1
	}
	
	* store results in the czreg matrix
	clear
	svmat2 czreg`outcome'`spec'_p`p', rnames(variables)
	gen number = [_n]
	rename czreg`outcome'`spec'_p`p'1 std_dev_`outcome'`spec'_p`p'
	rename czreg`outcome'`spec'_p`p'2 coef_corr_`outcome'`spec'_p`p'
	rename czreg`outcome'`spec'_p`p'3 se_corr_`outcome'`spec'_p`p'
	rename czreg`outcome'`spec'_p`p'4 coef_stayers_`outcome'`spec'_p`p'
	rename czreg`outcome'`spec'_p`p'5 se_stayers_`outcome'`spec'_p`p'
	rename czreg`outcome'`spec'_p`p'6 coef_causal_`outcome'`spec'_p`p'
	rename czreg`outcome'`spec'_p`p'7 se_causal_`outcome'`spec'_p`p'
	rename czreg`outcome'`spec'_p`p'8 coef_sorting_`outcome'`spec'_p`p'
	rename czreg`outcome'`spec'_p`p'9 se_sorting_`outcome'`spec'_p`p'
	order number variables std* coef_corr* se_corr* coef_stayers* se_stayers* coef_causal* se_causal* coef_sorting* se_sorting*
	tempfile czreg_`outcome'`spec'_p`p'
	save `czreg_`outcome'`spec'_p`p''
	
	drop number
	
	if "`p'"=="25"{
	export delimited "${tables}/app_table_11", replace  

	}
	if "`p'"=="75"{
	export delimited "${tables}/app_table_13", replace  
	}
	
}
}
}
	

* Appendix Table 12: Associations Between Place Effects and Area-Level Characteristics Across Counties within Commuting Zones for Low-Income Families (p = 25)												

* Appendix Table 14: Associations Between Place Effects and Area-Level Characteristics Across Counties within Commuting Zones for High-Income Families (p = 75)												
clear all 
macro drop cz_pop_cutoff cty_pop_cutoff weight reg_weight clvar scale_factor var_cap varlist
global cty_pop_cutoff = 10000
global cz_pop_cutoff = 25000
global weight precwt
global reg_weight cty_pop2000
global clvar cz
global scale_factor 20
global var_cap = .

global varlist cs_race_bla poor_share cs_race_theil_2000 cs00_seg_inc cs00_seg_inc_pov25 cs00_seg_inc_aff75 frac_traveltime_lt15 log_pop_density ///
	hhinc00 gini inc_share_1perc gini99 frac_middleclass ///
	taxrate subcty_total_taxes_pc subcty_total_expenditure_pc eitc_exposure tax_st_diff_top20 ///
	ccd_exp_tot ccd_pup_tch_ratio score_r dropout_r ///
	num_inst_pc tuition gradrate_r ///
	cs_labforce cs_elf_ind_man frac_worked1416 ///
	mig_inflow mig_outflow cs_born_foreign ///
	scap_ski90pcm rel_tot crime_violent ///
	cs_fam_wkidsinglemom cs_divorced cs_married ///
	median_house_value median_rent 
		
** Inflation scaling for rental data
import delimited "${dropbox}/movers/analysis/covariates/CPIAUCSL", clear
qui {
sum cpi if date == 2000
local 2000 = r(mean)
sum cpi if date == 2012
local 2012 = r(mean)
global inflate = `2012' / `2000'
}
	
foreach outcome in "kr26" {
foreach spec in "_cc2"{
foreach p in "25" "75" {
	
	* 1) Extract signal Var at the CZ level: 
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff}
	
	*Drop all obs with missing values of stayers, which are necessary for decomposition into sorting and causal
	keep if e_rank_b_`outcome'_p`p'~=.
	
	*Generate variances and precision weights
	g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_bs_se^2
	g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs
	
	* estimate signal and noise variances
	qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs_cz = r(mean)

	qui sum Bj_p`p'_cz`outcome'`spec' [w=${weight}],d
	global totvar_cz = r(Var)
	
	global sigvar_cz = $totvar_cz-$noisevar_bs_cz

	* 2) County estimates
	* define matrix to store results 
	mat define ctyreg`outcome'`spec'_p`p'=J(39,9,.)
	local row =1
	matrix rownames ctyreg`outcome'`spec'_p`p'= ${varlist}
	
	* use beta dataset
	use "${cty_data}", clear
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_bs_se)
	
	keep if cz_pop2000 >= ${cz_pop_cutoff}
	keep if cty_pop2000 >= ${cty_pop_cutoff}
	
	** Define median rent to be at given income level
	if "`p'" == "25" {
	gen median_rent = med_rent_bm 
	gen median_rent_st = med_rent_bm_st
	gen median_house_value = med_house_price_am
	gen median_house_value_st = med_house_price_am_st
	}
	else if "`p'" == "75" {
	gen median_rent = med_rent_am
	gen median_rent_st = med_rent_am_st
	gen median_house_value = med_house_price_bm
	gen median_house_value_st = med_house_price_bm_st
	}
	replace median_rent = median_rent * ${inflate}
	replace median_house_value = median_house_value * ${inflate}

	* compute CZ plus CTY variance
	g Bj_p`p'_czct_`outcome'`spec'_bs_se = sqrt(Bj_p`p'_cty_`outcome'`spec'_se^2+(Bj_p`p'_cz`outcome'`spec'_bs_se^2))
	replace Bj_p`p'_czct_`outcome'`spec'_bs_se = Bj_p`p'_cz`outcome'`spec'_bs_se if Bj_p`p'_czct_`outcome'`spec'_bs_se ==. & Bj_p`p'_cz_cty_`outcome'`spec'~=.
	rename Bj_p`p'_cz_cty_`outcome'`spec' Bj_p`p'_czct`outcome'`spec'
	
	*Drop all obs with missing values of stayers, which are necessary for decomposition into sorting and causal
	keep if e_rank_b_`outcome'_p`p'~=.

	*Generate variances and precision weights
	g Bj_var_p`p'_czct`outcome'`spec'_bs = Bj_p`p'_czct_`outcome'`spec'_bs_se ^2
	g precwt = 1/Bj_var_p`p'_czct`outcome'`spec'_bs

	* estimate noise variances 
	qui sum Bj_var_p`p'_czct`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)

	*Calculate total variance, accounting for df correction due to CZ fixed effects
	su Bj_p`p'_czct`outcome'`spec' [w=${weight}], d
	global totvar=r(Var)

	global sigvar = $totvar-$noisevar_bs
	
	* Estimating signal SD of county within cz
	global sigsd_within = sqrt(${sigvar} - ${sigvar_cz})
	
	*Estimates of causal and sorting effects
	g causal_raw_`p' = ${scale_factor}*Bj_p`p'_czct`outcome'`spec'
	g sorting_raw_`p' = e_rank_b_`outcome'_p`p'-causal_raw_`p'
	
	* Correlations with Observables
	foreach var of global varlist {
	
	sum `var' [w=${reg_weight}]
	global st_dev = r(sd)
	mat def ctyreg`outcome'`spec'_p`p'[`row',1] = ${st_dev}
	
	qui areg Bj_p`p'_czct`outcome'`spec' `var'_st [w=${reg_weight}], absorb(${clvar}) cluster(${clvar})
	mat def ctyreg`outcome'`spec'_p`p'[`row',2] = _b[`var'_st]/${sigsd_within}
	mat def ctyreg`outcome'`spec'_p`p'[`row',3] = _se[`var'_st]/${sigsd_within}
	
	qui areg e_rank_b_`outcome'_p`p' `var'_st [w=${reg_weight}], absorb(${clvar}) cluster(${clvar})
	mat def ctyreg`outcome'`spec'_p`p'[`row',4] = _b[`var'_st]
	mat def ctyreg`outcome'`spec'_p`p'[`row',5] = _se[`var'_st]
	
	qui areg causal_raw_`p' `var'_st [w=${reg_weight}], absorb(${clvar}) cluster(${clvar})
	mat def ctyreg`outcome'`spec'_p`p'[`row',6] = _b[`var'_st]
	mat def ctyreg`outcome'`spec'_p`p'[`row',7] = _se[`var'_st]
	
	qui areg sorting_raw_`p' `var'_st [w=${reg_weight}], absorb(${clvar}) cluster(${clvar})
	mat def ctyreg`outcome'`spec'_p`p'[`row',8] = _b[`var'_st]
	mat def ctyreg`outcome'`spec'_p`p'[`row',9] = _se[`var'_st]
	local row = `row'+1
	}
	
	* store results in the ctyreg matrix
	clear
	svmat2 ctyreg`outcome'`spec'_p`p', rnames(variables)
	gen number = [_n]
	rename ctyreg`outcome'`spec'_p`p'1 std_dev_`outcome'`spec'_p`p'
	rename ctyreg`outcome'`spec'_p`p'2 coef_corr_`outcome'`spec'_p`p'
	rename ctyreg`outcome'`spec'_p`p'3 se_corr_`outcome'`spec'_p`p'
	rename ctyreg`outcome'`spec'_p`p'4 coef_stayers_`outcome'`spec'_p`p'
	rename ctyreg`outcome'`spec'_p`p'5 se_stayers_`outcome'`spec'_p`p'
	rename ctyreg`outcome'`spec'_p`p'6 coef_causal_`outcome'`spec'_p`p'
	rename ctyreg`outcome'`spec'_p`p'7 se_causal_`outcome'`spec'_p`p'
	rename ctyreg`outcome'`spec'_p`p'8 coef_sorting_`outcome'`spec'_p`p'
	rename ctyreg`outcome'`spec'_p`p'9 se_sorting_`outcome'`spec'_p`p'
	order number variables std* coef_corr* se_corr* coef_stayers* se_stayers* coef_causal* se_causal* coef_sorting* se_sorting*
	tempfile ctyreg_`outcome'`spec'_p`p'
	save `ctyreg_`outcome'`spec'_p`p''
	
	* organize the output 
	drop number
	
	if "`p'"=="25"{
	export delimited "${tables}/app_table_12", replace  

	}
	if "`p'"=="75"{
	export delimited "${tables}/app_table_14", replace  
	}
	
}
}
}

** Table 5 Association Between Rents and Causal Effects on Children's Incomes for Low-Income Families						

** Log file
cap log close
log using "${logs}/table5log", replace

clear all
macro drop cutvar cz_cut weight var_cap
global var_cap =.
global cutvar "frac_traveltime_lt15"
global cz_min = 25000
global cty_min = 1e4

** Relevant factors and specs
local outcome = "kr26"
local spec = "_cc2"
local p 25
global factor = ${ctycz_signal_sd_p`p'}
global cz_factor = ${cz_signal_sd_p`p'}
global namelist CZ County County_Large High_Segregation Low_Segregation ///
	Observables Nonobservables

** Inflation scaling for rental data
import delimited "${dropbox}/movers/analysis/covariates/CPIAUCSL", clear
qui {
sum cpi if date == 2000
local 2000 = r(mean)
sum cpi if date == 2012
local 2012 = r(mean)
global inflate = `2012' / `2000'
}

mat define signal_r2=J(7,3,.)
matrix rownames signal_r2= ${namelist}

*** CZ Level Column 1 ***
** Weighting by precision
global weight pop2000

** Load cz data
use "${cz_data}", clear
keep if pop2000 >= ${cz_min}
	
** Define median rent to be at given income level
if "`p'" == "25" {
	gen median_rent = med_rent_bm
}
else if "`p'" == "75" {
	gen median_rent = med_rent_am
}

replace median_rent = median_rent * ${inflate}
	
** Generate variances and precision weights
g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_bs_se ^2
g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs

** Shrunk (RMSE-minimizing) estimates
** Use CZ signal SD from table 2
g shrinkage_raw = (${cz_factor})^2/((${cz_factor})^2 + Bj_var_p`p'_cz`outcome'`spec'_bs)
g Bj_shrunk_raw_`outcome'_p`p' = shrinkage_raw*Bj_p`p'_cz`outcome'`spec'
replace Bj_shrunk_raw_`outcome'_p`p' = Bj_shrunk_raw_`outcome'_p`p' * ${pctgain_p`p'_`outcome'}

** Column 1 Regression
_eststo: reg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}], cluster(cz)
	
** df correction for SD of RHS variables
su Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample)
mat def signal_r2[1,3] = `r(sd)'

preserve
su Bj_p`p'_cz`outcome'`spec' [w=${weight}]
local sd = r(sd)
corr median_rent Bj_p`p'_cz`outcome'`spec' [w=${weight}]
local signal_r2 =  "`=(r(rho)*`sd'/${cz_factor})^2'"
sum median_rent [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[1,1] = `signal_r2'
mat def signal_r2[1,2] = `mean_rent'

*** County Level for Columns 2 and 3 ***	
** 100 Largest CZ restriction for column 3 through 5
global cz_cut = 5.9e5
global weight cty_pop2000

** use beta dataset
use "${cty_data}", clear
keep if cz_pop2000 >= $cz_min
keep if cty_pop2000 >= $cty_min

** Define rent at appropriate income level
if "`p'" == "25" {
	gen median_rent = med_rent_bm
}
else if "`p'" == "75" {
	gen median_rent = med_rent_am
}
replace median_rent = median_rent * ${inflate}
	
** Generate variances and precision weights
g Bj_var_p`p'_cty_`outcome'`spec'_se = Bj_p`p'_cty_`outcome'`spec'_se ^2
g precwt = 1/Bj_var_p`p'_cty_`outcome'`spec'_se

** Use CTY within CZ signal SD from table 2	
gen shrinkage = (${factor})^2/((${factor})^2 + Bj_var_p`p'_cty_`outcome'`spec'_se)
gen Bj_shrunk_raw_`outcome'_p`p' = shrinkage*Bj_p`p'_cty_`outcome'`spec'
replace Bj_shrunk_raw_`outcome'_p`p' = Bj_shrunk_raw_`outcome'_p`p' * ${pctgain_p`p'_`outcome'}

** Regression for column 2
_eststo: areg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}], a(cz) cluster(cz)	

** df correction for SD of RHS variable
areg Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample), a(cz)
mat def signal_r2[2,3] = `e(rmse)'

preserve
areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] , a(cz)
predict med_rent_resid if e(sample), res

** Nathan's method for signal r2
areg med_rent_resid mu_resid [w=${weight}] if e(sample) , absorb(cz)
global coeff = _b[mu_resid]
areg med_rent_resid [w=${weight}] if e(sample) , absorb(cz)
global med_rent_sd = e(rmse)
areg mu_resid [w=${weight}] if e(sample) , absorb(cz)
global mu_resid_sd = e(rmse)
global corr = ($coeff * $mu_resid_sd / $med_rent_sd) 
global sig_r2_alt = ($corr * $mu_resid_sd / ${factor})^2 

local signal_r2 = $sig_r2_alt
sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[2,1] = `signal_r2'
mat def signal_r2[2,2] = `mean_rent'

** Regression for column 3 - 100 largest CZs
_eststo: areg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if cz_pop2000>${cz_cut}, absorb(cz) cluster(cz)	

** df correction for SD of RHS variable
areg Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample), a(cz)
mat def signal_r2[3,3] = `e(rmse)'
	
preserve
keep if cz_pop2000 > ${cz_cut}
areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] , a(cz)
predict med_rent_resid if e(sample), res

** Nathan's method for signal r2
areg med_rent_resid mu_resid [w=${weight}] if e(sample) , absorb(cz)
global coeff = _b[mu_resid]
areg med_rent_resid [w=${weight}] if e(sample) , absorb(cz)
global med_rent_sd = e(rmse)
areg mu_resid [w=${weight}] if e(sample) , absorb(cz)
global mu_resid_sd = e(rmse)
global corr = ($coeff * $mu_resid_sd / $med_rent_sd) 
global sig_r2_alt = ($corr * $mu_resid_sd / ${factor})^2 
local signal_r2 = $sig_r2_alt

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[3,1] = `signal_r2'
mat def signal_r2[3,2] = `mean_rent'

** SEGREGATED CITIES VS. NONSEGREGATED CITIES
preserve 
collapse (mean) ${cutvar} cz_pop2000 [w=cty_pop] if cz_pop2000 > ${cz_cut}  , by(cz)
su ${cutvar} if cz_pop2000 > $cz_cut, d
g seg_cz = ${cutvar} < r(p50) 
keep cz seg_cz
tempfile temp
save `temp' , replace
restore
merge m:1 cz using `temp' , nogen
	
** Regression coefficient needed in the text for seg_cz == 1
areg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if cz_pop2000 > $cz_cut & seg_cz == 1 , absorb(cz)
di in red "Regression coefficient for seg_cz == 1 " `_b[Bj_shrunk_raw_`outcome'_p`p']'

** df correction for SD of RHS variable	
areg Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample), a(cz)
mat def signal_r2[4,3] = `e(rmse)'
	
preserve	
keep if cz_pop2000 > $cz_cut & seg_cz == 1
areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] , a(cz)
predict med_rent_resid if e(sample), res

* Nathan's method for signal R-squared
areg med_rent_resid mu_resid [w=${weight}] if e(sample) , absorb(cz)
global coeff = _b[mu_resid]
areg med_rent_resid [w=${weight}] if e(sample) , absorb(cz)
global med_rent_sd = e(rmse)
areg mu_resid [w=${weight}] if e(sample) , absorb(cz)
global mu_resid_sd = e(rmse)
global corr = ($coeff * $mu_resid_sd / $med_rent_sd) 
global sig_r2_alt = ($corr * $mu_resid_sd / ${factor})^2 
local signal_r2 = $sig_r2_alt

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[4,1] = `signal_r2'
mat def signal_r2[4,2] = `mean_rent'
	
** Regression coefficient needed in the text for seg_cz == 0
areg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if cz_pop2000 > $cz_cut & seg_cz == 0 , absorb(cz)
di in red "Regression coefficient for seg_cz == 0 " `_b[Bj_shrunk_raw_`outcome'_p`p']'

** df correction for SD of RHS variable
areg Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample), a(cz)
mat def signal_r2[5,3] = `e(rmse)'
	
preserve	
keep if cz_pop2000 > $cz_cut & seg_cz == 0
areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] , a(cz)
predict med_rent_resid if e(sample), res

* Nathan's method for signal R-squared
areg med_rent_resid mu_resid [w=${weight}] if e(sample) , absorb(cz)
global coeff = _b[mu_resid]
areg med_rent_resid [w=${weight}] if e(sample) , absorb(cz)
global med_rent_sd = e(rmse)
areg mu_resid [w=${weight}] if e(sample) , absorb(cz)
global mu_resid_sd = e(rmse)
global corr = ($coeff * $mu_resid_sd / $med_rent_sd) 
global sig_r2_alt = ($corr * $mu_resid_sd / ${factor})^2 
local signal_r2 = $sig_r2_alt
di in red "`signal_r2'"

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[5,1] = `signal_r2'
mat def signal_r2[5,2] = `mean_rent'

** Columns 4 and 5
** Observable vs. Unobservable Characteristics
** Define observable characteristics
local obs = "cs_race_bla cs_race_theil_2000 gini cs_fam_wkidsinglemom scap_ski90pcm ccd_exp_tot"

** use cty beta dataset
use "${cty_data}", clear
keep if cz_pop2000 >= $cz_min
keep if cty_pop2000 >= $cty_min

** Define rent at appropriate income level
if "`p'" == "25" {
	gen median_rent = med_rent_bm
}
else if "`p'" == "75" {
	gen median_rent = med_rent_am
}

replace median_rent = median_rent * ${inflate}
	
** Generate variances and precision weights
g Bj_var_p`p'_cty_`outcome'`spec'_se = Bj_p`p'_cty_`outcome'`spec'_se ^2
g precwt = 1/Bj_var_p`p'_cty_`outcome'`spec'_se
	
** Construct observable portion of raw values
areg Bj_p`p'_cty_`outcome'`spec' `obs' [w=${weight}] if cz_pop > $cz_cut, a(cz)
cap drop bj_obs bj_res
predict Bj_obs if cz_pop > $cz_cut & e(sample), xb
predict Bj_res if cz_pop > $cz_cut & e(sample), r
	 
areg Bj_obs [w=${weight}] if cz_pop > $cz_cut , a(cz)
global obs_var = (e(rmse))^2

** Use signal SD from table 2
global resid_var = (${factor})^2 - ${obs_var}
global SD_bj_res_true = sqrt(($factor)^2 - $obs_var) 

gen shrinkage = ${resid_var}/(${resid_var}+Bj_var_p`p'_cty_`outcome'`spec'_se)
gen residual_shrunk = shrinkage*Bj_res
	
foreach var of varlist Bj_obs residual_shrunk{
		replace `var' = `var' * ${pctgain_p`p'_`outcome'}
}

	
** Regression for column 4
_eststo: areg median_rent Bj_obs if cz_pop > $cz_cut [w=${weight}], a(cz)

** df correction for SD of RHS variable	
areg Bj_obs [w=${weight}] if e(sample), a(cz)
mat def signal_r2[6,3] = `e(rmse)'
	
preserve
keep if cz_pop2000 > ${cz_cut}
areg Bj_obs [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] if e(sample), a(cz)
predict med_rent_resid if e(sample), res

** Nathan's updated methods for R-squared
areg mu_resid med_rent_resid [w=${weight}] , a(cz)
global coeff = _b[med_rent_resid] 
areg median_rent [w=${weight}] if e(sample), a(cz)
global sd_rent_rmse = e(rmse)
areg mu_resid [w=${weight}] if e(sample), a(cz)
global sd_mu_rmse = e(rmse)
global corr = $coeff * $sd_rent_rmse / $sd_mu_rmse
local signal_r2 = ($corr)^2

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[6,1] = `signal_r2'
mat def signal_r2[6,2] = `mean_rent'

** Regression for column 5
_eststo: areg median_rent residual_shrunk if cz_pop > $cz_cut [w=${weight}], a(cz)

** df correction for SD of RHS variable
areg residual_shrunk [w=${weight}] if e(sample), a(cz)
mat def signal_r2[7,3] = `e(rmse)'

preserve
keep if cz_pop2000 > ${cz_cut}
areg median_rent $obs [w=${weight}] , a(cz)
predict med_rent_temp if cz_pop > $cz_cut & e(sample), r
areg med_rent_temp [w=${weight}] if cz_pop > $cz_cut & e(sample), a(cz)
predict med_rent_res if cz_pop > $cz_cut & e(sample), r

* Alternative method for signal r2
reg Bj_res [w=${weight}] if cz_pop > $cz_cut , a(cz)
predict mu_resid if cz_pop > $cz_cut & e(sample), r
global sd_mu_rmse = e(rmse)

global tot_var = ((${ctycz_signal_sd_p`p'})^2)*(1-`signal_r2')
corr med_rent_res mu_resid [w=${weight}] 
global corr = r(rho) * $sd_mu_rmse / sqrt($tot_var)
local signal_r2 = ($corr)^2

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[7,1] = `signal_r2'
mat def signal_r2[7,2] = `mean_rent'

*** Export Coefficients
esttab using "${tables}/table50_raw.csv", se replace nonotes star(* 0.05 ** 0.01 *** 0.001) ///
	nocons mtitles(CZ County County_LargeCZ Observables Unobservables)  

clear	
svmat2 signal_r2, rnames(variables)
export delimited "${tables}/table51_raw.csv", replace


********************************************************************
**Apendix Table 15: Association Between Rents and Causal Effects on Children's Incomes for High-Income Families						


clear all
macro drop cutvar cz_cut weight var_cap
global var_cap =.
global cutvar "frac_traveltime_lt15"
global cz_min = 25000
global cty_min = 1e4

** Relevant factors and specs
local outcome = "kr26"
local spec = "_cc2"
local p 75
global factor = ${ctycz_signal_sd_p`p'}
global cz_factor = ${cz_signal_sd_p`p'}
global namelist CZ County County_Large High_Segregation Low_Segregation ///
	Observables Nonobservables

** Inflation scaling for rental data
import delimited "${dropbox}/movers/analysis/covariates/CPIAUCSL", clear
qui {
sum cpi if date == 2000
local 2000 = r(mean)
sum cpi if date == 2012
local 2012 = r(mean)
global inflate = `2012' / `2000'
}

mat define signal_r2=J(7,3,.)
matrix rownames signal_r2= ${namelist}

*** CZ Level Column 1 ***
** Weighting by precision
global weight pop2000

** Load cz data
use "${cz_data}", clear
keep if pop2000 >= ${cz_min}
	
** Define median rent to be at given income level
if "`p'" == "25" {
	gen median_rent = med_rent_bm
}
else if "`p'" == "75" {
	gen median_rent = med_rent_am
}

replace median_rent = median_rent * ${inflate}
	
** Generate variances and precision weights
g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_bs_se ^2
g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs

** Shrunk (RMSE-minimizing) estimates
** Use CZ signal SD from table 2
g shrinkage_raw = (${cz_factor})^2/((${cz_factor})^2 + Bj_var_p`p'_cz`outcome'`spec'_bs)
g Bj_shrunk_raw_`outcome'_p`p' = shrinkage_raw*Bj_p`p'_cz`outcome'`spec'
replace Bj_shrunk_raw_`outcome'_p`p' = Bj_shrunk_raw_`outcome'_p`p' * ${pctgain_p`p'_`outcome'}

** Column 1 Regression
_eststo: reg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}], cluster(cz)
	
** df correction for SD of RHS variables
su Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample)
mat def signal_r2[1,3] = `r(sd)'

preserve
su Bj_p`p'_cz`outcome'`spec' [w=${weight}]
local sd = r(sd)
corr median_rent Bj_p`p'_cz`outcome'`spec' [w=${weight}]
local signal_r2 =  "`=(r(rho)*`sd'/${cz_factor})^2'"
sum median_rent [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[1,1] = `signal_r2'
mat def signal_r2[1,2] = `mean_rent'

*** County Level for Columns 2 and 3 ***	
** 100 Largest CZ restriction for column 3 through 5
global cz_cut = 5.9e5
global weight cty_pop2000

** use beta dataset
use "${cty_data}", clear
keep if cz_pop2000 >= $cz_min
keep if cty_pop2000 >= $cty_min

** Define rent at appropriate income level
if "`p'" == "25" {
	gen median_rent = med_rent_bm
}
else if "`p'" == "75" {
	gen median_rent = med_rent_am
}
replace median_rent = median_rent * ${inflate}
	
** Generate variances and precision weights
g Bj_var_p`p'_cty_`outcome'`spec'_se = Bj_p`p'_cty_`outcome'`spec'_se ^2
g precwt = 1/Bj_var_p`p'_cty_`outcome'`spec'_se

** Use CTY within CZ signal SD from table 2	
gen shrinkage = (${factor})^2/((${factor})^2 + Bj_var_p`p'_cty_`outcome'`spec'_se)
gen Bj_shrunk_raw_`outcome'_p`p' = shrinkage*Bj_p`p'_cty_`outcome'`spec'
replace Bj_shrunk_raw_`outcome'_p`p' = Bj_shrunk_raw_`outcome'_p`p' * ${pctgain_p`p'_`outcome'}

** Regression for column 2
_eststo: areg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}], a(cz) cluster(cz)	

** df correction for SD of RHS variable
areg Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample), a(cz)
mat def signal_r2[2,3] = `e(rmse)'

preserve
areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] , a(cz)
predict med_rent_resid if e(sample), res

** Nathan's method for signal r2
areg med_rent_resid mu_resid [w=${weight}] if e(sample) , absorb(cz)
global coeff = _b[mu_resid]
areg med_rent_resid [w=${weight}] if e(sample) , absorb(cz)
global med_rent_sd = e(rmse)
areg mu_resid [w=${weight}] if e(sample) , absorb(cz)
global mu_resid_sd = e(rmse)
global corr = ($coeff * $mu_resid_sd / $med_rent_sd) 
global sig_r2_alt = ($corr * $mu_resid_sd / ${factor})^2 

local signal_r2 = $sig_r2_alt
sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[2,1] = `signal_r2'
mat def signal_r2[2,2] = `mean_rent'

** Regression for column 3 - 100 largest CZs
_eststo: areg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if cz_pop2000>${cz_cut}, absorb(cz) cluster(cz)	

** df correction for SD of RHS variable
areg Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample), a(cz)
mat def signal_r2[3,3] = `e(rmse)'
	
preserve
keep if cz_pop2000 > ${cz_cut}
areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] , a(cz)
predict med_rent_resid if e(sample), res

** Nathan's method for signal r2
areg med_rent_resid mu_resid [w=${weight}] if e(sample) , absorb(cz)
global coeff = _b[mu_resid]
areg med_rent_resid [w=${weight}] if e(sample) , absorb(cz)
global med_rent_sd = e(rmse)
areg mu_resid [w=${weight}] if e(sample) , absorb(cz)
global mu_resid_sd = e(rmse)
global corr = ($coeff * $mu_resid_sd / $med_rent_sd) 
global sig_r2_alt = ($corr * $mu_resid_sd / ${factor})^2 
local signal_r2 = $sig_r2_alt

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[3,1] = `signal_r2'
mat def signal_r2[3,2] = `mean_rent'

** SEGREGATED CITIES VS. NONSEGREGATED CITIES 
preserve 
collapse (mean) ${cutvar} cz_pop2000 [w=cty_pop] if cz_pop2000 > ${cz_cut}  , by(cz)
su ${cutvar} if cz_pop2000 > $cz_cut, d
g seg_cz = ${cutvar} < r(p50) 
keep cz seg_cz
tempfile temp
save `temp' , replace
restore
merge m:1 cz using `temp' , nogen
	
** Regression coefficient needed in the text for seg_cz == 1
areg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if cz_pop2000 > $cz_cut & seg_cz == 1 , absorb(cz)
di in red "Regression coefficient for seg_cz == 1 " `_b[Bj_shrunk_raw_`outcome'_p`p']'

** df correction for SD of RHS variable	
areg Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample), a(cz)
mat def signal_r2[4,3] = `e(rmse)'
	
preserve	
keep if cz_pop2000 > $cz_cut & seg_cz == 1
areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] , a(cz)
predict med_rent_resid if e(sample), res

* Nathan's method for signal R-squared
areg med_rent_resid mu_resid [w=${weight}] if e(sample) , absorb(cz)
global coeff = _b[mu_resid]
areg med_rent_resid [w=${weight}] if e(sample) , absorb(cz)
global med_rent_sd = e(rmse)
areg mu_resid [w=${weight}] if e(sample) , absorb(cz)
global mu_resid_sd = e(rmse)
global corr = ($coeff * $mu_resid_sd / $med_rent_sd) 
global sig_r2_alt = ($corr * $mu_resid_sd / ${factor})^2 
local signal_r2 = $sig_r2_alt

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[4,1] = `signal_r2'
mat def signal_r2[4,2] = `mean_rent'
	
** Regression coefficient needed in the text for seg_cz == 0
areg median_rent Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if cz_pop2000 > $cz_cut & seg_cz == 0 , absorb(cz)
di in red "Regression coefficient for seg_cz == 0 " `_b[Bj_shrunk_raw_`outcome'_p`p']'

** df correction for SD of RHS variable
areg Bj_shrunk_raw_`outcome'_p`p' [w=${weight}] if e(sample), a(cz)
mat def signal_r2[5,3] = `e(rmse)'
	
preserve	
keep if cz_pop2000 > $cz_cut & seg_cz == 0
areg Bj_p`p'_cty_`outcome'`spec' [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] , a(cz)
predict med_rent_resid if e(sample), res

* Nathan's method for signal R-squared
areg med_rent_resid mu_resid [w=${weight}] if e(sample) , absorb(cz)
global coeff = _b[mu_resid]
areg med_rent_resid [w=${weight}] if e(sample) , absorb(cz)
global med_rent_sd = e(rmse)
areg mu_resid [w=${weight}] if e(sample) , absorb(cz)
global mu_resid_sd = e(rmse)
global corr = ($coeff * $mu_resid_sd / $med_rent_sd) 
global sig_r2_alt = ($corr * $mu_resid_sd / ${factor})^2 
local signal_r2 = $sig_r2_alt
di in red "`signal_r2'"

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[5,1] = `signal_r2'
mat def signal_r2[5,2] = `mean_rent'

** Columns 4 and 5
** Observable vs. Unobservable Characteristics
** Define observable characteristics
local obs = "cs_race_bla cs_race_theil_2000 gini cs_fam_wkidsinglemom scap_ski90pcm ccd_exp_tot"

** use cty beta dataset
use "${cty_data}", clear
keep if cz_pop2000 >= $cz_min
keep if cty_pop2000 >= $cty_min

** Define rent at appropriate income level
if "`p'" == "25" {
	gen median_rent = med_rent_bm
}
else if "`p'" == "75" {
	gen median_rent = med_rent_am
}

replace median_rent = median_rent * ${inflate}
	
** Generate variances and precision weights
g Bj_var_p`p'_cty_`outcome'`spec'_se = Bj_p`p'_cty_`outcome'`spec'_se ^2
g precwt = 1/Bj_var_p`p'_cty_`outcome'`spec'_se
	
** Construct observable portion of raw values
areg Bj_p`p'_cty_`outcome'`spec' `obs' [w=${weight}] if cz_pop > $cz_cut, a(cz)
cap drop bj_obs bj_res
predict Bj_obs if cz_pop > $cz_cut & e(sample), xb
predict Bj_res if cz_pop > $cz_cut & e(sample), r
	 
areg Bj_obs [w=${weight}] if cz_pop > $cz_cut , a(cz)
global obs_var = (e(rmse))^2

** Use signal SD from table 2
global resid_var = (${factor})^2 - ${obs_var}
global SD_bj_res_true = sqrt(($factor)^2 - $obs_var) 

gen shrinkage = ${resid_var}/(${resid_var}+Bj_var_p`p'_cty_`outcome'`spec'_se)
gen residual_shrunk = shrinkage*Bj_res
	
foreach var of varlist Bj_obs residual_shrunk{
		replace `var' = `var' * ${pctgain_p`p'_`outcome'}
}

	
** Regression for column 4
_eststo: areg median_rent Bj_obs if cz_pop > $cz_cut [w=${weight}], a(cz)

** df correction for SD of RHS variable	
areg Bj_obs [w=${weight}] if e(sample), a(cz)
mat def signal_r2[6,3] = `e(rmse)'
	
preserve
keep if cz_pop2000 > ${cz_cut}
areg Bj_obs [w=${weight}], a(cz)
predict mu_resid if e(sample), res
areg median_rent [w=${weight}] if e(sample), a(cz)
predict med_rent_resid if e(sample), res

** Nathan's updated methods for R-squared
areg mu_resid med_rent_resid [w=${weight}] , a(cz)
global coeff = _b[med_rent_resid] 
areg median_rent [w=${weight}] if e(sample), a(cz)
global sd_rent_rmse = e(rmse)
areg mu_resid [w=${weight}] if e(sample), a(cz)
global sd_mu_rmse = e(rmse)
global corr = $coeff * $sd_rent_rmse / $sd_mu_rmse
local signal_r2 = ($corr)^2

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[6,1] = `signal_r2'
mat def signal_r2[6,2] = `mean_rent'

** Regression for column 5
_eststo: areg median_rent residual_shrunk if cz_pop > $cz_cut [w=${weight}], a(cz)

** df correction for SD of RHS variable
areg residual_shrunk [w=${weight}] if e(sample), a(cz)
mat def signal_r2[7,3] = `e(rmse)'

preserve
keep if cz_pop2000 > ${cz_cut}
areg median_rent $obs [w=${weight}] , a(cz)
predict med_rent_temp if cz_pop > $cz_cut & e(sample), r
areg med_rent_temp [w=${weight}] if cz_pop > $cz_cut & e(sample), a(cz)
predict med_rent_res if cz_pop > $cz_cut & e(sample), r

* Alternative method for signal r2
reg Bj_res [w=${weight}] if cz_pop > $cz_cut , a(cz)
predict mu_resid if cz_pop > $cz_cut & e(sample), r
global sd_mu_rmse = e(rmse)

global tot_var = ((${ctycz_signal_sd_p`p'})^2)*(1-`signal_r2')
corr med_rent_res mu_resid [w=${weight}] 
global corr = r(rho) * $sd_mu_rmse / sqrt($tot_var)
local signal_r2 = ($corr)^2

sum median_rent if e(sample) [w=${weight}]
local mean_rent = r(mean)
restore	
mat def signal_r2[7,1] = `signal_r2'
mat def signal_r2[7,2] = `mean_rent'

*** Export Coefficients
esttab using "${tables}/app_tab_16_raw.csv", se replace nonotes star(* 0.05 ** 0.01 *** 0.001) ///
	nocons mtitles(CZ County County_LargeCZ Observables Unobservables)

clear	
svmat2 signal_r2, rnames(variables)
export delimited "${tables}/app_tab_162_raw.csv", replace
