//============================================================================//
//	           Construct main dataset used in the paper and appendix	 	  //
//============================================================================//

clear all
set more off

*======================= Path settings =============================================

*global main_dir "~/Dropbox/rore/RORE_QJE_replication"

cd "${main_dir}"

include paths

*======================= Import data =============================================

use "${main_dir}/data/rore_public_main.dta", clear

merge 1:1 iso year using "${main_dir}/data/rore_public_supplement.dta", nogen


xtset ccode year

*======================= Variables and labels =============================================

* 1/ Country code ------------------------------------------------------------------------------
capture drop ccode*
egen ccode = group(country)
sort ccode year
xtset ccode year, yearly

* 2/ Time periods --------------------------------------------------------------------------------

* Wars
gen tp_nowar=0
replace tp_nowar=1 if (year>=1870 & year<=1913) | (year>=1920 & year<=1938) | (year>=1948)
gen tp_war = 0
replace tp_war = 1 if tin(1914,1919) | tin(1939,1946)
gen tp_ww1 = 0
replace tp_ww1 = 1 if tin(1914,1919)
gen tp_ww2 = 0
replace tp_ww2 = 1 if tin(1939,1946)
* No GFC
gen tp_nogfc = 1 if year < 2008


* Broad periods
local postpers 1900 1950 1980
foreach p of local postpers	{
	gen tp_post`p' = 0
	replace tp_post`p' = 1 if year >= `p'
}

* Subperiods for risky vs safe
gen tp_pre1900 = 1 if year < 1900
gen tp_post46to80 = 1 if year>1947 & year <1980
gen tp_post50to80 = 1 if year>1950 & year <1981
gen tp_last20 = 1 if year>1995

* Decades
gen decade = .
forvalues i = 1/15	{
	local start = 1871 + (`i'-1)*10
	local end = 1880 + (`i'-1)*10
	replace decade = `i' if tin(`start',`end')
}
replace decade = 1 if year == 1870

* 3/ Real returns ------------------------------------------------------------------------
local toreal_returns "eq_capgain eq_tr bill_rate bond_rate bond_tr housing_tr housing_capgain safe_tr risky_tr capital_tr housing_tr_low housing_tr_high housing_tr_loclow housing_tr_lochigh"
local toreal_labs ""Equity cap. gain" "Equity total return" "Bill rate" "Bond rate" "Bond total return" "Housing return" "Housing capital gain" "Safe return" "Risky return" "Return on capital""

local nreal : word count `toreal_returns'

forvalues j = 1/`nreal'	{
	local v`j' : word `j' of `toreal_returns'
	local l`j' : word `j' of `toreal_labs'

	* use the "technically correct" formula rather than simply return - inflation,
	*	otherwise small errors cumulate
	gen r_`v`j'' = (1+`v`j'')/(1 + inflation)-1
	
	label var r_`v`j'' "Real `l`j''"
}

* 9/ US $ returns; real return is US $ return - US inflatoin -----------------------------------------
local tousd_returns "eq_tr housing_tr bond_tr bill_rate"
local tousd_labs "Equity Housing Bonds Bills"
local nusd : word count `tousd_returns'

* US inflation, bill and bond rates
local usvars inflation bond_tr bill_rate r_bond_tr r_bill_rate
foreach v of local usvars	{
	gen us_`v' = `v' if iso == "USA"
	by year (us_`v'), sort : replace us_`v' = us_`v'[_n-1] if us_`v' ==.
}
xtset ccode year


forvalues i = 1/`nusd'	{
	local r : word `i' of `tousd_returns'
	local lab : word `i' of `tousd_labs'
	
	* USD returns, nominal and real
	gen usd_`r' = (1+`r')*l.xrusd/xrusd - 1
	label var usd_`r' "USD `lab' return, nominal"
	gen usd_r_`r' = (1+usd_`r')/(1 + us_inflation)-1
	label var usd_r_`r' "USD `lab' return, real"
	
	* USD housing fix - make sure we're consistent despite depreciaiton etc. fixes
	replace usd_`r' = `r' if iso == "USA"
	replace usd_r_`r' = r_`r' if iso == "USA"
	
	* USD excess returns
	gen usd_excess_`r' = usd_r_`r' - us_r_bill_rate
	gen usd_bondexess_`r' = usd_r_`r' - us_r_bond_tr
}


* 4/ Excess returns ------------------------------------------------------------------------
local toexcess_returns "eq_tr housing_tr bond_rate bond_tr"
local toexcess_labs "Equity Housing Bonds Bonds"

local nexc : word count `toexcess_returns'

* Use differences in real returns for a consistent sample
forvalues i = 1/`nexc'	{
	local v`i' : word `i' of `toexcess_returns'
	local l`i' : word `i' of `toexcess_labs'

	gen nom_excess_`v`i'' = `v`i'' - bill_rate
	gen excess_`v`i'' = r_`v`i'' - r_bill_rate
	
	label var nom_excess_`v`i'' "`l`i'' excess return over bills; nominal rates used"
	label var excess_`v`i'' "`l`i'' excess return over bills; real rates used"
	if "`v`i''" != "bond_rate" & "`v`i''" != "bond_tr" {
		gen nom_bondexcess_`v`i'' = `v`i'' - bond_tr
		gen bondexcess_`v`i'' = r_`v`i'' - r_bond_tr
		
		label var nom_bondexcess_`v`i'' "`l`i'' excess return over bonds; nominal rates used"
		label var bondexcess_`v`i'' "`l`i'' excess return over bonds; real rates used"
	}
}

