* 11-5-11
* Estimates the probability of a hostile dispute for the "Flexible Election Timing and International Conflict" ISQ.

* NOTE: 
* You have to run the "Election Timing--Election Results--Replication.do" file before this.  It produces the data set required for the second stage ("Election Hazard--Logit Clarify.dta").
* Two sections of the replication file take many hours each to complete: 1) calculating the 1000 coefficients for each variable in the second stage, and 2) calculating the predicted probabilities of a conflict for the three scenarios.
* Set up the working directory via the "cd" command

cd "C:\Users\\$D\Documents\Research\Projects\Election Cycles and Conflict\Midwest 2011\TeX\ISQ\Final Submission\Replication\"

clear
set mem 200m

* Set up the global macros for the model
global M "lower_dem minor_dyad cap_1 cap_2 noncontig_dummy log_distance alliance_dummy tenure_1 tenure_2 gov_rile_1 annual_ch_rgdppc_1 annual_ch_rgdppc_2"
global IM "init_force_dummy sp1_init_force sp2_init_force sp3_init_force"

****************************************************************************************************************************
* Dyadic models of conflict.
* For each of the 1000 draws of the future election probability from the first stage, merge it into the Dyadic data set, estimate the conflict model and save the coefficient; the 1000 draws from each of the coefficients will be saved into the "iam_clarify.dta" data set.
****************************************************************************************************************************
* Run this only once to generate the 1000 draws.
use "Election Timing--Dyadic.dta", clear

noisily display "$S_TIME	"		

set seed 648

local k = 17
quietly foreach x of numlist 1(1)`k' {
	gen k_`x' = .
}

