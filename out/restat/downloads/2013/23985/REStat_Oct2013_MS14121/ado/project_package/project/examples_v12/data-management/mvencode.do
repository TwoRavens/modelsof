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
	
	// we don't want this do-file to stop because of the error so we capture it
	capture noisily mvencode _all, mv(1)
	dis as error _rc
	
	list if mi(rep78)
	mvencode _all, mv(999)
	list if rep78 == 999
	

* Example 2

	mvdecode _all, mv(999)
	list if mi(rep78)
