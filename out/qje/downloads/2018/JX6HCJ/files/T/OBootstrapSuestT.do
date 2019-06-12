
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
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

use DatT, clear

*Table 4
global i = 0
mycmd (any) reg got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc) reg got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any) probit got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc) probit got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) probit got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) probit got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) probit got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 

suest $M, cluster(villnum)
test $test
matrix F = r(p), r(drop), r(df), r(chi2), 4
matrix B4 = B[1,1..$j]

*Table 5 
global i = 0
mycmd (any tinc tincs) reg got any tinc tincs male hiv2004 over tb thinktreat mar simave rumphi balaka if MainSample == 1, robust cluster(villnum)
mycmd (any tinc tincs any_never) reg got any tinc tincs any_never male hiv2004 over simave never rumphi balaka if mar==0 & MainSample == 1, robust cluster(villnum)
mycmd (any tinc tincs male_any) reg got any tinc tincs male_any male hiv2004 over simave if balaka== 1 & MainSample == 1, robust cluster(villnum)
mycmd (any tinc tincs over_any) reg got any tinc tincs over_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs over over_hiv hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs hiv_any) reg got any tinc tincs hiv_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 

suest $M, cluster(villnum)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

*Table 6
global i = 0
mycmd (any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004) reg got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi  if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)
mycmd (any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004) reg hiv_got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)

suest $M, cluster(villnum)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)
matrix B6 = B[1,1..$j]

generate Order = _n
drop if villnum == .
sort villnum Order
generate N = 1
generate Dif = (villnum ~= villnum[_n-1])
replace N = N[_n-1] + Dif if _n > 1
drop Dif
sort N 
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
	drop villnum
	rename obs villnum

*Table 4
global i = 0
mycmd (any) reg got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc) reg got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any) probit got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc) probit got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) probit got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) probit got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) probit got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 

capture suest $M, cluster(villnum)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

*Table 5 
global i = 0
mycmd (any tinc tincs) reg got any tinc tincs male hiv2004 over tb thinktreat mar simave rumphi balaka if MainSample == 1, robust cluster(villnum)
mycmd (any tinc tincs any_never) reg got any tinc tincs any_never male hiv2004 over simave never rumphi balaka if mar==0 & MainSample == 1, robust cluster(villnum)
mycmd (any tinc tincs male_any) reg got any tinc tincs male_any male hiv2004 over simave if balaka== 1 & MainSample == 1, robust cluster(villnum)
mycmd (any tinc tincs over_any) reg got any tinc tincs over_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs) reg got any tinc tincs over over_hiv hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
mycmd (any tinc tincs hiv_any) reg got any tinc tincs hiv_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 

capture suest $M, cluster(villnum)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}

*Table 6
global i = 0
mycmd (any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004) reg got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi  if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)
mycmd (any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004) reg hiv_got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)

capture suest $M, cluster(villnum)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
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
save results\OBootstrapSuestT, replace

erase aa.dta
erase aaa.dta

