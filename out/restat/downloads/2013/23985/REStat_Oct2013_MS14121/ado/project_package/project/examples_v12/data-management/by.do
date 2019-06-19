/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/autornd.dta")
	use "`pdir'/data/stata/autornd.dta"
	
	keep in 1/20
	
	// the following produces an error; we don't want to stop the build
	// so we capture the error
	capture noisily by mpg: egen mean_w = mean(weight)
	dis as error _rc
	
	sort mpg
	
	by mpg: egen mean_w = mean(weight)
	
	// the data is not fully sorted so the following list will change at
	// every run. This makes the log file change at each replication run.
	// Better to fully sort
	
	isid make	// make uniquely identifies observations
	sort mpg make
	
	list	
