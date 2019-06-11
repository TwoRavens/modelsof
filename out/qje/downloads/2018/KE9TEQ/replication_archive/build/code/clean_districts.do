/**************************************************************************
	
	Program: clean_districts.do
	Last Update: January 2018
	JS/DT
	
	This file prepares Congressional district data used in the analysis.
	
**************************************************************************/

	foreach year in 2004 2008 2012 {
	
		use "$input/congressional_districts/COUNTIES_DISTRICTS`year'_MAXAREA.dta", clear
		rename statefp state
		rename countyfp county
		rename max_frac cd_pct_max
		rename district cd_max
		gen year = `year'
		destring state county cd_*, replace
		keep state county year cd_*

		save "$data/`year'/congressional_districts.dta", replace

	}
		
**************************************************************************/

* END OF FILE
