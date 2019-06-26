// Do file for article "Truly Reconciled? A Dyadic Analysis of Post-Conflict Social Reintegration in Northern Uganda"


// Table 1

use "descriptives.dta", clear

sum age gender educ_level wealth_index attend_meeting social_groups_sum_comb threaten_weapon attacked_weapon beaten lost_body_part
bysort CategoryCode: sum age gender educ_level wealth_index attend_meeting social_groups_sum_comb threaten_weapon attacked_weapon beaten lost_body_part

ttest age if cat1 == 1 | cat2 == 1, by(cat1)
ttest age if cat1 == 1 | cat4 == 1, by(cat1)
ttest age if cat2 == 1 | cat4 == 1, by(cat2)

prtest gender if cat1 == 1 | cat2 == 1, by(cat1)
prtest gender if cat1 == 1 | cat4 == 1, by(cat1)
prtest gender if cat2 == 1 | cat4 == 1, by(cat2)

ttest educ_level if cat1 == 1 | cat2 == 1, by(cat1)
ttest educ_level if cat1 == 1 | cat4 == 1, by(cat1)
ttest educ_level if cat2 == 1 | cat4 == 1, by(cat2)

ttest wealth_index if cat1 == 1 | cat2 == 1, by(cat1)
ttest wealth_index if cat1 == 1 | cat4 == 1, by(cat1)
ttest wealth_index if cat2 == 1 | cat4 == 1, by(cat2)

prtest attend_meeting if cat1 == 1 | cat2 == 1, by(cat1)
prtest attend_meeting if cat1 == 1 | cat4 == 1, by(cat1)
prtest attend_meeting if cat2 == 1 | cat4 == 1, by(cat2)

ttest social_groups_sum_comb if cat1 == 1 | cat2 == 1, by(cat1)
ttest social_groups_sum_comb if cat1 == 1 | cat4 == 1, by(cat1)
ttest social_groups_sum_comb if cat2 == 1 | cat4 == 1, by(cat2)

prtest threaten_weapon if cat1 == 1 | cat2 == 1, by(cat1)
prtest threaten_weapon if cat1 == 1 | cat4 == 1, by(cat1)
prtest threaten_weapon if cat2 == 1 | cat4 == 1, by(cat2)

prtest attacked_weapon if cat1 == 1 | cat2 == 1, by(cat1)
prtest attacked_weapon if cat1 == 1 | cat4 == 1, by(cat1)
prtest attacked_weapon if cat2 == 1 | cat4 == 1, by(cat2)

prtest beaten if cat1 == 1 | cat2 == 1, by(cat1)
prtest beaten if cat1 == 1 | cat4 == 1, by(cat1)
prtest beaten if cat2 == 1 | cat4 == 1, by(cat2)

prtest lost_body_part if cat1 == 1 | cat2 == 1, by(cat1)
prtest lost_body_part if cat1 == 1 | cat4 == 1, by(cat1)
prtest lost_body_part if cat2 == 1 | cat4 == 1, by(cat2)

========================

// Table 2. Social ties

use "social ties.dta", clear

tab CAT_ALTER, gen(alter_cat)

gen alter_group = 1 if alter_cat1 == 1
replace alter_group = 2 if alter_cat2 == 1
replace alter_group = 3 if alter_cat3 == 1

// friend 
sum friend if EGO_ID1 != ALTER_ID1
bysort alter_group: sum friend if EGO_ID1 != ALTER_ID1
svyset EGO_ID1
svy: mean friend if alter_group == 1 | alter_group == 2 & EGO_ID1 != ALTER_ID1, over(alter_group)
test [friend]2 = [friend]1
svyset EGO_ID1
svy: mean friend if alter_group == 1 | alter_group == 3 & EGO_ID1 != ALTER_ID1, over(alter_group)
test [friend]3 = [friend]1
svyset EGO_ID1
svy: mean friend if alter_group == 2 | alter_group == 3 & EGO_ID1 != ALTER_ID1, over(alter_group)
test [friend]2 = [friend]3

// AS
sum friend if EGO_ID1 != ALTER_ID1 & C11 == 1
bysort alter_group: sum friend if EGO_ID1 != ALTER_ID1 & C11 == 1

svyset EGO_ID1
svy: mean friend if alter_group == 1 | alter_group == 2 & EGO_ID1 != ALTER_ID1 & C11 == 1, over(alter_group)
test [friend]2 = [friend]1
svyset EGO_ID1
svy: mean friend if alter_group == 1 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C11 == 1, over(alter_group)
test [friend]3 = [friend]1
svyset EGO_ID1
svy: mean friend if alter_group == 2 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C11 == 1, over(alter_group)
test [friend]2 = [friend]3

