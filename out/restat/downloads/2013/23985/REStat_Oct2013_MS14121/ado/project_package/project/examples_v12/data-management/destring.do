/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/destring1.dta")
	use "`pdir'/data/stata/destring1.dta"
	
	describe
	
	list
	
	destring, replace
	
	describe
	
	list
	
	
* Example 2

	project, original("`pdir'/data/stata/destring2.dta")
	use "`pdir'/data/stata/destring2.dta"

	describe date
	
	list date
	
	destring date, replace ignore(" ")
	
	describe date
	
	list date
	

* Example 3

	use "`pdir'/data/stata/destring2.dta", clear
	
	describe
	
	list
	
	destring date price percent, generate(date2 price2 percent2) ignore("$ ,%")
	
	char list
	
	describe
	
	list
	

* Example 4

	project, original("`pdir'/data/stata/tostring.dta")
	use "`pdir'/data/stata/tostring.dta"
	
	list
	
	tostring year day, replace
	generate date = month + "/" + day + "/" + year
	generate edate = date(date, "MDY")
	format edate %td
	
	list
