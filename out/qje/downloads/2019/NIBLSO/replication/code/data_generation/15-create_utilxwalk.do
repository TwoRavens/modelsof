/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Create average prior RVUs based on CPT code changes in utilization crosswalk

INPUTS:
- mu_w_spec.dta
- util_xwalks/`year'.dta
- workrvuhistory.dta

OUTPUTS:
- utilxwalk.dta
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

*** Prepare Medicare utilization file ****************************************************
use "data/intermediate/mu_w_spec", clear
tempfile mu_subset
keep if year>=2010&year<=2014
by year cpt_code, sort: egen totfreq=total(freq)
keep year cpt_code totfreq
duplicates drop
save `mu_subset', replace

*** Append utilization crosswalks ********************************************************
tempfile appended
qui foreach year of numlist 2011/2015 {
	noi disp as text "Year: `year'"
	use "data/raw/util_xwalks/`year'", clear
	keep CPT_Source New__Revised_Code Percent
	rename CPT_Source cpt_code
	rename New__Revised_Code new_cpt_code
	rename Percent percent
	drop if new_cpt_code=="Savings"|new_cpt_code=="savings"
	gen year=`year'-1
	merge m:1 cpt_code year using "data/raw/workrvuhistory", keep(match) nogen
	if `year'==2015 replace year=2013
	merge m:1 cpt_code year using `mu_subset', keep(match) nogen
	if `year'==2015 replace year=2014
	gen volume=percent*totfreq
	by new_cpt_code, sort: egen totvolume=total(volume)
	by new_cpt_code: egen prervu=total(rvu_value*volume/totvolume)
	keep new_cpt_code prervu year
	duplicates drop
	rename new_cpt_code cpt_code
	if `year'>2011 append using `appended'
	save `appended', replace
}
save data/intermediate/utilxwalk, replace
