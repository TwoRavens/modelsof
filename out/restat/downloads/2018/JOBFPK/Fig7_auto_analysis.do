
clear
set more off

**Boehm/Flaaen/Pandalai-Nayar
**This file shows some cleaning of the auto production data


/**************************************************************************************
*Structure of File
**Input Data: Proprietary Data from Ward's Auto 
	**We put the data through a seasonal adjustment process (The bank of beligum had free software that approximates the X12)
	
**Output Data: auto_data.txt
**************************************************************************************/


global datadir "<set directory>"
cd $datadir



local smoothpar = 14400

* load and merge data 
* notice: I am dropping all observations that are not matched!

use prod_na_company_sa.dta, clear
order company monthvar
sort company monthvar
save "prod_data_temp_sa", replace

use sales_na_company_sa.dta, clear
order company monthvar
sort company monthvar
save "sales_data_temp_sa", replace

use inv_us_company_sa.dta, clear
order company monthvar
sort company monthvar
save "us_inv_data_temp_sa", replace

use sales_data_temp_sa, clear
merge 1:1 company monthvar using prod_data_temp_sa 
drop _merge

merge 1:1 company monthvar using us_inv_data_temp_sa
drop _merge

drop if company=="total"

gen month = mvar
drop mvar

order company monthvar year month prod_sa 
sort company monthvar

gen japan = 0
replace japan = 1 if company=="honda" | company=="toyota" | company=="mitsubishi" | company=="subaru"
replace japan = 1 if company=="nissan" | company=="mazda" | company=="isuzu"


collapse year month (sum) prod_sa , by(japan monthvar)

order japan monthvar year month prod_sa 

gen to_keep = 0 
gen rel_time = -999

forvalues i = -10(1)10 {
	
	replace to_keep = 1 if monthvar == 614 + `i'
	replace rel_time = `i' if monthvar == 614 + `i'
	
}



xtset japan monthvar, monthly

gen log_prod = log(prod_sa)

tsfilter hp log_prod_c = log_prod, smooth(`smoothpar')

local var "prod_c"
keep if to_keep == 1
sort japan monthvar

keep japan rel_time log_prod_c

reshape wide log_prod_c, i(rel_time) j(japan)
gen prod_dif = log_prod_c1 - log_prod_c0
drop log_prod*

export delimited using "auto_data.txt", delimiter(tab) novarnames replace
