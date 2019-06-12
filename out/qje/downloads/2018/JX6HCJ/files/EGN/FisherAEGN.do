
*Randomize at treatment level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ll]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `ll'
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
	syntax anything [if] [in] [, cluster(string) ll iterate(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`iterate'" == "") {
		capture `anything' `if' `in', cluster(`cluster') `ll'
		scalar conv = 1
		}
	else {
		capture `anything' `if' `in', cluster(`cluster') iterate(`iterate')
		scalar conv = e(converged)
		}
	if (_rc == 0 & scalar(conv) == 1) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatEGN, clear

matrix F = J(5,4,.)
matrix B = J(7,2,.)

global i = 1
global j = 1

mycmd (t2) probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3, cluster(session)
mycmd (t2) reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3 & send_ij>0, cluster(session)
mycmd (t4) probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2, cluster(session)
mycmd (t4) reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2 & send_ij>0, cluster(session)
mycmd (t2 t3 t4) reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1, cluster(session)

*Although the authors describe as two experiments, all treatments on Univ. of Melbourne students, and collected same information, so sessions interchangeable
*Use same regressors in tables for the two experiments, distribution of earnings the same in both experiments, etc.
*Use both experiments together in tables 7 and 8

bysort session: gen NN = _n
sort NN session
global N = 9
mata Y = st_data((1,$N),("t2","t3","t4","treatment"))
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.); ResD = J($reps,5,.); ResDF = J($reps,5,.); ResB = J($reps,7,.); ResSE = J($reps,7,.)
forvalues c = 1/$reps {
	matrix FF = J(5,3,.)
	matrix BB = J(7,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("t2","t3","t4","treatment"),Y)
	sort session NN
	foreach j in t2 t3 t4 treatment {
		quietly replace `j' = `j'[_n-1] if NN > 1
		}

global i = 1
global j = 1

mycmd1 (t2) probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3, cluster(session) iterate(100)
mycmd1 (t2) reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3 & send_ij>0, cluster(session)
mycmd1 (t4) probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2, cluster(session) iterate(100)
mycmd1 (t4) reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2 & send_ij>0, cluster(session)
mycmd1 (t2 t3 t4) reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1, cluster(session)
	
mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..5] = FF[.,1]'; ResD[`c',1..5] = FF[.,2]'; ResDF[`c',1..5] = FF[.,3]'
mata ResB[`c',1..7] = BB[.,1]'; ResSE[`c',1..7] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/5 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/7 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\FisherAEGN, replace







