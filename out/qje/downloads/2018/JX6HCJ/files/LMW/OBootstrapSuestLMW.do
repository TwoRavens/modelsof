
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ll]
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


use DatLMW, clear

*Table 1
global i = 0
mycmd(sorting) reg percshared sorting , 
mycmd(sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, 
mycmd(sorting) tobit percshared sorting , ll 
mycmd(sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll 	
mycmd(sorting) probit percshared sorting , 
mycmd(sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, 

suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 1)
matrix B1 = B[1,1..$j]

*Table 2
global i = 0
mycmd(sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, 
mycmd(sorting) reg percshared sorting , 
matrix B2 = B[1,1..$j]

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)

gen N = _n
save aa, replace

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

*Table 1
global i = 0
mycmd(sorting) reg percshared sorting , 
mycmd(sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, 
mycmd(sorting) tobit percshared sorting , ll 
mycmd(sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll 	
mycmd(sorting) probit percshared sorting , 
mycmd(sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, 

capture suest $M, cluster(session)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B1)*invsym(V)*(B[1,1..$j]-B1)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 1)
		}
	}

*Table 2
global i = 0
mycmd(sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, 
mycmd(sorting) reg percshared sorting , 

capture suest $M, cluster(session)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
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
save results\OBootstrapSuestLMW, replace

erase aa.dta
erase aaa.dta

