
foreach num of numlist 99 90 75 {
clear all
clear matrix
set more off
set mem 700m

local Dtail   = "P`num'"
local  tail   =  `num'

capture log close
log using mydisasters_`Dtail'.log, replace

use  disaster_macro_V2_by_event.dta

* Add disasters within coutry-year
* --------------------------------

sort wbcode year id
egen total_killed            =  sum(killed), by(wbcode year)
gen missing_total_killed     =  (killed  ==. & disaster==1)
egen yc_missing_total_killed =  sum(missing_total_killed  ) , by(wbcode year)
replace total_killed         =  . if yc_missing_total_killed   >= 1

egen n_disasters  =  sum(disaster) , by(wbcode year)                                                          
                                                                                                      
* Collapse data at the country-year level                                                             
* ---------------------------------------
sort wbcode year id
by wbcode year : gen counter = _n
keep if counter==1

replace disaster=1 if n_disasters>=1
replace disaster=0 if n_disasters==0

* Drop Countries with pop < 1,000,000
* -----------------------------------
drop if pop <1000000

* generate normalized magnitude measure
* -------------------------------------

sort wbcode year

           gen killed_pop  = total_killed     / pop
by wbcode: gen killed_pop2 = total_killed[_n] / pop[_n-1]


* compute large disaster if magnitude > some percentile
* -----------------------------------------------------

qui su killed_pop2 if killed_pop2 != . & disaster==1 & year<2000, detail

scalar  p75_killed_pop2W = r(p75)
scalar  p90_killed_pop2W = r(p90)
scalar  p99_killed_pop2W = r(p99)

local  p75_killed_pop2W =  p75_killed_pop2W
local  p90_killed_pop2W =  p90_killed_pop2W
local  p99_killed_pop2W =  p99_killed_pop2W

gen largeDisaster_killedW   = (killed_pop2   > p`tail'_killed_pop2W   )*(  killed_pop2!=. & disaster==1)*(year<2000)

* Save the Large disaster List
keep if largeDisaster_killedW   ==1

save large_disastersP`tail'.dta, replace

clear

log close
}
