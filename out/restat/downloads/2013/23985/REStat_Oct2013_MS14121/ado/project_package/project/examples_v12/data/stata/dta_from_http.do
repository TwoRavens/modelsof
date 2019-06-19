/*
--------------------------------------------------------------------------------

The examples in the Stata reference manuals usually load datasets directly from 
the web. For those used in this project, save a local copy. 

--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name
	local author RP									// author of this file
	local sig {bind:{hi:[`author' : `dofile'.do]}}	// a signature in notes


* Make a list of datasets that we want to -use-

	local datasets autornd travel educ3 citytemp auto college census5 ///
		fullauto states census destring1 destring2 tostring ///
		hbp2 fillin1 census10 patients child parent stackxmpl statsby  ///
		regsmpl census9 fmtxmpl fmtxmpl2 funnyvar hbp3 outfilexmpl
		
		
* Make sure that we don't have duplicates and sort the list

	local datasets : list uniq datasets
	local datasets : list sort datasets
		
		
* Define the path to the datasets

	local http "http://www.stata-press.com/data/r12"
	

* Loop over the list of datasets and download if we don't have a readable
* local copy. We prefer using an -original()- build directive instead of
* -creates()- because the latter would force new downloads each time the
* -replicate- task is used.

	foreach dataset of local datasets {
	
		// check if we have a readable local copy; download if not
		capture des using "`dataset'.dta"
		if _rc qui copy "`http'/`dataset'.dta" "`dataset'.dta", replace
		
		// this is not a file created by this project
		project, original("`dataset'.dta")
	
	}
	