// AL
sum friend if EGO_ID1 != ALTER_ID1 & C12 == 1
bysort alter_group: sum friend if EGO_ID1 != ALTER_ID1 & C12 == 1

svyset EGO_ID1
svy: mean friend if alter_group == 1 | alter_group == 2 & EGO_ID1 != ALTER_ID1 & C12 == 1, over(alter_group)
test [friend]2 = [friend]1
svyset EGO_ID1
svy: mean friend if alter_group == 1 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C12 == 1, over(alter_group)
test [friend]3 = [friend]1
svyset EGO_ID1
svy: mean friend if alter_group == 2 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C12 == 1, over(alter_group)
test [friend]2 = [friend]3

// IDP
sum friend if EGO_ID1 != ALTER_ID1 & C13 == 1
bysort alter_group: sum friend if EGO_ID1 != ALTER_ID1 & C13 == 1

svyset EGO_ID1
svy: mean friend if alter_group == 1 | alter_group == 2 & EGO_ID1 != ALTER_ID1 & C13 == 1, over(alter_group)
test [friend]2 = [friend]1
svyset EGO_ID1
svy: mean friend if alter_group == 1 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C13 == 1, over(alter_group)
test [friend]3 = [friend]1
svyset EGO_ID1
svy: mean friend if alter_group == 2 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C13 == 1, over(alter_group)
test [friend]2 = [friend]3


// group 
sum sg_any if EGO_ID1 != ALTER_ID1
bysort alter_group: sum sg_any if EGO_ID1 != ALTER_ID1

svyset EGO_ID1
svy: mean sg_any if alter_group == 1 | alter_group == 2 & EGO_ID1 != ALTER_ID1, over(alter_group)
test [sg_any]2 = [sg_any]1
svyset EGO_ID1
svy: mean sg_any if alter_group == 1 | alter_group == 3 & EGO_ID1 != ALTER_ID1, over(alter_group)
test [sg_any]3 = [sg_any]1
svyset EGO_ID1
svy: mean sg_any if alter_group == 2 | alter_group == 3 & EGO_ID1 != ALTER_ID1, over(alter_group)
test [sg_any]2 = [sg_any]3

// AS
sum sg_any if EGO_ID1 != ALTER_ID1 & C11 == 1
bysort alter_group: sum sg_any if EGO_ID1 != ALTER_ID1 & C11 == 1

svyset EGO_ID1
svy: mean sg_any if alter_group == 1 | alter_group == 2 & EGO_ID1 != ALTER_ID1 & C11 == 1, over(alter_group)
test [sg_any]2 = [sg_any]1
svyset EGO_ID1
svy: mean sg_any if alter_group == 1 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C11 == 1, over(alter_group)
test [sg_any]3 = [sg_any]1
svyset EGO_ID1
svy: mean sg_any if alter_group == 2 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C11 == 1, over(alter_group)
test [sg_any]2 = [sg_any]3

// AL
sum sg_any if EGO_ID1 != ALTER_ID1 & C12 == 1
bysort alter_group: sum sg_any if EGO_ID1 != ALTER_ID1 & C12 == 1

svyset EGO_ID1
svy: mean sg_any if alter_group == 1 | alter_group == 2 & EGO_ID1 != ALTER_ID1 & C12 == 1, over(alter_group)
test [sg_any]2 = [sg_any]1
svyset EGO_ID1
svy: mean sg_any if alter_group == 1 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C12 == 1, over(alter_group)
test [sg_any]3 = [sg_any]1
svyset EGO_ID1
svy: mean sg_any if alter_group == 2 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C12 == 1, over(alter_group)
test [sg_any]2 = [sg_any]3

// IDP
sum sg_any if EGO_ID1 != ALTER_ID1 & C13 == 1
bysort alter_group: sum sg_any if EGO_ID1 != ALTER_ID1 & C13 == 1

svyset EGO_ID1
svy: mean sg_any if alter_group == 1 | alter_group == 2 & EGO_ID1 != ALTER_ID1 & C13 == 1, over(alter_group)
test [sg_any]2 = [sg_any]1
svyset EGO_ID1
svy: mean sg_any if alter_group == 1 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C13 == 1, over(alter_group)
test [sg_any]3 = [sg_any]1
svyset EGO_ID1
svy: mean sg_any if alter_group == 2 | alter_group == 3 & EGO_ID1 != ALTER_ID1 & C13 == 1, over(alter_group)
test [sg_any]2 = [sg_any]3


