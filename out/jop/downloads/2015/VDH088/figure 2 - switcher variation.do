set more off

*** time series ***

use "switchers", clear

keep if year >= 1987 & year <= 2011

collapse (sum) D1=D, by(year)

gen D0 = 920 - D1

#delimit;

gr tw
	(line D0 year, col(black) lpat(solid) lwid(thick))
	(line D1 year, col(black) lpat(dash) lwid(thick))
	,
		plotregion(style(none))
		ylab(, angle(horiz))
		xtitle("")
		ytitle("Number of towns")
		xlab(1987(5)2012)
		legend(off)
		nodraw
		name(g0, replace)
		title("Changes from election to appointment", yoffset(2.5))
		text(675 2004 "Towns with")
		text(590 2004 "Appointed Assessors")
		text(330 2005.5 "Towns with")
		text(245 2005.5 "Elected Assessors")
		
	;

#delimit cr

*** maps ***

use "switchers_map", clear

gen myD = .
replace myD = 2 if D1987 == 0 & D2012 == 0
replace myD = 1 if D1987 != D2012
replace myD = 3 if D1987 == 1 & D2012 == 1

tabulate myD, gen(myD)

forvalues i = 1(1)3 {

	if `i' == 1 local mytitle "Towns changing to appointment"
	if `i' == 2 local mytitle "Towns remaining elected"
	if `i' == 3 local mytitle "Towns remaining appointed"

	#delimit;

	spmap
		myD`i' using "coords"
		,
			id(_id) 
			nodraw
			fcol(white black white)
			mocol(black white black)
			ocol(black white black)
			clmethod(unique)
			ndfcolor(white)
			legend(off)	
			name(g`i', replace)
			title(`mytitle', size(medlarge))
			;

	#delimit cr

}

gr combine g0 g1 g2 g3

gr export "figure 2.eps", replace
