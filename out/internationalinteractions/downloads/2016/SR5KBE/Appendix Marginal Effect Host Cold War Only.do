clear all
set mem 50m
* cd "..."
use "DATA_COMPILED_ATOP_20151118.dta"
set more off 


gen sample1 = 0
replace sample1 = 1 if year < 1991
label var sample1 "All States"
gen sample2 = 0
replace sample2 = 1 if year < 1991 & usally == 1 & NATO == 0
label var sample2 "Non-NATO Allies"
gen sample3 = 0
replace sample3 = 1 if year < 1991 & NATO == 1
label var sample3 "NATO Allies"
gen sample4 = 0
replace sample4 = 1 if year < 1991 & usally == 0
label var sample4 "Non-Allies"


xtset ccode year

local i = 1

foreach var of varlist sample1-sample4 {

xtpcse defenseburden l.lntroops l.lntroops_spmean l.interaction l.spatial_lag l.polity l.growth l.lntpop l.IMR l.threat_environment war movav3 borderstates civilwar l.meanregionalallies l.meanregionalusallies if `var'==1 , corr(ar1) pairwise	

matrix b=e(b)
matrix V=e(V)

scalar b1=b[1,1]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]

scalar covb1b3=V[1,3]

scalar list b1 b3 varb1 varb3 covb1b3

*     ****************************************************************  *
*       Calculate data necessary for top marginal effect plot.          *
*     ****************************************************************  *

range MVZ 0 15 151
*gen MVZ=(_n/100)

replace  MVZ=. if MVZ >15

gen conbx=b1+b3*MVZ if MVZ<=15

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if MVZ<=15

gen ax=1.96*consx

gen upperx=conbx+ax

gen lowerx=conbx-ax


gen yline=0

*     ****************************************************************  *
*     ****************************************************************  *
*       Produce marginal effect plot for X.                             *
*     ****************************************************************  *
*     ****************************************************************  *

twoway hist lntroops_spmean if e(sample) & lntroops_spmean<=15, percent width(.5) yaxis(2) color(gs14) legend(off) ///
	   || line conbx MVZ,  clpattern(solid) clwidth(medium) clcolor(black) yaxis(1) ///
	   || line upperx MVZ, clpattern(shortdash) clwidth(medium) clcolor(black) ///
	   || line lowerx MVZ, clpattern(shortdash) clwidth(medium) clcolor(black) ///
	   || line yline  MVZ, clwidth(thin) clcolor(black) clpattern(solid) ///
	   || , ///
	   xlabel(0(1)15, nogrid ) ///
	   ylabel(, axis(1) nogrid ) ///
	   ylabel(0(5)20, nogrid axis(2) nogrid ) ///
	   xtitle(Regional Deployment Size) ///
	   yscale(alt) ///
	   yscale(alt axis(2))	///
	   legend(off) ///
	   ytitle("Marginal Effect", axis(1)) /// 
	   ytitle("Percent", axis(2)) ///
	   title((`i')) ///
	   graphregion(fcolor(white) lcolor(white)) ///
	   subtitle(`:variable label `var'')	  
	   
graph save `var'.gph, replace

drop MVZ conbx consx ax upperx lowerx yline
scalar drop _all
local i = `i'+1

}	   
	   
graph combine sample1.gph sample2.gph sample3.gph sample4.gph, cols(2) ycommon scale(.9) graphregion(color(white))

graph export "MarginalEffect_Host_ColdWar.pdf", replace






