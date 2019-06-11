/*
** last changes: March 2018  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
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


log using output/log_table5.txt, replace text


include code/set_globals.do


*-------------------------------------------------------
* table 5: first stage
*-------------------------------------------------------

 

use input/sample_countypairs, clear 

reghdfe cmag_prez_dem_base battleground_pop_share $extra_controls $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe cmag_prez_dem_base battleground_pop_share $extra_controls $demo_controls lag_turnout_pres, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe cmag_prez_dem_base battleground_pop_share $extra_controls $demo_controls lag_vote_share2pty_ptydf, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))



reghdfe cmag_prez_rep_base battleground_pop_share $extra_controls $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe cmag_prez_rep_base battleground_pop_share $extra_controls $demo_controls lag_turnout_pres, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe cmag_prez_rep_base battleground_pop_share $extra_controls $demo_controls lag_vote_share2pty_ptydf, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))



reghdfe cmag_prez_ptya_base battleground_pop_share $extra_controls $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe cmag_prez_ptya_base battleground_pop_share $extra_controls $demo_controls lag_turnout_pres, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe cmag_prez_ptya_base battleground_pop_share $extra_controls $demo_controls lag_vote_share2pty_ptydf, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))



reghdfe cmag_prez_ptyd_base battleground_pop_share $extra_controls $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe cmag_prez_ptyd_base battleground_pop_share $extra_controls $demo_controls lag_turnout_pres, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe cmag_prez_ptyd_base battleground_pop_share $extra_controls $demo_controls lag_vote_share2pty_ptydf, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE = (nullmat(TABLE), (_b[battleground_pop_share]*10 \ _se[battleground_pop_share]*10 \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))












matrix rownames TABLE = b se p fstat pvalue_all r2 n 
putexcel set output/tables.xlsx, sheet("iv_fs", replace) modify
putexcel A1=matrix(TABLE), rownames

log close
