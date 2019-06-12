clear
set mem 24g
set matsize 11000
set maxvar 11000
set more off
capture log close

global june "~/projecttwo/datanew/data"

global apr "~/projecttwo/results/results05092018" 

/*---------------------------------------------------------------------------------------------------------------------------------------------------
This file is used to estimate the effect of punishment by different author social status. 
-----------------------------------------------------------------------------------------------------------------------------------------------------*/
log using "$apr/step1_main_regresions.log", replace
local list0 "papers_tot cites_tot h_index"
local list1 "papers_tot_top_w_s cites_tot_top_w_s h_index_top_w_s"
local list2 "papers_tot_top cites_tot_top h_index_top"
local list3 "papers_tot_up cites_tot_up h_index_up"

/********---------------------------------------Main Tables:2-5 and Model 1 & 10 in Table A1, A2 and A3------------------------**********/
use "$june/C2_full_original.dta", clear
gen scandal0=.

replace scandal0=-1 if citationyear1<eventyear
replace scandal0=0 if citationyear1==eventyear
replace scandal0=1 if citationyear1>eventyear

gen dif_in_dif_year0=0
replace dif_in_dif_year0=1 if treated==1 & scandal0==0

gen dif_in_dif_year1=0
replace dif_in_dif_year1=1 if treated==1 & scandal0==1

save "$june/C2_full_01202015.dta", replace

use $june/C2_full_01202015.dta, clear
gen papers_tot_top_w=papers_tot/1000
gen cites_tot_top_w=cites_tot/10000
gen h_index_top_w=h_index/100

keep if avg_distance_to_treated==0
drop if eventyear>2009

/***Standardization at the author level****/
gen papers_tot_top_w_s=(papers_tot_top_w-.0244918)/.1147781 
gen cites_tot_top_w_s=(cites_tot_top_w-.1071419)/.3569609 
gen h_index_top_w_s=(h_index_top_w-.0958197)/.1357253 
gen mem_sh_s=(mem_sh-.4969034)/.3120696 
gen tot_coau_s=(tot_coau- 6.07377)/ 4.437438  


/***C2_zero: Main***/
/***Absolute Measures***/

xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.year_since_publication, fe cluster(item_retract)
est store a_`var'

capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.ranking*dif_in_dif_year0 i.ranking*dif_in_dif_year1 i.ranking*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'

}
outreg2 [a_* b_*] using  "$apr/TableA1_am1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

xtset paperid year_since_publication
foreach var of local list2 {

xtset paperid year_since_publication
capture noisily xi: xtpqml yearly_citations1 i.`var'*dif_in_dif_year0 i.`var'*dif_in_dif_year1 i.`var'*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store c_`var'
}

outreg2 [c_*] using  "$apr/TableA1_am2.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Relative Measures***/
xtset paperid year_since_publication
foreach var of local list0 {

capture noisily xi: xtpqml yearly_citations1 i.`var'_most_team*dif_in_dif_year0 i.`var'_most_team*dif_in_dif_year1 i.`var'_most_team*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`i'
}
outreg2 [ b_*] using  "$apr/TableA2_rm1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


xtset paperid year_since_publication
foreach var of local list3 {
forvalue i=5(1)5 {

capture noisily xi: xtpqml yearly_citations1 i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`i'

capture noisily xi: xtpqml yearly_citations1 i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.ranking*dif_in_dif_year0 i.ranking*dif_in_dif_year1 i.ranking*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store c_`var'_`i'

}
}
outreg2 [b_* c_*] using  "$apr/TableA2_rm2.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Coauthor Effects***/
foreach var of local list2 {

xtset paperid year_since_publication
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.year_since_publication, fe cluster(item_retract)
est store a_`var'

capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.ranking*dif_in_dif_year0 i.ranking*dif_in_dif_year1 i.ranking*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store c_`var'

}

outreg2 [a_* c_*] using  "$apr/TableA3_coauthor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/****Team Composition***/
xtset paperid year_since_publication

foreach var in h_index_top {

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication if `var'==1, fe cluster(item_retract)
est store em_`var'

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication if `var'==0, fe cluster(item_retract)
est store np_`var'

capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication, fe cluster(item_retract)
est store all_`var'

capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.ranking*dif_in_dif_year0 i.ranking*dif_in_dif_year1 i.ranking*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store allr_`var'
}

outreg2 [em_* np_* all_* allr_*] using  "$apr/TableA5.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/**************************************************************************************************************************************************************************/
/*******************************************OLS: Table A8 and Model 6 in Table A1, A2 and A3********************************************************/
/***Different Samples***/

/***Absolute Measures***/
gen lnyearly_citations1=log(yearly_citations1)


