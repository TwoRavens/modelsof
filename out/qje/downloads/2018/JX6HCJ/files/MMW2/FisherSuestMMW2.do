

use DatMMW2, clear
quietly tab strata, gen(S)
drop S1

*Table 2 

global i = 1

quietly reg tookup treat1 treat2 treat3 treat4, 
	estimates store M$i
	global i = $i + 1
quietly reg tookup treat1 treat2 treat3 treat4 S*, 
	estimates store M$i
	global i = $i + 1

quietly suest M1 M2, robust
test treat1 treat2 treat3 treat4 
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

*Table 3

global i = 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly suest M1 M2 M3 M4 M5, robust
test treat3 treat4 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

sort strata sheno
generate Order = _n
generate double U = .
mata Y = st_data(.,("treat1","treat2","treat3","treat4","treatgroup"))

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort strata U 
	mata st_store(.,("treat1","treat2","treat3","treat4","treatgroup"),Y)


*Table 2 

global i = 1

quietly reg tookup treat1 treat2 treat3 treat4, 
	estimates store M$i
	global i = $i + 1
quietly reg tookup treat1 treat2 treat3 treat4 S*, 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2, robust
if (_rc == 0) {
	capture test treat1 treat2 treat3 treat4 
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}

*Table 3

global i = 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5, robust
if (_rc == 0) {
	capture test treat3 treat4
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
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
sort N
save results\FisherSuestMMW2, replace



