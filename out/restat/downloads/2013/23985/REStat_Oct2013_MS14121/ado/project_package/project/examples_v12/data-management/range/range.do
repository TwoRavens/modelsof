/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	range x 0 12.56 100
	generate y = exp(-x/6)*sin(x)
	scatter y x, yline(0) ytitle(y = exp(-x/6) sin(x))
	
	// export to PNG format
	graph export "`dofile'_example1.png", width(1200) replace
	project, creates("`dofile'_example1.png")


* Example 2

	clear
	range theta 0 2*_pi 400
	generate r = 2*sin(2*theta)
	generate y = r*sin(theta)
	generate x = r*cos(theta)
	line y x, yline(0) xline(0) aspectratio(1)
	
	// export to PNG format
	graph export "`dofile'_example2.png", width(1200) replace
	project, creates("`dofile'_example2.png")
	