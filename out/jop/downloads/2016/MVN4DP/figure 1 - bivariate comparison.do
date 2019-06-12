set more off

use dataset, clear

gen y = demvoteshare - lagdemvoteshare

collapse y (semean) se = y [aw=totalvotes], by(overridep demincumbent year)

keep if !mi(y)

gen ub = y + 1.96*se
gen lb = y - 1.96*se

gen year0 = year
gen year1 = year + .2

bys overridep: gen rindex = _n if demincumbent == -1
gen rindex0 = rindex
gen rindex1 = rindex + .3

bys overridep: gen dindex = _n if demincumbent == 1
gen dindex0 = dindex
gen dindex1 = dindex + .3

local h .3

#delimit;

gr tw 
	(bar y rindex0 if overridep == 0, barwidth(`h') fcol(white) lcol(black) lwid(medium))
	(rspike ub lb rindex0 if overridep == 0, col(black))
	(bar y rindex1 if overridep == 1, barwidth(`h') fcol(white) lcol(black) lwid(medium))
	(rspike ub lb rindex1 if overridep == 1, col(black))
	,
		xlab(
			1 "No"
			1.3 "Yes"
			2 "No"
			2.3 "Yes"
			3 "No"
			3.3 "Yes"
		)
		text(10 1.1 "1992")
		text(10 2.1 "2004")
		text(10 3.1 "2008")
		ylab(, angle(horiz))
		legend(off)
		plotregion(style(none))
		title("Republican Incumbent")
		name(g1, replace)
		;

#delimit cr

#delimit;

gr tw 
	(bar y dindex0 if overridep == 0, barwidth(`h') fcol(white) lcol(black) lwid(medium))
	(rspike ub lb dindex0 if overridep == 0, col(black))
	(bar y dindex1 if overridep == 1, barwidth(`h') fcol(white) lcol(black) lwid(medium))
	(rspike ub lb dindex1 if overridep == 1, col(black))
	,
		xlab(
			4 "No"
			4.3 "Yes"
			5 "No"
			5.3 "Yes"
			6 "No"
			6.3 "Yes"
		)
		text(10 4.1 "1996")
		text(10 5.1 "2000")
		text(10 6.1 "2012")		
		ylab(, angle(horiz))		
		legend(off)
		plotregion(style(none))
		nodraw
		title("Democratic Incumbent")
		name(g2, replace)
		;

#delimit cr

gr combine g1 g2, xsize(2) ysize(1) scale(1.5) l2title("Change in Democratic vote") b1title("Property tax increase")

gr export "figure 1.eps", replace
 
