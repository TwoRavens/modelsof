*** THE MERGING OF THE DATA *****
*** prepares data for use by MASTER ANALYSIS
*** Todd G. Smith
*** updated 28 May 2014

clear all
set more off

local user  "`c(username)'"
cd "/Users/`user'/Documents/active_projects/feeding_unrest_africa/analysis"
/*
quietly do "do_files/recode do_files/scad_recode_140131.do"
quietly do "do_files/recode do_files/acled_recode_140122.do"
quietly do "do_files/recode do_files/ilo_recode_140129.do"
quietly do "do_files/recode do_files/wdi_recode_130808.do"
quietly do "do_files/recode do_files/imf_recode_140126.do"
quietly do "do_files/recode do_files/gpcc_recode_140124.do"
quietly do "do_files/recode do_files/gpcp_recode_140201.do"
quietly do "do_files/recode do_files/kof_polity_recode_140124.do"
quietly do "do_files/recode do_files/usda_grain_recode_140122.do"
quietly do "do_files/recode do_files/fao_index_recode_140124.do"
*/
*********************************************
********** THE MERGING OF THE DATA **********
*********************************************

clear
use "data/raw_data/ISO_codes_131121.dta"
lab var land "Landlocked"
lab var ldc "Least Developed Country"

drop if africa != 1
drop africa
drop if cow_code == .

merge 1:m cow_code using "data/gpcc_mscp_africa_recode.dta"
drop if _merge != 3
drop _merge

merge 1:1 cow_code time using "data/gpcp_africa_recode_140201.dta"
drop _merge
order GPCP_wet6-l_GPCP_dry12, a(dry_mscp18)
foreach n of numlist 6 9 12 {
	lab var GPCP_dry`n' "GPCP `n' month dry MSCP"
	lab var GPCP_wet`n' "GPCP `n' month wet MSCP"
	lab var l_GPCP_dry`n' "GPCP `n' month dry MSCP (t--1)"
	lab var l_GPCP_wet`n' "GPCP `n' month wet MSCP (t--1)"
	}
drop if iso2 == ""

quietly merge 1:1 iso2 time using "data/ilo_consumer_price_data.dta"
drop if _merge != 3
drop _merge country

quietly merge 1:1 cow_code time using "data/scad_urban_recode.dta"
drop if _merge == 2
drop _merge

quietly merge 1:1 cow_code time using "data/acled_recode.dta"
drop if _merge == 2
drop _merge

order time, a(cow_code)

quietly merge 1:1 wb_code time using "data/wdi_recode.dta"
drop if _merge == 2
drop _merge

quietly merge m:1 wb_code year using "data/kof_recode.dta"
drop if _merge == 2
drop _merge country

quietly merge m:1 cow_code year using "data/polity_recode.dta"
drop if _merge == 2
drop _merge flag fragment xrreg-regtrans

*quietly merge m:1 iso_num year using "data/wto_ag_food.dta"
*drop if _merge == 2
*drop _merge

merge 1:1 iso_num time using "data/gdelt_protest_africa_country_agg.dta"
*drop if _merge != 3
drop _merge

lab val month month

merge 1:1 iso_num time using "data/elections.dta"
drop if _merge == 2
drop _merge

tsfill, full

quietly merge m:1 time using "data/imf_commodity.dta"
drop if _merge == 2
drop _merge

quietly merge m:1 time using "data/fao_commodity_index.dta"
drop if _merge == 2
drop _merge

sort iso_num time
xtset iso_num time

merge m:1 iso_num year using "data/usda_grain_recode.dta"
drop if _merge == 2
drop _merge

drop fips wb_code iso2 cow_abbrev cow_code
lab var time "Month"
lab var month "Calendar month"
lab var year "Year"

sort iso_num time

*** generate variable for lagged number of events
gen l_unrest = l.unrest
lab var l_unrest "Occurence of SCAD event (t--1)"
gen l_violence = l.violence
lab var l_violence "Occurence of SCAD violent event (t--1)"
gen l_events = l.events
lab var l_events "Number of SCAD events (t--1)"
gen l_viol_events = l.viol_events
lab var l_viol_events "Number of SCAD violent events (t--1)"
gen l_acled = l.acled
lab var l_acled "Occurence of ACLED riot/protest (t--1)"
lab var gdelt_events "Number of GDELT protest events"
gen l_gdelt_events = l.gdelt_events
lab var l_gdelt_events "Number of GDELT protest events (t--1)"
gen gdelt = gdelt_events >= 1 & gdelt_events != .
lab var gdelt "Occurence of GDELT protest"
gen l_gdelt = l.gdelt
lab var l_gdelt "Occurence of GDELT protest (t--1)"

