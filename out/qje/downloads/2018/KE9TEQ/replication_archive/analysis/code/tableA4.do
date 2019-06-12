/*
** last changes: January 2018  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/analysis/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}


include code/preamble.do


log using output/log_tableA4.txt, replace text



include code/set_globals.do



*-------------------------------------------------------
* table A4
*-------------------------------------------------------

use input/sample_countypairs, clear

cap drop news_ptya_*_std

*standardize vars
foreach var in cmag_prez_ptya_base cmag_prez_dem_base cmag_prez_rep_base cmag_prez_ptyd_base cmag_oth_ptya_base $race_controls $other_controls $media_controls news_ptya_freq news_ptya_count {
    egen `var'_std = std(`var')
}  

by state_pair_year, sort: egen counter = count(news_ptya_freq)
keep if counter == 2
cap matrix drop TABLE1A
cap matrix drop TABLE1B
cap matrix drop TABLE2A
cap matrix drop TABLE2B

*xtset state_pair_year

foreach depvar in prez_ptya_base prez_dem_base prez_rep_base prez_ptyd_base oth_ptya_base { 
    reghdfe cmag_`depvar'_std news_ptya_freq_std $race_controls_std, absorb(state_pair_year) vce(cluster state segment) 
    local pvalue = (2*ttail(e(df_r),abs(_b[news_ptya_freq_std]/_se[news_ptya_freq_std])))
    matrix TABLE1A = (nullmat(TABLE1A), (_b[news_ptya_freq_std] \ _se[news_ptya_freq_std] \ `pvalue' \ e(r2) \ e(N)))

    reghdfe cmag_`depvar'_std news_ptya_freq_std $race_controls_std $other_controls_std, absorb(state_pair_year) vce(cluster state segment) 
    local pvalue = (2*ttail(e(df_r),abs(_b[news_ptya_freq_std]/_se[news_ptya_freq_std])))
    matrix TABLE1A = (nullmat(TABLE1A), (_b[news_ptya_freq_std] \ _se[news_ptya_freq_std] \ `pvalue' \ e(r2) \ e(N)))

    reghdfe cmag_`depvar'_std news_ptya_freq_std $race_controls_std $other_controls_std $media_controls_std, absorb(state_pair_year) vce(cluster state segment) 
    local pvalue = (2*ttail(e(df_r),abs(_b[news_ptya_freq_std]/_se[news_ptya_freq_std])))
    matrix TABLE1A = (nullmat(TABLE1A), (_b[news_ptya_freq_std] \ _se[news_ptya_freq_std] \ `pvalue' \ e(r2) \ e(N)))

}

use input/sample_allcounties, clear

cap drop news_ptya_*_std

*standardize vars
foreach var in cmag_prez_ptya_base cmag_prez_dem_base cmag_prez_rep_base cmag_prez_ptyd_base cmag_oth_ptya_base $race_controls $other_controls $media_controls news_ptya_freq news_ptya_count {
    egen `var'_std = std(`var')
} 

keep if !missing(news_ptya_freq)


foreach depvar in prez_ptya_base prez_dem_base prez_rep_base prez_ptyd_base oth_ptya_base { 
    *xtset state

    reghdfe cmag_`depvar'_std news_ptya_freq_std $race_controls_std, vce(cluster state segment) absorb(state)
    local pvalue = (2*ttail(e(df_r),abs(_b[news_ptya_freq_std]/_se[news_ptya_freq_std])))
    matrix TABLE2A = (nullmat(TABLE2A), (_b[news_ptya_freq_std] \ _se[news_ptya_freq_std] \ `pvalue' \ e(r2) \ e(N)))

    reghdfe cmag_`depvar'_std news_ptya_freq_std $race_controls_std $other_controls_std, vce(cluster state segment) absorb(state)
    local pvalue = (2*ttail(e(df_r),abs(_b[news_ptya_freq_std]/_se[news_ptya_freq_std])))
    matrix TABLE2A = (nullmat(TABLE2A), (_b[news_ptya_freq_std] \ _se[news_ptya_freq_std] \ `pvalue' \ e(r2) \ e(N)))

    reghdfe cmag_`depvar'_std news_ptya_freq_std $race_controls_std $other_controls_std $media_controls_std, vce(cluster state segment) absorb(state)
    local pvalue = (2*ttail(e(df_r),abs(_b[news_ptya_freq_std]/_se[news_ptya_freq_std])))
    matrix TABLE2A = (nullmat(TABLE2A), (_b[news_ptya_freq_std] \ _se[news_ptya_freq_std] \ `pvalue' \ e(r2) \ e(N)))

}

matrix TABLEA = (TABLE1A \ TABLE2A)
matrix rownames TABLEA = b_news_dfstd se_news_dfstd pvalue_dfstd r2_dfstd n_dfstd b_news_std se_news_std pvalue_std r2_std n_std
matrix colnames TABLEA = prez_ptya_base1 prez_ptya_base2 prez_ptya_base3 prez_dem_base1 prez_dem_base2 prez_dem_base3 prez_rep_base1 prez_rep_base2 prez_rep_base3 prez_ptyd_base1 prez_ptyd_base2 prez_ptyd_base3 oth_ptya_base1 oth_ptya_base2 oth_ptya_base3
putexcel set output/tables.xlsx, sheet("appendix_news_grp", replace) modify
putexcel A1=matrix(TABLEA), names


log close

