
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, mle robust iterate(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`iterate'" == "") capture `anything' `if' `in', `mle' 
	if ("`iterate'" ~= "") capture `anything' `if' `in', `mle' iterate(`iterate')
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
	syntax anything [if] [in] [, mle robust iterate(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`iterate'" == "") capture `anything' `if' `in', `mle' 
	if ("`iterate'" ~= "") capture `anything' `if' `in', `mle' iterate(`iterate')
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

global reps = 224

global b = 10

use DatCMS1, clear

matrix B = J(34,1,.)

global j = 1

*Table 2
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, robust
mycmd (tournament tournament_sabotage) xtreg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)

preserve

drop if id_number == `c'

global j = 1

*Table 2
mycmd1 (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage, robust
mycmd1 (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker, robust
mycmd1 (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor, robust
mycmd1 (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, robust
mycmd1 (tournament tournament_sabotage) xtreg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'
restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeCMS1, replace

********************************
********************************

global b = 24

use DatCMS2, clear

global j = 11

*Table 3
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts pos_diff diff_output male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
	
mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if id_number == `c'

global j = 1

*Table 3
mycmd1 (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd1 (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts pos_diff diff_output male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
mycmd1 (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd1 (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
	
mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'
restore

}

drop _all
set obs $reps
forvalues i = 11/34 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeCMS2, replace

*********
*********

use ip\OJackknifeCMS1, clear
merge using ip\OJackknifeCMS2
tab _m 
drop _m
aorder
svmat double B
save results\OJackknifeCMS, replace










