
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster')
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
	syntax anything [if] [in] [, cluster(string) iterate(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`iterate'" == "") capture `anything' `if' `in', cluster(`cluster') 
	if ("`iterate'" ~= "") capture `anything' `if' `in', cluster(`cluster') iterate(`iterate')
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
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

global a = 5
global b = 7

use DatEGN, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

mycmd (t2) probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3, cluster(session)
mycmd (t2) reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3&send_ij>0, cluster(session)
mycmd (t4) probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2, cluster(session)
mycmd (t4) reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2&send_ij>0, cluster(session)
mycmd (t2 t3 t4) reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1, cluster(session)

gen Order = _n
sort session Order
gen N = 1
gen Dif = (session ~= session[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,3,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop session
	rename obs session

global i = 1
global j = 1

mycmd1 (t2) probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3, cluster(session) iterate(25)
mycmd1 (t2) reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3&send_ij>0, cluster(session)
mycmd1 (t4) probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2, cluster(session) iterate(25)
mycmd1 (t4) reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2&send_ij>0, cluster(session)
mycmd1 (t2 t3 t4) reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1, cluster(session)
	
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
save results\OBootstrapAEGN, replace

erase aa.dta
erase aaa.dta

