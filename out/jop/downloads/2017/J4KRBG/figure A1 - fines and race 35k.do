set more off

use dataset35k, clear

*** set DV ***

local Y lfinesandforfeitspcp

*** recoding for log scale ***

forvalues i = 1(1)1000 {
	local log`i' = log(`i'+1)
}

*** do the graph ***

#delimit;

	gr tw 
		(sc `Y' pctblack, msize(vtiny) col(gs10) msymbol(O)) 
		(lfitci `Y' pctblack
			,
				alpat(dash) alcol(black) clcol(black) 
				clwidth(medthick) ciplot(rline)
				alwidth(vthin)
		)
		(lowess `Y' pctblack)
	
		,
			legend(off)
			name(g`j', replace)
			plotregion(style(none))
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
			ytitle("Fine revenue per capita")
			xtitle("Percent black population")
			;
			
#delimit cr

gr export "figureA1.eps", replace
shell epstopdf figureA1.eps

su pctblack
replace pctblack = (pctblack - r(min)) / (r(max) - r(min))
reg `Y' pctblack
replace pctblack = 0
predict Y0, xb
replace Y0 = exp(Y0)-1
replace pctblack = 1
predict Y1, xb
replace Y1 = exp(Y1)-1
su Y0 Y1

