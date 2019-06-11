
clear
set more off

use "Democratic Virtues.dta", clear

*political preferences
recode pid7 (8=.), gen(pid)
gen pidstrength = abs(pid-4)

gen repdummy = .
replace repdummy = 0 if pid < 4
replace repdummy = 1 if pid > 4

*political interest
recode Q37 (1=5) (2=4) (4=2) (5=1), gen(polinterest)

*outparty social interactions
recode Q32 (5=1) (4=2) (2=4) (1=5), gen(int_neighbors)
recode Q33 (5=1) (4=2) (2=4) (1=5), gen(int_working)
recode Q34 (5=1) (4=2) (2=4) (1=5), gen(int_dinner)
recode Q35 (5=1) (4=2) (2=4) (1=5), gen(int_marriage)
egen interaction = rowmean(int_neighbors int_working int_dinner int_marriage)

*in person political talk
gen talk_spouse = 7-q38_1
gen talk_family = 7-q38_2
gen talk_friends = 7-q38_3
gen talk_coworkers = 7-q38_4
gen talk_church = 7-q38_5
egen politicaltalk = rowmean(talk_spouse talk_family talk_friends talk_coworkers talk_church)

*in person political disagreement
recode q38a_1 (2=3) (3=2) (4=.), gen(disagree_spouse)
recode q38a_2 (2=3) (3=2) (4=.), gen(disagree_family)
recode q38a_3 (2=3) (3=2) (4=.), gen(disagree_friends)
recode q38a_4 (2=3) (3=2) (4=.), gen(disagree_coworkers)
recode q38a_5 (2=3) (3=2) (4=.), gen(disagree_church)
egen disagreement = rowmean(disagree_spouse disagree_family disagree_friends disagree_coworkers disagree_church)

*bridging and bonding
recode Q51 (1=4) (2=3) (3=2) (4=1), gen(demfriends)
recode Q52 (1=4) (2=3) (3=2) (4=1), gen(repfriends)
recode Q53 (1=4) (2=3) (3=2) (4=1), gen(indepfriends)

egen demrep = rowmean(demfriends repfriends)
egen demindep = rowmean(demfriends indepfriends)
egen repindep = rowmean(repfriends indepfriends)

gen partybridging = .
gen partybridging2 = .
replace partybridging = demindep if pid > 4
replace partybridging2 = demfriends if pid > 4
replace partybridging = repindep if pid < 4
replace partybridging2 = repfriends if pid < 4

gen partybonding = .
replace partybonding = demfriends if pid < 4
replace partybonding = repfriends if pid > 4

label define relationships 1 "1 (None)" 2 "2 (Just a few)" 3 "3 (Some)" 4 "4 (A lot)"
label values partybonding relationships
label values partybridging relationships
label values partybridging2 relationships
