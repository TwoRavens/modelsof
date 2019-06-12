/**************************************************************************
	
	Program: clean_bls.do
	Last Update: January 2018
	JS/DT
	
	This file prepares US Census data for analysis.
	
**************************************************************************/

	foreach year in 2004 2008 2012 {
	
		local yearstub = substr("`year'",3,2)

		clear
		
		infile using laucnty.dct, using("$input/bls/laucnty`yearstub'.txt")
		
		drop if missing(state)
		
		* Drop all header information
		drop in 1/3
		destring *, replace ignore(",")
		
		* Replace Oglala County, SD with Shannon County, SD
		* http://oglalalakota.sdcounties.org/
		replace county = 113 if county == 102 & state == 46 
		
		* Use Bedford County unemployment rate for Bedford City
		expand 2 if county == 19 & state == 51, gen(temp_expand)
		replace county = 515 if temp_expand
		drop temp_expand

		gen lfp = employed/labor_force
		
		save "$data/`year'/employment.dta", replace	

	}
		
**************************************************************************

* END OF FILE
