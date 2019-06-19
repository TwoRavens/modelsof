
*********************************************DATA SETUP *********************************
***This do file creates our main panel dataset 

clear
set mem 1g
*set matsize 11000
*set maxvar 11000



use countylist.dta

expand 96
 
sort countyreal
generate firstob=1 if countyreal!= countyreal[_n-1]
gen time=1 if firstob
replace time=time[_n-1]+1 if firstob!=1

gen year = 1984 + floor((time-1)/4)
gen quarter = mod(time-1,4)+1 

sort year quarter countyreal 

merge year quarter countyreal using QCEW_industrydata.dta

**dropping records for counties that are not part of a county_pair within selected MSAs.
drop if _merge==2
drop _merge
 
rename time period

*drop if year<1990

egen state_fips_all = max(state_fips), by(countyreal)
replace state_fips = state_fips_all
drop state_fips_all


**recoding san francisco state code.
 

sort state_fips year quarter

merge state_fips year quarter using MW_yr_qtr_84_07.dta

drop _merge

**** fix SF minwage ***

gen CA = (state_fips==6)
egen CAminwage = max(minwage*CA)  , by(year quarter)

replace minwage = CAminwage if countyreal==6075

replace minwage = 8.50 if countyreal==6075 & year==2004
replace minwage = 8.62 if countyreal==6075 & year==2005
replace minwage = 8.82 if countyreal==6075 & year==2006
replace minwage = 9.15 if countyreal==6075 & year==2007

***


gen lnpop = ln(pop)

gen lnMW = ln(minwage)

rename st_mw stminwage
rename fed_mw federalmin

 
saveold QCEWindustry_minwage_all.dta, replace



*******This sets up the contiguous counties main panel dataset***********

clear
drop _all
set more off

insheet using "county-pair-list.txt", comma
rename county countyreal
rename countypair_id pair_id


expand 96
egen pair_id_county = group(pair_id countyreal)
sort pair_id_county
generate firstob=1 if pair_id_county!= pair_id_county[_n-1]
gen time=1 if firstob
replace time=time[_n-1]+1 if firstob!=1

gen year = 1984 + floor((time-1)/4)
gen quarter = mod(time-1,4)+1 

sort year quarter countyreal 

merge year quarter countyreal using QCEW_industrydata.dta

**dropping records for counties that are not part of a county_pair within selected MSAs.
drop if _merge==2
drop _merge
 
rename time period

* drop if year<1990

egen state_fips_all = max(state_fips), by(countyreal)
replace state_fips = state_fips_all
drop state_fips_all


**recoding san francisco state code.
replace state_fips=99 if countyreal==6075

*yellowstone ...
replace state_fips = 30 if countyreal==30113


sort state_fips year quarter

merge state_fips year quarter using MW_yr_qtr_84_07.dta

drop _merge

**** fix SF minwage ***

gen CA = (state_fips==6)
egen CAminwage = max(minwage*CA)  , by(year quarter)

replace minwage = CAminwage if state_fips==99

replace minwage = 8.50 if state_fips==99 & year==2004
replace minwage = 8.62 if state_fips==99 & year==2005
replace minwage = 8.82 if state_fips==99 & year==2006
replace minwage = 9.15 if state_fips==99 & year==2007


*****************
gen lnMW = ln(minwage)

rename st_mw stminwage
rename fed_mw federalmin

*****************
 
gen all=1
gen event = (event_type<3)




egen pair_id_period = group(pair_id period)

********

 
 

egen nonmissing_both_pair = min(nonmissing_rest_both), by(pair_id)
egen lnMW_min_pairperiod = min(lnMW) , by(pair_id_period)
egen lnMW_max_pairperiod = max(lnMW) , by(pair_id_period)
gen lnMW_dif_period = (lnMW_min_pairperiod != lnMW_max_pairperiod) & ( period>=25 & period<=90)
egen lnMW_dif = max(lnMW_dif_period), by(pair_id)

 
gen lnMW_gap_pair = lnMW_max_pairperiod - lnMW_min_pairperiod

gen lnpop =ln(pop)

saveold QCEWindustry_minwage_contig.dta, replace
