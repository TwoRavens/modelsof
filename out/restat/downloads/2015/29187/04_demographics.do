
set more off
clear all
set mem 500m

log using "C:\output\logs\demographics_log", replace

use c:\research\denver\temp\prices.dta

* determine number of household heads
gen num_heads=2
replace num_heads=1 if mhage==0 | fhage==0
egen num_heads_max=max(num_heads), by(panid)
tabulate num_heads_max

* determine household size
egen hhsize_max=max(hhsize), by(panid)
tabulate hhsize_max
gen hhsize_code=0
replace hhsize_code=1 if hhsize_max<3 
replace hhsize_code=2 if hhsize_max>=3 & hhsize_max<=4
replace hhsize_code=3 if hhsize_max>4
tabulate hhsize_code

* determine household age group
gen hhage=0
replace hhage=max(mhage,fhage) if mhage==0 | fhage==0  
replace hhage=(mhage+fhage)/2 if mhage>0 & fhage>0
egen hhage_max=max(hhage), by(panid)
tabulate hhage_max
gen hhage_code=0
replace hhage_code=1 if hhage_max<4
replace hhage_code=2 if hhage_max>=4 & hhage_max<9
replace hhage_code=3 if hhage_max>=9
tabulate hhage_code

* determine household income category
egen income_max=max(income), by(panid)
tabulate income_max
gen income_code=0
replace income_code=1 if income_max<13
replace income_code=2 if income_max>=13 & income_max<18
replace income_code=3 if income_max>=18
tabulate income_code

* determine household head(s) education level
gen hhed=0
replace hhed=max(mhed,fhed) if mhed==0 | fhed==0  
replace hhed=(mhed+fhed)/2 if mhed>0 & fhed>0 
egen hhed_max=max(hhed), by(panid)
tabulate hhed_max
gen hhed_code=0
replace hhed_code=1 if hhed_max<3
replace hhed_code=2 if hhed_max>=3 & hhed_max<5
replace hhed_code=3 if hhed_max>=5
tabulate hhed_code

save c:\research\denver\temp\demographics.dta, replace

clear all
use c:\research\denver\temp\demographics.dta

* go down to the household level
collapse num_heads_max hhsize_code hhage_code income_code hhed_code, by(panid)

sort panid
save c:\research\denver\temp\demographics_only.dta, replace

log close

clear all
set more on

