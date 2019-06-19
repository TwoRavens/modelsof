/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/child.dta")
	use "`pdir'/data/stata/child.dta"
	
	describe
	list
	
	project, original("`pdir'/data/stata/parent.dta")
	use "`pdir'/data/stata/parent.dta"
	
	describe
	list, sep(0)


	sort family_id
	
	joinby family_id using "`pdir'/data/stata/child.dta"
	
	describe
	

	// Note that the results from this -joinby- command will change
	// at each run because the data is not fully sorted. This means
	// that this log file will change at every run and will make 
	// replication impossible. The solution is to fully sort...
	sort family_id parent_id child_id
	
	// the following checks that there is only one record per group
	// (i.e. data is fully sorted)
	by family_id parent_id child_id: assert _n == 1
	
	list, sepby(family_id) abbrev(12)
