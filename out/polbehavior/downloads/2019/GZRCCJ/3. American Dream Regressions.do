
clear
set more off

quiet: do "1. American Dream Prepare Variables.do"

*===============================================================================
*Table 1 in the Main Text ======================================================
*===============================================================================

foreach dv of varlist feeloutparty candidateoutparty nettraits_outparty polinterest polefficacy poldiscussion {
	reg `dv' c.partybridging c.partybonding i.female age education income i.religion4 i.nonwhite pidstrength repdummy
	estimates store m`dv'
}
esttab m* using Table1.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace
estimates clear


*===============================================================================
*Table A1 in the Online Appendix - Bridging doesn't include Independents ========
*===============================================================================

foreach dv of varlist feeloutparty candidateoutparty nettraits_outparty polinterest polefficacy poldiscussion {
	reg `dv' c.partybridging2 c.partybonding i.female age education income i.religion4 i.nonwhite pidstrength repdummy
	estimates store m`dv'
}
esttab m* using TableA1.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace
estimates clear


*===============================================================================
*Table A3 in the Online Appendix - Positive and Negative Traits Separately =====
*===============================================================================

foreach dv of varlist meanpos_outparty meanneg_outparty {
	reg `dv' c.partybridging c.partybonding i.female age education income i.religion4 i.nonwhite pidstrength repdummy
	estimates store m`dv'
}
esttab m* using TableA3.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace
estimates clear


*===============================================================================
*Table A4 in the Online Appendix - Only Partisan Orientations as Control Variables ========
*===============================================================================

foreach dv of varlist feeloutparty candidateoutparty nettraits_outparty polinterest polefficacy poldiscussion {
	reg `dv' c.partybridging c.partybonding pidstrength repdummy
	estimates store m`dv'
}
esttab m* using TableA4.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace
estimates clear
