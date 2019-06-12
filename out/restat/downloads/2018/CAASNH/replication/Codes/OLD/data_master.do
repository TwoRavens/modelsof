** --------------------------------------- ** 
* Creates master data
** --------------------------------------- ** 

clear 
tempfile a

** --------------------------------------- ** 
* 1. WDI GDP and GDPPC data
** --------------------------------------- ** 

use "$datadir/Data/WDI/WDI_clean.dta", clear


** --------------------------------------- ** 
* 2. PWT (PPP) gdp, price, labor share, and capital share data
** --------------------------------------- ** 

merge 1:1 ctyc year using "$datadir/Data/PWT/pwt_data.dta", keepusing(ctyc year gdp_curr_ppp gdp_const_ppp pl_gdp labsh labsh_mean cap_pc cap_pc_for_growth pop)
drop _merge

** --------------------------------------- ** 
* 3. ICIO theta, sigma, omega, and alpha data
** --------------------------------------- ** 

merge 1:1 ctyc year using "$datadir/Data/ICIO/icio_master_sect.dta"
drop if _merge == 2
drop _merge

** --------------------------------------- ** 
* 4. ICP data
** --------------------------------------- ** 

preserve
	use "$datadir/Data/ICP_WB/ICP_master.dta", clear
	keep if sector_match_icp == 1
	keep year ctyc pn_relUS
	save `a', replace
restore

merge 1:1 ctyc year using `a', keepusing(ctyc year pn_relUS)
drop if _merge == 2
drop _merge

** --------------------------------------- ** 
*6. Create model coefficients and variables
** --------------------------------------- ** 

sort ctyc year

gen ICIO = alpha_T != .
gen PWT = pl_gdp != .
gen ICIO_rescale = alpha_T != . & labsh != .

** --------------------------------------- ** 
*6a. Coefficients
*We're going to want to create a scaling factor to get the ICIO alphas to match
*the labor compensation share in PWT in case the two are different.
*As such, use our PWT labor shares, then create the scaling factor
*based off of alpha_total. This same process is in icp_data.do for the
*industry-level charts.
*To create our betas for countries not in ICIO, we'll want to use average
*alphas, sigmas, and rescaling factors.
** --------------------------------------- ** 

*Rescale based on average alpha values, where not available
foreach var in alpha_T alpha_N alpha_total {
	bysort year: egen xx`var' = mean(`var')
	replace `var' = xx`var' if `var' == .
	drop xx`var'
}

*Generate labor rescaling variable, rescale for those with labsh data
gen alpha_scaling = labsh/alpha_total
replace alpha_T = 1 - alpha_scaling*(1 - alpha_T)
replace alpha_N = 1 - alpha_scaling*(1 - alpha_N)

*Now, for those countries without coefficients (missing alpha, labsh, and sigma data), assign the averages
foreach var in alpha_T alpha_N alpha_total theta_T theta_N sigma_TN sigma_TT sigma_NN sigma_NT omega_N {
	bysort year: egen xx`var' = mean(`var')
	replace `var' = xx`var' if `var' == .
	drop xx`var'
}

*Create model betas
gen theta_bar_N = theta_N + sigma_TN*(1 - theta_N) + sigma_NT*(1 - theta_T)

gen beta_ky = (omega_N*(alpha_T*theta_T - alpha_N*theta_N))/(theta_bar_N)
gen beta_gdp = (omega_N*(theta_N - theta_T))/(theta_bar_N)

*gen beta_ky_ppp = (omega_N*(alpha_T*theta_T - alpha_N*theta_N))/(theta_bar_N - omega_N*(theta_N - theta_T))
*gen beta_gdp_ppp = (omega_N*(theta_N - theta_T))/(theta_bar_N - omega_N*(theta_N - theta_T))
*gen beta_gdp_rcons = (omega_N*(theta_N*(1 - alpha_N) - theta_T*(1 - alpha_T)))/(theta_bar_N)


*We want to freeze the values of beta, gamma, theta, and omega in 2011, by country
*Where we do not have data for beta or omega for a given country, we want to use the average 2011 value	

*foreach varn in beta_ky beta_gdp beta_ky_ppp beta_gdp_ppp omega_N {
foreach varn in beta_ky beta_gdp omega_N {

	gen xx`varn' = `varn' if year == 2011
	drop `varn'
	sum xx`varn'
	scalar mean`varn' = r(mean)
	bysort ctyc: egen `varn' = mean(xx`varn')
	replace `varn' = mean`varn' if `varn' == .
	drop xx`varn'
}


**********************************************************
*6b. Model variables
**********************************************************
*Create "US" variables for our model, as everything will be relative to the US
local varlist pl_gdp gdp_const gdp_curr gdp_const_ppp gdp_curr_ppp cap_pc cap_pc_for_growth
foreach var in `varlist' {
	gen xx`var'_US=`var' if ctyc == "USA"
	bysort year: egen `var'_US = mean(xx`var'_US)
	drop xx`var'_US
}


*Relative-to-US variables

*Real exchange rate, data
gen pl_gdp_PWT_relus = log(pl_gdp) - log(pl_gdp_US)

*Relative GDPPC, Relative GDPPC in PPP terms
gen gdp_const_logdifUS = log(gdp_const) - log(gdp_const_US)
gen gdp_curr_logdifUS = log(gdp_curr) - log(gdp_curr_US)
gen gdp_ppp_logdifUS = log(gdp_curr_ppp) - log(gdp_curr_ppp_US)

*Standard model
gen RER_model = beta_ky*(log(cap_pc) - log(cap_pc_US)) + beta_gdp*(gdp_curr_logdifUS)
gen RER_model_ky = beta_ky*(log(cap_pc) - log(cap_pc_US))
gen RER_model_gdp = beta_gdp*(gdp_curr_logdifUS)
gen RER_model_resid = pl_gdp_PWT_relus - RER_model

*PPP model
*gen RER_model_ppp = beta_ky_ppp*(log(cap_pc) - log(cap_pc_US)) + beta_gdp_ppp*(log(gdp_curr_ppp) - log(gdp_curr_ppp_US))
*gen RER_model_ky_ppp = beta_ky_ppp*(log(cap_pc) - log(cap_pc_US))
*gen RER_model_gdp_ppp = beta_gdp_ppp*(log(gdp_curr_ppp) - log(gdp_curr_ppp_US))
*gen RER_model_resid_ppp = pl_gdp_PWT_relus - RER_model_ppp
*Constant real interest rate
*gen RER_model_gdp_rcons = beta_gdp_rcons*(gdp_curr_logdifUS)

**********************************************************
*6c. Clean up, label data sources where relevant, output
**********************************************************
/*
la var gdp_const "GDPPC, 2010 $ (WDI)"
la var gdp_curr "GDPPC, current $ (WDI)"
la var gdp_const_ppp "GDPPC, constant PPP (PWT)"
la var gdp_curr_ppp "GDPPC, current PPP (PWT)"
la var ICIO "Has ICIO data indicator"
la var PWT "Has PWT data indicator"
la var ICIO_rescale "Has enough data to rescale labsh"
*/

*Output
keep if year >= 1980 & year <= 2014
keep if pl_gdp_PWT_relus != . & gdp_ppp_logdifUS != . & RER_model != . & gdp_const_logdifUS != .
save "$datadir/Data/output/master.dta", replace
