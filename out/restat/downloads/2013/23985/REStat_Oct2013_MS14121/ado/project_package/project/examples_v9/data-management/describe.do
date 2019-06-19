/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 9
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/states.dta")
	use "`pdir'/data/stata/states.dta"
	
	describe, numbers
	

* Example 2

	describe, fullnames
	

* Example 3

	describe, short
	

* Example 4

	project, original("`pdir'/data/stata/census.dta")
	use "`pdir'/data/stata/census.dta"
	
	describe pop*
	
	describe state region pop18p
	

