/*
Stata code for Military Coalitions and Crisis Duration

Daina Chiba and Jesse Johnson
last updated on: June 22, 2018
*/

clear
version 14

cap log close
log using "estimates/StataLog-analysis.txt", text replace

//-----------------------------------------------------------------//
//  Data
//-----------------------------------------------------------------//

use "coalition_crisis_phase.dta", clear

//-----------------------------------------------------------------//
//  Univariate analyses (Table 1)
//-----------------------------------------------------------------//

// stset end, id(crisno) failure(failure) time0(start) origin(start)

//drop pcdum30

// Table 1, Model 1
foreach dist in weibull logl logn {
	qui streg coalition_phase pcdum*, nocons dist(`dist') time tech(bfgs) difficult
	estimates store m1_`dist'
}

esttab m1_*, star(* 0.10 ** 0.05 *** 0.01) aic se mtitles("Weib" "LogL" "LogN")

// Table 1, Model 2
foreach dist in weibull logl logn {
	qui streg coalition_phase globorg_dum pcdum*, nocons dist(`dist') time tech(bfgs) difficult
	estimates store m2_`dist'
}

esttab m2_*, star(* 0.10 ** 0.05 *** 0.01) aic se mtitles("Weib" "LogL" "LogN")


// Table 1, Model 3
foreach dist in weibull logl logn {
	qui streg coalition_phase cinc_disparity pcdum*, nocons dist(`dist') time tech(bfgs) difficult
	estimates store m3_`dist'
}

esttab m3_*, star(* 0.10 ** 0.05 *** 0.01) aic se mtitles("Weib" "LogL" "LogN")

// Table 1, Model 4
foreach dist in weibull logl logn {
	qui streg coalition_phase globorg_dum cinc_disparity pcdum*, nocons dist(`dist') time tech(bfgs) difficult
	estimates store m4_`dist'
}

esttab m4_*, star(* 0.10 ** 0.05 *** 0.01) aic se mtitles("Weib" "LogL" "LogN")


// Table 1

esttab m1_logn m2_logn m3_logn m4_logn, star(* 0.10 ** 0.05 *** 0.01) aic se drop(pcdum*)


//-----------------------------------------------------------------//
//  Univariate analyses with programmed functions
//-----------------------------------------------------------------//

// Weibull

cap program drop myweibull
program define myweibull
	version 14
	args lnf xb lnp
	tempvar ph1 ph2 ph20 lambda p logft logSt logSt0
	quietly{
	gen double `p' = exp(`lnp')
	gen double `lambda' = exp(-`xb')
	gen double `ph1'=`p'*`lambda'
	gen double `ph2' = $ML_y1 * `lambda'
	gen double `ph20' = _t0 * `lambda'
	gen double `logft' = ln(`ph1') + ((`p'-1)*ln(`ph2'))-(`ph2'^`p')
	gen double `logSt' = -(`ph2')^`p'
	gen double `logSt0' = -(`ph20')^`p'
	replace `lnf'= (_d==1) * (`logft' - `logSt0') + (_d==0) * (`logSt' - `logSt0')
	}
end

streg coalition_phase globorg_dum cinc_disparity pcdum*, nocons dist(weib) time tech(bfgs) difficult
estimates store stataweib

ml model lf myweibull (xb:_t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp
ml search
ml maximize, nolog
estimates store mweib
mat mweib = e(b)

esttab stataweib mweib, star(* 0.10 ** 0.05 *** 0.01) aic se


// Log logit

cap program drop mylogl
program define mylogl
	version 14
	args lnf xb lnp
	tempvar p lambda phi1 phi2 phi20 St0 St ft
	quietly{
	gen double `p' = exp(-`lnp')
	gen double `lambda' = exp(-`xb')
	
	gen double `phi1' = `p' * `lambda'
	gen double `phi2' = $ML_y1 * `lambda'
	gen double `ft' = log(`phi1')+((`p'-1)*log(`phi2')) - 2*log(1+`phi2'^`p')
	gen double `St' = -log(1+`phi2'^`p')
	gen double `phi20' = _t0 * `lambda'
	gen double `St0' = -log(1+`phi20'^`p')
	replace `lnf'= (_d==1) * (`ft'-`St0') + (_d==0) * (`St'-`St0')
	}
end

streg coalition_phase globorg_dum cinc_disparity pcdum*, nocons dist(logl) time tech(bfgs) difficult
estimates store statalogl

ml model lf mylogl (xb:_t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons ) /lnp
ml search
ml maximize, nolog
estimates store mylogl
mat mylogl = e(b)

esttab statalogl mylogl, star(* 0.10 ** 0.05 *** 0.01) aic se


// Log normal

cap program drop mylogn
program define mylogn
	version 14
	args lnf xb lns
	tempvar sigma logft logSt logSt0
	quietly{
	gen double `sigma' = exp(`lns')
	gen double `logft' = ln(normalden((ln($ML_y1 ) - `xb')/`sigma')) - ln(`sigma'*$ML_y1 )
	gen double `logSt' = ln(normal(-(ln($ML_y1 ) - `xb')/`sigma' ))
	gen double `logSt0' = ln(normal(-(ln(_t0 ) - `xb')/`sigma' ))
	replace `logSt0' = 0 if _t0 == 0
	replace `lnf'= (_d==1) * (`logft' - `logSt0') + (_d==0) * (`logSt' - `logSt0')
	}
