* ATUS_models_xsec.do
* 2014.12.03
* Last update 2017.06.28: added hourly columns to table with 1st & RF
* 2017.06.24: updated path local, additional robustness
* Estimates long-term effects using ATUS collapsed to location level 

capture log close
set more off
timer clear 1
timer on 1
clear
set matsize 10000

local work "/DIRECTORY"

log using "`work'/logs/ATUS_models_xsec.log", replace
eststo clear
graph set window fontface "CMU Serif"
set scheme jleanc


/////////////////////////////////
// Locals for program flow
/////////////////////////////////
// Controls whether tables are produced
local output = 1

// Control whether sections of estimates are run
local summary_stats = 1
local linear = 1
local linear_robust = 1
local graphs = 1
local heterogeneity = 1
local other_time = 1 
local nonlinearity = 1
local bedwake = 1
local part_time = 1

/////////////////////////////////
// Locals for sets of controls
/////////////////////////////////
local geographic = "coast_dist coast cc lat_*"
local demographic = "mean_age age2 gender race_* primary_occ* pd_*"

* Defining "donuts" around TZ boundaries
local donutPM "-117.38, -114.74"
local donutMC "-104.58, -100.58"
local donutCE "-89.28, -84.93"
local donutPM2 "-117.5, -115"
local donutMC2 "-104.5, -101"
local donutCE2 "-89.5, -85"


*****************************
* Data
*****************************

* Reading data
use "`work'/data/Twosample_full.dta", clear


*****************************
* Balance table
*****************************
if `summary_stats'==1 {
	preserve
	gen educa_2 = educ_1 + educ_2
	* Residualizing variables
	foreach X in educa_2 educ_3 educ_4 trchildnum married capital_stock {
		display "Residualizing `X'"
		quietly regress `X' `geographic' `demographic' [aweight=obs], vce(robust)
		predict r`X', residuals
	}
	forval Y=1/52 {
		display "Residualizing `Y'"
		quietly regress primary_industry_`Y' `geographic' `demographic' [aweight=obs], vce(robust)
		predict rprimary_industry_`Y', residuals
		label variable rprimary_industry_`Y' "Primary industry `Y'"
	}
	* Variable labeling
	label var reduca_2 "HS or less (0/1)"
	label var reduc_3 "Some college (0/1)"
	label var reduc_4 "College (0/1)"
	label var rmarried "Ever married (0/1)"
	label var rtrchildnum "Number of children"
	label var rcapital_stock "Capital stock" 
	
	summarize sunset_time_avg, de
	gen SSTquartile = .
	replace SSTquartile = 1 if inrange(sunset_time_avg, 0, r(p50))
	replace SSTquartile = 2 if inrange(sunset_time_avg, r(p50), 24)
	
	local min_group = 1
	quietly: su SSTquartile
	local max_group = r(max)
	label def SSTquartile 1 "Early sunset" 2 "Late sunset", modify
	
	eststo drop *
	ereturn clear
	ettests reduca_2 reduc_3 reduc_4 rtrchildnum rmarried rcapital_stock if !missing(ln_wkly_wage) & (SSTquartile == `min_group' | SSTquartile == `max_group'), by(SSTquartile) casewise	  
	if `output'==1 {
		esttab using "`work'/tables/xsec/ATUS_xsecbalance_bySST.tex", ///
			  cells("mu_1(fmt(a2) label(Mean)) mu_2(fmt(a2) label(Mean)) d(star pvalue(p) label(Diff.)) N(label(Total obs.))" "sd_1(par fmt(a2) label((SD))) sd_2(par fmt(a2) label((SD))) se(par fmt(a2) label((SE)))") ///
			  star(* 0.10 ** 0.05 *** 0.01) ///
			  compress nogaps fragment label tex replace not noobs nomtitles nonum
		** You will still need to delimit the $ signs, and add \hline after cell labels, but
		** pretty close to a complete solution.
	} /* End output conditional */
	restore
} /* End summary_stats conditional*/


