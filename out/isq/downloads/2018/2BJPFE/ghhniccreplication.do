clear
clear matrix
set mem 500m
set more off

log using C:\Work\ghhniccreplication.log, replace

cd C:\Work 	// change to directory with imputed data sets

* TABLE 1
* SIGN
miest ghhn cloglog signed pol regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)
miest ghhn cloglog signed signpropdefwc_3 pol regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)
miest ghhn cloglog signed signproptrade_3 pol regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)
miest ghhn cloglog signed signpropigo23f3u_3 pol regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)
miest ghhn cloglog signed signpropdefwc_3 signproptrade_3 signpropigo23f3u_3 pol regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)
miest ghhn cloglog signed signindex_3 pol regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)
* RATIFY
miest ghhn cloglog ratified pol regionratpropns_3 ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)
miest ghhn cloglog ratified ratpropdefwc_3 pol regionratpropns_3 ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)
miest ghhn cloglog ratified ratproptrade_3 pol regionratpropns_3 ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)
miest ghhn cloglog ratified ratpropigo23f3u_3 pol regionratpropns_3 ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)
miest ghhn cloglog ratified ratpropdefwc_3 ratproptrade_3 ratpropigo23f3u_3 pol regionratpropns_3 ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)
miest ghhn cloglog ratified ratindex_3 pol regionratpropns_3 ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)

* TABLE 2
miest ghhn cloglog signed igonumberall signpropdefwc_3 signproptrade_3 signpropigo23f3u_3 civilsignprop_3 pol empinx_12 lnforce lrgdp96 regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)
miest ghhn cloglog signed igonumberall signindex_3 civilsignprop_3 pol empinx_12 lnforce lrgdp96 regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)
miest ghhn cloglog signed igonumberall signpropdefwc_3 signproptrade_3 signpropigo23f3u_3 colonysignprop_3 civilsignprop_3 languagesignprop_3 lnvol newdem pol physint_12 empinx_12 leg_com lnforce lrgdp96 midnew psfill regionsignpropns_3 presidential sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)
miest ghhn cloglog signed igonumberall signindex_3 colonysignprop_3 civilsignprop_3 languagesignprop_3 lnvol newdem pol physint_12 empinx_12 leg_com lnforce lrgdp96 midnew psfill regionsignpropns_3 presidential sign2months s2spline* if s2include==1, cluster(cnum) nsets(5)

* TABLE 3
miest ghhn cloglog ratified igonumberall ratpropdefwc_3 ratproptrade_3 ratpropigo23f3u_3 colonyratprop_3 pol empinx_12 lrgdp96 regionratpropns_3 ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)
miest ghhn cloglog ratified igonumberall ratindex_3 colonyratprop_3 pol empinx_12 lrgdp96 regionratpropns_3 ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)
miest ghhn cloglog ratified igonumberall ratpropdefwc_3 ratproptrade_3 ratpropigo23f3u_3 colonyratprop_3 civilratprop_3 languageratprop_3 lnvol newdem pol physint_12 empinx_12 leg_com lnforce lrgdp96 midnew psfill regionratpropns_3 presidential ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)
miest ghhn cloglog ratified igonumberall ratindex_3 colonyratprop_3 civilratprop_3 languageratprop_3 lnvol newdem pol physint_12 empinx_12 leg_com lnforce lrgdp96 midnew psfill regionratpropns_3 presidential ratmonths rspline* if rinclude==1, cluster(cnum) nsets(5)

