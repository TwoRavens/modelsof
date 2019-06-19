**********************************************************************
***************Frontier Numbers***************************************
**********************************************************************



clear
clear matrix
set more off
set mem 600m
cd "P:\NPD\Data Update"
use npdit_update.dta, clear
bysort brand modela: egen totunits = total(units)
gen unit_share = units/totunits
sort brand modela time

replace proccore = "Single" if proccore == ""

keep if totunits > 1000
by brand modela: gen units_cdf = sum(unit_share)
gen leftcens = 0
replace leftcens = 1 if position == 1 & time == 501
bysort brand modela: egen leftcens_temp = max(leftcens)
drop if leftcens_temp == 1

by brand modela: gen newpos = _n
by brand modela: gen newcount = _N

gen flag = 0
sort brand modela time
by brand modela: replace flag = 1 if time[_n] ~= time[_n+1] - 1 & _n ~= _N 
*drop if flag == 1

sort brand modela time
*drop if units_cdf > .975


cd "P:\NPD\Data Update\temp"

keep if procbran == "Intel"
drop if proctyp == "" | proctyp == "Apple" | proctyp == "Apple G5" | proctyp == "Null" |proctyp == "Not Specified"| proctyp == "Pentium" | proctyp == "Core Duo" | proctyp == "Xeon"


gen top = 0
gen intro_brand = 0
sort proctyp time 
by proctyp: replace top = 1 if _n == 1
gen intro_date_t = time if top == 1

by proctyp: egen intro_date = max(intro_date_t)

****Fix from NotebookCheck.Net****
*replace intro_date = 552 if proctyp == "Core Duo T2600"

sort proctyp brand time
gen chip_lag = time - intro_date
keep if subcat == "Notebook Computers"
*keep if display == 15.4 | display == 15.2
keep if time > 556
gen leftcens_n = 0
replace leftcens_n = 1 if position > 1 & time == 557
bysort brand modela: egen leftcens_temp_n = max(leftcens_n)
*drop if leftcens_temp_n == 1


bysort time brand: egen minlag = min(chip_lag)


*****Chip Adopt Graph*****
collapse (mean) minlag, by(time brand)
sort brand time
