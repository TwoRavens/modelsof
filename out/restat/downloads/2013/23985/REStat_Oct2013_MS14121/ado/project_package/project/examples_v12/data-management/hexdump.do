/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/other/myfile.raw")
	type "`pdir'/data/other/myfile.raw"

	hexdump "`pdir'/data/other/myfile.raw"
	
	hexdump "`pdir'/data/other/myfile.raw", analyze
	
	
	project, original("`pdir'/data/other/myfile2.raw")
	hexdump "`pdir'/data/other/myfile2.raw"
