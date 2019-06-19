clear
set more off
set mem 500m
use "C:\Documents and Settings\odaxs1\My Documents\NPD\Data Update\npdit_update.dta", clear
collapse (mean) unit_price, by(time)
drop if time ==.
drop unit_price
sort time
save "C:\Documents and Settings\odaxs1\My Documents\NPD\Data Update\temp\blank.dta", replace
clear
use "C:\Documents and Settings\odaxs1\My Documents\NPD\Data Update\npdit_update.dta", clear
sort brand modela time
bysort brand modela: egen totunits = total(units)
gen unit_share = units/totunits
bysort brand modela: gen units_cdf = sum(unit_share)

drop if brand == "Private Label"

gen leftcens = 0
replace leftcens = 1 if position == 1 & time == 501
bysort modela: egen leftcens_temp = max(leftcens)
drop if leftcens_temp == 1
sort modela time


*quietly drop if count == 1
drop if units_cdf < .01
sort brand modela time
by brand modela: gen newpos = _n


*****HP**********
*keep if brand == "Hewlett Packard"  & display > 14.9 & display < 16  & formpc == "Notebook"  & totunits >20000

******Toshiba
*keep if (brand == "Toshiba")  & display > 14.9 & display < 16  & formpc == "Notebook"  & totunits >15000

***********Sony**************************
*keep if (brand == "Sony") & display > 14.9 & display < 16 & formpc == "Notebook"  & totunits >15000 

*****Apple*******
keep if (brand == "Apple") & display > 14.9 & display < 16 & formpc == "Notebook"  & totunits >4000



*keep time modela  unit_price count units_cdf
*keep time modela  speedprice count units_cdf
keep time modela position unit_price units harddrive totunits speed speedprice units_cdf
cd "C:\Documents and Settings\odaxs1\My Documents\NPD\Data Update\temp"
quietly egen subgroup = group(modela)
quietly levelsof subgroup, local(levels) 
foreach i of local levels { 
      quietly preserve
	quietly keep if subgroup == `i'
      quietly drop if units_cdf > .90
      quietly sort time
      quietly rename unit_price price_`i'
	quietly rename units units_`i'
      quietly rename harddrive  hd_`i'
      *quietly rename position   pos_`i'
      quietly rename speed   speed_`i'
      *quietly rename speedprice sp_`i'
      quietly save temp_`i', replace
	clear
	use "C:\Documents and Settings\odaxs1\My Documents\NPD\Data Update\temp\blank.dta"
      quietly sort time
	quietly merge time using temp_`i'
      quietly drop _merge
	quietly save "C:\Documents and Settings\odaxs1\My Documents\NPD\Data Update\temp\blank.dta", replace
      quietly restore 
}

use "C:\Documents and Settings\odaxs1\My Documents\NPD\Data Update\temp\blank.dta", clear


*keep time price* speed* units*
keep time price* 
browse




 
