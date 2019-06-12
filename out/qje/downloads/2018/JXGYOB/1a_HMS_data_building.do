**** Summary:
* 1. Convert to Stata from raw files from Nielsen
* 2. Generate main analysis dataset by income quintiles
* 3.a/b Robustness datasets by age-income and income deciles

cd "D:/Dropbox/unequal_gains/main_data/HMS/"
global db "D:\Dropbox\unequal_gains\main_data"


**** 1. Convert to Stata from raw files from Nielsen 

foreach i of numlist 2004(1)2015 {
clear
import delimited `i'/Annual_Files/purchases_`i'.tsv, numericcols(_all) asdouble
save "$db/Important Datasets/purchases_`i'.dta", replace

keep upc upc_ver_uc 
duplicates drop 
save "$db/Important Lists/available_upcs_`i'.dta", replace
}

foreach i of numlist 2004(1)2015 {
clear
import delimited `i'/Annual_Files/trips_`i'.tsv
save "$db/Important Datasets/trips_`i'.dta", replace
}

foreach i of numlist 2004(1)2015 {
clear 
import delimited `i'/Annual_Files/panelists_`i'.tsv
save "$db/Important Datasets/panelists_`i'.dta", replace
}

foreach i of numlist 2004(1)2015 {
clear 
import delimited `i'/Annual_Files/products_extra_`i'.tsv
save "$db/Important Datasets/products_extra_`i'.dta", replace
}

clear 
import delimited Master_Files/Latest/products.tsv
* now we save a file with the following variables:
keep upc upc_ver_uc product_module_code product_group_code department_code brand_code_uc
save "$db/Important Lists/products_short_final.dta", replace

**** 2. Generate main analysis dataset by income quintiles

* 2a. now bring together price data with household characteristics, for all product modules available in 2004
foreach i of numlist 2004(1)2015 {
display "Starting analysis for year `i'"

use "$db/Important Datasets/purchases_`i'.dta", clear
drop if missing(upc)

* bring in upc classification [this step also gets rid of deferred product codes]
display "merge to upc classification"
merge m:1 upc upc_ver_uc using "$db/Important Lists/products_short_final.dta"
keep if _merge==3
drop _merge
* get rid of magnet products (product modules 445 to 750)
drop if product_module_code > 444 & product_module_code <751 
* get rid of upcs whose product module didn't exist in 2004
display "merge to product module codes available in 2004"
merge m:1 product_module_code using "$db/Important Lists/available_product_module_code_2004.dta"
keep if _merge==3
drop _merge

display "merge to trips dataset"
merge m:1 trip_code_uc using "$db/Important Datasets/trips_`i'.dta", keepusing(trip_code_uc household_code)
keep if _merge==3
drop _merge 
display "merge to panelist dataset"
merge m:1 household_code using "$db/Important Datasets/panelists_`i'.dta", ///
keepusing(household_code household_income household_size projection_factor ///
fips_state_code fips_county_code scantrack_market_code male_head_birth female_head_birth)
keep if _merge==3
drop _merge
save "$db/Important Datasets/purchases_household_income_`i'_2004_modules.dta", replace
}

* 2b. Now collapse the data at the level of UPC by households
foreach i of numlist 2004(1)2015 {
use "$db/Important Datasets/purchases_household_income_`i'_2004_modules.dta", clear
* aggregate UPC data at the household level
gen final_price= total_price_paid-coupon
drop if final_price==0 | final_price<0 
drop if quantity==0  | quantity<0
bysort household_code upc upc_ver: egen double total_quantity=sum(quantity)
bysort household_code upc upc_ver: egen double total_spending=sum(final_price)
gen average_unit_price = total_spending/total_quantity
* build variation for household age
gen male_head_birth_temp=substr(male_head_birth,1,4) 
gen female_head_birth_temp=substr(female_head_birth,1,4)
gen male_head_birth_num=real(male_head_birth_temp)
gen female_head_birth_num=real(female_head_birth_temp)
gen male_head_age_num=`i'-male_head_birth_num
gen female_head_age_num=`i'-female_head_birth_num
gen household_age=(male_head_age_num+female_head_age_num)/2
replace household_age=male_head_age_num if missing(female_head_age_num)
replace household_age=female_head_age_num if missing(male_head_age_num)
* here we keep all the data we will use later on to do different cuts: 
* by income, by geography, by age
keep upc upc_ver_uc average_unit_price total_spending total_quantity ///
household_code projection_factor household_income product_module_code product_group_code department_code ///
household_size fips_state_code fips_county_code scantrack_market_code household_age
duplicates drop 
save "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules.dta", replace
} 

