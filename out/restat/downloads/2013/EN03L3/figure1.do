*This file creates Figure 1

use "$data/hhindiv04_labor.dta", clear
drop if result==.
keep if race==1
keep if agedisc>=4 & agedisc<=17
bysort agedisc: egen min=min(age)
bysort agedisc: egen max=max(age)
gen agecat=(min+max)*0.5
collapse (mean) result agecat,   by(agedisc female)
lab var result "HIV prevalence"
lab var agecat "Age group"
set scheme s1mono
line result agecat if female==0, legend(lab(1 "Male") lab(2 "Female")) ylabel(0(0.05)0.4) ymtick(0(0.05)0.4) xlabel(15(5)85) xmtick(15(5)85) || line result agecat if female==1, lpattern(dash)
graph export "$output/figure1.pdf", replace as(pdf)

exit