******************************
* Main specification
******************************
if `linear' == 1 {
	label variable ln_wkly_wage "ln(earnings)"
	* Weekly earnings - weighted
	eststo clear
	* 1st stage
	regress sleep sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
	eststo fs
	* Reduced form
	regress ln_wkly_wage sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
	eststo rf
	* Elasticity
	quietly: ivregress 2sls wkly_wage (sleep = sunset_time_avg) `geographic' `demographic'  [aweight=obs], vce(robust) first
	local beta_sleep_nolog = _b[sleep]
	quietly: su wkly_wage if e(sample)
	local wage_avg = r(mean)
	quietly: su sleep if e(sample)
	local sleep_avg = r(mean)
	local elasticity = (`sleep_avg'/`wage_avg')*`beta_sleep_nolog'
	local elasticity : display %3.2f `elasticity'
	* 2SLS
	ivreg2 ln_wkly_wage (sleep = sunset_time_avg) `geographic' `demographic'  [aweight=obs], robust
	local beta_sleep = _b[sleep]
	local f_stat = round(e(widstat), 0.01)
	local f_stat : display %3.2f `f_stat'
	estadd local f_stat `f_stat', replace
	estadd local elasticity `elasticity', replace
	eststo twostage
	* OLS
	regress ln_wkly_wage sleep `geographic' `demographic' [aweight=obs], vce(robust)
	eststo ols
	if `output' == 1 {
		esttab fs rf twostage ols using "`work'/tables/xsec/ATUS_linear_xsec.tex", ///
			scalars("f_stat F-stat on IV" "elasticity Elasticity") ///
			indicate("Geographic controls=`geographic'" "Demographic controls=`demographic'") ///
			drop(_cons) ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			ar2 se noconstant nonumbers nogaps label tex fragment replace b(a2) se(a2)
		esttab fs rf twostage using "`work'/tables/xsec/ATUS_linear_xsec_small.tex", ///
			scalars("f_stat F-stat on IV") ///
			keep(sleep sunset_time_avg) ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			ar2 se noconstant nonumbers nogaps label tex fragment replace b(a2) se(a2)
		esttab twostage using "`work'/tables/xsec/ATUS_xsec_iv.tex", ///
			scalars("f_stat F-stat on IV" "elasticity Elasticity") ///
			indicate("Geographic controls=`geographic'" "Demographic controls=`demographic'") ///
			drop(_cons) ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			ar2 se noconstant nonumbers nogaps label tex fragment replace b(a2) se(a2)
	} /* End output conditional */
	* Breusch-Pagan heteroskedasticity test, as recommended in Solon et al (2013)
	gen J = 1/obs
	ivregress 2sls ln_wkly_wage (sleep = sunset_time_avg) `geographic' `demographic', vce(robust) /* unweighted OLS */
	predict double resid, residuals
	gen double resid2 = resid * resid
	* n.b. consistency of B-P test requires homoskedastic errors in below regression, so vce(robust) not appropriate
	regress resid2 J
	eststo BP
	if `output' == 1 {
		esttab BP using "`work'/tables/xsec/ATUS_linear_BPtest.tex", ///
			coeflabels(_cons "Constant" J "1/Observations") ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			substitute(resid2 "Residuals$^{2}$") ///
			ar2 se nonumbers nogaps label tex fragment replace b(a2) se(a2)
	} /* End output conditional */
	* Income effect
	local delta = 1 
	quietly summarize tehruslt
	local avg_hours = r(mean)
	gen hourly_wk_wage = wkly_wage/tehruslt
	quietly summarize hourly_wk_wage
	local avg_wage = r(mean)
	local eps_w = 0
	local wks = 50
	local beta_sleep = `beta_sleep'
	di "Annual change in income implied by `delta' hour extra sleep per week, holding work constant"
	di `wks'*(`avg_wage'*(1 + (exp(`beta_sleep')-1)*`delta')*(`avg_hours' - `delta'*`eps_w') - `avg_wage'*`avg_hours')
	di "Implied value of leisure:" 
	di (`wks'*(`avg_wage'*(1 + (exp(`beta_sleep')-1)*`delta')*(`avg_hours' - `delta'*`eps_w') - `avg_wage'*`avg_hours'))/(`delta'*`wks')
	// Now with more data implied hour shifting
	regress work `geographic' `demographic' sunset_time_avg [aweight=obs], vce(robust)
	local eps_w = _b[sunset_time_avg]
	di "Annual change in income implied by `delta' hour extra sleep per week, allowing work to vary"
	di `wks'*(`avg_wage'*(1 + (exp(`beta_sleep')-1)*`delta')*(`avg_hours' - `delta'*`eps_w') - `avg_wage'*`avg_hours')
	local eps_w = 1
	di "Annual change in income implied by `delta' hour extra sleep per week, taking all time out of work"
	di `wks'*(`avg_wage'*(1 + (exp(`beta_sleep')-1)*`delta')*(`avg_hours' - `delta'*`eps_w') - `avg_wage'*`avg_hours')
	// Break even point will be
	di "Break even work response"
	di (`avg_hours'/(1 + (exp(`beta_sleep')-1)*`delta')- `avg_hours')*(-`delta')^(-1)
	
	* Weekly earnings - unweighted
	* 1st stage
	regress sleep sunset_time_avg `geographic' `demographic', vce(robust)
	test sunset_time_avg
	estadd local f_stat = round(r(F), 0.01)
	eststo firststageuw
	* Reduced form
	regress ln_wkly_wage sunset_time_avg `geographic' `demographic', vce(robust)
	eststo rfuw
	* Elasticity
	quietly: ivregress 2sls wkly_wage (sleep = sunset_time_avg) `geographic' `demographic', vce(robust) first
	local beta_sleep_nolog = _b[sleep]
	quietly: su wkly_wage if e(sample)
	local wage_avg = r(mean)
	quietly: su sleep if e(sample)
	local sleep_avg = r(mean)
	local elasticityuw = (`sleep_avg'/`wage_avg')*`beta_sleep_nolog'
	local elasticityuw : display %3.2f `elasticity'
	* 2SLS
	ivregress 2sls ln_wkly_wage (sleep = sunset_time_avg) `geographic' `demographic', vce(robust) first
	estadd local elasticityuw `elasticity', replace
	eststo twostageuw
	if `output' == 1 {
		esttab firststageuw rfuw twostageuw using "`work'/tables/xsec/ATUS_linear_xsec_unweighted.tex", ///
			scalars("f_stat F-stat on IV") ///
			keep(sleep sunset_time_avg) ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			ar2 se noconstant nonumbers nogaps label tex fragment replace b(a2) se(a2)
	} /* End output conditional */
	
	* Hourly wage
	use "`work'/data/ATUS_xsec_hrly.dta", clear
	keep if group==2 & inlist(time_zone, "P", "M", "C", "E")
	mkspline lat_ 10 = latitude
	mkspline pd_ 5 = pop_density
	gen lnsleep = log(sleep)
	gen state_coded = (fips == fips2)
	gen coast = ((coastal == 1 & coast_dist < 1) | (coast_dist < 1 & state_coded == 1))
	gen cc = coast_dist*coast
	label variable sleep "Sleep"
	label variable sunset_time_avg "Avg. sunset time"
	label variable ln_wage "ln(wage)"
	label variable ln_wkly_wage "ln(earnings)"
	* 1st stage
	regress sleep sunset_time_avg `geographic' `demographic' [aweight=hrly_obs], vce(robust)
	test sunset_time_avg
	estadd local f_stat = round(r(F), 0.01)
	eststo fshrly
	* Reduced form
	regress ln_wage sunset_time_avg `geographic' `demographic' [aweight=hrly_obs], vce(robust)
	eststo rfhrly
	* Elasticity
	quietly: ivregress 2sls wage (sleep = sunset_time_avg) `geographic' `demographic'  [aweight=hrly_obs], vce(robust) first
	local beta_sleep_nolog = _b[sleep]
	quietly: su wage if e(sample)
	local wage_avg = r(mean)
	quietly: su sleep if e(sample)
	local sleep_avg = r(mean)
	local elasticityhrly = (`sleep_avg'/`wage_avg')*`beta_sleep_nolog'
	local elasticityhrly : display %3.2f `elasticity'
	* 2SLS
	ivreg2 ln_wage (sleep = sunset_time_avg) `geographic' `demographic'  [aweight=hrly_obs], robust
	local f_stat = round(e(widstat), 0.01)
	local f_stat : display %3.2f `f_stat'
	estadd local f_stat `f_stat', replace
	estadd local elasticityhrly `elasticity', replace
	eststo tshrly
	* OLS
	regress ln_wage sleep `geographic' `demographic' [aweight=hrly_obs], vce(robust)
	eststo olshrly
	if `output' == 1 {
		esttab fshrly rfhrly tshrly olshrly using "`work'/tables/xsec/ATUS_linear_xsec_hrly.tex", ///
			scalars("f_stat F-stat on IV" "elasticity Elasticity") ///
			indicate("Geographic controls=`geographic'" "Demographic controls=`demographic'") ///
			drop(_cons) ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			ar2 se noconstant nonumbers nogaps label tex fragment replace b(a2) se(a2)
		esttab rfhrly using "`work'/tables/xsec/ATUS_xsec_hrly_rf.tex", ///
			keep(sunset_time_avg) ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex fragment replace nomtitles nolines
		esttab tshrly using "`work'/tables/xsec/ATUS_xsec_hrly_iv.tex", ///
			scalars("f_stat F-stat on IV" "elasticity Elasticity") ///
			indicate("Geographic controls=`geographic'" "Demographic controls=`demographic'") ///
			drop(_cons) ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			ar2 se noconstant nonumbers nogaps label tex fragment replace b(a2) se(a2)
		* New 2017.06.28: putting hourly in same table with weekly earnings
		esttab fs rf fshrly rfhrly using "`work'/tables/xsec/ATUS_xsec_fsrf.tex", ///
			indicate("Geographic controls=`geographic'" "Demographic controls=`demographic'") ///
			drop(_cons) ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			ar2 se noconstant nonumbers nogaps label tex fragment replace b(a2) se(a2)
	} /* End output conditional */

	* Returning to base sample
	* Reading data
	use "`work'/data/Twosample_full.dta", clear
	* Subsetting to ATUS, continental US
	keep if group==2 & inlist(time_zone, "P", "M", "C", "E")
	* Variable handling
	mkspline lat_ 10 = latitude
	mkspline pd_ 5 = pop_density
	mkspline cd_ 3 = coast_dist
	gen lnsleep = log(sleep)
	encode time_zone, generate(ATUStzcode)
	gen state_coded = (fips == fips2)
	gen coast = ((coastal == 1 & coast_dist < 1) | (coast_dist < 1 & state_coded == 1))
	gen cc = coast_dist*coast
	* Variable labeling
	label variable ln_wkly_wage "ln(earnings)"
	label variable sleep "Sleep"
	label variable sunset_time_avg "Avg. sunset time"
	label variable lnsleep "ln(sleep)"
	label variable sleep_base "Sleep and naps"

} /* End linear conditional */


