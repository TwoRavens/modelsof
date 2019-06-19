//Figure A1. Exit rates by domestic and foreign firm

use "eseecleaned.dta", clear

cap drop exit
gen exit=(idsit==2) 
gen domfir=(pcaext<=50)
replace domfir=. if pcaext==.
replace domfir=l.domfir if exit==1
proportion exit, over(domfir year)
parmest, norestore
keep if eq=="_prop_2"
gen domfir=0 in 1/8
replace domfir=1 in 9/16
gen year=.
bysort domfir: replace year=2003+_n-1
keep estimate min95 max95 domfir year
reshape wide estimate min95 max95, i(year) j(domfir)
tsset year
label var estimate0 "Foreign firms"
label var estimate1 "Domestic firms"
set scheme s2mono
tsline estimate0 min950 max950 estimate1 min951 max951, lpat(solid dash dash solid dash dash) ///
	lcol(gs0 gs0 gs0 gs10 gs10 gs10) legend(order(1 4)) ytitle("Exit rates") xtitle("Year") 
graph export "figureA1.png", replace
