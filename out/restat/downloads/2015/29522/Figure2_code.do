
**********************************************************************
***************Price Declines Updated***********
**********************************************************************

***I just copy and pasted the tables****


clear
clear matrix
set mem 50m
set matsize 11000
set more off
use "P:\NPD\Data Update\npdit_update.dta", clear
bysort brand modela: egen totunits = total(units)
gen unit_share = units/totunits
sort brand modela time
by brand modela: gen units_cdf = sum(unit_share)
gen leftcens = 0
replace leftcens = 1 if position == 1 & time == 501
bysort brand modela: egen leftcens_temp = max(leftcens)
drop if leftcens_temp == 1
keep if totunits > 1000

*drop if count == 1

sort brand modela time
drop if units_cdf > .90
drop if units_cdf < .01
by brand modela: gen newpos = _n
by brand modela: gen newcount = _N

bysort brand modela: egen totunits_alt = total(units)
gen unit_share_alt = units/totunits_alt
sort brand modela time
by brand modela: gen units_cdf_alt = sum(unit_share_alt)


gen units_cdf_100 = units_cdf_alt*100


**Intervals of 10*****

forval i = 20(10)100 {
gen cdf_dum_`i' = 0
replace cdf_dum_`i' = 1 if units_cdf_100 >`i' - 10 & units_cdf_100 <= `i'
}

keep if brand == "Apple"| brand == "Compaq" | brand == "Emachines" | brand == "Hewlett Packard" | brand == "Sony" | brand == "Toshiba" | brand == "Gateway" | brand == "Acer"
gen PC = 0
replace PC = 1 if brand == "Compaq" | brand == "Emachines" | brand == "Hewlett Packard" | brand == "Sony" | brand == "Toshiba" | brand == "Gateway"


drop modela_ods
encode modela, gen(modela_ods)

gen cdf_dum_80plus = 0
replace cdf_dum_80plus = 1 if units_cdf_100 > 80 
local brands "Apple Compaq Emachines HP Sony Toshiba Gateway"
foreach k of local brands { 
xi: xtreg lnprice cdf_dum_20 cdf_dum_30 cdf_dum_40 cdf_dum_50 cdf_dum_60 cdf_dum_70 cdf_dum_80 cdf_dum_80plus [aweight = totunits] if brand == "`k'", fe i(modela_ods) cluster(modela_ods)
}

*Robustness
xi: xtreg lnprice cdf_dum_20 cdf_dum_30 cdf_dum_40 cdf_dum_50 cdf_dum_60 cdf_dum_70 cdf_dum_80 cdf_dum_80plus [aweight = totunits] if PC == 1, fe i(modela_ods) cluster(modela_ods)
bysort time: egen agg_sales = total(units)
xi: xtreg lnprice agg_sales  cdf_dum_20 cdf_dum_30 cdf_dum_40 cdf_dum_50 cdf_dum_60 cdf_dum_70 cdf_dum_80 cdf_dum_80plus [aweight = totunits] if PC == 1, fe i(modela_ods) cluster(modela_ods)
gen lnsales = ln(agg_sales)
xi: xtreg lnprice lnsales  cdf_dum_20 cdf_dum_30 cdf_dum_40 cdf_dum_50 cdf_dum_60 cdf_dum_70 cdf_dum_80 cdf_dum_80plus [aweight = totunits] if PC == 1, fe i(modela_ods) cluster(modela_ods)
xi: xtreg lnprice year  cdf_dum_20 cdf_dum_30 cdf_dum_40 cdf_dum_50 cdf_dum_60 cdf_dum_70 cdf_dum_80 cdf_dum_80plus [aweight = totunits] if PC == 1, fe i(modela_ods) cluster(modela_ods)




