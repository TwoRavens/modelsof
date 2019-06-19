/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 9
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/auto.dta")
	use "`pdir'/data/stata/auto.dta"

	separate mpg, by(foreign)
	
	list mpg* foreign
	
	// Make sure that the data is in the same order at every run. If not,
	// the PNG will be different.
	sort foreign make
	by foreign make: assert _n == 1
	
	qqplot mpg0 mpg1

	// export to PNG format
	graph export "`dofile'_example1.png", width(1200) replace
	project, creates("`dofile'_example1.png")