******************************
* Robustness
******************************
if `linear_robust' == 1 {
	* Robustness: controls
	* Usual work hours quadratic
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' c.tehruslt##c.tehruslt [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_usualhoursquad.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' _cons *tehruslt*) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* Usual work hours
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' tehruslt [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_usualhours.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' _cons *tehruslt*) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* Geo controls only
	eststo clear
	eststo: regress ln_wkly_wage sunset_time_avg  `geographic' [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_geoonly.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* 3-part spline in coastal distance
	eststo clear
	regress ln_wkly_wage sunset_time_avg  cd_* lat_*  `demographic' [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab using "`work'/tables/xsec/ATUS_linear_robust_coastspline.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(cd_* lat_* `demographic' _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* No occupation indicators
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* pd_* [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_noocc.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' med_age gender race_* pd_* _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* Education indicators
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* educ_* [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_edu.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' med_age gender race_* primary_occ* pd_* educ_* _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* Largest 100 locations only
	preserve
	gsort -pop_2010
	keep if _n <=100
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_top100locs.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' med_age gender race_* primary_occ* pd_* _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	restore
	* Comparing county- and state-geocoded obs - NB unweighted
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* if state_coded==1, vce(robust)
	eststo rf1
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* if state_coded==0, vce(robust)
	eststo rf2
	if `output' == 1 { 
		esttab rf1 rf2 using "`work'/tables/xsec/ATUS_linear_robust_geocoding.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' med_age gender race_* primary_occ* pd_* _cons) ///
		se(a2) b(a2) noconstant nonumbers nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* Rural v. urban - NB unweighted
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* if pop_density<1552, vce(robust)
	eststo rf1
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* if pop_density>=1552, vce(robust)
	eststo rf2
	if `output' == 1 { 
		esttab rf1 rf2 using "`work'/tables/xsec/ATUS_linear_robust_ruralVurban.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' med_age gender race_* primary_occ* pd_* _cons) ///
		se(a2) b(a2) noconstant nonumbers nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* Few v. many observations - NB unweighted
	* for reference
	/*
	summarize obs, detail
	
							  (sum) obs
	-------------------------------------------------------------
		  Percentiles      Smallest
	 1%            3              1
	 5%           13              2
	10%           19              2       Obs                 529
	25%           34              3       Sum of Wgt.         529
	
	50%           58                      Mean           116.8828
							Largest       Std. Dev.      166.2796
	75%          128            806
	90%          287           1158       Variance       27648.91
	95%          419           1422       Skewness       4.089142
	99%          770           1638       Kurtosis       27.55302
	*/
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* if obs<58, vce(robust)
	eststo rf1
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* if obs>=58, vce(robust)
	eststo rf2
	if `output' == 1 { 
		esttab rf1 rf2 using "`work'/tables/xsec/ATUS_linear_robust_fewobsVmanyobs.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' med_age gender race_* primary_occ* pd_* _cons) ///
		se(a2) b(a2) noconstant nonumbers nogaps label tex fragment replace nomtitles nolines
	}
	* Additional individual controls: age^2
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' c.med_age##c.med_age gender race_* primary_occ* pd_* [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_age2.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' *med_age* gender race_* primary_occ* pd_* _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* Additional individual controls: industry dummies
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* primary_industry_* [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_industry.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' med_age gender race_* primary_occ* pd_* primary_industry_* _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* TZ indicators
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' i.ATUStzcode [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_TZdummies.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' *.ATUStzcode _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* Longitude control
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' longitude [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_longitude.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' longitude _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* Region indicators
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' gereg_* [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_regions.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' gereg_*  _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* State capital stock
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' capital_stock [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_kstock.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' capital_stock _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* State QOL index from Albouy
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' qol [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_QOL.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' qol _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* SEs clustered at state level
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' [aweight=obs], vce(cluster fips2)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_statecluster.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' _cons) ///
		se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* "Kitchen sink" model for R2
	eststo clear
	eststo: regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' [aweight=obs], vce(robust)
	eststo: regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' c.tehruslt##c.tehruslt [aweight=obs], vce(robust)
	eststo: regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' c.tehruslt##c.tehruslt i.ATUStzcode [aweight=obs], vce(robust)
	eststo: regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' c.tehruslt##c.tehruslt i.ATUStzcode qol [aweight=obs], vce(robust)
	eststo: regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' c.tehruslt##c.tehruslt i.ATUStzcode qol educ_* [aweight=obs], vce(robust)
	if `output' == 1 { 
		esttab using "`work'/tables/xsec/ATUS_linear_robust_many_controls.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		keep(sunset_time_avg) ///
		indicate("Work hrs quadratic = *tehruslt*" "Time zone indicators = *.ATUStzcode" "Albouy QOL = qol" "Educ. attainment shares=educ_*") ///
		se(a2) b(a2) noconstant nonumbers nogaps label tex fragment replace nomtitles nolines
	}
	* Including naps for R2
	eststo clear
	regress sleep_base sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
	eststo fs
	regress ln_wkly_wage sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
	eststo rf
	ivreg2 ln_wkly_wage (sleep_base = sunset_time_avg) `geographic' `demographic'  [aweight=obs], robust
	local f_stat = round(e(widstat), 0.01)
	local f_stat : display %3.2f `f_stat'
	estadd local f_stat `f_stat', replace
	eststo twostage
	if `output'==1 {
			esttab fs rf twostage using "`work'/tables/xsec/ATUS_linear_xsec_wnaps.tex", ///
			scalars("f_stat F-stat on IV") ///
			keep(sleep_base sunset_time_avg) ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			ar2 se noconstant nonumbers nogaps label tex fragment replace b(a2) se(a2)
	}
	
	* Robustness: sample
	* No time zone border counties; 2015.07.13 adopted donuts from QCEW analysis
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' [aweight=obs] if !inrange(longitude, `donutPM') & !inrange(longitude, `donutMC') & !inrange(longitude, `donutCE'), vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_noborder.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' _cons) ///
		se(a2) b(a2) noconstant nonumbers nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	* TZ subsamples
	* Note not enough locations in mountain TZ to estimate model
	foreach tz in P C E {
		eststo clear
		regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' [aweight=obs] if time_zone=="`tz'", vce(robust)
		eststo rf
		if `output' == 1 { 
			esttab rf using "`work'/tables/xsec/ATUS_linear_robust_tz`tz'.tex", ///
			star(* 0.10 ** 0.05 *** 0.01) ///  
			drop(`geographic' `demographic' _cons) ///
			coeflabels(sunset_time_avg "Avg. sunset time" sleep "Sleep") ///
			se(a2) b(a2) noconstant nonumbers nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
		}
	}
	* Excluding Eastern time zone
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' [aweight=obs] if time_zone!="E", vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_noE.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' _cons) ///
		coeflabels(sunset_time_avg "Avg. sunset time" sleep "Sleep") ///
		se(a2) b(a2) noconstant nonumbers nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	
	
	*** Models below require different data sets ***
	* No weekend diaries
	use "`work'/data/ATUS_xsec_nowkends.dta", clear
	keep if group==2 & inlist(time_zone, "P", "M", "C", "E")
	mkspline lat_ 10 = latitude
	mkspline pd_ 5 = pop_density
	gen state_coded = (fips == fips2)
	gen coast = ((coastal == 1 & coast_dist < 1) | (coast_dist < 1 & state_coded == 1))
	gen cc = coast_dist*coast
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' `demographic' [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_nowkends.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' `demographic' _cons) ///
		coeflabels(sunset_time_avg "Avg. sunset time" sleep "Sleep") ///
		se(a2) b(a2) noconstant nonumbers nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}

	* Dropping SF, LA, CHI, BOS, NYC
	use "`work'/data/ATUS_xsec_noHWcities.dta", clear
	keep if group==2 & inlist(time_zone, "P", "M", "C", "E")
	mkspline lat_ 10 = latitude
	mkspline pd_ 5 = pop_density
	gen state_coded = (fips == fips2)
	gen coast = ((coastal == 1 & coast_dist < 1) | (coast_dist < 1 & state_coded == 1))
	gen cc = coast_dist*coast
	eststo clear
	regress ln_wkly_wage sunset_time_avg  `geographic' med_age gender race_* primary_occ* pd_* [aweight=obs], vce(robust)
	eststo rf
	if `output' == 1 { 
		esttab rf using "`work'/tables/xsec/ATUS_linear_robust_noHWcities.tex", ///
		star(* 0.10 ** 0.05 *** 0.01) ///  
		drop(`geographic' med_age gender race_* primary_occ* pd_* _cons) ///
		coeflabels(sunset_time_avg "Avg. sunset time" sleep "Sleep") ///
		se(a2) b(a2) noconstant nonumbers nogaps wide label tex begin(" & ") fragment replace nomtitles nolines
	}
	/* Ensures we will not accidentally use this data set in a subsequent model */
	* Reading data
	use "`work'/data/Twosample_full.dta", clear
	keep if group==2 & inlist(time_zone, "P", "M", "C", "E")
	* Variable handling
	mkspline lat_ 10 = latitude
	mkspline pd_ 5 = pop_density
	mkspline cd_ 3 = coast_dist
	gen lnsleep = log(sleep)
	encode time_zone, generate(ATUStzcode)
	gen state_coded = (fips == fips2)
	gen coast = ((coastal == 1 & coast_dist < 1) | (coast_dist < 1 & state_coded == 1))
	gen cc = coast_dist*coast
	* Variable labeling
	label variable ln_wkly_wage "ln(earnings)"
	label variable sleep "Sleep"
	label variable sunset_time_avg "Avg. sunset time"
	label variable lnsleep "ln(sleep)"
	label variable sleep_base "Sleep and naps"

} // End robustness conditional


