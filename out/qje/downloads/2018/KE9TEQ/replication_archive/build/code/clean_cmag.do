/**************************************************************************
	
	Program: clean_cmag.do
	Last Update: July 2016
	JS/DT
	
	This file prepares Kantar Media (CMAG) data for analysis.
	
**************************************************************************/

	include "$code/standardize_cmag.do"

/**************************************************************************

	1. Prepare 2004 CMAG Presidential Data

**************************************************************************/

	use "$input/cmag/cmag2004pres", clear
	rename EAD_TONE tone
	rename Party party
	rename Sponsor sponsor
	rename StatDist statdist
	rename station distributor
	rename date stata_date
	recode party (98=3) (0=3) 
	gen office = "pres"
	gen stata_time = clock(airtime,"hms")
	gen scope = "local"
	gen ad_id = 0
	gen year = 2004
	standardize_cmag 2004 pres
	save "$temp/cmag2004pres", replace

/**************************************************************************

	2. Prepare 2004 CMAG Non-Presidential Data

**************************************************************************/

	use "$input/cmag/cmag2004nonpres", clear
	rename ead_tone tone
	rename station distributor
	rename date stata_date
	rename airtime stata_time
	tostring office, replace force
	replace office = "senate" if office == "2"
	replace office = "house" if office == "3"
	replace office = "gov" if office == "4"
	replace party = "1" if party == "D"
	replace party = "2" if party == "R"
	replace party = "3" if inlist(party,"L","I","")
	gen scope = "local"
	gen ad_id = 0
	gen year = 2004
	standardize_cmag 2004 nonpres
	save "$temp/cmag2004nonpres", replace

/**************************************************************************

	3. Prepare 2008 CMAG Presidential Data

**************************************************************************/

	use "$input/cmag/cmag2008pres.dta", clear
	drop if STATE_1 == "NATIONAL"
	gen scope = "local"
	gen ad_id = 0
	append using ../temp/cmag2008pres_national
	rename STATE_1 alphacode 
	rename l spotleng
	rename AD_TONE tone
	rename EST_SPENDING est_cost
	rename station distributor
	merge m:1 alphacode using "$data/xwalk/state_crosswalk.dta", keep(1 3) nogenerate
	rename numericcode fips
	* Reassign dates when year = 200 to 2007 or 2008 based on Weeks_To variable
	gen temp_date = date(date,"MDY")
	gen month = month(temp_date)
	gen day = day(temp_date)
	gen year = year(temp_date)
	replace year = 2008 if year == 200 & Weeks_To < 10
	replace year = 2007 if year == 200 & Weeks_To > 40
	assert inlist(year,2007,2008)
	gen stata_date = mdy(month,day,year)
	gen stata_time = Clock(time,"hms")
	recode party (98=3) (99=3) (.=3)
	gen office = "pres"
	standardize_cmag 2008 pres
	save "$temp/cmag2008pres.dta", replace

/**************************************************************************

	4. Prepare 2008 CMAG Non-Presidential Data

**************************************************************************/

	use "$input/cmag/cmag2008nonpres.dta", clear
	gen fips = floor(statdist/100)
	gen stata_date = date(date,"MDY")
	gen stata_time = Clock(time,"hms")
	tostring office, replace force
	replace office = "senate" if office == "1"
	replace office = "house" if office == "2"
	replace office = "gov" if office == "3"
	recode party (4=3) (90=3) (.=3)
	rename AD_TONE tone
	rename station distributor
	rename l spotleng
	rename EST_SPENDING est_cost
	gen scope = "local"
	gen ad_id = 0
	gen year = 2008
	standardize_cmag 2008 nonpres
	save "$temp/cmag2008nonpres.dta", replace

***************************************************************************

* END OF FILE
