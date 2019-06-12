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


log using output/log_figureA4.txt, replace text



include code/set_globals.do



*-------------------------------------------------------
* figure A4
*-------------------------------------------------------

use input/sample_pairdfs.dta, clear


gen difference_all = abs(cmag_prez_ptya_base1 - cmag_prez_ptya_base2)
gen difference_pdiff = abs(cmag_prez_ptyd_base1 - cmag_prez_ptyd_base2)


hist difference_all, width(1) freq
graph play code/figureA4a.grec
graph save output/figureA4a.gph, replace
graph export output/figureA4a.eps, replace


hist difference_pdiff, width(1) freq
graph play code/figureA4b.grec
graph save output/figureA4b.gph, replace
graph export output/figureA4b.eps, replace




* robustness of main results to excluding "low difference" border-county pairs
use input/sample_countypairs.dta, clear

by state_pair_year, sort: egen mean_diff = mean(cmag_prez_ptyd_base)
gen pair_diff_diff= abs(2*mean_diff - 2*cmag_prez_ptyd_base)
by state_pair_year, sort: egen mean_all = mean(cmag_prez_ptya_base)
gen pair_diff_all= abs(2*mean_all - 2*cmag_prez_ptya_base)


reghdfe turnout cmag_prez_ptya_base $extra_controls_ptya $demo_controls , absorb(state_county state_pair_year) vce(cluster state)
reghdfe turnout cmag_prez_ptya_base $extra_controls_ptya $demo_controls if pair_diff_all>1, absorb(state_county state_pair_year) vce(cluster state)


reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base $extra_controls_ptyd $demo_controls , absorb(state_county state_pair_year) vce(cluster state)
reghdfe vote_share2pty_ptydf cmag_prez_ptyd_base $extra_controls_ptyd $demo_controls if pair_diff_diff>1, absorb(state_county state_pair_year) vce(cluster state)





log close

