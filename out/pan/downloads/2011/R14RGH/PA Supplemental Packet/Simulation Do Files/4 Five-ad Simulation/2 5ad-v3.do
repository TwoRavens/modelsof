clear all
set mem 7g
set more off
set seed 1111111
set mat 800

*cd "C:\Users\poastpd\Desktop\"
*cd "C:\Users\Paul\Desktop\DISSERTATION MAIN FOLDER\Paper 3 - MisUse of Dyadic Data (materials)\Methods Paper Simulations\"

use "k-ads.dta", clear
gen id = _n
save "k-ads id.dta", replace

use "k-ads id.dta", clear
keep if id>= 1 & id<=500000
cross using "countries.dta"
rename ccode mem5
drop if mem1>=mem5
drop if mem2>=mem5
drop if mem3>=mem5
drop if mem4>=mem5
compress
save "storage_fivead1.dta", replace

use "k-ads id.dta", clear
keep if id>= 500001 & id<=1000000
cross using "countries.dta"
rename ccode mem5
drop if mem1>=mem5
drop if mem2>=mem5
drop if mem3>=mem5
drop if mem4>=mem5
compress
save "storage_fivead2.dta", replace

use "k-ads id.dta", clear
keep if id>= 1000001 & id<=1500000
cross using "countries.dta"
rename ccode mem5
drop if mem1>=mem5
drop if mem2>=mem5
drop if mem3>=mem5
drop if mem4>=mem5
compress
save "storage_fivead3.dta", replace

use "k-ads id.dta", clear
keep if id>= 1500001 & id<=2000000
cross using "countries.dta"
rename ccode mem5
drop if mem1>=mem5
drop if mem2>=mem5
drop if mem3>=mem5
drop if mem4>=mem5
compress
save "storage_fivead4.dta", replace

use "k-ads id.dta", clear
keep if id>= 2000001 & id<=2500000
cross using "countries.dta"
rename ccode mem5
drop if mem1>=mem5
drop if mem2>=mem5
drop if mem3>=mem5
drop if mem4>=mem5
compress
save "storage_fivead5.dta", replace

use "k-ads id.dta", clear
keep if id>= 2500001 & id<=3000000
cross using "countries.dta"
rename ccode mem5
drop if mem1>=mem5
drop if mem2>=mem5
drop if mem3>=mem5
drop if mem4>=mem5
compress
save "storage_fivead6.dta", replace

use "k-ads id.dta", clear
keep if id>= 3000001 & id<=3500000
cross using "countries.dta"
rename ccode mem5
drop if mem1>=mem5
drop if mem2>=mem5
drop if mem3>=mem5
drop if mem4>=mem5
compress
save "storage_fivead7.dta", replace

use "k-ads id.dta", clear
keep if id>= 3500001 & id<=4000000
cross using "countries.dta"
rename ccode mem5
drop if mem1>=mem5
drop if mem2>=mem5
drop if mem3>=mem5
drop if mem4>=mem5
compress
save "storage_fivead8.dta", replace

use "k-ads id.dta", clear
keep if id>=4000001 & id<=4500000
cross using "countries.dta"
rename ccode mem5
drop if mem1>=mem5
drop if mem2>=mem5
drop if mem3>=mem5
drop if mem4>=mem5
compress
save "storage_fivead9.dta", replace
