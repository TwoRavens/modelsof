*******************************************************************
*** Do file to replicate the models and substantive effects for "Opposition Parties and the Timing of Successful No-Confidence Motions"
***
*** Created: 12-21-14
***
*******************************************************************

*** Establish the working directory
* cd ""

*** Load the data and run the necessary programs
do "Williams PSRM--Programs.do"
use "Williams PSRM.dta", clear

cap log close
log using "Williams PSRM.smcl", replace

**********************************************************************************
**** Statistical Backwards Induction
**********************************************************************************
set maxiter 100
di "$S_TIME"
bootstrap r(surplus) r(minority) r(gparties) r(ciep_perc) r(ts_govt) r(ts_challenge) r(no_challenge) r(annual_ch_rgdppc_F) r(annual_ch_rgdppc_P) r(eff_par), reps(2200) dots: sbi, seed(648)
di "$S_TIME"

**********************************************************************************
**** Substantive Effects of Pr(Propose)
**********************************************************************************
use "Williams PSRM.dta", clear

qui logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
predict pr_sbi 
sum pr_sbi if e(sample)
local z = 1 - r(mean)
local y = r(mean)

foreach i of varlist surplus minority gparties ciep_perc ts_govt ts_challenge no_challenge annual_ch_rgdppc {
	gen z_`i' = (1 - pr_sbi) * `i'
}

foreach j of varlist annual_ch_rgdppc eff_par {
	gen y_`j' = pr_sbi * `j'
}