order iso country year eq_tr r_eq_tr housing_tr r_housing_tr bond_tr r_bond_tr bill_rate r_bill_rate

* 5/ Sample dummy ------------------------------------------------------------------------
local insample r_eq_tr r_housing_tr r_bond_tr r_bill_rate
gen sample =1
foreach s of local insample	{
	replace sample = 0 if `s' ==.
}

* 6/ Weights; for weighted averages ------------------------------------------------------------------------
gen weight = rgdpmad*pop
label var weight "Weight: real GDP"

* 7/ Real GDP growth for r - g comparison ---------------------------------------------------------------------
gen rgdp = rgdpmad*pop
label var rgdp "Real GDP"
gen rgdp_growth = d.rgdp/l.rgdp
label var rgdp_growth "Real GDP growth"

* 8/ Equally-weighted proxies for the return on capital and risky rate
* Capital
gen r_capital_tr_simple = r_eq_tr/3 + r_housing_tr/3 + r_bond_tr/3
label var r_capital_tr_simple "Real return on capital, equal weighting (1/3 equity, housing, bonds)"

gen capital_tr_simple = eq_tr/3 + housing_tr/3 + bond_tr/3
label var capital_tr_simple "Nominal return on capital, equal weighting (1/3 equity, housing, bonds)"
 
* Keep simple 1/2 1/2 weights for comparison
gen r_risky_tr_simple = r_eq_tr/2 + r_housing_tr/2
label var r_risky_tr_simple "Real risky rate, equal weighting (1/2 equity, housing)"

gen risky_tr_simple = eq_tr/2 + housing_tr/2
label var risky_tr_simple "Nominal risky rate, equal weighting (1/2 equity, housing)"

* 9/ Risk premium ------------------------------------------------------------------------
gen risk_premium = r_risky_tr - r_safe_tr
label var risk_premium "Risk premium (risky minus safe return)"

gen risk_premium_simple = r_risky_tr_simple - r_safe_tr
label var risk_premium_simple "Risk premium (risky minus safe return), equal weighting"

*======================= Cumulative rtn indices =============================================

* Specify series to cumulate
local tocum eq_capgain r_eq_tr r_housing_tr r_bond_tr r_bill_rate

* Specify gap countries for each series
* 1 gap
local 1gap_r_eq_tr FIN ITA JPN
local 1gap_eq_capgain JPN
local 1gap_r_housing_tr ITA JPN GBR BEL
local 1gap_r_bond_tr BEL DNK FIN ITA ESP CHE
local 1gap_r_bill_rate AUS BEL FIN FRA ESP

* 2 gaps
local 2gap_r_eq_tr DEU
local 2gap_r_housing_tr DEU FIN
local 2gap_r_bond_tr JPN
local 2gap_r_bill_rate JPN

* 3 gaps
local 3gap_r_eq_tr
local 3gap_r_housing_tr
local 3gap_r_bond_tr DEU
local 3gap_r_bill_rate DEU ITA

* Outer loop: series
foreach s of local tocum	{

	* Base year
	gen base_year_`s' = .
	replace base_year_`s' = 1 if f.`s' !=. & year == 1870 | (f.`s' !=. & `s' ==.)
	* End year
	gen end_year_`s' =.
	replace end_year_`s' = 1 if f.`s' ==. & `s' !=.

	* Cumulative indices, not accounting for gaps
	gen cum_`s' =.
	replace cum_`s' = 1 if base_year_`s' == 1
	replace cum_`s' = l.cum_`s'*(1+`s') if base_year_`s' == . & `s' !=.

	* Countries with 1 gap
	foreach g of local 1gap_`s' {

		* Generate flags for gaps in series: start and end
		replace base_year_`s' = sum(base_year_`s') if iso == "`g'" & base_year_`s' !=.
		replace end_year_`s' = sum(end_year_`s') if iso == "`g'" & end_year_`s' !=.

		su year if end_year_`s' ==1 & iso == "`g'"
		local start = r(min)
		su year if base_year_`s' == 2 & iso == "`g'"
		local end = r(min)

		*Bridging gaps in the dataset: continue with the same cum. return
		gen prev_cum_`s' = .
			
		*1/ Extrapolate previous value of the index over the gap	
		forvalues t = `start'(1)`end' {
			replace prev_cum_`s' = cum_`s' if year == `start' & iso == "`g'"
			replace prev_cum_`s' = l.prev_cum_`s' if year == `t'+1 & iso == "`g'"
		}
			
		*2/ Restart and fill in the index after the gap
		replace cum_`s' = prev_cum_`s' if year == `end' & iso == "`g'"
		replace cum_`s' = l.cum_`s'*(1+`s') if year > `end' & iso == "`g'"
			
		drop prev_*

	}
	
	* Countries with 2 gaps
	foreach g of local 2gap_`s' {

		* Generate flags for gaps in series: start and end
		replace base_year_`s' = sum(base_year_`s') if iso == "`g'" & base_year_`s' !=.
		replace end_year_`s' = sum(end_year_`s') if iso == "`g'" & end_year_`s' !=.

		su year if end_year_`s' ==1 & iso == "`g'"
		local start1 = r(min)
		su year if end_year_`s' ==2 & iso == "`g'"
		local start2 = r(min)
		su year if base_year_`s' == 2 & iso == "`g'"
		local end1 = r(min)
		su year if base_year_`s' == 3 & iso == "`g'"
		local end2 = r(min)

		
		*Bridging gaps in the dataset: continue with the same cum. return
		gen prev_cum_`s' = .
		
		* I. First Gap
		*1/ Extrapolate previous value of the index over the gap	
		forvalues t = `start1'(1)`end1' {
			replace prev_cum_`s' = cum_`s' if year == `start1' & iso == "`g'"
			replace prev_cum_`s' = l.prev_cum_`s' if year == `t'+1 & iso == "`g'"
		}
		
		*2/ Restart and fill in the index after the gap
		replace cum_`s' = prev_cum_`s' if year == `end1' & iso == "`g'"
		replace cum_`s' = l.cum_`s'*(1+`s') if year > `end1' & iso == "`g'"
		
		* II. Second Gap
		*1/ Extrapolate previous value of the index over the gap	
		forvalues t = `start2'(1)`end2' {
			replace prev_cum_`s' = cum_`s' if year == `start2' & iso == "`g'"
			replace prev_cum_`s' = l.prev_cum_`s' if year == `t'+1 & iso == "`g'"
		}
		
		*2/ Restart and fill in the index after the gap
		replace cum_`s' = prev_cum_`s' if year == `end2' & iso == "`g'"
		replace cum_`s' = l.cum_`s'*(1+`s') if year > `end2' & iso == "`g'"
		
		drop prev_*

	}

	* Countries with 3 gaps
	foreach g of local 3gap_`s' {

		* Generate flags for gaps in series: start and end
		replace base_year_`s' = sum(base_year_`s') if iso == "`g'" & base_year_`s' !=.
		replace end_year_`s' = sum(end_year_`s') if iso == "`g'" & end_year_`s' !=.

		su year if end_year_`s' ==1 & iso == "`g'"
		local start1 = r(min)
		su year if end_year_`s' ==2 & iso == "`g'"
		local start2 = r(min)
		su year if end_year_`s' ==3 & iso == "`g'"
		local start3 = r(min)
		su year if base_year_`s' == 2 & iso == "`g'"
		local end1 = r(min)
		su year if base_year_`s' == 3 & iso == "`g'"
		local end2 = r(min)
		su year if base_year_`s' == 4 & iso == "`g'"
		local end3 = r(min)

		
		*Bridging gaps in the dataset: continue with the same cum. return
		gen prev_cum_`s' = .
		
		* I. First Gap
		*1/ Extrapolate previous value of the index over the gap	
		forvalues t = `start1'(1)`end1' {
			replace prev_cum_`s' = cum_`s' if year == `start1' & iso == "`g'"
			replace prev_cum_`s' = l.prev_cum_`s' if year == `t'+1 & iso == "`g'"
		}
		
		*2/ Restart and fill in the index after the gap
		replace cum_`s' = prev_cum_`s' if year == `end1' & iso == "`g'"
		replace cum_`s' = l.cum_`s'*(1+`s') if year > `end1' & iso == "`g'"
		
		* II. Second Gap
		*1/ Extrapolate previous value of the index over the gap	
		forvalues t = `start2'(1)`end2' {
			replace prev_cum_`s' = cum_`s' if year == `start2' & iso == "`g'"
			replace prev_cum_`s' = l.prev_cum_`s' if year == `t'+1 & iso == "`g'"
		}
		*2/ Restart and fill in the index after the gap
		replace cum_`s' = prev_cum_`s' if year == `end2' & iso == "`g'"
		replace cum_`s' = l.cum_`s'*(1+`s') if year > `end2' & iso == "`g'"
		
		* III. Third Gap
		*1/ Extrapolate previous value of the index over the gap	
		forvalues t = `start3'(1)`end3' {
			replace prev_cum_`s' = cum_`s' if year == `start3' & iso == "`g'"
			replace prev_cum_`s' = l.prev_cum_`s' if year == `t'+1 & iso == "`g'"
		}
		
		*2/ Restart and fill in the index after the gap
		replace cum_`s' = prev_cum_`s' if year == `end3' & iso == "`g'"
		replace cum_`s' = l.cum_`s'*(1+`s') if year > `end3' & iso == "`g'"
		
		drop prev_*

	}

}

drop end_year* base_year*
*
* Interim save
save "${rore}/bld/data_out/rore_core_dataset.dta", replace

* Clean up
drop if iso == ""

*======================= Final Save =============================================
save "${rore}/bld/data_out/rore_core_dataset.dta", replace
