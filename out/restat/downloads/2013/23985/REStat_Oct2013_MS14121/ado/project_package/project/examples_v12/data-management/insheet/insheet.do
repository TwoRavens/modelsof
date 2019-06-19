/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("auto.raw")
	
	insheet using "auto.raw"
	
	describe
	list
	
	// technical note	
	type "auto.raw"
	type "auto.raw", showtabs


	project, original("auto2.raw")
	
	type "auto2.raw"
	insheet using "auto2.raw"
	
	des
	list
	
	
* Example 2

	project, original("auto3.raw")
	
	type "auto3.raw"
	
	insheet using "auto3.raw", clear
	
	describe
	list
	
	
	insheet make price mpg rep78 foreign using "auto3.raw", clear
	
	list
	
	
* Example 3

	project, original("auto4.raw")
	
	type "auto4.raw", showtabs
	
	insheet using "auto4.raw"
	
	describe
	list
