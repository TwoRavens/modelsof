clear
set mem 24g
set matsize 11000
set maxvar 11000
set more off
capture log close

global data "~/projecttwo/datanew/data"
global apr "~/projecttwo/results/results05092018" 


/*---------------------------------------------------------------------------------------------------------------------------------------------------
This file is used to construct Tables.
-----------------------------------------------------------------------------------------------------------------------------------------------------*/
log using "$apr/C2_table1.log",replace

use $data/C2_full_01202015.dta, clear

keep if avg_distance_to_treated==0
drop if eventyear>2009


sort author item_retract
merge author item_retract using  $data/firstyear.dta
tab _m
keep if _m==3
drop _m

gen age2=eventyear-firstyear

keep if treated==1
codebook author
bysort author: gen x=_n
keep if x==1
drop x
sum papers_tot cites_tot h_index age2

foreach var in papers_tot_top cites_tot_top h_index_top {
bysort `var': sum papers_tot cites_tot h_index age
}

log close
