
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', absorb(`absorb')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', absorb(`absorb')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatDKR, clear

matrix F = J(18,4,.)
matrix B = J(96,2,.)

global i = 1
global j = 1
*Table 4
forvalues k = 1/3 {
	mycmd (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
forvalues k = 1/3 {
	mycmd (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
*Table 7
foreach X in remind_bought_ftd remind_plan_ftd remind_planorbuy_ftd {
	mycmd (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo, absorb(school)
	mycmd (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 sbsk1 sbsk1_demo, absorb(school)
	}

sort Strata hid
generate Order = _n

mata Y = st_data(.,("safi_lr04","safi_sr04","choice","subsidy","fullprice","buy","buy_safi_sr04","SAFI","SAFI_SR04","CHOICE","PRICE","BUY"))

generate double U = .

*Will implement randomization across 1236 sample, using actual treatments (except for 6 missing, where use planned treatments)
*Will recalculate reminder using planned treatments, because this is how I can reproduce original reminder treatment 
*reminder treatment was only administered to those they managed to get to, so will only administer reminder treatment (based upon rerandomization) to those

mata ResF = J($reps,18,.); ResD = J($reps,18,.); ResDF = J($reps,18,.); ResB = J($reps,96,.); ResSE = J($reps,96,.)
forvalues c = 1/$reps {
	matrix FF = J(18,3,.)
	matrix BB = J(96,2,.)
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

global i = 1
global j = 1
*Table 4
forvalues k = 1/3 {
	mycmd1 (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd1 (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
forvalues k = 1/3 {
	mycmd1 (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd1 (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
*Table 7
foreach X in remind_bought_ftd remind_plan_ftd remind_planorbuy_ftd {
	mycmd1 (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo, absorb(school)
	mycmd1 (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 sbsk1 sbsk1_demo, absorb(school)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..18] = FF[.,1]'; ResD[`c',1..18] = FF[.,2]'; ResDF[`c',1..18] = FF[.,3]'
mata ResB[`c',1..96] = BB[.,1]'; ResSE[`c',1..96] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/18 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/96 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherDKR, replace