end

streg coalition_phase globorg_dum cinc_disparity pcdum*, nocons dist(logn) time tech(bfgs) difficult
estimates store statalogn

ml model lf mylogn (xb:_t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons ) /lns
ml search
ml maximize, nolog
estimates store mylogn
mat mylogn = e(b)

esttab statalogn mylogn, aic se ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	starlevels(* 0.10 ** 0.05 *** 0.01)




//-----------------------------------------------------------------//
//  Univariate models predicting coalition
//-----------------------------------------------------------------//

probit coalition_phase globorg_dum cinc_disparity_pcp neighbors_total_max
estimates store unip1
mat unip1 = e(b)


probit coalition_phase globorg_dum cinc_disparity_pcp neighbors_land_max
estimates store unip2
mat unip2 = e(b)

esttab unip*, ///
	star(* 0.10 ** 0.05 *** 0.01) aic se ///
	starlevels(* 0.10 ** 0.05 *** 0.01)


//-----------------------------------------------------------------//
//  Bivariate duration models
//-----------------------------------------------------------------//

// Log normal - probit

cap program drop lognprobit
program define lognprobit
    version 14
    args lnf xg xb lns athrho
    tempvar rho sigma logft FT FT0 uT uT0 llf1 llf0 Stc1 Stc0 lls1 lls0 s01 s00 St0c1 St0c0
qui{
	gen double `rho' = (exp(2 * `athrho')-1)/(exp(2 * `athrho')+1)
	gen double `sigma' = exp(`lns')
	gen double `logft' = ln(normalden((ln($ML_y2 ) - `xb')/`sigma')/(`sigma'*$ML_y2 ))
	gen double `FT' = min(1,max(4.84e-20, normal((ln( $ML_y2 ) - `xb')/`sigma') ))
	gen double `FT0' = min(1,max(4.84e-20, normal((ln( _t0 ) - `xb')/`sigma') ))
	gen double `uT' = -invnormal(max(`FT',4.84e-20))
	gen double `uT0' = -invnormal(max(`FT0',4.84e-20))

	// Pr(T=t, coal = 1) = Pr(T=t) * Pr(coal=1 | T=t)
	gen double `llf1' = `logft' + ln(min(1,max(4.84e-20, normal((`xg' - `rho'*`uT')/sqrt(1-`rho'^2)))))

	// Pr(T=t, coal = 0) = Pr(t=T) - Pr(t=T, coal = 1)
  	gen double `llf0' = ln(exp(`logft') - exp(`llf1'))
	
	// Pr(T>t, coal = 1)
	gen double `Stc1' = min(1,max(4.84e-20, binormal(`xg', `uT', `rho') ))
	gen double `lls1' = ln(`Stc1')

	// Pr(T>t, coal = 0) = Pr(T>t) - Pr(T>t, coal = 1)
	gen double `Stc0' = min(1,max(4.84e-20, 1-`FT' - `Stc1'))
	gen double `lls0' = ln(`Stc0')
	
	gen double `St0c1' = min(1,max(4.84e-20, binormal(`xg', `uT0', `rho') ))
	gen double `St0c0' = min(1,max(4.84e-20, 1-`FT0' - `St0c1'))	
	gen double `s01' = ln(`St0c1')
	gen double `s00' = ln(`St0c0')
	replace `s01' = 0 if _t0 == 0
	replace `s00' = 0 if _t0 == 0
	
	// log-likelihood
	replace `lnf' = `llf1' -`s01' if _d == 1 & $ML_y1 == 1
	replace `lnf' = `llf0' -`s00' if _d == 1 & $ML_y1 == 0
	replace `lnf' = `lls1' -`s01' if _d == 0 & $ML_y1 == 1
	replace `lnf' = `lls0' -`s00' if _d == 0 & $ML_y1 == 0
}
end


