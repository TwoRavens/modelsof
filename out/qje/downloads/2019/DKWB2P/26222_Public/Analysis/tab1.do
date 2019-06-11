/* This do-file creates the results presented in Table 1 of Costinot, Donaldson, Kyle and Williams (QJE, 2019) */ 


***Preamble***

capture log close
*Set log
log using "${log_dir}tab1.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}main_final_dataset.dta", clear

***Prepare data***
*Make the dataset the square dataset
drop if square_dataset != 1

*generate world sales and expenditure shares
egen world_sales = total(sales_mnf_usd)
bysort sales_ctry: egen country_sales = total(sales_mnf_usd)
bysort dest_ctry: egen country_expenditure = total(sales_mnf_usd)

gen world_sales_share = country_sales/world_sales*100
gen world_expenditure_share = country_expenditure/world_sales*100

preserve
*only keep 10 largest world shares sales, as sales_countries
collapse (first) world_sales_share, by(sales_ctry sales_country)
gen minshare = -world_sales_share
sort minshare
drop if _n > 10
drop minshare

tempfile temp1
save `temp1', replace

restore
*collapse destination_countries and expenditure shares
collapse (first) world_expenditure_share, by(dest_ctry dest_country)

rename dest_ctry sales_ctry
merge 1:1 sales_ctry using `temp1'
drop if _m != 3
drop _m
drop dest_country

tempfile temp1
save `temp1', replace

*get number of firms
use "${finalsavedir}/number_of_firms.dta"

*merge world share data
merge 1:1 sales_ctry using `temp1'
drop if _m != 3
drop _m

*order data
order sales_ctry sales_country world_sales_share world_expenditure_share num_of_firms
gen minshare = -world_sales_share
sort minshare
drop minshare


***Output***

replace sales_ctry = proper(sales_ctry)
replace sales_ctry = "USA" if sales_ctry == "Usa"

scalar TabIColIRowI = sales_ctry[1]
scalar TabIColIRowII = sales_ctry[2]
scalar TabIColIRowIII = sales_ctry[3]
scalar TabIColIRowIV = sales_ctry[4]
scalar TabIColIRowV = sales_ctry[5]
scalar TabIColIRowVI = sales_ctry[6]
scalar TabIColIRowVII = sales_ctry[7]
scalar TabIColIRowVIII = sales_ctry[8]
scalar TabIColIRowIX = sales_ctry[9]
scalar TabIColIRowX = sales_ctry[10]

scalar TabIColIIRowI = round(world_sales_share[1], 0.01)
scalar TabIColIIRowII = round(world_sales_share[2], 0.01)
scalar TabIColIIRowIII = round(world_sales_share[3], 0.01)
scalar TabIColIIRowIV = round(world_sales_share[4], 0.01)
scalar TabIColIIRowV = round(world_sales_share[5], 0.01)
scalar TabIColIIRowVI = round(world_sales_share[6], 0.01)
scalar TabIColIIRowVII = round(world_sales_share[7], 0.01)
scalar TabIColIIRowVIII = round(world_sales_share[8], 0.01)
scalar TabIColIIRowIX = round(world_sales_share[9], 0.01)
scalar TabIColIIRowX = round(world_sales_share[10], 0.01)

scalar TabIColIIIRowI = round(world_expenditure_share[1], 0.01)
scalar TabIColIIIRowII = round(world_expenditure_share[2], 0.01)
scalar TabIColIIIRowIII = round(world_expenditure_share[3], 0.01)
scalar TabIColIIIRowIV = round(world_expenditure_share[4], 0.01)
scalar TabIColIIIRowV = round(world_expenditure_share[5], 0.01)
scalar TabIColIIIRowVI = round(world_expenditure_share[6], 0.01)
scalar TabIColIIIRowVII = round(world_expenditure_share[7], 0.01)
scalar TabIColIIIRowVIII = round(world_expenditure_share[8], 0.01)
scalar TabIColIIIRowIX = round(world_expenditure_share[9], 0.01)
scalar TabIColIIIRowX = round(world_expenditure_share[10], 0.01)

scalar TabIColIVRowI = num_of_firms[1]
scalar TabIColIVRowII = num_of_firms[2]
scalar TabIColIVRowIII = num_of_firms[3]
scalar TabIColIVRowIV = num_of_firms[4]
scalar TabIColIVRowV = num_of_firms[5]
scalar TabIColIVRowVI = num_of_firms[6]
scalar TabIColIVRowVII = num_of_firms[7]
scalar TabIColIVRowVIII = num_of_firms[8]
scalar TabIColIVRowIX = num_of_firms[9]
scalar TabIColIVRowX = num_of_firms[10]

scalar list



log close