/****Absolute Measures***/
xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtreg lnyearly_citations1 i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.year_since_publication, fe cluster(item_retract)
est store a_`var'
}

outreg2 [a_*] using  "$apr/TableC1_am1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Relative Measures***/
xtset paperid year_since_publication
foreach var of local list3 {
forvalue i=5(1)5 {

capture noisily xi: xtreg lnyearly_citations1 i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`i'
}
}
outreg2 [b_*] using  "$apr/TableC2_rm.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Coauthor Effects***/
foreach var of local list2 {

xtset paperid year_since_publication
capture noisily xi: xtreg lnyearly_citations1 i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.year_since_publication, fe cluster(item_retract)
est store a_`var'

}

outreg2 [a_* ] using  "$apr/TableC3_coauthor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

/***Team Composition***/
xtset paperid year_since_publication

foreach var in h_index_top {

capture noisily xi: xtreg lnyearly_citations1 i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication, fe cluster(item_retract)
est store all_`var'

capture noisily xi: xtreg lnyearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s  i.year_since_publication if `var'==1, fe cluster(item_retract)
est store s1_`var'

capture noisily xi: xtreg lnyearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication if `var'==0, fe cluster(item_retract)
est store s0_`var'
}

outreg2 [all_* s1_* s0_*] using  "$apr/TableC5.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/*****************************************Old Papers:Table A4 and Model 2 in Table A1, A2 and A3*********************************************************************/
keep if publishyear<eventyear & publishyear>=eventyear-9
/***Absolute Measures***/

xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.year_since_publication, fe cluster(item_retract)
est store a_`var'
}
outreg2 [a_*] using  "$apr/TableD1_am1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Relative Measures***/
xtset paperid year_since_publication
foreach var of local list3 {
forvalue i=5(1)5 {

capture noisily xi: xtpqml yearly_citations1 i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`i'
}
}
outreg2 [b_*] using  "$apr/TableD2_rm.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Coauthor Effects***/
foreach var of local list2 {

xtset paperid year_since_publication
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.year_since_publication, fe cluster(item_retract)
est store a_`var'

}

outreg2 [a_*] using  "$apr/TableD3_coauthor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

/***Team Composition***/
xtset paperid year_since_publication

foreach var in h_index_top {

capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s i.dif_in_dif_year0*`var'_emi_s i.dif_in_dif_year1*`var'_emi_s i.scandal0*`var'_emi_s i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication, fe cluster(item_retract)
est store all_`var'

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==1, fe cluster(item_retract)
est store s1_`var'

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==0, fe cluster(item_retract)
est store s0_`var'
}

outreg2 [all_* s1_* s0_*] using  "$apr/TableD5.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear
clear


/*****************************************************************************Left Censored: Table A5 and Model 3 in Table A1, A2 and A3************************************************/
use $june/priorwork/C2_full_01202015.dta, clear
gen previousyear=0
replace previousyear=1 if citationyear1==eventyear-1
gen tempcite=.
replace tempcite=yearly_citations1 if previousyear==1 & treated==1
bysort scandalid: egen dying=max(tempcite)
drop if dying==0
drop previousyear tempcite dying

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
outreg2 [a_*] using  "$apr/TableE1_am1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

