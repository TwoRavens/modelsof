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


log using output/log_figureA5.txt, replace text



include code/set_globals.do

*---------------------------------------------------------------------------------------------
* figure A5
*---------------------------------------------------------------------------------------------

use input/sample_countypairs, clear

tempfile pvals
postfile p_data p using `pvals', replace


*standardize vars
foreach var in cmag_prez_ptya_base cmag_prez_dem_base cmag_prez_rep_base cmag_prez_ptyd_base cmag_oth_ptya_base $race_controls $other_controls $media_controls {
    egen `var'_std = std(`var')
}  


foreach depvar in prez_ptya_base prez_dem_base prez_rep_base prez_ptyd_base oth_ptya_base { 
    
    * run single covariate regressions
    foreach indepvar in $race_controls_std $other_controls_std $media_controls_std {
    	reghdfe cmag_`depvar'_std `indepvar', absorb(state_county state_pair_year) vce(cluster state segment)
	local b = _b[`indepvar']
	local se = _se[`indepvar']
	test `indepvar' = 0
	local p = r(p)
	post p_data (`p')
	matrix TABLE_COL = (nullmat(TABLE_COL) \  (`b' , `se' , `p'))
    }

    matrix colnames TABLE_COL = `depvar'_b `depvar'_se `depvar'_p
    matrix TABLE_ROW = (nullmat(TABLE_ROW) , TABLE_COL)    
    matrix drop TABLE_COL
    

}
postclose p_data

matrix rownames TABLE_ROW = $race_controls_std $other_controls_std $media_controls_std
putexcel set output/tables.xlsx, sheet("correlation_single_var", replace) modify
putexcel A1=matrix(TABLE_ROW), names


use `pvals', clear

ksmirnov p=p

sort p
cumul p, generate(cdf)

local new = _N + 2
set obs `new'

gen x=p
replace x = 1 if _n==_N
replace p = 1 if _n==_N
replace cdf = 1 if _n==_N
replace x = 0 if _n==_N-1
replace p = 0 if _n==_N-1
replace cdf = 0 if _n==_N-1

sort p
twoway (line cdf p) (line x p)
graph play code/figureA5.grec
graph save output/figureA5.gph, replace
graph export output/figureA5.eps, replace

log close