* 2c. Now collapse the data at the level of UPC by household income groups (quintiles)
foreach i of numlist 2004(1)2015 {

display "Start with year `i'"

use "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules.dta", clear

drop if missing(household_income)
gen income_quintile=.
* first quintile if makes below 20k
replace income_quintile=1 if household_income<13
* second quintile if makes between 20k & 40k
replace income_quintile=2 if household_income>12 & household_income<18
* third quintile if makes between 40k & 60k
replace income_quintile=3 if household_income>17 & household_income<23
* fourth quintile if makes between 60k & 100k 
replace income_quintile=4 if household_income>22 & household_income<27
* fifth quintile if makes above 100k
replace income_quintile=5 if household_income>26

collapse (sum) total_spending total_quantity (mean) product_module_code ///
product_group_code department_code [fw=projection_factor], by(upc upc_ver_uc income_quintile) fast

gen average_unit_price = total_spending/total_quantity

* compute average unit price for full population
bysort upc upc_ver_uc: egen total_quantity_all=sum(total_quantity)
bysort upc upc_ver_uc: egen total_spending_all=sum(total_spending)
gen average_unit_price_all=total_spending_all/total_quantity_all

save "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules_final.dta", replace

display "Done with year `i'"
} 

**** 3.a. Generate robustness dataset by income quintiles & 6 age groups
**** (25-35, 35-45, 45-55, 55-65, 65-75, >75)

* Now collapse the data at the level of UPC by household age by income groups (quintiles)
foreach i of numlist 2004(1)2015 {

display "Start with year `i'"

use "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules.dta", clear

drop if missing(household_income)
gen income_quintile=.
* first quintile if makes below 20k
replace income_quintile=1 if household_income<13
* second quintile if makes between 20k & 40k
replace income_quintile=2 if household_income>12 & household_income<18
* third quintile if makes between 40k & 60k
replace income_quintile=3 if household_income>17 & household_income<23
* fourth quintile if makes between 60k & 100k 
replace income_quintile=4 if household_income>22 & household_income<27
* fifth quintile if makes above 100k
replace income_quintile=5 if household_income>26

drop if missing(household_age)
gen age_group=.
replace age_group=25 if household_age>=25 & household_age<35
replace age_group=35 if household_age>=35 & household_age<45
replace age_group=45 if household_age>=45 & household_age<55
replace age_group=55 if household_age>=55 & household_age<65
replace age_group=65 if household_age>=65 & household_age<75
replace age_group=75 if household_age>=75

collapse (sum) total_spending total_quantity (mean) product_module_code ///
product_group_code department_code [fw=projection_factor], by(upc upc_ver_uc income_quintile age_group) fast

gen average_unit_price = total_spending/total_quantity

* compute average unit price for full population
bysort upc upc_ver_uc: egen total_quantity_all=sum(total_quantity)
bysort upc upc_ver_uc: egen total_spending_all=sum(total_spending)
gen average_unit_price_all=total_spending_all/total_quantity_all

save "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules_final_age.dta", replace

display "Done with year `i' for age by income groups"
} 

**** 3.b. Generate robustness dataset by more detailed income groups
**** to approximate income deciles

* Now collapse the data at the level of income deciles

foreach i of numlist 2004(1)2015 {

display "Start with year `i'"

use "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules.dta", clear

drop if missing(household_income)
gen income_decile=.
* first decile if makes below 10k
replace income_decile=1 if household_income<8
* second decile if makes between 10k & 20k
replace income_decile=2 if household_income>6 & household_income<13
* third decile if makes between 20k & 30k
replace income_decile=3 if household_income>11 & household_income<16
* fourth decile if makes between 30k & 40k
replace income_decile=4 if household_income>15 & household_income<18
* fifth decile if makes between 40k & 50k
replace income_decile=5 if household_income>17 & household_income<21
* sixth decile if makes between 50k and 60k
replace income_decile=6 if household_income>19 & household_income<23
* from p60 to p80 if makes between 60k and 100k
replace income_decile=7 if household_income>21 & household_income<27
* above p80
replace income_decile=8 if household_income>26

collapse (sum) total_spending total_quantity (mean) product_module_code ///
product_group_code department_code [fw=projection_factor], by(upc upc_ver_uc income_decile) fast

gen average_unit_price = total_spending/total_quantity

* compute average unit price for full population
bysort upc upc_ver_uc: egen total_quantity_all=sum(total_quantity)
bysort upc upc_ver_uc: egen total_spending_all=sum(total_spending)
gen average_unit_price_all=total_spending_all/total_quantity_all

save "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules_final_incdecile.dta", replace

display "Done with year `i' for income deciles"
} 
