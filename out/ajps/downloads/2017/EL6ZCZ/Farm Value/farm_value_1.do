* Date: March 18, 2015
* Apply to: various
* Description: create demand-side variables file

clear

set more off


* Import Census data on number of farms and farm value per state

clear

import excel "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Farm Value\Farms2.xlsx", sheet("Sheet1") firstrow

destring year, gen(year2)
drop year
rename year2 year

gen long stateyear = (state * 10000) + year

drop state year

sort stateyear


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Farm Value\Farms.dta", replace


* Use Census population and farm value data to create measures of farm value per capita

use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Farm Value\Population\pop_1.dta", clear


* Merge farm value variables

sort stateyear


merge 1:1 stateyear using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Farm Value\Farms.dta", update

tab _merge
drop if _merge==2
drop _merge


* Interpolate farm values values

sort state year

by state: ipolate farm_val year, gen(i_farm_val_mil)

gen double i_farm_val = i_farm_val_mil * 1000000
gen long i_pc_farm_val = i_farm_val / i_pop_tot

sort year state


egen i_farm_val_mil_med = pctile(i_farm_val_mil) if admitted==1, p(50) by(year)
egen i_farm_val_mil_p75 = pctile(i_farm_val_mil) if admitted==1, p(75) by(year)

gen i_farm_val_hi = 0
replace i_farm_val_hi = 1 if i_farm_val_mil > i_farm_val_mil_med
replace i_farm_val_hi = . if admitted==0
replace i_farm_val_hi = . if i_farm_val_mil==.

gen i_farm_val_up = 0
replace i_farm_val_up = 1 if i_farm_val_mil > i_farm_val_mil_p75
replace i_farm_val_up = . if admitted==0
replace i_farm_val_up = . if i_farm_val_mil==.

drop i_farm_val_mil_med i_farm_val_mil_p75 farm_val


egen i_pc_farm_val_med = pctile(i_pc_farm_val) if admitted==1, p(50) by(year)
egen i_pc_farm_val_p75 = pctile(i_pc_farm_val) if admitted==1, p(75) by(year)

gen i_pc_farm_val_hi = 0
replace i_pc_farm_val_hi = 1 if i_pc_farm_val > i_pc_farm_val_med
replace i_pc_farm_val_hi = . if admitted==0
replace i_pc_farm_val_hi = . if i_pc_farm_val==.

gen i_pc_farm_val_up = 0
replace i_pc_farm_val_up = 1 if i_pc_farm_val > i_pc_farm_val_p75
replace i_pc_farm_val_up = . if admitted==0
replace i_pc_farm_val_up = . if i_pc_farm_val==.

drop i_pc_farm_val_med i_pc_farm_val_p75


* Interpolate farms values

sort state year

by state: ipolate farms year, gen(i_farms_tho)

gen double i_farms = i_farms_tho * 1000
gen long i_pc_farms = i_farms / i_pop_tot

sort year state


egen i_farms_tho_med = pctile(i_farms_tho) if admitted==1, p(50) by(year)
egen i_farms_tho_p75 = pctile(i_farms_tho) if admitted==1, p(75) by(year)

gen i_farms_hi = 0
replace i_farms_hi = 1 if i_farms_tho > i_farms_tho_med
replace i_farms_hi = . if admitted==0
replace i_farms_hi = . if i_farms_tho==.

gen i_farms_up = 0
replace i_farms_up = 1 if i_farms_tho > i_farms_tho_p75
replace i_farms_up = . if admitted==0
replace i_farms_up = . if i_farms_tho==.

drop i_farms_tho_med i_farms_tho_p75 farms


egen i_pc_farms_med = pctile(i_pc_farms) if admitted==1, p(50) by(year)
egen i_pc_farms_p75 = pctile(i_pc_farms) if admitted==1, p(75) by(year)

gen i_pc_farms_hi = 0
replace i_pc_farms_hi = 1 if i_pc_farms > i_pc_farms_med
replace i_pc_farms_hi = . if admitted==0
replace i_pc_farms_hi = . if i_pc_farms==.

gen i_pc_farms_up = 0
replace i_pc_farms_up = 1 if i_pc_farms > i_pc_farms_p75
replace i_pc_farms_up = . if admitted==0
replace i_pc_farms_up = . if i_pc_farms==.

drop i_pc_farms_med i_pc_farms_p75


* Drop extraneous observations

drop if year < 1878
drop if year > 1932

drop year

keep stateyear i_pc_farm_val_hi i_farms_hi i_pop_tot i_pop_urban_p

sort stateyear


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Farm Value\farm_value_1.dta", replace

* End
