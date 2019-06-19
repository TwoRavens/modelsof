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
	
	statsby _b, by(foreign) verbose nodots: regress price weight length mpg
	
	list
	
	
	use "`pdir'/data/stata/auto.dta", clear
	statsby mpg=_b[mpg], by(foreign) nodots: regress price weight length mpg
	list
	
	
	use "`pdir'/data/stata/auto.dta", clear
	statsby _se, by(foreign) verbose nodots: regress price weight length mpg
	list
	

* Example 2

	project, original("`pdir'/data/stata/statsby.dta")
	use "`pdir'/data/stata/statsby.dta"
	
	statsby _b, by(group) verbose nodots: heckman price mpg, sel(trunk)
	
	list
	
	
	use "`pdir'/data/stata/statsby.dta", clear
	statsby [price]_b, by(group) verbose nodots: heckman price mpg, sel(trunk)
	list


* Example 3

	use "`pdir'/data/stata/auto.dta", clear
	
	statsby mean=r(mean) median=r(p50) ratio=(r(mean)/r(p50)), ///
		by(foreign) nodots: summarize price, detail
	
	list


* Example 4

	use "`pdir'/data/stata/auto.dta", clear
	
	statsby mean=r(mean) median=r(p50) n=r(N), ///
		by(foreign rep78) subsets nodots: summarize price, detail
		
	list
	
	
	// technical note
	use "`pdir'/data/stata/auto.dta", clear
	
	statsby mean=r(mean) se=(r(sd)/sqrt(r(N))), ///
		by(foreign) noisily nodots: summarize price
	
	list
