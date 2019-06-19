/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/patients.dta")
	use "`pdir'/data/stata/patients.dta"
	
	list in 1/10
	
	// we do not want to stop the do-file on an error so capture it
	capture noisily icd9 clean diag1
	
	icd9 check diag1, gen(prob)
	
	list patid diag1 prob if prob
	
	replace diag1 = "230.6" if patid==2
	
	drop prob
	
	icd9 clean diag1
	
	list in 1/10
	
	
	icd9 clean diag1, dots
	icd9 clean diag2, dots
	icd9 clean diag3, dots
	list in 1/10
	
	
	icd9p clean proc1, dots
	icd9p clean proc2, dots
	list in 1/10
	
	
	icd9p check proc1
	icd9p check proc2
	
	
	icd9 generate td1 = diag1, description
	sort patid
	list patid diag1 td1 in 1/10
	

	icd9p gen tp2 = proc2, description
	sort patid
	list patid proc2 tp2 in 1/10


	icd9 generate main1 = diag1, main
	list patid diag1 main1 in 1/10
	
	
	list diag* if patid==563


	icd9 lookup 526.4
	
	
	icd9 lookup 526/526.99
	
	
	icd9 lookup 526*
	
	
	// the following command produces an error
	capture noisily icd9 search jaw disease
	dis as error "return code = " _rc
