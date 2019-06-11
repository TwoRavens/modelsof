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


log using output/log_table4.txt, replace text



include code/set_globals.do


*-------------------------------------------------------
* table 4 & A10:main_table_party
*-------------------------------------------------------


global specB1 ", absorb(one) vce(cluster state segment)"
global specB2 ", absorb(state_county year) vce(cluster state segment)"
global specB3 "$extra_controls_ptyd $demo_controls, absorb(state_county year) vce(cluster state segment)"
global specB4 ", absorb(one) vce(cluster state segment)"
global specB5 ", absorb(state_county year) vce(cluster state segment)"
global specB6 "$extra_controls_ptyd $demo_controls, absorb(state_county year) vce(cluster state segment)"
global specB7 ", absorb(state_county state_pair_year) vce(cluster state segment)"
global specB8 "$extra_controls_ptyd $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)"
global specB9 "lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls, absorb(state_pair_year) vce(cluster state segment)"


use input/sample_allcounties, clear

gen one = 1

forvalues n = 1/3 {

    di "reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base ${specB`n'}"
    reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base ${specB`n'}
    test cmag_prez_ptyd_base = 0
    local pvalue_d = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
    matrix TABLE_PARTY = (nullmat(TABLE_PARTY), (_b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue_d' \ r(F) \ r(p) \ e(r2) \ e(N)))

}

use input/sample_countypairs, clear

gen one = 1

forvalues n = 4/9 {

    di "reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base ${specB`n'}"
    reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base ${specB`n'}
    test cmag_prez_ptyd_base = 0
    local pvalue_d = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
    matrix TABLE_PARTY = (nullmat(TABLE_PARTY), (_b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue_d' \ r(F) \ r(p) \ e(r2) \ e(N)))
}

matrix rownames TABLE_PARTY = b_all se_all p_all fstat_all pvalue_all r2_all n_all
putexcel set output/tables.xlsx, sheet("main_table_party", replace) modify
putexcel A1=matrix(TABLE_PARTY), rownames







log close

