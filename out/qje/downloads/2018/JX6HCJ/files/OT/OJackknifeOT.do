
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', absorb(`absorb')
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', absorb(`absorb')
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 4

use DatOT, clear

matrix B = J($b,1,.)

global j = 1

mycmd (treatment) areg attendance treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg attendance treat_period period RESPID* if after==1, cluster(respid) absorb(date_group)
mycmd (treatment) areg present_diary treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg present_diary treat_period period RESPID* if after==1  , cluster(respid) absorb(date_group)

egen M = group(respid)
sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1

mycmd1 (treatment) areg attendance treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd1 (treat_period) areg attendance treat_period period RESPID* if after==1, cluster(respid) absorb(date_group)
mycmd1 (treatment) areg present_diary treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd1 (treat_period) areg present_diary treat_period period RESPID* if after==1  , cluster(respid) absorb(date_group)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeOT, replace



