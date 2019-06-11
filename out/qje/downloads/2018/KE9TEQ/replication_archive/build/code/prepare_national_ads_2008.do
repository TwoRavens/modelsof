/**************************************************************************
	
	Program: prepare_national_ads.do
	Last Update: February 2018
	JS/DT
	
	This files is used to project 2008 national advertisements to local markets. 
	
**************************************************************************/

	use "$input/cmag/cmag2008pres", clear
	append using "$input/cmag/cmag2008nonpres"
	drop if inlist(market,"National","Cable")
	keep market affiliate station
	duplicates drop
	save "$temp/markets2008", replace

	use "$input/cmag/cmag2008pres", clear
	keep if inlist(market,"National","Cable")
	drop market station
	gen ad_id = _n
	joinby affiliate using "$temp/markets2008"
	gen scope = "national"
	save "$temp/cmag2008pres_national", replace

**************************************************************************/

* END OF FILE



