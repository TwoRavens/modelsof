set more off

use dataset, clear

gen y = dtaxbill

*** make forcing variable ***

replace X = X/demincumbent

*** main effect ***

lpoly y X if X < 0, nograph gen(x0 y0)
lpoly y X if X > 0, nograph gen(x1 y1)
su x0
su y0 if x0 == r(max)
local Y0 = r(mean)
su x1
su y1 if x1 == r(min)
local Y1 = r(mean)
di `Y1'-`Y0'

keep if !mi(y) & !mi(X)

*** figure ***

#delimit;

gr tw 
	(scatteri -15 0 15 0, c(l) m(i) col(gray) lpat(shortdash) lwid(thin))
	(lpolyci y X if X <= 0, col(black) lwid(thick) acol(gray) fintens(20) alcol(white) alwidth(none))
	(lpolyci y X if X >= 0, col(black) lwid(thick) acol(gray) fintens(20) alcol(white) alwidth(none))
	(sc y X if !mi(X) & !mi(y), col(black) msize(vtiny))
	,
		legend(off)
		plotregion(style(none))
		xtitle("Tax increase vote share")
		ylab(, angle(horiz))
		xlab(
			-.5 "-50"
			-.4 "-40"
			-.3 "-30"
			-.2 "-20"
			-.1 "-10"
			0 "0"
			.1 "10"
			.2 "20"
			.3 "30"
			.4 "40"
			.5 "50"
		)
		ytitle("Change in tax bills")
		name(g1, replace)		
		;
		
#delimit cr

gr export "figure A3b.eps", replace
