*****Graphs Saved as competition_graph in modelpaper/figures********
clear
set mem 500m
set matsize 800
set more off
use "E:\ODResearch\NPD\Data Update\npdit_update.dta", clear
collapse (mean) unit_price, by(time)
drop if time ==.
drop unit_price
sort time
save "E:\ODResearch\NPD\Data Update\temp\blank.dta", replace
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


drop if units_cdf > .900
*drop if units_cdf < .01
sort brand modela time
by brand modela: gen newpos = _n
drop count
bysort modela: gen count = _N


drop if brand == "Private Label"
*drop if brand == "Apple"
keep if brand == "Compaq" | brand == "Hewlett Packard" | brand == "Toshiba" | brand == "Sony"
*keep if brand == "Apple"

keep time modela count unit_price harddrive totunits speed units_cdf brand display formpc units position newpos ram  scrnqul proctyp

*keep if display > 14.9 & display < 16 & formpc == "Notebook"  & totunits > 1000  	
keep if display > 14.9 & display < 16 & formpc == "Notebook"  & totunits > 1000 & ram == 512
*keep if display > 14.9 & display < 16 & formpc == "Notebook"  & totunits > 1000 & ram == 256		

*keep if formpc == "Notebook"  & totunits > 1000



bysort time: egen maxprice = max(unit_price)
gen flag = 0 
replace flag = 1 if unit_price == maxprice & newpos == 1
bysort modela: egen flag2 = max(flag)

****flag2 means the highest price happened to be an entering good*****
keep if flag2 == 1


bysort time: egen maxprice3 = max(unit_price) if newpos == 1
gen flag3 = 0
replace flag3 =1 if unit_price == maxprice3 & newpos == 1
bysort modela: egen flag4 = max(flag3)

****flag4 means this was the higest priced entering good*******
*keep if flag4 == 1


sort modela time
quietly egen subbrand = group(brand)
quietly levelsof subbrand, local(levels_b)
foreach j of local levels_b{
quietly egen subgroup_`j' = group(modela)	if subbrand == `j'
quietly levelsof subgroup_`j' if subbrand == `j', local(levels) 
		foreach i of local levels { 
		quietly preserve
		keep if subbrand == `j' 	
		quietly keep if subgroup_`j' == `i'
      	quietly sort time
      	quietly rename unit_price price_`j'_`i'
		quietly rename units units_`j'_`i'
      	*quietly rename count count_`j'_`i'
      	quietly rename harddrive  hd_`j'_`i'
      	quietly rename position   pos_`j'_`i'
      	quietly rename speed   speed_`j'_`i'
      	*quietly rename speedprice sp_`j'_`i'
		quietly rename brand brand_`j'_`i'
		quietly rename units_cdf units_cdf_`j'_`i'
		quietly rename scrnqul scrnqul_`j'_`i'
		quietly rename proctyp proctyp_`j'_`i'
      	quietly save temp_`j'_`i', replace
		clear
		use "E:\ODResearch\NPD\Data Update\temp\blank.dta"
      	quietly sort time
		quietly merge time using temp_`j'_`i'
      	quietly drop _merge
		quietly save  "E:\ODResearch\NPD\Data Update\temp\blank.dta", replace
      	quietly restore 
		} 


}


use "E:\ODResearch\NPD\Data Update\temp\blank.dta", clear


*keep time price* brand* units* units_cdf*
*keep time price* brand* speed_* hd_* scrnqul_* proctyp_*
keep time price* brand* 

browse




 
