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


log using output/log_tableA7.txt, replace text



include code/set_globals.do


*-------------------------------------------------------
* table A7: placebo_votes
*-------------------------------------------------------

global spec1  "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls, absorb(state_pair_year); baseline"
global spec2  "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls [aw=weight], absorb(state_pair_year); county_weight"
global spec3  "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pct_pair_pop <= 0.15, absorb(state_pair_year); pop_share15"
global spec4  "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pct_pair_pop <= 0.10, absorb(state_pair_year); pop_share10"
global spec5  "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pct_pair_pop <= 0.05, absorb(state_pair_year); pop_share5"
global spec6  "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pct_pair_pop <= 0.02, absorb(state_pair_year); pop_share2"
global spec7  "vote_share2pty_ptydf f_cmag_prez_ptyd_1knads lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_1knads $media_controls $demo_controls, absorb(state_pair_year); nads"
global spec8  "vote_share2pty_ptydf f_cmag_prez_ptyd_grp lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_grp $media_controls $demo_controls, absorb(state_pair_year); grps"
global spec9 "vote_share2pty_ptydf f_cmag_prez_ptyd_180days lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_180days $media_controls $demo_controls, absorb(state_pair_year); within_180days"
global spec10 "vote_share2pty_ptydf f_cmag_prez_ptyd_120days lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_120days $media_controls $demo_controls, absorb(state_pair_year); within_120days"
global spec11 "vote_share2pty_ptydf f_cmag_prez_ptyd_30days lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_30days $media_controls $demo_controls, absorb(state_pair_year); within_30days"
global spec12 "vote_share2pty_ptydf f_cmag_prez_ptyd_2plus lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_2plus $media_controls $demo_controls, absorb(state_pair_year); 2_plus_grp"
global spec13 "vote_share2pty_ptydf f_cmag_prez_ptyd_natl lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_natl $media_controls $demo_controls, absorb(state_pair_year); include_natl"
global spec14 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground == 1, absorb(state_pair_year); battleground"
global spec15 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground == 0, absorb(state_pair_year); non_battleground"
global spec16 "vote_share2pty_ptydf f_cmag_prez_ptyd_uniq lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_uniq $media_controls $demo_controls, absorb(state_pair_year); unique_ads"
global spec17 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pair_cd_match & cd_pct_max >= 0.80, absorb(state_pair_year); cd_match_80"
global spec18 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pair_cd_match & cd_pct_max >= 0.90, absorb(state_pair_year); cd_match_90"
global spec19 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pair_cd_match & cd_pct_max >= 0.95, absorb(state_pair_year); cd_match_95"
global spec20 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pair_cd_match & cd_pct_max >= 0.99, absorb(state_pair_year); cd_match_99"
global spec21 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pop_share_minority < med_minorities, absorb(state_pair_year); lo_minorities"
global spec22 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pop_share_minority >= med_minorities, absorb(state_pair_year); hi_minorities"
global spec23 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if edu_colplus < med_college, absorb(state_pair_year); lo_educ"
global spec24 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if edu_colplus >= med_college, absorb(state_pair_year); hi_educ"
global spec25 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground_index>0, absorb(state_pair_year); democratic"
global spec26 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground_index==0, absorb(state_pair_year); tossup"
global spec27 "vote_share2pty_ptydf f_cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground_index<0, absorb(state_pair_year); republican"

local f_vars "cmag_prez_ptyd_base cmag_prez_ptyd_uniq cmag_prez_ptyd_natl cmag_prez_ptyd_2plus cmag_prez_ptyd_30days cmag_prez_ptyd_120days cmag_prez_ptyd_180days cmag_prez_ptyd_grp cmag_prez_ptyd_1knads"


use input/sample_countypairs, clear

by year, sort: egen med_minorities = median(pop_share_minority)
by year, sort: egen med_college = median(edu_colplus)

by state_pair_year, sort: egen appearances=total(n_pairs_per_county)
gen weight = 1/appearances

egen ID = group(state county state_pair)
xtset ID year, delta(4)

foreach v in `f_vars' {
    gen f_`v'=f.`v'
}

*xtset state_pair_year

foreach year in ALL 2004 2008 {
    
    preserve
    if inlist("`year'","2004","2008") keep if year == `year' 
    local matrix_rownames ""    
    capture matrix drop TABLE_`year'

    forvalues n = 1/27 {
	
	local spec_match = regexm("${spec`n'}","(.*);(.*)")
	local spec_reg = regexs(1)
	local spec_name = trim(regexs(2))
	tokenize "`spec_reg'"
	di "reghdfe `spec_reg' vce(cluster state segment)"
	reghdfe `spec_reg' vce(cluster state segment)
	test `2' = 0 
	matrix TABLE1 = ((_b[`2'] \ _se[`2']), (r(p) \ .))
	matrix TABLE_`year' = (nullmat(TABLE_`year') \ TABLE1)
	local matrix_rownames = "`matrix_rownames' b_`spec_name' se_`spec_name'"
    
    }
    restore
}
drop f_*

matrix TABLE_YEAR = (TABLE_ALL, TABLE_2004, TABLE_2008)
matrix rownames TABLE_YEAR = `matrix_rownames'
matrix colnames TABLE_YEAR = coef_all pvalue_all coef_2004 pvalue_2004 coef_2008 pvalue_2008
putexcel set output/tables.xlsx, sheet("placebo_party", replace) modify
putexcel A1=matrix(TABLE_YEAR), names



log close
