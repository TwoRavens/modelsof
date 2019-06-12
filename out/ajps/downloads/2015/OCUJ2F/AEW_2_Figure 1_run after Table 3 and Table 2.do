/* TWO STEPS: 1) RUN AFTER DO-FILE: "AEW_1_Table 3 and Table 2" 
              2) REQUIRES ESTSIMP COMMAND, IF YOU HAVE NOT DOWNLOADED IT PREVIOUSLY,
			  TYPE COMMAND "findit estsimp" BEFORE RUNNING THIS DO-FILE. */ 

set more off

// investigate the range of pmposition_ch_all

qui regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)
sum pmposition_ch_all if e(sample)==1

// We will simulate coefficients, which will be named b0-b6, so we need to preemptively drop them
cap drop b1-b6

estsimp regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)

// generate variables to store the estimates

gen xaxis_pmp = .

gen pred_dparty_0_lb = .
gen pred_dparty_0_m  = .
gen pred_dparty_0_ub = .

gen pred_dparty_1_lb = .
gen pred_dparty_1_m  = .
gen pred_dparty_1_ub = .

// Loop over the range of pmposition_ch_all

local i = 1
forvalues this_pmp = -1(.1)1 {

	// axis
	replace xaxis_pmp = `this_pmp' in `i'

	// for the case with ingovt = 0

	setx mean
	setx ingovt 0
	setx ingovtxpmposition_ch_all 0
	setx pmposition_ch_all `this_pmp'

	cap drop pred_dparty
	simqi, ev genev(pred_dparty)
	qui sum pred_dparty

	replace pred_dparty_0_m = `r(mean)' in `i'
	qui _pctile pred_dparty, p(8, 92)
	replace pred_dparty_0_lb = `r(r1)' in `i'
	replace pred_dparty_0_ub = `r(r2)' in `i'

	// for the casewith ingovt = 1
	setx mean
	setx ingovt 1
	setx ingovtxpmposition_ch_all `this_pmp'
	setx pmposition_ch_all `this_pmp'

	cap drop pred_dparty
	simqi, ev genev(pred_dparty)
	qui sum pred_dparty

	replace pred_dparty_1_m = `r(mean)' in `i'
	qui _pctile pred_dparty, p(8, 92)
	replace pred_dparty_1_lb = `r(r1)' in `i'
	replace pred_dparty_1_ub = `r(r2)' in `i'
	
	local i = `i' + 1
}


list pred_dparty* in 1/21

// plot them

set scheme s1mono

 twoway (rarea pred_dparty_1_lb pred_dparty_1_ub xaxis_pmp) ///
 (rarea pred_dparty_0_lb pred_dparty_0_ub xaxis_pmp ) ///
 (line pred_dparty_0_m xaxis_pmp, lpattern("-"))  ///
 (line pred_dparty_1_m xaxis_pmp, lpattern("black")), ///
 legend(off) ytitle("Party j's perceived shift") xtitle("PM party's perceived shift")






