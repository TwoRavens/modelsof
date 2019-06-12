
clear
set more off

quiet: do "1. American Dream Prepare Variables.do"


*===============================================================================
*Table 1 in the Main Text ======================================================
*===============================================================================

log using "American Dream - Effect Size.log", replace
	quiet: reg feeloutparty c.partybridging c.partybonding i.female age education income i.religion4 i.nonwhite pidstrength repdummy
	test partybridging == -partybonding
	estat esize
	
	quiet: reg candidateoutparty c.partybridging c.partybonding i.female age education income i.religion4 i.nonwhite pidstrength repdummy
	test partybridging == -partybonding
	estat esize
	
	quiet: reg nettraits_outparty c.partybridging c.partybonding i.female age education income i.religion4 i.nonwhite pidstrength repdummy
	test partybridging == -partybonding
	estat esize
	
	quiet: reg polinterest c.partybridging c.partybonding i.female age education income i.religion4 i.nonwhite pidstrength repdummy
	test partybridging == partybonding
	estat esize
	
	quiet: reg polefficacy c.partybridging c.partybonding i.female age education income i.religion4 i.nonwhite pidstrength repdummy
	test partybridging == partybonding
	estat esize
	
	quiet: reg poldiscussion c.partybridging c.partybonding i.female age education income i.religion4 i.nonwhite pidstrength repdummy
	test partybridging == partybonding
	estat esize
log close
