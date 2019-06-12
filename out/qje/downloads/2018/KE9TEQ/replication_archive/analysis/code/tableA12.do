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


log using output/log_tableA12.txt, replace text



include code/set_globals.do



*-------------------------------------------------------
* table A12: additional robustness checks
*-------------------------------------------------------



*** reweighting estimators
use input/sample_allcounties.dta, clear

tempfile weights

reg border_county $extra_controls $demo_controls i.year lag_turnout_pres lag_vote_share2pty_ptydf
predict pborder
gen ipw = 1/pborder


local mlist
foreach v in $extra_controls $demo_controls vote_share_rep vote_share_dem lag_turnout_pres lag_vote_share2pty_ptydf {
    sum `v'
    local m = r(mean)
    local mean = "`m'"
    local mlist: list mlist | mean
}
di "`mlist'"
    
ebalance $extra_controls $demo_controls vote_share_rep vote_share_dem lag_turnout_pres lag_vote_share2pty_ptydf if border_county, manualtargets(`mlist')


keep if border_county==1
keep ipw _webal state county year


save `weights'



use input/sample_countypairs.dta, clear

gen one=1

merge m:1 state county year using `weights'



reghdfe turnout cmag_prez_ptya_base  lag_turnout_pres $extra_controls_ptya $demo_controls  [pw=ipw], absorb(state_pair_year) vce(cluster state segment)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_base]/_se[cmag_prez_ptya_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptya_base] \ _se[cmag_prez_ptya_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))

reghdfe turnout cmag_prez_ptya_base  lag_turnout_pres $extra_controls_ptya $demo_controls  [aw=_webal], absorb(state_pair_year) vce(cluster state segment)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_base]/_se[cmag_prez_ptya_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptya_base] \ _se[cmag_prez_ptya_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))



reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base  lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls  [pw=ipw], absorb(state_pair_year) vce(cluster state segment)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))

reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base  lag_vote_share2pty_ptydf $extra_controls_ptyd $demo_controls  [aw=_webal], absorb(state_pair_year) vce(cluster state segment)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))








*** specification: baseline + state*lagged outcome + (controls*lagged outcome)

use input/sample_countypairs, clear


global controls "$extra_controls $demo_controls"


local interc
foreach v in $controls {
    local tempv = "c.`v'#c.lag_vote_share2pty_ptydf"
    local interc : list interc | tempv
}

*xtset state_pair_year

reghdfe turnout cmag_prez_ptya_base i.state#c.lag_turnout_pres $controls, absorb(state_pair_year) vce(cluster state segment)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_base]/_se[cmag_prez_ptya_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptya_base] \ _se[cmag_prez_ptya_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))

reghdfe turnout cmag_prez_ptya_base i.state#c.lag_turnout_pres `interc' $controls, absorb(state_pair_year) vce(cluster state segment)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_base]/_se[cmag_prez_ptya_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptya_base] \ _se[cmag_prez_ptya_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))


reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base i.state#c.lag_vote_share2pty_ptydf $controls, absorb(state_pair_year) vce(cluster state segment)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))

reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base i.state#c.lag_vote_share2pty_ptydf `interc' $controls, absorb(state_pair_year) vce(cluster state segment)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))