******************************
* Graphs
******************************
if `graphs' == 1 {

** Raw data graphs
* Binscatters
binscatter ln_wkly_wage sunset_time_avg, ytitle("ln(earnings)") xtitle("Avg. sunset time") name(binRF, replace)
graph export "`work'/graphs/xsec_binscatter_RF.eps", as(eps) replace
binscatter sleep sunset_time_avg, ytitle("Sleep") xtitle("Avg. sunset time") name(bin1st, replace)
graph export "`work'/graphs/xsec_binscatter_1st.eps", as(eps) replace
* Raw scatter
twoway scatter ln_wkly_wage sunset_time_avg, ytitle("ln(earnings)") xtitle("Avg. sunset time") name(scatterRF, replace)
graph export "`work'/graphs/xsec_rawscatter_RF.eps", as(eps) replace
* Raw scatter - circles for obs size
twoway scatter ln_wkly_wage sunset_time_avg [w=obs], msymbol(circle_hollow) ytitle("ln(earnings)") xtitle("Avg. sunset time") name(scatterRFcirc, replace)
graph export "`work'/graphs/xsec_rawscatter_RF_circles.eps", as(eps) replace
* Lpoly
twoway lpolyci ln_wkly_wage sunset_time_avg, ytitle("ln(earnings)") xtitle("Avg. sunset time") name(lpolyRF, replace)
graph export "`work'/graphs/xsec_rawlpoly_RF.eps", as(eps) replace

