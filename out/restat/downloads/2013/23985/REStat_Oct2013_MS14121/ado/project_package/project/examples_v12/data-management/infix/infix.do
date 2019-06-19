/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("highway.dct")

	listfile "highway.dct"

	infix using "highway.dct"
	
	list


* Example 2

	project, original("mydata.raw")
	project, original("mydata1.dct")
	project, original("mydata2.dct")

	listfile "mydata.raw"
	listfile "mydata1.dct"
	listfile "mydata2.dct"

	infix using "mydata1.dct"
	
	list in 1/2



	clear
	infix using "mydata2.dct"
	
	list in 1/2
	
	
	project, original("mydata3.dct")

	listfile "mydata3.dct"
	
	infix using "mydata3.dct"
	
	list in 1/2
