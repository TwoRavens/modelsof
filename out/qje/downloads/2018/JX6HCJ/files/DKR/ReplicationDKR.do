
*Table 4 - All okay

use SAFI_main_dataset_AER, clear
gen incomeK_04=income_04/1000

forvalues i = 1/3 {
	reg anyfert_plus`i'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 school1-school16
	reg anyfert_plus`i'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 thatch_roof_04 std5parent school1-school16
	}

forvalues i = 1/3 {
	reg anyfert_plus`i'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 house_ever_anyfert_05 safi_lr04 sbsk1 sbsk1_demo demo school1-school16
	reg anyfert_plus`i'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 thatch_roof_04 std5parent sbsk1 sbsk1_demo demo safi_lr04 school1-school16
	}


*Table 6 - All okay

use pilot_SAFI_AER, clear
gen incomeK=income/1000

foreach X in 2 3 4 4b 5 6 {
	cap rename safi`X'_offer safi_offer_`X' 
	cap rename safi`X'_paid safi_paid_`X'  
	cap rename safi`X'_sample safi_sample_`X' 
	cap rename safi`X'_accept safi_accept_`X'
	}

reshape long safi_offer safi_paid safi_sample safi_accept, i(hid) j(year) string

for any 2 3 4 4b 5 6: replace year="X" if year=="_X"
drop if safi_offer==0 | (safi_sample==0 & safi_offer==.)
drop safi3_eligible safi6*
egen sum=robs( safi_sample safi_offer safi_accept safi_paid)
drop if sum==0
drop sum

*now or later: 3, 4, 5 (option 1), 6;
gen now_or_later_offer=safi_offer if year=="3" | year=="4" | (year=="5" & safi_offer==1) | year=="6"
gen now_or_later_accept=safi_accept if year=="3" | year=="4" | (year=="5" & safi_offer==1) | year=="6"
gen now_or_later_paid=safi_paid if year=="3" | year=="4" | (year=="5" & safi_offer==1) | year=="6"
gen take_it_or_leave_it=1 if year=="3" | year=="4" | (year=="5" & safi_offer==1) | year=="6"

*few days: 4b, 5 (option 2);
gen few_days_offer=safi_offer if year=="4b" | (year=="5" & safi_offer==2)
gen few_days_accept=safi_accept if year=="4b" | (year=="5" & safi_offer==2) 
gen few_days_paid=safi_paid if year=="4b" | (year=="5" & safi_offer==2)
gen few_days=1 if year=="4b" | (year=="5" & safi_offer==2) 

*few months: 2, 5 (option 3);
gen few_months_offer=safi_offer if year=="2" | (year=="5" & safi_offer==3) 
gen few_months_accept=safi_accept if year=="2" | (year=="5" & safi_offer==3) 
gen few_months_paid=safi_paid if year=="2" | (year=="5" & safi_offer==3) 
gen few_months=1 if year=="2" | (year=="5" & safi_offer==3) 

egen sum=rsum(take_it_or_leave_it few_days few_months)
for var take_it_or_leave_it few_days few_months: replace X=0 if X==. & sum==1
drop sum

reg safi_accept take_it_or_leave_it few_days few_months, nocons
reg safi_accept take_it_or_leave_it few_days few_months house_ever_anyfert educ, nocons
reg safi_paid take_it_or_leave_it few_days few_months, nocons
reg safi_paid take_it_or_leave_it few_days few_months house_ever_anyfert educ, nocons
reg safi_accept take_it_or_leave_it few_days few_months if year=="5", nocons
reg safi_accept take_it_or_leave_it few_days few_months house_ever_anyfert educ if year=="5", nocons
reg safi_paid take_it_or_leave_it few_days few_months if year=="5", nocons
reg safi_paid take_it_or_leave_it few_days few_months house_ever_anyfert educ if year=="5", nocons



*Table 7 - All okay

use SAFI_main_dataset_AER, clear
gen incomeK_04=income_04/1000
foreach X in remind_bought_ftd remind_plan_ftd remind_planorbuy_ftd {
	reg `X' reminder safi_lr04 safi_sr04 subsidy fullprice choice buy buy_safi_sr04 sbsk1 sbsk1_demo demo school1-school16
	reg `X' reminder house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 safi_lr04 safi_sr04 subsidy fullprice choice buy buy_safi_sr04 sbsk1 sbsk1_demo demo school1-school16
	}



********************************************

*Pilot programme - randomization protocols lost to history - see correspondence with Robinson

********************************************************************************

*File provided by Jon Robinson
use sampling_frame_alwyn_young_28mar14, clear
rename school SCHOOL
rename sbsk1 SBSK1
rename safi SAFI
rename safi_sr04 SAFI_SR04
rename choice CHOICE
rename price PRICE
rename buy BUY
sort hid
save aq, replace

*These are the sampling plan, don't exactly correspond to treatment administered (correspondence with Jon Robinson)
*Also 6 more households in this plan

use SAFI_main_dataset_AER, clear
destring hid, replace
sort hid
merge hid using aq

*Filling in planned treatment for households that are missing from main_dataset
replace safi_lr04 = SAFI if _m == 2
replace safi_sr04 = SAFI_SR04 if _m == 2
replace choice = CHOICE if _m == 2
replace buy = BUY if _m == 2
replace subsidy = (PRICE == "HALF") if _m == 2
replace fullprice = (PRICE == "FULL") if _m == 2
replace buy_safi_sr04 = buy*safi_sr04 if _m == 2

