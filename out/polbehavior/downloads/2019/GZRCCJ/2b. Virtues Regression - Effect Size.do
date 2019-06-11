
clear
set more off

quiet: do "1. Virtues Prepare Variables.do"

*===============================================================================
*Table 2 in the Main Text ======================================================
*===============================================================================

log using "Democratic Virtues - Effect Size.log", replace
	
	*NOTE REGRESSION IS UNWEIGHTED BECAUSE STATA CAN'T GIVE ETA-SQUARED WITH WEIGHTED REGRESSION
	quiet: reg interaction c.partybridging c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy
	estimates store m1
	test partybridging == -partybonding
	estat esize

	quiet: reg polinterest c.partybridging c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy
	estimates store m2
	test partybridging == partybonding
	estat esize
	
	quiet: reg politicaltalk c.partybridging c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy
	estimates store m3
	test partybridging == partybonding
	estat esize
	
	quiet: reg disagreement c.partybridging c.partybonding female age education income i.religion4 nonwhite pidstrength repdummy
	estimates store m4
	test partybridging == partybonding
	estat esize
log close

* Producing unweighted regression as comparison
* Results are substantively the same
esttab m* using Table2-NoWeight.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace
