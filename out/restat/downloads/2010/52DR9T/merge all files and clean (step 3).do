**Step 3: Merge all files and clean**

use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace

use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_allwaves.dta"
drop _m
save "f:\BHPS\daughters\voting_allwaves.dta", replace

use "f:\BHPS\daughters\egoalt_all_child.dta", clear
sort pid round
save "f:\BHPS\daughters\egoalt_all_child.dta", replace

use "f:\BHPS\daughters\voting_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\egoalt_all_child.dta"
drop _m
sort pid round
by pid round: egen j = seq()
drop if j > 1
save "f:\BHPS\daughters\voting_allwaves.dta", replace

**Clean data and generate new variables**

gen cpi = 0.909 if doiy4 == 1992
replace cpi = 0.932 if doiy4 == 1993
replace cpi = 0.951 if doiy4 == 1994
replace cpi = 0.976 if doiy4 == 1995
replace cpi = 1 if doiy4 == 1996
replace cpi = 1.018 if doiy4 == 1997
replace cpi = 1.034 if doiy4 == 1998
replace cpi = 1.048 if doiy4 == 1999
replace cpi = 1.056 if doiy4 == 2000
replace cpi = 1.069 if doiy4 == 2001
replace cpi = 1.083 if doiy4 == 2002
replace cpi = 1.098 if doiy4 == 2003
replace cpi = 1.112 if doiy4 == 2004 

replace fihhyr = . if fihhyr < 0
replace fiyr = . if fiyr < 0 

gen r_hhincome = fihhyr/cpi
gen r_hhincome_cap = r_hhincome/hhsize
gen r_income = fiyr/cpi

gen employment = jbstat if jbstat >0
lab val emp bjbstat
replace emp = 0 if emp == 2

gen first_degree = qfachi == 2
gen higher_degree = qfachi == 1
gen vocational = qfachi == 3
gen a_level = qfachi == 4
gen o_level = qfachi == 5
gen gcse_level = qfachi == 6

gen married = mastat == 1
gen cohabit = mastat == 2
gen widow = mastat == 3
gen divorce = mastat == 4
gen separated = mastat == 5
gen single = mastat == 6

gen vote_labour_not_cons = 1 if vote4 == 2
replace vote_labour_not_cons = 0 if vote4 == 1

save "f:\BHPS\daughters\voting_allwaves.dta", replace

sort pid round
by pid round: egen j2 = seq()
drop if j2 > 1

**Gen voting variable (dependent variable)**

gen vote_lib_lab_not_cons = 1 if vote4 == 2 | vote4 == 3
replace vote_lib_lab_not_cons = 0 if vote4 == 1

replace nat_child_total = 0 if nat_child_total == .
replace step_child_total = 0 if step_child_total == .
replace fa_child_total = 0 if fa_child_total == .
replace all_child_total = 0 if all_child_total == .

replace nat_son_total = 0 if nat_son_total == .
replace step_son_total = 0 if step_son_total == .
replace fa_son_total = 0 if fa_son_total == .
replace all_son_total = 0 if all_son_total == .

replace nat_daughter_total = 0 if nat_daughter_total == .
replace step_daughter_total = 0 if step_daughter_total == .
replace fa_daughter_total = 0 if fa_daughter_total == .
replace all_daughter_total = 0 if all_daughter_total == .

replace all_bchild_total = 0 if all_bchild_total == .
replace all_bdaughter_total = 0 if all_bdaughter_total == .
replace all_bson_total = 0 if all_bson_total == .

replace first_nat_daughter = 0 if first_nat_daughter == .
replace second_nat_daughter = 0 if second_nat_daughter == .
replace third_nat_daughter = 0 if third_nat_daughter == .
replace fourth_nat_daughter = 0 if fourth_nat_daughter == .
replace fifth_nat_daughter = 0 if fifth_nat_daughter == .
replace sixth_nat_daughter = 0 if sixth_nat_daughter == .
replace seventh_nat_daughter = 0 if seventh_nat_daughter == .
replace eighth_nat_daughter = 0 if eighth_nat_daughter == .
replace ninth_nat_daughter = 0 if ninth_nat_daughter == .
replace tenth_nat_daughter = 0 if tenth_nat_daughter == .

replace first_nat_son = 0 if first_nat_son == .
replace second_nat_son = 0 if second_nat_son == .
replace third_nat_son = 0 if third_nat_son == .
replace fourth_nat_son = 0 if fourth_nat_son == .
replace fifth_nat_son = 0 if fifth_nat_son == .
replace sixth_nat_son = 0 if sixth_nat_son == .
replace seventh_nat_son = 0 if seventh_nat_son == .
replace eighth_nat_son = 0 if eighth_nat_son == .
replace ninth_nat_son = 0 if ninth_nat_son == .
replace tenth_nat_son = 0 if tenth_nat_son == .

gen income_1000 = r_hhincome_/1000
gen age2 = age^2/100

*gen religion*

gen religion = 0 if oprlg1 == 1
replace religion = 1 if oprlg1 == 2
replace religion = 2 if oprlg1 == 3
replace religion = 3 if oprlg1 >3 & oprlg1 ~=.
replace religion = 99 if oprlg1 <0

lab define religion 0 "no religion" 1 "C of E" 2 "Roman Cath" 3 "Other" 99 "missing", modify

lab val religion religion

sort pid
by pid: egen mreligion = mean(religion) if religion ~=99

replace religion = 0 if mreligion == 0 & religion == .
replace religion = 1 if mreligion == 1 & religion == .
replace religion = 2 if mreligion == 2 & religion == .
replace religion = 3 if mreligion == 3 & religion == .

replace religion = 99 if mreligion == .

save "f:\BHPS\daughters\voting_allwaves.dta", replace
