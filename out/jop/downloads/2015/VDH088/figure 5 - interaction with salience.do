set more off

*** read data ***

use "reassessments", clear
merge m:m swis_code year using "switchers"
drop _m
merge m:m muni_name county_name year using "census demographics"
drop _m

keep if year > 1986 & year < 2012

*** recode for interpretation ***

gen elected = 1-D
replace reass = reass * 100

gen salience = pct65plus1990
gen electedXsalience = elected*salience

*** do the graphs ***

xi: areg reass elected electedXsalience i.year, a(swis_code) cl(swis_code)
mat V = e(V)

gen index = _n
gen B = .
gen SE = .

forvalues j = 5(1)30 {

	local i = `j'
	replace B = _b[elected] + `i'*_b[electedXsalience] if index == `j'
	replace SE = sqrt((V[1,1]) + (`i'^2)*(V[2,2]) + `i'*2*(V[2,1])) if index == `j'
	

}

gen UB = B + 1.96*SE
gen LB = B - 1.96*SE

keep if !mi(B)

#delimit;

gr tw
	(line UB LB index, lcol(black black) lpat(shortdash shortdash))
	(line B index, col(black) lwid(thick) lpat(solid))
	scatteri 0 5 0 30, c(l) m(i) col(black) lpat(solid) lwid(thin)
	,
		legend(off)
		plotregion(style(none))
		yline(0)
		ytitle("Effect of elected assessor")
		xtitle("Percent 65 and older")
		ylab(-20(10)30, angle(horiz))
		;

#delimit cr

gr export "figure 5.eps", replace

