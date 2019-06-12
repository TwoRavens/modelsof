set more off 

set more off 

use "ssi october 2012", clear

merge 1:1 svid using "ssi october 2012 wave 2"

keep if _m == 3

keep if independent == 0

foreach x in predict_obama {
	su `x', det
	keep if `x' > r(p1) & `x' < r(p99)
}

gen dchange_eco = change_eco2 - change_eco
gen y = dchange_eco


su dchange_eco if democrat == 1
local mymean1 = r(mean)
su dchange_eco if democrat == 0
local mymean2 = r(mean)


#delimit;

gr tw 
	(fpfitci y predict_obama if democrat == 1
		, acol(gray) alwidth(none) alcol(white) fintens(50) col(black) clwidth(medthick)
	)
	(fpfitci y predict_obama if democrat == 0
		, ciplot(rline) col(black) lpat(dash) alpat(shortdash) clwidth(thick)
	)

	,
		legend(off)
		plotregion(style(none))
		ylab(, angle(horiz))
		text(-1.25 50 "Republicans")
		text(0.4 40 "Democrats")
		ytitle("Change in economic perceptions")
		yline(`mymean1', lcol(black) lwid(vvthin))
		yline(`mymean2', lcol(black) lpat(dash) lwid(vvthin))
		;
	
#delimit cr

gr export "figure6.eps", replace

