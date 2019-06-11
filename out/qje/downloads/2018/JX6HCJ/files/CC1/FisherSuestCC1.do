
use DatCC1, clear

*Table 7 
global i = 1
probit Coop TICKET lagduration cycle2-cycle5 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2 & Period==1, 
	estimates store M$i
	global i = $i + 1

probit Coop TICKET lagduration cycle2-cycle5 periods* grimtrigger Lag1 Lag2 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2, 
	estimates store M$i
	global i = $i + 1

suest M1 M2, cluster(session)
test TICKET
matrix F = r(p), r(drop), r(df), r(chi2), 7

bysort session: gen N = _n
sort N session
global N = 4
mata Y = st_data((1,$N),"TICKET")
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"TICKET",Y)
	sort session N
	quietly replace TICKET = TICKET[_n-1] if session == session[_n-1]

*Table 7 
global i = 1
quietly probit Coop TICKET lagduration cycle2-cycle5 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2 & Period==1, 
	estimates store M$i
	global i = $i + 1

quietly probit Coop TICKET lagduration cycle2-cycle5 periods* grimtrigger Lag1 Lag2 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2, 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2, cluster(session)
if (_rc == 0) {
	capture test TICKET
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
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
save results\FisherSuestCC1, replace


