
***Replicate Table I***

set mem 2m
use C:kochdurationreplication.dta"

stset time if time~=., failure(failure==1)id(midid)

streg govrlsd govrlsd2 left   majority lnciep demtarg initiate c2 allyd newbal salient  , d(weibull) frailty(gamma) shared(dyadid2) nohr
streg govrlsd govrlsd2 left   majority lnciep demtarg initiate c2 allyd newbal salient if force==1  , d(weibull) frailty(gamma) shared(dyadid2) nohr
streg govrlsd govrlsd2 left   majority lnciep demtarg initiate c2 allyd newbal if salient==1   , d(weibull) frailty(gamma) shared(dyadid2) nohr


***Replicate Table II***

set mem 200m
use "C:Govpardata.dta"
***LOGIT ONSET MODEL***
logit conflict govrlsd govrlsd2 left   majority lnciep demopp  c2 allyd newbal peaceyrs _spline1 _spline2 _spline3 if exclude==0, cluster(dyadid)

***FOR BOOTSTRAP DURATION REPLICATE RUN THE 30 do files***

use "C:btscoefv31.dta" 

append using  "C:btscoefv32.dta"
append using  "C:btscoefv33.dta"
append using  "C:btscoefv34.dta"
append using  "C:btscoefv35.dta"
append using  "C:btscoefv36.dta"
append using  "C:btscoefv37.dta"
append using  "C:btscoefv38.dta"
append using  "C:btscoefv39.dta"
append using  "C:btscoefv310.dta"
append using  "C:btscoefv311.dta"
append using  "C:btscoefv312.dta"
append using  "C:btscoefv313.dta"
append using  "C:btscoefv314.dta"
append using  "C:btscoefv315.dta"
append using  "C:btscoefv316.dta"
append using  "C:btscoefv317.dta"
append using  "C:btscoefv318.dta"
append using  "C:btscoefv319.dta"
append using  "C:btscoefv320.dta"
append using  "C:btscoefv321.dta"
append using  "C:btscoefv322.dta"
append using  "C:btscoefv323.dta"
append using  "C:btscoefv324.dta"
append using  "C:btscoefv325.dta"
append using  "C:btscoefv326.dta"
append using  "C:btscoefv327.dta"
append using  "C:btscoefv328.dta"
append using  "C:btscoefv329.dta"
append using  "C:btscoefv330.dta"

centile
