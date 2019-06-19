// This program runs the county administrator analysis.
// Input data: base.dta, county_admin.dta
// Log file: logs\County_Admin_Analysis.txt
// Subsidiary code: Extended_Analysis_Init_Search.do

// June 22 2010. I re-programmed the non-linear program and verified the estimates. The estimates confirmed. I also fixed the standard errors.
// Need to implement the Polytope method.

* June 20 2010: cluster standard errors by county.
* Oct 6 2008.

capture: log close

clear
set more off
program drop _all
set memory 1400m

do "Restat_Extended_Analysis_Init_Search.do"

/* Estimation Data Preparation */

use Data\Base.dta

/* Merge County Admin Info */
sort county section_id q qq
merge county section_id q qq using data\county_admin.dta, nokeep
drop _merge

sort county section_id q qq

tempfile base_fsa
save `base_fsa'

global expvar
foreach tempvar of varlist slope_r - county_admin {
	global expvar $expvar `tempvar'
}

foreach tempvar of varlist _all {
	rename `tempvar' o_`tempvar'
}

rename o_county county
rename o_section_id section_id
rename o_q q


gen a1_qq = 2 if o_qq == 1
replace a1_qq = 4 if o_qq == 2
replace a1_qq = 1 if o_qq == 3
replace a1_qq = 3 if o_qq == 4

gen a2_qq = 3 if o_qq == 1
replace a2_qq = 1 if o_qq == 2
replace a2_qq = 4 if o_qq == 3
replace a2_qq = 2 if o_qq == 4

gen b_qq = 4 if o_qq == 1
replace b_qq = 3 if o_qq == 2
replace b_qq = 2 if o_qq == 3
replace b_qq = 1 if o_qq == 4

foreach type in a1 a2 b {

	rename `type'_qq qq

	sort county section_id q qq
	merge county section_id q qq using `base_fsa'

	foreach tempvar in qq $expvar {
		rename `tempvar' `type'_`tempvar'
	}
	drop crop*
	drop if _merge != 3
	drop _merge
}

sort county section_id q o_qq

foreach x in a1 a2 b {
	gen D_`x' = 0
	replace D_`x' = 1 if o_county_admin != `x'_county_admin
}


global expvar
foreach tempvar of varlist o_slope_r - o_DCnty12 {
	local var2 = substr("`tempvar'",3,.)
	global expvar $expvar `var2'
}

renpfix o_crop crop

global croplist
foreach tempvar of varlist crop* {
	local var2 = substr("`tempvar'",6,.)	
	global croplist $croplist `var2'
}

sort county section_id q o_qq

/* Estimation */

/* Initialize Variables */

foreach tempvar in $expvar {
	quietly gen double x_`tempvar' = 0
}

log using logs\County_Admin_Analysis.txt, replace text

/* NLE program */

capture program drop nlscaleagP
program nlscaleagP
	version 10.1
	syntax varlist (min = 1 max = 1) if, at(name)
	
	local pred: word 1 of `varlist'

	tempname gamA gamB gamD temp
	
	scalar `gamA' = `at'[1,1]
	scalar `gamB' = `at'[1,2]
	scalar `gamD' = `at'[1,3]

	foreach var in $expvar {
		quietly replace x_`var' = (1 - 2*`gamA' -`gamB')*o_`var' + ///
		`gamA'*((1-D_a1) + `gamD'*D_a1)*a1_`var' + `gamA'*((1-D_a2) + `gamD'*D_a2)*a2_`var' + ///
		`gamB'*((1-D_b) + `gamD'*D_b)*b_`var'
	}
		
	quietly {
		regress crop_$cropnum x_* , noconstant /* We run regression without constant term because we have full county dummies */
		predict double `temp', xb
		replace `pred' = `temp'
	}
end


display "$expvar"

display "Crop List: $croplist"

foreach cropnumloc in $croplist {

	display "==============="
	display "Crop `cropnumloc'"
	display "==============="

	global cropnum `cropnumloc'

	init_search
	mat ivalsP = ($InitGamA, $InitGamB, $InitGamD)
	nl scaleagP @ crop_$cropnum, parameters(gamA gamB gamD) initial(ivalsP)
	
	mat b=e(b)
	global gamA b[1,1]
	global gamB b[1,2]
	global gamD b[1,3]

	/* Construct GNR variables */

	/* Residual */
	qui regress crop_$cropnum x_*, noconstant
	predict double resid, residuals

	/* Derivative of f w.r.t. gam1 and gamA */

	gen double gA = 0
	gen double gB = 0
	gen double gD = 0

	mat a = e(b)
	foreach var in $expvar {
		mat temp = a["y1","x_`var'"]
		qui replace gA = gA + (-2*o_`var' + ((1-D_a1) + $gamD*D_a1)*a1_`var' + ((1-D_a2) + $gamD*D_a2)*a2_`var' )*temp[1,1]
		qui replace gB = gB + (-o_`var'+ ((1-D_b) + $gamD*D_b)*b_`var')*temp[1,1]
		qui replace gD = gD + ($gamA*D_a1*a1_`var' + $gamA*D_a2*a2_`var' + $gamB*D_b*b_`var')*temp[1,1]
 	}

	regress resid gA gB gD x_*, noconstant cluster(county)

	mat variance = e(V)
	mat variance = variance[1..2,1..2]
	mat list variance

	drop gA gB gD resid

	}

log close





