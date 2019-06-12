
clear
set more off

quiet: do "1. Virtues Prepare Variables.do"


*===============================================================================
*Table 2 in the Main Text ======================================================
*===============================================================================

foreach dv of varlist interaction polinterest politicaltalk disagreement {
	reg `dv' c.partybridging c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
	estimates store m1`dv'
	reg `dv' c.partybridging c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy disagreement [pweight=weight]
	estimates store m2`dv'
}
esttab m* using Table2.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace
estimates clear


*===============================================================================
*Table A2 in the Online Appendix - Bridging doesn't include Independents ========
*===============================================================================

foreach dv of varlist interaction polinterest politicaltalk disagreement {
	reg `dv' c.partybridging2 c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
	estimates store m1`dv'
	reg `dv' c.partybridging2 c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy disagreement [pweight=weight]
	estimates store m2`dv'
}
esttab m* using TableA2.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace
estimates clear



*===============================================================================
*Table A5 in the Online Appendix - Only Partisan Orientations as Control Variables ========
*===============================================================================

foreach dv of varlist interaction polinterest politicaltalk disagreement {
	reg `dv' c.partybridging c.partybonding pidstrength repdummy
	estimates store m1`dv'
	reg `dv' c.partybridging c.partybonding pidstrength repdummy disagreement
	estimates store m2`dv'
}
esttab m* using TableA5.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace
estimates clear


*===============================================================================
*Table A7 in the Online Appendix - Interaction between Disagreement and Bonding/Bridging ========
*===============================================================================

set more off
foreach dv of varlist interaction polinterest politicaltalk {
	reg `dv' c.disagreement##c.partybridging c.disagreement##c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
	estimates store m1`dv'

}

esttab m* using TableA7.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace
estimates clear


*===============================================================================
*Plotting Interactions ========
*===============================================================================

*** interaction: bridging X disagreement
set more off
reg interaction c.partybridging##c.disagreement c.disagreement##c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
margins, at(disagreement=(1) partybridging=(1 4)) atmeans post
estimates store low
reg interaction c.partybridging##c.disagreement c.disagreement##c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
margins, at(disagreement=(3) partybridging=(1 4)) atmeans post
estimates store high

coefplot (low, color(gray)) ///
		 (high, color(olive_teal)), ///
		 ytitle(Outparty Interaction) vertical recast(bar) barwidth(0.25) ciopts(recast(rcap)) citop ///
		legend(rows(1) label(3 "High Disagreement") label(1 "Low Disagreement") ) ///
		yscale(range(1 5)) ylabel(1(1)5) ///
		xscale(range(1 2)) xlabel(1 "Low Bridging" 2 "High Bridging") ///
		graphregion(color(white)) ///
		bgcolor(white) ///
		subtitle(Outparty Interactions)
graph export "Outparty Interactions - Bridging.png", replace


*** political interest: bridging X disagreement
set more off
reg polinterest c.partybridging##c.disagreement c.disagreement##c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
margins, at(disagreement=(1) partybridging=(1 4)) atmeans post
estimates store low
reg interaction c.partybridging##c.disagreement c.disagreement##c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
margins, at(disagreement=(3) partybridging=(1 4)) atmeans post
estimates store high

coefplot (low, color(gray)) ///
		 (high, color(olive_teal)), ///
		 ytitle(Political Interest) vertical recast(bar) barwidth(0.25) ciopts(recast(rcap)) citop ///
		legend(rows(1) label(3 "High Disagreement") label(1 "Low Disagreement") ) ///
		yscale(range(1 5))  ylabel(1(1)5) ///
		xscale(range(1 2)) xlabel(1 "Low Bridging" 2 "High Bridging") ///
		graphregion(color(white)) ///
		bgcolor(white) ///
		subtitle(Political Interest)
graph export "Political Interest - Bridging.png", replace



*** political interest: bonding X disagreement
set more off
reg polinterest c.partybridging##c.disagreement c.disagreement##c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
margins, at(disagreement=(1) partybonding=(1 4)) atmeans post
estimates store low
reg interaction c.partybridging##c.disagreement c.disagreement##c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
margins, at(disagreement=(3) partybonding=(1 4)) atmeans post
estimates store high

coefplot (low, color(gray)) ///
		 (high, color(olive_teal)), ///
		 ytitle(Political Interest) vertical recast(bar) barwidth(0.25) ciopts(recast(rcap)) citop ///
		legend(rows(1) label(3 "High Disagreement") label(1 "Low Disagreement") ) ///
		yscale(range(1 5)) ylabel(1(1)5) ///
		xscale(range(1 2)) xlabel(1 "Low Bonding" 2 "High Bonding") ///
		graphregion(color(white)) ///
		bgcolor(white) ///
		subtitle(Political Interest)
graph export "Political Interest - Bonding.png", replace


*** political discussion: bonding X disagreement
set more off
reg politicaltalk c.partybridging##c.disagreement c.disagreement##c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
margins, at(disagreement=(1) partybonding=(1 4)) atmeans post
estimates store low
reg interaction c.partybridging##c.disagreement c.disagreement##c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy [pweight=weight]
margins, at(disagreement=(3) partybonding=(1 4)) atmeans post
estimates store high

coefplot (low, color(gray)) ///
		 (high, color(olive_teal)), ///
		 ytitle(Political Discussion) vertical recast(bar) barwidth(0.25) ciopts(recast(rcap)) citop ///
		legend(rows(1) label(3 "High Disagreement") label(1 "Low Disagreement") ) ///
		yscale(range(0 6)) ylabel(0(1)6) ///
		xscale(range(1 2)) xlabel(1 "Low Bonding" 2 "High Bonding") ///
		graphregion(color(white)) ///
		bgcolor(white) ///
		subtitle(Political Discussion)
graph export "Political Discussion - Bonding.png", replace
