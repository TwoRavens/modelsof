// Runs the basic analysis by counties.
// Input data: Base.dta
// Output log file: Basic_Analysis_By_County

// We will calculate the Theta for each county and calculate average Theta and its variance
// across counties. Thus, we need not worry about the standard errors for the point estimates in the first stage.
// Since we do not use any county dummies, we add a constant term in the regression.
// August 10 2010.


clear
set more off
program drop _all
set memory 1000m

/* Estimation Data Preparation */

use Data\Base.dta

drop DCnty*

global expvar
foreach tempvar of varlist slope_r - lat_long {
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

	sort county section_id q qq
	merge county section_id q qq using Data\Base.dta, sort

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

tempfile estimation_base
save `estimation_base'

/* NLE program */

program nlscaleag
	version 8.0

	if "`1'"=="?" {
		global S_1 "gamA gamB"
		global gamA= 0.15
		global gamB= 0.1
		exit
	}

	foreach var in $expvar {
		quietly replace x_`var' = (1 - 2*$gamA -$gamB)*o_`var' + $gamA*gamA_`var'+ $gamB*b_`var'
	}

	quietly {
		regress crop_$cropnum x_*
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

log using logs\Basic_Analysis_By_County.txt, text replace

display "$expvar"

display "Crop List: $croplist"

foreach county in 017 019 035 063 067 071 073 077 081 091 097 099 {

	use if county == "`county'" using `estimation_base', replace

	foreach cropnumloc in $croplist {

		display "====================="
		display "Crop `cropnumloc' in County `county'"
		display "====================="

		global cropnum `cropnumloc'

		nl scaleag crop_$cropnum

		/* Construct GNR variables */

		/* Residual */
		qui regress crop_$cropnum x_*
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

		regress resid g2 g4 x_*

		mat variance = e(V)
		mat variance = variance[1..2,1..2]
		mat list variance

		drop g2 g4 resid

		}

	}


log close





