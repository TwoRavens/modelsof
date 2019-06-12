* Analysis_TRI_CBP_compare.do
* Compares TRI establishment counts to CBP

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/Analysis_TRI_CBP_compare.log", replace
set matsize 11000

*******************************
* CBP-TRI comparison
* 1998 onward based on NAICS
*******************************

* Reading TRI data
use "`work'/Data/TRI/Processed/TRI.dta", clear

* Constructing consistent SIC and NAICS codes
* This code fragment adapted from "TRI_county_merge.do"
encode trifacilityid, gen(facility_id)
bysort facility_id: egen sic = mode(primarysic), minmode
bysort facility_id: egen naics = mode(primarynaics), minmode

* Other variable handling
destring fips_state, generate(fipstate)
drop fips_state
destring fips_cnty, generate(fipscty)
drop fips_cnty

* Subset to 1998-onward
keep if year>=1998

* Records are at facility-pollutant-year level; keeping only 1 record per facility-year
keep facility_id year naics sic fipstate fipscty
duplicates drop

* Collapsing to year-sector level
gen TRIest = 1
collapse (sum) TRIest, by(year naics fipstate fipscty)

* Merging CBP data
merge 1:1 year naics fipstate fipscty using "`work'/Data/CBP/Processed/CBP_naics.dta"

* Limit to NAICS codes covered in TRI
gen TRIrecord = (_merge==1 | _merge==3)
bysort year naics: egen coverednaics = max(TRIrecord)
tab _merge coverednaics
* This method incorrectly includes some uncovered NAICS codes because of NAICS misreporting in TRI 
* Excluding Auto repair (811111), Wholesale trade agents (425120), supermarkets (445110), corporate offices (551114)
* Other nondurable wholesalers (424990), engineering services (541330)
replace coverednaics=0 if naics==811111 | naics==425120 | naics==445110 | naics==551114 | naics==424990 | naics==541330
* NAICS with <100 establishments in TRI are all mistakes
bysort naics: egen totTRIest = sum(TRIest)
replace coverednaics=0 if totTRIest<100
keep if coverednaics==1
replace est = 0 if missing(est)
replace TRIest = 0 if missing(TRIest)

* Evaluating coverage differences
gen diff = TRIest - est
summarize diff, detail
bysort year: summarize diff

* Collapse to NAICS-year level
collapse (sum) TRIest est, by(year naics)

* Evaluating coverage differences
gen coverage_rate = TRIest/est

* Coverage rates in top ten NAICS
foreach x in 221112 325188 212231 212234 212221 331111 325199 322121 562211 324110 {
	summarize coverage_rate if naics==`x'
}






timer off 1
timer list 1
capture log close

