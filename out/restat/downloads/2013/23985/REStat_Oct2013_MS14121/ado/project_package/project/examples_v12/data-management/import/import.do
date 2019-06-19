/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("example1.raw")

	listfile "example1.raw"
	
	listfile "example1.raw", showtabs
	
	insheet a b c name gender using "example1.raw"
	
	list


* Example 2

	project, original("example2.raw")

	listfile "example2.raw"
	
	insheet using "example2.raw"
	
	list


* Example 3

	project, original("example3.raw")

	listfile "example3.raw"
	listfile "example3.raw", showtabs
	
	infile byte (a b c) str15 name str1 gender using "example3.raw"

	list
	
	
	clear
	insheet a b c name gender using "example3.raw"

	list
	
	
	project, original("dict3.dct")
	
	listfile "dict3.dct"
	
	infile using "dict3.dct"
	
	list


* Example 4

	project, original("example4.raw")
	listfile "example4.raw"

	infile byte (a b c) str15 name str1 gender using "example4.raw"
	list
	
	
	project, original("dict4.dct")
	infile using "dict4.dct"
	listfile "dict4.dct"
	
	list


* Example 5

	project, original("example5.raw")
	listfile "example5.raw"

	infix a 1 b 2 c 3 str gender 4 str name 5-19 using "example5.raw"
	list
	
	clear
	infix using dict5a
	
	
	project, original("dict5a.dct")
	infix using "dict5a.dct"
	listfile "dict5a.dct"
	
	list
	
	
	project, original("dict5b.dct")
	infile using "dict5b.dct"
	listfile "dict5b.dct"
	
	list


* Example 6

	project, original("example6.raw")
	project, original("dict6a.dct")
	
	listfile "example6.raw"
	listfile "dict6a.dct"
	
	infile using "dict6a.dct"
	list
	
	
	clear
	infix 5 first a 1 b 9 c 17 str gender 25 str name 33-46 using "example6.raw"
	list


	project, original("dict6b.dct")
	listfile "dict6b.dct"
	infix using "dict6b.dct"
	list
	


* Example 7

	project, original("example7.raw")
	project, original("dict7a.dct")
	
	listfile "example7.raw"
	listfile "dict7a.dct"
	
	infile using "dict7a.dct"
	list
	
	
	project, original("dict7b.dct")
	listfile "dict7b.dct"
	infile using "dict7b.dct"
	list
	
	
	clear
	infix 2 first 3 lines a 1 b 3 c 5 str gender 2:1 str name 3:1-15 using "example7.raw"
	list
	
	
	project, original("dict7c.dct")
	listfile "dict7c.dct"
	infix using "dict7c.dct"
	list
	
	
	
	
	project, original("dict7d.dct")
	listfile "dict7d.dct"
	infix using "dict7d.dct"
	list
