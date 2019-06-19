/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/college.dta")
	use "`pdir'/data/stata/college.dta"
	
	describe
	
	list, sep(4)
	
	collapse (p25) gpa [fw=number], by(year)
	
	list
	
		
	use "`pdir'/data/stata/college.dta", clear
	collapse gpa hour [fw=number], by(year)
	list

		
	use "`pdir'/data/stata/college.dta", clear
	collapse (mean) gpa hour (median) medgpa=gpa medhour=hour [fw=number], by(year)
	list

		
	use "`pdir'/data/stata/college.dta", clear
	collapse (count) gpa hour (min) mingpa=gpa minhour=hour [fw=number], by(year)
	list


	use "`pdir'/data/stata/college.dta", clear
	replace gpa = . in 2/4
	list, sep(4)
	collapse gpa hour [fw=number], by(year)
	list


	use "`pdir'/data/stata/college.dta", clear
	replace gpa = . in 2/4
	collapse (mean) gpa hour [fw=number], by(year) cw
	list
	
	
* Example 2

	// no data
	
	
* Example 3

	// no data
	
	
* Example 4

	// no data
	
	
* Example 5

	project, original("`pdir'/data/stata/census5.dta")
	use "`pdir'/data/stata/census5.dta"
	
	describe
	
	list, sepby(region)
	
	collapse (median) median_age marriage_rate divorce_rate (mean) avgmrate=marriage_rate ///
		avgdrate=divorce_rate [aw=pop], by(region)

	list
	
	describe