*** specification: LASSO
* create LASSO variables
gen y2004=(year==2004)
gen y2012=(year==2012)
xi i.state, noomit prefix(_S)
local OLScontrols = "$controls lag_vote_share2pty_ptydf lag_turnout_pres"
*local OLScontrols = "$controls"
local O
local counter = 1
foreach w of local OLScontrols {


				quietly : gen O`counter' = `w'
				local tempname = "O`counter'"
				local O : list O | tempname
				
				local counter = `counter'+1


}
foreach w of local OLScontrols {
	foreach x of local OLScontrols {

				quietly : gen Oa`counter' = `w' * `x'
				local tempname = "Oa`counter'"
				local Oa : list Oa | tempname
				
				local counter = `counter'+1

	}
}
foreach w of local OLScontrols {
	foreach x of varlist _Sstate_1-_Sstate_56 {

				quietly : gen Ob`counter' = `w' * `x'
				local tempname = "Ob`counter'"
				local Ob : list Ob | tempname
				
				local counter = `counter'+1

	}
}
foreach w of local OLScontrols {
	foreach x of varlist y2004 y2012 {

				quietly : gen Oc`counter' = `w' * `x'
				local tempname = "Oc`counter'"
				local Oc : list Oc | tempname
				
				local counter = `counter'+1

	}
}

gen one=1


local AllC : list O | Oa
local AllC : list AllC | Ob
local AllC : list AllC | Oc


di "TOTAL NUMBER OF POTENTIAL CONTROLS: `counter'"


* remove collinear vars;
qui : _rmcollright  `AllC'
local dropped `r(dropped)'
local AllC : list AllC - dropped	


keep O* one turnout vote_share2pty_ptydf cmag_prez_ptya_base cmag_prez_ptyd_base state_pair_year state dma_code state_county segment

* partial out FEs
hdfe O* one turnout vote_share2pty_ptydf cmag_prez_ptya_base cmag_prez_ptyd_base, absorb(state_pair_year) keepvars(state_pair_year state segment) clear

* Outcome
lassoShooting turnout `AllC' , controls(one) lasiter(100) verbose(0) fdisplay(0)
local yvSel_turnout `r(selected)'
di "`yvSel_turnout'" 

lassoShooting vote_share2pty_ptydf `AllC' , controls(one) lasiter(100) verbose(0) fdisplay(0)
local yvSel_vote `r(selected)'
di "`yvSel_vote'"



* Advertising
lassoShooting cmag_prez_ptya_base `AllC' , controls(one) lasiter(100) verbose(0) fdisplay(0)
local xvSel_turnout `r(selected)'
di "`xSel_turnout'"

lassoShooting cmag_prez_ptyd_base `AllC' , controls(one) lasiter(100) verbose(0) fdisplay(0)
local xvSel_vote `r(selected)'
di "`xSel_vote'"


* Get union of selected instruments
local vDS_turnout : list yvSel_turnout | xSel_turnout
di "`vDS_turnout'"
local vDS_vote : list yvSel_vote | xSel_vote
di "`vDS_vote'"



* LASSO: turnout
reghdfe turnout cmag_prez_ptya_base `vDS_turnout', cluster(state segment) absorb(one)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptya_base]/_se[cmag_prez_ptya_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptya_base] \ _se[cmag_prez_ptya_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))


* LASSO: vote shares
reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base `vDS_vote' , cluster(state segment) absorb(one)
local pvalue = (2*ttail(e(df_r),abs(_b[cmag_prez_ptyd_base]/_se[cmag_prez_ptyd_base])))
matrix TABLE = (nullmat(TABLE), (_b[cmag_prez_ptyd_base] \ _se[cmag_prez_ptyd_base] \ `pvalue' \ . \ . \ e(r2) \ e(N)))












*** nearest-neighbor matching
global RUNS = 1000
use input/sample_allcounties.dta, clear


* drop states w/ only one media market
by state year, sort: egen dummy=sd(dma_code)
drop if dummy==0
drop dummy



* define "treatment indicators"
by state year: egen dummy=median(cmag_prez_ptya_base)
gen Tall=(cmag_prez_ptya_base>dummy)
drop dummy
by state year: egen dummy1=count(Tall)
by state year: egen dummy2=total(Tall)
gen sample_all=(dummy1>=5 & dummy2>=5)
drop dummy*
by state year: egen dummy=median(cmag_prez_ptyd_base)
gen Tdiff=(cmag_prez_ptyd_base>dummy)
drop dummy
by state year: egen dummy1=count(Tdiff)
by state year: egen dummy2=total(Tdiff)
gen sample_diff=(dummy1>=5 & dummy2>=5)
drop dummy*

* save temp data sets for bootstrapping
tempfile data_diff
tempfile data_all
preserve
keep if sample_diff==1
save `data_diff'
restore
preserve
keep if sample_all==1
save `data_all'
restore


* point estimates
teffects nnmatch (cmag_prez_ptyd_base $extra_controls_ptyd $demo_controls lag_vote_share2pty_ptydf) (Tdiff) if sample_diff, vce(iid) ematch(year state) biasadj($extra_controls_ptyd $demo_controls lag_vote_share2pty_ptydf) nneighbor(1)
matrix b= e(b)
local pe_diff = b[1,1]
teffects nnmatch (vote_share2pty_ptydf $extra_controls_ptyd $demo_controls lag_vote_share2pty_ptydf) (Tdiff) if sample_diff, vce(iid) ematch(year state) biasadj($extra_controls_ptyd $demo_controls lag_vote_share2pty_ptydf) gen(distance_diff_nn) nneighbor(1)
matrix b= e(b)
local pe_vote = b[1,1]
local N_diff = e(N)

local effect_diff = `pe_vote'/`pe_diff'
di "Effect *diff*: `effect_diff'"


teffects nnmatch (cmag_prez_ptya_base $extra_controls_ptya $demo_controls lag_turnout_pres) (Tall) if sample_all, vce(iid) ematch(year state) biasadj($extra_controls_ptya $demo_controls lag_turnout_pres) nneighbor(1)
matrix b= e(b)
local pe_all = b[1,1]
teffects nnmatch (turnout $extra_controls_ptya $demo_controls lag_turnout_pres) (Tall) if sample_all, vce(iid) ematch(year state) biasadj($extra_controls_ptya $demo_controls lag_turnout_pres) gen(distance_all_nn) nneighbor(1)
matrix b= e(b)
local pe_turnout = b[1,1]
local N_all = e(N)

local effect_all = `pe_turnout'/`pe_all'
di "Effect *all*: `effect_all'"


** bootstrapping (*all*)
use `data_all', clear

tempfile bsresults_all
postfile bskeep_all bsest using `bsresults_all', replace


distinct state if sample_all
local n = r(ndistinct)
local b = round(`n'/3)
di "n: `n'   b: `b'"

forvalues q=1(1)$RUNS {
    
    quietly {
        use `data_all', clear
        
        * draw subsamples of size b
        gen u=uniform()
        by state: gen t=u[1]
        egen number=group(t)
        keep if number<=`b'
        
        teffects nnmatch (cmag_prez_ptya_base $extra_controls_ptya $demo_controls lag_turnout_pres) (Tall) if sample_all, vce(iid) ematch(year state) biasadj($extra_controls_ptya $demo_controls lag_turnout_pres)
        matrix b= e(b)
        local pe_all = b[1,1]
        teffects nnmatch (turnout $extra_controls_ptya $demo_controls lag_turnout_pres) (Tall) if sample_all, vce(iid) ematch(year state) biasadj($extra_controls_ptya $demo_controls lag_turnout_pres)
        matrix b= e(b)
        local pe_turnout = b[1,1]

        local pe = `pe_turnout'/`pe_all'
        
        post bskeep_all (`pe')
    }

}
postclose bskeep_all 




** bootstrapping (*diff*)
use `data_diff', clear

tempfile bsresults_diff
postfile bskeep_diff bsest using `bsresults_diff', replace


distinct state if sample_diff
local n = r(ndistinct)
local b = round(`n'/3)
di "n: `n'   b: `b'"

forvalues q=1(1)$RUNS {
    
    quietly {
        use `data_diff', clear
        
        * draw subsamples of size b
        gen u=uniform()
        by state: gen t=u[1]
        egen number=group(t)
        keep if number<=`b'
        
        teffects nnmatch (cmag_prez_ptyd_base $extra_controls_ptyd $demo_controls lag_vote_share2pty_ptydf) (Tdiff) if sample_diff, vce(iid) ematch(year state) biasadj($extra_controls_ptyd $demo_controls lag_vote_share2pty_ptydf)
        matrix b= e(b)
        local pe_diff = b[1,1]
        teffects nnmatch (vote_share2pty_ptydf $extra_controls_ptyd $demo_controls lag_vote_share2pty_ptydf) (Tdiff) if sample_diff, vce(iid) ematch(year state) biasadj($extra_controls_ptyd $demo_controls lag_vote_share2pty_ptydf)
        matrix b= e(b)
        local pe_vote = b[1,1]
        
        local pe = `pe_vote'/`pe_diff'
        
        post bskeep_diff (`pe')
    }

}
postclose bskeep_diff 


* display results
use `bsresults_all', clear

gen z_star = (bsest - `effect_all')*(`b'/`n')^.5

sum z_star
di "Effect *all*: `effect_all'"
di "SE:" r(sd)
local p = (2*ttail(1000,abs(`effect_all'/r(sd))))
matrix TABLE = (nullmat(TABLE), (`effect_all' \ r(sd) \ `p' \ . \ . \ . \ `N_all'))


use `bsresults_diff', clear

gen z_star = (bsest - `effect_diff')*(`b'/`n')^.5

sum z_star
di "Effect *diff*: `effect_diff'"
di "SE:" r(sd)
local p = (2*ttail(1000,abs(`effect_diff'/r(sd))))
matrix TABLE = (nullmat(TABLE), (`effect_diff' \ r(sd) \ `p' \ . \ . \ . \ `N_diff'))





matrix rownames TABLE = b se p fstat pvalue_all r2 n
putexcel set output/tables.xlsx, sheet("extra_robust", replace) modify
putexcel A1=matrix(TABLE), rownames


log close

