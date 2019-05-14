* Incidents of anti-German harassment
use hatecrimes, clear
collapse (count) id, by(statefip)
ren id hatecrimes
tempfile hatecrimes
save `hatecrimes'
 
* ICSPR county-level census data
tempfile germans1910

*-------------------------------------------------------------------------------
* Load 1910 ICPSR county-level data
*-------------------------------------------------------------------------------

gen totalgermans=nwfpgerm + pbwgerm
ren nwfpgerm totalgermanssec
ren pbwgerm totalgermansfirst
keep if level==2
gen statefip=fips/1000
keep totalgermans* totpop statefip
gen germans1910=totalgermans/totpop
gen germanssec1910=totalgermanssec/totpop
gen germansfirst1910=totalgermansfirst/totpop
save `germans1910'


*-------------------------------------------------------------------------------
* Load 1910 Complete Count from IPUMS
* Create share with one German parent
*-------------------------------------------------------------------------------

* first and second generation Germans
gen german=(bpl==453)
gen germansec=(fbpl==453|mbpl==453)

* one parent German
gen onegerman=1 if (fbpl==453&mbpl!=453)|(fbpl!=453&mbpl==453)
replace onegerman=0 if (fbpl==453&mbpl==453)
replace onegerman=. if (fbpl==.|mbpl==.)

collapse onegerman if germansec==1, by(statefip)
tempfile onegerman
save `onegerman'


*-------------------------------------------------------------------------------
* Load 1910 Complete Count from IPUMS
* Create share naturalized, average years in US, share self-employed
*-------------------------------------------------------------------------------

* first and second generation Germans
gen german=(bpl==453)
gen germansec=(fbpl==453|mbpl==453)

gen naturalized=(citizen==2)
replace naturalized=. if citizen==0|citizen==5

gen yrsusa=1910-yrimmig
replace yrsusa=. if yrimmig==0|yrimmig<1790

gen self=(classwkr==1)
replace self=. if classwkr==.

collapse naturalized yrsusa self if german==1, by(statefip stateicp)


* merge with anti-German incidents 
merge 1:1 statefip using `hatecrimes'
replace hatecrimes=0 if _merge==1
drop _merge


* merge with German share in 1910
merge 1:1 statefip using `germans1910'
keep if _merge==3
drop _merge

* merge with share with one parents German
merge 1:1 statefip using `onegerman'
keep if _merge==3
drop _merge

gen hatepcpop=(hatecrimes/totpop)*1000

* regressions
reg hatepcpop onegerman  germanssec1910, ro
eststo m1
reg hatepcpop naturalized  germans1910, ro
eststo m2
reg hatepcpop yrsusa  germans1910, ro
eststo m3
reg hatepcpop self  germans1910, ro
eststo m4
reg hatepcpop onegerman naturalized yrsusa self germans1910, ro
eststo m5

esttab m* using "TableE4.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) ///
stats(N r2) keep(naturalized yrsusa onegerman self) 
