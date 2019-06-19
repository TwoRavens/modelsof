**Step 2: Generate and merge daughters variables**

use "f:\BHPS\stata6\aindall.dta", clear
renpfix a
gen round = 1
save "f:\BHPS\daughters\indall_wave1.dta", replace

use "f:\BHPS\stata6\bindall.dta", clear
renpfix b
gen round = 2
save "f:\BHPS\daughters\indall_wave2.dta", replace

use "f:\BHPS\stata6\cindall.dta", clear
renpfix c
gen round = 3
save "f:\BHPS\daughters\indall_wave3.dta", replace

use "f:\BHPS\stata6\dindall.dta", clear
renpfix d
gen round = 4
save "f:\BHPS\daughters\indall_wave4.dta", replace

use "f:\BHPS\stata6\eindall.dta", clear
renpfix e
gen round = 5
save "f:\BHPS\daughters\indall_wave5.dta", replace

use "f:\BHPS\stata6\findall.dta", clear
renpfix f
gen round = 6
save "f:\BHPS\daughters\indall_wave6.dta", replace

use "f:\BHPS\stata6\gindall.dta", clear
renpfix g
gen round = 7
save "f:\BHPS\daughters\indall_wave7.dta", replace

use "f:\BHPS\stata6\hindall.dta", clear
renpfix h
gen round = 8
save "f:\BHPS\daughters\indall_wave8.dta", replace

use "f:\BHPS\stata6\iindall.dta", clear
renpfix i
gen round = 9
save "f:\BHPS\daughters\indall_wave9.dta", replace

use "f:\BHPS\stata6\jindall.dta", clear
renpfix j
gen round = 10
save "f:\BHPS\daughters\indall_wave10.dta", replace

use "f:\BHPS\stata6\kindall.dta", clear
renpfix k
gen round = 11
save "f:\BHPS\daughters\indall_wave11.dta", replace

use "f:\BHPS\stata6\lindall.dta", clear
renpfix l
gen round = 12
save "f:\BHPS\daughters\indall_wave12.dta", replace

use "f:\BHPS\stata6\mindall.dta", clear
renpfix m
gen round = 13
save "f:\BHPS\daughters\indall_wave13.dta", replace

use "f:\BHPS\stata6\nindall.dta", clear
renpfix n
gen round = 14
save "f:\BHPS\daughters\indall_wave14.dta", replace

use "f:\BHPS\daughters\indall_wave1.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave1.dta", replace
use "f:\BHPS\daughters\indall_wave2.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave1.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave3.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave3.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave3.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave4.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave4.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave4.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave5.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave5.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave5.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave6.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave6.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave6.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave7.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave7.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave7.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave8.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave8.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave8.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave9.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave9.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave9.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave10.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave10.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave10.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave11.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave11.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave11.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave12.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave12.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave12.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave13.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave13.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave13.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace
use "f:\BHPS\daughters\indall_wave14.dta", clear
sort hid
save "f:\BHPS\daughters\indall_wave14.dta", replace
use "f:\BHPS\daughters\indall_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\indall_wave14.dta"
drop _m
save "f:\BHPS\daughters\indall_allwaves.dta", replace

ren pid opid
sort opid round

save "f:\BHPS\daughters\indall_allwaves_opid.dta", replace
use "F:\BHPS\daughters\egoalt_all.dta", clear
sort opid round
merge opid round using "f:\BHPS\daughters\indall_allwaves_opid.dta"
drop if _m ~=3
save "F:\BHPS\daughters\egoalt_all.dta", replace

**Gen children variables**

sort pid round
by pid round: egen cnat_child_total = count(rel) if rel == 4
by pid round: egen nat_child_total = max(cnat_child_total)
drop cnat_child

sort pid round
by pid round: egen cstep_child_total = count(rel) if rel == 7
by pid round: egen step_child_total = max(cstep_child_total)
drop cstep_child

sort pid round
by pid round: egen cfa_child_total = count(rel) if (rel == 5 | rel == 6)
by pid round: egen fa_child_total = max(cfa_child_total)
drop cfa_child

sort pid round
by pid round: egen call_child_total = count(rel) if (rel >=4 & rel <= 7)
by pid round: egen all_child_total = max(call_child_total)
drop call_child

**Gen daughters variables**

sort pid round
by pid round: egen cnat_daughter_total = count(rel) if rel == 4 & osex == 2
by pid round: egen nat_daughter_total = max(cnat_daughter_total)
drop cnat_daughter

sort pid round
by pid round: egen cstep_daughter_total = count(rel) if rel == 7 & osex == 2
by pid round: egen step_daughter_total = max(cstep_daughter_total)
drop cstep_daughter

