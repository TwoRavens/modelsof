/**************************************************************************
	
	Program: clean_factiva.do
	Last Update: January 2018
	JS/DT
	
	This file prepares Factiva data used in the analysis.
	
**************************************************************************/

/**************************************************************************

	1. Assemble Raw Factiva Data

**************************************************************************/

*Crosswalk between AAM and Factiva data

	tempfile xwalk_factiva_AAM
	import excel "$input/factiva/factiva_AAM_crosswalk.xlsx", sheet("Sheet1") firstrow clear
	save `xwalk_factiva_AAM'

*Crosswalk between couny names and fips codes

	tempfile xwalk_county
	use "$data/xwalk/fips_county_crosswalk.dta", clear
	replace county_name=strupper(subinstr(county_name," ","",.))
	replace state_name=strupper(state_name)
	save `xwalk_county'

	
/**************************************************************************

	2. Assemble 2004 Data

**************************************************************************/

	tempfile SP2004
	clear
	import excel "$input/factiva/raw/2004_SmallNewspapers.xlsx", sheet("1") firstrow
	gen YEAR=2004
	save `SP2004'

	tempfile TP2004
	clear
	import excel "$input/factiva/raw/2004_TopNewspapers.xlsx", sheet("1") firstrow
	gen YEAR=2004
	save `TP2004'  
		
	use `TP2004'
	append using `SP2004'
	
	merge m:1 Source using `xwalk_factiva_AAM', keep(3) nogenerate
	
	collapse (sum) DocumentCount, by(MEMBERNUMBER YEAR)

	destring MEMBERNUMBER, replace

	tempfile factiva_2004
	save `factiva_2004'
	
	use "$input/newspaper/fall2004_county.dta", clear

	collapse (mean) MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY SATURDAY SUNDAY, by(MEMBERNUMBER STATE COUNTY)
	egen circ=rowmean(MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY SATURDAY SUNDAY)
	keep if !mi(circ)
	replace circ=round(circ)

	gen YEAR=2004

	destring MEMBERNUMBER, replace
	merge m:1 MEMBERNUMBER YEAR using `factiva_2004', keep(3) nogenerate
	
	collapse (mean) DocumentCount [fw= circ], by(STATE COUNTY YEAR)

	compress

	replace STATE=strupper(STATE)
	rename STATE state_name
	rename COUNTY county_name
	replace county_name=strupper(subinstr(county_name," ","",.))

	drop if state_name=="ALASKA"

	merge m:1 state_name county_name using `xwalk_county', keep(3) nogenerate

	rename (YEAR DocumentCount) (year document_count)
	compress

	save "$data/2004/factiva_newspaper_coverage.dta", replace


/**************************************************************************

	3. Assemble 2008 Data

**************************************************************************/

	*Import data
	forvalues d=1(1)31 {
		
		tempfile SP2008Oct`d'
		
		import excel "$input/factiva/raw/2008_SmallNewspapers_Oct`d'.xlsx", sheet("1") firstrow clear
		gen YEAR=2008
		
		save `SP2008Oct`d''

	}

	tempfile SP2008Nov
	clear
	import excel "$input/factiva/raw/2008_SmallNewspapers_Nov.xlsx", sheet("1") firstrow
	gen YEAR=2008
	save `SP2008Nov'

	tempfile SP2008Sep1
	clear
	import excel "$input/factiva/raw/2008_SmallNewspapers_Sep_5-15.xlsx", sheet("1") firstrow
	gen YEAR=2008
	save `SP2008Sep1'

	tempfile SP2008Sep2
	clear
	import excel "$input/factiva/raw/2008_SmallNewspapers_Sep_16-30.xlsx", sheet("1") firstrow
	gen YEAR=2008
	save `SP2008Sep2'

	
	tempfile TP2008
	clear
	import excel "$input/factiva/raw/2008_TopNewspapers.xlsx", sheet("1") firstrow
	gen YEAR=2008
	save `TP2008'  
	
	use `TP2008'
	append using `SP2008Sep1'
	append using `SP2008Sep2'
	append using `SP2008Nov'
	forvalues d=1(1)31 {
		append using `SP2008Oct`d''   
	}
	
	keep Source DocumentCount YEAR

	merge m:1 Source using `xwalk_factiva_AAM', keep(3) nogenerate
	
	collapse (sum) DocumentCount, by(MEMBERNUMBER YEAR)

	destring MEMBERNUMBER, replace

	tempfile factiva_2008
	save `factiva_2008'

	* 2008

	use "$input/newspaper/fall2008_county.dta", clear

	gen circ=max(DAILY,AVERAGE)
	keep if !mi(circ)

	gen YEAR=2008

	merge m:1 MEMBERNUMBER YEAR using `factiva_2008', keep(3) nogenerate
	collapse (mean) DocumentCount [fw= circ], by(STATE COUNTY YEAR)

	compress
	tempfile coverage2008
	save `coverage2008'

	replace STATE=strupper(STATE)
	rename STATE state_name
	rename COUNTY county_name
	replace county_name=strupper(subinstr(county_name," ","",.))

	drop if state_name=="ALASKA"

	merge m:1 state_name county_name using `xwalk_county', keep(3) nogenerate

	rename (YEAR DocumentCount) (year document_count)
	compress

	save "$data/2008/factiva_newspaper_coverage.dta", replace


/**************************************************************************

	4. Assemble 2012 Data

**************************************************************************/


	forvalues d=1(1)31 {
		
		tempfile SP2012Oct`d'
		
		import excel "$input/factiva/raw/2012_SmallNewspapers_Oct`d'.xlsx", sheet("1") firstrow clear
		gen YEAR=2012
		
		save `SP2012Oct`d''

	}
	
	tempfile TP2012
	clear
	import excel "$input/factiva/raw/2012_TopNewspapers.xlsx", sheet("1") firstrow
	gen YEAR=2012
	save `TP2012'  
	
	use `TP2012'
	forvalues d=1(1)31 {
		append using `SP2012Oct`d''   
	}
	
	keep Source DocumentCount YEAR

	merge m:1 Source using `xwalk_factiva_AAM', keep(3) nogenerate
	
	collapse (sum) DocumentCount, by(MEMBERNUMBER YEAR)

	destring MEMBERNUMBER, replace

	tempfile factiva_2012
	save `factiva_2012'

	use "$input/newspaper/fall2012_county.dta", clear

	gen circ=max(DAILY,COMBINEDAVERAGE)
	keep if !mi(circ)

	gen YEAR=2012

	merge m:1 MEMBERNUMBER YEAR using `factiva_2012', keep(3) nogenerate
	collapse (mean) DocumentCount [fw= circ], by(STATE COUNTY YEAR)

	compress
	tempfile coverage2012
	save `coverage2012'

	compress

	replace STATE=strupper(STATE)
	rename STATE state_name
	rename COUNTY county_name
	replace county_name=strupper(subinstr(county_name," ","",.))

	drop if state_name=="ALASKA"

	merge m:1 state_name county_name using `xwalk_county', keep(3) nogenerate

	rename (YEAR DocumentCount) (year document_count)
	compress

	save "$data/2012/factiva_newspaper_coverage.dta", replace
		
**************************************************************************

* END OF FILE
