* 2018-11-8

/* 

This do-file creates tables found in the main text of

  - Bell, A., Chetty, R., Jaravel, X., Petkova, N. & Van Reenen, J. (2018). 
		Who Becomes an Inventor in America? The Importance of Exposure to Innovation
		
*/

* Run patents_figs_metafile first!

* Log
cap log close
log using "${logs}/tables_main_text_log.log", replace

*** TABLES IN MAIN TEXT

/****************************************************************************
							Table 1: Summary Statistics
Notes: Samples are:
	-fullsample: all taxpayers linked to a patent application or grant over
		years 1996-2014
	-intergen: birth cohorts 1980-84
	-nyc: birth cohorts 1979-85
****************************************************************************/

local sumstat_data "${data}"

* Append all samples
use "`sumstat_data'/summstats_fullsample.dta", clear
gen sample = 1
tempfile full
save `full'

use "`sumstat_data'/summstats_intergen.dta", clear
keep if inventor ==1
gen sample = 2
tempfile ig_inv
save `ig_inv'

use "`sumstat_data'/summstats_intergen.dta", clear
keep if inventor ==0
gen sample = 3
tempfile ig_noninv
save `ig_noninv'

use "`sumstat_data'/summstats_nyc.dta", clear
keep if inventor ==1
gen sample = 4
tempfile nyc_inv
save `nyc_inv'

use "`sumstat_data'/summstats_nyc", clear
keep if inventor ==0
gen sample = 5
tempfile nyc_noninv
save `nyc_noninv'

use `full', clear
append using `ig_inv' `ig_noninv' `nyc_inv' `nyc_noninv'

* Reorder variables 
order *collab*, last
order n, last
order sample, first
order mean_asian, a(mean_white)

* Don't want to lose precision in n (will fix later)
replace n = n/1000

* Drop unused variables
foreach var in female coll20 white black asian hispanic{
	drop sd_`var' p50_`var'
}
drop inventor* p50_rpat_age p50_math* p50_verb* 



* Round income medians to nearest $1,000
foreach var in p50_w2_inc_trim p50_f1040_inc_trim p50_par_fam_inc p50_non_spouse_f1040_trim{
	replace `var' = round(`var', 1000)
}

* Export results in a csv.file
eststo clear
forvalues sample = 1/5{
	ds sample, not
	eststo: qui: estpost sum `r(varlist)' if sample == `sample', meanonly
}

esttab using "${tabs}/summary stats num collab.csv", cells(mean) nodep ///
	mti(Full IG-inventors IG-non-inventors NYC-inventors NYC-non-inventors) ///
	nonote nonum noobs unstack replace

/*******************************************************************************
Table 2: Fraction of Gap in Innovation by Parental Income Explained by 
Differences in 3rd Grade Test Scores
Notes: Based on entire NYC sample (birth cohorts 1979-85) with non-missing test
score. Children may potentially be observed at all grades.
*******************************************************************************/

local data_gap "${data}/p80"
eststo clear
* Compute raw and reweighted means and gaps
matrix gap_closed = J(6,1,.) // store fraction of gap closed at each grade
forvalues grade = 3/8 {
	use "`data_gap'`grade'", clear
	
	* Raw means and gap
	eststo: reg inv_1k1 [aw=n1] 			// using reg to store a new estimate
	* Kids from high-income families
	sum inv_1k1 [aw=n1]
	local high_mean_`grade' = `r(mean)'
	local high_sd_`grade' 	= sqrt(`r(mean)'*(1000-`r(mean)')) // binary outcome
	local N1				= `r(sum_w)' 	// # of kids from high-inc families
	estadd sca high_mean 	= `high_mean_`grade''  
	estadd sca high_se		= `high_sd_`grade'' / sqrt(`N1')
	* Kids from low-income families
	sum inv_1k0 [aw=n0]
	local low_mean_`grade'  = `r(mean)'
	local low_sd_`grade'	= sqrt(`r(mean)'*(1000-`r(mean)')) // binary outcome
	local N0				= `r(sum_w)' 	// # of kids from low-inc families
	estadd sca low_mean	    = `low_mean_`grade''
	estadd sca low_se	    = `low_sd_`grade'' / sqrt(`N0')
	* Gap
	local diff_`grade'	= `high_mean_`grade''-`low_mean_`grade''
	estadd sca diff     = `diff_`grade''
	estadd sca diff_se  = sqrt(`low_sd_`grade''^2/`N0' + `high_sd_`grade''^2/`N1')
	
	* Reweighting the disadvantaged group
	sum inv_1k0 [aw=n1]
	local rw_low_mean_`grade' = `r(mean)'
	local rw_low_sd_`grade'	  = sqrt(`r(mean)'*(1000-`r(mean)')) // binary outcome
	estadd sca rw_low_mean    = `rw_low_mean_`grade''
	estadd sca rw_low_se      = `rw_low_sd_`grade'' / sqrt(`N0')
	* Gap
	local rw_diff_`grade' 	  = `high_mean_`grade''-`rw_low_mean_`grade''
	local rw_diff_se_`grade'  = sqrt(`rw_low_sd_`grade''^2/`N0' + `high_sd_`grade''^2/`N1')
	estadd sca rw_diff 		  = `rw_diff_`grade'' 
	estadd sca rw_diff_se     = `rw_diff_se_`grade''
	* Compute fraction of gap closed
	local closed_`grade' = 1-`rw_diff_`grade'' / `diff_`grade''
	estadd sca closed    = `closed_`grade'' * 100
	estadd sca closed_se = (`closed_`grade''/`rw_diff_`grade'')*`rw_diff_se_`grade'' * 100
	matrix gap_closed[`grade'-2,1]  = `closed_`grade'' * 100
}

