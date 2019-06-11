/*--------------------------------------------------------------

This file calculates correlations across countries for each asset 
	(graph plots in separate .do file)
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths



*========================== Settings =============================================
* Variables to correlate
local tocorrel r_bond_tr r_bill_rate r_eq_tr r_housing_tr r_safe_tr r_risky_tr r_capital_tr risk_premium
local labs ""Bond return (real)" "Bill rate (real)" "Equity return (real)" "Housing return (real)" "Safe rate (real)" "Risky return (real)" "Rate of return on capital (real)" "Risk premium (risky -- safe return)""
local ncorr : word count `tocorrel'

* Window
local window 11
local wind1 = `window'-1

*========================== Import data =============================================
use "${rore}/bld/data_out/rore_core_dataset.dta", clear

* Country marker
local country ccode
qui su `country'
local cnum = r(max)

* Panel set-up
*xtset `country' year, yearly

*========================== Manipulate data =============================================
* Reshape to wide: for each year, have a column for each country-variable observation

keep `tocorrel' year `country'
reshape wide `tocorrel', i(year) j(`country')

set obs 1000

tsset year, yearly

*========================== Calculate correlations =============================================

forvalues i = 1/`ncorr'	{
	* Load parameters
	local s`i' : word `i' of `tocorrel'
	local l`i' : word `i' of `labs'
	
	* Make sure start of correlations has data for the window years.
	qui su year
	local start = r(min)
	local end = r(max)-`wind1'
	
	* Variable to store correlations
	gen correl_`s`i'' = .
	
	* Loop over windows
	forvalues t = `start'/`end'	{
		* Window
		local wmin = `t'
		local wmax = `t'+`wind1'
		* Variable to store data
		qui gen correl_`wmax' = .
		
		* Loop over countries: correlate all pairs
		* First country in pair
		forvalues j = 1/`cnum'	{
			
			* Second country in pair
			forvalues k = 1/`cnum'	{
				local count = `j'*(`k'-1) + `k'
				if `k' != `j'	{
					* Check that we have observations for both countries during the window
					qui count if `s`i''`k' !=. & `s`i''`j' !=. & tin(`wmin',`wmax')
					
					local obs = r(N)
					
					* only correlate if have enough observations
					if `obs' >= floor(`window'/1.5)	{
						qui correlate `s`i''`k' `s`i''`j'  if  year>=`t' & year <=`t'+`wind1'
						
						* Store correlations in one variable
						qui replace correl_`wmax' = r(rho) in `count'
						
					}
					
				}
				
			}
		}
		
		* Store average correlation for that year and asset
		qui su correl_`wmax'
		qui replace correl_`s`i'' = r(mean) if year == `wmax'
		drop correl_`wmax'
	}
	* Center correlation datapoint in the middle of the window
	local forward = floor(`wind1'/2)+1
	gen corr_new = f`forward'.correl_`s`i''
	drop correl_`s`i''
	ren corr_new correl_`s`i''
	label var correl_`s`i'' "`l`i'' cross-country correlations, window = `window' years"
}

* Tidy up
keep year correl*
drop if year ==.

*========================== Final Save =============================================
save "${rore}/bld/data_out/correlations_crosscountry.dta", replace
