**** PSRM paper


** last: 17 Apr 14


clear
version 12
set more off
*cd "C:\Users\tbraeun\Dropbox\Gov&Opp\replication"
*cd "C:\Users\Marc\myworks\psrm2014"
cap noisily 
do splitpps_new
use govparl_final, clear


*** stset 

stset datende_einper, origin(time datein) failure(status_einper==1)
tab init_gomix, gen(dini)


*** descriptives: table 1

tab land status_einper if dini4==1, row
tab land status_einper if dini3==1, row
tab land if dini4==1 | dini3==1
 

*** duration stats
sum _t if dini4==1 & status_einper==1, detail
sum _t if dini3==1 & status_einper==1, detail

bysort land: sum _t if dini4==1 & status_einper==1, detail
bysort land: sum _t if dini3==1 & status_einper==1, detail


*** density distribution and non-parametric: figure 2

kdensity _t if dini4==1 
kdensity _t if dini3==1

gen inew = .
replace inew = 0 if dini4==1
replace inew = 1 if dini3==1

graph set window fontface "Garamond"
foreach x of numlist 0 1 {
gen tmp = (status_einper==1 & inew==`x' & _t < 1250)
kdensity _t if tmp, gen(points fx) 
for any be fr ge uk: kdensity _t if X & tmp, at(points) nograph gen(fxX)
lab var fxbe "Belgium"
lab var fxfr "France"
lab var fxge "Germany"
lab var fxuk "UK"
twoway /*
 */ (scatter fxbe points, connect(l) msym(i) clwidth(medthin) clp(solid) xtitle("Duration (days)") /*
 */ xlab(0 250 500 750 1000 1250) ytitle(" ")) /*
 */ (scatter fxfr points,connect(l) msym(i) clwidth(medthin) clp(shortdash)) /*
 */ (scatter fxge points,connect(l) msym(i) clwidth(medthin) clp(longdash)) /*
 */ (scatter fxuk points,connect(l) msym(i) clwidth(medthin) clp(shortdash_dot))
graph display Graph, scheme(s1mono)
graph save kdensity_`x', replace
graph export kdensitynew_`x'.png, replace
sum _t if status_einper==1 & inew==`x', detail
bysort land: sum _t if status_einper==1 & inew==`x', detail
drop tmp fx fx?? points
}


* check log-logistic assumption with Kaplan-Meier
* okay: ll and also Weibull fit better than exponential

gen lnt = ln(_t)
sts gen s = s if inew==1
  * ll
  gen lns_ll = ln( (1-s)/s)
  scatter lns_ll lnt || lfit lns_ll lnt, saving(ll, replace)
  regress lns_ll lnt
  * exp
  gen lns_ex = ln(s)
  scatter lns_ex _t || lfit lns_ex _t, saving(ex, replace)
  regress lns_ex _t
  * weibull
  gen lns_we = ln(-ln(s))
  scatter lns_we lnt || lfit lns_we lnt, saving(we, replace)
  regress lns_we lnt
  drop s lns*
gr combine ll.gph ex.gph we.gph

sts gen s = s if inew==0
  * ll
  gen lns_ll = ln( (1-s)/s)
  scatter lns_ll lnt || lfit lns_ll lnt, saving(ll, replace)
  regress lns_ll lnt
  * exp
  gen lns_ex = ln(s)
  scatter lns_ex _t || lfit lns_ex _t, saving(ex, replace)
  regress lns_ex _t
  * weibull
  gen lns_we = ln(-ln(s))
  scatter lns_we lnt || lfit lns_we lnt, saving(we, replace)
  regress lns_we lnt
  drop s lns*
  drop lnt
gr combine ll.gph ex.gph we.gph


*** new vars 

gen mvpdi = mind * vpdi_pjoint
gen div1Xzustim1 = div1 * zustim1
gen dcog_pjoint = abs(cog_pjoint_g - cog_pjoint_o)
for var vpdi_pjoint dcog_pjoint: replace X = X/100
rename _IpKommBild __IpKommBild


*** split population model: government bills

* fit constant model to obtain inits
streg be ge fr uk if dini4==1 & status_einper, nocons dist(ll) anc(be ge fr)
matrix B0 = e(b)
matrix B0[1,5] = exp(B0[1,5]+B0[1,8])
matrix B0[1,6] = exp(B0[1,6]+B0[1,8]) 
matrix B0[1,7] = exp(B0[1,7]+B0[1,8]) 
matrix B0[1,8] = exp(B0[1,8]) 
matrix colnames B0 = _t:be _t:ge _t:fr _t:uk gam:be gam:ge gam:fr gam:uk
ml model lf splitpps_ll_anc1 (_t: _t = be ge fr uk, nocons) ///
 (status: status_einper = ) ///
 (gam: be = be ge fr uk, nocons) if dini4==1
ml init B0, skip
ml search
ml max, difficult noclear
matrix B1 = e(b)

* fit full model
eststo clear
ml model lf splitpps_ll_anc1 ///
 (_t: _t = vpdi_pjoint dcog_pjoint mind mvpdi div1 zustim1 div1Xzustim1 _Ip* be ge fr uk, nocons) ///
 (status: status_einper = vpdi_pjoint dcog_pjoint mind mvpdi div1 zustim1  _Ip* be ge fr uk, nocons) ///
 (gam: be = be ge fr uk, nocons) if dini4==1, cluster(land)
ml init B1, skip
ml search
ml max, difficult noclear
eststo

* splitting parameter
predict xb, eq(status)
gen p=exp(xb)/(1+exp(xb))
sum p status_einper if dini4==1
drop xb p

* predicted probabilities for baseline and others: table 3a
qui sum vpdi_pjoint, detail
local base_vpdi_pjoint = r(p50)
qui sum dcog_pjoint, detail
local base_dcog_pjoint = r(p50)
local xb0 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint'
qui sum vpdi_pjoint, detail
local xb1 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*r(p90) ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint'
qui sum dcog_pjoint, detail
local xb2 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*r(p90)
local xb3 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint' + [status]_b[mind] + [status]_b[mvpdi]*`base_vpdi_pjoint'
local xb4 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint' + [status]_b[div1] 
local xb5 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint' + [status]_b[zustim1] 
foreach x of numlist 0/5 {
  gen p`x' = exp(`xb`x'')/(1+exp(`xb`x''))
}
for num 0/5: sum pX if dini4==1
drop p?

* hazards by conflict for baseline hazard and others: figure 3
qui sum vpdi_pjoint, detail
local base_vpdi_pjoint = r(p50)
qui sum dcog_pjoint, detail
local base_dcog_pjoint = r(p50)
local p = 1/([gam]_b[ge])
local ll = [_t]_b[be] + [_t]_b[_IpJustiz] + [_t]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [_t]_b[dcog_pjoint]*`base_dcog_pjoint'
local l = exp( (-1) * `ll')
gen hazg_mean = (`l'*`p'* (`l'*_t)^(`p'-1)) / (1+ (`l'*_t)^`p')
qui sum vpdi_pjoint, detail
local ll = [_t]_b[ge] + [_t]_b[_IpJustiz] + [_t]_b[vpdi_pjoint]*r(p90) ///
          + [_t]_b[dcog_pjoint]*`base_dcog_pjoint'
local l = exp( (-1) * `ll')
gen hazg_vpdi_pjoint = (`l'*`p'* (`l'*_t)^(`p'-1)) / (1+ (`l'*_t)^`p')
qui sum dcog_pjoint, detail
local ll = [_t]_b[ge] + [_t]_b[_IpJustiz] + [_t]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [_t]_b[dcog_pjoint]*r(p90)
local l = exp( (-1) * `ll')
gen hazg_dcog_pjoint = (`l'*`p'* (`l'*_t)^(`p'-1)) / (1+ (`l'*_t)^`p')

lab var hazg_mean "Baseline"
lab var hazg_vpdi_pjoint "Intra-governmental conflict"
lab var hazg_dcog_pjoint "Intra-parliamentary conflict"
gen tmp = ( ( round(_t/20) == _t/20  & _t<=1460 ) | _t == 1 | _t==10)
twoway /*
 */ (scatter hazg_mean _t if tmp, sort connect(l) msym(i) clwidth(medthin) clp(solid) xtitle("Duration (days)") /*
 */ xlab(0 250 500 750 1000 1250 1460) ytitle("Hazard rate")) /*
 */ (scatter hazg_vpdi_pjoint _t if tmp,sort connect(l) msym(i) clwidth(medthin) clp(shortdash)) /*
 */ (scatter hazg_dcog_pjoint _t if tmp,sort connect(l) msym(i) clwidth(medthin) clp(longdash))
graph display Graph, scheme(s1mono)
graph save hazard_1, replace
graph export hazardnew_1.png, replace
drop tmp

* change in hazards: table 3b
qui sum hazg_mean
qui sum _t if hazg_mean ==r(max)
local tmax = r(mean)
di "baseline hazard is max at _t = `tmax'" 
foreach v in vpdi_pjoint dcog_pjoint {
 di "`v'"
 sum hazg_mean if _t ==`tmax'
 local b0 = r(mean)
 sum hazg_`v' if _t == `tmax'
 di "change at t=`tmax'   " (r(mean)-`b0') / `b0'
 sum hazg_mean if _t ==365
 local b0 = r(mean)
 sum hazg_`v' if _t == 365
 di "change at t=365   " (r(mean)-`b0') / `b0'
 sum hazg_mean if _t ==1460
 local b0 = r(mean)
 sum hazg_`v' if _t ==1460
 di "change at t=1460   " (r(mean)-`b0') / `b0'
}
drop hazg*


*** opposition bills

* fit constant model to obtain inits for full model
streg be ge fr uk if dini3==1 & status_einper, nocons dist(ll) anc(be ge fr)
matrix B0 = e(b)
matrix B0[1,5] = exp(B0[1,5]+B0[1,8])
matrix B0[1,6] = exp(B0[1,6]+B0[1,8]) 
matrix B0[1,7] = exp(B0[1,7]+B0[1,8]) 
matrix B0[1,8] = exp(B0[1,8]) 
matrix colnames B0 = _t:be _t:ge _t:fr _t:uk gam:be gam:ge gam:fr gam:uk
ml model lf splitpps_ll_anc1 (_t: _t = be ge fr uk, nocons) ///
 (status: status_einper = ) ///
 (gam: be = be ge fr uk, nocons) if dini3==1
ml init B0, skip
ml search
ml max, difficult noclear
matrix B1 = e(b)

* fit full model
ml model lf splitpps_ll_anc1 ///
 (_t: _t = vpdi_pjoint dcog_pjoint mind div1 zustim1 div1Xzustim1 _Ip* be ge fr uk, nocons) ///
 (status: status_einper = vpdi_pjoint  dcog_pjoint mind div1 zustim1 _Ip* be ge fr uk, nocons) ///
 (gam: be = be ge fr uk, nocons) if dini3==1, cluster(land)
ml init B1, skip
ml search
ml max, difficult noclear
eststo

* splitting parameter
predict xb, eq(status)
gen p=exp(xb)/(1+exp(xb))
sum p status_einper if dini3==1
drop xb p

* predicted probabilities for baseline and others: table 3a
qui sum vpdi_pjoint, detail
local base_vpdi_pjoint = r(p50)
qui sum dcog_pjoint, detail
local base_dcog_pjoint = r(p50)
local xb0 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint'
qui sum vpdi_pjoint, detail
local xb1 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*r(p90) ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint'
qui sum dcog_pjoint, detail
local xb2 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*r(p90)
local xb3 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint' + [status]_b[mind] 
local xb4 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint' + [status]_b[div1] 
local xb5 = [status]_b[ge] + [status]_b[_IpJustiz] + [status]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [status]_b[dcog_pjoint]*`base_dcog_pjoint' + [status]_b[zustim1] 
foreach x of numlist 0/5 {
  gen p`x' = exp(`xb`x'')/(1+exp(`xb`x''))
}
for num 0/5: sum pX if dini3==1
drop p?

* hazards by conflict for baseline hazard and others: figure 3
qui sum vpdi_pjoint, detail
local base_vpdi_pjoint = r(p50)
qui sum dcog_pjoint, detail
local base_dcog_pjoint = r(p50)
local p = 1/([gam]_b[be])
local ll = [_t]_b[be] + [_t]_b[_IpJustiz] + [_t]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [_t]_b[dcog_pjoint]*`base_dcog_pjoint'
local l = exp( (-1) * `ll')
gen hazg_mean = (`l'*`p'* (`l'*_t)^(`p'-1)) / (1+ (`l'*_t)^`p')
qui sum vpdi_pjoint, detail
local ll = [_t]_b[be] + [_t]_b[_IpJustiz] + [_t]_b[vpdi_pjoint]*r(p75) ///
          + [_t]_b[dcog_pjoint]*`base_dcog_pjoint'
local l = exp( (-1) * `ll')
gen hazg_vpdi_pjoint = (`l'*`p'* (`l'*_t)^(`p'-1)) / (1+ (`l'*_t)^`p')
qui sum dcog_pjoint, detail
local ll = [_t]_b[be] + [_t]_b[_IpJustiz] + [_t]_b[vpdi_pjoint]*`base_vpdi_pjoint' ///
          + [_t]_b[dcog_pjoint]*r(p75)
local l = exp( (-1) * `ll')
gen hazg_dcog_pjoint = (`l'*`p'* (`l'*_t)^(`p'-1)) / (1+ (`l'*_t)^`p')

lab var hazg_mean "Baseline"
lab var hazg_vpdi_pjoint "Intra-governmental conflict"
lab var hazg_dcog_pjoint "Intra-parliamentary conflict"
gen tmp = ( ( round(_t/20) == _t/20  & _t<=1460 ) | _t == 1 | _t==10)
twoway /*
 */ (scatter hazg_mean _t if tmp, sort connect(l) msym(i) clwidth(medthin) clp(solid) xtitle("Duration (days)") /*
 */ xlab(0 250 500 750 1000 1250 1460) ytitle("Hazard rate")) /*
 */ (scatter hazg_vpdi_pjoint _t if tmp,sort connect(l) msym(i) clwidth(medthin) clp(shortdash)) /*
 */ (scatter hazg_dcog_pjoint _t if tmp,sort connect(l) msym(i) clwidth(medthin) clp(longdash))
graph display Graph, scheme(s1mono)
graph save hazard_0, replace
graph export hazardnew_0.png, replace
drop tmp

* change in hazards: table 3b
qui sum hazg_mean
qui sum _t if hazg_mean ==r(max)
local tmax = r(mean)
di "baseline hazard is max at _t = `tmax'" 
foreach v in vpdi_pjoint dcog_pjoint {
 di "`v'"
 sum hazg_mean if _t ==`tmax'
 local b0 = r(mean)
 sum hazg_`v' if _t == `tmax'
 di "change at t=`tmax'   " (r(mean)-`b0') / `b0'
 sum hazg_mean if _t ==365
 local b0 = r(mean)
 sum hazg_`v' if _t == 365
 di "change at t=365   " (r(mean)-`b0') / `b0'
 sum hazg_mean if _t ==1460
 local b0 = r(mean)
 sum hazg_`v' if _t ==1460
 di "change at t=1460   " (r(mean)-`b0') / `b0'
}
drop hazg*


*** collect parameter estimates: table 2

esttab using "splitmodel_new.tex", nogaps nodepvars scalars("N \sc Observations" "ll \sc Log Pseudo-likelihood")  ///
    booktabs title(\sc Duration and Success of Bills: Split Population Models) ///
	replace coeflabels(vpdi_pjoint "Intra-governmental conflict" dcog_pjoint "Intra-parliamentary conflict" ///
	mind "Minority government" mvpdi "Minority $\times$ Intra-gov. conflict" div1 "Divided" zustim1 "Bicameral" ///
	div1Xzustim1 "Divided $\times$ Bicameral" _IpSoziales "Social" _IpFinanzen "Finance" _IpInnen "Interior" ///
	_IpJustiz "Justice" _IpVerkehr "Infrastructure" _IpGesundheit "Health" _IpUmweltAgrar "Environment/Agriculture" ///
	_IpWirtschaft "Economy" _IpAussVert "Foreign/Defense" be "Belgium" ge "Germany" fr "France" uk "UK")  ///
	order(vpdi_pjoint dcog_pjoint  ///
	mind  mvpdi  div1  zustim1  ///
	div1Xzustim1  _IpSoziales  _IpFinanzen  _IpInnen  ///
	_IpJustiz _IpVerkehr  _IpGesundheit _IpUmweltAgrar  ///
	_IpWirtschaft  _IpAussVert  be  ge  fr  uk )  ///
	p cells(b(fmt(a2) star) p(par fmt(%5.3f))) unstack compress mti("Government bills" "Private member bills") ///
	nonumbers nodepvar ///
	star(* 0.10 ** 0.05 *** 0.01)

	
exit

