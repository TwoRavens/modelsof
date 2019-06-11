* 2018-11-8

 
/*
This do-file creates tables found in the appendix of

  - Bell, A., Chetty, R., Jaravel, X., Petkova, N. & Van Reenen, J. (2018). 
		Who Becomes an Inventor in America? The Importance of Exposure to Innovation
		
*/

* Run patents_figs_metafile first!

* Log
cap log close
log using "${logs}/tables_appendix_log.log", replace

*** TABLES IN APPENDIX
/*******************************************************************************
App. Table 1
Excel link from inv_vs_testscores.csv
*******************************************************************************/

/*******************************************************************************
App. Table 2: Fraction of Gender Gap in Innovation Explained by Differences
in Test Scores
Notes: Based on entire NYC sample (birth cohorts 1979-85) with non-missing test
score. Children may potentially be observed at all grades.
*******************************************************************************/
local data_gap "${data}/gender"
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
	estadd sca closed_se = (`closed_`grade''/`rw_diff_`grade'')*`rw_diff_se_`grade'' * 100 // Check with Raj
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
local g_scalars high_mean high_se low_mean low_se diff diff_se ///
 rw_low_mean rw_low_se rw_diff rw_diff_se closed closed_se ///
 av_pp_change se_av_pp_change
esttab using  "${tabs}/gender gap explained by test score.csv", ///
 stats(`g_scalars', fmt(2 2 2 2 2 2 2 2 2 2 1 1 1 1)) d(_cons grade) ///
 nonote mti(3 4 5 6 7 8 "slope") nonum replace
 
log close
