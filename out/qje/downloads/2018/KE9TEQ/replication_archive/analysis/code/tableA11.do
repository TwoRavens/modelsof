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


clear
clear matrix
clear mata
pause off
set more off
set matsize 8000
set maxvar 10000
adopath + code/
cap matrix drop _all
cap file close handle
cap log close 
log using output/log_tableA11.txt, replace text



include code/set_globals.do


*-------------------------------------------------------
* table A11:sensitivity_party
*-------------------------------------------------------

global spec1  "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls, absorb(state_pair_year); baseline"
global spec2  "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls [aw=weight], absorb(state_pair_year); county_weight"
global spec3  "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pct_pair_pop <= 0.15, absorb(state_pair_year); pop_share15"
global spec4  "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pct_pair_pop <= 0.10, absorb(state_pair_year); pop_share10"
global spec5  "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pct_pair_pop <= 0.05, absorb(state_pair_year); pop_share5"
global spec6  "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pct_pair_pop <= 0.02, absorb(state_pair_year); pop_share2"
global spec7  "vote_share2pty_ptydf cmag_prez_ptyd_1knads lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_1knads $media_controls $demo_controls, absorb(state_pair_year); nads"
global spec8  "vote_share2pty_ptydf cmag_prez_ptyd_grp lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_grp $media_controls $demo_controls, absorb(state_pair_year); grps"
global spec9 "vote_share2pty_ptydf cmag_prez_ptyd_180days lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_180days $media_controls $demo_controls, absorb(state_pair_year); within_180days"
global spec10 "vote_share2pty_ptydf cmag_prez_ptyd_120days lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_120days $media_controls $demo_controls, absorb(state_pair_year); within_120days"
global spec11 "vote_share2pty_ptydf cmag_prez_ptyd_30days lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_30days $media_controls $demo_controls, absorb(state_pair_year); within_30days"
global spec12 "vote_share2pty_ptydf cmag_prez_ptyd_2plus lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_2plus $media_controls $demo_controls, absorb(state_pair_year); 2_plus_grp"
global spec13 "vote_share2pty_ptydf cmag_prez_ptyd_natl lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_natl  $media_controls $demo_controls, absorb(state_pair_year); include_natl"
global spec14 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground == 1, absorb(state_pair_year); battleground"
global spec15 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground == 0, absorb(state_pair_year); non_battleground"
global spec16 "vote_share2pty_ptydf cmag_prez_ptyd_uniq lag_vote_share2pty_ptydf cand_visits_ptydf cmag_oth_ptyd_uniq $media_controls $demo_controls, absorb(state_pair_year); unique_ads"
global spec17 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pair_cd_match & cd_pct_max >= 0.80, absorb(state_pair_year); cd_match_80"
global spec18 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pair_cd_match & cd_pct_max >= 0.90, absorb(state_pair_year); cd_match_90"
global spec19 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pair_cd_match & cd_pct_max >= 0.95, absorb(state_pair_year); cd_match_95"
global spec20 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pair_cd_match & cd_pct_max >= 0.99, absorb(state_pair_year); cd_match_99"
global spec21 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pop_share_minority < med_minorities, absorb(state_pair_year); lo_minorities"
global spec22 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if pop_share_minority >= med_minorities, absorb(state_pair_year); hi_minorities"
global spec23 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if edu_colplus < med_college, absorb(state_pair_year); lo_educ"
global spec24 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if edu_colplus >= med_college, absorb(state_pair_year); hi_educ"
global spec25 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground_index>0, absorb(state_pair_year); democratic"
global spec26 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground_index==0, absorb(state_pair_year); tossup"
global spec27 "vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls if battleground_index<0, absorb(state_pair_year); republican"


use input/sample_countypairs, clear


*xtset state_pair_year

by year, sort: egen med_minorities = median(pop_share_minority)
by year, sort: egen med_college = median(edu_colplus)

by state_county year, sort: egen appearances=count(county)
gen weight = 1/appearances

foreach year in ALL 2004 2008 2012 {
    
    preserve
    if inlist("`year'","2004","2008","2012") keep if year == `year' 
    local matrix_rownames ""    
    capture matrix drop TABLE_`year'

    forvalues n = 1/27 {
	
	local spec_match = regexm("${spec`n'}","(.*);(.*)")
	local spec_reg = regexs(1)
	local spec_name = trim(regexs(2))
	tokenize "`spec_reg'"
	if `n'==2 {
	   	di "reghdfe `spec_reg' vce(cluster state segment)"
	    reghdfe `spec_reg' vce(cluster state segment)
	}
	else {
	    di "xtreg `spec_reg' vce(cluster state segment)"
	    reghdfe `spec_reg' vce(cluster state segment) 
    }  
	test `2' = 0 
	matrix TABLE1 = ((_b[`2'] \ _se[`2']), (r(p) \ .))
	matrix TABLE_`year' = (nullmat(TABLE_`year') \ TABLE1)
	local matrix_rownames = "`matrix_rownames' b_`spec_name' se_`spec_name'"
    
    }
    restore
}

matrix TABLE_YEAR = (TABLE_ALL, TABLE_2004, TABLE_2008, TABLE_2012)
matrix rownames TABLE_YEAR = `matrix_rownames'
matrix colnames TABLE_YEAR = coef_all pvalue_all coef_2004 pvalue_2004 coef_2008 pvalue_2008 coef_2012 pvalue_2012
putexcel set output/tables.xlsx, sheet("sensitivity_party", replace) modify
putexcel A1=matrix(TABLE_YEAR), names




gen above_med = (edu_colplus >= med_college)
foreach y in cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls {
    gen __`y' = `y'*above_med
}
egen fe__=group(above_med state_pair_year)
*xtset fe__
reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls __*, absorb(fe__) vce(cluster state segment)

drop *__*

gen above_min = (pop_share_minority >= med_minorities)
foreach y in cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls {
    gen __`y' = `y'*above_min
}
egen fe__=group(above_min state_pair_year)
*xtset fe__
reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls __*, absorb(fe__) vce(cluster state segment)






* test for equality of coefficients in first row
global year_demo_controls = "i.year#c.pop_share_minority i.year#c.tot_pop_adult i.year#c.edu_dropout i.year#c.edu_colplus i.year#c.foreign_born_pct i.year#c.income i.year#c.pct_poverty i.year#c.lfp"

global year_extra_controls "i.year#c.cand_visits_ptydf i.year#c.cmag_oth_ptyd_base i.year#c.newspaper_slant i.year#c.document_count"

forvalues y = 2004(4)2012 {
    gen ads`y' = (year==`y')*c.cmag_prez_ptyd_base
}
egen year_state=group(year state)
egen year_segment=group(year segment)

*xtset state_pair_year
reghdfe vote_share2pty_ptydf ads2004 ads2008 ads2012 i.year#c.lag_vote_share2pty_ptydf $year_demo_controls $year_extra_controls, absorb(state_pair_year) vce(cluster year_state year_segment)
test ads2004==ads2008==ads2012




log close
