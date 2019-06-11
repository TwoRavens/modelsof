
**** 1. Convert to state-level files from raw files from Nielsen 

**** 2. Convert to national-level datasets
global db "D:\Dropbox\unequal_gains\QJE revision plan\analysis"
global db2 "D:\Dropbox\unequal_gains\main_data"
cd "$db\RMS\collapsed_files\state_level"

foreach i of numlist 2006(1)2015 {
use state_`i', clear
collapse (sum) total_quantity total_spending, by(product_group_code product_module_code upc)
gen average_unit_price_all=total_spending/total_quantity
* bring in info on department
merge m:1 product_group_code using  "$db2/Important Lists/groups_dep.dta", keepusing(department_code)
keep if _merge==3
drop _merge
save rms_`i', replace
}
