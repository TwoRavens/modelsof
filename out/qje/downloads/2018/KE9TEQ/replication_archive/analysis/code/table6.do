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


log using output/log_table6.txt, replace text


include code/set_globals.do


use input/sample_countypairs, clear 


di "reduced form"

reghdfe turnout battleground_pop_share $extra_controls_ptya $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE_RF = (nullmat(TABLE_RF), (_b[battleground_pop_share] \ _se[battleground_pop_share] \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe turnout lag_turnout battleground_pop_share $extra_controls_ptya $demo_controls, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE_RF = (nullmat(TABLE_RF), (_b[battleground_pop_share] \ _se[battleground_pop_share] \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))


reghdfe vote_share2pty_ptydf battleground_pop_share $extra_controls_ptyd $demo_controls, absorb(state_county state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE_RF = (nullmat(TABLE_RF), (_b[battleground_pop_share] \ _se[battleground_pop_share] \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))

reghdfe vote_share2pty_ptydf lag_vote_share2pty_ptydf battleground_pop_share $extra_controls_ptyd $demo_controls, absorb(state_pair_year) vce(cluster state segment)
test battleground_pop_share = 0
local pvalue = (2*ttail(e(df_r),abs(_b[battleground_pop_share]/_se[battleground_pop_share])))
matrix TABLE_RF = (nullmat(TABLE_RF), (_b[battleground_pop_share] \ _se[battleground_pop_share] \ `pvalue' \ r(F) \ r(p) \ e(r2) \ e(N)))



di "2sls"

reghdfe turnout $extra_controls_ptya $demo_controls (cmag_prez_ptya_base=battleground_pop_share) , absorb(state_county state_pair_year) vce(cluster state segment)
test cmag_prez_ptya_base = 0
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_base]/_se[cmag_prez_ptya_base])))
matrix TABLE_IV = (nullmat(TABLE_IV), (_b[cmag_prez_ptya_base] \ _se[cmag_prez_ptya_base] \ . \ . \ `pvalue' \ r(F) \ r(p) \ e(widstat) \ e(N)))

reghdfe turnout lag_turnout $extra_controls_ptya $demo_controls (cmag_prez_ptya_base=battleground_pop_share) , absorb(state_pair_year) vce(cluster state segment)
test cmag_prez_ptya_base = 0
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_base]/_se[cmag_prez_ptya_base])))
matrix TABLE_IV = (nullmat(TABLE_IV), (_b[cmag_prez_ptya_base] \ _se[cmag_prez_ptya_base] \ . \ . \ `pvalue' \ r(F) \ r(p) \ e(widstat) \ e(N)))



reghdfe vote_share2pty_ptydf $extra_controls_ptyd_ptyd $demo_controls (cmag_prez_ptyd_base=battleground_pop_share) , absorb(state_county state_pair_year) vce(cluster state segment)
test cmag_prez_ptyd_base = 0
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
matrix TABLE_IV = (nullmat(TABLE_IV), ( . \ . \ _b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue' \ r(F) \ r(p) \ e(widstat) \ e(N)))

reghdfe vote_share2pty_ptydf lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls  (cmag_prez_ptyd_base=battleground_pop_share) , absorb(state_pair_year) vce(cluster state segment)
test cmag_prez_ptyd_base = 0
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
matrix TABLE_IV = (nullmat(TABLE_IV), ( . \ . \ _b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue' \ r(F) \ r(p) \ e(widstat) \ e(N)))



matrix rownames TABLE_RF = b se p fstat pvalue_all r2 n 
putexcel set output/tables.xlsx, sheet("iv_rf", replace) modify
putexcel A1=matrix(TABLE_RF), rownames

matrix rownames TABLE_IV = b_turnout se_turnout b_votes se_votes p fstat pvalue_all ffirst n 
putexcel set output/tables.xlsx, sheet("iv_2sls", replace) modify
putexcel A1=matrix(TABLE_IV), rownames


log close
