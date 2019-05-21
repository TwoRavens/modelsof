* Date: March 8, 2013
* Apply to: district_pop_1860_1910.dta, county_population_1912_1962.dta
* Description: This set of commands imports data on district population
* compiled by Erik Engstrom for the 1860 to 1962 period, extracts 
* measures of district population and creates a state-year-district identifier.

clear

set more off


* Prepare district population files for merge

use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\District Population\district_pop_1860_1910.dta", clear


replace congress = 38 if congress==.


gen double sdc_id = (state * 10000) + (district * 100) + congress

sort sdc_id

duplicates drop


keep sdc_id population

sort sdc_id


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\District Population\dis_pop_1_mrg.dta", replace


clear

use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\District Population\county_population_1912_1962.dta", clear


drop if district==.
drop if year>=942


gen double sdc_id = (state * 10000) + (district * 100) + congress

sort sdc_id

gen lag_sdc_id = sdc_id[_n-1]

gen dif_sdc_id = sdc_id - lag_sdc_id

drop if state==1 & congress==73 & district==5 & dif_sdc_id==0
drop if state==13 & congress==63 & district < 11 & dif_sdc_id!=0
drop if state==73 & congress==73 & district==2 & dif_sdc_id!=0


* Create observations for between census years

drop lag_sdc_id dif_sdc_id

expand = 5, gen(dup_year)

sort sdc_id dup_year

generate congress_old = congress

replace congress = . if dup_year==1

by sdc_id: replace congress = congress[_n-1] + 1 if congress==.

drop sdc_id

gen double sdc_id = (state * 10000) + (district * 100) + congress


rename district_pop population

keep sdc_id population

sort sdc_id


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\District Population\dis_pop_2_mrg.dta", replace

* End