** Residual graphs
regress ln_wkly_wage /*sunset_time_avg*/ `geographic' `demographic' [aweight=obs], vce(robust)
predict resid, residuals
* Binscatters
binscatter resid sunset_time_avg, ytitle("ln(earnings)") xtitle("Avg. sunset time") name(rbinRF, replace)
graph export "`work'/graphs/xsec_binscatter_RFr.eps", as(eps) replace
* Raw scatter
twoway scatter resid sunset_time_avg, ytitle("ln(earnings)") xtitle("Avg. sunset time") name(rscatterRF, replace)
graph export "`work'/graphs/xsec_rawscatter_RFr.eps", as(eps) replace
* Raw scatter - circles for obs size
twoway scatter resid sunset_time_avg [w=obs], msymbol(circle_hollow) ytitle("ln(earnings)") xtitle("Avg. sunset time") name(rscatterRFcirc, replace)
graph export "`work'/graphs/xsec_rawscatter_RF_circlesr.eps", as(eps) replace
* Lpoly
twoway lpolyci resid sunset_time_avg, ytitle("ln(earnings)") xtitle("Avg. sunset time") name(rlpolyRF, replace)
graph export "`work'/graphs/xsec_rawlpoly_RFr.eps", as(eps) replace

* for reference
/*
summarize obs, detail

                          (sum) obs
-------------------------------------------------------------
      Percentiles      Smallest
 1%            3              1
 5%           13              2
10%           19              2       Obs                 529
25%           34              3       Sum of Wgt.         529

50%           58                      Mean           116.8828
                        Largest       Std. Dev.      166.2796
75%          128            806
90%          287           1158       Variance       27648.91
95%          419           1422       Skewness       4.089142
99%          770           1638       Kurtosis       27.55302
*/
* Small reduced form in unwieghted regressions is coming from low-obs locations
twoway lpolyci resid sunset_time_avg if obs>=128, ytitle("ln(earnings)") xtitle("Avg. sunset time") name(rlpolyRFbig, replace)
graph export "`work'/graphs/xsec_rawlpoly_RFr_big.eps", as(eps) replace
twoway lpolyci resid sunset_time_avg if obs<128, ytitle("ln(earnings)") xtitle("Avg. sunset time") name(rlpolyRFsmall, replace)
graph export "`work'/graphs/xsec_rawlpoly_RFr_small.eps", as(eps) replace
twoway scatter resid sunset_time_avg [w=obs] if obs>=128, msymbol(circle_hollow) ytitle("ln(earnings)") xtitle("Avg. sunset time") name(rscatterRFcircbig, replace)
graph export "`work'/graphs/xsec_rawscatter_RF_circlesr_big.eps", as(eps) replace
twoway scatter resid sunset_time_avg [w=obs] if obs<128, msymbol(circle_hollow) ytitle("ln(earnings)") xtitle("Avg. sunset time") name(rscatterRFcircsmall, replace)
graph export "`work'/graphs/xsec_rawscatter_RF_circlesr_small.eps", as(eps) replace

