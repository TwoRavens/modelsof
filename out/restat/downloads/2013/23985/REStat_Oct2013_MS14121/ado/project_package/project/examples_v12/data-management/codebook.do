/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/educ3.dta")
	use "`pdir'/data/stata/educ3.dta"
	
	codebook fips division, all
	
	
* Example 2

	project, original("`pdir'/data/stata/citytemp.dta")
	use "`pdir'/data/stata/citytemp.dta"
	
	codebook cooldd heatdd tempjan tempjuly, mv
	

* Example 3

	project, original("`pdir'/data/stata/auto.dta")
	use "`pdir'/data/stata/auto.dta"
	
	label language en, rename
	label language de, new
	label data "1978 Automobile Daten"
	label variable foreign "Art Auto"
	label values foreign origin_de
	label define origin_de 0 "Innen" 1 "Ausländish"
	codebook foreign
	
	codebook foreign, languages(en de)
	
	
* Example 4

	// no need to link again
	use "`pdir'/data/stata/auto.dta", clear
	
	codebook, compact
	
	summarize
		
	
* Example 5

	// no need to link again
	project, original("`pdir'/data/stata/funnyvar.dta")
	use "`pdir'/data/stata/funnyvar.dta", clear
	
	codebook name
	
	codebook, problems
