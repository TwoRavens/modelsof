set more off

use dataset, clear

*** recoding for log scale ***

forvalues i = 1(1)1000 {
	local log`i' = log(`i'+1)
}

*** labels ***

label define anyblackgovl 0 "No black councilor" 1 "At least one black councilor", replace
label values anyblackgov anyblackgovl

*** graph ***

#delimit;

gr tw 
	(sc lfinesandforfeitspcp pctblack, col(gs10) msize(tiny))
	(lfit lfinesandforfeitspcp pctblack, col(black) lwid(thick) lpat(dash))
	(lowess lfinesandforfeitspcp pctblack, col(black))
	,
		by(anyblackgov, legend(off) note(""))
		ylab(
			0 "0"
			`log1' "1"
			`log2' "2"
			`log5' "5"
			`log10' "10"
			`log20' "20"
			`log35' "35"
			`log100' "100"
			`log500' "500"		
			,
			angle(horiz)
			nogrid
		)
		xlab(
			0 "0"
			`log1' "1"
			`log5' "5"
			`log10' "10"
			`log25' "25"
			`log50' "50"
			`log100' "100"
			
		)	
		xtitle("Percent black population")
		ytitle("Fines revenue per capita")
		plotregion(style(none))
		subtitle(, fcol(none) lcol(none))
		;

#delimit cr
 
gr export "figureA5.eps", replace
shell epstopdf figureA5.eps