quietly foreach n of numlist 1(1)1000 {
	rename ccode1 ccode
	sort ccode ts
	merge ccode ts using "Election Hazard--Logit Clarify.dta", keep(future_pr_`n'_1)
	drop if _merge==2
	drop _merge
	rename ccode ccode1
	rename future_pr_`n'_1 future_ehaz1_1
	logit $IM future_ehaz1_1 $M if ccode1!=666, iterate(20) nolog robust cluster(ccode1)
	mat b = e(b)
	foreach i of numlist 1(1)`k' {
		replace k_`i' = b[1,`i'] in `n'
	}
	if mod(`n',100) == 0 {
		noisily display "." _c
		if mod(`n',1000) == 0 {
			noisily display ""
		}
	}
	drop future_ehaz1_1 
}

keep k_*
save im_clarify.dta, replace

noisily display "$S_TIME	"		



****************************************************************************************************************************
* Substantive effects for dyadic model of conflict.
* On the 1000 in-sample predicted probabilities from the first-stage logit, estimate the predicted probability of initiated force in that quarter according to three scenarios of other explanatory variables: safe, okay and hostile.
* NOTE:
* Run these commands only once to create the three data sets of predicted probabilities: election_mid_safe_long.dta, election_mid_okay_long.dta, and election_mid_hostile_long.dta
* Change the X matrix according to the values you want.
* Change the range of values and iterations for the variable of interest.
****************************************************************************************************************************



***************
* Three scenarios
***************
* Safe Scenario
use "im_clarify.dta", clear

local start = 0
local stop = 1
local it = .01

local a = 1
quietly foreach i of numlist `start'(`it')`stop' {
	gen pr_`a' = .
	local a = `a' + 1
}

quietly foreach n of numlist 1(1)1000 {
	if `n' == 1 {
		di
		di
		noisily display "Simulations started..."
	}
	if mod(`n',100) == 0 {
		noisily display "." _c
		noisily display "*" 		"$S_TIME	"		"	Simulation # " `n'
		if mod(`n',1000) == 0 {
			noisily display ""
		}
	}
	preserve
		keep in `n'
		mkmat k_*, matrix(b)
		mat B = b'
	restore
	local a = 1
	quietly foreach i of numlist `start'(`it')`stop' {
		mat X =(-50000,-75000,-50000,`i',0,1,.01,.01,1,8,0,16,16,0,0,2,1)
		matrix xb = X*B
		svmat xb
		gen xb1_inv = invlogit(xb1)
		sum xb1_inv, meanonly
		local val = r(mean)
		replace pr_`a' = `val' in `n'
		local a = `a' + 1
		drop xb1*
		matrix drop X xb
	}
	matrix drop b B
}

preserve
	local x = `start'
	local a = `a' - 1
	keep if pr_1 != .
	keep pr_*
	gen sim = _n
	reshape long pr_, i(sim) j(vectaxis)
	foreach i of numlist 1(1)`a' {
		replace vectaxis = `x' if vectaxis == `i'
		local x = `x' + `it'
		local x = round(`x',.001)
	}
	rename pr_ pr
	sort vectaxis sim
	save election_mid_safe_long.dta, replace
restore


* Okay Scenario
use "im_clarify.dta", clear

local start = 0
local stop = 1
local it = .01

local a = 1
quietly foreach i of numlist `start'(`it')`stop' {
	gen pr_`a' = .
	local a = `a' + 1
}

quietly foreach n of numlist 1(1)1000 {
	if `n' == 1 {
		di
		di
		noisily display "Simulations started..."
	}
	if mod(`n',100) == 0 {
		noisily display "." _c
		noisily display "*" 		"$S_TIME	"		"	Simulation # " `n'
		if mod(`n',1000) == 0 {
			noisily display ""
		}
	}
	preserve
		keep in `n'
		mkmat k_*, matrix(b)
		mat B = b'
	restore
	local a = 1
	quietly foreach i of numlist `start'(`it')`stop' {
		mat X =(-25000,-75000,-25000,`i',0,1,.01,.01,1,8,0,16,16,0,0,2,1)
		matrix xb = X*B
		svmat xb
		gen xb1_inv = invlogit(xb1)
		sum xb1_inv, meanonly
		local val = r(mean)
		replace pr_`a' = `val' in `n'
		local a = `a' + 1
		drop xb1*
		matrix drop X xb
	}
	matrix drop b B
}

preserve
	local x = `start'
	local a = `a' - 1
	keep if pr_1 != .
	keep pr_*
	gen sim = _n
	reshape long pr_, i(sim) j(vectaxis)
	foreach i of numlist 1(1)`a' {
		replace vectaxis = `x' if vectaxis == `i'
		local x = `x' + `it'
		local x = round(`x',.001)
	}
	rename pr_ pr
	sort vectaxis sim
	save election_mid_okay_long.dta, replace
restore


* Hostile Scenario
use "im_clarify.dta", clear

local start = 0
local stop = 1
local it = .01

local a = 1
quietly foreach i of numlist `start'(`it')`stop' {
	gen pr_`a' = .
	local a = `a' + 1
}

quietly foreach n of numlist 1(1)1000 {
	if `n' == 1 {
		di
		di
		noisily display "Simulations started..."
	}
	if mod(`n',100) == 0 {
		noisily display "." _c
		noisily display "*" 		"$S_TIME	"		"	Simulation # " `n'
		if mod(`n',1000) == 0 {
			noisily display ""
		}
	}
	preserve
		keep in `n'
		mkmat k_*, matrix(b)
		mat B = b'
	restore
	local a = 1
	quietly foreach i of numlist `start'(`it')`stop' {
		mat X =(-15000,-75000,-15000,`i',0,1,.01,.01,1,8,0,16,16,0,0,2,1)
		matrix xb = X*B
		svmat xb
		gen xb1_inv = invlogit(xb1)
		sum xb1_inv, meanonly
		local val = r(mean)
		replace pr_`a' = `val' in `n'
		local a = `a' + 1
		drop xb1*
		matrix drop X xb
	}
	matrix drop b B
}

preserve
	local x = `start'
	local a = `a' - 1
	keep if pr_1 != .
	keep pr_*
	gen sim = _n
	reshape long pr_, i(sim) j(vectaxis)
	foreach i of numlist 1(1)`a' {
		replace vectaxis = `x' if vectaxis == `i'
		local x = `x' + `it'
		local x = round(`x',.001)
	}
	rename pr_ pr
	sort vectaxis sim
	save election_mid_hostile_long.dta, replace
restore

* Produce the figures
*** Safe Scenario
use election_mid_safe_long.dta, clear
by vectaxis: egen pr_mn = mean(pr)
by vectaxis: egen pr_lower = pctile(pr), p(2.5)
by vectaxis: egen pr_upper = pctile(pr), p(97.5)
collapse (max) pr_mn pr_lower pr_upper, by(vectaxis)

qui sum pr_mn in 1
local base = r(mean)
di "Baseline probability = "  `base'
qui sum pr_mn in 9
local one = r(mean)
di "Probability when fep is .08 = "  `one'
di "Change in probability = " `one' - `base'
di "Percentage change =  " 100*((`one'-`base')/`base')
qui sum pr_mn in 31
local two = r(mean)
di "Probability when fep is .3 = "  `two'
di "Change in probability = " `two' - `base'
di "Percentage change =  " 100*((`two'-`base')/`base')

twoway (line pr_mn vectaxis, clpattern(solid) sort) (line pr_lower vectaxis, clpattern(dash) sort) (line pr_upper vectaxis, clpattern(dash) sort), /*
*/	ytitle(" ""PR(Initiate MID)") legend(off) xscale(off) /*
*/	xtitle("Future Election Hazard") /*
*/	name(e_safe, replace)

preserve
	outsheet using pr_mid_safe_long.csv, comma replace
restore

*** Okay Scenario
use election_mid_okay_long.dta, clear
by vectaxis: egen pr_mn = mean(pr)
by vectaxis: egen pr_lower = pctile(pr), p(2.5)
by vectaxis: egen pr_upper = pctile(pr), p(97.5)
collapse (max) pr_mn pr_lower pr_upper, by(vectaxis)

qui sum pr_mn in 1
local base = r(mean)
di "Baseline probability = "  `base'
qui sum pr_mn in 9
local one = r(mean)
di "Probability when fep is .08 = "  `one'
di "Change in probability = " `one' - `base'
di "Percentage change =  " 100*((`one'-`base')/`base')
qui sum pr_mn in 31
local two = r(mean)
di "Probability when fep is .3 = "  `two'
di "Change in probability = " `two' - `base'
di "Percentage change =  " 100*((`two'-`base')/`base')

twoway (line pr_mn vectaxis, clpattern(solid) sort) (line pr_lower vectaxis, clpattern(dash) sort) (line pr_upper vectaxis, clpattern(dash) sort), /*
*/	ytitle(" ""PR(Initiate MID)") legend(off) xscale(off)/*
*/	xtitle("Future Election Hazard") /*
*/	name(e_okay, replace)

preserve
	outsheet using pr_mid_okay_long.csv, comma replace
restore

*** Hostile Scenario
use election_mid_hostile_long.dta, clear
by vectaxis: egen pr_mn = mean(pr)
by vectaxis: egen pr_lower = pctile(pr), p(2.5)
by vectaxis: egen pr_upper = pctile(pr), p(97.5)
collapse (max) pr_mn pr_lower pr_upper, by(vectaxis)

qui sum pr_mn in 1
local base = r(mean)
di "Baseline probability = "  `base'
qui sum pr_mn in 9
local one = r(mean)
di "Probability when fep is .08 = "  `one'
di "Change in probability = " `one' - `base'
di "Percentage change =  " 100*((`one'-`base')/`base')
qui sum pr_mn in 31
local two = r(mean)
di "Probability when fep is .3 = "  `two'
di "Change in probability = " `two' - `base'
di "Percentage change =  " 100*((`two'-`base')/`base')

twoway (line pr_mn vectaxis, clpattern(solid) sort) (line pr_lower vectaxis, clpattern(dash) sort) (line pr_upper vectaxis, clpattern(dash) sort), /*
*/	ytitle(" ""PR(Initiate MID)") legend(off) /*
*/	xtitle("Future Election Hazard") /*
*/	name(e_hostile, replace)

preserve
	outsheet using pr_mid_hostile_long.csv, comma replace
restore

graph combine e_safe e_okay e_hostile, cols(1)


****************************************************************************************************************************
* Get the confidence intervals for the tables.
****************************************************************************************************************************
use "im_clarify.dta", clear

local v "sp1_init_force sp2_init_force sp3_init_force future_ehaz1_1 lower_dem minor_dyad cap_1 cap_2 noncontig_dummy log_distance alliance_dummy tenure_1 tenure_2 gov_rile_1 annual_ch_rgdppc_1 annual_ch_rgdppc_2 constant"
foreach i of numlist 1(1)17 {
	local name: word `i' of `v'
	qui sum k_`i', meanonly
	local mn = r(mean)
	_pctile k_`i', p(2.5, 97.5)
	di "`name' Beta = "   `mn'
	di
	di "`name' 95% CI = " r(r1) "   " r(r2)
	di
	_pctile k_`i', p(5.0, 95.0)
	di "`name' 90% CI = " r(r1) "   " r(r2)
	di
	di
}


******************************************************
* Predicted change in probabilities for other variables.
******************************************************
* Future election hazard
use "im_clarify.dta", clear

local s1 = 0
local s2 = 1

gen diff = .

quietly foreach n of numlist 1(1)500 {
	if `n' == 1 {
		di
		di
		noisily display "Simulations started..."
	}
	if mod(`n',100) == 0 {
		noisily display "." _c
		noisily display "*" 		"$S_TIME	"		"	Simulation # " `n'
		if mod(`n',1000) == 0 {
			noisily display ""
		}
	}
	preserve
		keep in `n'
		mkmat k_*, matrix(b)
		mat B = b'
	restore
	mat X1 =(-25000,-75000,-25000,`s1',0,1,.01,.01,1,8,0,16,16,0,0,2,1)
	matrix xb = X1*B
	svmat xb
	gen xb1_inv = invlogit(xb1)
	sum xb1_inv, meanonly
	local val1 = r(mean)
	mat X2 =(-25000,-75000,-25000,`s2',0,1,.01,.01,1,8,0,16,16,0,0,2,1)
	matrix xb2 = X2*B
	svmat xb2
	gen xb2_inv = invlogit(xb21)
	sum xb2_inv, meanonly
	local val2 = r(mean)
	replace diff = `val2' - `val1' in `n'
	drop xb1* xb2*
	matrix drop X1 X2 xb xb2
	matrix drop b B
}

log using "change in probs.smcl", append

sort diff
qui sum diff
local diff_mean = r(mean)
_pctile diff, p(2.5, 97.5)
di "Change 95% CI = " r(r1) "   " r(r2)
di "Mean  = "  `diff_mean'
di
_pctile diff, p(5.0, 95.0)
di "Change 90% CI = " r(r1) "   " r(r2)
di "Mean  = "  `diff_mean'
	
log close

* Change in minor_dyad: from minor dyad to major dyad
use "im_clarify.dta", clear

local s1 = 1
local s2 = 0

gen diff = .

quietly foreach n of numlist 1(1)500 {
	if `n' == 1 {
		di
		di
		noisily display "Simulations started..."
	}
	if mod(`n',100) == 0 {
		noisily display "." _c
		noisily display "*" 		"$S_TIME	"		"	Simulation # " `n'
		if mod(`n',1000) == 0 {
			noisily display ""
		}
	}
	preserve
		keep in `n'
		mkmat k_*, matrix(b)
		mat B = b'
	restore
	mat X1 =(-25000,-75000,-25000,.1,0,`s1',.01,.01,1,8,0,16,16,0,0,2,1)
	matrix xb = X1*B
	svmat xb
	gen xb1_inv = invlogit(xb1)
	sum xb1_inv, meanonly
	local val1 = r(mean)
	mat X2 =(-25000,-75000,-25000,.1,0,`s2',.01,.01,1,8,0,16,16,0,0,2,1)
	matrix xb2 = X2*B
	svmat xb2
	gen xb2_inv = invlogit(xb21)
	sum xb2_inv, meanonly
	local val2 = r(mean)
	replace diff = `val2' - `val1' in `n'
	drop xb1* xb2*
	matrix drop X1 X2 xb xb2
	matrix drop b B
}

log using "change in probs.smcl", append
* Change in minor_dyad: from minor dyad to major dyad
sort diff
qui sum diff
local diff_mean = r(mean)
_pctile diff, p(2.5, 97.5)
di "Change 95% CI = " r(r1) "   " r(r2)
di "Mean  = "  `diff_mean'
di
_pctile diff, p(5.0, 95.0)
di "Change 90% CI = " r(r1) "   " r(r2)
di "Mean  = "  `diff_mean'

log close

* Change in non-contiguous dummy: from non-contiguous to contiguous
use "im_clarify.dta", clear

local s1 = 1
local s2 = 0

gen diff = .

quietly foreach n of numlist 1(1)500 {
	if `n' == 1 {
		di
		di
		noisily display "Simulations started..."
	}
	if mod(`n',100) == 0 {
		noisily display "." _c
		noisily display "*" 		"$S_TIME	"		"	Simulation # " `n'
		if mod(`n',1000) == 0 {
			noisily display ""
		}
	}
	preserve
		keep in `n'
		mkmat k_*, matrix(b)
		mat B = b'
	restore
	mat X1 =(-25000,-75000,-25000,.1,0,1,.01,.01,`s1',8,0,16,16,0,0,2,1)
	matrix xb = X1*B
	svmat xb
	gen xb1_inv = invlogit(xb1)
	sum xb1_inv, meanonly
	local val1 = r(mean)
	mat X2 =(-25000,-75000,-25000,.1,0,1,.01,.01,`s2',8,0,16,16,0,0,2,1)
	matrix xb2 = X2*B
	svmat xb2
	gen xb2_inv = invlogit(xb21)
	sum xb2_inv, meanonly
	local val2 = r(mean)
	replace diff = `val2' - `val1' in `n'
	drop xb1* xb2*
	matrix drop X1 X2 xb xb2
	matrix drop b B
}

log using "change in probs.smcl", append
* Change in non-contiguous dummy: from non-contiguous to contiguous
sort diff
qui sum diff
local diff_mean = r(mean)
_pctile diff, p(2.5, 97.5)
di "Change 95% CI = " r(r1) "   " r(r2)
di "Mean  = "  `diff_mean'
di
_pctile diff, p(5.0, 95.0)
di "Change 90% CI = " r(r1) "   " r(r2)
di "Mean  = "  `diff_mean'

log close


* Change in distance: going from closer (5) to farther away (8)
use "im_clarify.dta", clear

local s1 = 5
local s2 = 8

gen diff = .

quietly foreach n of numlist 1(1)500 {
	if `n' == 1 {
		di
		di
		noisily display "Simulations started..."
	}
	if mod(`n',100) == 0 {
		noisily display "." _c
		noisily display "*" 		"$S_TIME	"		"	Simulation # " `n'
		if mod(`n',1000) == 0 {
			noisily display ""
		}
	}
	preserve
		keep in `n'
		mkmat k_*, matrix(b)
		mat B = b'
	restore
	mat X1 =(-25000,-75000,-25000,.1,0,1,.01,.01,1,`s1',0,16,16,0,0,2,1)
	matrix xb = X1*B
	svmat xb
	gen xb1_inv = invlogit(xb1)
	sum xb1_inv, meanonly
	local val1 = r(mean)
	mat X2 =(-25000,-75000,-25000,.1,0,1,.01,.01,1,`s2',0,16,16,0,0,2,1)
	matrix xb2 = X2*B
	svmat xb2
	gen xb2_inv = invlogit(xb21)
	sum xb2_inv, meanonly
	local val2 = r(mean)
	replace diff = `val2' - `val1' in `n'
	drop xb1* xb2*
	matrix drop X1 X2 xb xb2
	matrix drop b B
}

log using "change in probs.smcl", append
* Change in distance: going from closer (5) to farther away (8)
sort diff
qui sum diff
local diff_mean = r(mean)
_pctile diff, p(2.5, 97.5)
di "Change 95% CI = " r(r1) "   " r(r2)
di "Mean  = "  `diff_mean'
di
_pctile diff, p(5.0, 95.0)
di "Change 90% CI = " r(r1) "   " r(r2)
di "Mean  = "  `diff_mean'

log close


******************************************************
* Descriptive statistics.
******************************************************
use "Election Timing--Dyadic.dta", clear
set seed 648

lab def ccode1 2 "USA" 20 "Canada" 200 "Great Britain" 205 "Ireland" 210 "Netherlands" 211 "Belgium" 212 "Luxembourg" 220 "France" 225 "Switzerland" 230 "Spain" 235 "Portugal" 255 "Germany" 305 "Austria" 325 "Italy" 350 "Greece" 375 "Finland" 380 "Sweden" 385 "Norway" 390 "Denmark" 395 "Iceland" 640 "Turkey" 666 "Ireland" 740 "Japan" 900 "Australia" 920 "New Zealand"
lab val ccode1 ccode1

keep if init_sample == 1
rename ccode1 ccode
sort ccode ts
merge ccode ts using "Election Hazard--Logit Clarify.dta", keep(future_pr_1_1)
drop if _merge==2
drop _merge
rename ccode ccode1
rename future_pr_1_1 future_ehaz1_1

qui logit $IM future_ehaz1_1 $M if ccode1!=666, iterate(20)

preserve
	keep if e(sample)
	sum $M future_ehaz1_1
	sum future_ehaz1_1, det
	tab minor_dyad
	tab noncontig_dummy
	tab alliance_dummy 
	collapse (count) obs = id (sum) numb_im = init_force_dummy (max) max_ts = ts (min) min_ts = ts, by(ccode1)
	list ccode1 obs min_ts max_ts numb_im
	collapse (sum) obs numb_im
	list obs numb_im
restore




****************************************************************************************************************************
* Changes in Probability of Initiating a MID based on varying the government attributes variables.
****************************************************************************************************************************
use "Election Timing.dta", clear

gen nois_sample = .
replace nois_sample = 1 if (year>=1960 & year<=2001) & (ccode== 20 | ccode== 200 | ccode== 205 | ccode== 210 | ccode== 211 | ccode== 220 | ccode== 230 | ccode== 235 | ccode== 255 | ccode== 305 | ccode== 325 | ccode== 350 | ccode== 375 | ccode== 390 | ccode== 395 | ccode== 740 | ccode== 900 | ccode== 920)

sort ccode intime
replace endtime = (intime + 1) if (ccode==ccode[_n+1] & intime==intime[_n+1]) & failure==1
replace intime = (intime + 2) if (ccode==ccode[_n-1] & intime==intime[_n-1])

stset endtime, id(id) failure(failure==1) origin(time intime) scale(365.25)

global S "if nois_sample==1"
global St "nois_sample"

* First, generate the predicted election probabilities across the range of the key variable.
* Time since call 
capture drop k_*
estsimp logit failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 740, nolog genname(k_) 

capture drop vectaxis
capture drop lower* upper* pr_*

gen pr = .
gen lower = .
gen upper = .
gen vectaxis = .

local b = 1
quietly foreach i of numlist 0(1)4 {
	setx majority 0 ciep_perc .62 eff_par mean ts_call `i' rgdppc_growth mean ts_govt mean
	simqi, prval(1) genpr(c)
	qui sum c, meanonly
	replace pr = r(mean) in `b'
	_pctile c, p(2.5,97.5)
	replace lower = r(r1) in `b'
	replace upper = r(r2) in `b'
	drop c
	replace vectaxis = `i' in `b'
	local b = `b' + 1	
}
preserve
	keep vectaxis pr lower upper 
	keep in 1/5
	sort vectaxis
	outsheet using pr_election_ts_call.csv, comma replace
restore

capture drop pr lower upper vectaxis

* Government tenure
capture drop k_*
estsimp logit failure sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 900, nolog genname(k_)

capture drop vectaxis
capture drop lower* upper* pr_*

gen pr = .
gen lower = .
gen upper = .
gen vectaxis = .

local b = 1
quietly foreach i of numlist 1(1)12 {
	setx sing_party 0 ciep_perc .62 eff_par mean ts_call 0 rgdppc_growth mean ts_govt `i'
	simqi, prval(1) genpr(c)
	qui sum c, meanonly
	replace pr = r(mean) in `b'
	_pctile c, p(2.5,97.5)
	replace lower = r(r1) in `b'
	replace upper = r(r2) in `b'
	drop c
	replace vectaxis = `i' in `b'
	local b = `b' + 1	
}

preserve
	keep vectaxis pr lower upper 
	keep in 1/12
	sort vectaxis
	outsheet using pr_election_ts_govt.csv, comma replace
restore

capture drop pr lower upper vectaxis


* The indirect effects of government attributes through election timing
use election_mid_okay_long.dta, clear
by vectaxis: egen pr_mn = mean(pr)
by vectaxis: egen pr_lower = pctile(pr), p(2.5)
by vectaxis: egen pr_upper = pctile(pr), p(97.5)
collapse (max) pr_mn pr_lower pr_upper, by(vectaxis)

preserve
	clear
	insheet using "pr_election_ts_call.csv", comma
	list vectaxis pr lower upper
restore

* change in probability as ts_call goes from 0 to 1
di "Baseline probability is .091967"
di "Change in probability is " .0586564-.091967
di 100*((.0586564-.091967)/.091967)

preserve
	clear
	insheet using "pr_election_ts_govt.csv", comma
	list vectaxis pr lower upper 
restore 

* change in probability as ts_govt goes from 1 to 4 and 4 to 8.
di "Baseline probability is .1099332"
di "Change in probability is " .1033956-.1099332
di 100*((.1033956-.1099332)/.1099332)

di "Change in probability is " .0869683-.1033956
di 100*((.0869683-.1033956)/.1033956)