=======

// Table 3. The role of alter's category

// DG

use "DG.dta", clear

keep if C21 == 1
keep P1_Offer ID1
collapse P1_Offer, by(ID1)
rename P1_Offer offer_AS
save "DG_21.dta", replace

use "DG.dta", clear
keep if C22 == 1
keep P1_Offer ID1
collapse P1_Offer, by(ID1)
rename P1_Offer offer_AL
save "DG_22.dta", replace

use "DG.dta", clear
keep if C23 == 1
keep P1_Offer ID1
collapse P1_Offer, by(ID1)
rename P1_Offer offer_IDP
save "DG_23.dta", replace

use "DG_21.dta", clear
merge m:m ID1 using "DG_22.dta"
drop _merge
merge m:m ID1 using "DG_23.dta"
drop _merge

sum offer_AS offer_AL offer_IDP

ttest offer_IDP = offer_AS
ttest offer_IDP = offer_AL
ttest offer_AL = offer_AS


// PG

use "PG.dta", clear

keep if C21 == 1
keep P1_Offer ID1
collapse P1_Offer, by(ID1)
rename P1_Offer offer_AS
save "PG_21.dta", replace

use "PG.dta", clear
keep if C22 == 1
keep P1_Offer ID1
collapse P1_Offer, by(ID1)
rename P1_Offer offer_AL
save "PG_22.dta", replace

use "PG.dta", clear
keep if C23 == 1
keep P1_Offer ID1
collapse P1_Offer, by(ID1)
rename P1_Offer offer_IDP
save "PG_23.dta", replace

use "PG_21.dta", clear
merge m:m ID1 using "PG_22.dta"
drop _merge
merge m:m ID1 using "PG_23.dta"
drop _merge

sum offer_AS offer_AL offer_IDP

ttest offer_IDP = offer_AS
ttest offer_IDP = offer_AL
ttest offer_AL = offer_AS


// Table 4. The role of alter's category (regressions)

use "PG.dta", clear
merge 1:1 ID_link using "social ties2.dta"
keep if _merge == 3

gen p1_AL = 1 if C1 == 2
replace p1_AL = 0 if C1 == 1 | C1 == 3
gen p2_AL = 1 if C2 == 2
replace p2_AL = 0 if C2 == 1 | C2 == 3

eststo clear
xtreg P1_Offer ib1.C2  age_alter gender_female_alter educ_level_alter wealth_index_alter friend, i(ID1) fe  cluster(Village_ego)
eststo
xtreg P1_Offer ib1.C2  age_alter gender_female_alter educ_level_alter wealth_index_alter friend if C1 == 1, i(ID1) fe  cluster(Village_ego)
eststo
xtreg P1_Offer ib1.C2  age_alter gender_female_alter educ_level_alter wealth_index_alter friend if C1 == 2, i(ID1) fe  cluster(Village_ego)
eststo
xtreg P1_Offer ib1.C2  age_alter gender_female_alter educ_level_alter wealth_index_alter friend if C1 == 3, i(ID1) fe  cluster(Village_ego)
eststo


use "DG.dta", clear
merge 1:1 ID_link using "social ties2.dta"
keep if _merge == 3

gen p1_AL = 1 if C1 == 2
replace p1_AL = 0 if C1 == 1 | C1 == 3
gen p2_AL = 1 if C2 == 2
replace p2_AL = 0 if C2 == 1 | C2 == 3

xtreg P1_Offer ib1.C2  age_alter gender_female_alter educ_level_alter wealth_index_alter friend, i(ID1) fe  cluster(Village_ego)
eststo
xtreg P1_Offer ib1.C2  age_alter gender_female_alter educ_level_alter wealth_index_alter friend if C1 == 1, i(ID1) fe  cluster(Village_ego)
eststo
xtreg P1_Offer ib1.C2  age_alter gender_female_alter educ_level_alter wealth_index_alter friend if C1 == 2, i(ID1) fe  cluster(Village_ego)
eststo
xtreg P1_Offer ib1.C2  age_alter gender_female_alter educ_level_alter wealth_index_alter friend if C1 == 3, i(ID1) fe  cluster(Village_ego)
eststo

esttab using "results.csv", replace b(%9.3f) label star(* 0.05 ** 0.01) se nobase r2 scalars(F) nogaps