// Weibull

cap program drop weibprobit
program define weibprobit
    version 14
    args lnf xg xb lnp athrho
    tempvar rho logft p lambda ph1 ph2 ph20 FT FT0 uT uT0 llf1 llf0 Stc1 Stc0 lls1 lls0 s01 s00 St0c1 St0c0
qui{
	gen double `rho' = (exp(2 * `athrho')-1)/(exp(2 * `athrho')+1)
	gen double `p' = exp(`lnp')
	gen double `lambda' = exp(-`xb')
	gen double `ph1'=`p'*`lambda'
	gen double `ph2' = $ML_y2 * `lambda'
	gen double `ph20' = _t0 * `lambda'
	gen double `logft' = ln(`ph1') + ((`p'-1)*ln(`ph2'))-(`ph2'^`p')
	gen double `FT' = min(1,max(4.84e-20, 1-exp(-(`ph2'^`p') )))
	gen double `FT0' = min(1,max(4.84e-20, 1-exp(-(`ph20'^`p') )))
	gen double `uT' = -invnormal(max(`FT',4.84e-20))
	gen double `uT0' = -invnormal(max(`FT0',4.84e-20))

	// Pr(T=t, coal = 1) = Pr(T=t) * Pr(coal=1 | T=t)
	gen double `llf1' = `logft' + ln(min(1,max(4.84e-20, normal((`xg' - `rho'*`uT')/sqrt(1-`rho'^2)))))

	// Pr(T=t, coal = 0) = Pr(t=T) - Pr(t=T, coal = 1)
  	gen double `llf0' = ln(exp(`logft') - exp(`llf1'))
	
	// Pr(T>t, coal = 1)
	gen double `Stc1' = min(1,max(4.84e-20, binormal(`xg', `uT', `rho') ))
	gen double `lls1' = ln(`Stc1')

	// Pr(T>t, coal = 0) = Pr(T>t) - Pr(T>t, coal = 1)
	gen double `Stc0' = min(1,max(4.84e-20, 1-`FT' - `Stc1'))
	gen double `lls0' = ln(`Stc0')
	
	gen double `St0c1' = min(1,max(4.84e-20, binormal(`xg', `uT0', `rho') ))
	gen double `St0c0' = min(1,max(4.84e-20, 1-`FT0' - `St0c1'))	
	gen double `s01' = ln(`St0c1')
	gen double `s00' = ln(`St0c0')
	replace `s01' = 0 if _t0 == 0
	replace `s00' = 0 if _t0 == 0
	
	// log-likelihood
	replace `lnf' = `llf1' -`s01' if _d == 1 & $ML_y1 == 1
	replace `lnf' = `llf0' -`s00' if _d == 1 & $ML_y1 == 0
	replace `lnf' = `lls1' -`s01' if _d == 0 & $ML_y1 == 1
	replace `lnf' = `lls0' -`s00' if _d == 0 & $ML_y1 == 0
}
end

// Log logit

