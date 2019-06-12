

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust mle iterate(string)]
	gettoken testvars anything: anything, match(match)
	if ("`iterate'" == "") `anything' `if' `in', `robust' `mle'
	if ("`iterate'" ~= "") `anything' `if' `in', `robust' `mle' iterate(`iterate')
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		if ("`iterate'" == "") quietly `anything' if M ~= `i', `robust' `mle'
		if ("`iterate'" ~= "") quietly `anything' if M ~= `i', `robust' `mle' iterate(`iterate')
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end



*******************


global cluster = "session"

global i = 1
global j = 1

use DatCMS1, clear

*Table 2
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, robust
mycmd (tournament tournament_sabotage) xtreg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle

********************************************

use DatCMS2, clear

*Table 3
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts pos_diff diff_output male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
	
use ip\JK1, clear
forvalues i = 2/9 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/9 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeACMS, replace