*********************************************
************ CLEANUP & RENAMING *************
*********************************************

replace name = "Tazania" if name == "Tanzania, United Republic of"
replace name = "Central African Rep" if name == "Central African Republic"

xtset iso_num time

lab var FAO_food "FAO Food Commodity Index"
lab var IMF_food "IMF Food Commodity Index"
lab var FAO_food_chg "% change in FAO Food Commodity Index"
lab var IMF_food_chg "% change in IMF Food Commodity Index"
gen l_IMF_food_chg = l.IMF_food_chg
lab var l_IMF_food_chg "% change in IMF Food Commodity Index (t--1)"
gen l_FAO_food_chg = l.FAO_food_chg
lab var l_FAO_food_chg "% change in FAO Food Commodity Index (t--1)"

gen f_elections = f.elections
lab var f_elections "National Elections (lead)"
order f_elections, a(elections)

foreach n of numlist 3(3)18 {
	quietly gen l_dry_mscp`n' = l.dry_mscp`n'
	quietly gen l_wet_mscp`n' = l.wet_mscp`n'
	lab var l_dry_mscp`n' "`n' month dry MSCP (t--1)"
	lab var l_wet_mscp`n' "`n' month wet MSCP (t--1)"
	}

lab var unrest "Occurrence of unrest"
lab var violence "Occurrence of violent unrest"
lab var events "Number of unrest events"
lab var viol_events "Number of violent events"
lab var l_unrest "Occurrence of unrest (t--1)"
lab var l_violence "Occurrence of violent unrest (t--1)"

***** FINALIZE DATASET *****

drop if year < 1990
drop if year > 2011

*** exclude Ethiopia and Eritrea prior to the de jure independence of Eritrea
drop if iso3 == "ETH" & time < 401
drop if iso3 == "ERT" & time < 401

*** exclude Zimbabwe after 2004 due to extreme outliers in food price changes
*** during hyperinflationary period beginning in 2005
drop if iso3 == "ZWE" & time >= 550 & time <= 582		// Nov 2005 to Jul 2008

*** exclude Angola before 1984 due to extreme outliers in food price changes in 
*** 1983, ranging from -100% in January 1995 to 85.5% in November 1995
drop if iso3 == "AGO" & time <= 505						// through Feb 2002 (death of Savimbi) excluded

**** STANDARDIZE FOOD PRICES ****

egen mn_fc = mean(food_chg), by(iso_num)
lab var mn_fc "Long-term mean of monthly change in domestic food price index"
egen sd_fc = sd(food_chg), by(iso_num)
lab var sd_fc "Long-term sd of monthly change in domestic food price index"
gen std_food_chg = (food_chg - mn_fc) / sd_fc
lab var std_food_chg "Std change in domestic food price index"

order events l_events viol_events l_viol_events unrest l_unrest violence l_violence acled_days acled gdelt_events gdelt food_price food_chg mn_fc sd_fc std_food_chg, a(year)

*** GENERATE DUMMIES FOR COUNTRIES, YEARS, & MONTHS ****

quietly tab iso_num, gen(i)
quietly tab year, gen(y)
quietly tab month, gen(m)

**** CREATE THE GRAIN COMMODITY TRADE INSTRUMENT ****

gen grinst = ((wheat_bal * pwheamt_chg) + (rice_bal * pricenpq_chg) + (corn_bal * pmaizmt_chg)) / 3

replace grinst = ((wheat_bal * pwheamt_chg) + (rice_bal * pricenpq_chg)) / 2 if corn_bal == .
replace grinst = ((wheat_bal * pwheamt_chg) + (corn_bal * pmaizmt_chg)) / 2 if rice_bal == .
replace grinst = ((rice_bal * pricenpq_chg) + (corn_bal * pmaizmt_chg)) / 2 if wheat_bal == .

replace grinst = wheat_bal * pwheamt_chg if corn_bal == . & rice_bal == .
replace grinst = corn_bal * pmaizmt_chg if rice_bal == . & wheat_bal == .
replace grinst = rice_bal * pricenpq_chg if wheat_bal == . & corn_bal == .

egen mean = mean(grinst)
egen sd = sd(grinst)
replace grinst = (mean - grinst) / sd
drop mean sd

lab var grinst "Trade bal adj grain price instrument"
gen l_grinst = l.grinst
lab var l_grinst "Trade bal adj grain price instrument (t--1)"

order grinst l_grinst, a(std_wheat_bal)

*xtreg std_food_chg grinst l_dry_mscp9 l_wet_mscp6 l_unrest i.month i.year, fe cl(iso_num)
*xtreg std_food_chg grinst l_dry_mscp9 l_wet_mscp6 l_unrest elections pop pop_growth pct_urb pct_youth gdppc democ autoc life_exp inf_mort i.month i.year, fe cl(iso_num)