* Closing accumulated graphs
window manage close graph _all

* Sleep PDFs
count
kdensity sleep, name(pdfall, replace)
histogram sleep, name(histall, replace)


} /* End graphs conditional */



******************************
* Heterogeneity
******************************
if `heterogeneity' == 1 {

    * Baseline
    regress ln_wkly_wage sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
    * Hourly wage
    eststo rf_w: regress ln_wage sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
    * Non-hourly wage
    eststo rf_s: regress ln_salary sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
    * Hourly but for earnings
    eststo rf_we: regress ln_wkly_wage_hour sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)    

   // Output a table with hourly wage and non-hourly wage people
   if `output' == 1 {
      esttab rf_w rf_s rf_we using "`work'/tables/xsec/ATUS_flex.tex", ///
             star(* 0.10 ** 0.05 *** 0.01) drop(`geographic' `demographic' _cons) ///
             se(a2) b(a2) noconstant nonumbers nogaps  label tex fragment replace nomtitles nolines
   }
    
    
   gen SSTXcollege = sunset_time_avg * college
   gen sleepXcollege = sleep * college
   eststo clear
   eststo: regress sleep sunset_time_avg SSTXcollege `geographic' `demographic' [aweight=obs], vce(robust)
   eststo: regress sleepXcollege sunset_time_avg SSTXcollege `geographic' `demographic' [aweight=obs], vce(robust)
   eststo: regress ln_wkly_wage sunset_time_avg SSTXcollege `geographic' `demographic' [aweight=obs], vce(robust)
   eststo: ivregress 2sls ln_wkly_wage (sleep sleepXcollege = sunset_time_avg SSTXcollege)  `geographic' `demographic' [aweight=obs], vce(robust) 
   if `output' == 1 { 
      esttab using "`work'/tables/xsec/ATUS_heterog_byedu.tex", ///
             star(* 0.10 ** 0.05 *** 0.01) ///  
             drop(`geographic' `demographic' _cons) ///
             se(a2) b(a2) noconstant nonumbers noobs nogaps wide label tex fragment replace nomtitles nolines
   }

} /* End heterogeneity conditional */


