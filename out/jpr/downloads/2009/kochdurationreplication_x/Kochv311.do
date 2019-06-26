

capture log close
log using "C:jprbootv311", replace
clear
set more off
set mem 500m

***************** the bootstrapping process starts here *****************

capture use "C:btscoefv311.dta"
capture drop _all
capture set obs 1
capture gen double b1=.
capture gen double b2=.
capture gen double b3=.
capture gen double b4=.
capture gen double b5=.
capture gen double b6=.
capture gen double b7=.
capture gen double b8=.
capture gen double b9=.
capture gen double b10=.
capture gen double b11=.
capture gen double b12=.
capture gen double b13=.
capture gen double b14=.
capture gen double b15=.

capture save "C:btscoefv311.dta",replace
capture clear

use "C:Govpardata.dta"

keep conflict govrlsd govrlsd2 left majority lnciep demopp  c2 allyd newbal peaceyrs _spline1 _spline2 _spline3 dyadid time failure midid initiate salient exclude 


capture drop probMID
capture program drop btscox

program define btscox
preserve
bsample
qui logit conflict govrlsd govrlsd2 left   majority lnciep demopp  c2 allyd newbal peaceyrs _spline1 _spline2 _spline3 if exclude==0, cluster(dyadid)
qui predict probMID,pr
qui streg govrlsd govrlsd2 left   majority lnciep demopp probMID c2 allyd newbal salient initiate , d(weibull)  frailty(gamma) shared(dyadid)nohr
drop _all
matrix b=get(_b)
capture svmat b
capture append using "C:btscoefv311.dta"
save"C:btscoefv311.dta", replace
restore
end

stset time if time~=., failure(failure==1)id(midid)

set seed 16911

local i=0

while `i' < 40 {
		qui btscox
		qui local i=`i'+1
		display `i'
	}

