/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
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

log using output/log_figureA7.txt, replace text

include code/set_globals.do



local nsim = 1000

local dep_var = "vote_share2pty_ownpty"
local ad_var = "cmag_prez_ownpty_base"
local sempar_model = "cmag_prez_othpty_base lag_vote_share2pty_ownpty cand_visits_othpty cand_visits_ownpty cmag_oth_ownpty_base cmag_oth_othpty_base newspaper_slant document_count $demo_controls, nonpar(`ad_var') spline degree(3) knots1(0(7)28) gen(f parametric_res) nograph"
local par_model = "cmag_prez_othpty_base lag_vote_share2pty_ownpty cand_visits_othpty cand_visits_ownpty cmag_oth_ownpty_base cmag_oth_othpty_base newspaper_slant document_count $demo_controls `ad_var'"


use input/sample_countypairs_own.dta, clear


egen FE=group(state_pair_year reference)
by FE, sort: gen t=_n
xtset FE t



* semiparametric model
xtsemipar `dep_var' `sempar_model'
gen eps = parametric_res - f
gen fit_sp = f + `dep_var' - parametric_res
gen f_orig = f

* parametric model
xtreg `dep_var' `par_model', fe
predict fit_par, xbu

* test statistic
gen sq_diff = (fit_sp-fit_par)^2
qui sum sq_diff
local T0 = r(mean)


* bootstrap test statistic
local TT 0
forvalues i=1(1)`nsim' {
    
    if `i'==1 {
        di""
        di "Boostrapping the distribution of the test statistic"
        di ""
        nois _dots 0, title(bootstrap replicates) reps(`nsim')
    }
    
    quietly {
        nois _dots `i' 0
        drop f parametric_res sq_diff
        
        gen z=1
        gen u=uniform()
        by state, sort: replace z=-1 if u[1]<=.5
        gen ystar = fit_par + eps*z


        * fit semiparametric model
        xtsemipar ystar `sempar_model'
        gen m_sp = f + ystar - parametric_res
        
        * fit linear model
        xtreg ystar `par_model', fe
        predict m_par, xbu
        
        gen sq_diff = (m_sp-m_par)^2
        sum sq_diff
        local T = r(mean)
        
        if `T'>=`T0' {
            local ++TT
        }
        
        drop u z ystar m_par m_sp
    }
}

di "bootstrapped p-value (H0 = linearity): " `TT'/`nsim'


xtreg `dep_var' `par_model', fe cluster(state)
predict R, e
gen Xb = _b[`ad_var']*`ad_var'
qui sum Xb
local m = r(mean)
replace R = R + Xb
qui sum f
replace f_orig = f_orig + `m'
sort `ad_var'
twoway (scatter R `ad_var') (line  Xb `ad_var') (line f_orig `ad_var')
graph play code/figureA7.grec
graph save output/figureA7.gph, replace
graph export output/figureA7.eps, replace

log close