cap program drop loglprobit
program define loglprobit
    version 14
    args lnf xg xb lnp athrho
    tempvar rho logft p lambda ph1 ph2 ph20 FT FT0 uT uT0 llf1 llf0 Stc1 Stc0 lls1 lls0 s01 s00 St0c1 St0c0
qui{
	gen double `rho' = (exp(2 * `athrho')-1)/(exp(2 * `athrho')+1)
	gen double `p' = exp(-`lnp')
	gen double `lambda' = exp(-`xb')
	gen double `ph1' = `p' * `lambda'
	gen double `ph2' = $ML_y2 * `lambda'
	gen double `ph20' = _t0 * `lambda'
	gen double `logft' = log(`ph1')+((`p'-1)*log(`ph2')) - 2*log(1+`ph2'^`p')
	gen double `FT' = min(1,max(4.84e-20, 1-1/(1+`ph2'^`p') ))
	gen double `FT0' = min(1,max(4.84e-20, 1-1/(1+`ph20'^`p') ))
	gen double `uT' = -invnormal(max(`FT',4.84e-20))
	gen double `uT0' = -invnormal(max(`FT0',4.84e-20))

	// Pr(T=t, coal = 1) = Pr(T=t) * Pr(coal=1 | T=t)
	gen double `llf1' = `logft' + ln(min(1,max(4.84e-20, normal((`xg' - `rho'*`uT')/sqrt(1-`rho'^2)))))

	// Pr(T=t, coal = 0) = Pr(t=T) - Pr(t=T, coal = 1)
  	gen double `llf0' = ln(exp(`logft') - exp(`llf1'))
	
	// Pr(T>t, coal = 1)
	gen double `Stc1' = min(1,max(4.84e-20, binormal(`xg', `uT', `rho') ))
	gen double `lls1' = ln(`Stc1')

	// Pr(T>t, coal = 0) = Pr(T>t) - Pr(T>t, coal = 1)
	gen double `Stc0' = min(1,max(4.84e-20, 1-`FT' - `Stc1'))
	gen double `lls0' = ln(`Stc0')
	
	gen double `St0c1' = min(1,max(4.84e-20, binormal(`xg', `uT0', `rho') ))
	gen double `St0c0' = min(1,max(4.84e-20, 1-`FT0' - `St0c1'))	
	gen double `s01' = ln(`St0c1')
	gen double `s00' = ln(`St0c0')
	replace `s01' = 0 if _t0 == 0
	replace `s00' = 0 if _t0 == 0
	
	// log-likelihood
	replace `lnf' = `llf1' -`s01' if _d == 1 & $ML_y1 == 1
	replace `lnf' = `llf0' -`s00' if _d == 1 & $ML_y1 == 0
	replace `lnf' = `lls1' -`s01' if _d == 0 & $ML_y1 == 1
	replace `lnf' = `lls0' -`s00' if _d == 0 & $ML_y1 == 0
}
end

//-----------------------------------------------------------------//
//  Bivariate models assuming rho=0
//-----------------------------------------------------------------//

constraint 1 [athrho]_cons = 0

// Table 1, Model 1 (logn)

ml model lf lognprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase pcdum*, nocons) /lns /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lns, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m1j_logn
mat m1j_logn = e(b)

// Table 1, Model 1 (weibull)

* Estimate the univariate model to obtain initial values
ml model lf myweibull (xb:_t = coalition_phase pcdum*, nocons) /lnp
ml search
ml maximize, nolog
estimates store univw_m1
mat univw_m1 = e(b)
mat init_m1_weib = unip1, univw_m1, 0

* Estimate the bivariate model (assuming rho=0)
ml model lf weibprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

ml init init_m1_weib, skip
set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m1j_weib
mat m1_weib = e(b)



// Table 1, Model 1 (log logit)

ml model lf loglprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m1j_logl
mat m1j_logl = e(b)

esttab m1j_logn m1j_weib m1j_logl, se aic


// Table 1, Model 2 (logn)

ml model lf lognprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum pcdum*, nocons) /lns /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lns, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m2j_logn
mat m2j_logn = e(b)


// Table 1, Model 2 (weibull)

