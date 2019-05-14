use FNIdataset if german==1, clear

* parents' characteristics
* one parent German
gen onegerman=1 if (fbpl==453&mbpl!=453)|(fbpl!=453&mbpl==453)
replace onegerman=0 if (fbpl==453&mbpl==453)
* father US citizen
gen popcit=(citizen_pop==2)
replace popcit=. if citizen_pop==0|citizen_pop==5
* mother US citizen
gen momcit=(citizen_mom==2)
replace momcit=. if citizen_mom==0|citizen_mom==5
* years of father in the US (at year of birth)
gen yrsuspop=yrsusa1_pop-(year-birthyear)
replace yrsuspop=. if yrsusa1_pop==.
* years of mother in the US (at year of birth)
gen yrsusmom=yrsusa1_mom-(year-birthyear)
replace yrsusmom=. if yrsusa1_mom==.
* father self-employed
gen self=(classwkr_pop==1)
replace self=. if classwkr_pop==.


gen postwar=(birthyear>=1917)
gen interone=postwar*onegerman
gen intercitpop=postwar*popcit
gen intercitmom=postwar*momcit
gen interyrspop=postwar*yrsuspop
gen interyrsmom=postwar*yrsusmom
gen interself=postwar*self


* regressions
estimates clear
xi: reg FNI i.birthyear interone onegerman, ro
eststo m1
xi: reg FNI i.birthyear intercitpop popcit if fbpl==453, ro
eststo m2
xi: reg FNI i.birthyear intercitmom momcit if mbpl==453, ro
eststo m3
xi: reg FNI i.birthyear interyrspop yrsuspop if fbpl==453, ro
eststo m4
xi: reg FNI i.birthyear interyrsmom yrsusmom if mbpl==453, ro
eststo m5
xi: reg FNI i.birthyear interself self if fbpl==453, ro
eststo m6
esttab m* using "TableE1.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) stats(N r2) keep(onegerman popcit momcit self yrsus* inter*) 
