* This program reproduces figures from the paper 
* The Impacts of Neighborhoods on Intergenerational Mobility II: County-Level Estimates 
* Raj Chetty and Nathaniel Hendren 

* Figure Extension
global image_suffix png

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

****************************** MAIN FIGURES ************************************

* FIGURE I: Causal Effect Estimates vs. Permanent Residents’ Outcomes for Low-Income Families

local p = "25"
local outcome = "kr26"
local spec = "_cc2"

/* Panel A Across Commuting Zones */

use "${cz_data}", clear
g beta_cz_p25 = Bj_p25_czkr26_cc2
g beta_cz_p25_se = Bj_p25_czkr26_cc2_bs_se

g precwt = (1/beta_cz_p25_se)^2
global ymax = .5
g beta_low = max(beta_cz_p25 - 1.96 * beta_cz_p25_se,-$ymax)
g beta_high = min(beta_cz_p25 + 1.96 * beta_cz_p25_se,$ymax)

label var beta_cz_p25 "Causal Effect" 

reg beta_cz_p25 e_rank_b_kr26_p25  [w=precwt]
predict beta_predict , xb

global poptop 2500000
global y_max .5
global y_min -.5
global x_max 48
global x_min 38

twoway (scatter beta_cz_p25 e_rank_b_`outcome'_p`p' if inrange(e_rank_b_`outcome'_p`p',${x_min},${x_max}) & inrange(beta_cz_p25,${y_min},${y_max}) , msize(tiny) mcolor(gs12)) ///
	(scatter beta_cz_p25 e_rank_b_`outcome'_p`p' if pop2000 > $poptop, mlabel(czname) mlabcolor(black) mcolor(navy)) ///
	(rcap beta_low beta_high e_rank_b_`outcome'_p`p' if pop2000 > $poptop, lwidth(vthin) lpattern(dash) lcolor(navy))  ///
	(line beta_predict e_rank_b_`outcome'_p`p' if inrange(e_rank_b_`outcome'_p`p',${x_min},${x_max}) & inrange(beta_cz_p25,${y_min},${y_max}) , lcolor(navy) )  ///	
	, graphregion(color(white)) legend(off) ///
	ytitle("Causal Effect of One Year of Exposure on Mean Rank") ///
	xtitle("Mean Rank of Children of Permanent Residents at p=25") ///
	name(fig1a, replace) ylabel(, format(%3.1f)) 
graph export "${figures}/fig1a.${image_suffix}" , replace

/* Panel B Across Counties */

local p = "25"
local outcome = "kr26"
local spec = "_cc2"

use "${cty_data}", clear
merge m:1 cz using "${cz_data}" , keepusing(czname Bj_p*_czkr26_cc2 Bj_p*_czkr26_cc2_bs_se)

g beta_cty_p25 = Bj_p`p'_cz_cty_`outcome'`spec'
g beta_cty_p25_se = sqrt(Bj_p`p'_cty_`outcome'`spec'_se^2+(Bj_p`p'_cz`outcome'`spec'_bs_se^2))
	
g precwt = (1/beta_cty_p25_se)^2
global ymax = 1
g beta_low = max(beta_cty_p25 - 1.96 * beta_cty_p25_se,-$ymax)
g beta_high = min(beta_cty_p25 + 1.96 * beta_cty_p25_se,$ymax)

label var beta_cty_p25 "Causal Effect" 

reg beta_cty_p25 e_rank_b_kr26_p25 [w=precwt]
predict beta_predict , xb

global poptop 500000
global y_max 1
global y_min -1
global x_max 55
global x_min 35

twoway (scatter beta_cty_p25 e_rank_b_`outcome'_p`p' if inrange(e_rank_b_`outcome'_p`p',${x_min},${x_max}) & inrange(beta_cty_p25,${y_min},${y_max}) , msize(tiny) mcolor(gs12)) ///
	(scatter beta_cty_p25 e_rank_b_`outcome'_p`p' if (czname == "New York" | czname == "Newark") & cty_pop2000 > $poptop, mlabel(county_name) mlabcolor(black) mcolor(navy) ) ///
	(rcap beta_low beta_high e_rank_b_`outcome'_p`p' if (czname == "New York" | czname == "Newark") & cty_pop2000 > $poptop, lwidth(vthin) lpattern(dash) lcolor(navy) )  ///
	(line beta_predict e_rank_b_`outcome'_p`p' if inrange(e_rank_b_`outcome'_p`p',${x_min},${x_max}) & inrange(beta_cty_p25,${y_min},${y_max}) , lcolor(navy) )  ///	
	, graphregion(color(white)) legend(off) ///
	ytitle("Causal Effect of One Year of Exposure on Mean Rank") ///
	xtitle("Mean Rank of Children of Permanent Residents at p=25") ///
	name(fig1b, replace)
graph export "${figures}/fig1b.${image_suffix}" ,  replace

* FIGURE II: Sensitivity of Causal Effect Estimates to Controls

* Scatterplot population restrictions
global cz_pop_cutoff 25000
global cty_pop_cutoff 10000
global poptop 25000

* Scatterplot graph range
global y_max 0.5
global y_min -0.5
global x_max 0.5
global x_min -0.5

* Panel A - CZ

local outcome "kr26"
local spec "_pmi_cc2"

foreach ppp in 25 75{
		
	use "${cz_data}", clear
	keep if pop2000 >= ${cz_pop_cutoff}
	
	* Calculate precision weights
	g precwt_reg = 1/ (Bj_p`ppp'_cz`outcome'`spec'_se^2 + Bj_p`ppp'_czkr26_cc2_bs_se^2)

	su Bj_p`ppp'_czkr26_cc2 [w=precwt_reg], d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz`outcome'`spec' [w=precwt_reg], d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates
	reg Bj_p`ppp'_cz`outcome'`spec' Bj_p`ppp'_czkr26_cc2 [w=precwt_reg]
	predict `outcome'`spec'_p`ppp'_pred, xb
	local x1_`outcome'`spec'_`ppp'_rd: di %4.3f _b[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd
	local x2_`outcome'`spec'_`ppp'_rd: di %4.3f _se[Bj_p`ppp'_czkr26_cc2] * $baseline_sd / $alternate_sd
				
	local xvar Bj_p`ppp'_czkr26_cc2
	local yvar Bj_p`ppp'_cz`outcome'`spec'
	twoway (scatter `yvar' `xvar' if inrange(`xvar',${x_min},${x_max}) & inrange(`yvar',${y_min},${y_max}) & pop2000>$poptop, msize(small) mcolor(gs12)) ///
		(line `outcome'`spec'_p`ppp'_pred `xvar' if inrange(`xvar',${x_min},${x_max}) & inrange(`yvar',${y_min},${y_max}) , lcolor(navy) )  ///	
		, ylabel(-0.5(.5).5) xlabel(-0.5(.5).5) graphregion(color(white)) legend(off) ytitle("Estimates Including Additional Controls") ///
		xtitle("Baseline Estimates of Causal Effect on Mean Rank (per Year of Childhood Exposure)") ///
		text(-0.33 0.32 "Correlation: `x1_`outcome'`spec'_`ppp'_rd'") text(-0.38 .32 "`x2_`outcome'`spec'_`ppp'_rd'") 
	if `ppp' == 25{
		graph export "${figures}/fig2a.${image_suffix}" , replace
	}
	else{
		graph export "${figures}/fig2c.${image_suffix}" , replace
	}
}
			
* Panel B - County
local outcome "kr26"
local spec "_pmi_cc2"

foreach ppp in 25 75{
			
	use "${cty_data}", clear
	keep if cty_pop2000 >= ${cty_pop_cutoff} & cz_pop2000 >= ${cz_pop_cutoff}
		
	* Calculate precision weights for regression 
	g precwt_reg_p = 1/ (Bj_p`ppp'_cz_cty_`outcome'`spec'_se^2 + Bj_p`ppp'_cz_cty_kr26_cc2_bs_se^2)

	* Adjust raw correlation and se for ratio of sds
	su Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg], d
	global baseline_sd = r(sd)
	su Bj_p`ppp'_cz_cty_`outcome'`spec' [w=precwt_reg], d
	global alternate_sd = r(sd)

	*Regress on Baseline Estimates
	reg Bj_p`ppp'_cz_cty_`outcome'`spec' Bj_p`ppp'_cz_cty_kr26_cc2 [w=precwt_reg]
	predict `outcome'`spec'_p`ppp'_pred, xb
	local x1_`outcome'`spec'_`ppp'_rd: di %4.3f _b[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd
	local x2_`outcome'`spec'_`ppp'_rd: di %4.3f _se[Bj_p`ppp'_cz_cty_kr26_cc2] * $baseline_sd / $alternate_sd
				
	local xvar Bj_p`ppp'_cz_cty_kr26_cc2
	local yvar Bj_p`ppp'_cz_cty_`outcome'`spec'
	twoway (scatter `yvar' `xvar' if inrange(`xvar',${x_min},${x_max}) & inrange(`yvar',${y_min},${y_max}) & cz_pop2000>$poptop & cty_pop2000>${cty_pop_cutoff}, msize(small) mcolor(gs12)) ///
		(line `outcome'`spec'_p`ppp'_pred `xvar' if inrange(`xvar',${x_min},${x_max}) & inrange(`yvar',${y_min},${y_max}) , lcolor(navy) )  ///	
		, ylabel(-0.5(.5).5) xlabel(-0.5(.5).5) graphregion(color(white)) legend(off) ytitle("Estimates Including Additional Controls") ///
		xtitle("Baseline Estimates of Causal Effect on Mean Rank (per Year of Childhood Exposure)") ///
		text(-0.33 0.32 "Correlation: `x1_`outcome'`spec'_`ppp'_rd'") text(-0.38 .32 "(`x2_`outcome'`spec'_`ppp'_rd')") 
		
	if `ppp' == 25{
		graph export "${figures}/fig2b.${image_suffix}" , replace
	}
	else{
		graph export "${figures}/fig2d.${image_suffix}" , replace
	}
}

* FIGURE III: Construction of Mean-Squared-Error Minimizing Forecasts
local p = "25"
local outcome = "kr26"
local spec = "_cc2"
global cz_pop_cutoff 25000
	
* use beta dataset
use "${cz_data}", clear
keep if pop2000 >= ${cz_pop_cutoff}
		
*Drop all obs with missing values of stayers, which are necessary for predictions
keep if e_rank_b_`outcome'_p`p'~=.

*Generate variances and precision weights
g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_bs_se^2
g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs
		
* estimate signal and noise variances 
qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=precwt]
global noisevar_bs = r(mean)
		
* stayers predictions
qui reg Bj_p`p'_cz`outcome'`spec' e_rank_b_`outcome'_p`p' [w=precwt]
global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
global Rsq_stayers = e(r2)
predict Bj_pred, xb
predict Bj_resid, r
		
g Bj_residsigvar = Bj_resid^2 - Bj_p`p'_cz`outcome'`spec'_bs_se^2
reg Bj_residsigvar Bj_p`p'_cz`outcome'`spec'_bs_se [w=precwt]
		
*Shrunk estimates using stayers predictions
sum Bj_resid [w=precwt]
global resid_sigvar = r(sd)^2 - $noisevar_bs
assert ${resid_sigvar}>0
		
g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_cz`outcome'`spec'_bs)
sum shrinkage [w=precwt],d
g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
		
*Estimate precision of shrunk estimates
g Bj_shrunk_rmse_`outcome'_p`p' = sqrt(1/(1/${resid_sigvar}+1/Bj_var_p`p'_cz`outcome'`spec'_bs))
		
*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
replace Bj_shrunk_rmse_`outcome'_p`p' = sqrt(${resid_sigvar}) if shrinkage==0&Bj_pred~=.
		
g beta_cz_p`p' = Bj_p`p'_czkr26_cc2
g beta_cz_p`p'_se = Bj_p`p'_czkr26_cc2_bs_se

global ymax = .5
g beta_low = max(beta_cz_p`p' - beta_cz_p`p'_se,-$ymax)
g beta_high = min(beta_cz_p`p' + beta_cz_p`p'_se,$ymax)

label var beta_cz_p`p' "Causal Effect" 

reg beta_cz_p`p' e_rank_b_kr26_p`p'  [w=precwt]
predict beta_predict , xb

g y_bar_high = beta_predict + sqrt($resid_sigvar)
g y_bar_low = beta_predict - sqrt($resid_sigvar)

g forecast_high = Bj_shrunk_`outcome'_p`p' + Bj_shrunk_rmse_`outcome'_p`p'
g forecast_low = Bj_shrunk_`outcome'_p`p' - Bj_shrunk_rmse_`outcome'_p`p'

replace czname = "Scranton, PA" if cz==18800
global poptop = 5000000 

replace beta_low = -.3 if cz==26002
drop if czname == "Newark" // drop Newark (the only large CZ we do not plot)

twoway (scatter beta_cz_p`p' e_rank_b_`outcome'_p`p') ///
	 (rcap beta_low beta_high e_rank_b_`outcome'_p`p' , msize(tiny) lwidth(vthin) lpattern(dash) lcolor(navy))  ///
	 (line beta_predict e_rank_b_`outcome'_p`p' , lcolor(navy) ) ///
	 (scatter Bj_shrunk_`outcome'_p`p' e_rank_b_`outcome'_p`p', mlabel(czname) msymbol(diamond) mlabcolor(black) mcolor(cranberry)) ///
	 if pop2000 > $poptop | inlist(cz, 39400, 34901, 11304, 1701, 20401) ///
	, graphregion(color(white)) ytitle("Causal Effect of One Year of Exposure on Mean Rank") xtitle("Mean Rank of Children of Permanent Residents at p=25") ///
	legend(label(1 "Fixed Effect Estimate") label(4 "Optimal Forecast") ///
	label(2 "Std. Error of Fixed Effect") order(1 4 2) ring(1) c(3) pos(6)) ///
	xscale(range(38 48)) name(fig3, replace) xlab(38(2)48) ylab(,format(%3.1f))
graph export "${figures}/fig3.${image_suffix}" ,  replace


* FIGURE IV: Forecasts of Causal Effects on Children’s Income by Commuting Zone
macro drop cz_pop_cutoff weight var_cap varlist 
global cz_pop_cutoff = 25000 
global weight precwt

foreach outcome in "kr26"{
foreach spec in "_cc2"{
foreach p in "25" "75" {
			
	* use beta dataset
	use "${cz_data}", clear
		
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.

	*Generate variances and precision weights
	g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_bs_se^2
	g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs
				
	* estimate noise variances 
	qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)
		
	* stayers predictions
	qui reg Bj_p`p'_cz`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r
		
	*Shrunk estimates using stayers predictions
	sum Bj_resid [w=${weight}]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	assert ${resid_sigvar}>0
		
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_cz`outcome'`spec'_bs)
	sum shrinkage [w=${weight}],d
	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
		
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
		
	replace Bj_shrunk_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20 * ${pctgain_p`p'_`outcome'}
		
	* Maptile maps
	maptile Bj_shrunk_`outcome'_p`p', geo(cz) n(10) rev
	if `p' == 25{
			graph export "${figures}/fig4a.png", replace
	}
	else{
			graph export "${figures}/fig4b.png", replace
	}
}
}
}

* FIGURE V: Forecasts of Causal Effects by County in the New York and Boston Areas
macro drop cty_pop_cutoff cz_pop_cutoff weight var_cap scale_factor 
global cty_pop_cutoff = 10000 
global cz_pop_cutoff = 25000
global weight precwt
global scale_factor 20
		
foreach outcome in "kr26" {
foreach spec in "_cc2"{
foreach p in "25" "75" {

	* use beta dataset
	use "${cty_data}", clear
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_bs_se)

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
		
	* stayers predictions 
	qui reg Bj_p`p'_czct`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r

	*Compute shrunk estimates
	sum Bj_resid [w=precwt]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	assert ${resid_sigvar}>0
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_czct`outcome'`spec'_bs)
	sum shrinkage [w=precwt],d

	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0

	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
		
	replace Bj_shrunk_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20 *  ${pctgain_p`p'_`outcome'}
		
	tempfile Figure14_`outcome'`spec'_`p'	
	sa `Figure14_`outcome'`spec'_`p''
		
	foreach csa in "408" "148" {
		use `Figure14_`outcome'`spec'_`p'', clear
		ren cty county
		maptile Bj_shrunk_`outcome'_p`p', geo(county1990) mapif(csa==`csa') n(10) rev
		graph export "${figures}/fig5_`csa'_p`p'.png", replace
		
	}
}
}
}


* FIGURE VI: Predictors of Place Effects For Children with Parents at 25th Percentile
clear all
macro drop pop_cutoff weight reg_weight var_cap clvar scale_factor varlist
global pop_cutoff 25000
global weight precwt
global reg_weight pop2000
global clvar state_id
global scale_factor 20

global varlist cs_race_bla cs_born_foreign cs_fam_wkidsinglemom scap_ski90pcm ///
			num_inst_pc ccd_exp_tot score_r inc_share_1perc gini frac_traveltime_lt15 cs_race_theil_2000
			
foreach outcome in "kr26" {
foreach spec in "_cc2"{
foreach p in "25" "75" {
		
	* define matrix to store results 
	mat define czreg`outcome'`spec'_p`p'=J(11,2,.)
	local row =1
	matrix rownames czreg`outcome'`spec'_p`p'= ${varlist}
		
	use "${cz_data}", clear
	keep if pop2000 >= ${pop_cutoff}
		
	*Drop all obs with missing values of stayers, which are necessary for decomposition into sorting and causal
	keep if e_rank_b_`outcome'_p`p'~=.
		
	* generate causal estimates (20 years of exposure)
	gen causal_raw_`p' = ${scale_factor}*Bj_p`p'_cz`outcome'`spec'
		
	* Regressions with Observables
	foreach var of global varlist {
		sum `var' [w=${reg_weight}]
		global st_dev = r(sd)
		
		qui reg e_rank_b_`outcome'_p`p' `var'_st [w=${reg_weight}], cluster(${clvar})
		mat def czreg`outcome'`spec'_p`p'[`row',1] = _b[`var'_st]
		
		qui reg causal_raw_`p' `var'_st [w=${reg_weight}], cluster(${clvar})
		mat def czreg`outcome'`spec'_p`p'[`row',2] = _b[`var'_st]

		local row = `row'+1
	}
		
	clear
	svmat2 czreg`outcome'`spec'_p`p', rnames(variables)
	gen number = [_n]
	rename czreg`outcome'`spec'_p`p'1 stayers_`outcome'`spec'_p`p'
	rename czreg`outcome'`spec'_p`p'2 causal_`outcome'`spec'_p`p'
	order number variables
	tempfile czreg_`outcome'`spec'_p`p'
	save `czreg_`outcome'`spec'_p`p''
		
	use `czreg_`outcome'`spec'_p`p''
	g lower_`outcome'`spec'_p`p' = min(causal_`outcome'`spec'_p`p',stayers_`outcome'`spec'_p`p')
	g upper_`outcome'`spec'_p`p' = max(causal_`outcome'`spec'_p`p',stayers_`outcome'`spec'_p`p')
	drop number
		
	gen n = . 
	replace n = 1 if [_n]==1
	replace n = 2.5 if [_n]==2
	replace n = 4 if [_n]==3
	replace n = 5.5 if [_n]==4
	replace n = 7 if [_n]==5
	replace n = 8.5 if [_n]==6
	replace n = 10 if [_n]==7	
	replace n = 11.5 if [_n]==8	
	replace n = 13 if [_n]==9	
	replace n = 14.5 if [_n]==10
	replace n = 16 if [_n]==11
		
	replace causal_`outcome'`spec'_p`p' = causal_`outcome'`spec'_p`p' * ${pctgain_p`p'_`outcome'}
	replace lower_`outcome'`spec'_p`p' = lower_`outcome'`spec'_p`p' * ${pctgain_p`p'_`outcome'}
	replace upper_`outcome'`spec'_p`p' = upper_`outcome'`spec'_p`p' * ${pctgain_p`p'_`outcome'}
		
	twoway 	(bar causal_`outcome'`spec'_p`p' n, barwidth(0.9) color(navy) horizontal xline(0, lcolor(gs3) lwidth(0.33))) ///
		(rcap lower_`outcome'`spec'_p`p' upper_`outcome'`spec'_p`p' n, lcolor(gs3) lpattern(dash) horizontal), ///
		xlabel(-2.5(0.5)2.5) ///
		ylabel(1 `""Frac. Black" "Residents""'  2.5 `""Frac. Foreign" "Born""'  4 `" "Frac. Single" "Moms" "' /// 
		5.5 `" "Social Capital" "Index" "' 7 `" "Num. of Colleges" "Per Capita""' 8.5 `" "School" "Expenditure" "'  10 `" "Test Scores" "Cond. on Income" "' 11.5 `" "Top 1%" "Income Share" "' /// 
		13 `""Gini" "Coef.""' 14.5 `""Frac w/Commute" "<15 mins.""' 16 `" "Theil Index of" "Racial Segregation" "', angle(horizontal) labsize(small)) ///
		xlabel(-8.0 "-8.0" -6.0 "-6.0" -4.0 "-4.0" -2.0 "-2.0" 0 "0" 2.0 "2.0" 4.0 "4.0" 6.0 "6.0" 8.0 "8.0" )  ///
		xtitle("Percentage Impact of 1 SD Change in Covariate") title(" ") ytitle(" ") legend(off) graphregion(color(white)) 
		
	if `p'==25{
		graph export "${figures}/fig6a.${image_suffix}", replace
	}
	if `p'==75{
		graph export "${figures}/fig7a.${image_suffix}", replace
	}
}
}
}

* FIGURE VII: Predictors of Place Effects For Children with Parents at 75th Percentile
clear all 
macro drop cz_pop_cutoff cty_pop_cutoff weight reg_weight clvar var_cap scale_factor varlist
global cty_pop_cutoff = 10000
global cz_pop_cutoff = 25000
global weight precwt
global reg_weight cty_pop2000
global clvar cz
global scale_factor 20

global varlist cs_race_bla cs_born_foreign cs_fam_wkidsinglemom scap_ski90pcm ///
		num_inst_pc ccd_exp_tot score_r inc_share_1perc gini frac_traveltime_lt15 cs_race_theil_2000
			
foreach outcome in "kr26" {
foreach spec in "_cc2"{
foreach p in "25" "75" {
		
	* define matrix to store results 
	mat define ctyreg`outcome'`spec'_p`p'=J(11,2,.)
	local row =1
	matrix rownames ctyreg`outcome'`spec'_p`p'= ${varlist}
		
	* use beta dataset
	use "${cty_data}", clear
	merge m:1 cz using "${cz_data}", nogen 
	keep if cty_pop2000 >= ${cty_pop_cutoff} & cz_pop2000 >= ${cz_pop_cutoff}

	rename Bj_p`p'_cz_cty_`outcome'`spec' Bj_p`p'_czct`outcome'`spec'
		
	*Drop all obs with missing values of stayers, which are necessary for decomposition into sorting and causal
	keep if e_rank_b_`outcome'_p`p'~=.
		
	* Generate causal estimates: 20 years of exposure 
	g causal_raw_`p'_cty = ${scale_factor}*Bj_p`p'_cty_`outcome'`spec'
	g causal_raw_`p'_czct = ${scale_factor}*Bj_p`p'_czct`outcome'`spec'

	* Correlations with Observables
		
	foreach var of global varlist {
		
		qui areg e_rank_b_`outcome'_p`p' `var'_st [w=${reg_weight}], absorb(${clvar}) cluster(${clvar})
		mat def ctyreg`outcome'`spec'_p`p'[`row',1] = _b[`var'_st]
		
		qui areg causal_raw_`p'_czct `var'_st [w=${reg_weight}], absorb(${clvar}) cluster(${clvar})
		mat def ctyreg`outcome'`spec'_p`p'[`row',2] = _b[`var'_st]

		local row = `row'+1
	}
		
	clear
	svmat2 ctyreg`outcome'`spec'_p`p', rnames(variables)
		
	gen number = [_n]
	rename ctyreg`outcome'`spec'_p`p'1 stayers_`outcome'`spec'_p`p'
	rename ctyreg`outcome'`spec'_p`p'2 causal_`outcome'`spec'_p`p'
	order number variables
	tempfile ctyreg_`outcome'`spec'_p`p'
	save `ctyreg_`outcome'`spec'_p`p''
		
	use `ctyreg_`outcome'`spec'_p`p''
	g lower_`outcome'`spec'_p`p' = min(causal_`outcome'`spec'_p`p',stayers_`outcome'`spec'_p`p')
	g upper_`outcome'`spec'_p`p' = max(causal_`outcome'`spec'_p`p',stayers_`outcome'`spec'_p`p')
	drop number
		
	gen n = . 
	replace n = 1 if [_n]==1
	replace n = 2.5 if [_n]==2
	replace n = 4 if [_n]==3
	replace n = 5.5 if [_n]==4
	replace n = 7 if [_n]==5
	replace n = 8.5 if [_n]==6
	replace n = 10 if [_n]==7	
	replace n = 11.5 if [_n]==8	
	replace n = 13 if [_n]==9	
	replace n = 14.5 if [_n]==10
	replace n = 16 if [_n]==11
		
	list 
	replace causal_`outcome'`spec'_p`p' = causal_`outcome'`spec'_p`p' * ${pctgain_p`p'_`outcome'}
	replace lower_`outcome'`spec'_p`p' = lower_`outcome'`spec'_p`p' * ${pctgain_p`p'_`outcome'}
	replace upper_`outcome'`spec'_p`p' = upper_`outcome'`spec'_p`p' * ${pctgain_p`p'_`outcome'}
				
	twoway 	(bar causal_`outcome'`spec'_p`p' n, barwidth(0.9) color(navy) horizontal xline(0, lcolor(gs3) lwidth(0.33))) ///
		(rcap lower_`outcome'`spec'_p`p' upper_`outcome'`spec'_p`p' n, lcolor(gs3) lpattern(dash) horizontal), ///
		ylabel(1 `""Frac. Black" "Residents""'  2.5 `""Frac. Foreign" "Born""'  4 `" "Frac. Single" "Moms" "' /// 
		5.5 `" "Social Capital" "Index" "' 7 `" "Num. of Colleges" "Per Capita""' 8.5 `" "School" "Expenditure" "'  10 `" "Test Scores" "Cond. on Income" "' 11.5 `" "Top 1%" "Income Share" "' /// 
		13 `""Gini" "Coef.""' 14.5 `""Frac w/Commute" "<15 mins.""' 16 `" "Theil Index of" "Racial Segregation" "', angle(horizontal) labsize(small)) ///
		xlabel(-8.0 "-8.0" -6.0 "-6.0" -4.0 "-4.0" -2.0 "-2.0" 0 "0" 2.0 "2.0" 4.0 "4.0" 6.0 "6.0" 8.0 "8.0" )  ///
		xtitle("Percentage Impact of 1 SD Change in Covariate") title(" ") ytitle(" ") legend(off) graphregion(color(white)) 
	if `p'==25{
		graph export "${figures}/fig6b.${image_suffix}", replace
	}
	if `p'==75{
		graph export "${figures}/fig7b.${image_suffix}", replace
	}
}
}
}	

* FIGURE VIII: Opportunity Bargains in the New York Area
local outcome = "kr26"
local spec = "_cc2"
local p 25

** Inflation scaling for rental data
import delimited "${dropbox}/movers/analysis/covariates/CPIAUCSL", clear
qui {
sum cpi if date == 2000
local 2000 = r(mean)
sum cpi if date == 2012
local 2012 = r(mean)
global inflate = `2012' / `2000'
}

use "${cty_data}", clear
keep if cty_pop2000 >= ${cty_pop_cutoff} & cz_pop2000 >= ${cz_pop_cutoff}

keep if e_rank_b_`outcome'_p`p'~=.

g Bj_var_p`p'_cz_cty_`outcome'`spec'_bs = Bj_p`p'_cz_cty_`outcome'`spec'_bs_se^2
g precwt = 1/Bj_var_p`p'_cz_cty_`outcome'`spec'
	
* estimate signal and noise variances 
qui sum Bj_var_p`p'_cz_cty_`outcome'`spec' [w=precwt]
global noisevar_bs = r(mean)
	
* stayers predictions
qui reg Bj_p`p'_cz_cty_`outcome'`spec' e_rank_b_`outcome'_p`p' [w=precwt]
global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	
predict Bj_pred, xb
predict Bj_resid, r
	
g Bj_residsigvar = Bj_resid^2 - Bj_p`p'_cz_cty_`outcome'`spec'_se^2
reg Bj_residsigvar Bj_p`p'_cz_cty_`outcome'`spec'_se [w=precwt]
	
*Shrunk estimates using stayers predictions
sum Bj_resid [w=precwt]
global resid_sigvar = r(sd)^2 - $noisevar_bs

assert ${resid_sigvar}>0
	
g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_cz_cty_`outcome'`spec')
sum shrinkage [w=precwt], d
g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
	
*Estimate precision of shrunk estimates
g Bj_shrunk_rmse_`outcome'_p`p' = sqrt(1/(1/${resid_sigvar}+1/Bj_var_p`p'_cz_cty_`outcome'`spec'))
	
*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
replace Bj_shrunk_rmse_`outcome'_p`p' = sqrt(${resid_sigvar}) if shrinkage==0&Bj_pred~=.
	
g pct_effect_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20 * ${pctgain_p`p'_`outcome'}
	
replace county_name = "Manhattan" if cty==36061 
	
*Generate inflated median rent for below-median families
gen median_rent = med_rent_bm * ${inflate}
	
tw (scatter pct_effect_`outcome'_p`p' median_rent if csa==408 & ~inlist(cty,34017,36061,34025,9001,34031), mlab(county_name) mlabp(9) mlabc(navy) mc(navy)) ///
	(scatter pct_effect_`outcome'_p`p' median_rent if csa==408 & inlist(cty,34025,9001,34031), mlab(county_name) mlabp(3) mlabc(navy) mc(navy)) ///
	(scatter pct_effect_`outcome'_p`p' median_rent if inlist(cty,34017,36061), mlab(county_name) mlabc(red) mc(red) msymb(diamond) mlabp(3)) ///
	(lfit pct_effect_`outcome'_p`p' median_rent if csa==408 [w=cty_pop2000], lc(maroon)) ///
	, ytitle("Forecasted Causal Effects (% impact, from birth)") xtitle("Median Rent in 2000 (in 2012 $)") ///
	legend(off) graphregion(color(white)) 
graph export "${figures}/fig8.${image_suffix}", replace
		

****************************** APPENDIX FIGURES ********************************


*ONLINE APPENDIX FIGURE I: Causal Effect Estimates vs. Permanent Residents’ Outcomes for High-Income Families

local p = "75"
local outcome = "kr26"
local spec = "cc2"
global cz_pop_cutoff = 25000

/* Panel A Across CZs */

use "${cz_data}", clear
keep if pop2000 >= ${cz_pop_cutoff}

g beta_cz_p`p' = Bj_p`p'_cz`outcome'_`spec'
g beta_cz_p`p'_se = Bj_p`p'_cz`outcome'_`spec'_bs_se

g precwt = (1/beta_cz_p`p'_se)^2
global ymax = .5
g beta_low = max(beta_cz_p`p' - 1.96 * beta_cz_p`p'_se,-$ymax)
g beta_high = min(beta_cz_p`p' + 1.96 * beta_cz_p`p'_se,$ymax)

label var beta_cz_p`p' "Causal Effect" 

reg beta_cz_p`p' e_rank_b_`outcome'_p`p' [w=precwt]
predict beta_predict , xb

global poptop 2500000
global y_max .5
global y_min -.5
global x_max 60
global x_min 52

twoway (scatter beta_cz_p`p' e_rank_b_`outcome'_p`p' if inrange(e_rank_b_`outcome'_p`p',${x_min},${x_max}) & inrange(beta_cz_p`p',${y_min},${y_max}) , msize(tiny) mcolor(gs12)) ///
		(scatter beta_cz_p`p' e_rank_b_`outcome'_p`p' if pop2000 > $poptop, mlabel(czname) mlabcolor(black) mcolor(navy)) ///
	(rcap beta_low beta_high e_rank_b_`outcome'_p`p' if pop2000 > $poptop, lwidth(vthin) lpattern(dash) lcolor(navy))  ///
	(line beta_predict e_rank_b_`outcome'_p`p' if inrange(e_rank_b_`outcome'_p`p',${x_min},${x_max}) & inrange(beta_cz_p`p',${y_min},${y_max}) , lcolor(navy) )  ///	
	, graphregion(color(white)) legend(off) ytitle("Causal Effect of One Year of Exposure on Mean Rank") xtitle("Mean Rank of Children of Permanent Residents at p = 75") ///
	name(appfig1a, replace)
graph export "${figures}/appfig1a.${image_suffix}" , replace


/* Panel B Across Counties */

local p = "75"
local outcome = "kr26"
local spec = "cc2"

use "${cty_data}", clear
merge m:1 cz using "${cz_data}" , keepusing(czname Bj_p*_cz`outcome'_`spec' Bj_p*_cz`outcome'_`spec'_bs_se)
keep if cty_pop2000 >= ${cty_pop_cutoff} & cz_pop2000 >= ${cz_pop_cutoff}

g beta_cty_p`p' = Bj_p`p'_cz`outcome'_`spec' + Bj_p`p'_cty_`outcome'_`spec'
g beta_cty_p`p'_se = sqrt(Bj_p`p'_cz`outcome'_`spec'_bs_se^2 + Bj_p`p'_cty_`outcome'_`spec'_se^2)

g precwt = (1/beta_cty_p`p'_se)^2
global ymax = 1
g beta_low = max(beta_cty_p`p' - 1.96 * beta_cty_p`p'_se,-$ymax)
g beta_high = min(beta_cty_p`p' + 1.96 * beta_cty_p`p'_se,$ymax)

label var beta_cty_p`p' "Causal Effect" 

reg beta_cty_p`p' e_rank_b_`outcome'_p`p'  [w=precwt]
predict beta_predict , xb

global poptop 500000
global y_max 1
global y_min -1
global x_max 65
global x_min 50

twoway (scatter beta_cty_p`p' e_rank_b_`outcome'_p`p' if inrange(e_rank_b_`outcome'_p`p',${x_min},${x_max}) & inrange(beta_cty_p`p',${y_min},${y_max}) , msize(tiny) mcolor(gs12)) ///
		(scatter beta_cty_p`p' e_rank_b_`outcome'_p`p' if (czname == "New York" | czname == "Newark") & cty_pop2000 > $poptop, mlabel(county_name) mlabcolor(black) mcolor(navy) ) ///
	(rcap beta_low beta_high e_rank_b_`outcome'_p`p' if (czname == "New York" | czname == "Newark") & cty_pop2000 > $poptop, lwidth(vthin) lpattern(dash) lcolor(navy) )  ///
	(line beta_predict e_rank_b_`outcome'_p`p' if inrange(e_rank_b_`outcome'_p`p',${x_min},${x_max}) & inrange(beta_cty_p`p',${y_min},${y_max}) , lcolor(navy) )  ///	
	, graphregion(color(white)) legend(off) ytitle("Causal Effect of One Year of Exposure on Mean Rank") xtitle("Mean Rank of Children of Permanent Residents at p = 75") ///
	name(fig1b, replace)
graph export "${figures}/appfig1b.${image_suffix}" ,  replace


* ONLINE APPENDIX FIGURE II: Forecasts using Additional Covariates vs. Baseline Forecasts

clear all
set more off
local pctile 25 75
global cz_pop_cutoff = 25000

foreach p of local pctile {
use "${cz_data}", clear
keep if pop2000 >= ${cz_pop_cutoff}

g inter_bla_erb = cs_race_bla_st*e_rank_b_kr26_p`p'
g inter_for_erb = cs_born_foreign_st*e_rank_b_kr26_p`p'
g inter_for_bla = cs_born_foreign_st*cs_race_bla_st

	* Observable Characteristics in addtion to perm. resident outcomes
	global inputvars "e_rank_b_kr26_p`p' cs_race_bla cs_race_theil_2000 gini cs_fam_wkidsinglemom scap_ski90pcm ccd_exp_tot"

	g Bj_var_p`p'_czkr26_cc2_bs = Bj_p`p'_czkr26_cc2_bs_se^2
	g precwt = 1/Bj_var_p`p'_czkr26_cc2_bs


	qui sum Bj_var_p`p'_czkr26_cc2_bs [w=precwt]
	global noisevar_bs = r(mean)
	
	qui reg Bj_p`p'_czkr26_cc2 $inputvars [w=precwt]
	global stayers_raw_coeff = _b[e_rank_b_kr26_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r
	
	*Shrunk estimates using stayers predictions
	sum Bj_resid [w=precwt]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	di $resid_sigvar
	assert ${resid_sigvar}>0
	
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_czkr26_cc2_bs)
	sum shrinkage [w=precwt],d
	g Bj_shrunk_kr26_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
	
	*Estimate precision of shrunk estimates
	g Bj_shrunk_rmse_kr26_p`p' = sqrt(1/(1/${resid_sigvar}+1/Bj_var_p`p'_czkr26_cc2_bs))
	keep cz Bj_shrunk_kr26_p`p' Bj_pred Bj_shrunk_rmse_kr26_p`p' 
	rename Bj_shrunk_kr26_p`p' Bj_shrunk_kr26_p`p'_many
	rename Bj_pred Bj_pred_many
	rename Bj_shrunk_rmse_kr26_p`p' Bj_shrunk_rmse_kr26_p`p'_many
	tempfile manyvars`p'
	save `manyvars`p'', replace

	* Now go back to just permanent residents
	clear
	macro drop cz_pop_cutoff weight var_cap varlist 
	global cz_pop_cutoff = 25000 
	global weight precwt

	foreach outcome in "kr26"  {
	foreach spec in "_cc2" {

		* use beta dataset
		use "${cz_data}", clear
		keep if pop2000 >= ${cz_pop_cutoff}
	
		*Drop all obs with missing values of stayers, which are necessary for predictions
		keep if e_rank_b_`outcome'_p`p'~=.

		*Generate variances and precision weights
		g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_bs_se^2
		g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs
	
		* estimate signal and noise variances 
		qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=${weight}]
		global noisevar_bs = r(mean)
	
		* stayers predictions
		qui reg Bj_p`p'_cz`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
		global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
		global Rsq_stayers = e(r2)
		predict Bj_pred, xb
		predict Bj_resid, r
	
		*Shrunk estimates using stayers predictions
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
		replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
		replace Bj_shrunk_rmse_`outcome'_p`p' = sqrt(${resid_sigvar}) if shrinkage==0&Bj_pred~=.
	
		* Keep only the variables of interest
		keep cz stateabbrv czname Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' pop2000
		order cz stateabbrv czname Bj_shrunk_`outcome'_p`p' Bj_shrunk_rmse_`outcome'_p`p' pop2000

		* Keep only the Top50 cz's
		tempfile permres`p'
		sa `permres`p''
	}
	}
}
	
	
	* organize output
	use `permres25', clear
	merge 1:1 cz using `permres75', nogen
	merge 1:1 cz using `manyvars25', nogen 
	merge 1:1 cz using `manyvars75', nogen 
	
	keep pop2000 czname stateabbrv  *kr26_p*
	order pop2000 czname stateabbrv  *kr26_p* 
	gsort -pop2000
	
foreach p of local pctile {
	
	if "`p'" == "25" {
		local label = "a"
		local y = -10
		local x = 30
	}
	else if "`p'" == "75" {
		local label = "b"
		local y = -5
		local x = 15
	}

	preserve
	replace Bj_shrunk_kr26_p`p'_many = ${pctgain_p`p'_kr26} * 20 * Bj_shrunk_kr26_p`p'_many
	replace Bj_shrunk_kr26_p`p' = ${pctgain_p`p'_kr26} * 20 * Bj_shrunk_kr26_p`p'
	
	egen position = mlabvpos(Bj_shrunk_kr26_p`p'_many Bj_shrunk_kr26_p`p')
	keep if ~mi(Bj_shrunk_kr26_p`p'_many) & ~mi(Bj_shrunk_kr26_p`p') & pop2000 > 25000
	gsort -pop2000
	
	corr Bj_shrunk_kr26_p`p'_many Bj_shrunk_kr26_p`p' [w=pop2000]
	local corr: di %5.3f `r(rho)'
	
	su Bj_shrunk_kr26_p`p' [w=pop2000], d
	global baseline_sd = r(sd)
	su Bj_shrunk_kr26_p`p'_many  [w=pop2000], d
	global alternate_sd = r(sd)

	* Regress on Baseline Estimates for SEs
	reg Bj_shrunk_kr26_p`p'_many Bj_shrunk_kr26_p`p' [w=pop2000]
	local coeff =  _b[Bj_shrunk_kr26_p`p'] * $baseline_sd / $alternate_sd
	di in red "coeff " `coeff'
	local se = _se[Bj_shrunk_kr26_p`p'] * $baseline_sd / $alternate_sd
	di in red "se " `se'
	local se: di %5.3f `se'
	
	twoway ///
	scatter Bj_shrunk_kr26_p`p'_many Bj_shrunk_kr26_p`p', mc(gs12) msiz(small) ||, ///
	graphregion(color(white)) legend(off)  ///
	text(`y' `x' "Correlation: `corr'(`se')") ///
	xtitle("Forecasts from Baseline Specification") ///
	ytitle("Forecasts from Specification Incl. Additional Predictors")
	graph export "${figures}/appfig2`label'.${image_suffix}", replace
	restore
}


* ONLINE APPENDIX FIGURE III: Forecasts of CZs’ Causal Effects on Individual Income
clear all
macro drop cz_pop_cutoff weight var_cap varlist 
global cz_pop_cutoff = 25000 
global weight precwt

foreach outcome in "kir26"  {
foreach spec in "_cc2"{
foreach p in "25" "75" {
		
	* use beta dataset
	use "${cz_data}", clear
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.

	*Generate variances and precision weights
	g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_bs_se^2
	g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs
		
	* estimate noise variances 
	qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)
	
	* stayers predictions
	qui reg Bj_p`p'_cz`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r
	
	*Shrunk estimates using stayers predictions
	sum Bj_resid [w=${weight}]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	di $resid_sigvar
	assert ${resid_sigvar}>0
	
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_cz`outcome'`spec'_bs)
	sum shrinkage [w=${weight}],d
	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
	
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
	
	*Scale to pct. impact for 20 years of exposure
	replace Bj_shrunk_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20 * ${pctgain_p`p'_kir26}
	
	* Maptile maps
	maptile Bj_shrunk_`outcome'_p`p', geo(cz) n(10) rev
	if `p' == 25{
		graph export "${figures}/appfig3a.png", replace
	}
	else{
		graph export "${figures}/appfig3b.png", replace
	}
}
}
}

*ONLINE APPENDIX FIGURE IV: Forecasts of CZs’ Causal Effects on Family Income by Child’s Gender
clear all
macro drop cz_pop_cutoff weight var_cap varlist 
global cz_pop_cutoff = 25000 
global weight precwt

foreach outcome in "kr26_m" "kr26_f"  {
foreach spec in "_cc2"{
foreach p in "25" "75" {  
		
	* use beta dataset
	use "${cz_data}", clear
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.

	*Generate variances and precision weights
	g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_se^2
	g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs
		
	* estimate noise variances 
	qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)
	
	* stayers predictions
	qui reg Bj_p`p'_cz`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r
	
	*Shrunk estimates using stayers predictions
	sum Bj_resid [w=${weight}]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	di $resid_sigvar
	assert ${resid_sigvar}>0
	
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_cz`outcome'`spec'_bs)
	sum shrinkage [w=${weight}],d
	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
	
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
	
	replace Bj_shrunk_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20 * ${pctgain_p`p'_`outcome'}
	
	* Maptile maps
	maptile Bj_shrunk_`outcome'_p`p', geo(cz) n(10) rev
	if "`outcome'" == "kr26_m"{
		if `p' == 25{
			graph export "${figures}/appfig4a.png", replace
		}
		else{
			graph export "${figures}/appfig4c.png", replace
		}
	}
	else{
		if `p' == 25{
			graph export "${figures}/appfig4b.png", replace
		}
		else{
			graph export "${figures}/appfig4d.png", replace
		}	
	}
}
}
}
	
*ONLINE APPENDIX FIGURE V: Forecasts of CZs’ Causal Effects on Individual Income by Child’s Gender
clear all
macro drop cz_pop_cutoff weight var_cap varlist 
global cz_pop_cutoff = 25000 
global weight precwt

foreach outcome in "kir26_m" "kir26_f"  {
foreach spec in "_cc2"{
foreach p in "25" "75"  {
	
	* use beta dataset
	use "${cz_data}", clear
	
	*Drop all obs with missing values of stayers, which are necessary for predictions
	keep if e_rank_b_`outcome'_p`p'~=.

	*Generate variances and precision weights
	g Bj_var_p`p'_cz`outcome'`spec'_bs = Bj_p`p'_cz`outcome'`spec'_se^2
	g precwt = 1/Bj_var_p`p'_cz`outcome'`spec'_bs
		
	* estimate noise variances 
	qui sum Bj_var_p`p'_cz`outcome'`spec'_bs [w=${weight}]
	global noisevar_bs = r(mean)
	
	* stayers predictions
	qui reg Bj_p`p'_cz`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r
	
	*Shrunk estimates using stayers predictions
	sum Bj_resid [w=${weight}]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	di $resid_sigvar
	assert ${resid_sigvar}>0
	
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_cz`outcome'`spec'_bs)
	sum shrinkage [w=${weight}],d
	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
	
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
	
	replace Bj_shrunk_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20 * ${pctgain_p`p'_`outcome'}
	
	* Maptile maps
	maptile Bj_shrunk_`outcome'_p`p', geo(cz) n(10) rev
	if "`outcome'" == "kir26_m" {
		if `p' == 25{
			graph export "${figures}/appfig5a.png", replace
		}
		else{
			graph export "${figures}/appfig5c.png", replace
		}
	}
	else{
		if `p' == 25{
			graph export "${figures}/appfig5b.png", replace
		}
		else{
			graph export "${figures}/appfig5d.png", replace
		}	
	}	
	}
	}
	}

* ONLINE APPENDIX FIGURE VI: Distribution of Counties’ Causal Effects by Gender
clear all
macro drop cty_pop_cutoff cz_pop_cutoff weight var_cap scale_factor 
global cty_pop_cutoff = 10000 
global cz_pop_cutoff = 25000
global weight precwt
global scale_factor 20
	
foreach outcome in "kr26_m" "kr26_f" {
foreach spec in "_cc2"{
foreach p in "25" {

	* use beta dataset
	use "${cty_data}", clear
	merge m:1 cz using "${cz_data}", keepusing(Bj_p`p'_cz`outcome'`spec'_se)
	keep if cty_pop2000 >= ${cty_pop_cutoff} & cz_pop2000 >= ${cz_pop_cutoff}
	rename Bj_p`p'_cz`outcome'`spec'_se Bj_p`p'_cz`outcome'`spec'_bs_se

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
	
	* stayers predictions 
	qui reg Bj_p`p'_czct`outcome'`spec' e_rank_b_`outcome'_p`p' [w=${weight}]
	global stayers_raw_coeff = _b[e_rank_b_`outcome'_p`p']
	global Rsq_stayers = e(r2)
	predict Bj_pred, xb
	predict Bj_resid, r

	*Compute shrunk estimates
	sum Bj_resid [w=precwt]
	global resid_sigvar = r(sd)^2 - $noisevar_bs
	di $resid_sigvar
	assert ${resid_sigvar}>0
	g shrinkage = $resid_sigvar/($resid_sigvar+Bj_var_p`p'_czct`outcome'`spec'_bs)
	sum shrinkage [w=precwt],d

	g Bj_shrunk_`outcome'_p`p' = Bj_pred + Bj_resid*shrinkage if ${resid_sigvar}>0
	
	*Use predictions based purely on stayers for places with pop below pop cutoff (i.e., those with no estimates based on movers)
	replace shrinkage = 0 if shrinkage==. & Bj_pred~=.
	replace Bj_shrunk_`outcome'_p`p' = Bj_pred if shrinkage==0 & Bj_pred~=.
	
	keep cty cty_pop2000 Bj_shrunk_`outcome'_p`p'
	replace Bj_shrunk_`outcome'_p`p' = Bj_shrunk_`outcome'_p`p' * 20 * ${pctgain_p`p'_`outcome'}
	tempfile appendixfigure8_`outcome'_p`p'
	save `appendixfigure8_`outcome'_p`p''
	
	}
	}
	}
	
	use `appendixfigure8_kr26_m_p25', clear
	merge 1:1 cty using `appendixfigure8_kr26_f_p25', nogen
	
	tempfile for_graph
	save `for_graph'
	
	* Cumulative Density Function 
	sort Bj_shrunk_kr26_m_p25 
	gen cum_pop_m = sum(cty_pop2000)
	egen total_pop_m = total(cty_pop2000)
	gen cum_pop_0_1_m = cum_pop_m/total_pop_m
	gen gdr = "male"

	tempfile 1 
	save `1'
	
	use `for_graph', clear
	sort Bj_shrunk_kr26_f_p25 
	gen cum_pop_f = sum(cty_pop2000)
	egen total_pop_f = total(cty_pop2000)
	gen cum_pop_0_1_f = cum_pop_f/total_pop_f
	gen gdr= "female"

	append using `1'

	twoway (line cum_pop_0_1_m Bj_shrunk_kr26_m_p25 if (gdr=="male") , lwidth(medthick) lcolor(navy)) ///
	(line cum_pop_0_1_f Bj_shrunk_kr26_f_p25 if (gdr=="female") ,  lwidth(medthick)lpattern(dash) lcolor(maroon)), ///
	xscale(range(-0.4 0.4))  xlabel(, format(%3.1f))  ylabel(, format(%3.1f)) ///
	title(" ") xtitle("Forecast of County-Level Causal Effect at p=25") ytitle("Cumulative Distribution Function (CDF)") legend(off)

	graph export "${figures}/appfig6.${image_suffix}", replace
	