*Based upon correspondence with Jon Robinson (demo did not vary within schools) 
egen Strata = group(SCHOOL SBSK1), label
egen school = group(SCHOOL)

*Code that implements randomization of reminder (based upon code provided by Jon Robinson)
egen group_SAFI=group(SBSK1 SAFI CHOICE BUY) if SAFI_SR04==1
egen group_sub=group(SBSK1 SAFI PRICE BUY) if PRICE!=""
egen group_SAFITOUSE=group(group_SAFI SCHOOL)
egen group_subTOUSE=group(group_sub SCHOOL)

set seed 19182004
sort hid
local cutoff = .5
gen random = uniform() if interview == 0

*1.  SAFI group
sum group_SAFITOUSE if interview == 0
local max_SAFI=r(max)
sort interview group_SAFITOUSE random
by interview group_SAFITOUSE: gen group_SAFIN=_N if interview == 0
by interview group_SAFITOUSE: gen group_SAFIRANK=_n if interview == 0
matrix num = J(`max_SAFI',1,0)
forvalues i = 1/`max_SAFI' {
	quietly count if group_SAFITOUSE == `i' & interview == 0
	matrix num[`i',1] = r(N)
	}

capture drop REMINDER
gen REMINDER = .
local takeodd = 1
local i 1
while `i' <= `max_SAFI' {
	if round(num[`i',1],2)!=num[`i',1] & num[`i',1]!=0 {
		if `takeodd'==1 {
			quietly replace REMINDER=1 if group_SAFIRANK<=`cutoff'*(group_SAFIN+1) & SAFI_SR04==1 & group_SAFITOUSE==`i' & interview == 0
			local takeodd=0
			}
	
		else {
			quietly replace REMINDER=1 if group_SAFIRANK<=`cutoff'*(group_SAFIN) & SAFI_SR04==1 & group_SAFITOUSE==`i' & interview == 0
			local takeodd=1
			}
		}

	else {
		quietly replace REMINDER=1 if group_SAFIRANK<=`cutoff'*(group_SAFIN) & SAFI_SR04==1 & group_SAFITOUSE==`i' & interview == 0
		}
	local i = `i' + 1
	}
drop *SAFIN* *SAFIRANK*

*2.  Subsidy group
sum group_subTOUSE if interview == 0
local max_sub=r(max)
sort interview group_subTOUSE random
by interview group_subTOUSE: gen group_subN=_N if interview == 0
by interview group_subTOUSE: gen group_subRANK=_n if interview == 0
matrix num = J(`max_sub',1,0)
forvalues i = 1/`max_sub' {
	quietly count if group_subTOUSE == `i' & interview == 0
	matrix num[`i',1] = r(N)
	}

local takeodd=1
local i 1
while `i' <= `max_sub' {
	if round(num[`i',1],2)!=num[`i',1] & num[`i',1]!=0 {
		if `takeodd'==1 {
			quietly replace REMINDER=1 if group_subRANK<=`cutoff'*(group_subN+1) & PRICE!="" & group_subTOUSE==`i' & interview == 0
			local takeodd=0
			}
	
		else {
			quietly replace REMINDER=1 if group_subRANK<=`cutoff'*(group_subN) & PRICE!="" & group_subTOUSE==`i' & interview == 0
			local takeodd=1
			}
		}

	else {
		quietly replace REMINDER=1 if group_subRANK<=`cutoff'*(group_subN) & PRICE!="" & group_subTOUSE==`i' & interview == 0
		}
	local i = `i' + 1
	}
drop *subN* *subRANK*
drop group* random

tab reminder
tab REMINDER reminder
drop REMINDER

gen incomeK_04=income_04/1000
save DatDKR, replace

*Will implement randomization across 1236 sample, using actual treatments (except for 6 missing, where use planned treatments)
*Will recalculate reminder using planned treatments, because this is how I can reproduce original reminder treatment 
*reminder treatment was only administered to those they managed to get to, so will only administer reminder treatment (based upon rerandomization) to those

*Table 4
forvalues k = 1/3 {
	reg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 school2-school16
	reg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent school2-school16
	}
forvalues k = 1/3 {
	reg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 house_ever_anyfert_05 safi_lr04 sbsk1 sbsk1_demo demo school1-school16
	reg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 school2-school16

	reg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 thatch_roof_04 std5parent sbsk1 sbsk1_demo demo safi_lr04 school1-school16
	reg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent school2-school16
	}
*Table 7
foreach X in remind_bought_ftd remind_plan_ftd remind_planorbuy_ftd {
	reg `X' reminder safi_lr04 safi_sr04 subsidy fullprice choice buy buy_safi_sr04 sbsk1 sbsk1_demo demo school1-school16
	areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo, absorb(school)

	reg `X' reminder house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 safi_lr04 safi_sr04 subsidy fullprice choice buy buy_safi_sr04 sbsk1 sbsk1_demo demo school1-school16
	areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 sbsk1 sbsk1_demo, absorb(school)

*Colinear, so dropped
areg demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 sbsk1 sbsk1_demo if `X' ~= ., absorb(school)
	}

capture erase aq.dta





