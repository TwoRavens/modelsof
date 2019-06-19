// Generate the fitted values.
// Input: Base.dta, the parameter estimates from the Basic Analysis.
// Output: fitted.dta contains fitted value for crop planting and soil by each crop and QQ.

clear
set more off
program drop _all
set memory 1000m

/* Estimation Data Preparation */

use Base.dta 

global soilvarlist
foreach tempvar of varlist slope_r - DCnty12 {
	global soilvarlist $soilvarlist `tempvar'
}

foreach tempvar in qq $soilvarlist {
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
	merge county section_id q qq using Base

	foreach tempvar in qq $soilvarlist {
		rename `tempvar' `type'_`tempvar'
	}
	drop if _merge != 3
	drop _merge
}

sort county section_id q o_qq


foreach var in $soilvarlist {
	quietly gen double x_`var' = 0
}

program drop _all
program fitted

	syntax ,cropnum(integer) gamA(real) gamB(real)

	foreach var in $soilvarlist {
		quietly replace x_`var' = (1 - 2*`gamA' -`gamB')*o_`var' + `gamA'*(a1_`var'+a2_`var') + `gamB'*b_`var'
	}

	qui regress crop_`cropnum' x_*, noconstant
	predict double yhat_`cropnum', xb    /* Fitted values with actual technology */

	foreach var in $soilvarlist {
		quietly replace x_`var' = o_`var' 
	}

	predict double xhat_`cropnum', xb  /* Fitted values with scale economy parameters set to zero */

end

fitted, cropnum(1) gamA(0.1985007) gamB(0.1439744)
fitted, cropnum(5) gamA(0.1365653) gamB(0.0943818)
fitted, cropnum(6) gamA(0.147377) gamB(0.092651)
fitted, cropnum(21) gamA(0.0951754) gamB(0.0527978)
fitted, cropnum(22) gamA(0.1154042) gamB(0.0477392)
fitted, cropnum(23) gamA(0.1277028) gamB(0.0866451)
fitted, cropnum(25) gamA(0.1834708) gamB(0.1144236)
fitted, cropnum(31) gamA(0.1428998) gamB(0.1118814)
fitted, cropnum(41) gamA(0.2248934) gamB(0.1842192)
fitted, cropnum(42) gamA(0.1806497) gamB(0.1091434)
fitted, cropnum(43) gamA(0.2360745) gamB(0.2044914)
fitted, cropnum(44) gamA(0.1120224) gamB(0.0703382)

rename o_qq qq
keep county section_id q qq crop* xhat* yhat*
sort county section_id q qq
order county section_id q qq crop* yhat* xhat* 
save fitted.dta

