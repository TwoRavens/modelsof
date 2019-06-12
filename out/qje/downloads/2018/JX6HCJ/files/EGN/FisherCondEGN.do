
*Randomize at authors' clustering level


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

use DatEGN, clear

matrix F = J(6,12,.)
matrix B = J(10,2,.)
matrix V = J(10,3,.)

global i = 1
global j = 1

mycmd (t2) probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3, cluster (subject)
mycmd (t2) reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3&send_ij>0, cluster (subject)
mycmd (t4) probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2, cluster (subject)
mycmd (t4) reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2&send_ij>0, cluster (subject)
mycmd (t2 t3 t4) reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1

*Although the authors describe as two experiments, all treatments on Univ. of Melbourne students, and collected same information, so sessions interchangeable
*Use same regressors in tables for the two experiments, distribution of earnings the same in both experiments, etc.
*Use both experiments together in tables 7 and 8

bysort subject: gen NN = _n
sort NN subject

egen m = group(t2 t3 t4), label
tab m
tab m, nolabel

global i = 0

*Table 2 
foreach var in t2 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1) 
	randcmdc ((`var') probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if (m == 1 | `var' == 1), cluster(subject)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(subject)
	}

foreach var in t2 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1) 
	randcmdc ((`var') reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if (m == 1 | `var' == 1) & send_ij>0, cluster(subject)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(subject)
	}

foreach var in t4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (t3 == 1 | `var' == 1) 
	randcmdc ((`var') probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if (t3 == 1 | t4 == 1), cluster(subject)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(subject)
	}

foreach var in t4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (t3 == 1 | `var' == 1) 
	randcmdc ((`var') reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if (t3 == 1 | t4 == 1) & send_ij>0, cluster(subject)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(subject)
	}

foreach var in t2 t3 t4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (m == 1 | `var' == 1) 
	randcmdc ((`var') reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(subject)
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
save results\FisherCondEGN, replace