* Estimate the univariate model to obtain initial values
ml model lf myweibull (xb:_t = coalition_phase globorg_dum pcdum*, nocons) /lnp
ml search
ml maximize, nolog
estimates store univw_m2
mat univw_m2 = e(b)
mat init_m2_weib = unip1, univw_m2, 0

* Estimate the bivariate model (assuming rho=0)
ml model lf weibprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

ml init init_m2_weib, skip
set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m2j_weib
mat m2j_weib = e(b)


// Table 1, Model 2 (log logit)

ml model lf loglprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m2j_logl
mat m2j_logl = e(b)

esttab m2j_logn m2j_weib m2j_logl, se aic



// Table 1, Model 3 (logn)

ml model lf lognprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase cinc_disparity pcdum*, nocons) /lns /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lns, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m3j_logn
mat m3j_logn = e(b)


// Table 1, Model 3 (weibull)

ml model lf weibprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase cinc_disparity pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m3j_weib
mat m3j_weib = e(b)

// Table 1, Model 3 (log logit)

ml model lf loglprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase cinc_disparity pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m3j_logl
mat m3j_logl = e(b)

esttab m3j_logn m3j_weib m3j_logl, se aic




// Table 1, Model 4 (logn)

ml model lf lognprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lns /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lns, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m4j_logn
mat m4j_logn = e(b)


// Table 1, Model 4 (weibull)

ml model lf weibprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m4j_weib
mat m4j_weib = e(b)


// Table 1, Model 4 (log logit)

ml model lf loglprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) const(1)  ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m4j_logl
mat m4j_logl = e(b)

esttab m4j_logn m4j_weib m4j_logl, se aic





// Replicate Table 1 with the joint model assuming rho=0

