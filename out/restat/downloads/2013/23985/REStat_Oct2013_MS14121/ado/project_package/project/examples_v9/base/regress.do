/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 9
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/auto.dta")
	use "`pdir'/data/stata/auto.dta"
	
	
	gen double weight2 = weight*weight
	regress mpg weight weight2 foreign
	
	
* Example 2

	regress, beta
	
	
* Example 3

	regress weight length, noconstant
	
	xi,noomit: regress weight length i.foreign, hascons

	// technical note
	xi,noomit: regress weight length i.foreign, noconstant
	
	// technical note
	regress weight length, hascons
	
	// technical note
	xi,noomit: regress weight length i.foreign
	
	
* Example 4

	gen gpmw = ((1/mpg)/weight)*100*1000
	summarize gpmw
	
	regress gpmw foreign

	regress gpmw foreign, vce(robust)
	
	tabulate foreign, summarize(gpmw)
	
	
* Example 5

	regress gpmw foreign, hc2
	regress gpmw foreign, hc3
	
	
* Example 6

	project, original("`pdir'/data/stata/regsmpl.dta")
	use "`pdir'/data/stata/regsmpl.dta"
	
	regress ln_wage age age2 tenure
	
	regress ln_wage age age2 tenure, cluster(idcode)
	
	xtreg ln_wage age age2 tenure, re
	
	estimates store random
	
	xtreg ln_wage age age2 tenure, fe
	
	hausman . random
	
	
* Example 7

	project, original("`pdir'/data/stata/census9.dta")
	use "`pdir'/data/stata/census9.dta"
	
	describe
	
	xi: regress drate medage i.region [w=pop]
	
	
	// technical note
	test _Iregion_2 _Iregion_3 _Iregion_4
