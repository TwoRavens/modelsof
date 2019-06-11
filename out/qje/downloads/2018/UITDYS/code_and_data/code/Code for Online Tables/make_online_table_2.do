*================================================================================
* File: make_online_table_2.do
* Purpose: Makes online data table 2 for the patents paper
* Author: MD and CG, September-October 2017
*================================================================================

*--------------------------------------------------------------------------------
* 0. Housekeeping
*--------------------------------------------------------------------------------
set more off
clear all
set rmsg on
global data_dir /home/stataharvard/patents/draft2016/data
global int_data /home/stataharvard/patents/draft2016/make_online_tables/intermediate_data 
global output   /home/stataharvard/patents/draft2016/make_online_tables/output

adopath + /home/stataharvard/ado

*--------------------------------------------------------------------------------
* 1. Prepare data for patents online data table 2
*--------------------------------------------------------------------------------
* Load patents data from event_20_v1 microdata
use "${data_dir}/event_20_v1", clear
gen cohort = tax_yr-age

* Turn gender indicator to lower-case for consistency with above
replace gnd_ind="m" if gnd_ind=="M"
replace gnd_ind="f" if gnd_ind=="F"

* Merge on CZ from zip-CZ crosswalk
// AB changing on Nov 21 to use zip5irtf rather than "zipcode" variable -- this will be more comparable to what we use from databank for denominator
destring zip5irtf, force gen(zip)
merge m:1 zip using "${data_dir}/zip_cz_crosswalk", keepusing(cz1) keep(1 3) nogen
rename cz1 cz

* Define indicator for whether granted a patent
replace patents = 0 if patents==.
gen granted 	= (patents>0)
gen inventor 	= applied_in_year>0

* Make within-age-year ranks for fcit_adj and fcit for inventors (inventor==1)
preserve
	keep if patents > 0 
	keep tin tax_yr cohort fcit fcit_adj
	foreach v of varlist fcit fcit_adj {
		egen rank_`v' = rank(`v'), by(cohort)
		forvalues i = 1896/1984 {
			qui sum rank_`v' if cohort==`i'
			if "`r(max)'"!="" {
				qui replace rank_`v' = rank_`v' / `r(max)' if cohort==`i'
			}
		}
	}
	keep tin tax_yr rank*
	isid tin tax_yr
	tempfile inventor_ranks
	save `inventor_ranks'
restore

merge 1:1 tin tax_yr using `inventor_ranks', keepusing(rank_*) keep(1 3) nogen
gen top5cit 	 = 1 if (rank_fcit > 0.95 		& ~mi(rank_fcit))
replace top5cit  = 0 if (rank_fcit <= 0.95 		& ~mi(rank_fcit))
gen top5cita 	 = 1 if (rank_fcit_adj > 0.95 	& ~mi(rank_fcit_adj))
replace top5cita = 0 if (rank_fcit_adj <= 0.95 	& ~mi(rank_fcit_adj))

* Save prepped microdata for table 2
save "${int_data}/table2_input", replace

*--------------------------------------------------------------------------------
* 2. Retrieve counts from 10% sample taxpayers from Databank
*--------------------------------------------------------------------------------
/*
* Load 10% sample data, only keeping ages 20-80
use tin tax_yr cohort irtf_zip5 gnd_ind if (tax_yr-cohort)>=20 & (tax_yr-cohort)<=80 using "/home/stataharvard/patents/draft2016/db_pull", clear
rename cohort yob
gen age = tax_yr - yob
replace gnd_ind="m" if gnd_ind=="M"
replace gnd_ind="f" if gnd_ind=="F"

* Merge ZIP -> CZ and state
rename irtf_zip5 zip
destring zip, replace
save ${data_dir}/temp.dta, replace
*/
/*
use ${data_dir}/temp.dta, clear
merge m:1 zip using "${data_dir}/zip_cz_crosswalk", keepusing(cz1 state) nogen
rename cz1 cz

* Get some taxpayer counts for both CZ and state geographies
foreach geo in cz state {

	* Get counts of taxpayers within each age-cohort-geo bin
	preserve
		gcollapse (count) `geo'_count = tin, by(age yob `geo')
		* Scale up from the 10% sample (to estimate counts)
		replace `geo'_count = `geo'_count*10
		tempfile `geo'_count
		save ``geo'_count', replace
		save `geo'_count, replace
	restore
	
	* Get counts of taxpayers within each age-cohort-geo-gender bin
	foreach gnd in m f {
		preserve
			keep if gnd_ind == "`gnd'"
			gcollapse (count) `geo'_count_g_`gnd'=tin, by(age yob `geo')
			
			* Scale up from the 10% sample (to estimate counts)
			replace `geo'_count_g_`gnd' = `geo'_count_g_`gnd'*10
			tempfile `geo'_count_g_`gnd'
			save ``geo'_count_g_`gnd'', replace
			save `geo'_count_g_`gnd', replace
		restore
	}
	
}
*/
*--------------------------------------------------------------------------------
* 3. Count share of taxpayers granted a patent in each age-yob-geo cell
*--------------------------------------------------------------------------------

// AB inserting block here
* reshape Inventor-Patent File to be at the Inventor-Year Level, so it can be merged with table2_input
use "${data_dir}/draft2016_v1_inv_precollapse", clear
// keep only patents to avoid double-counting
keep if ~missing(pat_inv_id)
keep tin appyear cat
gen inventor = 1
drop if missing(cat)
// only 3,000 obs have missing categories; probably b/c USPTO classes don't 100% map to NBER categorization -- this is okay
duplicates drop
reshape wide inventor, i(tin appyear) j(cat)
ren appyear tax_yr
tempfile catlevel
save `catlevel'

use "${data_dir}/draft2016_v1_inv_precollapse", clear
keep if ~missing(app_inv_id)
ren appyear tax_yr
keep tin tax_yr
duplicates drop
gen applicant = 1
tempfile applicant
save `applicant'


