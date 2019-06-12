set more off

use dataset, clear

*** set DV ***

local Y lpctfinesand

*** recoding for log scale ***

forvalues i = 1(1)1000 {
	local log`i' = log(`i'+1)
}
local loghalf = log(.5 + 1)

*** do the graph ***

#delimit;

	gr tw 
		(sc `Y' pctblack, msize(vtiny) col(gs10) msymbol(O)) 
		(lfit `Y' pctblack
			, col(black) lwid(thick)
				 
		)
		(lowess `Y' pctblack, col(gray) lpat(shortdash))
	
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
			title("(B)")
			;
			
#delimit cr

gr export "figureA4b.eps", replace
shell epstopdf figureA4b.eps

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
