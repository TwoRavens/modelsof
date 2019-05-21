set more off

*** read data ***

use "switchers", clear

merge m:m swis_code year using "reassessments"
keep if _m == 3
drop _m

merge m:m swis_code year using "salesweb"
keep if _m == 3
drop _m

*** do the graph ***

gen y = rar

xtile bin = sale_price, n(5)


su sale_price if bin == 1
local bin1range = "$" + string(`r(min)', "%20.0fc") + " - $" + string(`r(max)', "%20.0fc")
su sale_price if bin == 5
local bin5range = "$" + string(`r(min)', "%20.0fc") + " - $" + string(`r(max)', "%20.0fc")

keep if lag < 10


replace y = y*100

collapse y (semean) se=y, by(bin lag)

gen ub = y+1.96*se
gen lb = y-1.96*se



#delimit;
gr tw
	(line ub lb lag if bin == 1, lcol(black black) lpat(shortdash shortdash) lwid(thin thin))
	(line y lag if bin == 1, col(black) lpat(solid) lwid(thick))

	(line ub lb lag if bin == 5, lcol(black black) lpat(dot dot)  )
	(line y lag if bin == 5, col(black) lpat(dash) lwid(thick))

	,
		legend(off)
		xtitle("Years since reassessment")

		ytitle("Effective tax rate")
		ylab(, angle(horiz) format(%2.0f))
		xlab(0(1)9)
		
		text(90 6 "Least expensive homes")
		text(65 6.6 "Most expensive homes")
		
		scheme(s1manual)
		plotregion(style(none))
		;
#delimit cr

gr export "figure 1.eps", replace
