****************************************************************************
***** This do.file generates measures of entry and exit of 
***** goods across the product space (Quality-Modules/Modules/Groups/Dep.)
****************************************************************************

global db "D:\Dropbox\unequal_gains\main_data"
global db2 "D:\Dropbox\unequal_gains\QJE revision plan\analysis"
cd "$db2\RMS\collapsed_files\state_level"

* (1) Main datasets
foreach i of numlist 2006(1)2014 {

display "Starting Tornqvist computation for year `i', all consumers at different aggregation levels"

local var=`i'+1

use rms_`i', clear
rename total_quantity total_quantity_all_old
rename average_unit_price_all average_unit_price_all_old
gen upc_ver_uc=1
rename total_spending total_spending_all_old

* bring in info on UPC price decile (within product module) in base period:
merge m:1 upc upc_ver_uc using "$db/Important Lists/upc_brand_size_final.dta"
keep if _merge==3
drop _merge
sum size1_amount, d
drop if size1_amount<r(p1) | size1_amount>r(p99)
gen average_unit_price_adj=average_unit_price_all/(size1_amount*multi)
* create quality ranks without weights
sort product_module_code average_unit_price_adj
bysort product_module_code: gen double temp=[_N]
bysort product_module_code: gen double temp2=[_n]
gen rank=temp2/temp*100
gen quality_rank=.
foreach r of numlist 1(1)10 {
replace quality_rank=`r' if rank<=`r'*10 & missing(quality_rank)
}

merge 1:1 upc using rms_`var'
keep if _merge==3
rename total_quantity total_quantity_all
rename total_spending total_spending_all

gen double price_ratio_all=average_unit_price_all/average_unit_price_all_old
gen double quantity_ratio_all = total_quantity_all/total_quantity_all_old
* get rid of outliers
sum price_ratio_all, d
gen p1_p=r(p1)
gen p99_p=r(p99)
sum quantity_ratio_all, d
gen p1_q=r(p1)
gen p99_q=r(p99)
drop if price_ratio_all<p1_p | price_ratio_all>p99_p | ///
quantity_ratio_all<p1_q | quantity_ratio_all>p99_q

keep upc upc_ver_uc total_spending_all total_spending_all_old total_quantity_all total_quantity_all_old ///
average_unit_price_all average_unit_price_all_old price_ratio_all product_module_code product_group_code ///
department_code quality_rank quantity_ratio_all
duplicates drop

* (i) compute Tornqvist/Laspeyres/Paasche/CES price-quantity by quality_module
bysort product_module quality: egen double total_spending_QM=sum(total_spending_all)
bysort product_module quality: egen double total_spending_QM_old=sum(total_spending_all_old)
gen double share_QM=total_spending_all/total_spending_QM
gen double share_QM_old=total_spending_all_old/total_spending_QM_old
* tornqvist
gen double weight_QM=1/2*(share_QM+share_QM_old)
gen double numerator_temp=weight*log(price_ratio_all)
bysort product_module quality: egen double numerator=sum(numerator_temp)
gen double tornqvist_price_index=exp(numerator)
drop numerator numerator_temp weight*
* ces price
gen double weight_num=(share_QM-share_QM_old)/(ln(share_QM)-ln(share_QM_old))
bysort product_module quality: egen double weight_den=sum(weight_num)
gen double weight=weight_num/weight_den
gen double numerator_temp=weight*log(price_ratio_all)
bysort product_module quality: egen double numerator=sum(numerator_temp)
gen double ces_price_index=exp(numerator)
* ces quantity
gen double numerator_temp_q=weight*log(quantity_ratio_all)
bysort product_module quality: egen double numerator_q=sum(numerator_temp_q)
gen double ces_quantum_index=exp(numerator_q)
drop numerator* numerator_temp* weight*
* laspeyres
gen double numerator_temp=average_unit_price_all*total_quantity_all_old 
gen double denominator_temp=average_unit_price_all_old*total_quantity_all_old
bysort product_module quality: egen double numerator=sum(numerator_temp)
bysort product_module quality: egen double denominator=sum(denominator_temp)
gen laspeyres_price_index=numerator/denominator
drop numerator denominator numerator_temp denominator_temp
* paasche
gen double numerator_temp=average_unit_price_all*total_quantity_all
gen double denominator_temp=average_unit_price_all_old*total_quantity_all
bysort product_module quality: egen double numerator=sum(numerator_temp)
bysort product_module quality: egen double denominator=sum(denominator_temp)
gen paasche_price_index=numerator/denominator
drop numerator denominator numerator_temp denominator_temp

preserve
keep tornqvist_price_index ces_price_index ces_q laspeyres_price_index paasche_price_index ///
product_module quality product_group department total_spending_QM total_spending_QM_old
duplicates drop
save "$db/Important Price Datasets/inflation_QM_`i'_RMS.dta", replace
restore
drop tornqvist ces_p ces_q laspeyres paasche

* (ii) compute Tornqvist by module (note that this is effectively "nested" Tornqvist)
bysort product_module : egen double total_spending_M=sum(total_spending_all)
bysort product_module : egen double total_spending_M_old=sum(total_spending_all_old)
gen double share_M=total_spending_all/total_spending_M
gen double share_M_old=total_spending_all/total_spending_M_old

gen weight_M=1/2*(share_M+share_M_old)
gen double numerator_temp=weight*log(price_ratio_all)
bysort product_module : egen double numerator=sum(numerator_temp)
gen double tornqvist_price_index=exp(numerator)

preserve
keep tornqvist_price_index product_module product_group department total_spending_M total_spending_M_old
duplicates drop
save "$db/Important Price Datasets/inflation_M_`i'_RMS.dta", replace
restore
drop numerator numerator_temp weight tornqvist

* (iii) compute Tornqvist by group
bysort product_group : egen double total_spending_G=sum(total_spending_all)
bysort product_group : egen double total_spending_G_old=sum(total_spending_all_old)
gen double share_G=total_spending_all/total_spending_G
gen double share_G_old=total_spending_all/total_spending_G_old

gen weight_G=1/2*(share_G+share_G_old)
gen double numerator_temp=weight*log(price_ratio_all)
bysort product_group : egen double numerator=sum(numerator_temp)
gen double tornqvist_price_index=exp(numerator)

preserve
keep tornqvist_price_index product_group department total_spending_G total_spending_G_old
duplicates drop
save "$db/Important Price Datasets/inflation_G_`i'_RMS.dta", replace
restore
drop numerator numerator_temp weight tornqvist

* (iv) compute Tornqvist by department
bysort department : egen double total_spending_D=sum(total_spending_all)
bysort department : egen double total_spending_D_old=sum(total_spending_all_old)
gen double share_D=total_spending_all/total_spending_D
gen double share_D_old=total_spending_all/total_spending_D_old

gen weight_D=1/2*(share_D+share_D_old)
gen double numerator_temp=weight*log(price_ratio_all)
bysort department : egen double numerator=sum(numerator_temp)
gen double tornqvist_price_index=exp(numerator)

keep tornqvist_price_index department total_spending_D total_spending_D_old
duplicates drop
save "$db/Important Price Datasets/inflation_D_`i'_RMS.dta", replace
}

