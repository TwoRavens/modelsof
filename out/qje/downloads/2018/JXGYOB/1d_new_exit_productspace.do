****************************************************************************
***** This do.file generates measures of entry and exit of 
***** goods across the product space (Quality-Modules/Modules/Groups/Dep.)
****************************************************************************
** Note: quality deciles are based on CURRENT prices

global db "D:\Dropbox\unequal_gains\main_data"

* generate files for 2003 and 2016 so that we can run one loop, then we re-arrange the files below
clear
set obs 1
generate upc=.
generate upc_ver_uc=.
save "$db/Important Lists/available_upcs_upto2003_final.dta", replace
save "$db/Important Lists/available_upcs_post2015_final.dta", replace

**************************************************************************** 
*** PART I build measures of new goods across product space using HMS DATA *
**************************************************************************** 

foreach i of numlist 2004(1)2015 {

local prev=`i'-1

use "$db/Important Price Datasets/price_index_household_income_`i'_2004_modules_final.dta", clear

merge m:1 upc upc_ver using "$db/Important Lists/available_upcs_upto`prev'_final.dta"
drop if _merge==2
gen new=(_merge==1)
drop _merge

merge m:1 upc upc_ver using "$db/Important Lists/available_upcs_post`i'_final.dta"
drop if _merge==2
gen exit=(_merge==1)
drop _merge

drop total_spending*

* bring in info on UPC price decile (within product module):
merge m:1 upc upc_ver_uc using "$db/Important Lists/upc_brand_size_final.dta"
keep if _merge==3
drop _merge
sum size1_amount, d
drop if size1_amount<r(p1) | size1_amount>r(p99)
gen average_unit_price_adj=average_unit_price_all/(size1_amount*multi)
* create quality ranks without weights [note that here we adopt a slightly different definition of the quality threshold
* compare to the inflation file because it's only based on CURRENT price]
sort product_module_code average_unit_price_adj
bysort product_module_code: gen double temp=[_N]
bysort product_module_code: gen double temp2=[_n]
gen rank=temp2/temp*100
gen quality_rank=.
foreach r of numlist 1(1)10 {
replace quality_rank=`r' if rank<=`r'*10 & missing(quality_rank)
}

* collapse to UPC level 
bysort upc upc_ver_uc: egen double total_spending_all=sum(average_unit_price_all*total_quantity)
bysort upc upc_ver_uc: egen double total_spending_new_all=sum(average_unit_price_all*total_quantity*new)
bysort upc upc_ver_uc: egen double total_spending_exit_all=sum(average_unit_price_all*total_quantity*exit)

keep total_spending_all total_spending_new_all total_spending_exit_all ///
product_module_code product_group_code department_code quality_rank
duplicates drop

* (i) compute spending on new/exiting goods by quality_module
bysort product_module quality: egen double total_spending_QM=sum(total_spending_all)
bysort product_module quality: egen double total_spending_new_QM=sum(total_spending_new_all)
bysort product_module quality: egen double total_spending_exit_QM=sum(total_spending_exit_all)

keep product_module quality product_group department total_spending_QM ///
total_spending_new_QM total_spending_exit_QM
duplicates drop

gen ssnpQM  = total_spending_new_QM/total_spending_QM
gen ssepQM  = total_spending_exit_QM/total_spending_QM

gen year=`i'
save "$db/Important Price Datasets/new_exit_QM_`i'.dta", replace

* (ii) compute spending on new/exiting goods by module
bysort product_module: egen double total_spending_M=sum(total_spending_QM)
bysort product_module: egen double total_spending_new_M=sum(total_spending_new_QM)
bysort product_module: egen double total_spending_exit_M=sum(total_spending_exit_QM)

keep product_module product_group department total_spending_M ///
total_spending_new_M total_spending_exit_M
duplicates drop

gen ssnpM  = total_spending_new_M/total_spending_M
gen ssepM  = total_spending_exit_M/total_spending_M

gen year=`i'
save "$db/Important Price Datasets/new_exit_M_`i'.dta", replace

* (ii) compute spending on new/exiting goods by group
bysort product_group: egen double total_spending_G=sum(total_spending_M)
bysort product_group: egen double total_spending_new_G=sum(total_spending_new_M)
bysort product_group: egen double total_spending_exit_G=sum(total_spending_exit_M)

keep product_group department total_spending_G ///
total_spending_new_G total_spending_exit_G
duplicates drop

gen ssnpG  = total_spending_new_G/total_spending_G
gen ssepG  = total_spending_exit_G/total_spending_G

gen year=`i'
save "$db/Important Price Datasets/new_exit_G_`i'.dta", replace

* (iii) compute spending on new/exiting goods by department
bysort department: egen double total_spending_D=sum(total_spending_G)
bysort department: egen double total_spending_new_D=sum(total_spending_new_G)
bysort department: egen double total_spending_exit_D=sum(total_spending_exit_G)

keep department total_spending_D ///
total_spending_new_D total_spending_exit_D
duplicates drop

gen ssnpD  = total_spending_new_D/total_spending_D
gen ssepD  = total_spending_exit_D/total_spending_D

gen year=`i'
save "$db/Important Price Datasets/new_exit_D_`i'.dta", replace
}


***************************************************************************** 
*** PART II build measures of new goods across product space using RMS DATA *
***************************************************************************** 
global db "D:\Dropbox\unequal_gains\QJE revision plan\analysis"
global db2 "D:\Dropbox\unequal_gains\main_data"
cd "$db\RMS\collapsed_files\state_level"


foreach i of numlist 2006(1)2015 {

local prev=`i'-1
local next=`i'+1

use rms_`i', clear
gen upc_ver_uc=1

merge m:1 upc upc_ver_uc using "$db2/Important Lists/available_upcs_upto`prev'_final.dta"
drop if _merge==2
gen new=(_merge==1)
drop _merge

merge m:1 upc upc_ver_uc using "$db2/Important Lists/available_upcs_post`i'_final.dta"
drop if _merge==2
gen exit=(_merge==1)
drop _merge

* bring in info on UPC price decile (within product module):
merge 1:1 upc upc_ver_uc using "$db2/Important Lists/upc_brand_size_final.dta"
keep if _merge==3
drop _merge
sum size1_amount, d
drop if size1_amount<r(p1) | size1_amount>r(p99)
gen average_unit_price_adj=average_unit_price_all/(size1_amount*multi)
* create quality ranks without weights [note that here we adopt a slightly different definition of the quality threshold
* compare to the inflation file because it's only based on CURRENT price]
sort product_module_code average_unit_price_adj
by product_module_code: gen double temp=[_N]
by product_module_code: gen double temp2=[_n]
gen rank=temp2/temp*100
gen quality_rank=.
foreach r of numlist 1(1)10 {
replace quality_rank=`r' if rank<=`r'*10 & missing(quality_rank)
}

drop total_spending 

* collapse to UPC level 
bysort upc upc_ver_uc: egen double total_spending_all=sum(average_unit_price_all*total_quantity)
bysort upc upc_ver_uc: egen double total_spending_new_all=sum(average_unit_price_all*total_quantity*new)
bysort upc upc_ver_uc: egen double total_spending_exit_all=sum(average_unit_price_all*total_quantity*exit)

keep upc upc_ver_uc total_spending_all total_spending_new_all total_spending_exit_all ///
product_module_code product_group_code department_code quality_rank
duplicates drop

* (i) compute spending on new/exiting goods by quality_module
bysort product_module quality: egen double total_spending_QM=sum(total_spending_all)
bysort product_module quality: egen double total_spending_new_QM=sum(total_spending_new_all)
bysort product_module quality: egen double total_spending_exit_QM=sum(total_spending_exit_all)

keep product_module quality product_group department total_spending_QM ///
total_spending_new_QM total_spending_exit_QM
duplicates drop

gen ssnpQM  = total_spending_new_QM/total_spending_QM
gen ssepQM  = total_spending_exit_QM/total_spending_QM

gen year=`i'
save "$db2/Important Price Datasets/RMSnew_exit_QM_`i'.dta", replace

* (ii) compute spending on new/exiting goods by module
bysort product_module: egen double total_spending_M=sum(total_spending_QM)
bysort product_module: egen double total_spending_new_M=sum(total_spending_new_QM)
bysort product_module: egen double total_spending_exit_M=sum(total_spending_exit_QM)

keep product_module product_group department total_spending_M ///
total_spending_new_M total_spending_exit_M
duplicates drop

gen ssnpM  = total_spending_new_M/total_spending_M
gen ssepM  = total_spending_exit_M/total_spending_M

gen year=`i'
save "$db2/Important Price Datasets/RMSnew_exit_M_`i'.dta", replace

* (ii) compute spending on new/exiting goods by group
bysort product_group: egen double total_spending_G=sum(total_spending_M)
bysort product_group: egen double total_spending_new_G=sum(total_spending_new_M)
bysort product_group: egen double total_spending_exit_G=sum(total_spending_exit_M)

keep product_group department total_spending_G ///
total_spending_new_G total_spending_exit_G
duplicates drop

gen ssnpG  = total_spending_new_G/total_spending_G
gen ssepG  = total_spending_exit_G/total_spending_G

gen year=`i'
save "$db2/Important Price Datasets/RMSnew_exit_G_`i'.dta", replace

* (iii) compute spending on new/exiting goods by group
bysort department: egen double total_spending_D=sum(total_spending_G)
bysort department: egen double total_spending_new_D=sum(total_spending_new_G)
bysort department: egen double total_spending_exit_D=sum(total_spending_exit_G)

keep department total_spending_D ///
total_spending_new_D total_spending_exit_D
duplicates drop

gen ssnpD  = total_spending_new_D/total_spending_D
gen ssepD  = total_spending_exit_D/total_spending_D

gen year=`i'
save "$db2/Important Price Datasets/RMSnew_exit_D_`i'.dta", replace
}
