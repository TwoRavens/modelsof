clear all
capture log close
set more off

insheet using ~/borja2/DATA/sources/wdi_labor.txt, names

rename country isocode
rename country_name country

/* destring variables. */
forval i = 1976(1)2000 {
gen d`i' = real(data`i')
}
drop data*

/* reshape data. */
reshape long d, i(cid sid) j(year)
drop ind1_desc
reshape wide d, i(cid year) j(sid)

/* rename series. */
rename d1 gdp_sh_agriculture
rename d2 empl_sh_agriculture
rename d3 empl_sh_industry
rename d4 empl_sh_services
rename d5 gdp_sh_industry
rename d6 gdp_sh_services

/* drop identifiers and order series. */
drop cid
order country isocode year gdp_sh_agriculture gdp_sh_industry gdp_sh_services empl_sh_agriculture empl_sh_industry empl_sh_services

save ~/borja2/DATA/wdi_labor.dta, replace

clear 

use ~/borja2/DATA/pn_penntable_10avg_jan2006.dta
contract isocode
drop _freq

joinby isocode using ~/borja2/DATA/wdi_labor.dta

sort country year
save ~/borja2/DATA/wdi_labor_89countries.dta, replace

/* Create datasets with 10yr average data. */

clear
use ~/borja2/DATA/wdi_labor_89countries.dta

sort country year

gen yr10 = 70 if year<=1980
replace yr10 = 80 if year>=1981 & year<=1990
replace yr10 = 90 if year>=1991 & year<=2000

label var yr10 "10-year Period"

sort isocode yr10

by isocode yr10: egen count_empl = count(empl_sh_agriculture)
drop if count_empl<3

by isocode yr10: egen emplsh_agriculture_10avg = mean(empl_sh_agriculture)
by isocode yr10: egen emplsh_industry_10avg = mean(empl_sh_industry)
by isocode yr10: egen emplsh_services_10avg = mean(empl_sh_services)

replace emplsh_agriculture_10avg = emplsh_agriculture_10avg/100
replace emplsh_industry_10avg = emplsh_industry_10avg/100
replace emplsh_services_10avg = emplsh_services_10avg/100


contract yr10 isocode country emplsh_agriculture_10avg emplsh_industry_10avg emplsh_services_10avg

joinby isocode yr10 using ~/borja2/DATA/pn_penntable_10avg_jan2006.dta, unmatched(using) update
drop _merge _freq
save ~/borja2/DATA/pn_penntable_10avg_apr2006.dta, replace

