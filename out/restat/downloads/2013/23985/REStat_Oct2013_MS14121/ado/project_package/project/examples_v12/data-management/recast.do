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

	describe
	
	recast int headroom
	
	describe mpg
	
	recast byte mpg
	
	describe mpg
	
	
	describe make
	
	recast str16 make
	
	recast str20 make
	
	describe make
	