sort pid round
by pid round: egen cfa_daughter_total = count(rel) if (rel == 5 | rel == 6) & osex == 2
by pid round: egen fa_daughter_total = max(cfa_daughter_total)
drop cfa_daughter

sort pid round
by pid round: egen call_daughter_total = count(rel) if (rel >=4 & rel <= 7) & osex == 2
by pid round: egen all_daughter_total = max(call_daughter_total)
drop call_daughter

*gen son*

sort pid round
by pid round: egen cnat_son_total = count(rel) if rel == 4 & osex == 1
by pid round: egen nat_son_total = max(cnat_son_total)
drop cnat_son

sort pid round
by pid round: egen cstep_son_total = count(rel) if rel == 7 & osex == 1
by pid round: egen step_son_total = max(cstep_son_total)
drop cstep_son

sort pid round
by pid round: egen cfa_son_total = count(rel) if (rel == 5 | rel == 6) & osex == 1
by pid round: egen fa_son_total = max(cfa_son_total)
drop cfa_son

sort pid round
by pid round: egen call_son_total = count(rel) if (rel >=4 & rel <= 7) & osex == 1
by pid round: egen all_son_total = max(call_son_total)
drop call_son

*gen children born - w/n 1 year*

sort pid round
by pid round: egen call_bchild_total = count(rel) if (rel >=4 & rel <= 7) & age12<=1
by pid round: egen all_bchild_total = max(call_bchild_total)
drop call_bchild

sort pid round
by pid round: egen call_bdaughter_total = count(rel) if (rel >=4 & rel <= 7) & osex == 2 & age12<=1
by pid round: egen all_bdaughter_total = max(call_bdaughter_total)
drop call_bdaughter

sort pid round
by pid round: egen call_bson_total = count(rel) if (rel >=4 & rel <= 7) & osex == 1 & age12<=1
by pid round: egen all_bson_total = max(call_bson_total)
drop call_bson

drop _m

*gen order of child*

gsort pid round -age
by pid round: egen order_nat_child = seq() if rel==4

by pid round: gen first_nat_daughter = 1 if order_nat_child == 1 & osex == 2
by pid round: gen second_nat_daughter = 1 if order_nat_child == 2 & osex == 2
by pid round: gen third_nat_daughter = 1 if order_nat_child == 3 & osex == 2
by pid round: gen fourth_nat_daughter = 1 if order_nat_child == 4 & osex == 2
by pid round: gen fifth_nat_daughter = 1 if order_nat_child == 5 & osex == 2
by pid round: gen sixth_nat_daughter = 1 if order_nat_child == 6 & osex == 2
by pid round: gen seventh_nat_daughter = 1 if order_nat_child == 7 & osex == 2
by pid round: gen eighth_nat_daughter = 1 if order_nat_child == 8 & osex == 2
by pid round: gen ninth_nat_daughter = 1 if order_nat_child == 9 & osex == 2
by pid round: gen tenth_nat_daughter = 1 if order_nat_child == 10 & osex == 2

by pid round: gen first_nat_son = 1 if order_nat_child == 1 & osex == 1
by pid round: gen second_nat_son = 1 if order_nat_child == 2 & osex == 1
by pid round: gen third_nat_son = 1 if order_nat_child == 3 & osex == 1
by pid round: gen fourth_nat_son = 1 if order_nat_child == 4 & osex == 1
by pid round: gen fifth_nat_son = 1 if order_nat_child == 5 & osex == 1
by pid round: gen sixth_nat_son = 1 if order_nat_child == 6 & osex == 1
by pid round: gen seventh_nat_son = 1 if order_nat_child == 7 & osex == 1
by pid round: gen eighth_nat_son = 1 if order_nat_child == 8 & osex == 1
by pid round: gen ninth_nat_son = 1 if order_nat_child == 9 & osex == 1
by pid round: gen tenth_nat_son = 1 if order_nat_child == 10 & osex == 1

save "F:\BHPS\daughters\egoalt_all.dta", replace


collapse  (max) nat_child_total step_child_total fa_child_total /*
*/all_child_total nat_daughter_total step_daughter_total/*
*/  fa_daughter_total all_daughter_total nat_son_total step_son_total /*
*/ fa_son_total all_son_total all_bchild_total all_bdaughter_total /*
*/ all_bson_total order_nat_child first_nat_daughter second_nat_daughter /*
*/ third_nat_daughter fourth_nat_daughter fifth_nat_daughter /*
*/ sixth_nat_daughter seventh_nat_daughter eighth_nat_daughter /*
*/ ninth_nat_daughter tenth_nat_daughter first_nat_son second_nat_son/*
*/ third_nat_son fourth_nat_son fifth_nat_son sixth_nat_son /*
*/ seventh_nat_son eighth_nat_son ninth_nat_son tenth_nat_son, by(pid round)  

save "F:\BHPS\daughters\egoalt_all_child.dta", replace
