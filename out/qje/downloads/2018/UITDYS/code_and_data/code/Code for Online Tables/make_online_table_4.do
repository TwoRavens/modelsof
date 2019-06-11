*================================================================================
* File: make_online_table_4.do
* Purpose: Makes online data table 4 for the patents paper
* Author: MD and CG, September-October 2017
*================================================================================

*--------------------------------------------------------------------------------
* 0. Housekeeping
*--------------------------------------------------------------------------------

clear all
set rmsg on
global data_dir /home/stataharvard/patents/draft2016/data
global int_data /home/stataharvard/patents/draft2016/make_online_tables/intermediate_data 
global output   /home/stataharvard/patents/draft2016/make_online_tables/output
adopath + /home/stataharvard/finer_geo/ado

*--------------------------------------------------------------------------------
* 1. Prepare data for patents online data table 4
*--------------------------------------------------------------------------------
/*
* Prelim: define lifetime_patents and lifetime_cites for all inventors
use tin lifetime_patents lifetime_cites using "${data_dir}/draft2016_v1_inv_precollapse", clear
duplicates drop
tempfile t1
save `t1'

* Begin with table 1 prepped data
use kid_tin par_rank_n inventor top5cit top5cita using "${int_data}/table1_input", clear

* Merge on school and cohort from finer geos basefile
merge 1:1 kid_tin using "/home/stataharvard/finer_geo/data/fg_v7_base.dta", keepusing(super_opeid_22 cohort) keep(1 3) nogen
keep if cohort>=1980 & cohort<=1984
rename (super_opeid_22 kid_tin) (super_opeid tin)

* Merge on lifetime_patents and lifetime_cites
merge 1:1 tin using `t1', nogen keep(1 3)
replace lifetime_patents=0 if lifetime_patents==.
replace lifetime_cites=0 if lifetime_cites==.

* Generate parent quintile and quintile-specific inventor indicators (missing outside given quintile)
gen par_q = ceil(par_rank_n*5)
forval i=1/5 {
	gen inventor_q`i' = inventor if par_q==`i'
	gen kid_q`i' = tin if par_q==`i'
}

* Save prepped microdata for table 4
save "${int_data}/table4_input", replace
*/
*--------------------------------------------------------------------------------
* 2. Collapse to college-level and prepare that data
*--------------------------------------------------------------------------------

use * if super_opeid>0 using "${int_data}/table4_input", clear
collapse (count) count=tin kid_q* ///
		 (sum) inventor* lifetime_patents lifetime_cites top5cit top5cita ///
	, by(super_opeid)
rename kid_q* count_par_q*

* Restrict to schools with at least 10 inventors and save
keep if inventor>=10

* Generate share outcomes
gen share_inventor = inventor / count
forval i=1/5 {
	gen share_inventor_q`i' = inventor_q`i' / count_par_q`i'
}
gen share_top5cit  = top5cit/count
gen share_top5cita = top5cita/count

* Merge on college characteristics and format them
merge 1:1 super_opeid using "${int_data}/college_covariates_grouped.dta", keep(3) nogen
drop group_id group_name group_size opeid college_tier instnm opeid usn_bin enrollment exact_match
rename mn_earn_wne_* mnew_*
rename notfirstgen_rpy_3yr_rt_supp not1stgen_rpy_3y_rt_supp
qui sum super_opeid if ~mi(count)
local num_schools = r(N)

sum if ~mi(count) 

* Generate arbitrary grouping
sort super_opeid
gen group_id = mod(_n,15)+1
order group_id, after(super_opeid)
qui sum group_id
local num_groups = r(max)

* Generate a variable with group size
bysort group_id: gen gp_size = _N
egen group_size = max(gp_size), by(group_id)
drop gp_size
order group_size, after(group_id)

* Generate logarithmic and quadratic transformations of level covariates
qui foreach v of varlist female_share-act_avg_75 {
	gen lg_`v' = log(`v')
	gen sq_`v' = `v'^2
}

* Drop covariates with less than full coverage
di "num schools: `num_schools'"
foreach v of varlist female_share-sq_act_avg_75 {
	local n_before = `n_before' + 1
	qui sum `v' if ~mi(`v')
	local nonmiss = r(N)
	if `nonmiss' < `num_schools' drop `v'
}

*--------------------------------------------------------------------------------
* 2. Run forward search algorithm
*--------------------------------------------------------------------------------

* Store list of outcomes to run through forward search algorithm
local outcomes lifetime_patents lifetime_cites

* Loop over outcomes
qui foreach o in `outcomes' {
	noi di "Outcome: `o'"
	gen `o'_hat = .
	forval i=1/`num_groups' {
		noi di "  Group: `i'"
		* Get max regressors = group_size - 10
		qui sum group_size if group_id==`i'
		local df = r(mean) - 10
		* Run forward search within group
		qui fsearch `o' female_share-sq_not1stgen_rpy_3y_rt_supp if group_id==`i', fast predictors(`df')
		qui reg `o' `r(regressors)' if group_id==`i'
		qui predict temp_yhat if group_id==`i'
		qui replace `o'_hat = temp_yhat if group_id==`i'
		drop temp_yhat
	}
}

save "${output}/table_4_temp.dta", replace
*/

use "${output}/table_4_temp.dta", clear
keep super_opeid lifetime*
save "${output}/table_4.dta", replace
