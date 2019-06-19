// This program runs the Basic Analysis in section V.
// Input data set: "Data\Base.dta"
// Output log file: "logs\Basic_Analysis.txt"
// Subsidiary code: "Basic_Analysis_Init_Search.do"
// Adapt working directory in the code.
// August 10 2010.

clear
set more off
program drop _all
set memory 1000m

do "Basic_Analysis_Init_Search.do"

/* Estimation Data Preparation */

use Data\Base.dta

global expvar
foreach tempvar of varlist slope_r - DCnty12 {
	global expvar $expvar `tempvar'
}

foreach tempvar in qq $expvar {
	rename `tempvar' o_`tempvar'
}

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

	sort county township_id section_id q qq
	merge county township_id section_id q qq using Data\Base

	foreach tempvar in qq $expvar {
		rename `tempvar' `type'_`tempvar'
	}
	drop if _merge != 3
	drop _merge
}

sort county section_id q o_qq

/* Estimation */

/* Initialize Variables */

foreach tempvar in $expvar {
	quietly gen double x_`tempvar' = 0
}

foreach var in $expvar {
	quietly gen double gamA_`var' = a1_`var'+a2_`var'
}


/* NLE program */

program nlscaleag
	version 8.0

	if "`1'"=="?" {
		global S_1 "gamA gamB"
		global gamA= $InitGamA
		global gamB= $InitGamB
		exit
	}
 
	foreach var in $expvar {
		quietly replace x_`var' = (1 - 2*$gamA -$gamB)*o_`var' + $gamA*gamA_`var'+ $gamB*b_`var'
	}

	quietly {
		regress crop_$cropnum x_*, noconstant /* We run regression without constant term because we have full county dummies */
		predict double temp, xb
		replace `1' = temp
		drop temp
	}
end

global croplist
foreach tempvar of varlist crop* {
	local var2 = substr("`tempvar'",6,.)	
	global croplist $croplist `var2'
}

capture log close
log using logs\Basic_Analysis.txt, text replace

display "$expvar"

display "Crop List: $croplist"

foreach cropnumloc in $croplist {

	display "==============="
	display "Crop `cropnumloc'"
	display "==============="

	global cropnum `cropnumloc'

	init_search

	nl scaleag crop_$cropnum, trace

	/* Construct GNR variables */

	/* Residual */
	qui regress crop_$cropnum x_*, noconstant
	predict double resid, residuals

	/* Derivative of f w.r.t. gam1 and gamA */

	gen double g2 = 0
	gen double g4 = 0

	mat a = e(b)
	foreach var in $expvar {
		mat temp = a["y1","x_`var'"]
		qui replace g2 = g2 + (gamA_`var' - 2*o_`var')*temp[1,1]
		qui replace g4 = g4 + (b_`var' - o_`var')*temp[1,1] 
	}
/*
	display "==============="
	display " Not clustered "
	display "==============="
	regress resid g2 g4 x_*, noconstant

	display "================"
	display " Clustered at q "
	display "================"
	regress resid g2 g4 x_*, noconstant cluster(q) // http://www.stata.com/support/faqs/stat/cluster.html
	
	display "======================="
	display " Clustered at section "
	display "======================="
	regress resid g2 g4 x_*, noconstant cluster(section_id) 

	display "======================="
	display " Clustered at township "
	display "======================="
	regress resid g2 g4 x_*, noconstant cluster(township_id) 
*/

	display "======================="
	display " Clustered at county "
	display "======================="
	regress resid g2 g4 x_*, noconstant cluster(county) 

	mat variance = e(V)
	mat variance = variance[1..2,1..2]
	mat list variance
	
	drop g2 g4 resid

	}

log close