******************************
* Other time
******************************
if `other_time' == 1 {
   // Gronau time categories
   // We want to run this over the baseline sample, part-time, and unemployed
   // Baseline sample
   eststo c_2: regress sleep sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   eststo c_1: regress time_c_1 sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   eststo c_4: regress time_c_4 sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   eststo c_3: regress time_c_3 sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   if `output' == 1 {
      esttab c_2 c_1 c_4 c_3 using "`work'/tables/xsec/ATUS_modeltime_base.tex", ///
             drop(`geographic' `demographic' _cons) ///
             star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
             se(a2) noconstant nonumbers nogaps  label tex fragment replace ///
             nomtitles nolines  b(a2)
   }
   su sleep time_c_1 time_c_4 time_c_3 [aweight=obs]
   // Part-time sample
   preserve
   use "`work'/data/Twosample_part.dta", clear
   eststo c_2: regress sleep sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   eststo c_1: regress time_c_1 sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   eststo c_4: regress time_c_4 sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   eststo c_3: regress time_c_3 sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   if `output' == 1 {
      esttab c_2 c_1 c_4 c_3 using "`work'/tables/xsec/ATUS_modeltime_part.tex", ///
             drop(`geographic' `demographic' _cons) ///
             star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
             se(a2) noconstant nonumbers nogaps  label tex fragment replace ///
             nomtitles nolines  b(a2)
   }
   // Not employed sample
   use "`work'/data/Twosample_non.dta", clear
   local demographic = "mean_age age2 gender race_* pd_*"
   eststo c_2: regress sleep sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   eststo c_4: regress time_c_4 sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   eststo c_3: regress time_c_3 sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
   if `output' == 1 {
      esttab c_2 c_4 c_3 using "`work'/tables/xsec/ATUS_modeltime_noemp.tex", ///
             drop(`geographic' `demographic' _cons) ///
             star(* 0.10 ** 0.05 *** 0.01) ///
             stats(N, label("Observations") fmt(%9.0gc)) ///
             se(a2) noconstant nonumbers nogaps  label tex fragment replace ///
             nomtitles nolines  b(a2) extracols(2) noobs
   }
   su sleep time_c_1 time_c_4 time_c_3 [aweight=obs]
   restore
   
    * Work duration as fxn of sunset
    eststo clear
    eststo: regress work `geographic' `demographic' sunset_time_avg [aweight=obs], vce(robust)
* Other time as fxn of sunset
eststo: regress other_time_exnaps `geographic' `demographic' sunset_time_avg [aweight=obs], vce(robust)
if `output' == 1 {
	esttab using "`work'/tables/xsec/ATUS_workothertime_IV.tex", ///
	drop(_cons) ///
	indicate("Geographic controls=`geographic'" "Demographic controls=`demographic'") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	ar2 se(a2) noconstant nonumbers nogaps label tex fragment replace nomtitles nolines noeqlines b(a2)
}

* Other hours: heterogeneity suggested by comparative statics
* tehruslt (usual hrs worked): 90th pctile 55. 95th is 60. conditional on non-zero hrs
* work: 50th 2.5, 75th 8, 90th 9.63, 95th 10.83, 99th 13.33
* work | work>0: 50th 7.83, 75th 9, 90th 10.58, 95th 11.83, 99th 14.3
* sleep: 50th 8.23, 25th 7, 10th 6, 5th 5, 1st 3.42.
* 10th pctile of wage, conditional on non-zero hours, is 5.442418
eststo clear
use "`work'/data/ATUS_xsec_hihrs_lowsleep.dta", clear
keep if group==2 & inlist(time_zone, "P", "M", "C", "E")
mkspline lat_ 10 = latitude
mkspline pd_ 5 = pop_density
gen state_coded = (fips == fips2)
gen coast = ((coastal == 1 & coast_dist < 1) | (coast_dist < 1 & state_coded == 1))
gen cc = coast_dist*coast
regress other_time_exnaps `geographic' `demographic' sunset_time_avg [aweight=obs], vce(robust)
eststo LRlowsleep

use "`work'/data/ATUS_xsec_lowwage.dta", clear
keep if inlist(time_zone, "P", "M", "C", "E")
mkspline lat_ 10 = latitude
mkspline pd_ 5 = pop_density
gen state_coded = (fips == fips2)
gen coast = ((coastal == 1 & coast_dist < 1) | (coast_dist < 1 & state_coded == 1))
gen cc = coast_dist*coast
regress other_time_exnaps `geographic' `demographic' sunset_time_avg [aweight=obs], vce(robust)
eststo LRlowwage

if `output' == 1 {
	esttab LRlowsleep LRlowwage using "`work'/tables/xsec/ATUS_othertime_subpops.tex", ///
	drop(_cons) ///
	coeflabels(sunset_time_avg "Avg. sunset time") ///
	indicate("Geographic controls=`geographic'" "Demographic controls=`demographic'") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	ar2 se(a2) noconstant nonumbers nogaps  label tex fragment replace nomtitles nolines noeqlines b(a2)
}

} /* End other time conditional */


******************************
* Non-linearity
******************************
if `nonlinearity' == 1 {
* Reading data
use "`work'/data/Twosample_full.dta", clear
* use "`work'/data/atus_proc.dta", clear
* use "`work'/data/ATUS_xsec_FT65.dta", clear
* Subsetting to ATUS, continental US
keep if group==2 & inlist(time_zone, "P", "M", "C", "E")

