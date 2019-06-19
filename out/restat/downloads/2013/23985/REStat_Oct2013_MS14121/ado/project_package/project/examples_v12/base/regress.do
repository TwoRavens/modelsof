/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/auto.dta")
	use "`pdir'/data/stata/auto.dta"
	
	
	regress mpg weight c.weight#c.weight foreign
	
	
* Example 2

	regress, beta
	
	
* Example 3

	regress weight length, noconstant
	
	regress weight length bn.foreign, hascons

	// technical note
	regress weight length bn.foreign, noconstant
	
	// technical note
	regress weight length, hascons
	
	// technical note
	regress weight length bn.foreign
	
	
* Example 4

	gen gpmw = ((1/mpg)/weight)*100*1000
	summarize gpmw
	
	regress gpmw foreign

	regress gpmw foreign, vce(robust)
	
	tabulate foreign, summarize(gpmw)
	
	
* Example 5

	regress gpmw foreign, vce(hc2)
	regress gpmw foreign, vce(hc3)
	
	
* Example 6

	project, original("`pdir'/data/stata/regsmpl.dta")
	use "`pdir'/data/stata/regsmpl.dta"
	
	regress ln_wage age c.age#c.age tenure
	
	regress ln_wage age c.age#c.age tenure, vce(cluster idcode)
	
	xtreg ln_wage age c.age#c.age tenure, re
	
	estimates store random
	
	xtreg ln_wage age c.age#c.age tenure, fe
	
	hausman . random
	
	
* Example 7

	project, original("`pdir'/data/stata/census9.dta")
	use "`pdir'/data/stata/census9.dta"
	
	describe
	
	regress drate medage i.region [w=pop]
	
	
	// technical note
	test 2.region 3.region 4.region
