

***merge time series

use "$data/ts_wages.dta", clear

merge 1:1 ltypes stateicp survey using "$data\ts_supply.dta"

order survey stateicp lweekly sizew ltypes
sort survey stateicp lweekly sizew ltypes
egen state = group(stateicp)

gen lgsupply=log(sizew)

sort survey state lweekly lgsupply ltypes
keep survey state lweekly lgsupply ltypes
reshape wide lweekly  lgsupply, i(state survey) j(ltypes)

***save full panel dataset
save "$data/final_panel.dta", replace

***produce csv
use "$data/final_panel.dta", clear


order state survey	
		
***preserve, sort, produce state and survey vector IT of specific ltype
preserve
sort state survey
keep state survey
outsheet using "$output/IT.csv", delimiter(";") nonames replace
restore

***preserve, sort, produce dependend variable wage Y vector of specific ltype
preserve
sort state survey
keep lweekly*
outsheet using "$output/Y.csv", delimiter(";") nonames replace
restore

***preserve, sort, produce independend variable sum of workers (weighted by hours worked (as are lweekly) vector of specific ltype
preserve
sort state survey
keep lgsupply*
outsheet using "$output/X.csv", delimiter(";") nonames replace
restore


