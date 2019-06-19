/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 9
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name
	local author RP									// author of this file
	local sig {bind:{hi:[`author' : `dofile'.do]}}	// a signature in notes


* Example 1

	project, original("`pdir'/data/other/myfile.raw")
	type "`pdir'/data/other/myfile.raw"

	hexdump "`pdir'/data/other/myfile.raw"
	
	hexdump "`pdir'/data/other/myfile.raw", analyze
	
	
	project, original("`pdir'/data/other/myfile2.raw")
	hexdump "`pdir'/data/other/myfile2.raw"
