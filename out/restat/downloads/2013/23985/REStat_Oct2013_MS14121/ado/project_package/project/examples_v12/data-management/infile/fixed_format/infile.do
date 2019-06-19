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

	infile using "highway.dct"
	
	list


* Example 2

	project, original("highway2.dct")

	listfile "highway2.dct"

	infile using "highway2.dct"
	
	list
	

* Example 3

	project, original("highway3.dct")

	listfile "highway3.dct"

	infile using "highway3.dct"
	
	list
	

* Example 4

	project, original("emp.dct")

	listfile "emp.dct"

	infile using "emp.dct"
	
	list
	

* Example 5

	project, original("emp2.dct")

	listfile "emp2.dct"

	infile using "emp2.dct", automatic
	
	list
	list, nolabel
	

* Example 6

	project, original("highway6.dct")
	project, original("highway6.raw")

	listfile "highway6.dct"
	listfile "highway6.raw"

	infile using "highway6.dct"
	
	list
	

* Example 7

	project, original("mydata.dct")
	project, original("mydata.raw")

	listfile "mydata.dct"
	listfile "mydata.raw"

	infile using "mydata.dct"
	
	list
	
	
* Example 8

	project, original("mydata2.dct")
	project, original("mydata2.raw")

	listfile "mydata2.dct"
	listfile "mydata2.raw"

	infile using "mydata2.dct", clear
	
	list
	
	project, original("mydata2p.dct")
	infile using "mydata2p.dct", clear
	
	list
	
	
	// technical note
	project, original("highway_tn.dct")

	listfile "highway_tn.dct"

	infile using "highway_tn.dct", automatic
	
	list
	

* Example 9

	project, original("highway_rfff.dct")
	project, original("highway_rfff.raw")

	listfile "highway_rfff.dct"
	listfile "highway_rfff.raw"

	infile using "highway_rfff.dct", clear
	
	list
	

* Example 10

	project, original("fname.dct")
	project, original("fname.txt")

	listfile "fname.dct"
	listfile "fname.txt"

	infile using "fname.dct", clear
	
	list
	

* Example 11

	project, original("example.dct")

	listfile "example.dct"

	infile using "example.dct", clear
	
	list
