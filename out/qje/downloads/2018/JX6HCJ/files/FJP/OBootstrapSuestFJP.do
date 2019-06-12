
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
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in'
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

use DatFJP, clear

*Table 2
global i = 0
foreach var in taken_new tdeposits {
	mycmd(Treated Treated_Hindu_SC_Kat Treated_muslim) reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	}

suest $M, cluster(t_group)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

*Table 3
global i = 0
foreach var in Dummy_Client_Income Talk_Fam {
	mycmd(Treated Treated_Hindu_SC_Kat Treated_muslim) reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	}

suest $M, cluster(t_group)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

gen Order = _n
sort t_group Order
gen N = 1
gen Dif = (t_group ~= t_group[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop t_group
	rename obs t_group

*Table 2
global i = 0
foreach var in taken_new tdeposits {
	mycmd(Treated Treated_Hindu_SC_Kat Treated_muslim) reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	}

capture suest $M, cluster(t_group)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}

*Table 3
global i = 0
foreach var in Dummy_Client_Income Talk_Fam {
	mycmd(Treated Treated_Hindu_SC_Kat Treated_muslim) reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	}

capture suest $M, cluster(t_group)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/10 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestFJP, replace

erase aa.dta
erase aaa.dta

