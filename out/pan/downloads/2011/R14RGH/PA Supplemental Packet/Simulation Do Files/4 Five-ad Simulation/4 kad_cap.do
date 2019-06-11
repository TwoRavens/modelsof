clear all
set mem 7g
set more off
set seed 1111111
set mat 800

*cd "C:\Users\poastpd\Desktop\"
*cd "C:\Users\Paul\Desktop\DISSERTATION MAIN FOLDER\Paper 3 - MisUse of Dyadic Data (materials)\Methods Paper Simulations\"


** Add Capabilities
local i 1
while `i' <=(5) {
use "practice.dta", clear
rename ccode mem`i'
sort mem`i'
save "practice2.dta", replace
use "Complete Kad dataset.dta", clear
sort mem`i'
merge mem`i' using "practice2.dta", nokeep keep(cap)
rename cap cap`i'
replace cap`i'=0 if cap`i'==.
drop _merge
save "Complete Kad dataset.dta", replace
local i = `i' + 1 
}


use "Complete Kad dataset.dta", clear
** Compute Capabilities Ratio
gen cap_max = max(cap1, cap2, cap3, cap4, cap5)
gen cap_sum = cap1 + cap2 + cap3 + cap4 + cap5
gen cap_ratio = cap_max/cap_sum

drop cap1 cap2 cap3 cap4 cap5

save "Complete Kad dataset.dta", replace
saveold "Complete_Kad_dataset.dta", replace

* check to make sure still have same number of observations
sum mem1
