
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


use DatOT, clear

matrix B = J(4,2,.)

global j = 1

*Table 2
global i = 0
mycmd (treatment) areg attendance treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg attendance treat_period period RESPID2-RESPID198 if after==1, cluster(respid) absorb(date_group)
mycmd (treatment) areg present_diary treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg present_diary treat_period period RESPID2-RESPID154 RESPID156-RESPID198 if after==1  , cluster(respid) absorb(date_group)

quietly suest $M, cluster(respid)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)
 
drop _all
svmat double F
svmat double B
save results/SuestOT, replace