set seed 648
qui estsimp logit opp_conf_dummy z_surplus z_minority z_gparties z_ciep_perc z_ts_govt z_ts_challenge z_no_challenge z_annual_ch_rgdppc y_annual_ch_rgdppc y_eff_par, nocons iterate(500) genname(xxx)
setx z_surplus 0*`z' z_minority 1*`z' z_gparties 1*`z' z_ciep_perc 1*`z' z_ts_govt 12*`z' z_ts_challenge 12*`z' z_no_challenge 3*`z' z_annual_ch_rgdppc 1*`z' y_annual_ch_rgdppc 1*`y' y_eff_par 2.4*`y'
simqi, prval(1) genpr(prp)
quietly sum prp, meanonly
local base = r(mean)

*** Now, produce the changes in predicted probabilities.
* Surplus
simqi, fd(prval(1)) changex(z_surplus 0*`z' 1*`z') level(90)
simqi, fd(prval(1) genpr(fd)) changex(z_surplus 0*`z' 1*`z') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Minority
simqi, fd(prval(1)) changex(z_minority 0*`z' 1*`z') level(90)
simqi, fd(prval(1) genpr(fd)) changex(z_minority 0*`z' 1*`z') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Government parties
simqi, fd(prval(1)) changex(z_gparties 1*`z' 4*`z') level(90)
simqi, fd(prval(1) genpr(fd)) changex(z_gparties 1*`z' 4*`z') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Time Left in CIEP
simqi, fd(prval(1)) changex(z_ciep_perc 1*`z' .5*`z') level(90)
simqi, fd(prval(1) genpr(fd)) changex(z_ciep_perc 1*`z' .5*`z') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Tenure
simqi, fd(prval(1)) changex(z_ts_govt 12*`z' 24*`z') level(90)
simqi, fd(prval(1) genpr(fd)) changex(z_ts_govt 12*`z' 24*`z') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Time Since Challenge
simqi, fd(prval(1)) changex(z_ts_challenge 12*`z' 36*`z') level(90)
simqi, fd(prval(1) genpr(fd)) changex(z_ts_challenge 12*`z' 36*`z') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Number of Previous Challenges
simqi, fd(prval(1)) changex(z_no_challenge 3*`z' 1*`z') level(90)
simqi, fd(prval(1) genpr(fd)) changex(z_no_challenge 3*`z' 1*`z') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Real GDP Per Capita Growth: Fail
simqi, fd(prval(1)) changex(z_annual_ch_rgdppc 1*`z' 2.5*`z') level(90)
simqi, fd(prval(1) genpr(fd)) changex(z_annual_ch_rgdppc 1*`z' 2.5*`z') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Real GDP Per Capita Growth: Pass
simqi, fd(prval(1)) changex(y_annual_ch_rgdppc 1*`y' 2.5*`y') level(90)
simqi, fd(prval(1) genpr(fd)) changex(y_annual_ch_rgdppc 1*`y' 2.5*`y') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Effective Parliamentary Parties
simqi, fd(prval(1)) changex(y_eff_par 2.4*`y' 4*`y') level(90)
simqi, fd(prval(1) genpr(fd)) changex(y_eff_par 2.4*`y' 4*`y') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

**********************************************************************************
**** Substantive Effects of Pr(Accept)
**********************************************************************************
use "Williams PSRM.dta", clear

quietly logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
qui sum ciep_perc if e(sample)
local s_ciep = r(mean)
local e_ciep = r(mean) + r(sd)

qui sum return_elect if e(sample)
local s_ret = r(mean)
local e_ret = r(mean) + r(sd)

qui sum annual_ch_rgdppc if e(sample)
local s_gdp = r(mean)
local e_gdp = r(mean) + r(sd)

set seed 648
estsimp logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
setx surplus 0 minority 1 gparties 1 ts_govt mean return_elect .5 ciep_perc 1
simqi, prval(1) genpr(pra)
qui sum pra, meanonly
local base = r(mean)

* Surplus
simqi, fd(prval(1)) changex(surplus 0 1) level(90)
simqi, fd(prval(1) genpr(fd)) changex(surplus 0 1) level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Minority
simqi, fd(prval(1)) changex(minority 0 1) level(90)
simqi, fd(prval(1) genpr(fd)) changex(minority 0 1) level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Government parties
simqi, fd(prval(1)) changex(gparties 1 4) level(90)
simqi, fd(prval(1) genpr(fd)) changex(gparties 1 4) level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* CIEP
simqi, fd(prval(1)) changex(ciep_perc 1.0 .5) level(90)
simqi, fd(prval(1) genpr(fd)) changex(ciep_perc 1.0 .5) level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* Returnability 
simqi, fd(prval(1)) changex(return_elect .50 .85) level(90)
simqi, fd(prval(1) genpr(fd)) changex(return_elect .50 .85) level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

* GDP
simqi, fd(prval(1)) changex(annual_ch_rgdppc 2 5) level(90)
simqi, fd(prval(1) genpr(fd)) changex(annual_ch_rgdppc 2 5) level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

simqi, fd(prval(1)) changex(annual_ch_rgdppc `s_gdp' `e_gdp') level(90)
simqi, fd(prval(1) genpr(fd)) changex(annual_ch_rgdppc `s_gdp' `e_gdp') level(95)
qui sum fd, meanonly
local fd = r(mean)
di 100*(`fd'/`base')
drop fd

*********************************************************************
**** Figure 4: Probability of opposition proposing a no-confidence motion across government tenure for three different values of probability of accept
*********************************************************************
use "Williams PSRM.dta", clear

logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
predict pr_sbi 

qui foreach i of varlist surplus minority gparties ciep_perc ts_govt ts_challenge no_challenge annual_ch_rgdppc {
	gen z_`i' = (1 - pr_sbi) * `i'
}

qui foreach j of varlist annual_ch_rgdppc eff_par {
	gen y_`j' = pr_sbi * `j'
}

set seed 648
estsimp logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode) genname(zzz)
setx mean
simqi, prval(1) genpr(base)

set seed 648
qui estsimp logit opp_conf_dummy z_surplus z_minority z_gparties z_ciep_perc z_ts_govt z_ts_challenge z_no_challenge z_annual_ch_rgdppc y_annual_ch_rgdppc y_eff_par, nocons iterate(500) genname(xxx)

tempfile pr_best pr_okay pr_worst
local base = (1-.5)

preserve
	gen b = .
	gen u = .
	gen l = .
	gen vectaxis = .
	local b = 1
	qui forvalues i = 0(1)48 {
		setx mean
		setx z_ts_govt `i'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		capture drop x
		local b = `b' + 1
	}
	keep vectaxis b l u
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_best', replace
restore

local base = (1-.25)

preserve
	gen b = .
	gen u = .
	gen l = .
	gen vectaxis = .
	local b = 1
	qui forvalues i = 0(1)48 {
		setx mean
		setx z_ts_govt `i'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		capture drop x
		local b = `b' + 1
	}
	keep vectaxis b l u
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_okay', replace
restore

local base = (1-.05)

preserve
	gen b = .
	gen u = .
	gen l = .
	gen vectaxis = .
	local b = 1
	qui forvalues i = 0(1)48 {
		setx mean
		setx z_ts_govt `i'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		capture drop x
		local b = `b' + 1
	}
	keep vectaxis b l u
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_worst', replace
restore

preserve
	use `pr_best', clear
	sort vectaxis
	rename b b_best
	rename u u_best
	rename l l_best
	sort vectaxis
	merge vectaxis using `pr_okay'
	drop _merge
	rename b b_okay
	rename u u_okay
	rename l l_okay
	sort vectaxis
	merge vectaxis using `pr_worst'
	drop _merge
	rename b b_worst
	rename u u_worst
	rename l l_worst
	save pr_tenure.dta, replace
restore


*********************************************************************
**** Figure 5: Probability of opposition proposing a no-confidence motion across the electoral cycle for three different values of probability of accept
*********************************************************************
use "Williams PSRM.dta", clear

logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
predict pr_sbi 

foreach i of varlist surplus minority gparties ciep_perc ts_govt ts_challenge no_challenge annual_ch_rgdppc {
	gen z_`i' = (1 - pr_sbi) * `i'
}

foreach j of varlist annual_ch_rgdppc eff_par {
	gen y_`j' = pr_sbi * `j'
}

set seed 648
estsimp logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode) genname(zzz)
setx mean
simqi, prval(1) genpr(base)

set seed 648
qui estsimp logit opp_conf_dummy z_surplus z_minority z_gparties z_ciep_perc z_ts_govt z_ts_challenge z_no_challenge z_annual_ch_rgdppc y_annual_ch_rgdppc y_eff_par, nocons iterate(500) genname(xxx)

tempfile pr_best pr_okay pr_worst
local base = (1-.5)

preserve
	gen b = .
	gen u = .
	gen l = .
	gen vectaxis = .
	local b = 1
	forvalues i = 0(.1)1 {
		setx mean
		setx z_ciep_perc `i'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		capture drop x
		local b = `b' + 1
	}
	keep vectaxis b l u
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_best', replace
restore

local base = (1-.25)

preserve
	gen b = .
	gen u = .
	gen l = .
	gen vectaxis = .
	local b = 1
	forvalues i = 0(.1)1 {
		setx mean
		setx z_ciep_perc `i'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		capture drop x
		local b = `b' + 1
	}
	keep vectaxis b l u
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_okay', replace
restore

local base = (1-.05)

preserve
	gen b = .
	gen u = .
	gen l = .
	gen vectaxis = .
	local b = 1
	forvalues i = 0(.1)1 {
		setx mean
		setx z_ciep_perc `i'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		capture drop x
		local b = `b' + 1
	}
	keep vectaxis b l u
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_worst', replace
restore

preserve
	use `pr_best', clear
	sort vectaxis
	rename b b_best
	rename u u_best
	rename l l_best
	sort vectaxis
	merge vectaxis using `pr_okay'
	drop _merge
	rename b b_okay
	rename u u_okay
	rename l l_okay
	sort vectaxis
	merge vectaxis using `pr_worst'
	drop _merge
	rename b b_worst
	rename u u_worst
	rename l l_worst
	save pr_ciep.dta, replace
restore

************************************************************************************
*** Figure 6: Probability of opposition proposing a NCM for one government versus three governments
************************************************************************************
use "Williams PSRM.dta", clear

qui logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
predict pr_sbi 

qui foreach i of varlist surplus minority gparties ciep_perc ts_govt ts_challenge no_challenge annual_ch_rgdppc {
	gen z_`i' = (1 - pr_sbi) * `i'
}

qui foreach j of varlist annual_ch_rgdppc eff_par {
	gen y_`j' = pr_sbi * `j'
}

*** First scenario (government starts at ciep = 1)
set seed 648
qui estsimp logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode) genname(zzz)
setx mean
simqi, prval(1) genpr(base)

set seed 648
qui estsimp logit opp_conf_dummy z_surplus z_minority z_gparties z_ciep_perc z_ts_govt z_ts_challenge z_no_challenge z_annual_ch_rgdppc y_annual_ch_rgdppc y_eff_par, nocons iterate(500) genname(xxx)

tempfile pr_okay pr_1_govt

local base = (1-.25)

preserve
	gen b = .
	gen u = .
	gen l = .
	gen vectaxis = .
	gen vectaxis_2 = .
	local b = 1
	local it = 0
	qui forvalues i = 0(.01)1 {
		local g = 48-(`it'*.48)
		setx mean
		setx z_ciep_perc `i'*`base' z_ts_govt `g'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		replace vectaxis_2 = `g' in `b'
		capture drop x
		local b = `b' + 1
		local it = `it' + 1
	}
	keep vectaxis vectaxis_2 b l u
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_okay', replace
	save `pr_1_govt', replace
restore
	
*** Next Scenario (new governments at 1, .6, and .4)
tempfile pr_g1 pr_g2 pr_g3

local base = (1-.25)

preserve
	gen b = .
	gen u = .
	gen l = .
	gen govt = 3
	gen vectaxis = .
	gen vectaxis_2 = .
	local b = 1
	local it = 0
	qui forvalues i = .3(-.01)0 {
		local g = 0+(`it'*.48)
		setx mean
		setx z_ciep_perc `i'*`base' z_ts_govt `g'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		replace vectaxis_2 = `g' in `b'
		capture drop x
		local b = `b' + 1
		local it = `it' + 1
	}
	keep vectaxis vectaxis_2 b l u govt
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_g3', replace
restore

preserve
	gen b = .
	gen u = .
	gen l = .
	gen govt = 2
	gen vectaxis = .
	gen vectaxis_2 = .
	local b = 1
	local it = 0
	qui forvalues i = .5(-.01).31 {
		local g = 0+(`it'*.48)
		setx mean
		setx z_ciep_perc `i'*`base' z_ts_govt `g'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		replace vectaxis_2 = `g' in `b'
		capture drop x
		local b = `b' + 1
		local it = `it' + 1
	}
	keep vectaxis vectaxis_2 b l u govt
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_g2', replace
restore
	
preserve
	gen b = .
	gen u = .
	gen l = .
	gen govt = 1
	gen vectaxis = .
	gen vectaxis_2 = .
	local b = 1
	local it = 0
	qui forvalues i = 1(-.01).51 {
		local g = 0+(`it'*.48)
		setx mean
		setx z_ciep_perc `i'*`base' z_ts_govt `g'*`base'
		simqi, prval(1) genpr(x)
		sum x, meanonly
		replace b = `r(mean)' in `b'
		_pctile x, p(2.5,97.5)
		replace l = r(r1) in `b'
		replace u = r(r2) in `b'
		replace vectaxis = `i' in `b'
		replace vectaxis_2 = `g' in `b'
		capture drop x
		local b = `b' + 1
		local it = `it' + 1
	}
	keep vectaxis vectaxis_2 b l u govt
	keep if !missing(vectaxis)
	sort vectaxis
	save `pr_g1', replace
restore

preserve
	use `pr_g1', clear
	append using `pr_g2'
	append using `pr_g3'
	sort vectaxis
	tempfile pr_3_govt
	save `pr_3_govt', replace
restore

preserve
	use `pr_1_govt', clear
	rename b b_1
	rename u u_1
	rename l l_1
	sort vectaxis
	merge vectaxis using `pr_3_govt'
	tab _merge
	drop if inlist(_merge, 1,2)
	drop _merge
	save pr.dta, replace
restore

**********************************************************************************
**** Descriptive Statistics
**********************************************************************************
use "Williams PSRM.dta", clear

* Accept model
qui logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
tab no_conf_dummy if e(sample)
tab minority if e(sample)
tab surplus if e(sample)
tab gparties if e(sample)
sum gparties ciep_perc ts_govt return_elect surplus minority annual_ch_rgdppc if e(sample)

preserve
	keep if e(sample)
	collapse (sum) success = no_conf_dummy, by(abbrev)
	sort abbrev
	list abbrev success
restore

preserve
	keep if e(sample)
	collapse (count) ncm = opp_conf_dummy, by(abbrev)
	sort abbrev
	list abbrev ncm
restore

preserve
	sort abbrev
	list ccode ts surplus minority gparties ts_govt ciep_perc if no_conf_dummy==1 & e(sample)
restore

* Propose model
qui logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
predict pr_sbi 

foreach i of varlist surplus minority gparties ciep_perc ts_govt ts_challenge no_challenge annual_ch_rgdppc {
	gen z_`i' = (1 - pr_sbi) * `i'
}

foreach j of varlist annual_ch_rgdppc eff_par {
	gen y_`j' = pr_sbi * `j'
}

quietly logit opp_conf_dummy z_surplus z_minority z_gparties z_ciep_perc z_ts_govt z_ts_challenge z_no_challenge z_annual_ch_rgdppc y_annual_ch_rgdppc y_eff_par, nocons iterate(100) robust cluster(ccode)
tab no_conf_dummy if e(sample)
tab opp_conf_dummy if e(sample)
tab surplus if e(sample)
tab minority if e(sample)
tab gparties if e(sample)
sum pr_sbi gparties ciep_perc ts_govt ts_challenge no_challenge annual_ch_rgdppc eff_par surplus minority annual_ch_rgdppc if e(sample)

preserve
	keep if e(sample)
	collapse (min) start = ts (max) end = ts, by(abbrev)
	sort abbrev
	list abbrev start end
restore

* Interpolation test for three scenarios
preserve
	keep if inrange(pr_sbi, .045, .055) & e(sample)
	sort abbrev ts
	list abbrev ts, sepby(abbrev)
	di _N
restore

preserve
	keep if inrange(pr_sbi, .2, .3) & e(sample)
	sort abbrev ts
	list abbrev ts, sepby(abbrev)
	di _N
restore

preserve
	keep if inrange(pr_sbi, .45, .55) & e(sample)
	sort abbrev ts
	list abbrev ts, sepby(abbrev)
	di _N
restore


**********************************************************************************
**********************************************************************************
***************** Additional Materials ****************************************
**********************************************************************************
**********************************************************************************

**********************************************************************************
**** Including institutional variables in the U_O(Pass)
**********************************************************************************
use "Williams PSRM.dta", clear

logit no_conf_dummy surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
predict pr_sbi 

foreach i of varlist surplus minority gparties ciep_perc ts_govt ts_challenge no_challenge annual_ch_rgdppc {
	gen z_`i' = (1 - pr_sbi) * `i'
}

foreach j of varlist surplus minority gparties ciep_perc ts_govt annual_ch_rgdppc eff_par {
	gen y_`j' = pr_sbi * `j'
}

di "$S_TIME"
bootstrap r(surplus) r(minority) r(gparties) r(ciep_perc) r(ts_govt) r(ts_challenge) r(no_challenge) r(annual_ch_rgdppc_F) r(surplus_P) r(minority_P) r(gparties_P) r(ciep_perc_P) r(ts_govt_P) r(annual_ch_rgdppc_P) r(eff_par), reps(1000) dots: sbi3, seed(648)
di "$S_TIME"

pwcorr z_surplus z_minority z_gparties z_ciep_perc z_ts_govt z_ts_challenge z_no_challenge z_annual_ch_rgdppc y_surplus y_minority y_gparties y_ciep_perc y_ts_govt y_annual_ch_rgdppc y_eff_par if e(sample)

**********************************************************************************
**** Curvilinear relationship
**********************************************************************************
use "Williams PSRM.dta", clear

logit no_conf_dummy surplus minority gparties ciep_perc ciep_perc2 ts_govt ts_govt2 annual_ch_rgdppc return_elect if opp_conf_dummy==1, robust cluster(ccode)
predict pr_sbi 

foreach i of varlist surplus minority gparties ciep_perc ciep_perc2 ts_govt ts_govt2 ts_challenge no_challenge annual_ch_rgdppc {
	gen z_`i' = (1 - pr_sbi) * `i'
}

foreach j of varlist annual_ch_rgdppc eff_par {
	gen y_`j' = pr_sbi * `j'
}

di "$S_TIME"
bootstrap r(surplus) r(minority) r(gparties) r(ciep_perc) r(ciep_perc2) r(ts_govt) r(ts_govt2) r(ts_challenge) r(no_challenge) r(annual_ch_rgdppc_F) r(annual_ch_rgdppc_P) r(eff_par), reps(1000) dots: sbi2, seed(648)
di "$S_TIME"

log close












