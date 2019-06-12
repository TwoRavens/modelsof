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


log using output/log_table3.txt, replace text



include code/set_globals.do


*-------------------------------------------------------
* table 3 & A8: main_table_turnout
*-------------------------------------------------------

global specA1 ", absorb(one) vce(cluster state segment)"
global specA2 ", absorb(state_county year) vce(cluster state segment)"
global specA3 "$extra_controls_ptya $demo_controls, absorb(state_county year) vce(cluster state segment)"
global specA4 ", absorb(one) vce(cluster state segment)"
global specA5 ", absorb(state_county year) vce(cluster state segment)"
global specA6 "$extra_controls_ptya $demo_controls, absorb(state_county year) vce(cluster state segment)"
global specA7 ", absorb(state_county state_pair_year) vce(cluster state segment)"
global specA8 "$extra_controls_ptya $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)"
global specA9 "lag_turnout_pres $extra_controls_ptya $demo_controls, absorb(state_pair_year) vce(cluster state segment)"


use input/sample_allcounties, clear

gen one = 1

forvalues n = 1/3 {

    di "reghdfe turnout cmag_prez_ptya_base ${specA`n'}"
    reghdfe turnout cmag_prez_ptya_base ${specA`n'}
    test cmag_prez_ptya_base = 0
    local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_base]/_se[cmag_prez_ptya_base])))
    matrix TABLE = (_b[cmag_prez_ptya_base] \ _se[cmag_prez_ptya_base] \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N))
    
    di "reghdfe turnout cmag_prez_ptya_pro cmag_prez_ptya_neg ${specA`n'}"
    reghdfe turnout cmag_prez_ptya_pro cmag_prez_ptya_neg ${specA`n'}
    test (cmag_prez_ptya_pro = 0) (cmag_prez_ptya_neg = 0)
    local pvalue_pro = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_pro]/_se[cmag_prez_ptya_pro])))
    local pvalue_neg = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_neg]/_se[cmag_prez_ptya_neg])))
    matrix TABLE = (nullmat(TABLE) \ (_b[cmag_prez_ptya_pro] \ _se[cmag_prez_ptya_pro] \ `pvalue_pro' \ _b[cmag_prez_ptya_neg] \ _se[cmag_prez_ptya_neg] \ `pvalue_neg' \ r(F) \ r(p) \ e(r2) \ e(N)))
    matrix TABLE_ALL = (nullmat(TABLE_ALL), TABLE)

}

use input/sample_countypairs, clear

gen one = 1


forvalues n = 4/9 {
    di "reghdfe turnout cmag_prez_ptya_base ${specA`n'}"
    reghdfe turnout cmag_prez_ptya_base ${specA`n'}
    test cmag_prez_ptya_base = 0
    local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_base]/_se[cmag_prez_ptya_base])))
    matrix TABLE = (_b[cmag_prez_ptya_base] \ _se[cmag_prez_ptya_base] \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N))
    
    di "reghdfe turnout cmag_prez_ptya_pro cmag_prez_ptya_neg ${specA`n'}"
    reghdfe turnout cmag_prez_ptya_pro cmag_prez_ptya_neg ${specA`n'}
    test (cmag_prez_ptya_pro = 0) (cmag_prez_ptya_neg = 0)
    local pvalue_pro = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_pro]/_se[cmag_prez_ptya_pro])))
    local pvalue_neg = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_neg]/_se[cmag_prez_ptya_neg])))
    matrix TABLE = (nullmat(TABLE) \ (_b[cmag_prez_ptya_pro] \ _se[cmag_prez_ptya_pro] \ `pvalue_pro' \ _b[cmag_prez_ptya_neg] \ _se[cmag_prez_ptya_neg] \ `pvalue_neg' \ r(F) \ r(p) \ e(r2) \ e(N)))
    matrix TABLE_ALL = (nullmat(TABLE_ALL), TABLE)
}

matrix rownames TABLE_ALL = b_all se_all p_all fstat_all pvalue_all r2_all n_all b_pro se_pro p_pro b_neg se_neg p_neg fstat_tone pvalue_tone r2_tone n_tone
putexcel set output/tables.xlsx, sheet("main_table_turnout", replace) modify
putexcel A1=matrix(TABLE_ALL), rownames





log close
