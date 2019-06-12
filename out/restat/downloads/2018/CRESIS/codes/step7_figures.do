clear
set mem 24g
set matsize 11000
set maxvar 11000
set more off
capture log close

global june "~/projecttwo/datanew"
global data "~/projecttwo/datanew/data"
global apr "~/projecttwo/results/results05092018"  

/*---------------------------------------------------------------------------------------------------------------------------------------------------
This file is used to estimate the yearly effect of punishment by different author social status. The coeffietns are used to draw figure 2.
-----------------------------------------------------------------------------------------------------------------------------------------------------*/
log using "$apr/C2_figures.log", replace

use $data/C2_full_01202015.dta, clear

keep if avg_distance_to_treated==0
drop if eventyear>2009

preserve
xtset paperid year_since_publication

capture noisily xi: xtpqml yearly_citations1 i.bin4*treated i.year_since_publication, fe cluster(item_retract)
est store eminent

outreg2 [e*] using  "$apr/TableN0_all.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear
restore

preserve
keep if h_index_top==1

xtset paperid year_since_publication

capture noisily xi: xtpqml yearly_citations1 i.bin4*treated i.year_since_publication, fe cluster(item_retract)
est store eminent

outreg2 [e*] using  "$apr/TableN1_absolute.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear
restore

preserve
keep if h_index_top==0

xtset paperid year_since_publication

capture noisily xi: xtpqml yearly_citations1 i.bin4*treated i.year_since_publication, fe cluster(item_retract)
est store ordinary

outreg2 [o*] using  "$apr/TableN1_absolute.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word append
est clear
restore

preserve
keep if h_index_most_team==1

xtset paperid year_since_publication

capture noisily xi: xtpqml yearly_citations1 i.bin4*treated i.year_since_publication, fe cluster(item_retract)
est store eminent

outreg2 [e*] using  "$apr/TableN2_relative.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear
restore

preserve
keep if h_index_most_team==0

xtset paperid year_since_publication

capture noisily xi: xtpqml yearly_citations1 i.bin4*treated i.year_since_publication, fe cluster(item_retract)
est store ordinary

outreg2 [o*] using  "$apr/TableN2_relative.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word append
est clear
restore

log close
