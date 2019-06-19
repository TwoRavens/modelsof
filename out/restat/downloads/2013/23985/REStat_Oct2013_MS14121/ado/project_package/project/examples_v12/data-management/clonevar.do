/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/travel.dta")
	use "`pdir'/data/stata/travel.dta"
	
	describe mode
	
	label list travel
	
	clonevar airtrain = mode if mode == 1 | mode == 2
	
	describe mode airtrain
	
	list mode airtrain in 1/5
	
	
* Technical note

	clonevar airtrain2 = mode if mode == "air":travel | mode == "train":travel
	
	list mode airtrain airtrain2 in 1/5
