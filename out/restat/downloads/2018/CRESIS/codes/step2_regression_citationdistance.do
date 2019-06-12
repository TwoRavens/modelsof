clear
*set mem 24g
*set matsize 11000
*set maxvar 11000
set more off
capture log close

global june "~/projecttwo/datanew/data"

global apr "~/projecttwo/results/results05092018" 

/*---------------------------------------------------------------------------------------------------------------------------------------------------
This file is used to estimate the effect of punishment by different author social status. 
We use the degree of citations to see if eminant authors with extensive fields bias the results.
-----------------------------------------------------------------------------------------------------------------------------------------------------*/

log using "$apr/step2_regression_citationdistance.log",replace
local list0 "papers_tot cites_tot h_index"
local list1 "papers_tot_top_w cites_tot_top_w h_index_top_w"
local list2 "papers_tot_top cites_tot_top h_index_top"
local list3 "papers_tot_up cites_tot_up h_index_up"

/*****************************************************Low Citation Distance: Table A6 and Model 4 in Table A1, A2 and A3**************************/

use $june/C2_full_01202015.dta, clear

gen papers_tot_top_w=papers_tot/1000
gen cites_tot_top_w=cites_tot/10000
gen h_index_top_w=h_index/100

drop if eventyear>2009
keep if avg_distance_to_treated==0

keep if round==1


/***Standardization****/
gen papers_tot_top_w_s=(papers_tot_top_w-.0391919)/.0553398 
gen cites_tot_top_w_s=(cites_tot_top_w-.1584393)/ .317795 
gen h_index_top_w_s=(h_index_top_w-.143062)/.1511059  
gen mem_sh_s=(mem_sh-.4524285)/.3106033 
gen tot_coau_s=(tot_coau-5.673406)/3.871044  


/***C2_Full Samples: Table A1***/
/***Absolute Measures***/

xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.year_since_publication, fe cluster(item_retract)
est store a_`var'
}
outreg2 [a_*] using  "$apr/TableI1_am1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Relative Measures***/
xtset paperid year_since_publication
foreach var of local list3 {
forvalue i=5(1)5 {

capture noisily xi: xtpqml yearly_citations1 i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`i'
}
}
outreg2 [b_*] using  "$apr/TableI2_rm.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Coauthor Effects***/

foreach var of local list2 {
xtset paperid year_since_publication
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.year_since_publication, fe cluster(item_retract)
est store a_`var'
}

outreg2 [a_*] using  "$apr/TableI3_coauthor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

/***Team Composition***/
xtset paperid year_since_publication

foreach var in h_index_top {
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s  i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication, fe cluster(item_retract)
est store all_`var'
}

outreg2 [all_*] using  "$apr/TableI5.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear
clear

