********************************************************************************
** Regression Discontinuity Designs Using Covariates
** Author: Calonico, Cattaneo, Farrell and Titiunik
** Last update: 07-MAY-2018
********************************************************************************
** WEBSITE: https://sites.google.com/site/rdpackages/
** RDROBUST: net install rdrobust, from(https://sites.google.com/site/rdpackages/rdrobust/stata) replace
********************************************************************************
clear all
set more off
set linesize 200
	
********************************************************************************
** Open the post file
********************************************************************************
postfile filepost str30(application) ///
         double(Ntr Nco h b rho tau pvalrb  CIlrb CIurb  CIlenchange) str20(case) ///
		 using "postfile-results.dta", replace

gl dec = 0.00001

********************************************************************************
** Head Start Data
********************************************************************************
use "headstart.dta", clear

gl y mort_age59_related_postHS
gl x povrate60
gl z census1960_pop census1960_pctsch1417 census1960_pctsch534 ///
     census1960_pctsch25plus census1960_pop1417 census1960_pop534 ///
	 census1960_pop25plus census1960_pcturban census1960_pctblack

** rho unrestricted; MSE-optimal bandwidths w/o covs; RD w/o covs
qui rdrobust $y $x, c(59.1968)
local h = e(h_l)
local b = e(b_l)
local IL =  e(ci_r_rb) - e(ci_l_rb)
post filepost ("Head-Start") (e(N_h_r)) (e(N_h_l)) (round(e(h_l), $dec)) (round(e(b_l), $dec)) ///
			  (round(e(h_l)/e(b_l), $dec)) (round(e(tau_cl), $dec)) (round(e(pv_rb),$dec)) ///
			  (round(e(ci_l_rb), $dec)) (round(e(ci_r_rb), $dec)) (0) ("nocov")

** rho unrestricted; MSE-optimal bandwidths w/o covs; RD w/ covs
qui rdrobust $y $x, c(59.1968) covs($z) h(`h') b(`b')
local ILch = round((((`e(ci_r_rb)' - `e(ci_l_rb)')/`IL') - 1)* 100, 0.001)
post filepost ("Head-Start") (e(N_h_r)) (e(N_h_l)) (round(e(h_l), $dec)) (round(e(b_l), $dec)) ///
			  (round(e(h_l)/e(b_l), $dec)) (round(e(tau_cl), $dec)) (round(e(pv_rb),$dec)) ///
			  (round(e(ci_l_rb), $dec)) (round(e(ci_r_rb), $dec)) (round(`ILch', $dec)) ("cov-subh")

** rho unrestricted; MSE-optimal bandwidths w/ covs; RD w/ covs
qui rdrobust $y $x, c(59.1968) covs($z)
local ILch = round((((`e(ci_r_rb)' - `e(ci_l_rb)')/`IL') - 1)* 100, 0.001)
post filepost ("Head-Start") (e(N_h_r)) (e(N_h_l)) (round(e(h_l), $dec)) (round(e(b_l), $dec)) ///
			  (round(e(h_l)/e(b_l), $dec)) (round(e(tau_cl), $dec)) (round(e(pv_rb),$dec)) ///
			  (round(e(ci_l_rb), $dec)) (round(e(ci_r_rb), $dec)) (round(`ILch', $dec)) ("cov")

** rho=1; MSE-optimal bandwidths w/o covs; RD w/o covs
qui rdrobust $y $x, c(59.1968) rho(1)
local h = e(h_l)
local b = e(b_l)
local IL =  e(ci_r_rb) - e(ci_l_rb)
post filepost ("Head-Start") (e(N_h_r)) (e(N_h_l)) (round(e(h_l), $dec)) (round(e(b_l), $dec)) ///
			  (round(e(h_l)/e(b_l), $dec)) (round(e(tau_cl), $dec)) (round(e(pv_rb),$dec)) ///
			  (round(e(ci_l_rb), $dec)) (round(e(ci_r_rb), $dec)) (0) ("nocov")

** rho=1; MSE-optimal bandwidths w/o covs; RD w/ covs
qui rdrobust $y $x, c(59.1968) covs($z) h(`h') b(`b')
local ILch = round((((`e(ci_r_rb)' - `e(ci_l_rb)')/`IL') - 1)* 100, 0.001)
post filepost ("Head-Start") (e(N_h_r)) (e(N_h_l)) (round(e(h_l), $dec)) (round(e(b_l), $dec)) ///
			  (round(e(h_l)/e(b_l), $dec)) (round(e(tau_cl), $dec)) (round(e(pv_rb),$dec)) ///
			  (round(e(ci_l_rb), $dec)) (round(e(ci_r_rb), $dec)) (round(`ILch', $dec)) ("cov-subh")

** rho=1; MSE-optimal bandwidths w/ covs; RD w/ covs
qui rdrobust $y $x, c(59.1968) covs($z) rho(1)
local ILch = round((((`e(ci_r_rb)' - `e(ci_l_rb)')/`IL') - 1)* 100, 0.001)
post filepost ("Head-Start") (e(N_h_r)) (e(N_h_l)) (round(e(h_l), $dec)) (round(e(b_l), $dec)) ///
			  (round(e(h_l)/e(b_l), $dec)) (round(e(tau_cl), $dec)) (round(e(pv_rb),$dec)) ///
			  (round(e(ci_l_rb), $dec)) (round(e(ci_r_rb), $dec)) (round(`ILch', $dec)) ("cov")

********************************************************************************
** Close postfile
********************************************************************************
postclose filepost 

