** add demographics to death data to create analysis datasets

** get demogrpahics data sorted
use ..\processed_data\seer_pop_month.dta, clear
sort fips year month
save ..\processed_data\seer_pop_month.dta, replace
use ..\processed_data\urate_monthly.dta, clear
sort fips year month
save ..\processed_data\urate_monthly.dta, replace


use ..\processed_data\panel_dataset.dta, clear
** merge on demographics
sort fips year month
merge 1:1 fips year month using .\seer_pop_month.dta
** looks good
drop if _merge==2
drop _merge

** merge on unemployment rates as well
sort fips year month
merge 1:1 fips year month using .\urate_monthly.dta
** looks good
drop if _merge==2
drop _merge

**************************************************************
** now create panel analysis dataset
**************************************************************

preserve

rename any_heroin heroin_deaths
rename any_opioid opioid_deaths
rename h_or_o h_or_o_deaths

drop any_* *_nosynths 

save ..\processed_data\heroin_deaths_state_month.dta, replace

**************************************************************
** now create time-series analysis dataset
**************************************************************

** national population monthly numbers
use ..\processed_data\seer_pop_month.dta, clear
collapse (sum) population, by(year month)
sort year month
tempfile tspop
save `tspop'

use ..\processed_data\ts_dataset.dta, clear
sort year month
merge 1:1 year month using `tspop'
drop if _merge==2
drop _merge
save ..\processed_data\opioids_by_month.dta, replace



