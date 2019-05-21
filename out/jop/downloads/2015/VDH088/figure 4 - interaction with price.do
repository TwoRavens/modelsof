set more off

*** read data ***

set more off

use "reassessments", clear
merge m:m swis_code year using "switchers"
drop _m
merge m:m swis_code year using "salesweb"
keep if _m == 3
drop _m

*** recode for interpretation ***

gen elected = 1-D
replace rar = rar*100

*** do the plots ***

su lprice if !mi(rar), det
local mymin = log(10000)
local mymax = log(1000000)
local mymed = log(100000)
local emin = string(exp(`mymin'), "%9.2gc")
local emax = string(exp(`mymax'), "%9.2gc")
local emed = string(exp(`mymed'), "%9.2gc")

xi: areg rar elected##c.lprice i.year, a(swis_code) cl(swis_code)

margins, dydx(elected) at(lprice = (`mymin'(.5)`mymax'))

#delimit;

marginsplot,
	
	plotregion(style(none))
	plotopts(
		col(black) lwid(thick)
		
	)
	ciopts(lpat(shortdash shortdash) lcol(black black))
	recastci(rline)
	recast(line)
	title("`mytitle'")
	ytitle("Effect of elected assessor")
	xtitle("Home value")

	addplot(
		scatteri 0 `mymin' 0 `mymax', c(l) m(i) col(black) lpat(solid) lwid(thin)
		xlab(
			`mymin' "10,000"
			`mymed' "100,000"
			`mymax' "1 million"
			
		)
		ylab(, angle(horiz))
	)

	legend(off)
	;

#delimit cr
	
gr export "figure 4.eps", replace


