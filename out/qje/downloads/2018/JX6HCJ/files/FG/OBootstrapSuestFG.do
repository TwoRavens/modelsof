

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		matrix B = J(1,100,.)
		estimates clear
		global j = 0
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	else {
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' 
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture `cmd' `dep' `newtestvars' `anything' `if' `in', 
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatFG1, clear

*Table 3
global i = 0
mycmd (high) areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer) 
mycmd (high) areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)

suest $M, cluster(fahrer)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

capture drop _m
sort fahrer
merge fahrer using Sample1
tab _m
sort N
drop _m
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop fahrer
	rename obs fahrer

*Table 3
global i = 0
mycmd (high) areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer) 
mycmd (high) areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)

capture suest $M, cluster(fahrer)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
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
save ip\OBootstrapSuestFG1, replace



****************************************
****************************************

use DatFG2, clear

*Table 5 
global i = 0
mycmd (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 

suest $M, cluster(datum)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

*Table 6 
global i = 0
mycmd (high_la high_not0) areg lnum high_la high_not0 lnten fdum*, absorb(datum) cluster(datum) 
mycmd (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 

suest $M, cluster(datum)
test $test
matrix F = F\ (r(p), r(drop), r(df), r(chi2), 6)
matrix B6 = B[1,1..$j]

capture drop _m
sort fahrer
merge fahrer using Sample1
tab _m
sort N
drop _m
save bb, replace

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop fahrer
	rename obs fahrer

	drop if lnum == .
	drop fdum*
	quietly tab fahrer, gen(fdum)
	drop fdum1

*Table 5 
global i = 0
mycmd (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 

capture suest $M, cluster(datum)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}

*Table 6 
global i = 0
mycmd (high_la high_not0) areg lnum high_la high_not0 lnten fdum*, absorb(datum) cluster(datum) 
mycmd (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 

capture suest $M, cluster(datum)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
		}
	}
}

drop _all
set obs $reps
forvalues i = 6/15 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestFG2, replace

erase aa.dta
erase bb.dta
erase aaa.dta

use ip\OBootstrapSuestFG1, clear
merge 1:1 N using ip\OBootstrapSuestFG2, nogenerate
drop F*
svmat double F
aorder
save results\OBootstrapSuestFG, replace




