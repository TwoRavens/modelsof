/**************************************************************************
	
	Program: clean_wesleyan.do
	Political Advertising Project
	Last Update: April 2017
	JS/DT
	
	This file prepares data from Wesleyan Advertising Project for analysis.
	
**************************************************************************/

/**************************************************************************

	0. Read in Programs

**************************************************************************/

	include "$code/standardize_cmag.do"

/**************************************************************************

	4. Prepare 2012 Downballot Data

**************************************************************************/

	use "$input/wesleyan/wmp-downballot-2012-v1.1.dta", clear
	gen stata_date = airdate
	gen stata_time = Clock(airtime,"hms")
	replace party = "1" if lower(party) == "democrat"
	replace party = "2" if lower(party) == "republican"
	replace party = "3" if !inlist(party,"1","2")
	rename station distributor
	rename l spotleng
	rename state abbrev
	replace abbrev = "N/A" if missing(abbrev)
	gen scope = "local"
	gen office = "downballot"
	gen ad_id = 0
	gen sponsor = .
	gen statdist = .
	
	merge m:1 abbrev using "$input/xwalk/fips_crosswalk", keep(1 3)
	assert abbrev == "N/A" if _merge == 1
	drop _merge

 	gen year = 2012	
	standardize_cmag 2012 downballot
	save "$temp/wesleyan2012downballot", replace

/**************************************************************************

	5. Prepare 2012 Governor Data

**************************************************************************/

	use "$input/wesleyan/wmp-gov-2012-v1.1.dta", clear
	gen stata_date = airdate
	gen stata_time = Clock(airtime,"hms")
	replace party = "1" if lower(party) == "democrat"
	replace party = "2" if lower(party) == "republican"
	replace party = "3" if !inlist(party,"1","2")
	rename station distributor
	rename l spotleng
	rename state abbrev
	gen scope = "local"
	gen office = "gov"
	gen ad_id = 0
	
	* Recode tone to match previous CMAG designations
	rename ad_tone tone
	recode tone (1=2) (2=3) (3=1)
	recode sponsor (3=4) (4=3)
	
	gen statdist = .
	
	merge m:1 abbrev using "$input/xwalk/fips_crosswalk", keep(1 3) 
	assert missing(abbrev) if _merge == 1
	drop _merge 

	gen year = 2012
	standardize_cmag 2012 gov
	save "$temp/wesleyan2012gov", replace
	
	
/**************************************************************************

	6. Prepare 2012 House Data

**************************************************************************/

	use "$input/wesleyan/wmp-house-2012-v1.1.dta", clear
	gen stata_date = airdate
	gen stata_time = Clock(airtime,"hms")
	replace party = "1" if lower(party) == "democrat"
	replace party = "2" if lower(party) == "republican"
	replace party = "3" if !inlist(party,"1","2")
	rename station distributor
	rename l spotleng
	rename state abbrev
	gen scope = "local"
	gen office = "gov"
	gen ad_id = 0
	
	* Recode tone to match previous CMAG designations
	rename ad_tone tone
	recode tone (1=2) (2=3) (3=1)
	recode sponsor (3=4) (4=3)
		
	merge m:1 abbrev using "$input/xwalk/fips_crosswalk", keep(3) assert(2 3) nogen
	
	destring district, replace
	gen statdist = 100*fips + district
	
	gen year = 2012
	standardize_cmag 2012 house
	save "$temp/wesleyan2012house", replace

/**************************************************************************

	7. Prepare 2012 Senate Data

**************************************************************************/

	use "$input/wesleyan/wmp-senate-2012-v1.1.dta", clear
	gen stata_date = airdate
	gen stata_time = Clock(airtime,"hms")
	replace party = "1" if lower(party) == "democrat"
	replace party = "2" if lower(party) == "republican"
	replace party = "3" if !inlist(party,"1","2")
	rename station distributor
	rename l spotleng
	rename state abbrev
	gen scope = "local"
	gen office = "senate"
	gen ad_id = 0
	gen statdist = .
	
	* Recode tone to match previous CMAG designations
	rename ad_tone tone
	recode tone (1=2) (2=3) (3=1)
	recode sponsor (3=4) (4=3)
		
	merge m:1 abbrev using "$input/xwalk/fips_crosswalk", keep(3) assert(2 3) nogen
	
	gen year = 2012
	standardize_cmag 2012 senate
	save "$temp/wesleyan2012senate", replace

/**************************************************************************

	8. Prepare 2012 Presidential Data

**************************************************************************/

	use "$input/wesleyan/wmp-pres-2012-v1.0.dta", clear
	drop if inlist(market,"NATIONAL CABLE","NATIONAL NETWORK")
	gen scope = "local"
	gen ad_id = 0
	append using "$temp/wesleyan2012pres_national"
	gen month = substr(airdate,1,2)
	gen day = substr(airdate,4,2)
	gen year = substr(airdate,7,4)
	destring month day year, replace
	gen stata_date = mdy(month,day,year)
	drop year month
	gen stata_time = Clock(airtime,"hms")
	gen party = "1" if lower(affiliation) == "democrat"
	replace party = "2" if lower(affiliation) == "republican"
	replace party = "3" if !inlist(party,"1","2")
	rename station distributor
	rename l spotleng
	gen fips = .
	gen office = "pres"
	gen statdist = .
	
	* Recode tone and sponsor to match previous CMAG designations
	rename ad_tone tone
	recode tone (1=2) (2=3) (3=1)
	rename sponsorwmp sponsor
	recode sponsor (3=4) (4=3)
		
	gen year = 2012
	standardize_cmag 2012 pres
	save "$temp/wesleyan2012pres", replace
	
**************************************************************************/

* END OF FILE