* (2) Inflation across QM by computing average price over both years
foreach i of numlist 2006(1)2014 {

display "Starting Tornqvist computation for year `i', all consumers at different aggregation levels"

local var=`i'+1

use rms_`i', clear
rename total_quantity total_quantity_old
rename average_unit_price_all average_unit_price_all_old
rename total_spending total_spending_all_old

merge 1:1 upc using rms_`var'
keep if _merge==3
rename total_spending total_spending_all
drop _merge

gen upc_ver_uc=1

* bring in info on UPC price decile (within product module) [for continued products, taking the average price in both periods]:
merge m:1 upc upc_ver_uc using "$db/Important Lists/upc_brand_size_final.dta"
keep if _merge==3
drop _merge
sum size1_amount, d
drop if size1_amount<r(p1) | size1_amount>r(p99)
gen average_unit_price_adj=(average_unit_price_all+average_unit_price_all_old)/(2*size1_amount*multi)
* create quality ranks without weights
sort product_module_code average_unit_price_adj
bysort product_module_code: gen double temp=[_N]
bysort product_module_code: gen double temp2=[_n]
gen rank=temp2/temp*100
gen quality_rank=.
foreach r of numlist 1(1)10 {
replace quality_rank=`r' if rank<=`r'*10 & missing(quality_rank)
}

gen double price_ratio_all=average_unit_price_all/average_unit_price_all_old
* get rid of outliers
sum price_ratio_all, d
drop if price_ratio_all<r(p1) | price_ratio_all>r(p99)

keep upc total_spending_all total_spending_all_old price_ratio_all product_module_code product_group_code department_code quality_rank
duplicates drop

* (i) compute Tornqvist by quality_module
bysort product_module quality: egen double total_spending_QM=sum(total_spending_all)
bysort product_module quality: egen double total_spending_QM_old=sum(total_spending_all_old)
gen double share_QM=total_spending_all/total_spending_QM
gen double share_QM_old=total_spending_all_old/total_spending_QM_old

gen weight_QM=1/2*(share_QM+share_QM_old)
gen double numerator_temp=weight*log(price_ratio_all)
bysort product_module quality: egen double numerator=sum(numerator_temp)
gen double tornqvist_price_index=exp(numerator)

keep tornqvist_price_index product_module quality product_group department total_spending_QM total_spending_QM_old
duplicates drop
save "$db/Important Price Datasets/inflation_QM_`i'_2yrs_RMS.dta", replace
}

* (3) Price ratio for each continued UPC (for decomposition across barcodes)
foreach i of numlist 2006(1)2014 {

display "Starting Tornqvist computation for year `i', all consumers at different aggregation levels"

local var=`i'+1

use rms_`i', clear
rename total_quantity total_quantity_old
rename average_unit_price_all average_unit_price_all_old
rename total_spending total_spending_all_old

merge 1:1 upc using rms_`var'
keep if _merge==3
rename total_spending total_spending_all
drop _merge

gen double price_ratio_all=average_unit_price_all/average_unit_price_all_old
gen upc_ver_uc=1
keep upc upc_ver_uc price_ratio_all
duplicates drop

save "$db/Important Price Datasets/inflation_upc_`i'_RMS.dta", replace
}

