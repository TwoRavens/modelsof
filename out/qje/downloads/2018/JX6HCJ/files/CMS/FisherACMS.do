*Run in Stata 10
*randomizing at treatment level
*Note, xtreg mle and xtmixed do not allow clustering


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust mle iterate(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`iterate'" ~= "") {
		`anything' `if' `in', iterate(`iterate')
		}
	else if ("`mle'" ~= "") {
		`anything' `if' `in', `mle'
		}
	else {
		`anything' `if' `in', cluster(`cluster')
		}
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
	syntax anything [if] [in] [, robust mle iterate(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`iterate'" ~= "") {
		quietly `anything' `if' `in', iterate(`iterate')
		}
	else if ("`mle'" ~= "") {
		quietly `anything' `if' `in', `mle'
		}
	else {
		quietly `anything' `if' `in', cluster(`cluster')
		}
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

use DatCMS1, clear

matrix F = J(5,4,.)
matrix B = J(10,2,.)

global i = 1
global j = 1

*Table 2
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage, cluster(session)
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker, cluster(session)
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor, cluster(session)
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, cluster(session)
mycmd (tournament tournament_sabotage) xtreg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle

bys session_id: gen N = _n
sort N session_id
global N = 28
mata Y = st_data((1,$N),("tournament","tournament_sabotage"))
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.); ResD = J($reps,5,.); ResDF = J($reps,5,.); ResB = J($reps,10,.); ResSE = J($reps,10,.)
forvalues c = 1/$reps {
	matrix FF = J(5,3,.)
	matrix BB = J(10,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("tournament","tournament_sabotage"),Y)
	sort session_id N
	foreach j in tournament tournament_sabotage {
		quietly replace `j' = `j'[_n-1] if session_id == session_id[_n-1] 
		}

global i = 1
global j = 1

*Table 2
mycmd1 (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage, cluster(session)
mycmd1 (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker, cluster(session)
mycmd1 (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor, cluster(session)
mycmd1 (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, cluster(session)
mycmd1 (tournament tournament_sabotage) xtreg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..5] = FF[.,1]'; ResD[`c',1..5] = FF[.,2]'; ResDF[`c',1..5] = FF[.,3]'
mata ResB[`c',1..10] = BB[.,1]'; ResSE[`c',1..10] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/5 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/10 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\FisherACMS1, replace

********************************************

*Note, 2nd regression achieves convergence under Stata13 (which has better computation algorithm), but coefficients
*reported in the paper are based on the unconverged coefficients achieved in earlier versions of Stata.
*So, use Stata 10 to analyse distribution of this regression

use DatCMS2, clear

matrix F = J(4,4,.)
matrix B = J(24,2,.)

global i = 1
global j = 1

*Table 3
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts pos_diff diff_output male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
	
*This will generate same randomization as above, because session numbers are the same (double checked by merging characteristics of participants and treatment)
bys session: gen N = _n
sort N session
global N = 28
mata Y = st_data((1,$N),("tournament","tournament_sabotage"))
generate Order = _n
generate double U = .

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,24,.); ResSE = J($reps,24,.)
forvalues c = 1/$reps {
	matrix FF = J(4,4,.)
	matrix BB = J(24,3,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("tournament","tournament_sabotage"),Y)
	sort session N
	foreach j in tournament tournament_sabotage {
		quietly replace `j' = `j'[_n-1] if session == session[_n-1] 
		}
	quietly replace diff_out_t=diff_output*tournament
	quietly replace diff_out_ts=diff_output*tournament_sabotage
	quietly replace pos_diff_t=pos_diff*tournament
	quietly replace pos_diff_ts=pos_diff*tournament_sabotage

global i = 1
global j = 1

*Table 3
mycmd1 (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd1 (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts pos_diff diff_output male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
mycmd1 (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd1 (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..24] = BB[.,1]'; ResSE[`c',1..24] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/24 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\FisherACMS2, replace

********************************

use ip\FisherACMS2, clear
mkmat F1-F4 in 1/4, matrix(F2)
mkmat B1 B2 in 1/24, matrix(B2)
drop F1-F4 B1-B2 
forvalues i = 4(-1)1 {
	local j = `i' + 5
	rename ResF`i' ResF`j'
	rename ResDF`i' ResDF`j'
	rename ResD`i' ResD`j'
	}
forvalues i = 24(-1)1 {
	local j = `i' + 10
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
sort N
save a2, replace

use ip\FisherACMS1, clear
mkmat F1-F4 in 1/5, matrix(F1)
mkmat B1 B2 in 1/10, matrix(B1)
drop F1-F4 B1-B2 
sort N
merge N using a2
tab _m
drop _m
matrix F = F1 \ F2
matrix B = B1 \ B2
svmat double F
svmat double B
aorder
save results\FisherACMS, replace