esttab m1j_logn m2j_logn m3j_logn m4j_logn, se aic drop(pcdum*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	starlevels(* 0.10 ** 0.05 *** 0.01)

// Table 1 (reproduced for comparison)

esttab m1_logn m2_logn m3_logn m4_logn, se aic drop(pcdum*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	starlevels(* 0.10 ** 0.05 *** 0.01)




//-----------------------------------------------------------------//
//  Bivariate analyses (Table 2)
//-----------------------------------------------------------------//

// Table 2, Model 5 with lognormal

ml model lf lognprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lns /athrho ///
	, tech(bfgs) ///
	diparm(lns, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m5_logn


// Table 2, Model 5 with loglogit

ml model lf loglprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m5_logl


// Table 2, Model 5 with Weibull

* Estimate the univariate model to obtain initial values
ml model lf myweibull (xb:_t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp
ml search
ml maximize, nolog
estimates store univw_m5
mat univw_m5 = e(b)
mat init_m5_weib = unip1, univw_m5

* Estimate the bivariate model
ml model lf weibprobit ///
	(coalition_phase: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs) ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

ml init init_m5_weib
set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m5_weib


// Compare models
esttab m5_logn m5_logl m5_weib, se aic



// Table 2, Model 6 (land contiguity) with lognormal

ml model lf lognprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_land_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lns /athrho ///
	, tech(bfgs)   ///
	diparm(lns, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m6_logn


// Table 2, Model 6 (land contiguity) with loglogit

ml model lf loglprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_land_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs)   ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m6_logl


// Table 2, Model 6 (land contiguity) with weibull

* Estimate the univariate model to obtain initial values
mat init_m6_weib = unip2, univw_m5

ml model lf weibprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_land_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	, tech(bfgs)   ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

ml init init_m6_weib, skip
set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m6_weib

// Compare models
esttab m6_logn m6_logl m6_weib, se aic



// Table 2, Model 7 (dropping duration outliers) with lognormal

ml model lf lognprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lns /athrho ///
	if outliers_dur==0, tech(bfgs)   ///
	diparm(lns, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m7_logn


// Table 2, Model 7 (dropping duration outliers) with loglogit

ml model lf loglprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	if outliers_dur==0, tech(bfgs)   ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m7_logl

// Table 2, Model 7 (dropping duration outliers) with weibul

* Estimate the univariate model to obtain initial values
ml model lf myweibull (xb:_t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp if outliers_dur==0
ml search
ml maximize, nolog
estimates store univw_m7
mat univw_m7 = e(b)
mat init_m7_weib = unip1, univw_m7

* Estimate the bivariate model
ml model lf weibprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	if outliers_dur==0, tech(bfgs)   ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

ml init init_m7_weib, skip
set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m7_weib


// Compare models
esttab m7_logn m7_logl m7_weib, se aic




// Table 2, Model 8 (dropping coalition outliers) with lognormal

ml model lf lognprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lns /athrho ///
	if outliers_coal==0, tech(bfgs)   ///
	diparm(lns, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m8_logn

// Table 2, Model 8 (dropping coalition outliers) with loglogit

ml model lf loglprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	if outliers_coal==0, tech(bfgs)   ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m8_logl

// Table 2, Model 8 (dropping duration outliers) with weibul

* Estimate the univariate model to obtain initial values
ml model lf myweibull (xb:_t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp if outliers_coal==0
ml search
ml maximize, nolog
estimates store univw_m8
mat univw_m8 = e(b)
mat init_m8_weib = unip1, univw_m8

* Estimate the bivariate model
ml model lf weibprobit ///
	(xg: coalition_phase = globorg_dum cinc_disparity_pcp neighbors_total_max) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lnp /athrho ///
	if outliers_coal==0, tech(bfgs)   ///
	diparm(lnp, exp label(/sigma)) diparm(athrho, tanh label(/rho)) 

ml init init_m8_weib, skip
set seed 1234
ml search
set seed 1234
ml maximize, nolog difficult
estimates store m8_weib


// Compare models
esttab m8_logn m8_logl m8_weib, se aic



// Table 2
esttab m5_logn m6_logn m7_logn m8_logn, ///
	star(* 0.10 ** 0.05 *** 0.01) aic se drop(pcdum*) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	mtitles("Base" "Land" "Outlier1" "Outlier2")
	

// Export estimates for the main model

estimates restore m5_logn
mat beta = e(b)
mat varcov = e(V)

preserve
	drop _all
	svmat beta, names(eqcol)
	outsheet _all in 1 using "estimates/m5_logn_beta.txt", replace nolabel
restore

preserve
	drop _all
	svmat varcov, names(eqcol)
	outsheet _all in 1/39 using "estimates/m5_logn_vcov.txt", replace nolabel
restore


// Export estimates for the independent model

estimates restore m4j_logn
mat beta = e(b)
mat varcov = e(V)

preserve
	drop _all
	svmat beta, names(eqcol)
	outsheet _all in 1 using "estimates/m4j_logn_beta.txt", replace nolabel
restore

preserve
	drop _all
	svmat varcov, names(eqcol)
	outsheet _all in 1/39 using "estimates/m4j_logn_vcov.txt", replace nolabel
restore

// Export estimates for univariate model

estimates restore m4_logn
mat beta = e(b)
mat varcov = e(V)

preserve
	drop _all
	svmat beta, names(eqcol)
	outsheet _all in 1 using "estimates/m4_logn_beta.txt", replace nolabel
restore

preserve
	drop _all
	svmat varcov, names(eqcol)
	outsheet _all in 1/34 using "estimates/m4_logn_vcov.txt", replace nolabel
restore


// Export estimates for land neighbors model

estimates restore m6_logn
mat beta = e(b)
mat varcov = e(V)

preserve
	drop _all
	svmat beta, names(eqcol)
	outsheet _all in 1 using "estimates/m6_logn_beta.txt", replace nolabel
restore

preserve
	drop _all
	svmat varcov, names(eqcol)
	outsheet _all in 1/39 using "estimates/m6_logn_vcov.txt", replace nolabel
restore


// Export estimates for the outlier model (duration)

estimates restore m7_logn
mat beta = e(b)
mat varcov = e(V)

preserve
	drop _all
	svmat beta, names(eqcol)
	outsheet _all in 1 using "estimates/m7_logn_beta.txt", replace nolabel
restore

preserve
	drop _all
	svmat varcov, names(eqcol)
	outsheet _all in 1/39 using "estimates/m7_logn_vcov.txt", replace nolabel
restore


// Export estimates for the outlier model (coalition)

estimates restore m8_logn
mat beta = e(b)
mat varcov = e(V)

preserve
	drop _all
	svmat beta, names(eqcol)
	outsheet _all in 1 using "estimates/m8_logn_beta.txt", replace nolabel
restore

preserve
	drop _all
	svmat varcov, names(eqcol)
	outsheet _all in 1/39 using "estimates/m8_logn_vcov.txt", replace nolabel
restore


//-----------------------------------------------------------------//
//  Robustness checks: coalition size
//-----------------------------------------------------------------//

// Baseline model
streg coalition_phase globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
estimates store base

tab coalsize
tab coalsize coalition

// Coalition size for phases

gen coalsize_phase = coalsize
replace coalsize_phase = 1 if coalition_phase == 0

tab coalsize coalition_phase
tab coalsize_phase coalition_phase

streg coalsize_phase globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
estimates store coalsize

// Coalition size as categorical variable
tab coalsize_phase, gen(coalsize_dum)
sum coalsize_dum*

streg coalsize_dum2 coalsize_dum3 coalsize_dum4 coalsize_dum5 coalsize_dum6 ///
	globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
estimates store coalsizedum


// Log(Coalition size)

gen coalsize_phase_log = ln(coalsize_phase)

streg coalsize_phase_log globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
estimates store coalsizelog

esttab coalsize coalsizedum coalsizelog, se aic drop(pcdum*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	starlevels(* 0.10 ** 0.05 *** 0.01)

// Export estimates
estimates restore coalsizelog
mat beta = e(b)
mat varcov = e(V)

preserve
	drop _all
	svmat beta, names(eqcol)
	outsheet _all in 1 using "estimates/m10_coalsize_beta.txt", replace nolabel
restore

preserve
	drop _all
	svmat varcov, names(eqcol)
	outsheet _all in 1/34 using "estimates/m10_coalsize_vcov.txt", replace nolabel
restore


//-----------------------------------------------------------------//
//  Robustness checks: major power
//-----------------------------------------------------------------//


// Major power coalitions

replace max_majoronly1_side = 0 if coalition_phase == 0
replace min_majoronly1_side = 0 if coalition_phase == 0

tab max_majoronly1_side
tab min_majoronly1_side

tab max_majoronly1_side min_majoronly1_side
tab max_majoronly1_side coalition_phase

streg max_majoronly1_side coalition_phase globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
estimates store major1

gen other_coal = max_majoronly1_side == 0 & coalition_phase == 1
gen other_coal_min = min_majoronly1_side == 0 & coalition_phase == 1

tab max_majoronly1_side other_coal
tab other_coal coalition_phase
tab min_majoronly1_side other_coal_min

// Only 1 major on either side
streg max_majoronly1_side other_coal globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
estimates store major2

// Only 1 major on both sides
streg min_majoronly1_side other_coal_min globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
estimates store major3

esttab major1 major2 major3, star(* 0.10 ** 0.05 *** 0.01) ///
	aic se drop(pcdum*)

// Both major, major vs minor, at least 1 major
replace major_major_cris = 0 if coalition_phase == 0
tab major_major_cris coalition_phase

replace major_minor_cris = 0 if coalition_phase == 0
tab major_minor_cris coalition_phase

replace majorcoal_cris = 0 if coalition_phase == 0
tab majorcoal_cris coalition_phase

gen other_coal_majcoal = majorcoal_cris == 0 & coalition_phase == 1
tab majorcoal_cris other_coal_majcoal

streg majorcoal_cris other_coal_majcoal globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
estimates store major4
	
esttab major2 major3 major4, star(* 0.10 ** 0.05 *** 0.01) ///
	aic se  mtitles("Only1Maj(max)" "Only1Maj(min)" "Atleast1") ///
	drop(pcdum*)

	
// Robustness models

esttab base coalsizelog major2, star(* 0.10 ** 0.05 *** 0.01) ///
	aic se  mtitles("Baseline" "Size" "Only1Maj(max)") ///
	order(coalition_phase coalsize_phase_log max_majoronly1_side other_coal) ///
	drop(pcdum*)



//-----------------------------------------------------------------//
// Dyad-year data (sample selection)
//-----------------------------------------------------------------//

use "coalition_dyadyear.dta", clear

stset end, id(crisno) failure(failure) time0(start) origin(start)

// First stage

probit crisis cinc_disp lnccdist contiguity s_un_glo peaceyrs*
estimates store m1cc

probit crisis cinc_disp lnmidist contiguity s_un_glo peaceyrs*
estimates store m1mi

esttab m1cc m1mi, aic se

// Second stage

streg coalition_phase globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
estimates store d1

preserve
keep if crisis == 1
streg coalition_phase globorg_dum cinc_disparity pcdum*, ///
	nocons dist(logn) time tech(bfgs) difficult
restore

estimates store d2

esttab d1 d2, aic se



// Duration with selection

recode coalition_phase (.=0) if crisis == 0
recode globorg_dum (.=0) if crisis == 0
recode cinc_disparity (.=0) if crisis == 0
recode _t (.=0) if crisis == 0
//recode _t0 (.=0) if crisis == 0

forvalues i = 1(1)30{
	recode pcdum`i' (.=0)
}

cap program drop lognsel
program define lognsel
    version 14
    args lnf xg xb lns athrho
    tempvar rho sigma logft FT FT0 uT uT0 ll1 Stc1 St0c1 sc1 sc0 s01 lxg0 lxg1
qui{
	gen double `rho' = (exp(2 * `athrho')-1)/(exp(2 * `athrho')+1)
	gen double `sigma' = exp(`lns')
	gen double `logft' = ln(normalden((ln($ML_y2 ) - `xb')/`sigma')/(`sigma'*$ML_y2 ))
	gen double `FT' = min(1,max(4.84e-20, normal((ln( $ML_y2 ) - `xb')/`sigma') ))
	gen double `FT0' = min(1,max(4.84e-20, normal((ln( _t0 ) - `xb')/`sigma') ))
	gen double `uT' = -invnormal(max(`FT',4.84e-20))
	gen double `uT0' = -invnormal(max(`FT0',4.84e-20))
	
	// Pr(T=t, sel = 1)
	gen double `ll1' = `logft' + ln(min(1,max(4.84e-20, normal((`xg' - `rho'*`uT')/sqrt(1-`rho'^2)))))

	// Pr(T>t, sel = 1)
	gen double `Stc1' = min(1,max(4.84e-20, binormal(`xg',`uT', `rho')))
	
	// Pr(T>t0, coal = 1) = Pr(coal = 1) - Pr(T<t0, coal = 1)
	gen double `St0c1' = min(1,max(4.84e-20, binormal(`xg', `uT0', `rho')))

	// log-likelihood
	gen double `sc1' = ln(`Stc1')
	gen double `s01' = ln(`St0c1')
	replace `s01' = 0 if _t0 == 0
	
	gen double `lxg1' = ln(normal(`xg'))
	gen double `lxg0' = ln(normal(-`xg'))
	
	replace `lnf' = `lxg0' if $ML_y1 == 0
 	replace `lnf' = `lxg1' + `ll1' - `s01' if _d == 1
 	replace `lnf' = `lxg1' + `sc1' - `s01' if _d == 0
	}
end



// Selection model

ml model lf lognsel ///
	(xg: crisis = cinc_disp lnccdist contiguity s_un_glo peaceyrs*) ///
	(xb: _t = coalition_phase globorg_dum cinc_disparity pcdum*, nocons) /lns /athrho ///
	, tech(bfgs) diparm(athrho, tanh label(/rho))

set seed 1234
ml search
set seed 1234
dis c(current_time)
ml maximize, nolog difficult
dis c(current_time)
estimates store lognselfe

esttab lognselfe, se aic ///
	star(* 0.10 ** 0.05 *** 0.01) drop(pcdum*) ///
	starlevels(* 0.10 ** 0.05 *** 0.01)


log close
exit

