*This is a do-file to replicate footnote 35 of Costinot, Donaldson, Kyle and Williams (QJE, 2019)


***Preamble***

capture log close
*Set log
log using "${log_dir}tab7_FN35.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}main_final_dataset.dta", clear
preserve

***Prepare data***

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry


***Regressions***
* first check that we replicate Table 7 cols 1 and 2:
reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
reghdfe lnsales lndaly_p_dest lndaly_p_sales if dest_EU == 1, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)



* Modify regression in column (2) to consider only those observations with EU (ESM) origins:

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

reghdfe lnsales lndaly_p_dest lndaly_p_sales if sales_EU == 1, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)


log close
