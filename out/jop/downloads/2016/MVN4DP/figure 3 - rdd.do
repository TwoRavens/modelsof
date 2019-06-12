set more off

use dataset, clear

*** impute pres vote for non-election years ***

gen l4lagdem = l4.lagdemvoteshare
gsort town -year 

foreach x in demvoteshare totalvotes lagdemvoteshare l4totalvotes l4lagdem {
	bys town: replace `x' = `x'[_n-1] if mi(`x') & year >= 1990 & year <= 2012
}

*** residualize ***

gen y = demvoteshare

reg y lagdemvoteshare i.year [aw=totalvotes], a(town)
predict e, res
drop y
rename e y 

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
		xtitle("Tax increase vote share*Democratic incumbent")
		ylab(-15(5)15, angle(horiz))
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
		ytitle("Change in Democratic vote share")
		name(g1, replace)	
		;
		
#delimit cr

gr export "figure 3.eps", replace
