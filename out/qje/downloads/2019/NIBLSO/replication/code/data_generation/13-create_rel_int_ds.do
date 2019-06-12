/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Create dataset of related interests

INPUTS:
- specialty_specid_xwalk
- serv_aff_out_freq.csv
- serv_aff_out_rev.csv

OUTPUTS:
- rel_int.dta
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado
	
*** Create dataset ***********************************************************************
gen_working_data
merge 1:1 obs_id using data/intermediate/aff_ds_1, assert(match master) keep(match) nogen

qui foreach type in freq rev {
	preserve
	tempfile master
	save `master'
	gen_ruc_memspec_old, source(2) //*//
	joinby ruc_yr mtg_num using `master', unmatched(both)
	assert _merge==3|_merge==1
	keep if _merge==3
	drop _merge
	rename member_specialty specialty
	merge m:1 specialty using "data/crosswalks/specialty_specid_xwalk", keep(match) ///
		assert(match using) nogen
	drop specialty
	save `master', replace

	import delimited using "data/intermediate/serv_aff_out_`type'.csv", clear
	tostring cpt_code, replace
	merge 1:m specid cpt_code using `master', keep(match using) nogen
	gsort obs_id member_id -aff_`type'_shr_corr
	by obs_id member_id: drop if _n>1
	by obs_id: egen has_missing=max(missing(aff_`type'_shr_corr))
	by obs_id: egen has_present=max(!missing(aff_`type'_shr_corr))
	assert !(has_missing&has_present)
	assert has_missing|has_present
		// These codes with has_missing are largely those introduced in 2013 and later 
		// (Medicare data we use ends in 2013; codes introduced in 2013 have only 
		// one year so cannot calculate covariances for those codes)

	rename aff_`type'_shr_corr `type'_int
	drop specid sigma
	collapse_by_ruc_member, measures(`type'_int) moments(mean median 33tile)
	qui foreach var of varlist `type'_int_* {
		sum `var'
		gen n`var'=(`var'-r(mean))/r(sd)
		gen byte m_n`var'=missing(n`var')
		gen byte a_n`var'=cond(missing(n`var'),0,n`var')
	}
	keep obs_id n`type'_int_* a_n`type'_int_* m_n`type'_int_* 
	if "`type'"=="rev" {
		merge 1:1 obs_id using data/intermediate/rel_interest, ///
			assert(match) nogen
	}
	save data/intermediate/rel_interest, replace
	restore
}
