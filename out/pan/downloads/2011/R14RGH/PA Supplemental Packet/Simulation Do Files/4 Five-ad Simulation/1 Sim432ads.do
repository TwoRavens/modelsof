clear all
set mem 1g
set more off
set seed 1111111
set mat 800

*cd "C:\Users\poastpd\Desktop\"
*cd "C:\Users\Paul\Desktop\DISSERTATION MAIN FOLDER\Paper 3 - MisUse of Dyadic Data (materials)\Methods Paper Simulations\"

/* STEP 1: Create Fictional International System */ 
/* STEP 1a: Specify number of countries */ 
local ob 100
set obs `ob'

/* STEP 1: Randomly Assign capabilities to each country */ 
*gen x = ibeta(4,1,uniform())
gen x = uniform()
sum x
gen ccode  = _n
gen cap = x*100
drop x
save "practice.dta", replace
keep ccode
drop if ccode>0
set obs 1
save "storage.dta", replace
save "storage_kad.dta", replace

use "practice.dta", clear
keep ccode
save "countries.dta", replace

** Create 4-ad List
* Member 1
use "countries.dta", clear
* Add Member 2
rename ccode mem1
cross using "countries.dta"
* Add Member 3
rename ccode mem2
drop if mem1>=mem2
cross using "countries.dta"
* Add Member 4
rename ccode mem3
drop if mem1>=mem3
drop if mem2>=mem3
cross using "countries.dta"
rename ccode mem4
drop if mem1>=mem4
drop if mem2>=mem4
drop if mem3>=mem4
save "storage_fourad.dta", replace

** Create 3-ad List
* Member 1
use "countries.dta", clear
* Add Member 2
rename ccode mem1
cross using "countries.dta"
* Add Member 3
rename ccode mem2
drop if mem1>=mem2
cross using "countries.dta"
rename ccode mem3
drop if mem1>=mem3
drop if mem2>=mem3
save "storage_threead.dta", replace

** Create 2-ad List
* Member 1
use "countries.dta", clear
* Add Member 2
rename ccode mem1
cross using "countries.dta"
rename ccode mem2
drop if mem1>=mem2
save "storage_twoad.dta", replace

use "storage_fivead.dta", clear
append using "storage_fourad.dta"
append using "storage_threead.dta"
append using "storage_twoad.dta"

drop ccode
drop if mem1==.
compress

save "k-ads.dta", replace