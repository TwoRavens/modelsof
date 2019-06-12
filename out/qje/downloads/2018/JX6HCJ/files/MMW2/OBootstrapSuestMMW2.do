
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

use DatMMW2, clear
quietly tab strata, gen(S)
drop S1

*Table 2 
global i = 0
mycmd (treat1 treat2 treat3 treat4)  reg tookup treat1 treat2 treat3 treat4, 
mycmd (treat1 treat2 treat3 treat4)  reg tookup treat1 treat2 treat3 treat4 S*, 

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

*Table 3
global i = 0
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, 

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
save aaa, replace

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

*Table 2 
global i = 0
mycmd (treat1 treat2 treat3 treat4)  reg tookup treat1 treat2 treat3 treat4, 
mycmd (treat1 treat2 treat3 treat4)  reg tookup treat1 treat2 treat3 treat4 S*, 

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}

*Table 3
global i = 0
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
mycmd(treat3 treat4)  probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, 

capture suest $M, robust
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
save results\OBootstrapSuestMMW2, replace

erase aa.dta
erase aaa.dta
