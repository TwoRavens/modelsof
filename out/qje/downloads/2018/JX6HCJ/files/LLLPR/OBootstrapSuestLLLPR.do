
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


use DatLLLPR.dta, clear
quietly tab id, gen(ID)
drop ID1

*Table 3 
global i = 0
mycmd (small_gift large_gift) reg donation small_gift large_gift warm_list ID*, 
mycmd (small_gift large_gift warm_small warm_large) reg donation small_gift large_gift warm_small warm_large warm_list ID*, 
mycmd (small_gift large_gift) reg donation small_gift large_gift warm_pVCM warm_pLotto ID*, 
matrix B3 = B[1,1..$j]

suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

*Table 4 
global i = 0
mycmd (small_gift large_gift) reg give small_gift large_gift warm_list ID*, 
mycmd (small_gift large_gift warm_small warm_large) reg give small_gift large_gift warm_small warm_large warm_list ID*, 
mycmd (small_gift large_gift) reg give small_gift large_gift warm_pVCM warm_pLotto ID*, 
matrix B4 = B[1,1..$j]

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

generate N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
save aaa, replace

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {

	if (ceil(`c'/50)*50 == `c') display "`c'"
	set seed `c'
	display `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

*Table 3 
global i = 0
mycmd (small_gift large_gift) reg donation small_gift large_gift warm_list ID*, 
mycmd (small_gift large_gift warm_small warm_large) reg donation small_gift large_gift warm_small warm_large warm_list ID*, 
mycmd (small_gift large_gift) reg donation small_gift large_gift warm_pVCM warm_pLotto ID*, 

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 4 
global i = 0
mycmd (small_gift large_gift) reg give small_gift large_gift warm_list ID*, 
mycmd (small_gift large_gift warm_small warm_large) reg give small_gift large_gift warm_small warm_large warm_list ID*, 
mycmd (small_gift large_gift) reg give small_gift large_gift warm_pVCM warm_pLotto ID*, 

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
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
save results\OBootstrapSuestLLLPR, replace

erase aa.dta
erase aaa.dta

