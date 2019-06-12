set more off

use dataset, clear

*** make interactions ***

foreach x in f3overridep f1overridep f2overridep l1overridep l2overridep l3overridep overridep {
	su `x'
	gen demincumbentX`x' = demincumbent*`x'
	replace `x' = demincumbentX`x'
}

*** do the regressions ***

keep if !mi(demvoteshare) & !mi(demincumbentXoverridep)
tabulate year, gen(year_)

eststo clear

eststo: xi: reg demvoteshare lagdemvoteshare f3overridep f2overridep f1overridep overridep l1overridep l2overridep l3overridep year_* [aw=totalvotes], cl(town) 

mat B = e(b)
mat V = e(V)

gen index = _n
gen B = .
gen UB = .
gen LB = .

forvalues i = 1(1)7 {
	local j = `i' + 1
	replace B = B[1,`j'] if index == `i'
	replace UB = B[1,`j'] + 1.96*sqrt(V[`j',`j']) if index == `i'
	replace LB = B[1,`j'] - 1.96*sqrt(V[`j',`j']) if index == `i'
}
keep if !mi(B)

replace index = index - 4

#delimit;

gr tw 
	(rspike UB LB index, col(black) lwid(thick))
	(sc B index if index >=0, msym(O) col(black) msize(vlarge))
	(sc B index if index < 0, mfcol(white) msym(O) col(black) msize(vlarge))

	,
		legend(off)
		yline(0, lcol(black) lpat(dash))
		plotregion(style(none))
		ylab(, angle(horiz))
		ytitle("Effect on Democratic voteshare")
		xtitle("Year relative to tax increase taking effect (t)")
		xlab(
			-3 "t-3"
			-2 "t-2"
			-1 "t-1"
			0 "t"
			1 "t+1"
			2 "t+2"
			3 "t+3"
		)
		;
		
#delimit cr

gr export "figure 2.eps", replace
