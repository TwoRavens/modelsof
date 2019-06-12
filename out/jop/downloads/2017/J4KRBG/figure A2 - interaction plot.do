set more off

use dataset, clear

*** define covariates ***

local X1 totalrevownsourcespcp pcttotaltax pcttotalig
local X2 lpopulation popdensity incomepcp pctba pct65plus
local X3 crimepcp totalpolicepcp dem ngovspcp netmigration H pcthisp herf pctforeign

local X `X1' `X2' `X3'

replace pctblackgov = log(pctblackgov + 1)
label variable pctblackgov "Non-white council member"

*** rescale ***

foreach x in `X' pctblackgov {
	su `x'
	replace `x' = (`x' - r(min)) / (r(max) - r(min))
}

*** interactions ***

gen pctblackXpctblackgov = pctblack*pctblackgov
gen pctblackXanyblackgov = pctblack*anyblackgov

*** regressions ***

gen index = _n
local nboot 500
forvalues k = 0(20)100 {
	gen B`k' = .
	gen Bm`k' = .
	di `k'
	forvalues i = 1(1)`nboot' {
		qui{
		preserve
			* point estimate
			reg lfinesandforfeitspcp pctblack anyblackgov pctblackXanyblackgov, robust
			local y11 = _b[_cons] + log(`k'+1)*_b[pctblack] + _b[anyblackgov] + log(`k'+1)*_b[pctblackXanyblackgov]
			local y10 = _b[_cons] + log(`k'+1)*_b[pctblack] 
			local Bm = exp(`y11')-exp(`y10')			
			* standard errors
			bsample
			reg lfinesandforfeitspcp pctblack anyblackgov pctblackXanyblackgov, robust
			local y11 = _b[_cons] + log(`k'+1)*_b[pctblack] + _b[anyblackgov] + log(`k'+1)*_b[pctblackXanyblackgov]
			local y10 = _b[_cons] + log(`k'+1)*_b[pctblack] 
			local B = exp(`y11')-exp(`y10')
		restore
		replace B`k' = `B' if index == `i'
		replace Bm`k' = `Bm' if index == `i'
		}
		
	}
}	

keep B* index
drop if mi(B0)
reshape i index
reshape j pctblack
reshape xij Bm B
reshape xi
reshape long

collapse Bm B (p5) LB = B (p95) UB = B, by(pctblack)

#delimit;

gr tw
	(line Bm pctblack, col(black) lwid(thick))
	(line UB LB pctblack, col(black black) lpat(dash dash))
	,
		yline(0, lpat(solid) lwid(thin) lcol(black))
		legend(off)
		ylab(, angle(horiz))
		plotregion(style(none))
		xtitle("Percent black population")
		l2title("Effect of any black council")
		l1title("on revenue from fines")
		;

#delimit cr

gr export "figureA2.eps", replace
shell epstopdf figureA2.eps
