set more off

use dataset, clear

*** set DV ***

local Y lfinesandforfeitspcp

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
		//`loghalf' ".5"
		`log1' "1"
		//`log2' "2"
		`log5' "5"
		`log10' "10"
		`log20' "20"
		`log35' "35"
		`log100' "100"
		`log500' "500"
		,
			angle(horiz)
			
	)
	xline(`r(mean)', lcol(black) lpat(dash) lwid(thick))
	fcol(none)
	//lwid(medium)
	lcol(black)
	//barwidth(.08)
	plotregion(style(none))
	xtitle("Fine revenue per capita")
	ytitle("Number of cities")
	freq
	ylab(, angle(horiz))
	title("(A)")
	;
		
#delimit cr

gr export "figure1a.eps", replace
shell epstopdf figure1a.eps

gen anyfines = `Y' > 0 & !mi(`Y')
tab anyfines
su anyfines



