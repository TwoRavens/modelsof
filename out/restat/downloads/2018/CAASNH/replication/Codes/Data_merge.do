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

merge 1:1 ctyc year using "$datadir/Data/PWT/pwt_data.dta", keepusing(ctyc year gdp_curr_ppp gdp_const_ppp pl_gdp labsh labsh_mean cap_pc pop)
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
** --------------------------------------- ** 

foreach var in alpha_T alpha_N alpha_total {
	bysort year: egen xx`var' = mean(`var')
	replace `var' = xx`var' if `var' == .
	drop xx`var'
}

gen alpha_scaling = labsh/alpha_total
replace alpha_T = 1 - alpha_scaling*(1 - alpha_T)
replace alpha_N = 1 - alpha_scaling*(1 - alpha_N)

foreach var in alpha_T alpha_N alpha_total theta_T theta_N sigma_TN sigma_TT sigma_NN sigma_NT omega_N {
	bysort year: egen xx`var' = mean(`var')
	replace `var' = xx`var' if `var' == .
	drop xx`var'
}


*Create model betas

gen theta_bar_N = theta_N + sigma_TN*(1 - theta_N) + sigma_NT*(1 - theta_T)
gen beta_ky = (omega_N*(alpha_T*theta_T - alpha_N*theta_N))/(theta_bar_N)
gen beta_gdp = (omega_N*(theta_N - theta_T))/(theta_bar_N)

foreach varn in beta_ky beta_gdp omega_N {
	gen xx`varn' = `varn' if year == 2011
	drop `varn'
	sum xx`varn'
	scalar mean`varn' = r(mean)
	bysort ctyc: egen `varn' = mean(xx`varn')
	replace `varn' = mean`varn' if `varn' == .
	drop xx`varn'
}

local varlist pl_gdp gdp_const gdp_curr gdp_const_ppp gdp_curr_ppp cap_pc 
foreach var in `varlist' {
	gen xx`var'_US=`var' if ctyc == "USA"
	bysort year: egen `var'_US = mean(xx`var'_US)
	drop xx`var'_US
}

gen pl_gdp_PWT_relus = log(pl_gdp) - log(pl_gdp_US)
gen gdp_curr_logdifUS = log(gdp_curr) - log(gdp_curr_US)
gen gdp_ppp_logdifUS = log(gdp_curr_ppp) - log(gdp_curr_ppp_US)
gen gdp_const_logdifUS = log(gdp_const) - log(gdp_const_US)

gen RER_model = beta_ky*(log(cap_pc) - log(cap_pc_US)) + beta_gdp*(gdp_curr_logdifUS)
gen RER_model_ky = beta_ky*(log(cap_pc) - log(cap_pc_US))
gen RER_model_gdp = beta_gdp*(gdp_curr_logdifUS)
gen RER_model_resid = pl_gdp_PWT_relus - RER_model

keep if year >= 1980 & year <= 2014
keep if pl_gdp_PWT_relus != . & gdp_ppp_logdifUS != . & RER_model != . & gdp_const_logdifUS != .

save "$datadir/Data/output/master.dta", replace
