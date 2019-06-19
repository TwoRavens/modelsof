/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 9
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/census10.dta")
	use "`pdir'/data/stata/census10.dta"
	
	describe
	
	list in 1/8

	format state %-14s	
	list in 1/8
	
	format region %-8.0g
	list in 1/8
	
	format pop %11.0gc
	list in 1/8
	
	format pop %12.0gc
	list in 1/8

	format medage %8.1f	
	list in 1/8


* Example 2

	// no data


* Example 3

	// no data
	

* Example 4

	project, original("`pdir'/data/stata/census10.dta")
	use "`pdir'/data/stata/census10.dta"
	
	format pop %12,0gc
	format medage %9,2f	
	list in 1/8
	
	format pop %12.0gc 	// (put the formats back as they were)
	format medage %9.2f
	set dp comma		// (tell Stata to use European format)
	list in 1/8	
	
	tabulate region [fw=pop]
	
	set dp period
	
	tabulate region [fw=pop]
