clear
clear matrix
set mem 3g
set matsize 2000
set more off
use "E:\ODResearch\NPD\Data Update\npdit_update.dta", clear
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

drop if units_cdf > .90
drop if units_cdf < .01
drop if unit_share <.05

bysort brand modela: egen totunits_alt = total(units)
gen unit_share_alt = units/totunits_alt
sort brand modela time
by brand modela: gen units_cdf_alt = sum(unit_share_alt)


sort brand modela time
by brand modela: gen newpos = _n
by brand modela: gen newcount = _N
*cd "X:\NPD\Data Update\temp"

keep if brand == "Apple"| brand == "Compaq" | brand == "Emachines" | brand == "Hewlett Packard" | brand == "Sony" | brand == "Toshiba" | brand == "Gateway" | brand == "Acer"
gen PC = 0
replace PC = 1 if brand == "Compaq" | brand == "Emachines" | brand == "Hewlett Packard" | brand == "Sony" | brand == "Toshiba" | brand == "Gateway"


***CHOOSE PDF***
keep if PC == 1
*keep if brand == "Apple"
*keep if brand == "Compaq"
*keep if brand == "Hewlett Packard"
*keep if brand == "Emachines"
*keep if brand == "Sony"
*keep if brand == "Gateway"
*keep if brand == "Toshiba"

bysort newpos: egen mean_pdf_pc = mean(unit_share_alt)  
bysort newpos: egen med_pdf_pc = median(unit_share_alt)

bysort newpos: egen mean_cdf_pc = mean(units_cdf_alt) 
bysort newpos: egen med_cdf_pc = median(units_cdf_alt)


tab newpos


 
collapse (sum) units, by(newpos) 
 
 
*collapse (mean) unit_share_alt units_cdf_alt [fweight = totunits], by(newpos) 
