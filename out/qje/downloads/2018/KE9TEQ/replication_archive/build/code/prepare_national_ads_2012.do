/**************************************************************************
	
	Program: prepare_national_ads.do
	Last Update: February 2018
	JS/DT
	
	This files is used to project 2012  national advertisements to local markets. 
	
**************************************************************************/

	use market affiliate station using "$input/wesleyan/wmp-pres-2012-v1.0.dta", clear
	append using "$input/wesleyan/wmp-senate-2012-v1.1.dta", keep(market affiliate station)
	append using "$input/wesleyan/wmp-house-2012-v1.1.dta", keep(market affiliate station)
	append using "$input/wesleyan/wmp-gov-2012-v1.1.dta", keep(market affiliate station)
	drop if inlist(market,"NATIONAL CABLE","NATIONAL NETWORK")
	keep market affiliate station
	duplicates drop
	save "$temp/markets2012", replace

	use "$input/wesleyan/wmp-pres-2012-v1.0.dta", clear
	keep if inlist(market,"NATIONAL CABLE","NATIONAL NETWORK")
	drop market station
	gen ad_id = _n
	joinby affiliate using "$temp/markets2012"
	gen scope = "national"
	save "$temp/wesleyan2012pres_national", replace

**************************************************************************/

* END OF FILE



