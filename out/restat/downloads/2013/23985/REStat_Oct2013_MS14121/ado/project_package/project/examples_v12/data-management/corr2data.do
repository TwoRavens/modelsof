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
	
	regress weight length trunk
	
	// matrix of means
	mean weight length trunk
	mat M = e(b)
	mat list M
	
	// covariance matrix
	correlate weight length trunk, covariance
	mat V = r(C)
	mat list V
	
	
	corr2data x y z, n(74) cov(V) means(M)
	regress x y z