// now start from "table 2 input" file and merge on category-specific info at TIN-YEAR level
use "${int_data}/table2_input", clear
merge 1:1 tin tax_yr using `applicant', keep(match master) nogen
replace applicant = 0 if applicant!=1
merge 1:1 tin tax_yr using `catlevel'
tab tax_yr if _m==2
// most of the unmatched patents are from years outside of 1996-2012, which we won't have cz for
// we need to drop that; we won't have geo info for those years
drop if _m==2
// we now have the same number of obs as table2_input

// any years not flagged as inventor in a category are set to 0
foreach var of varlist inventor1-inventor7 {
replace `var'=0 if missing(`var')
}

foreach var of varlist inventor applicant granted patents top5cit top5cita {
gen `var'm=`var' * (gnd_ind=="m")
gen `var'f=`var' * (gnd_ind=="f")
}

* Get some taxpayer counts for both CZ and state geographies
foreach geo in cz state {
	preserve
	* Counts by age-yob-geo
		gcollapse ///
			(sum) 	count_inventor=inventor ///
					count_applicant=applicant ///
				    count_granted=granted ///
					count_patents=patents ///
					count_top5cit=top5cit ///
					count_top5cita=top5cita ///
					count_cat_1 = inventor1 ///
					count_cat_2 = inventor2 ///
					count_cat_3 = inventor3 ///
					count_cat_4 = inventor4 ///
					count_cat_5 = inventor5 ///
					count_cat_6 = inventor6 ///
					count_cat_7 = inventor7 ///
					count_inventor_g_m=inventorm ///
					count_applicant_g_m=applicantm ///
					count_granted_g_m=grantedm ///
					count_patents_g_m=patentsm ///
					count_top5cit_g_m=top5citm ///
					count_top5cita_g_m=top5citam ///
					count_inventor_g_f=inventorf ///
					count_applicant_g_f=applicantf ///
					count_granted_g_f=grantedf ///
					count_patents_g_f=patentsf ///
					count_top5cit_g_f=top5citf ///
					count_top5cita_g_f=top5citaf ///
			, by(age yob `geo')
		tempfile p_`geo'_count
		save `p_`geo'_count', replace
		save p_`geo'_count, replace
	restore
}

*--------------------------------------------------------------------------------
* 4. Count share of inventors in each category within each age-yob-geo cell
*--------------------------------------------------------------------------------
// AB Deprecating this block

*--------------------------------------------------------------------------------
* 5. Merge together all counts (and make shares) 
*--------------------------------------------------------------------------------

foreach geo in cz state {

	use `geo'_count, clear
	
	* Merge on gender counts
	foreach gnd in m f {
		merge 1:1 age yob `geo' using `geo'_count_g_`gnd', keep(1 3) nogen
	}
	
	* Merge on patent count statistics
	merge 1:1 age yob `geo' using p_`geo'_count, keep(1 3) nogen
	
	// AB removing merges to category and gender level patent count files
	
	* Generate shares for patent statistics
	local patent_stats inventor applicant granted patents top5cit top5cita cat_1 cat_2 cat_3 cat_4 cat_5 cat_6 cat_7
	
	* Make sure missings are coded as 0 to distinguish from masked obs
	foreach j of local patent_stats {
		replace count_`j' = 0 if mi(count_`j')
	}
	
	* Generate shares for patent statistics
	foreach j of local patent_stats {
		gen share_`j' = count_`j' /`geo'_count
	}
	
	* Shares for patent statistics by gender
	foreach gnd in m f {
		foreach j in inventor_g_`gnd' applicant_g_`gnd' granted_g_`gnd' patents_g_`gnd' top5cit_g_`gnd' top5cita_g_`gnd' {
			replace count_`j' = 0 if mi(count_`j')
			// AB adding below since we did it for non-gender but still need to do it for the by-gender
			gen share_`j' = count_`j'/`geo'_count_g_`gnd'
		}
	}

	* Drop all patent count statistics 
	drop count*

*--------------------------------------------------------------------------------
* 6. Mask and Save
*--------------------------------------------------------------------------------

	* Mask pooled output (not by gender)
	* Masking threshold 100 not 10 since we get counts with a 10% Databank sample 
	ds yob age `geo' `geo'_count *_m *_f, not
	foreach var in `r(varlist)' {
		replace `var'=. if `geo'_count<100
	}
	replace `geo'_count=. if `geo'_count<100
	
	* Mask output for each gender
	foreach gnd in m f {
		ds share_inventor_g_`gnd' share_applicant_g_`gnd' share_granted_g_`gnd'  share_patents_g_`gnd' share_top5cit_g_`gnd' share_top5cita_g_`gnd'
		foreach var in `r(varlist)' {
			replace `var'=. if `geo'_count_g_`gnd'<100
		}
		replace `geo'_count_g_`gnd'=. if `geo'_count_g_`gnd'<100
	}

	* Rename count
	rename `geo'_count count
	
	* Save table
	if "`geo'"=="cz" {
		save "${output}/table_2a", replace
	}
	if "`geo'"=="state" {
		save "${output}/table_2b", replace
	}
	
}


