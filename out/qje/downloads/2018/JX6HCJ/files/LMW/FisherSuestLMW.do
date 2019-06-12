
use DatLMW, clear

*Table 1

global i = 1

reg percshared sorting , 
		estimates store M$i
		global i = $i + 1

reg percshared sorting sortBarcelona Barcelona, 
		estimates store M$i
		global i = $i + 1

tobit percshared sorting , ll 
		estimates store M$i
		global i = $i + 1

tobit percshared sorting sortBarcelona Barcelona, ll 	
		estimates store M$i
		global i = $i + 1

probit percshared sorting , 
		estimates store M$i
		global i = $i + 1

probit percshared sorting sortBarcelona Barcelona, 
		estimates store M$i
		global i = $i + 1

suest M1 M2 M3 M4 M5 M6, robust
test sorting sortBarcelona
matrix F = (r(p), r(drop), r(df), r(chi2), 1)


*Table 2

global i = 1

reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, 
		estimates store M$i
		global i = $i + 1

reg percshared sorting , 
		estimates store M$i
		global i = $i + 1

suest M1 M2, robust
test sorting 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)

mata Y = st_data(.,"sorting")
generate Order = _n
generate double U = .

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort U 
	mata st_store(.,"sorting",Y)
	quietly replace sortBarcelona = sorting*Barcelona

*Table 1
estimates clear
global i = 1
capture reg percshared sorting , 
		if (_rc == 0) estimates store M$i
		global i = $i + 1
capture reg percshared sorting sortBarcelona Barcelona, 
		if (_rc == 0) estimates store M$i
		global i = $i + 1
capture tobit percshared sorting , ll 
		if (_rc == 0) estimates store M$i
		global i = $i + 1
capture tobit percshared sorting sortBarcelona Barcelona, ll 	
		if (_rc == 0) estimates store M$i
		global i = $i + 1
capture probit percshared sorting , 
		if (_rc == 0) estimates store M$i
		global i = $i + 1
capture probit percshared sorting sortBarcelona Barcelona, 
		if (_rc == 0) estimates store M$i
		global i = $i + 1
capture suest M1 M2 M3 M4 M5 M6, robust
if (_rc == 0) {
	capture test sorting sortBarcelona
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 1)
		}
	}

*Table 2
estimates clear
global i = 1
capture reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, 
		if (_rc == 0) estimates store M$i
		global i = $i + 1
capture reg percshared sorting , 
		if (_rc == 0) estimates store M$i
		global i = $i + 1
capture suest M1 M2, robust
if (_rc == 0) {
	capture test sorting 
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
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
save results\FisherSuestLMW, replace


