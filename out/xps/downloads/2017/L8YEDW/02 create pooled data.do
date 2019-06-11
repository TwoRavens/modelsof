set more off
clear

*-----------------------
*** CREATE POOLED DATA ***
*-----------------------

use "$path/main_fr.dta"
gen country=1 //"France"

* Load German data
append using "$path/main_ge.dta"
replace country=2 if country>1 //"Germany" 

* Load UK data
append using "$path/main_uk.dta"
replace country=3 if country>2 //"UK" 

* Load US data
append using "$path/main_us.dta"
replace country=4 if country>3 //"US" 

label define country 1 "France" 2 "Germany" 3 "United Kingdom" 4 "United States"
label values country country

*label variable altru_howmuch "Donation (£, Û, $)"

label var recip_own_contrib "Contribution to Other (Û, £, $)"
label var altru_howmuch "Altruism: Donation to Charity (Û, £, $)"

label var altru_donate "Donates:"
*label define donate 0 "No" 1 "Yes"
label values altru_donate donate

tab altru_donate country, col
xtset ID

* Marital status
gen married=0
replace married=1 if marstat==1

gen separated=0
replace separated=1 if marstat==2

gen divorced=0
replace divorced=1 if marstat==3 

gen widowed=0
replace widowed=1 if marstat==4 

gen dompart=0
replace dompart=1 if marstat==6 
 

* Altruism and expected contribution: Three categories based on distribution
gen altru_high=.
su altru_howmuch, det

replace altru_high=0 if altru_howmuch<=`r(p50)'
replace altru_high=1 if altru_howmuch>`r(p50)' & altru_howmuch<=100

label define two_lab 0 "Low" 1 "High"
label values altru_high two_lab

tab altru_high

gen recip_expect_cat=.
label var recip_expect_cat "Expected Contribution Other: 1=low, 2=medium, 3=high"
su recip_expect_contrib, det
replace recip_expect_cat=1 if recip_expect_contrib<=`r(p25)'
replace recip_expect_cat=2 if recip_expect_contrib>`r(p25)' & recip_expect_contrib<=`r(p75)'
replace recip_expect_cat=3 if recip_expect_contrib>`r(p75)' & recip_expect_contrib<=100

label define three_lab 1 "Low" 2 "Medium" 3 "High"
label values recip_expect_cat three_lab

tab recip_expect_cat, generate(recip_expect)
rename recip_expect1 recip_expect_low
rename recip_expect2 recip_expect_med
rename recip_expect3 recip_expect_high

* Treatment indicator if own or other expectation asked first
tab q2_2ab_rand_coded
gen expectationsother_asked_first=0
replace expectationsother_asked_first=1 if q2_2ab_rand_coded==1

/*Create additional treatment indicator for the contribtion experiment variables */
foreach side in other own {
gen example_`side'_306090=.
replace example_`side'_306090=0 if recip_ex_`side'_contrib==10
replace example_`side'_306090=1 if recip_ex_`side'_contrib==30
replace example_`side'_306090=1 if recip_ex_`side'_contrib==60
replace example_`side'_306090=1 if recip_ex_`side'_contrib==90
}

gen own_ex_cont=recip_ex_own_contrib
gen other_ex_cont=recip_ex_other_contrib

label var example_other_306090 "Example Other: High"
label define other_hilo 0 "Group: Other Low" 1 "Group: Other High"
label values example_other_306090 other_hilo

label var example_own_306090 "Group: Own High"
label define own_hilo 0 "Group: Own Low" 1 "Group: Own High"
label values example_own_306090 own_hilo

gen expect_catXD_highother=recip_expect_cat*example_other_306090
label var expect_catXD_highother "Interaction expected coop*high other contribution"

* All indicators for other contribution treatments
tab recip_ex_other_contrib, gen(D_)
rename D_1 D_ex_other_10
label var D_ex_other_10 "Treatment: Other gives 10"

rename D_2 D_ex_other_30
label var D_ex_other_30 "Treatment: Other gives 30"

rename D_3 D_ex_other_60
label var D_ex_other_60 "Treatment: Other gives 60"

rename D_4 D_ex_other_90
label var D_ex_other_90 "Treatment: Other gives 90"


* Create variable that measures individual's predicted contribution
* based on its contribution table

d recip_own_contrib recip_expect_contrib
gen pred_contrib_ct=.
label variable pred_contrib_ct "Predicted contribution based on strategy and expectation"
replace pred_contrib_ct=recip_own_if_other0 if recip_expect_contrib<=12.5
replace pred_contrib_ct=recip_own_if_other25 if recip_expect_contrib>12.5 & recip_expect_contrib<=37.5
replace pred_contrib_ct=recip_own_if_other50 if recip_expect_contrib>37.5 & recip_expect_contrib<=62.5
replace pred_contrib_ct=recip_own_if_other75 if recip_expect_contrib>62.5 & recip_expect_contrib<=82.5
replace pred_contrib_ct=recip_own_if_other100 if recip_expect_contrib>82.5 & recip_expect_contrib<=100
*order recip_expect_contrib  pred_contrib_ct

label var female "Female"
label var agegr30_39 "Age: 30-39"
label var agegr40_49 "Age: 40-49"
label var agegr50_59 "Age: 50-59"
label var agegr60_69 "Age: 60-69"
label var agegr70_o "Age: 70+"
label var incgr_lowermiddle "Income: Lower Middle"
label var incgr_uppermiddle "Income: Upper Middle"
label var incgr_high "Income: High"
label var educ_high "Education: High"

bysort country: tab age_groups

gen agegr30_49=0
replace agegr30_49=1 if age>=30 & age<=49
label var agegr30_49 "Age: 30-49"

gen agegr50_69=0
replace agegr50_69=1 if age>=50 & age<=69
label var agegr50_69 "Age: 50-69"

gen incgr_middle=0
replace incgr_middle=1 if incgr_lowermiddle==1 | incgr_uppermiddle==1
label var incgr_middle "Income: Middle" 

* Save pooled individual-level data in long format
label data "Bechtel/Scheve, Pooled Data"
compress
save "$path/data_wide.dta", replace

* Reshape to long format
sort ID
gen aux=_n
reshape long recip_own_if_other, i(ID) j(contrib_other)
gen contrib_own=recip_own_if_other
order ID contrib_other contrib_own
label var contrib_own "Own contribution (in Û/£/$)"
label var contrib_other "Contribution other (in Û/£/$)"
* Min and max contributions
gen contrib_min=.
gen contrib_max=.
set more off
su aux
local start=`r(min)'
local end=`r(max)'

forvalues i=`start'(1)`end' {
display "Observation `i'"
su contrib_own if aux==`i'
qui replace contrib_min=`r(min)' if aux== `i'
qui replace contrib_max=`r(max)' if aux== `i'
}
order ID contrib_other contrib_own contrib_min contrib_max
sort ID
compress
label data "Bechtel/Scheve, Pooled Data (Long Format)"
save "$path/data_long.dta", replace


exit

