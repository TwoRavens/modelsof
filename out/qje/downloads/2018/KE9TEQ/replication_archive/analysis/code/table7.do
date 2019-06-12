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


log using output/log_table7.txt, replace text



include code/set_globals.do


*-------------------------------------------------------
* table 7: own vs opponent advertising
*-------------------------------------------------------


use input/sample_countypairs, clear


global spec1 "vote_share_dem; lag_vote_share_dem"
global spec2 "vote_share_rep; lag_vote_share_rep"
global spec3 "vote_share_ptydf; lag_vote_share_ptydf"

forvalues n = 1/3 {
  
    local spec_match = regexm("${spec`n'}","(.*);(.*)")
    local depvar = regexs(1)
    local lag_depvar = trim(regexs(2))

    di "reghdfe `depvar' cmag_prez_dem_base cmag_prez_rep_base cand_visits_dem cand_visits_rep cmag_oth_dem_base cmag_oth_rep_base newspaper_slant document_count $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)"
    reghdfe `depvar' cmag_prez_dem_base cmag_prez_rep_base cand_visits_dem cand_visits_rep cmag_oth_dem_base cmag_oth_rep_base newspaper_slant document_count $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)
    test (cmag_prez_dem_base = 0) (cmag_prez_rep_base = 0)
    local pvalue_dem = (2*ttail(e(df_r),abs(_b[cmag_prez_dem_base]/_se[cmag_prez_dem_base])))
    local pvalue_rep = (2*ttail(e(df_r),abs(_b[cmag_prez_rep_base]/_se[cmag_prez_rep_base])))
    local F_stat_equal = r(F)
    local p_value_equal = r(p)
    test cmag_prez_dem_base = -cmag_prez_rep_base
    matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_dem_base] \ _se[cmag_prez_dem_base] \ `pvalue_dem' \ _b[cmag_prez_rep_base] \ _se[cmag_prez_rep_base] \ `pvalue_rep' \ . \ . \ . \ `F_stat_equal' \ `p_value_equal' \ r(F) \ r(p) \ e(r2) \ e(N)))

    di "reghdfe `depvar' cmag_prez_dem_base cmag_prez_rep_base `lag_depvar' cand_visits_dem cand_visits_rep cmag_oth_dem_base cmag_oth_rep_base newspaper_slant document_count $demo_controls, absorb(state_pair_year) vce(cluster state segment)"
    reghdfe `depvar' cmag_prez_dem_base cmag_prez_rep_base `lag_depvar' cand_visits_dem cand_visits_rep cmag_oth_dem_base cmag_oth_rep_base newspaper_slant document_count $demo_controls, absorb(state_pair_year) vce(cluster state segment)
    estimates store `depvar'2
    test (cmag_prez_dem_base = 0) (cmag_prez_rep_base = 0)
    local pvalue_dem = (2*ttail(e(df_r),abs(_b[cmag_prez_dem_base]/_se[cmag_prez_dem_base])))
    local pvalue_rep = (2*ttail(e(df_r),abs(_b[cmag_prez_rep_base]/_se[cmag_prez_rep_base])))
    local F_stat_equal = r(F)
    local p_value_equal = r(p)
    test cmag_prez_dem_base = -cmag_prez_rep_base
    matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_dem_base] \ _se[cmag_prez_dem_base] \ `pvalue_dem' \ _b[cmag_prez_rep_base] \ _se[cmag_prez_rep_base] \ `pvalue_rep' \ . \ . \ . \ `F_stat_equal' \ `p_value_equal' \ r(F) \ r(p) \ e(r2) \ e(N)))

    di "reghdfe `depvar' cmag_prez_ptyd_base `lag_depvar' cand_visits_dem cand_visits_rep cmag_oth_ptyd_base newspaper_slant document_count $demo_controls, absorb(state_pair_year) vce(cluster state segment)"
    reghdfe `depvar' cmag_prez_ptyd_base `lag_depvar' cand_visits_dem cand_visits_rep cmag_oth_dem_base cmag_oth_rep_base newspaper_slant document_count $demo_controls, absorb(state_pair_year) vce(cluster state segment)
    estimates store `depvar'3
    local pvalue_ptyd = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
    matrix TABLE = (nullmat(TABLE), ( . \ . \ . \ . \ . \ . \ _b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue_ptyd' \ . \ . \ . \ . \ e(r2) \ e(N)))
}

matrix rownames TABLE = b_dem se_dem p_dem b_rep se_rep p_rep b_ptyd se_ptyd p_ptyd fstat_equal_pty pvalue_equal_pty fstat_asym_pty pvalue_asym_pty r2_pty n_pty
putexcel set output/tables.xlsx, sheet("party_split") modify
putexcel A1=matrix(TABLE), rownames



log close
