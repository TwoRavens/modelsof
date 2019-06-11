
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
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

global N = 43
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y1")

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y1",Y)
	forvalues i = 1/$N {
		quietly replace odd = Y1[`i'] if fahrer == Y2[`i']
		}
	quietly replace high = 0
	quietly replace high = 1 if odd + block == 3
*Reproducing systematic coding error
	quietly replace high = 0 if fahrer == 10


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
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
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
sort N
save ip\FisherSuestFG1, replace

**********************************
 
use DatFG2, clear

*Table 5 
global i = 0
mycmd (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 

suest $M, cluster(datum)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*Table 6 
global i = 0
mycmd (high_la high_not0) areg lnum high_la high_not0 lnten fdum*, absorb(datum) cluster(datum) 
mycmd (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 

suest $M, cluster(datum)
test $test
matrix F = F\ (r(p), r(drop), r(df), r(chi2), 6)

global N = 43
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y1")
replace odd = 0 if odd == .

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y1",Y)
	forvalues i = 1/$N {
		quietly replace odd = Y1[`i'] if fahrer == Y2[`i']
		}
	quietly replace high = 0
	quietly replace high = 1 if odd + block == 3 & t ~= 29
	foreach i in la la1 la2 not0 {
		quietly replace high_`i' = high*`i'
		}

*Table 5 
global i = 0
mycmd (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 

capture suest $M, cluster(fahrer)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}

*Table 6 
global i = 0
mycmd (high_la high_not0) areg lnum high_la high_not0 lnten fdum*, absorb(datum) cluster(datum) 
mycmd (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 

capture suest $M, cluster(fahrer)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
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
sort N
save ip\FisherSuestFG2, replace

**********************************

use ip\FisherSuestFG1, clear
merge 1:1 N using ip\FisherSuestFG2, nogenerate
drop F*
svmat double F
aorder
save results\FisherSuestFG, replace




