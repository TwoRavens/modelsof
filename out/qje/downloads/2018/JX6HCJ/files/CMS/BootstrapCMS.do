
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust mle iterate(string)]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	if ("`iterate'" == "") `anything' `if' `in', `robust' `mle'
	if ("`iterate'" ~= "") `anything' `if' `in', `robust' `mle' iterate(`iterate')
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	xtset
	local panelvar = r(panelvar)
	forvalues i = 1/$reps {
		set seed `i'
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			if ("`panelvar'" == "$cluster") {
				quietly replace id_number = `newcluster'
				xtset id_number
				}
			if ("`iterate'" == "") `anything' `if' `in', `robust' `mle'
			if ("`iterate'" ~= "") `anything' `if' `in', `robust' `mle' iterate(`iterate')
			if (_rc == 0) {
			capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
			capture testparm `testvars'
			if (_rc == 0 & r(df) == $k) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
				if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
				if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
				}
				}
		restore
		}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
	restore
		global i = $i + 1
		global j = $j + $k

end


*******************

*id_number is individual observation in this file, multiple observations in the next
*In order to sample consistently (all regressions have same sample) at level they specify (no clustering), sample at id_number
*This file is xtset session_id, so no need to reset after bootstrap; next is xtset id_number, need to reset after bootstrap

global cluster = "id_number"

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
	
************************************************


use ip\BS1, clear
forvalues i = 2/9 {
	merge using ip\BS`i'
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
save results\BootstrapCMS, replace

