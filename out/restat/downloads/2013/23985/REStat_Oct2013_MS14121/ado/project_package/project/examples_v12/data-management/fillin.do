/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/fillin1.dta")
	use "`pdir'/data/stata/fillin1.dta"
	
	list
	
	fillin sex race age_group
	
	list, sepby(sex)
	