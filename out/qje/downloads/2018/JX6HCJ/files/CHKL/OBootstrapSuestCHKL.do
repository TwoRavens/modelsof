
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ll ]
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
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', `ll'
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

use DatCHKL, clear

*Table 7 
global i = 0
mycmd (dumconf dumnetb) tobit post_rating dumconf dumnetb pre_rating, ll 
mycmd (dumconf) tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
mycmd (dumnetb) tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 

suest $M, robust
test $test
matrix F = r(p), r(drop), r(df), r(chi2), 7
matrix B7 = B[1,1..$j]

sort userid 
gen N = _n
save aa, replace

egen NN = max(N)
keep NN
save aaa, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

*Table 7 
global i = 0
mycmd (dumconf dumnetb) tobit post_rating dumconf dumnetb pre_rating, ll 
mycmd (dumconf) tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
mycmd (dumnetb) tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B7)*invsym(V)*(B[1,1..$j]-B7)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/5 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestCHKL, replace

erase aa.dta
erase aaa.dta

