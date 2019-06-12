****************************************************************************
**		File name: 	policyanalysis
**		Author:		Omer Yair
**		Date: 		Final version: June 5 2015
**		Purpose: 	Produces Figure A3
**		Input:		policy.dta
*****************************************************************************

use "policy.dta"
capture log using "lpolicy.log", replace

*** recode vote: 1 = Labour Party (DNA), 2 = Conservative Party (H) 
gen vote=1 if v227==3
replace vote=2 if v227==7
tab vote

drop if v134>97
rename v134 lrself 
tab lrself

*** Recode policy items (eliminate missing values, unify liberal-conservative 
*** direction and length of scale)

* Economic policies 

rename v037 cities_keep_more_tax
recode cities_keep_more_tax (8/9=.)
replace cities_keep_more_tax=(6-cities_keep_more_tax)
label define lab_names 1 "complete disagreement" 5 "complete agreement"
label values cities_keep_more_tax lab_names
tab cities_keep_more_tax

rename v039 red_econ_diffs
recode red_econ_diffs (8/9=.)
tab red_econ_diffs

rename v093 accept_bigger_wage_diffs
recode accept_bigger_wage_diffs (8/9=.)
replace accept_bigger_wage_diffs=(6-accept_bigger_wage_diffs)
label define lab_names2 1 "strongly disagree" 5 "strongly agree"
label values accept_bigger_wage_diffs lab_names2
tab accept_bigger_wage_diffs

rename v095 allow_private_schools
recode allow_private_schools (8/9=.)
replace allow_private_schools=(6-allow_private_schools)
label values allow_private_schools lab_names2
tab allow_private_schools

rename v096 public_serv_over_red_taxs
recode public_serv_over_red_taxs (8/9=.)
tab public_serv_over_red_taxs

rename v186 public_activities_w_private
recode public_activities_w_private (8/9=.)
replace public_activities_w_private=(6-public_activities_w_private)
label values public_activities_w_private lab_names2
tab public_activities_w_private

rename v187 high_inc_more_tax
recode high_inc_more_tax (8/9=.)
tab high_inc_more_tax

rename v214 abolish_wealth_tax
recode abolish_wealth_tax (8/9=.)
replace abolish_wealth_tax=(6-abolish_wealth_tax)
label values abolish_wealth_tax lab_names2
tab abolish_wealth_tax

* Social policies 

rename v033 relig_educ
recode relig_educ (98/99=.)
replace relig_educ=(10-relig_educ)
replace relig_educ=(relig_educ*0.4)+1
label define lab_names_relig_educ 1 "voluntary relig. educ." 5 "mandatory relig. educ."
label values relig_educ lab_names_relig_educ
tab relig_educ

rename v041 church_state_sep
recode church_state_sep (8/9=.)
tab church_state_sep

rename v092 abortion
recode abortion (8/9=.)
replace abortion=(5-abortion)
replace abortion=((abortion-1)*(4/3)+1)
label define lab_names_abortion 1 "self-determined abortion" 5 "abortion should never be permitted"
label values abortion lab_names_abortion
tab abortion

rename v189 christian_val
recode christian_val (8/9=.)
replace christian_val=(6-christian_val)
label values christian_val lab_names2
tab christian_val

rename v208 gays_samerights
recode gays_samerights (8/9=.)
tab gays_samerights

rename v213 euthanasia
recode euthanasia (8/9=.)
tab euthanasia

*** Generate a binary variable for region (West=0, Oslo=1)

gen oslo_west=1 if v311==1
replace oslo_west=0 if v311==4
label define lab_oslo_west 0 "West" 1 "Oslo"
label values oslo_west lab_oslo_west
tab oslo_west v311

*** Compare average positions of Labour supporters in the two regions on each 
*** policy item. Then calculate the nation-wide average position among Labour supporters
*** on each policy item.

/** Economic policies **/
ttest cities_keep_more_tax if vote==1, by (oslo_west) welch 
ttest red_econ_diffs if vote==1, by (oslo_west) welch 
ttest accept_bigger_wage_diffs if vote==1, by (oslo_west) welch 
ttest allow_private_schools if vote==1, by (oslo_west) welch 
ttest public_serv_over_red_taxs if vote==1, by (oslo_west) welch 
ttest public_activities_w_private if vote==1, by (oslo_west) welch 
ttest high_inc_more_tax if vote==1, by (oslo_west) welch 
ttest abolish_wealth_tax if vote==1, by (oslo_west) welch 

sum cities_keep_more_tax if vote==1 
sum red_econ_diffs if vote==1 
sum accept_bigger_wage_diffs if vote==1 
sum allow_private_schools if vote==1
sum public_serv_over_red_taxs if vote==1 
sum public_activities_w_private if vote==1
sum high_inc_more_tax if vote==1
sum abolish_wealth_tax if vote==1 

/** social policies  **/
ttest relig_educ if vote==1, by (oslo_west) welch 
ttest church_state_sep if vote==1, by (oslo_west) welch 
ttest abortion if vote==1, by (oslo_west) welch 
ttest christian_val if vote==1, by (oslo_west) welch 
ttest gays_samerights if vote==1, by (oslo_west) welch 
ttest euthanasia if vote==1, by (oslo_west) welch 

sum relig_educ if vote==1 
sum church_state_sep if vote==1
sum abortion if vote==1
sum christian_val if vote==1
sum gays_samerights if vote==1
sum euthanasia if vote==1

*** Compare average positions of Conservative Party supporters in the two regions on each 
*** policy item. Then calculate the nation-wide average position among Conservative 
*** Party supporters on each policy item.

/** Economic policies **/
ttest cities_keep_more_tax if vote==2, by (oslo_west) welch 
ttest red_econ_diffs if vote==2, by (oslo_west) welch 
ttest accept_bigger_wage_diffs if vote==2, by (oslo_west) welch  
ttest allow_private_schools if vote==2, by (oslo_west) welch 
ttest public_serv_over_red_taxs if vote==2, by (oslo_west) welch 
ttest public_activities_w_private if vote==2, by (oslo_west) welch 
ttest high_inc_more_tax if vote==2, by (oslo_west) welch 
ttest abolish_wealth_tax if vote==2, by (oslo_west) welch 

sum cities_keep_more_tax if vote==2
sum red_econ_diffs if vote==2
sum accept_bigger_wage_diffs if vote==2
sum allow_private_schools if vote==2
sum public_serv_over_red_taxs if vote==2
sum public_activities_w_private if vote==2
sum high_inc_more_tax if vote==2
sum abolish_wealth_tax if vote==2 

/** social policies  **/
ttest relig_educ if vote==2, by (oslo_west) welch 
ttest church_state_sep if vote==2, by (oslo_west) welch 
ttest abortion if vote==2, by (oslo_west) welch 
ttest christian_val if vote==2, by (oslo_west) welch
ttest gays_samerights if vote==2, by (oslo_west) welch 
ttest euthanasia if vote==2, by (oslo_west) welch 

sum relig_educ if vote==2 
sum church_state_sep if vote==2
sum abortion if vote==2
sum christian_val if vote==2
sum gays_samerights if vote==2
sum euthanasia if vote==2

log close
