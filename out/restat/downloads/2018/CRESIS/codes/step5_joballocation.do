clear
*set mem 12g
*set matsize 11000
*set maxvar 11000
set more off
capture log close

global june "~/projecttwo/datanew"
global data "~/projecttwo/datanew/data"
global apr "~/projecttwo/results/results05092018" 

/*---------------------------------------------------------------------------------------------------------------------------------------------------
This file is used to estimate the effect of punishment by different author social status: exploration
by social status when making the retraction papers. 

Table A15
-----------------------------------------------------------------------------------------------------------------------------------------------------*/
log using "$apr/joballocation.log", replace

local list1 "papers_tot cites_tot h_index"

use $data/C2_full_01202015.dta, clear
sort author item_retract
merge author item_retract using $june/author_publish_1212.dta
tab _m
local list2 "papers_tot_top_publish cites_tot_top_publish h_index_top_publish"
foreach var of local list2 {
replace `var'=0 if `var'==. & _m==1
}
drop _m

keep if avg_distance_to_treated==0
drop if eventyear>2009

/***Clustered by Retarction***/

xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtpqml yearly_citations1 i.`var'_top*dif_in_dif_year0 i.`var'_top*dif_in_dif_year1 i.`var'_top*i.scandal0 i.`var'_top_publish*dif_in_dif_year0 i.`var'_top_publish*dif_in_dif_year1 i.`var'_top_publish*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store p`var'

capture noisily xi: xtpqml yearly_citations1 i.`var'_top*dif_in_dif_year0 i.`var'_top*dif_in_dif_year1 i.`var'_top*i.scandal0 i.year_since_publication if `var'_top_publish==0, fe cluster(item_retract)
est store o`var'
}

outreg2 [p* o*] using  "$apr/TableM1_joballocation_am.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


log close

