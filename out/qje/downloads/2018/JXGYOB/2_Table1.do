************
** Table 1
************

* Summary 
* 1. Summary stats across depts from HMS data: (a) spending; (b) number of barcodes (Table 1a)
* 2. Comparison of spending patterns in Nielsen & CEX (Table 1b)

global db "D:\Dropbox\unequal_gains\main_data"
global db2 "D:\Dropbox\unequal_gains\QJE revision plan\analysis"
global resultspath "D:\Dropbox\unequal_gains\QJE revision plan\analysis\clean_results"


****************************************************
** PANEL A Expenditures and Barcodes in Nielsen data
****************************************************

* 1. Summary stats across departments from HMS data 
use "$db/Important Price Datasets/price_index_household_income_2004_2004_modules_final.dta", clear
foreach i of numlist 2005(1)2015 {
append using "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules_final.dta"
}
* a) spending
preserve
collapse (sum) total_spending, by(department_code) fast
egen double total_spending_all=sum(total_spending)
gen spending_frac_hms=total_spending/total_spending_all*100
save "$resultspath/table1a", replace
restore
* b) barcode
keep department_code upc upc_ver_uc
duplicates drop
gen upc_count=[_N]
collapse (sum) upc_count, by(department_code) fast
egen double total_upc=sum(upc_count)
gen upc_frac_hms=upc_count/total_upc*100
merge 1:1 department_code using "$resultspath/table1a"
drop _merge
save "$resultspath/table1a", replace
* c) examples of products
cd "D:/Dropbox/unequal_gains/main_data/HMS/"
clear
import delimited Master_Files/Latest/products.tsv
keep department_descr product_group_descr department_code
duplicates drop
save "$resultspath/table1_productexamples", replace
keep department_code department_descr
drop if missing(department_code)
duplicates drop
merge 1:1 department_code using "$resultspath/table1a"
drop _merge
save "$resultspath/table1a", replace

* 2. Summary stats across departments from RMS data
cd "$db2\RMS\collapsed_files\state_level"
use rms_2006, clear
foreach i of numlist 2007(1)2015 {
append using rms_`i'
}
* a) spending
preserve
collapse (sum) total_spending, by(department_code) fast
egen double total_spending_all=sum(total_spending)
gen spending_frac_rms=total_spending/total_spending_all*100
merge 1:1 department_code using "$resultspath/table1a"
drop _merge
save "$resultspath/table1a", replace
restore
* b) barcode
keep department_code upc 
duplicates drop
gen upc_count=[_N]
collapse (sum) upc_count, by(department_code) fast
egen double total_upc=sum(upc_count)
gen upc_frac_rms=upc_count/total_upc*100
merge 1:1 department_code using "$resultspath/table1a"
drop _merge
sort department_descr
order department_descr department_code spending_frac* upc_frac*
keep department_descr department_code spending_frac* upc_frac*
format spending_frac* upc_frac* %8.2f
* drop magnet data (spending not counted)
drop if department_code==99
save "$resultspath/table1a", replace


***************************************
** PANEL B Comparison CEX & Nielsen
***************************************

** 1. Spending patterns for Nielsen 

* get number of households
clear
set obs 1
gen hh_count=.
save "$db/Important Price Datasets/hhcount_HMS", replace
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

keep household_code projection_factor income_quintile
duplicates drop
gen hh_count=1

collapse (sum) hh_count [fw=projection_factor], by(income_quintile) fast

gen year=`i'
append using "$db/Important Price Datasets/hhcount_HMS"
drop if missing(year)
save "$db/Important Price Datasets/hhcount_HMS", replace

display "Done with year `i'"
} 

* now compute spending per capita on all products in Nielsen
use "$db/Important Price Datasets/price_index_household_income_2004_2004_modules_final.dta", clear
foreach i of numlist 2005(1)2015 {
append using "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules_final.dta"
}
collapse (sum) total_spending, fast
gen source="Nielsen"
gen sample="All"
gen income_quintile=100
save "$resultspath/table1b", replace

* now compute spending per capita on FOOD/BEVERAGES products in Nielsen
use "$db/Important Price Datasets/price_index_household_income_2004_2004_modules_final.dta", clear
foreach i of numlist 2005(1)2015 {
append using "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules_final.dta"
}
drop if department_code==0 | department_code==7 | department_code==9 
collapse (sum) total_spending, fast
rename total_spending total_spending_food_bev
gen source="Nielsen"
gen sample="Food and drinks (at home)"
gen income_quintile=100
merge 1:1 source income_quintile using "$resultspath/table1b"
drop _merge
save "$resultspath/table1b", replace

