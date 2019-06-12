clear
*set mem 10g
*set matsize 11000
*set maxvar 11000
set more off
capture log close

global data "~/projecttwo/datanew/data"
global june "~/projecttwo/datanew"
global apr "~/projecttwo/results/results05092018" 
/*---------------------------------------------------------------------------------------------------------------------------
This file is used to generate the variables indicating the status of each author right before the event year.
We use controls with more distances.
------------------------------------------------------------------------------------------------------------------------------*/
log using $apr/step4_worst_two.log, replace

/***********************************************************Table A10 and Model 8 in Table A1, A2 and A3: Worst Two Controls*******************************************************/
local list0 "papers_tot cites_tot h_index"
local list1 "papers_tot_top_w_s cites_tot_top_w_s h_index_top_w_s"
local list2 "papers_tot_top cites_tot_top h_index_top"
local list3 "papers_tot_up cites_tot_up h_index_up"

use $data/C2_worst.dta, clear
gen papers_tot_top_w=papers_tot/1000
gen cites_tot_top_w=cites_tot/10000
gen h_index_top_w=h_index/100

keep if avg_distance_to_treated==0
drop if eventyear>2009

/***Standardize****/

gen papers_tot_top_w_s=(papers_tot_top_w-.0244918)/.1147781 
gen cites_tot_top_w_s=(cites_tot_top_w-.1071419)/.3569609 
gen h_index_top_w_s=(h_index_top_w-.0958197)/.1357253 
gen papers_tot_top_emi_s=(papers_tot_top_emi-.0450265)/.1147781
gen cites_tot_top_emi_s=(cites_tot_top_emi-.0442491)/ .110675 
gen h_index_top_emi_s=(h_index_top_emi-.0386236)/.1020438  
gen mem_sh_s=(mem_sh-.4969034)/.3120696 
gen tot_coau_s=(tot_coau- 6.07377)/ 4.437438  

/***Different Samples***/
/***Absolute Measures***/

xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.year_since_publication, fe cluster(item_retract)
est store a_`var'
}
outreg2 [a_*] using  "$apr/TableH1_am1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

/***Relative Measures***/
xtset paperid year_since_publication
foreach var of local list3 {
forvalue i=5(1)5 {

capture noisily xi: xtpqml yearly_citations1 i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`i'
}
}
outreg2 [b_*] using  "$apr/TableH2_rm.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Coauthor Effects***/

foreach var of local list2 {

xtset paperid year_since_publication
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.year_since_publication, fe cluster(item_retract)
est store a_`var'

}

outreg2 [a_*] using  "$apr/TableH3_coauthor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Team Composition***/
xtset paperid year_since_publication

foreach var in h_index_top {

capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication, fe cluster(item_retract)
est store all_`var'
}

outreg2 [all_*] using  "$apr/TableH5.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear
log close
