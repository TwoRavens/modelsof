
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	if ("`cmd'" == "probit") capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', iterate(50)
	if ("`cmd'" ~= "probit") capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', 
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************


use DatEGN, clear

*Table 3
global i = 0
mycmd (t2) probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3, 
mycmd (t2) reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3 & send_ij>0, 

suest $M, cluster(subject)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

*Table 6
global i = 0
mycmd (t4) probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2, 
mycmd (t4) reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2 & send_ij>0, 

suest $M, cluster(subject)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)
matrix B6 = B[1,1..$j]

*Table 7
global i = 0
mycmd (t2 t3 t4) reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1

suest $M, cluster(subject)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)
matrix B7 = B[1,1..$j]

gen Order = _n
sort subject Order
gen N = 1
gen Dif = (subject ~= subject[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,15,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop subject
	rename obs subject

*Table 3
global i = 0
mycmd (t2) probit send  t2  myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3, 
mycmd (t2) reg send_ij t2 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 pos_diff_words neg_diff_words male law age commerce arts science year_of_study time_in_australia if treatment<3 & send_ij>0, 

capture suest $M, cluster(subject)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 6
global i = 0
mycmd (t4) probit send t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2, 
mycmd (t4) reg send_ij t4 myr2_2 myr2_3 myr2_4 yrr2_2 yrr2_3 yrr2_4 male age commerce law arts science year_of_study time_in_australia if treatment>2 & send_ij>0, 

capture suest $M, cluster(subject)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
		}
	}

*Table 7
global i = 0
mycmd (t2 t3 t4) reg wordspermin t2 t3 t4 male age commerce law arts science year_of_study time_in_australia if n == 1

capture suest $M, cluster(subject)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B7)*invsym(V)*(B[1,1..$j]-B7)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/15 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestEGN, replace

erase aa.dta
erase aaa.dta


