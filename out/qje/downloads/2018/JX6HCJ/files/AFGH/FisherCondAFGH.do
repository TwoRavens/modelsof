
*randomizing at authors' clustering level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ll ul]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	global k = wordcount("`testvars'")
	if ("`cmd'" ~= "mlogit") {
		`cmd' `anything' `if' `in', `ll' `ul'
		}
	else {
		`cmd' `anything' `if' `in', 
		global k = $k*2
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		if ("`cmd'" ~= "mlogit") {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		else {
			foreach var in `testvars' {
				matrix B[$j+`i',1] = _b[3:`var'], _se[3:`var']
				local i = `i' + 1
				matrix B[$j+`i',1] = _b[7:`var'], _se[7:`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatAFGH, clear

matrix F = J(24,4,.)
matrix B = J(57,2,.)

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

gen sample1 = (treat_lo | treat_hi)
gen sample2 = (treat_lo | treat_nosal | treat_r | treat_sal)
gen sample3 = (treat_lo | treat_nosal | treat_r)

generate Order = _n

global i = 0

*Table 1
foreach var in treat_hi {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg profit_main treat_hi if sample1), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_hi {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg profit_main treat_hi neg_avg_time_cor_ans_pt if sample1), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_hi {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if sample1), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_hi {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg time_total_work_min treat_hi if sample1), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_hi {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if sample1), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_hi {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if sample1), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_hi {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') tobit time_total_work_min treat_hi if sample1, ul), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_hi {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if sample1, ul), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_hi {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if sample1, ul), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

*Table 2
	forvalues j = 1/6 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}

*Table 3 
	forvalues j = 1/18 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}

*Table 4 
foreach var in treat_nosal treat_r {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg profit_main treat_nosal treat_r if sample3), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_nosal treat_r {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if sample3), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_nosal treat_r {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if sample3), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_sal treat_nosal treat_r {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg ws treat_sal treat_nosal treat_r if sample2), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_sal treat_nosal treat_r {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if sample2), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_sal treat_nosal treat_r {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if sample2), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_sal treat_nosal treat_r {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') tobit ws treat_sal treat_nosal treat_r if sample2, ll), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_sal treat_nosal treat_r {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if sample2, ll), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}

foreach var in treat_sal treat_nosal treat_r {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat_lo == 1 | `var' == 1)
	randcmdc ((`var') tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if sample2, ll), treatvars(`var') strata(Strata) seed(1) sample saving(ip\a$i, replace) reps($reps) 
	}



matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondAFGH, replace

