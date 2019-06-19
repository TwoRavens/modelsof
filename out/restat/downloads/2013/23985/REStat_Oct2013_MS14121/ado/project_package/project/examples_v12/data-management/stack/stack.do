/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/stackxmpl.dta")
	use "`pdir'/data/stata/stackxmpl.dta"
	
	list

	stack a b c d, into(e f) clear
	
	list


* Example 2

	use "`pdir'/data/stata/stackxmpl.dta", clear
	
	stack a b a c, into(a bc) clear
	
	list
	
	
	use "`pdir'/data/stata/stackxmpl.dta", clear
	stack a b a c, group(2) clear
	list

	
	use "`pdir'/data/stata/stackxmpl.dta", clear
	stack a b a c, into(a b) clear
	list


* Example 3

	use "`pdir'/data/stata/stackxmpl.dta", clear
	
	stack a b c d, into(e f) clear wide
	
	list


* Example 4

	use "`pdir'/data/stata/stackxmpl.dta", clear
	
	stack a b a c, into(a bc) clear wide

	list


* Example 5

	// no data


* Example 6


	project, original("`pdir'/data/stata/citytemp.dta")
	use "`pdir'/data/stata/citytemp.dta"

	cumul tempjan, gen(cjan)
	cumul tempjuly, gen(cjuly)
	

	// Make sure that the data is in the same order at every run. If not,
	// the PNG will be different.
	sort cjan tempjan
	scatter cjan tempjan, c(l) m(o)
	
	
	// export to PNG format
	graph export "`dofile'_example6.png", width(1200) replace
	project, creates("`dofile'_example6.png") preserve
	
	
	
	stack cjuly tempjuly cjan tempjan, into(c temp) clear
	generate cjan = c if _stack==1
	generate cjuly = c if _stack==2
	// Make sure that the data is in the same order at every run. If not,
	// the PNG will be different.
	sort cjan cjuly temp
	scatter cjan cjuly temp, c(l l) m(o o)
	// export to PNG format
	graph export "`dofile'_example6b.png", width(1200) replace
	project, creates("`dofile'_example6b.png")
	
	
	use "`pdir'/data/stata/citytemp.dta"
	cumul tempjan, gen(cjan)
	cumul tempjuly, gen(cjuly)
	stack cjuly tempjuly cjan tempjan, into(c temp) clear wide
	// Make sure that the data is in the same order at every run. If not,
	// the PNG will be different.
	sort cjan cjuly temp
	scatter cjan cjuly temp, c(l l) m(o o)
	
	// export to PNG format
	graph export "`dofile'_example6c.png", width(1200) replace
	project, creates("`dofile'_example6c.png")
	
	
	// technical note
	use "`pdir'/data/stata/citytemp.dta"
	cumul tempjan, gen(cjan)
	cumul tempjuly, gen(cjuly)
	stack cjuly tempjuly cjan tempjan, into(c temp) clear
	
	// Make sure that the data is in the same order at every run. If not,
	// the PNG will be different.
	sort _stack c temp, stable
	scatter c temp if !mi(temp), c(L) m(o)
	
	// export to PNG format
	graph export "`dofile'_example6d.png", width(1200) replace
	project, creates("`dofile'_example6d.png") preserve
