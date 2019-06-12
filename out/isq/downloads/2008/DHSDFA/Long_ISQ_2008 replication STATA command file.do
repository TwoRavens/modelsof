
* This do file contains the analysis for Table 1 of "Bilateral Trade and Rational Expectations of Armed Conflict" and all 
* additional analysis referred to in the article.

set mem 500m
set matsize 5000
use "C:\(full path here)\ArmedConflict_BilateralTrade.dta"

tsset ddyad year

*AR1 test.
xtserial ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival

*Full Model
xtpcse ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival, c(ar1) hetonly

logdummy wtopta jdem allies border strival
sum ddyad year ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if e(sample)
corr ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if e(sample)


*Drop border variable.
xtpcse ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival, c(ar1) hetonly

logdummy wtopta jdem allies strival
sum ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if e(sample)
corr ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if e(sample)


*Drop Similarity variable.
xtpcse ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival, c(ar1) hetonly

logdummy wtopta jdem allies border strival
sum ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if e(sample)
corr ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if e(sample)


*Drop imputed zero values of trade.
xtpcse ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if ldtrad>-8, c(ar1) hetonly

logdummy wtopta jdem allies border strival
sum ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if e(sample)
corr ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if e(sample)


*Fixed Effects Model
xtregar ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival, fe twostep rhot(tsc)
logdummy wtopta jdem allies border strival

*Random Effects Model
xtregar ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival, re twostep rhot(tsc)
logdummy wtopta jdem allies border strival

*Fixed Effects Model without zero imputed values.
xtregar ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if ldtrad>-8, fe twostep rhot(tsc)
logdummy wtopta jdem allies border strival

*Random Effects Model without zero imputed values.
xtregar ldtrad lgdp1 lgdp2 lgdppc1 lgdppc2 ldist border wtopta jdem allies lnS doarmcf1 doarmcf2 moarmcf1 moarmcf2 dyarmcf lprsicf1 lprsicf2 lprsecf1 lprsecf2 strival if ldtrad>-8, re twostep rhot(tsc)
logdummy wtopta jdem allies border strival