* Variable handling
mkspline lat_10_ 10 = latitude
mkspline pd_ 5 = pop_density
mkspline cd_ 3 = coast_dist
gen lnsleep = log(sleep)
encode time_zone, generate(ATUStzcode)
gen state_coded = (fips == fips2)
gen coast = ((coastal == 1 & coast_dist < 1) | (coast_dist < 1 & state_coded == 1))
gen cc = coast_dist*coast

* Variable labeling
label variable ln_wkly_wage "ln(earnings)"
label variable sleep "Sleep"
label variable sunset_time_avg "Avg. sunset time"
label variable lnsleep "ln(sleep)"
label variable sleep_base "Sleep and naps"

* Figure code (adapted from SR code)
quietly: summarize sleep if !missing(ln_wkly_wage)
local avg_sleep = r(mean)
capture drop sleep_hat
capture drop wage_resid
capture drop wage_hat
capture drop sleep_hat_resid
capture drop sleep_hat_resid_avg
regress sleep sunset_time_avg `geographic' `demographic' [aweight=obs]
predict sleep_hat if e(sample), xb /* used for lpoly below */
regress sleep_hat `geographic' `demographic' [aweight=obs]
predict sleep_hat_resid if e(sample), residuals
regress ln_wkly_wage `geographic' `demographic' [aweight=obs]
predict wage_resid if e(sample), residuals
predict wage_hat if e(sample)
gen sleep_hat_resid_avg = sleep_hat_resid + `avg_sleep'
lpoly wage_resid sleep_hat_resid, noscatter ci level(95) degree(1) ytitle("Residual log earnings") xtitle("Instrumented sleep") xlabel(-.6(.2).6) title("")
graph export "`work'/graphs/residwage_sleephat_lpoly_LR.pdf", as(pdf) replace

* Kim and Petrin
* Higher-order control functions and interactions often statistically significant, but do not appreciably change coefficients of interest
capture program drop KPendog2step
global base_control "`geographic' `demographic'"
global lhs "ln_wkly_wage"
gen sleep2 = sleep^2
gen sleep3 = sleep^3
gen sleep4 = sleep^4
program KPendog2step, eclass
	version 14
	tempname b
	capture drop ehat* etilde*
	regress sleep $base_control sunset_time_avg
	predict ehat1, residuals
	gen etilde1 = ehat1
	gen etilde1XSST = etilde1 * sunset_time_avg
	gen ehat2 = ehat1^2
	quietly regress ehat2 sunset_time_avg
	predict etilde2, residuals
	gen etilde2XSST = etilde2 * sunset_time_avg
	regress $lhs $base_control sleep sleep2 etilde1* etilde2* [aweight=obs] if !missing($lhs)
	matrix `b' = e(b)
	ereturn post `b'
end

keep if !missing(ln_wkly_wage, sunset_time_avg, sleep, race_1, race_2, race_3, race_4, gender, mean_age, age2, coast_dist, coast, cc)
eststo clear
bootstrap _b[sleep] _b[sleep2] /*_b[sleep3] _b[sleep4]*/, reps(100) seed(47) cluster(fips): KPendog2step
eststo

* Graph
twoway function y=(_b[_bs_1]*x)+(_b[_bs_2]*x^2)/*+(_b[_bs_3]*x^3)+(_b[_bs_4]*x^4)*/, range(57.1 58.3) ///
|| function y=(1.96*(_se[_bs_1]+_se[_bs_2]/*+_se[_bs_3]+_se[_bs_4])*/)+(_b[_bs_1]*x)+(_b[_bs_2]*x^2)/*+(_b[_bs_3]*x^3)+(_b[_bs_4]*x^4)*/), range(57.1 58.3) lpattern(dash) ///
|| function y=(-1.96*(_se[_bs_1]+_se[_bs_2]/*+_se[_bs_3]+_se[_bs_4])*/)+(_b[_bs_1]*x)+(_b[_bs_2]*x^2)/*+(_b[_bs_3]*x^3)+(_b[_bs_4]*x^4)*/), range(57.1 58.3) lpattern(dash) ///
name(kp, replace) xtitle("Sleep") ytitle("Residual log earnings") title("") legend(off)
graph export "`work'/graphs/KPplot_xsec.pdf", as(pdf) replace

} /* End nonlinearity conditional */


******************************
* Bedtime & wake-up
******************************
if `bedwake' == 1 {

eststo clear
eststo: regress bedtime `geographic' `demographic' sunset_time_avg  [aweight=obs], vce(robust)
eststo: regress waketime `geographic' `demographic' sunset_time_avg  [aweight=obs], vce(robust)
if `output' == 1 {
	esttab using "`work'/tables/xsec/ATUS_xsec_bedwake.tex", ///
	keep(sunset_time_avg) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	se(a2) noconstant nonumbers nogaps noobs label tex fragment replace nomtitles nolines noeqlines b(a2)
}

} /* End bedtime & wake-up conditional */

if `part_time' == 1 {
   use "`work'/data/Twosample_all.dta", clear
   label var part_time "Part-time employed"
	regress part_time sunset_time_avg `geographic' `demographic' [aweight=obs], vce(robust)
	eststo rf
	esttab using "`work'/tables/xsec/ATUS_xsec_part_time.tex", ///
	keep(sunset_time_avg) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	se(a2) noconstant nonumbers nogaps noobs label tex fragment replace nomtitles nolines noeqlines b(a2)

}

timer off 1
timer list 1
capture log close



