
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ul ll]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	global k = wordcount("`testvars'")
	if ("`cmd'" == "mlogit") global k = 2*$k
	capture `cmd' `anything' `if' `in', `ul' `ll'
	if (_rc == 0) {
		local i = 0
		if ("`cmd'" ~= "mlogit") {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[`var']
				local i = `i' + 1
				}
			}
		else {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = [3]_b[`var']
				local i = `i' + 1
				matrix B[$j+`i',1] = [7]_b[`var']
				local i = `i' + 1
				}
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, ul ll]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	global k = wordcount("`testvars'")
	if ("`cmd'" == "mlogit") global k = 2*$k
	capture `cmd' `anything' `if' `in', `ul' `ll'
	if (_rc == 0) {
		local i = 0
		if ("`cmd'" ~= "mlogit") {
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var']
				local i = `i' + 1
				}
			}
		else {
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = [3]_b[`var']
				local i = `i' + 1
				matrix BB[$j+`i',1] = [7]_b[`var']
				local i = `i' + 1
				}
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 57

use DatAFGH, clear

matrix B = J($b,1,.)

global j = 1

*Table 1
mycmd (treat_hi) reg profit_main treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd (treat_hi) tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ul
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ul
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ul

*Table 2
mycmd (treat_hi) mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)

*Table 3
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)

*Table 4 
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll

global reps = _N

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if _n == `c'

global j = 1

*Table 1
mycmd1 (treat_hi) reg profit_main treat_hi if (treat_lo | treat_hi)
mycmd1 (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd1 (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd1 (treat_hi) reg time_total_work_min treat_hi if (treat_lo | treat_hi)
mycmd1 (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd1 (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd1 (treat_hi) tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ul
mycmd1 (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ul
mycmd1 (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ul

*Table 2
mycmd1 (treat_hi) mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi)
mycmd1 (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd1 (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)

*Table 3
mycmd1 (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd1 (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd1 (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)

*Table 4 
mycmd1 (treat_nosal treat_r) reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r)
mycmd1 (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r)
mycmd1 (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r)
mycmd1 (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd1 (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd1 (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd1 (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd1 (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd1 (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll

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
save results\OJackknifeAFGH, replace


