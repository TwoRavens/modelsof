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
	
	sort rep78 foreign
	list rep78 foreign, sepby(rep78 foreign)
	
	contract rep78 foreign
	
	list
	
	
	use "`pdir'/data/stata/auto.dta", clear
	contract rep78 foreign, zero
	list
