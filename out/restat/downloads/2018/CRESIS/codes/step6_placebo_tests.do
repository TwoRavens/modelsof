set mem 5g
set more off
capture log close

global data "~/projecttwo/datanew/"

global apr "~/projecttwo/results/results05092018" 

log using $apr/step6_placebo_tests.log, replace

use $data/sample500_11282013.dta, clear
sort item_ut
merge item_ut using $data/team_status
tab _m
keep if _m==3
drop _m
sort scandalid item_ut
merge scandalid item_ut using $data/testsample, nokeep
tab _m
drop _m

gen year_since_publication=citationyear1-publishyear+1

egen paperid=group(scandalid item_ut)


xtset paperid year_since_publication

local list "h_index"
local list1 "avg mean"
foreach num of local list1 { 
foreach var of local list {
capture noisily xi: xtpqml yearly_citations1 i.scandal0*`var'_`num' i.year_since_publication, fe cluster(scandalid)
est store a_`var'_`num'

capture noisily xi: xtpqml yearly_citations1 i.scandal0*`var'_`num' i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`num'
}
}
outreg2 [a_* b_*] using  "$apr/TableP_placebo.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear
log close