*sum grinst grinst_sq
*twoway (scatter std_food_chg grinst)

**** GENERATE SUB-CATEGORIES OF SCAD UNREST ****

drop if unrest == .

foreach var of varlist etype1 - etype10 {
	replace `var' = `var' >= 1 & `var' != .
	}

gen demo = etype1 == 1
replace demo = 1 if etype2 == 1
gen riot = etype3 == 1
replace riot = 1 if etype4 == 1
gen spon = etype2 == 1
replace spon = 1 if etype4 == 1
gen org = etype1 == 1
replace spon = 1 if etype3 == 1
gen strike = etype5 == 1
replace strike = 1 if etype6 == 1
foreach var of varlist etype1 - etype10 demo - strike {
	gen l_`var' = l.`var'
	}

lab var demo "Demonstrations (organized and spontaneous)"
lab var riot "Riots (organized and spontaneous)"
lab var spon "Spontaneous events (demonstrations and riots)"
lab var org "Organized events (demonstrations and riots)"
lab var strike "Strikes (general and limited)"
lab var l_etype1 "Organized Demonstration (t--1)"
lab var l_etype2 "Spontaneous demonstration (t--1)"
lab var l_etype3 "Organized violent riot (t--1)"
lab var l_etype4 "Spontaneous violent riot (t--1)"
lab var l_etype5 "General strike (t--1)"
lab var l_etype6 "Limited strike (t--1)"
lab var l_etype7 "Pro-government violence (repression) (t--1)"
lab var l_etype8 "Anti-government violence (t--1)"
lab var l_etype9 "Extra-government violence (t--1)"
lab var l_etype10 "Intra-government violence (t--1)"
lab var l_demo "Demonstrations (organized and spontaneous) (t--1)"
lab var l_riot "Riots (organized and spontaneous) (t--1)"
lab var l_spon "Spontaneous events (demonstrations and riots) (t--1)"
lab var l_org "Organized events (demonstrations and riots) (t--1)"
lab var l_strike "Strikes (general and limited) (t--1)"

lab var pwheamt_chg "Monthly change in intl wheat price"
lab var pricenpq_chg "Monthly change in intl rice price"
lab var pmaizmt_chg "Monthly change in intl corn price"
lab var gdppc "GDP per cap (000 of const 2005 USD)"
lab var pop_growth "Population Growth (monthly \%)"
lab var pct_urb "Urban Population (\% of total)"
lab var pct_youth "Youth Population (\% of total 14 \& under)"
lab var inf_mort "Infant mortality rate (per 1000 births)"

order demo-l_strike, a(etype10)

sort iso_num time

compress
lab data "Feeding Unrest in Africa - Todd G. Smith"
save "data/feeding_unrest_africa.dta", replace

describe, replace
drop vallab
save "feeding_unrest_africa_codebook.dta", replace
export delimited using "feeding_unrest_africa_codebook.txt", delimiter(tab) replace

use "data/feeding_unrest_africa.dta", clear
estpost sum
esttab using "sum_stats.csv", cells("count(fmt(0)) mean(fmt(5)) sd(fmt(5)) min(fmt(5)) max(fmt(5))") nomtitle nonumber replace
import delimited "sum_stats.csv", clear
drop in 1
drop in 2
rename v1 name
rename v2 count
rename v3 mean
rename v4 sd
rename v5 min
rename v6 max
replace name = subinstr(name, char(34), "", .)
replace name = subinstr(name, "=", "", .)
foreach var of varlist count mean sd min max {
	replace `var' = subinstr(`var', char(34), "", .)
	destring `var', i("=") replace
	}
save "sum_stats.dta", replace
use "feeding_unrest_africa_codebook.dta", clear
merge 1:1 name using "sum_stats.dta"
drop _merge
sort position
drop if position > 205
drop position isnumeric
drop if name == "N"
lab var name "Variable Name"
lab var type "Storage Type"
lab var format "Display Format"
lab var varlab "Variable Label"
lab var count "Count"
lab var mean "Mean"
lab var sd "Standard Deviation"
lab var min "Minimum"
lab var max "Maximum"
replace count = 9973 if name == "name" | name == "iso3"
compress
order name varlab
save "feeding_unrest_africa_codebook.dta", replace
export delimited using "feeding_unrest_africa_codebook.txt", delimiter(tab) replace
export excel using "feeding_unrest_africa_codebook", firstrow(varlabels) replace
erase "sum_stats.dta"
erase "sum_stats.csv"

exit
