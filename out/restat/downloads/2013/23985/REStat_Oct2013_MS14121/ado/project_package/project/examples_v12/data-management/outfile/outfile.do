/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("emp.dta")
	use "emp.dta"
	
	list
	
	
	outfile using "employee.raw", replace
	project, creates("employee.raw")
	
	type "employee.raw"


	// technical note
	use "emp.dta"
	outfile using "employee2.raw", replace nolabel
	project, creates("employee2.raw")
	
	type "employee2.raw"


	// technical note
	use "emp.dta"
	outfile using "employee3.raw", replace noquote
	project, creates("employee3.raw")
	
	type "employee3.raw"


* Example 2

	use "emp.dta"
	outfile using "employee4.raw", comma replace
	project, creates("employee4.raw")
	
	type "employee4.raw"


* Example 3

	use "emp.dta"
	outfile using "employee5.raw", dict replace
	project, creates("employee5.raw")
	
	type "employee5.raw"

	
* Example 4

	project, original("`pdir'/data/stata/outfilexmpl.dta")
	use "`pdir'/data/stata/outfilexmpl.dta"
	
	describe
	list
	
	outfile using "sp.raw", replace
	project, creates("sp.raw")

	type "sp.raw"
