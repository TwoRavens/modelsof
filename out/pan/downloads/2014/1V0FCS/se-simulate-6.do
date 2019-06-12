 * se-simulate-6.do --- 
 * 
 * Filename: se-simulate-6.do
 * Author: Arzheimer & Evans
 *

 * Commentary: 
 * 6 parties
 * 
 *

 * Change log:
 * 
 * 
 *

* Easier to create artificial data from DS
use scbmat-6.dta, clear
set obs 50000


set seed 123456789

* Matrix for party system
matrix v = J(18,6,0)

forvalues p = 1/9 {
	matrix v[`p',1] = (.5,.1,.1,.1,.1,.1)
	}

forvalues p = 10/18 {
	matrix v[`p',1] = (0.3,.3,.05,.05,.15,.15)
	}


* Counters
local zfield "betaeins betazwei betadrei betavier betafuenf betasechs"




* Generate correlated betas

forvalues s = 1/18 {
	mkmat coeff_`s'_1 coeff_`s'_2 coeff_`s'_3 coeff_`s'_4 coeff_`s'_5 in 1,mat(means)
	mkmat vce_`s'_1 vce_`s'_2 vce_`s'_3 vce_`s'_4 vce_`s'_5 in 1/5,mat(cov)
	corr2data betazwei_`s' betadrei_`s' betavier_`s' betafuenf_`s' betasechs_`s' ,means(means) cov(cov) 

* Constant
	gen byte betaeins_`s' = 0
	
* Calculate A's
	forvalues z = 1/6 {
		local zaehler : word `z' of `zfield'
* Multiplier
		local faktor = (1- v[`s',`z']) / v[`s',`z']
* Fraction
		local denominator "1 + exp(betazwei_`s') + exp(betadrei_`s') + exp(betavier_`s') + exp(betafuenf_`s') + exp(betasechs_`s')"
		local innerfraction "(exp(`zaehler'_`s') / (`denominator'))"
* Generate primes
		gen aprime_`z'_`s' = ln(`innerfraction' / (1 - `innerfraction') * `faktor')
		}
	}


save party6simulations,replace


* se-simulate-6.do ends here
