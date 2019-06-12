* This do-file creates the results presented in Footnote 41 of Costinot, Donaldson, Kyle and Williams (QJE, 2019)


***Preamble***

capture log close
*Set log
log using "${log_dir}tab9_FN41.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}data_for_price_on_distance.dta", clear
preserve
***Prepare data***

* attach GDP per capita
merge m:1 sales_ctry using "${intersavedir}world_bank_gdppc_sales.dta", keep(3) nogen
merge m:1 dest_ctry using "${intersavedir}world_bank_gdppc_dest.dta", keep(3) nogen

* gen absolute value of the GDP per capita difference between the origin and destination countries
gen gdppc_diff = abs(gdppc_dest - gdppc_sales)

* gen indicator that both origin and destination are EU (ESM) members
gen dest_EU = 0
replace dest_EU = 1 if dest_ctry == "AUSTRIA"
replace dest_EU = 1 if dest_ctry == "BELGIUM"
replace dest_EU = 1 if dest_ctry == "BULGARIA"
replace dest_EU = 1 if dest_ctry == "CZECH REPUBLIC"
replace dest_EU = 1 if dest_ctry == "FINLAND"
replace dest_EU = 1 if dest_ctry == "FRANCE"
replace dest_EU = 1 if dest_ctry == "GERMANY"
replace dest_EU = 1 if dest_ctry == "GREECE"
replace dest_EU = 1 if dest_ctry == "HUNGARY"
replace dest_EU = 1 if dest_ctry == "IRELAND"
replace dest_EU = 1 if dest_ctry == "ITALY"
replace dest_EU = 1 if dest_ctry == "LATVIA"
replace dest_EU = 1 if dest_ctry == "LUXEMBOURG"
replace dest_EU = 1 if dest_ctry == "NORWAY"
replace dest_EU = 1 if dest_ctry == "POLAND"
replace dest_EU = 1 if dest_ctry == "PORTUGAL"
replace dest_EU = 1 if dest_ctry == "SLOVENIA"
replace dest_EU = 1 if dest_ctry == "SPAIN"
replace dest_EU = 1 if dest_ctry == "SWEDEN"
replace dest_EU = 1 if dest_ctry == "SWITZERLAND"
replace dest_EU = 1 if dest_ctry == "UNITED KINGDOM"
gen sales_EU = 0
replace sales_EU = 1 if sales_ctry == "AUSTRIA"
replace sales_EU = 1 if sales_ctry == "BELGIUM"
replace sales_EU = 1 if sales_ctry == "BULGARIA"
replace sales_EU = 1 if sales_ctry == "CZECH REPUBLIC"
replace sales_EU = 1 if sales_ctry == "FINLAND"
replace sales_EU = 1 if sales_ctry == "FRANCE"
replace sales_EU = 1 if sales_ctry == "GERMANY"
replace sales_EU = 1 if sales_ctry == "GREECE"
replace sales_EU = 1 if sales_ctry == "HUNGARY"
replace sales_EU = 1 if sales_ctry == "IRELAND"
replace sales_EU = 1 if sales_ctry == "ITALY"
replace sales_EU = 1 if sales_ctry == "LATVIA"
replace sales_EU = 1 if sales_ctry == "LUXEMBOURG"
replace sales_EU = 1 if sales_ctry == "NORWAY"
replace sales_EU = 1 if sales_ctry == "POLAND"
replace sales_EU = 1 if sales_ctry == "PORTUGAL"
replace sales_EU = 1 if sales_ctry == "SLOVENIA"
replace sales_EU = 1 if sales_ctry == "SPAIN"
replace sales_EU = 1 if sales_ctry == "SWEDEN"
replace sales_EU = 1 if sales_ctry == "SWITZERLAND"
replace sales_EU = 1 if sales_ctry == "UNITED KINGDOM"
gen dest_and_sales_EU = dest_EU*sales_EU



*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry




***Regressions described in FN 41:



* (1) original regression as in column (2) of Table 9
reghdfe lnprice lndist, absorb(gbd#corp#mol) vce(cl dest_country)

* (2) with a destination fixed effect
reghdfe lnprice lndist, absorb(gbd#corp#mol dest_country) vce(cl dest_country)

* (3) with a destination-disease fixed effect
reghdfe lnprice lndist, absorb(gbd#corp#mol gbd#dest_country) vce(cl dest_country)

* (4) with a control for "both origin and destination are EU members"
reghdfe lnprice lndist dest_and_sales_EU, absorb(gbd#corp#mol) vce(cl dest_country)

* (5) with a control for "the absolute value of the GDP per capita difference between the origin and destination countries"
reghdfe lnprice lndist gdppc_diff, absorb(gbd#corp#mol) vce(cl dest_country)

* (6) with all 3 of these additional controls (destination-disease fixed effects, both-EU, and GDPpc-difference)
reghdfe lnprice lndist gdppc_diff dest_and_sales_EU, absorb(gbd#corp#mol dest_country#gbd) vce(cl dest_country)


log close
