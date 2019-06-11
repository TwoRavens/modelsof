*Run in Stata 10
*randomizing at authors' clustering level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust mle iterate(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`iterate'" ~= "") {
		`anything' `if' `in', iterate(`iterate')
		}
	else {
		`anything' `if' `in', `robust' `mle'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$ii,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$jj+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global ii = $ii + 1
global jj = $jj + $k
end

****************************************
****************************************

use DatCMS1, clear

matrix F = J(9,4,.)
matrix B = J(34,2,.)

global ii = 1
global jj = 1

*Table 2
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, robust
mycmd (tournament tournament_sabotage) xtreg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle

bys id_number: gen N = _n
sort N id_number
generate Order = _n

egen m = group(tournament tournament_sabotage), label

global i = 0
foreach var in tournament tournament_sabotage {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1)
	randcmdc ((`var') reg qual_adj_output tournament tournament_sabotage, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in tournament tournament_sabotage {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1)
	randcmdc ((`var') reg qual_adj_output tournament tournament_sabotage male international_student risk_taker, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in tournament tournament_sabotage {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1)
	randcmdc ((`var') reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in tournament tournament_sabotage {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1)
	randcmdc ((`var') reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, robust), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in tournament tournament_sabotage {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1)
	randcmdc ((`var') xtreg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}



********************************************

*Note, 2nd regression achieves convergence under Stata13 (which has better computation algorithm), but coefficients
*reported in the paper are based on the unconverged coefficients achieved in earlier versions of Stata.
*So, use Stata 10 to analyse distribution of this regression

use DatCMS2, clear

*Table 3
mycmd (tournament diff_out_t pos_diff_t tournament_sabotage diff_out_ts pos_diff_ts) xtreg output_sabotage tournament diff_out_t pos_diff_t tournament_sabotage diff_out_ts pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament diff_out_t pos_diff_t tournament_sabotage diff_out_ts pos_diff_ts) xtmixed output_sabotage tournament diff_out_t pos_diff_t tournament_sabotage diff_out_ts pos_diff_ts pos_diff diff_output male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
mycmd (tournament diff_out_t pos_diff_t tournament_sabotage diff_out_ts pos_diff_ts) xtreg quality_sabotage tournament diff_out_t pos_diff_t tournament_sabotage diff_out_ts pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament diff_out_t pos_diff_t tournament_sabotage diff_out_ts pos_diff_ts) xtmixed quality_sabotage tournament diff_out_t pos_diff_t tournament_sabotage diff_out_ts pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
	
*Table 3 (interactions)

forvalues j = 1/24 {
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
save results\FisherCondCMS, replace


