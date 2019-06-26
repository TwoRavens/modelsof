
log using gartzke_climate_09232011.log, replace

use gartzke_climate_09232011_before.dta, clear
set more off

tsset year, yearly


sort year

gen msyspop=syspop/1000000
la var msyspop "syspop/1000000"

gen Annual_Mean2=Annual_Mean*Annual_Mean
la var Annual_Mean2 "Annual_Mean*Annual_Mean"

gen pcenerg2= pcenerg*pcenerg
la var pcenerg2 "pcenerg*pcenerg"

gen propdem2=propdem*propdem
la var propdem2 "propdem*propdem"

gen tenumioyear=enumioyear/1000
la var tenumioyear "enumioyear/1000"

gen tenumioyear2=tenumioyear*tenumioyear
la var tenumioyear2 "tenumioyear*tenumioyear"








eststo: estsimp nbreg mids Annual_Mean msyspop numpols, nolog robust sims(10000)
drop b1 b2 b3 b4 b5

eststo: estsimp nbreg mids Annual_Mean Annual_Mean2 msyspop numpols, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6

eststo: estsimp nbreg mids Annual_Mean Annual_Mean2 propdem msyspop numpols, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6 b7

eststo: estsimp nbreg mids Annual_Mean Annual_Mean2 propdem propdem2 msyspop numpols, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6 b7 b8

eststo: estsimp nbreg mids Annual_Mean Annual_Mean2 propdem propdem2 pcenerg msyspop numpols, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9

eststo: estsimp nbreg mids Annual_Mean Annual_Mean2 propdem propdem2 pcenerg pcenerg2 msyspop numpols, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10

eststo: estsimp nbreg mids Annual_Mean Annual_Mean2 propdem propdem2 pcenerg pcenerg2 tenumioyear msyspop numpols, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11

eststo: estsimp nbreg mids Annual_Mean Annual_Mean2 propdem propdem2 pcenerg pcenerg2 tenumioyear tenumioyear2 msyspop numpols, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12

esttab using table1.tex, nogaps se(a3) replace
eststo clear



eststo: estsimp nbreg mids Annual_Mean Annual_Mean2 propdem propdem2 pcenerg pcenerg2 tenumioyear tenumioyear2 msyspop numpols counter counter2 counter3, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15


eststo: estsimp nbreg fat1 a_year_Mean propdem pcenerg tenumioyear worlddepi usheg msyspop numpols counter counter2 counter3, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13


eststo: estsimp nbreg fat1 a_year_Mean propdem pcenerg tenumioyear worlddepi usheg postcoldwar msyspop numpols counter counter2 counter3, nolog robust sims(10000)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14


esttab using table2.tex, nogaps wide se(a3) replace
eststo clear



*gen msysengy=sysengy/1000000

sort year

dfuller Annual_Mean, regress trend

summarize Annual_Mean
gen xAnnual_Mean=Annual_Mean+0.0584426
gen xAnnual_Mean1d=xAnnual_Mean-xAnnual_Mean[_n-1]
gen xAnnual_Mean1d2=xAnnual_Mean1d*xAnnual_Mean1d

dfuller xAnnual_Mean1d, regress trend


dfuller hadcrut3_gl, regress trend

summarize hadcrut3_gl
gen hadcrut3_gl1d=hadcrut3_gl-hadcrut3_gl[_n-1]
gen hadcrut3_gl1d2=hadcrut3_gl1d*hadcrut3_gl1d

dfuller hadcrut3_gl1d, regress trend


dfuller pcenerg, regress trend

gen lpcenerg=ln(pcenerg)
summarize lpcenerg
gen xlpcenerg=lpcenerg+0.4408935
gen xlpcenerg1d=xlpcenerg-xlpcenerg[_n-1]
gen xlpcenerg1d2=xlpcenerg1d*xlpcenerg1d

dfuller xlpcenerg1d, regress trend


dfuller propdem, regress trend

summarize propdem
gen xpropdem=propdem-0.242863
gen xpropdem1d=xpropdem-xpropdem[_n-1]
gen xpropdem1d2=xpropdem1d*xpropdem1d

dfuller xpropdem1d, regress trend


dfuller tenumioyear, regress trend


gen ltenumioyear=ln(tenumioyear)
summarize ltenumioyear
gen xltenumioyear= ltenumioyear+3.657406
gen xltenumioyear1d= xltenumioyear-xltenumioyear[_n-1]
gen xltenumioyear1d2= xltenumioyear1d*xltenumioyear1d

dfuller xltenumioyear1d, regress trend




eststo:  nbreg mids xAnnual_Mean1d xAnnual_Mean1d2 xlpcenerg1d xlpcenerg1d2 xpropdem1d xpropdem1d2 xltenumioyear1d xltenumioyear1d2, nolog robust

eststo:  nbreg mids hadcrut3_gl1d hadcrut3_gl1d2 xlpcenerg1d xlpcenerg1d2 xpropdem1d xpropdem1d2 xltenumioyear1d xltenumioyear1d2, nolog robust


eststo:  nbreg fat1 hadcrut3_gl1d hadcrut3_gl1d2 xlpcenerg1d xlpcenerg1d2 xpropdem1d xpropdem1d2 xltenumioyear1d xltenumioyear1d2, nolog robust


esttab using table3.tex, nogaps wide se(a3) replace


save gartzke_climate_09232011_after.dta, replace


