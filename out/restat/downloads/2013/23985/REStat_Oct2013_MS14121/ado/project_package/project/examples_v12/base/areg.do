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
	
	
	regress mpg weight gear_ratio b5.rep78
	
	
	areg mpg weight gear_ratio, absorb(rep78)
	
	
	// technical note
	predict yhat
	summarize mpg yhat if rep78 != .
	
	
* Example 2

	// no data
