use FNIdataset if german==1, clear

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

tabstat FNI onegerman popcit yrsuspop, statistics(mean sd N) columns(stats)
tabstat momcit yrsusmom if mbpl>100, statistics(mean sd N) columns(stats)	// relevant only for mothers born abroad 
