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


log using output/log_table2.txt, replace text



include code/set_globals.do

*---------------------------------------------------------------------------------------------
* table 2: political advertising and border-county characteristics
*---------------------------------------------------------------------------------------------

use input/sample_countypairs, clear

eststo clear

*standardize vars
foreach var in cmag_prez_ptya_base cmag_prez_dem_base cmag_prez_rep_base cmag_prez_ptyd_base cmag_oth_ptya_base $race_controls $other_controls $media_controls {
    egen `var'_std = std(`var')
}  


foreach depvar in prez_ptya_base prez_dem_base prez_rep_base prez_ptyd_base oth_ptya_base { 
    reghdfe cmag_`depvar'_std $race_controls_std, absorb(state_county state_pair_year) vce(cluster state segment)
    test $race_controls_std
    eststo `depvar'1, add(within_R2 e(r2_within) f_stat r(F) f_pvalue r(p))

    reghdfe cmag_`depvar'_std $race_controls_std $other_controls_std, absorb(state_county state_pair_year) vce(cluster state segment)
    test $race_controls_std $other_controls_std 
    eststo `depvar'2, add(within_R2 e(r2_within) f_stat r(F) f_pvalue r(p))

    reghdfe cmag_`depvar'_std $race_controls_std $other_controls_std $media_controls_std, absorb(state_county state_pair_year) vce(cluster state segment)
    test $race_controls_std $other_controls_std $media_controls_std
    eststo `depvar'3, add(within_R2 e(r2_within) f_stat r(F) f_pvalue r(p))

}

esttab * using output/correlation_regs.csv, replace b(%4.3f) se(%4.3f) r2 star(* 0.05 ** 0.01) pa mtitles scalars(within_R2 f_stat f_pvalue)
eststo clear


log close
