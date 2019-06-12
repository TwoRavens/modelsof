
****************************************
****************************************

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
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}

	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************

***********************************

use DatDKR, clear

matrix B = J(96,2,.)

global j = 1

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
 
drop _all
svmat double F
svmat double B
save results/SuestDKR, replace





