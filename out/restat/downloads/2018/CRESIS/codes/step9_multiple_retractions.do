clear
set mem 10g
*set matsize 11000
*set maxvar 11000
set more off
capture log close


global temp "D:/Matthew/datanew/"
global temp1 "D:/Matthew/datanew/temp"
global data "D:/Matthew/datanew/data"
global temp2 "D:/Matthew/data"

global apr "D:/Matthew/results/" 

/*-----------------------------------------------------------------------------------------------------------------
This file is used to generate the variables indicating the status of each author right before the event year.
On Nov 27, 2015, Imade this dofile to work on the multiple retraction cases.
I aim to see if information is not murky, will social status still play a role?

-------------------------------------------------------------------------------------------------------------------*/
log using "$apr/C2_multiple_retraction.log", replace

use $temp2/C2_multiple_nsr_16.dta, clear

local list1 "h_index_top_w_s"

gen h_index_top_w=h_index/100

keep if avg_distance_to_treated==0
drop if eventyear>2009

/***Standardize at the author level****/
gen h_index_top_w_s=(h_index_top_w-1.130473)/.6788003 

/***C2_zero: Main***/

xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.year_since_publication, fe cluster(item_retract)
est store a_`var'

}
outreg2 [a_*] using  "$apr/TableW16_multipleretarction.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

clear

/***Bad actor and innocent together***/
use $temp2/C2_multiple_innocent.dta, clear

local list1 "h_index_top_w_s"

gen h_index_top_w=h_index/100

keep if avg_distance_to_treated==0
drop if eventyear>2009

/***Standardize at the author level****/
gen h_index_top_w_s=(h_index_top_w-.8411494)/.652958

gen badactor=1-innocent

foreach var in h_index_top_w_s {
gen `var'_bad=`var'*badactor
}

xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*badactor i.dif_in_dif_year1*badactor i.scandal0*badactor i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.dif_in_dif_year0*`var'_bad i.dif_in_dif_year1*`var'_bad i.scandal0*`var'_bad i.year_since_publication, fe cluster(item_retract)
est store a_`var'
}

outreg2 [a*] using  "$apr/TableW16_badactor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

clear

/***** Innocent Actors Sample****/
use $temp2/C2_multiple_innocent.dta, clear

keep if innocent==1

local list1 "h_index_top_w_s"

gen h_index_top_w=h_index/100

keep if avg_distance_to_treated==0
drop if eventyear>2009

/***Standardize at the author level****/
gen h_index_top_w_s=(h_index_top_w-.3863986)/.1841066

xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.year_since_publication, fe cluster(item_retract)
est store a_`var'
}
outreg2 [a_*] using  "$apr/TableW16_innocent.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

clear

log close
