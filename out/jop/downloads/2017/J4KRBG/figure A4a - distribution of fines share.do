set more off

use dataset, clear

*** set DV ***

local Y lpctfinesand

*** recode log scale ***

forvalues i = 1(1)1000 {
	local log`i' = log(`i'+1)
}
local loghalf = log(.5 + 1)

*** do the graph ***

su `Y', det

#delimit;

hist `Y'
	,
	xlab(
		0 "0"
		`log1' "1"
		`log5' "5"
		`log10' "10"
		`log20' "20"
		`log35' "35"
		`log100' "100"
		,
			angle(horiz)
			
	)
	xline(`r(mean)', lcol(black) lpat(dash) lwid(thick))
	fcol(none)
	//lwid(medium)
	lcol(black)
	//barwidth(.08)
	plotregion(style(none))
	xtitle("Fines as percent of total revenue")
	ytitle("Number of cities")
	freq
	ylab(, angle(horiz))
	title("(A)")
	;
		
#delimit cr

gr export "figureA4a.eps", replace
shell epstopdf figureA4a.eps

gen anyfines = `Y' > 0 & !mi(`Y')
tab anyfines
su anyfines



