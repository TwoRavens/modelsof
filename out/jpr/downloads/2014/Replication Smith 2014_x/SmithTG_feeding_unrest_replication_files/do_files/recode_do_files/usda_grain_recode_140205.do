**** PREP USDA GRAIN COMMODITY DATA *****
*** prepares data for use by MASTER ANALYSIS
*** Todd G. Smith
*** updated 5 February 2014


set more off

cd "/Users/tgsmitty/Documents/Active Projects/Feeding Unrest Africa/analysis"
*cd "/Users/tgsmitty/Desktop/USDA PSD data"
capture erase temp.dta
insheet using "data/raw_data/usda_psd_grains_pulses_131120.csv", clear

/*
attribute_id	attribute_description	unit_id	unit_description
4				Area Harvested			4		(1000 HA)
20				Beginning Stocks		8		(1000 MT)
125				Domestic Consumption	8		(1000 MT)
176				Ending Stocks			8		(1000 MT)
88				Exports					8		(1000 MT)
130				Feed Dom. Consumption	8		(1000 MT)
192				FSI Consumption			8		(1000 MT)
57				Imports					8		(1000 MT)
28				Production				8		(1000 MT)
178				Total Distribution		8		(1000 MT)
86				Total Supply			8		(1000 MT)
113				TY Exports				8		(1000 MT)
84				TY Imp. from U.S.		8		(1000 MT)
81				TY Imports				8		(1000 MT)
184				Yield					26		(MT/HA)

20 Beginning Stocks + 28 Production + 57 Imports
= 88 Exports + 125 Domestic Consumption + 176 Ending Stocks

410000	Wheat
411000	Wheat, Durum
422110	Rice, Milled
430000	Barley
440000	Corn
451000	Rye
452000	Oats
459100	Millet
459200	Sorghum
459900	Mixed Grain
*/

keep if commodity_code == 410000

*keep if attribute_id == 57 | attribute_id == 88 | attribute_id == 20 | attribute_id == 28 | attribute_id == 125 | attribute_id == 88 | attribute_id == 176
*replace value = -value if attribute_id == 125 | attribute_id == 88 | attribute_id == 176
*egen total = sum(value), by(country_code market_year)

keep if attribute_id == 57 | attribute_id == 88 | attribute_id == 125
sort country_code commodity_code market_year
drop calendar_year month attribute_description unit_id unit_description commodity_code commodity_description
reshape wide value, i(country_code market_year) j(attribute_id)
rename value57 wheat_imp
rename value88 wheat_exp
rename value125 wheat_cons

save temp, replace

insheet using "data/raw_data/usda_psd_grains_pulses_131120.csv", clear
keep if commodity_code == 422110
keep if attribute_id == 57 | attribute_id == 88 | attribute_id == 125
sort country_code commodity_code market_year
drop calendar_year month attribute_description unit_id unit_description commodity_code commodity_description
reshape wide value, i(country_code market_year) j(attribute_id)
rename value57 rice_imp
rename value88 rice_exp
rename value125 rice_cons
merge 1:1 country_code market_year using temp
drop _merge
save temp, replace

insheet using "data/raw_data/usda_psd_grains_pulses_131120.csv", clear
keep if commodity_code == 440000
keep if attribute_id == 57 | attribute_id == 88 | attribute_id == 125
sort country_code commodity_code market_year
drop calendar_year month attribute_description unit_id unit_description commodity_code commodity_description
reshape wide value, i(country_code market_year) j(attribute_id)
rename value57 corn_imp
rename value88 corn_exp
rename value125 corn_cons
merge 1:1 country_code market_year using temp
drop _merge

*egen wheat_tot = sum(wheat_bal), by(market_year)
*egen rice_tot = sum(rice_bal), by(market_year)
*egen corn_tot = sum(corn_bal), by(market_year)

rename country_code fips

save temp, replace

use "data/raw_data/ISO_codes_131121.dta"
drop if fips == ".."
merge 1:m fips using temp.dta
keep if _merge == 3
xtset iso_num market_year
tsfill, full
drop _merge ldc land country_name iso2 wb_code cow_abbrev cow_code 
rename market_year year
sort iso_num year

*foreach var of varlist

lab var corn_imp "Maize Imports (1000 mt)"
lab var corn_exp "Maize Exports (1000 mt)"
lab var corn_cons "Maize Domestic Consumption (1000 mt)"
lab var rice_imp "Rice Imports (1000 mt)"
lab var rice_exp "Rice Exports (1000 mt)"
lab var rice_cons "Rice Domestic Consumption (1000 mt)"
lab var wheat_imp "Wheat Imports (1000 mt)"
lab var wheat_exp "Wheat Exports (1000 mt)"
lab var wheat_cons "Wheat Domestic Consumption (1000 mt)"

gen comp_imp = wheat_imp + rice_imp + corn_imp
gen comp_exp = wheat_exp + rice_exp + corn_exp
gen comp_cons = wheat_cons + rice_cons + corn_cons

lab var comp_imp "Combined maize, rice and wheat Imports (1000 mt)"
lab var comp_exp "Combined maize, rice and wheat Exports (1000 mt)"
lab var comp_cons "Combined maize, rice and wheat Consumption (1000 mt)"

/*
expand 11
sort iso_num year
egen month = fill(1 2:12 1 2:12)
gen time = ((year - 1960) * 12) + month - 1
format time %tmMon_CCYY
xtset iso_num time

foreach var of varlist corn_imp corn_exp corn_cons rice_imp rice_exp rice_cons wheat_imp wheat_exp wheat_cons {
	replace `var' = `var' / 12
	}
*/

gen corn_bal = corn_exp - corn_imp
lab var corn_bal "Trade balance in corn (1000 mt)"
gen rice_bal = rice_exp - rice_imp
lab var rice_bal "Trade balance in milled rice (1000 mt)"
gen wheat_bal = wheat_exp - wheat_imp
lab var wheat_bal "Trade balance in wheat (1000 mt)"

foreach var of varlist corn_bal rice_bal wheat_bal {
	egen mean = mean(`var')
	egen sd = sd(`var')
	gen std_`var' = (mean - `var') / sd
	drop mean sd
	}

lab var std_corn_bal "Standardized trade balance in corn"
lab var std_rice_bal "Standardized trade balance in rice"
lab var std_wheat_bal "Standardized trade balance in wheat"

sum corn_imp - std_wheat_bal

foreach grain in wheat rice corn {
	egen tot_`grain'_exp = sum(`grain'_exp), by(year)
	gen `grain'_share = `grain'_exp / tot_`grain'_exp
	lab var `grain'_share "Share of total global `grain' exports"
	drop tot_`grain'_exp
	}

drop if africa == 0
drop africa

compress
save "data/usda_grain_recode.dta", replace
erase temp.dta

count