* example of joint significance test: Table 1, column 1
forvalues j=1/5 {
	use "C:\Work\ghhn`j'.dta", clear
	quietly cloglog signed pol regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) 
	quietly testparm pol regionsignpropns_3 sign2months s2spline* 
 	scalar dstarl`j' = r(chi2)
	scalar ll`j' = e(ll)
}
scalar llbar = 0
forvalues j=1/5 {
	scalar llbar = ll`j' + llbar
}
scalar llbar = llbar/5
scalar dmbar = 0
forvalues j=1/5 {
	scalar dmbar = dstarl`j' + dmbar
}
scalar dmbar = dmbar/5
scalar sd2 = 0
forvalues j=1/5 {
	scalar sd2 = (dstarl`j' - dmbar)^2 + sd2
}
scalar sd2 = sd2 / 4
scalar rm = ((1 + (1/5))*sd2)/(2*dmbar + sqrt(4*dmbar^2 - 2*6*sd2))
scalar Dmhat = ((dmbar/6) - ((4/6)*rm))/(1 + rm)
scalar etahat = 4*(1 + (1/rm))^2
display "average (pseudo-)log-likelihood = " llbar
display "average chi2 value, all vars = " dmbar
display "repeated-imputation joint significance test, all vars, 3-month lag, p-value =" Ftail(6, (1+(1/6))*etahat/2, Dmhat)

* Table 4: SIGN
* this provides the baseline and pr`i' provides the hazard rate over time
set seed 987654321
use "C:\Work\ghhn1.dta", clear
estsimp cloglog signed signpropdefwc_3 signproptrade_3 signpropigo23f3u_3 civilsignprop_3 pol empinx_12 lnforce lrgdp96 igonumberall regionsignpropns_3 sign2months s2spline* if s2include==1, cluster(cnum) mi(isqrmi) sims(10000) genname(s)
gen signdef10 = .
gen signdef50 = .
gen signdef90 = .
gen signtrade10 = .
gen signtrade50 = .
gen signtrade90 = .
gen signigo10 = .
gen signigo50 = .
gen signigo90 = .
gen signregion10 = .
gen signregion50 = .
gen signregion90 = .
gen signcivil10 = .
gen signcivil50 = .
gen signcivil90 = .
forvalues i = 0/29 {
	local j = `i' + 1
	_pctile signpropdefwc_3 if sign2months == `i', p(10, 50, 90)
	quietly replace signdef10 = r(r1) in `j'
	quietly replace signdef50 = r(r2) in `j'
	quietly replace signdef90 = r(r3) in `j'
	_pctile signproptrade_3 if sign2months == `i', p(10, 50, 90)
	quietly replace signtrade10 = r(r1) in `j'
	quietly replace signtrade50 = r(r2) in `j'
	quietly replace signtrade90 = r(r3) in `j'
	_pctile signpropigo23f3u_3 if sign2months == `i', p(10, 50, 90)
	quietly replace signigo10 = r(r1) in `j'
	quietly replace signigo50 = r(r2) in `j'
	quietly replace signigo90 = r(r3) in `j'
	_pctile regionsignpropns_3 if sign2months == `i', p(10, 50, 90)
	quietly replace signregion10 = r(r1) in `j'
	quietly replace signregion50 = r(r2) in `j'
	quietly replace signregion90 = r(r3) in `j'
	_pctile civilsignprop_3 if sign2months == `i', p(10, 50, 90)
	quietly replace signcivil10 = r(r1) in `j'
	quietly replace signcivil50 = r(r2) in `j'
	quietly replace signcivil90 = r(r3) in `j'
}
summarize signdef* signtrade* signigo* signregion* signcivil*
setx median
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade50[`k']
	local g = signigo50[`k']
	local r = signregion50[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	rename pr`i' basesign`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr
scalar mcumpr = r(mean)
display "Cumulative probability of signing after 29 months = " 1-mcumpr
rename cumpr cumprbase

setx median
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade90[`k']
	local g = signigo50[`k']
	local r = signregion50[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (trade at p90) after 29 months = " 1-mcumpr
rename cumpr cumprtrade
gen dtrade = cumprbase - cumprtrade
sum dtrade, meanonly
scalar mean = r(mean)
_pctile dtrade, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (trade) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade50[`k']
	local g = signigo90[`k']
	local r = signregion50[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (igo at p90) after 29 months = " 1-mcumpr
rename cumpr cumprigo
gen digo = cumprbase - cumprigo
sum digo, meanonly
scalar mean = r(mean)
_pctile digo, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (igo) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef90[`k']
	local t = signtrade50[`k']
	local g = signigo50[`k']
	local r = signregion50[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (defense at p90) after 29 months = " 1-mcumpr
rename cumpr cumprdef
gen ddef = cumprbase - cumprdef
sum ddef, meanonly
scalar mean = r(mean)
_pctile ddef, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (def) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade50[`k']
	local g = signigo50[`k']
	local r = signregion90[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (region at p90) after 29 months = " 1-mcumpr
rename cumpr cumprregion
gen dregion = cumprbase - cumprregion
sum dregion, meanonly
scalar mean = r(mean)
_pctile dregion, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (region) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade50[`k']
	local g = signigo50[`k']
	local r = signregion50[`k']
	local c = signcivil90[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (civil at p90) after 29 months = " 1-mcumpr
rename cumpr cumprcivil
gen dcivil = cumprbase - cumprcivil
sum dcivil, meanonly
scalar mean = r(mean)
_pctile dcivil, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (civil) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx empinx_12 p90
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade50[`k']
	local g = signigo50[`k']
	local r = signregion50[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (empinx at 10) after 29 months = " 1-mcumpr
rename cumpr cumprempinx
gen dempinx = cumprbase - cumprempinx
sum dempinx, meanonly
scalar mean = r(mean)
_pctile dempinx, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (empinx) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx lrgdp96 p90
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade50[`k']
	local g = signigo50[`k']
	local r = signregion50[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (gdp at p90) after 29 months = " 1-mcumpr
rename cumpr cumprgdp
gen dgdp = cumprbase - cumprgdp
sum dgdp, meanonly
scalar mean = r(mean)
_pctile dgdp, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (gdp) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx lnforce p90
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade50[`k']
	local g = signigo50[`k']
	local r = signregion50[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (force at p90) after 29 months = " 1-mcumpr
rename cumpr cumprforce
gen dforce = cumprbase - cumprforce
sum dforce, meanonly
scalar mean = r(mean)
_pctile dforce, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (force) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx igonumberall p90
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade50[`k']
	local g = signigo50[`k']
	local r = signregion50[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (igonubmerall at p90) after 29 months = " 1-mcumpr
rename cumpr cumprvolun
gen dvolun = cumprbase - cumprvolun
sum dvolun, meanonly
scalar mean = r(mean)
_pctile dvolun, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (igonumberall) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx pol p90
setx
gen cumpr = 1
forvalues i = 0/29 {
	local j = `i' + 787
	local k = `i' + 1
	local d = signdef50[`k']
	local t = signtrade50[`k']
	local g = signigo50[`k']
	local r = signregion50[`k']
	local c = signcivil50[`k']
	setx signpropdefwc_3 `d' signproptrade_3 `t' signpropigo23f3u_3 `g' regionsignpropns_3 `r' civilsignprop_3 `c' sign2months sign2months[`j'] s2spline1 s2spline1[`j'] s2spline2 s2spline2[`j'] s2spline3 s2spline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of signing (pol at p90) after 29 months = " 1-mcumpr
rename cumpr cumprpol
gen dpol = cumprbase - cumprpol
sum dpol, meanonly
scalar mean = r(mean)
_pctile dpol, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of signing (pol) = " mean "   95%CI:{" lo "," hi "}"

save C:\Work\ghhnprobsign.dta, replace


* Table 4 RATIFY
* this provides the baseline and pr`i' provides the hazard rate over time
use "C:\Work\ghhn1.dta", clear
estsimp cloglog ratified ratpropdefwc_3 ratproptrade_3 ratpropigo23f3u_3 colonyratprop_3 pol empinx_12 lrgdp96 igonumberall regionratpropns_3 ratmonths rspline* if rinclude==1, cluster(cnum) mi(isqrmi) sims(10000) genname(r)
gen ratdef10 = .
gen ratdef50 = .
gen ratdef90 = .
gen rattrade10 = .
gen rattrade50 = .
gen rattrade90 = .
gen ratigo10 = .
gen ratigo50 = .
gen ratigo90 = .
gen ratregion10 = .
gen ratregion50 = .
gen ratregion90 = .
gen ratcolony10 = .
gen ratcolony50 = .
gen ratcolony90 = .
forvalues i = 0/77 {
	local j = `i' + 1
	_pctile ratpropdefwc_3 if ratmonths == `i', p(10, 50, 90)
	quietly replace ratdef10 = r(r1) in `j'
	quietly replace ratdef50 = r(r2) in `j'
	quietly replace ratdef90 = r(r3) in `j'
	_pctile ratproptrade_3 if ratmonths == `i', p(10, 50, 90)
	quietly replace rattrade10 = r(r1) in `j'
	quietly replace rattrade50 = r(r2) in `j'
	quietly replace rattrade90 = r(r3) in `j'
	_pctile ratpropigo23f3u_3 if ratmonths == `i', p(10, 50, 90)
	quietly replace ratigo10 = r(r1) in `j'
	quietly replace ratigo50 = r(r2) in `j'
	quietly replace ratigo90 = r(r3) in `j'
	_pctile regionratpropns_3 if ratmonths == `i', p(10, 50, 90)
	quietly replace ratregion10 = r(r1) in `j'
	quietly replace ratregion50 = r(r2) in `j'
	quietly replace ratregion90 = r(r3) in `j'
	_pctile colonyratprop_3 if ratmonths == `i', p(10, 50, 90)
	quietly replace ratcolony10 = r(r1) in `j'
	quietly replace ratcolony50 = r(r2) in `j'
	quietly replace ratcolony90 = r(r3) in `j'
}
summarize ratdef* rattrade* ratigo* ratregion* ratcolony*
setx median
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef50[`k']
	local t = rattrade50[`k']
	local g = ratigo50[`k']
	local r = ratregion50[`k']
	local c = ratcolony50[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	rename pr`i' baserat`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying after 77 months = " 1-mcumpr
rename cumpr cumprbase

setx median
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef50[`k']
	local t = rattrade90[`k']
	local g = ratigo50[`k']
	local r = ratregion50[`k']
	local c = ratcolony50[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying (trade at p90) after 77 months = " 1-mcumpr
rename cumpr cumprtrade
gen dtrade = cumprbase - cumprtrade
sum dtrade, meanonly
scalar mean = r(mean)
_pctile dtrade, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of ratifying (trade) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef50[`k']
	local t = rattrade50[`k']
	local g = ratigo90[`k']
	local r = ratregion50[`k']
	local c = ratcolony50[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying (igo at p90) after 77 months = " 1-mcumpr
rename cumpr cumprigo
gen digo = cumprbase - cumprigo
sum digo, meanonly
scalar mean = r(mean)
_pctile digo, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of ratifying (igo) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef90[`k']
	local t = rattrade50[`k']
	local g = ratigo50[`k']
	local r = ratregion50[`k']
	local c = ratcolony50[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying (defense at p90) after 77 months = " 1-mcumpr
rename cumpr cumprdef
gen ddef = cumprbase - cumprdef
sum ddef, meanonly
scalar mean = r(mean)
_pctile ddef, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of ratifying (defense) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef50[`k']
	local t = rattrade50[`k']
	local g = ratigo50[`k']
	local r = ratregion90[`k']
	local c = ratcolony50[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying (region at p90) after 77 months = " 1-mcumpr
rename cumpr cumprregion
gen dregion = cumprbase - cumprregion
sum dregion, meanonly
scalar mean = r(mean)
_pctile dregion, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of ratifying (region) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef50[`k']
	local t = rattrade50[`k']
	local g = ratigo50[`k']
	local r = ratregion50[`k']
	local c = ratcolony90[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying (colony at p90) after 77 months = " 1-mcumpr
rename cumpr cumprcolony
gen dcolony = cumprbase - cumprcolony
sum dcolony, meanonly
scalar mean = r(mean)
_pctile dcolony, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of ratifying (colony) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx pol p90
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef50[`k']
	local t = rattrade50[`k']
	local g = ratigo50[`k']
	local r = ratregion50[`k']
	local c = ratcolony50[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying (pol at p10) after 77 months = " 1-mcumpr
rename cumpr cumprpol
gen dpol = cumprbase - cumprpol
sum dpol, meanonly
scalar mean = r(mean)
_pctile dpol, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of ratifying (pol) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx empinx_12 p90
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef50[`k']
	local t = rattrade50[`k']
	local g = ratigo50[`k']
	local r = ratregion50[`k']
	local c = ratcolony50[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying (empinx at 10) after 77 months = " 1-mcumpr
rename cumpr cumprempinx
gen dempinx = cumprbase - cumprempinx
sum dempinx, meanonly
scalar mean = r(mean)
_pctile dempinx, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of ratifying (empinx) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx igonumberall p90
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef50[`k']
	local t = rattrade50[`k']
	local g = ratigo50[`k']
	local r = ratregion50[`k']
	local c = ratcolony50[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying (igonumberall at p90) after 77 months = " 1-mcumpr
rename cumpr cumprmid
gen dmid = cumprbase - cumprmid
sum dmid, meanonly
scalar mean = r(mean)
_pctile dmid, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of ratifying (igonumberall) = " mean "   95%CI:{" lo "," hi "}"

setx median
setx lrgdp96 p90
setx
gen cumpr = 1
forvalues i = 0/77 {
	local j = `i' + 211
	local k = `i' + 1
	local d = ratdef50[`k']
	local t = rattrade50[`k']
	local g = ratigo50[`k']
	local r = ratregion50[`k']
	local c = ratcolony50[`k']
	setx ratpropdefwc_3 `d' ratproptrade_3 `t' ratpropigo23f3u_3 `g' regionratpropns_3 `r' colonyratprop_3 `c' ratmonths ratmonths[`j'] rspline1 rspline1[`j'] rspline2 rspline2[`j'] rspline3 rspline3[`j']
	setx
	quietly simqi, prval(0) genpr(pr`i')
	quietly replace cumpr = cumpr * pr`i'
	drop pr`i'
}
quietly summarize cumpr, meanonly
tempname mcumpr mean lo hi
scalar mcumpr = r(mean)
display "Cumulative probability of ratifying (lrgdp96 at p90) after 77 months = " 1-mcumpr
rename cumpr cumprps
gen dps = cumprbase - cumprps
sum dps, meanonly
scalar mean = r(mean)
_pctile dps, p(2.5 97.5)
scalar lo = r(r1)
scalar hi = r(r2)
display "Difference in probability of ratifying (lrgdp96) = " mean "   95%CI:{" lo "," hi "}"

save C:\Work\ghhnprobrat.dta, replace

log close
