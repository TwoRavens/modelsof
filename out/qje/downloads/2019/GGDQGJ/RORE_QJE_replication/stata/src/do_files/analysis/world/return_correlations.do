/*--------------------------------------------------------------

This file calculates correlations in asset returns (within-country)
	by time period and country
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths



*========================== Settings =============================================
* Variables to correlate
local tocorrel ""bond_tr inflation" "bill_rate inflation" "r_bond_tr r_bill_rate" "r_eq_tr r_housing_tr" "r_safe_tr r_risky_tr" "eq_tr inflation" "housing_tr inflation" "r_bond_tr r_eq_tr" "r_bond_tr r_housing_tr" "risky_tr inflation" "safe_tr inflation" "capital_tr inflation""
local names ""bond_inf" "bill_inf" "bond_bill" "eq_hous" "risky_safe" "eq_inf" "hous_inf" "bond_eq" "bond_hous" "risky_inf" "safe_inf" "cap_inf""
local labels ""Bonds vs inflation" "Bills vs inflation" "Bonds vs bills (real)" "Equity vs housing (real)" "Risky rate vs safe rate (real)" "Equity (nominal) vs inflation" "Housing (nominal) vs inflation" "Bond return vs equity (real)" "Bond return vs housing (real)" "Risky rate vs inflation" "Safe rate vs inflation" "Return on capital vs inflation""

local ncorr : word count `tocorrel'

* Window
local window 11
local wind1 = `window'-1

* Country marker
local country ccode

*========================== Calculate correlations =============================================

* 1/ Average of by-country correlations xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

* Import data
use "${rore}/bld/data_out/rore_core_dataset.dta", clear

xtset ccode year, yearly
sort ccode year

forvalues i = 1/`ncorr'	{
	* Load parameters
	local v`i' : word `i' of `tocorrel'
	local n`i' : word `i' of `names'
	local l`i' : word `i' of `labels'
	local s`i' : word 1 of `v`i''
	local e`i' : word 2 of `v`i''
	
	* Make sure start of correlations has data on both variables for the window years.
	qui su year if `s`i'' !=.
	local start = r(min)
	local end = r(max)-`wind1'
	qui su year if `e`i'' !=.
	local start = max(`start',r(min))
	local end = min(`end',r(max)-`wind1')
	
	* Calculate and store correlations
	qui gen correl_c_av_`n`i'' =.

	forvalues t = `start'/`end'	{
		qui correlate `v`i'' if  year>=`t' & year <=`t'+`wind1'
		qui replace correl_c_av_`n`i'' = r(rho) if  year==`t'+`wind1' & iso == "AUS"
	}	

	* Center the correlation
	local forward = floor(`wind1'/2)+1
	gen corr_new = f`forward'.correl_c_av_`n`i''
	drop correl_c_av_`n`i''
	ren corr_new correl_c_av_`n`i''
	label var correl_c_av_`n`i'' "`l`i''"

}

drop if iso != "AUS"
keep year correl_*
gen iso = "WORLD"

* Interim save ---------------------------------------------------------------
save "${rore}/bld/data_out/correlations.dta", replace


* 2/ World-level and by-country rolling correlations xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

* Import data
use "${rore}/bld/data_out/r_minus_g.dta", clear

xtset `country' year
sort `country' year

qui su `country'
local cnum = r(max)

* Bound for enough observations to calculate correlations
local bound = 0.8*`wind1'

* 2-1/ Country loop xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
forvalues j = 1/`cnum'	{

	* 2-2/ Variable loop xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	forvalues i = 1/`ncorr'	{
		* Load parameters
		local v`i' : word `i' of `tocorrel'
		local n`i' : word `i' of `names'
		local l`i' : word `i' of `labels'
		local s`i' : word 1 of `v`i''
		local e`i' : word 2 of `v`i''
		
		* Make sure start of correlations has data on both variables for the window years.
		qui su year if `s`i'' !=. & `country' == `j'
		local start = r(min)
		local end = r(max)-`wind1'
		qui su year if `e`i'' !=. & `country' == `j'
		local start = max(`start',r(min))
		local end = min(`end',r(max)-`wind1')
		
		* Calculate and store correlations
		* Create variable if first in the loop
		if `j' == 1	{
			qui gen correl_`n`i'' =.
			label var correl_`n`i'' "`l`i''"
		}
		* Compute by-country correlations
		forvalues t = `start'/`end'	{
			* Make sure window has enough data
			qui su `s`i''  if  year>=`t' & year <=`t'+`wind1' & `country' == `j'
			local samp1 = r(N)
			qui su `e`i''  if  year>=`t' & year <=`t'+`wind1' & `country' == `j'
			local samp2 = r(N)
			
			* Correlate
			if (`samp1' > `bound' & `samp2' > `bound')	{
				qui correlate `v`i'' if  year>=`t' & year <=`t'+`wind1' & `country' == `j'
				qui replace correl_`n`i'' = r(rho) if  year==`t'+`wind1' & `country' == `j'
			}
			
		}	
		
	}

}
* Center the correlation
forvalues i = 1/`ncorr'	{
	local n`i' : word `i' of `names'
	local l`i' : word `i' of `labels'
	
	local forward = floor(`wind1'/2)+1
	gen corr_new = f`forward'.correl_`n`i''
	drop correl_`n`i''
	ren corr_new correl_`n`i''
	label var correl_`n`i'' "`l`i''"
}

* Tidy and merge
keep iso country ccode year correl_*

merge 1:1 iso year using "${rore}/bld/data_out/correlations.dta", gen(_merge1)
drop _merge*

*========================== Final Save =============================================
save "${rore}/bld/data_out/correlations.dta", replace