use "$db/Important Price Datasets/hhcount_HMS", clear
collapse (sum) hh_count
gen source="Nielsen" 
merge 1:1 source using "$resultspath/table1b"
drop _merge
save "$resultspath/table1b", replace

* repeat above by income quintiles
use "$db/Important Price Datasets/price_index_household_income_2004_2004_modules_final.dta", clear
foreach i of numlist 2005(1)2015 {
append using "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules_final.dta"
}
collapse (sum) total_spending, by(income_quintile) fast
gen source="Nielsen"
gen sample="All"
append using "$resultspath/table1b"
save "$resultspath/table1b", replace

* FOOD/BEVERAGES
use "$db/Important Price Datasets/price_index_household_income_2004_2004_modules_final.dta", clear
foreach i of numlist 2005(1)2015 {
append using "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules_final.dta"
}
drop if department_code==0 | department_code==7 | department_code==9 
collapse (sum) total_spending, by(income_quintile) fast
rename total_spending total_spending_food_bev
gen source="Nielsen"
gen sample="Food and drinks (at home)"
merge 1:1 source income_quintile using "$resultspath/table1b"
drop _merge
save "$resultspath/table1b", replace

use "$db/Important Price Datasets/hhcount_HMS", clear
collapse (sum) hh_count, by(income_quintile)
gen source="Nielsen"
merge 1:1 source income_quintile using "$resultspath/table1b"
drop _merge

gen double spending_capita=total_spending/hh_count 
gen double spending_capita_food_bev=total_spending_food_bev/hh_count
gen food_bev_frac=spending_capita_food_bev/spending_capita*100
sort sample income_q
format spending_capita spending_capita_food_bev %8.2f
order income_quintile spending_capita spending_capita_food_bev
save "$resultspath/table1b", replace


** 2. Spending patterns for CEX

** Start with all expenditures to get 
** per capita expenditures; then, to get the breakdown by category 
** we use our merge to the CPI data (which has the categories)
** Then we check that all numbers are in line with Nielsen 

* 2.a Number of households across quintiles
use "$root/Processed/CEX/merged_int_all_years", clear
gen income_quintile=.
* first quintile if makes below 20k
replace income_quintile=1 if income<=20000
* second quintile if makes between 20k & 40k
replace income_quintile=2 if income>20000 & income<=40000
* third quintile if makes between 40k & 60k
replace income_quintile=3 if income>40000 & income<=60000
* fourth quintile if makes between 60k & 100k 
replace income_quintile=4 if income>60000 & income<=100000
* fifth quintile if makes above 100k
replace income_quintile=5 if income>100000 
keep cuid year income_q 
*keep cuid year income_q finlwt21
duplicates drop
gen hh_count=1
*gen w_hh_count=finlwt21
*collapse (sum) hh_count w_hh_count, by(income_quintile) fast
collapse (sum) hh_count, by(income_quintile) fast
save "$db2/CEXhhcount", replace

use "$root/Processed/CEX/merged_int_all_years", clear
keep cuid year 
*keep cuid year finlwt21
duplicates drop
gen hh_count=1
*gen w_hh_count=finlwt21
*collapse (sum) hh_count w_hh_count, fast
collapse (sum) hh_count, fast
gen income_quintile=100
append using "$db2/CEXhhcount"
save "$db2/CEXhhcount", replace

* 2.b Total spending across quintiles
use "$root/Processed/CEX/merged_int_all_years", clear
gen income_quintile=.
* first quintile if makes below 20k
replace income_quintile=1 if income<=20000
* second quintile if makes between 20k & 40k
replace income_quintile=2 if income>20000 & income<=40000
* third quintile if makes between 40k & 60k
replace income_quintile=3 if income>40000 & income<=60000
* fourth quintile if makes between 60k & 100k 
replace income_quintile=4 if income>60000 & income<=100000
* fifth quintile if makes above 100k
replace income_quintile=5 if income>100000 
gen spending=cost*4
*gen w_spending=cost*4*finlwt21
*collapse (sum) spending  w_spending, by(income_q) fast
collapse (sum) spending, by(income_q) fast
merge 1:1 income_q using "$db2/CEXhhcount"
drop _merge 
save "$db2/CEXhhcount", replace

