********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE A1

* START LOG SESSION
	log using "LOGS/TAB_A1", replace

* GENERATE PRE-1870 OBSERVATIONS
	clear
	set obs 3
	gen buildingnumberebn = .
	gen officialname = ""
	gen CC  = .
	gen YEAR = . 
	gen HEIGHT = .
	gen x_build_coord  =. 
	gen y_build_coord = . 
	
	replace buildingnumberebn = 131024 if _n == 1
	replace officialname = "Holy Name Cathedral" if _n == 1
	replace CC = 1850 if _n == 1
	replace YEAR = 1854 if _n == 1
	replace HEIGHT = 74.68 if _n == 1
	replace x_build_coord  = 1176339/5280 if _n == 1
	replace y_build_coord = 1905261/5280 if _n == 1
	
	replace buildingnumberebn = 209289 if _n == 2
	replace officialname = "University Hall" if _n == 2
	replace CC = 1860 if _n == 2
	replace HEIGHT = 17.57 if _n == 2	
	replace YEAR = 1869 if _n == 2
	
	replace buildingnumberebn = 212561 if _n == 3
	replace officialname = "Chicago Water Tower" if _n == 3
	replace CC = 1860 if _n == 3
	replace HEIGHT = 55.63 if _n == 3	
	replace YEAR = 1869 if _n == 3

* APPEND OBSERVATIONS FROM 1850s AND 1860s NOT USED IN REST OF THE ANALYSIS	
	append using  "DATA/BUILDING_LV.dta"	
	
* LOAD DATA
	*u "DATA/BUILDING_LV.dta", clear
	*append using "DATA/BUILDING_1850_60.dta"

	* GENERATE TALLEST BUILDING VARIABLE
		sum YEAR
			local min = r(min)
			local max = r(max)
		forval year = `min'/`max' {	
		gen tallest_`year' = 0
		sum HEIGHT if YEAR <= `year'
			local height = r(max)
			replace tallest_`year' = 1 if HEIGHT == `height' & YEAR <= `year'
			}	
		
	* CONSOLIDATE DATA SET AND RESHAPE		
		keep tallest_* officialname YEAR HEIGHT buildingnumberebn x_ y_
		reshape long tallest_ , i(buildingnumberebn) j(year)
		keep if tallest_ == 1	
		sort year
		duplicates drop officialname YEAR HEIGHT, force
	
	* GENERATE YEARS BEING THE TALLEST VARIABLE
		gen tallest_end= YEAR[_n+1]
		gen tallest_duration = tallest_end - YEAR
		replace tallest_duration = 2015 - YEAR if tallest_duration == .

	* FURTHER CONSOLIDATE DATA, ORDER AND LABEL VARIABlES
		drop buildingnumberebn year tallest_
		gen t_id = _n
		order t_id officialname YEAR tallest_duration HEIGHT
		label var t_id "No."
		label var officialname "Name"
		label var YEAR "Construction year"
		label var tallest_duration "Years being the tallest"
		label var HEIGHT "Height (m)"
	
	* WRITE TABLE A1
		export excel t_id officialname YEAR tallest_duration HEIGHT using "TABS\TAB_A1.xls", firstrow(varlabels) replace
		
* END LOG SESSION
 log close	
