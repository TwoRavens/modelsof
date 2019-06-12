clear all
set mem 7g
set more off
set seed 1111111
set mat 800

*cd "C:\Users\poastpd\Desktop\"
*cd "C:\Users\Paul\Desktop\DISSERTATION MAIN FOLDER\Paper 3 - MisUse of Dyadic Data (materials)\Methods Paper Simulations\"


use "storage_fivead1.dta", clear
append using "storage_fivead2.dta"
append using "storage_fivead3.dta"
append using "storage_fivead4.dta"
append using "storage_fivead5.dta"
append using "storage_fivead6.dta"
append using "storage_fivead7.dta"
append using "storage_fivead8.dta"
append using "storage_fivead9.dta"
append using "storage_fourad.dta"
append using "storage_threead.dta"
append using "storage_twoad.dta"

save "Complete Kad dataset.dta", replace
saveold "Complete_Kad_dataset.dta", replace

* Obs should = 79,375,395
sum mem1
* Obs should = 75,287,520
sum mem1 if mem5~=.
* Obs should = 3,921,225
sum mem1 if mem5==. & mem4~=.
* Obs should = 161,700
sum mem1 if mem4==. & mem5==. & mem3~=.
* Obs should = 4,950
sum mem1 if mem3==. & mem4==. & mem5==. & mem2~=.
* Obs should = 0
sum if mem1==.