use "$root/Processed/CEX/merged_int_all_years", clear
gen spending=cost*4
*gen w_spending=cost*4*finlwt21
*collapse (sum) spending w_spending, fast
collapse (sum) spending, fast
gen income_quintile=100
merge 1:1 income_q using "$db2/CEXhhcount"
drop _merge 
gen spending_capita=spending/hh_count
save "$db2/CEXhhcount", replace

* 2.c Now compute a variety of spending shares
use "$rootcpi\cpi_cex_2004_2015_final", clear

gen Shelter=(Subcategory=="Shelter")
gen SHTS=(Subcategory=="Shelter" | Good_or_Service=="S" | ///
Subcategory=="Private_transportation" | Subcategory=="Public_transportation" | ///
Subcategory=="Miscellaneous_Services" | Subcategory=="Medical_commodities" | ///
Subcategory=="Medical_services" | Subcategory=="Utilities")
* food and drinks at home & housekeeping supplies:
gen FDHHS=(Subcategory=="Alcohol_home" | Subcategory=="Food_home" ///
| item_name=="Housekeeping supplies" | item_name=="Household cleaning products")
* food and drinks at home & housekeeping supplies,
* smoking, personal care, apparel, home equipment
gen FDHHSMore=(FDHHS==1 | Subcategory=="Smoking_Products" ///
| item_name=="Personal care products" ///
| item_name=="Hair, dental, shaving, and miscellaneous personal care products" ///
| item_name=="Cosmetics, perfume, bath, nail preparations and implements" ///
| Subcategory=="Apparel" ///
| Subcategory=="Clocks, lamps and decorator items" ///
| Subcategory=="Dishes and flatware" ///
| Subcategory=="Nonelectric cookware and tableware" ///
| Subcategory=="Tools, hardware and supplies" ///
| Subcategory=="Miscellaneous household products")

rename spending spending_all
foreach i in spending_all spending_incq1 spending_incq2 spending_incq3 spending_incq4 spending_incq5 {
bysort year: egen double tot_`i'=sum(`i')
}

foreach i in spending_all spending_incq1 spending_incq2 spending_incq3 spending_incq4 spending_incq5 {
foreach x in Shelter SHTS FDHHS FDHHSMore {
bysort year: egen double `x'_`i'=sum(`i'*`x')
gen `x'Share_`i'=`x'_`i'/tot_`i'*100
format `x'Share_`i' %8.2f
}
}

keep *Share* year
duplicates drop

* Now average across all years
collapse (mean) *Sh*

* Now reshape and bring to main file
foreach x in Shelter SHTS FDHHS FDHHSMore {
rename `x'Share_spending_all `x'Share_spending_incq100
}

gen id=1
reshape long ShelterShare_spending_incq SHTSShare_spending_incq ///
FDHHSShare_spending_incq FDHHSMoreShare_spending_incq, i(id) j(income_quintile)
drop id

merge 1:1 income_quintile using "$db2/CEXhhcount"
drop _merge

foreach x in Shelter SHTS {
gen ShNon`x'=100-`x'
gen SpNon`x'=spending_capita*ShNon`x'/100
}

foreach x in FDHHSShare FDHHSMoreShare {
gen Sp`x'=spending_capita*`x'/100
}

rename spending_capita spending_capita_cex
merge 1:1 income_quintile using "$resultspath/table1b"
drop _merge

** Examine patterns for CEX
order income_quintile spending_capita_cex SpNonShelter ShNonShelter SpNonSHTS ///
ShNonSHTS SpFDHHSShare FDHHSShare_spending_incq SpFDHHSMoreShare FDHHSMoreShare_spending_incq
replace income_q=0 if income_q==100
sort income_q
format spending_* Sp* %8.2gc
format Sh* %8.2fc
br

** Examiner patterns for Nielsen
gen Nielsen_share=spending_capita/spending_capita_cex*100
gen Nielsen_fooddrinks_share=spending_capita_food_bev/spending_capita_cex*100
order income_quintile spending_capita Nielsen_share spending_capita_food_bev Nielsen_fooddrinks_share
format Nielsen* %8.2fc
br

drop spending hh_count hh_count total_spending_food_bev sample total_spending food_bev_frac source
save "$resultspath/table1b", replace
