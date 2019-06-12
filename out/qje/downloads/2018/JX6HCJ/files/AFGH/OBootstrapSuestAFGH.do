
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ul ll]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', `ul' `ll'
	if (_rc == 0) {
		estimates store M$i
		if ("`cmd'" ~= "mlogit") {
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		else {
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[3:`var']
				global j = $j + 1
				matrix B[1,$j] = _b[7:`var']
				}
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************


use DatAFGH, clear

*Table 1
global i = 0
mycmd (treat_hi) reg profit_main treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd (treat_hi) tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ul
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ul
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ul

suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 1)
matrix B1 = B[1,1..$j]

*Table 2
global i = 0
mycmd (treat_hi) mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)

suest $M, robust
test [M1_3]xxxtreat_hi1 [M1_7]xxxtreat_hi1 [M2_3]xxxtreat_hi2 [M2_7]xxxtreat_hi2 [M3_3]xxxtreat_hi3 [M3_7]xxxtreat_hi3
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

*Table 3
global i = 0
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)

suest $M, robust
test [M1_3]xxxtreat_sal1 [M1_3]xxxtreat_nosal1 [M1_3]xxxtreat_r1 [M1_7]xxxtreat_sal1 [M1_7]xxxtreat_nosal1 [M1_7]xxxtreat_r1 [M2_3]xxxtreat_sal2 [M2_3]xxxtreat_nosal2 [M2_3]xxxtreat_r2 [M2_7]xxxtreat_sal2 [M2_7]xxxtreat_nosal2 [M2_7]xxxtreat_r2 [M3_3]xxxtreat_sal3 [M3_3]xxxtreat_nosal3 [M3_3]xxxtreat_r3 [M3_7]xxxtreat_sal3 [M3_7]xxxtreat_nosal3 [M3_7]xxxtreat_r3
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

*Table 4 
global i = 0
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll

local anything = "$test"
global test = ""
matrix B4 = J(1,$j-2,.)
local k = 1
forvalues i = 1/$j {
	gettoken a anything: anything
	if ("`a'" ~= "xxxtreat_nosal1" & "`a'" ~= "xxxtreat_sal7") {
		global test = "$test" + " " + "`a'"
		matrix B4[1,`k'] = B[1,`i']
		local k = `k' + 1
		}
	}
global j = $j - 2
	
suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

gen N = _n
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa


*Table 1
global i = 0
mycmd (treat_hi) reg profit_main treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd (treat_hi) tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ul
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ul
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ul

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B1)*invsym(V)*(B[1,1..$j]-B1)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 1)
		}
	}

*Table 2
global i = 0
mycmd (treat_hi) mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)

capture suest $M, robust
if (_rc == 0) {
	capture test [M1_3]xxxtreat_hi1 [M1_7]xxxtreat_hi1 [M2_3]xxxtreat_hi2 [M2_7]xxxtreat_hi2 [M3_3]xxxtreat_hi3 [M3_7]xxxtreat_hi3, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}

*Table 3
global i = 0
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)

capture suest $M, robust
if (_rc == 0) {
	capture test [M1_3]xxxtreat_sal1 [M1_3]xxxtreat_nosal1 [M1_3]xxxtreat_r1 [M1_7]xxxtreat_sal1 [M1_7]xxxtreat_nosal1 [M1_7]xxxtreat_r1 [M2_3]xxxtreat_sal2 [M2_3]xxxtreat_nosal2 [M2_3]xxxtreat_r2 [M2_7]xxxtreat_sal2 [M2_7]xxxtreat_nosal2 [M2_7]xxxtreat_r2 [M3_3]xxxtreat_sal3 [M3_3]xxxtreat_nosal3 [M3_3]xxxtreat_r3 [M3_7]xxxtreat_sal3 [M3_7]xxxtreat_nosal3 [M3_7]xxxtreat_r3, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}

*Table 4 
global i = 0
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll
	
capture suest $M, robust
if (_rc == 0) {
	local anything = "$test"
	global test = ""
	matrix BB = J(1,$j-2,.)
	local k = 1
	forvalues i = 1/$j {
		gettoken a anything: anything
		if ("`a'" ~= "xxxtreat_nosal1" & "`a'" ~= "xxxtreat_sal7") {
			global test = "$test" + " " + "`a'"
			matrix BB[1,`k'] = B[1,`i']
			local k = `k' + 1
			}
		}
	global j = $j - 2
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (BB[1,1..$j]-B4)*invsym(V)*(BB[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

}

drop _all
set obs $reps
forvalues i = 1/20 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestAFGH, replace

erase aa.dta
erase aaa.dta