* Compute average percentage point change per grade
clear
svmat gap_closed
gen grade = _n + 2
eststo: regress gap_closed grade // robust standard errors are smaller
estadd sca av_pp_change     = _b[grade] 
estadd sca se_av_pp_change  = _se[grade]

* Format and export results
local add_scalars high_mean high_se low_mean low_se diff diff_se ///
 rw_low_mean rw_low_se rw_diff rw_diff_se closed closed_se ///
 av_pp_change se_av_pp_change
esttab using  "${tabs}/parental income gap explained by test score.csv", ///
 stats(`add_scalars', fmt(2 2 2 2 2 2 2 2 2 2 1 1 1 1)) d(_cons grade) ///
 nonote mti(3 4 5 6 7 8 "slope") nonum replace
 
 
/******************************************************************************
 Table 3 and Table 4
 These tables are Excel links from IRS results in CSV format (see IRS source code)
******************************************************************************/
 
/******************************************************************************
 Table 5: Gender-Specific Exposure Effects: Children's Innovation Rates vs. 
 Innovation Rates by Gender in Childhood CZ
******************************************************************************/

* Program to store means of dependent and independent variables
cap program drop storemeans
program def storemeans 
syntax varlist
foreach var in `varlist' {
	sum `var' [aw=num_kids]  if e(sample)
	scalar mean_`var' 	 = `r(mean)'
	scalar sd_`var' 	 = `r(sd)'
	estadd scalar mean_`var'
	estadd scalar sd_`var'
}
end

* Program to compute F-test for male vs female gender coefficient equality
cap program drop ftest_gender
program def ftest_gender
	test patentsFpercap = patentsMpercap 
	scalar f_test_stat = `r(F)'
	scalar f_test_pval = `r(p)'
	estadd scalar f_test_stat 
	estadd scalar f_test_pval
end

****************************************************************************

* Clear stored estimates
local gender F M
eststo clear

* col 1
use "${data}/adultsandkids_bycz_mskd.dta", clear
gen patentspercap = patentsFpercap + patentsMpercap
collapse (rawsum) num_kids (mean) inventor (first) patentspercap [aw=num_kids], by(cz)
local indepvars patentspercap
eststo: reg inventor `indepvars' [aw=num_kids] , cluster(cz)
storemeans  inventor `indepvars' 

* col 2-3
use "${data}/adultsandkids_bycz_mskd.dta", clear
local indepvars patentsFpercap  patentsMpercap
foreach gend in `gender'{
	eststo: reg inventor `indepvars'  [aw=num_kids] if kid_gnd=="`gend'", cluster(cz)
	ftest_gender
	storemeans  inventor `indepvars' 
}

* By patent category
use "${data}/adultsandkids_byczcat_mskd.dta", clear
local indepvars patentsFpercap  patentsMpercap
rename totkids num_kids
* col 4-5
foreach gend in `gender'{
	eststo: areg inventor `indepvars'  [aw=num_kids] if kid_gnd=="`gend'", cluster(cz) a(cat)
	ftest_gender
	storemeans  inventor `indepvars' 
}

* Export results
foreach var in inventor patentspercap patentsFpercap patentsMpercap {
	local add_scalars2 `add_scalars2' mean_`var' 
	local add_scalars2 `add_scalars2' sd_`var'
}
local add_scalars2 N `add_scalars2' f_test_stat f_test_pval
esttab using  "${tabs}/Neighborhood effects by gender.csv", noconstant   b(3) se(3) ///
	  nostar stats(`add_scalars2', fmt(0 6)) replace
	  
log close


 
/******************************************************************************
 Table 6
 This table is an Excel link to movers_various.csv 
******************************************************************************/
 
