
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ul ll]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	global k = wordcount("`testvars'")
	if ("`cmd'" == "mlogit") global k = 2*$k
	`cmd' `anything' `if' `in', `ul' `ll'
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), $k - r(df), e(df_r), $k
		local i = 0
		if ("`cmd'" ~= "mlogit") {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		else {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = [3]_b[`var'], [3]_se[`var']
				local i = `i' + 1
				matrix B[$j+`i',1] = [7]_b[`var'], [7]_se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
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
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), $k - r(df), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			if ("`cmd'" == "mlogit" ) {
				matrix S = J($k,rowsof(V),0)
				local i = 1
				foreach var in `testvars' {
					local q = rownumb(V,"3:`var'")
					matrix S[`i',`q'] = 1
					local i = `i' + 1
					local q = rownumb(V,"7:`var'")
					matrix S[`i',`q'] = 1
					local i = `i' + 1
					}
				matrix V = S*V*S'
				matrix b = b*S'
				}
			else {
				matrix V = V[1..$k,1..$k]
				matrix b = b[1,1..$k]
				}
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			if ("`cmd'" ~= "mlogit") {
				foreach var in `testvars' {
					matrix BB[$j+`i',1] = _b[`var'], _se[`var']
					local i = `i' + 1
					}
				}
			else {
				foreach var in `testvars' {
					matrix BB[$j+`i',1] = [3]_b[`var'], [3]_se[`var']
					local i = `i' + 1
					matrix BB[$j+`i',1] = [7]_b[`var'], [7]_se[`var']
					local i = `i' + 1
					}
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 24
global b = 57

use DatAFGH, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
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

gen N = _n
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,2,.)
	matrix FF = J($a,4,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

global i = 1
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

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\OBootstrapAFGH, replace

erase aa.dta
erase aaa.dta