/***Relative Measures***/
xtset paperid year_since_publication
foreach var of local list3 {
forvalue i=5(1)5 {

capture noisily xi: xtpqml yearly_citations1 i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`i'
}
}
outreg2 [b_*] using  "$apr/TableE2_rm.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Coauthor Effects***/

foreach var of local list2 {

xtset paperid year_since_publication
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.year_since_publication, fe cluster(item_retract)
est store a_`var'

}

outreg2 [a_*] using  "$apr/TableE3_coauthor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Team Composition***/
xtset paperid year_since_publication

foreach var in h_index_top {

capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s i.dif_in_dif_year0*`var'_emi_s i.dif_in_dif_year1*`var'_emi_s i.scandal0*`var'_emi_s i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication, fe cluster(item_retract)
est store all_`var'

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==1, fe cluster(item_retract)
est store s1_`var'

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==0, fe cluster(item_retract)
est store s0_`var'
}

outreg2 [all_* s1_* s0_*] using  "$apr/TableE5.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear



/**********************************************************************Self Citations: Table A7 and Model 5 in Table A1, A2 and A3********************************************************/
use $june/priorwork/C2_full_01202015.dta, clear
sort item_ut citationyear1
merge item_ut citationyear1 using "~/projecttwo/datanew/selfcitationcounts_12102012.dta"
tab _m
drop if _m==2
/***46 papers were cited before officially published***/
replace self_cites=0 if _m==1
drop _m
gen yearly_citations_noself=yearly_citations1-self_cites
sum yearly_citations_noself, de
replace yearly_citations_noself=. if yearly_citations_noself<0

gen yearly_citations_new=yearly_citations1
replace yearly_citations_new=yearly_citations_noself if citationyear1>=eventyear
label var yearly_citations1 "Yearly Citations in WOS"
label var yearly_citations_noself "Yearly Citations minus Self Citations"
label var yearly_citations_new "Yearly Citations minus self citations after retraction"

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


xtset paperid year_since_publication
/***Different Samples***/
/***Absolute Measures***/

xtset paperid year_since_publication

foreach var of local list1 {
capture noisily xi: xtpqml yearly_citations_new i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.year_since_publication, fe cluster(item_retract)
est store a_`var'
}
outreg2 [a_*] using  "$apr/TableF1_am1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

/***Relative Measures***/
xtset paperid year_since_publication
foreach var of local list3 {
forvalue i=5(1)5 {

capture noisily xi: xtpqml yearly_citations_new i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`i'
}
}
outreg2 [b_*] using  "$apr/TableF2_rm.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Coauthor Effects***/

foreach var of local list2 {

xtset paperid year_since_publication
capture noisily xi: xtpqml yearly_citations_new i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.year_since_publication, fe cluster(item_retract)
est store a_`var'

}

outreg2 [a_*] using  "$apr/TableF3_coauthor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

/***Team Composition***/
xtset paperid year_since_publication

foreach var in h_index_top {

capture noisily xi: xtpqml yearly_citations_new i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s i.dif_in_dif_year0*`var'_emi_s i.dif_in_dif_year1*`var'_emi_s i.scandal0*`var'_emi_s i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication, fe cluster(item_retract)
est store all_`var'

capture noisily xi: xtpqml yearly_citations_new   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==1, fe cluster(item_retract)
est store s1_`var'

capture noisily xi: xtpqml yearly_citations_new   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==0, fe cluster(item_retract)
est store s0_`var'
}

outreg2 [all_* s1_* s0_*] using  "$apr/TableF5.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

clear
/***********************************************************Table A11 and Model 9 in Table A1, A2 and A3: drop three years*******************************************************/
use $june/priorwork/C2_full_01202015.dta, clear
gen papers_tot_top_w=papers_tot/1000
gen cites_tot_top_w=cites_tot/10000
gen h_index_top_w=h_index/100

drop if publishyear<eventyear & publishyear>=eventyear-3

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
outreg2 [a_*] using  "$apr/TableG1_am1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

/***Relative Measures***/
xtset paperid year_since_publication
foreach var of local list3 {
forvalue i=5(1)5 {

capture noisily xi: xtpqml yearly_citations1 i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.year_since_publication, fe cluster(item_retract)
est store b_`var'_`i'
}
}
outreg2 [b_*] using  "$apr/TableG2_rm.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Coauthor Effects***/

foreach var of local list2 {

xtset paperid year_since_publication
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.year_since_publication, fe cluster(item_retract)
est store a_`var'

}

outreg2 [a_*] using  "$apr/TableG3_coauthor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Team Composition***/
xtset paperid year_since_publication

foreach var in h_index_top {

capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s i.dif_in_dif_year0*`var'_emi_s i.dif_in_dif_year1*`var'_emi_s i.scandal0*`var'_emi_s i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication, fe cluster(item_retract)
est store all_`var'

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==1, fe cluster(item_retract)
est store s1_`var'

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==0, fe cluster(item_retract)
est store s0_`var'
}

outreg2 [all_* s1_* s0_*] using  "$apr/TableG5.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear
clear

/***********************************************************Table A9 and Model 7 in Table A1, A2 and A3: clustered by treated/control group*******************************************************/
use $june/priorwork/C2_full_01202015.dta, clear
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
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var' i.dif_in_dif_year1*`var' i.scandal0*`var' i.year_since_publication, fe cluster(item_treated)
est store a_`var'
}
outreg2 [a_*] using  "$apr/TableB1_am1.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

/***Relative Measures***/
xtset paperid year_since_publication
foreach var of local list3 {
forvalue i=5(1)5 {

capture noisily xi: xtpqml yearly_citations1 i.`var'`i'*dif_in_dif_year0 i.`var'`i'*dif_in_dif_year1 i.`var'`i'*i.scandal0 i.year_since_publication, fe cluster(item_treated)
est store b_`var'_`i'
}
}
outreg2 [b_*] using  "$apr/TableB2_rm.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Coauthor Effects***/

foreach var of local list2 {

xtset paperid year_since_publication
capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*i.`var'_cat i.dif_in_dif_year1*i.`var'_cat i.scandal0*i.`var'_cat i.year_since_publication, fe cluster(item_treated)
est store a_`var'

}

outreg2 [a_*] using  "$apr/TableB3_coauthor.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear


/***Team Composition***/
xtset paperid year_since_publication

foreach var in h_index_top {

capture noisily xi: xtpqml yearly_citations1 i.dif_in_dif_year0*`var'_w_s i.dif_in_dif_year1*`var'_w_s i.scandal0*`var'_w_s i.dif_in_dif_year0*`var'_emi_s i.dif_in_dif_year1*`var'_emi_s i.scandal0*`var'_emi_s i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s i.dif_in_dif_year0*tot_coau_s i.dif_in_dif_year1*tot_coau_s i.scandal0*tot_coau_s i.year_since_publication, fe cluster(item_treated)
est store all_`var'

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==1, fe cluster(item_treated)
est store s1_`var'

capture noisily xi: xtpqml yearly_citations1   i.dif_in_dif_year0*mem_sh_s i.dif_in_dif_year1*mem_sh_s i.scandal0*mem_sh_s  i.year_since_publication if `var'==0, fe cluster(item_treated)
est store s0_`var'
}

outreg2 [all_* s1_* s0_*] using  "$apr/TableB5.csv", title("The Spillover Effects of Retraction") dec(3) drop(_Iyear*) word replace
est clear

log close


