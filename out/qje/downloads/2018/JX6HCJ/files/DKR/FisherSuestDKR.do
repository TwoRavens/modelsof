
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* xxx* Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
	quietly generate Ssample$i = e(sample)
	quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
	quietly predict double yyy$i if Ssample$i, resid
	local newtestvars = ""
	foreach var in `testvars' {
		quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
		quietly predict double xxx`var'$i if Ssample$i, resid
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	quietly reg yyy$i `newtestvars', noconstant
	estimates store M$i
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************


use DatDKR, clear

*Table 4
global i = 0
forvalues k = 1/3 {
	mycmd (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
forvalues k = 1/3 {
	mycmd (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 4)

*Table 7
global i = 0
foreach X in remind_bought_ftd remind_plan_ftd remind_planorbuy_ftd {
	mycmd (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo, absorb(school)
	mycmd (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 sbsk1 sbsk1_demo, absorb(school)
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

sort Strata hid
generate Order = _n

mata Y = st_data(.,("safi_lr04","safi_sr04","choice","subsidy","fullprice","buy","buy_safi_sr04","SAFI","SAFI_SR04","CHOICE","PRICE","BUY"))

generate double U = .

*Will implement randomization across 1236 sample, using actual treatments (except for 6 missing, where use planned treatments)
*Will recalculate reminder using planned treatments, because this is how I can reproduce original reminder treatment 
*reminder treatment was only administered to those they managed to get to, so will only administer reminder treatment (based upon rerandomization) to those

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort Strata U
	mata st_store(.,("safi_lr04","safi_sr04","choice","subsidy","fullprice","buy","buy_safi_sr04","SAFI","SAFI_SR04","CHOICE","PRICE","BUY"),Y)

*Code that implements randomization of reminder (based upon code provided by Jon Robinson)
quietly egen group_SAFI=group(SBSK1 SAFI CHOICE BUY) if SAFI_SR04==1
quietly egen group_sub=group(SBSK1 SAFI PRICE BUY) if PRICE!=""
quietly egen group_SAFITOUSE=group(group_SAFI SCHOOL)
quietly egen group_subTOUSE=group(group_sub SCHOOL)

set seed 19182004
sort hid
local cutoff = .5
quietly gen random = uniform() if interview == 0

*1.  SAFI group
quietly sum group_SAFITOUSE if interview == 0
local max_SAFI=r(max)
sort interview group_SAFITOUSE random
quietly by interview group_SAFITOUSE: gen group_SAFIN=_N if interview == 0
quietly by interview group_SAFITOUSE: gen group_SAFIRANK=_n if interview == 0
matrix num = J(`max_SAFI',1,0)
forvalues i = 1/`max_SAFI' {
	quietly count if group_SAFITOUSE == `i' & interview == 0
	matrix num[`i',1] = r(N)
	}

capture drop REMINDER
quietly gen REMINDER = .
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
quietly sum group_subTOUSE if interview == 0
local max_sub=r(max)
sort interview group_subTOUSE random
quietly by interview group_subTOUSE: gen group_subN=_N if interview == 0
quietly by interview group_subTOUSE: gen group_subRANK=_n if interview == 0
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

quietly replace reminder = 0 if reminder ~= .
quietly replace reminder = 1 if REMINDER == 1 & reminder ~= .


*Table 4
global i = 0
forvalues k = 1/3 {
	mycmd (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
forvalues k = 1/3 {
	mycmd (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*Table 7
global i = 0
foreach X in remind_bought_ftd remind_plan_ftd remind_planorbuy_ftd {
	mycmd (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo, absorb(school)
	mycmd (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 sbsk1 sbsk1_demo, absorb(school)
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/10 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestDKR, replace


