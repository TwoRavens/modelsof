/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	// we need to fabricate data from Bob

	// for replication, always set a seed
	set seed 12345
	
	set obs 522
	gen sal = 6000 + runiform() * (125000-6000)
	replace sal = . if _n <= 14
	gen exp = runiform() * 40
	gen female = round(uniform())
	
	tempfile frombob
	save "`frombob'"
	
	summarize
	
	
	// we do not want this program to stop when the error is encountered
	capture noisily {
		use "`frombob'", clear
		assert _N==522
		assert sal>=6000 & sal<=125000
		assert female==1 | female==0
		gen work=sum(female==1)
		assert work[_N]>0
		replace work=sum(female==0)
		assert work[_N]>0
		drop work
		assert exp>=0 & exp<=40
	}
	
	
	// Bob sends a new version
	replace sal = 6000 + runiform() * (125000-6000) if mi(sal)
	save "`frombob'", replace
	
	sum
	
	// this time all works well
	use "`frombob'", clear
	assert _N==522
	assert sal>=6000 & sal<=125000
	assert female==1 | female==0
	gen work=sum(female==1)
	assert work[_N]>0
	replace work=sum(female==0)
	assert work[_N]>0
	drop work
	assert exp>=0 & exp<=40
