/**************************************************************************
	
	Program: clean_geolytics.do
	Last Update: January 2018
	JS/DT
	
	This file prepares Geolytics data used in the analysis.
	
**************************************************************************/

/**************************************************************************

	1. 2000

**************************************************************************/

	* Append data together
	local myfilelist: dir "$input/geolytics/geolytics_extract_2000/" files "*.csv"
	local counter = 0
	foreach file of local myfilelist {
		local counter = `counter' + 1
		tempfile temp`counter'
		insheet using "$input/geolytics/geolytics_extract_2000/`file'", clear 
		save `temp`counter''
	}
	clear
	gen areakey =.
	forvalues n = 1/`counter' {
		append using `temp`n''
	}

	* Recode Data
	gen pop_25 = p037001
	egen edu_dropout_25 = rowtotal(p037003-p037010 p037020-p037027)
	egen edu_hsplus_25 = rowtotal(p037011-p037013 p037028-p037030)
	egen edu_colplus_25 = rowtotal(p037014-p037018 p037031-p037035)
	gen edu_dropout2000 = edu_dropout_25/pop_25
	gen edu_hsplus2000 = edu_hsplus_25/pop_25
	gen edu_colplus2000 = edu_colplus_25/pop_25
	keep state county *2000 
	save "$temp/year2000.dta", replace

	
/**************************************************************************

	2. 2010

**************************************************************************/
	
	* Append data together
	local myfilelist: dir "$input/geolytics/geolytics_extract_2010/" files "*.csv"
	local counter = 0
	foreach file of local myfilelist {
		local counter = `counter' + 1
		tempfile temp`counter'
		insheet using "$input/geolytics/geolytics_extract_2010/`file'", clear 
		save `temp`counter''
	}
	clear
	gen areakey = .
	forvalues n = 1/`counter' {
		append using `temp`n''
	}
	
	* Recode data
	gen state = floor(areakey/1000)
	gen county = mod(areakey,1000)
	egen edu_dropout_25 = rowtotal(eeat_*os eeat_*n4g eeat_*56g eeat_*78g eeat_*9g eeat_*10g eeat_*11g eeat_*12n)
	egen edu_hsplus_25 = rowtotal(eeat_*hsc eeat_*cg1 eeat_*cg1p)
	egen edu_colplus_25 = rowtotal(eeat_*asd eeat_*bac eeat_*mas eeat_*pro eeat_*doc)
	gen pop_25 = eeat_pop25p
	gen edu_dropout2010 = edu_dropout_25/pop_25
	gen edu_hsplus2010 = edu_hsplus_25/pop_25
	gen edu_colplus2010 = edu_colplus_25/pop_25 
	keep state county *2010 
	save "$temp/year2010.dta", replace
	

/**************************************************************************

	2. Merge 2000 and 2010 data

**************************************************************************/

	use "$temp/year2000.dta", clear
	merge 1:1 state county using "$temp/year2010.dta"
	/*CHECK*/
	assert state == 51 & county == 560 if _merge == 1
	assert state == 8 & county == 14 if _merge == 2	
	drop _merge
	
	global variables "edu_dropout edu_hsplus edu_colplus"
	
	* Impute using one value if the year is missing
	foreach var of global variables {
		replace `var'2000 = `var'2010 if missing(`var'2000)
		replace `var'2010 = `var'2000 if missing(`var'2010)
		gen `var'2004 = 0.6*`var'2000 + 0.4*`var'2010
		gen `var'2008 = 0.2*`var'2000 + 0.8*`var'2010

	}

	keep state county *2004 *2008 

	reshape long $variables, i(state county) j(year)

	save "$data/geolytics.dta", replace
	
**************************************************************************/

* END OF FILE	