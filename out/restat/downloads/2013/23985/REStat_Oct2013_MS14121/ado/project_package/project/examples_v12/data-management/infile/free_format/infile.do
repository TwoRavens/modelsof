/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("highway1.raw")

	listfile "highway1.raw"

	infile acc_rate spdlimit acc_pts using "highway1.raw"
	
	list
	describe


* Example 2

	project, original("highway2.raw")

	listfile "highway2.raw"

	infile acc_rate spdlimit acc_pts using "highway2.raw"
	
	list


* Example 3

	infile acc_rate int spdlimit acc_pts using "highway1.raw", clear
	
	list
	describe

	infile double(acc_rate spdlimit acc_pts) using "highway1.raw", clear

	list
	describe


* Example 4

	project, original("myfile.raw")
	project, original("myfile2.raw")

	listfile "myfile.raw"
	listfile "myfile2.raw"
	
	infile str20 name age sex using "myfile.raw", clear
	list
	infile str20 name age sex using "myfile2.raw", clear
	list


	infile str20 name age int sex using "myfile.raw", clear
	list
	des
	
	infile str20 name int(age sex) using "myfile.raw", clear
	list
	des
	
	
* Technical note

	project, original("persons.raw")
	
	listfile "persons.raw"

	label define sexfmt 0 "Male" 1 "Female"
	infile str16 name sex:sexfmt age using "persons.raw"
	
	list
	list, nolabel
	
	
	
* Technical note

	project, original("geog.raw")
	
	listfile "geog.raw"
	
	infile str6 region var1 var2 using "geog.raw"
	
	list
	

	infile byte region:regfmt var1 var2 using "geog.raw", automatic clear
	
	list, sep(0)
	
	label list regfmt
	
	
	clear
	label define regfmt 2 "West"
	infile byte region:regfmt var1 var2 using "geog.raw", automatic clear
	
	list, sep(0)
	
	label list regfmt
	
	
* Example 5

	listfile "highway1.raw"

	clear
	infile acc_rate spdlimit _skip using "highway1.raw"
	list
	
	infile acc_rate _skip acc_pts using "highway1.raw", clear
	list
	
	infile acc_rate _skip(2) using "highway1.raw", clear
	
	
* Example 6

	infile acc_rate spdlimit acc_pts if acc_rate>3 using "highway1.raw", clear
	list
	
	infile acc_rate spdlimit acc_pts in 2/4 using "highway1.raw", clear
	list
	
	
* Example 7

	project, original("time.raw")
	
	listfile "time.raw"
	
	infile year amount cost using "time.raw", byvariable(4) clear
	list
	
	project, original("time2.raw")
	
	listfile "time2.raw"
	
	infile year amount cost using "time2.raw", byvariable(100) clear
	list
	