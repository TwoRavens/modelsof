/**************************************************************************
	
	Program: clean_newspaper.do
	Last Update: July 2016
	JS/DT
	
**************************************************************************/


	foreach yr in 2004 2008 2012 {

		use "$input/newspaper/newspapers`yr'.dta", clear
		
		rename STATE state_name
		rename COUNTY county_name
		rename SLANT newspaper_slant
		rename TOTCOUNT newspaper_phrase
		
		replace state_name = proper(state_name)
		replace state_name = "District of Columbia" if state_name == "District Of Columbia"
		replace county_name = upper(county_name)
		replace county_name = "DE BACA" if county_name == "DEBACA"
		replace county_name = "LASALLE" if county_name == "LA SALLE" & state_name == "Illinois"
		replace county_name = "LAPORTE" if county_name == "LA PORTE" & state_name == "Indiana"
		replace county_name = "DEKALB" if county_name == "DE KALB" & state_name == "Indiana"
		
		replace county_name = subinstr(county_name,"SAINT","ST.",.) if state_name == "Louisiana"
		
		drop if inlist(county_name,"CLIFTON FORGE CITY","SOUTH BOSTON CITY") | state_name == "Alaska"
		
		merge 1:1 state_name county_name using "$data/xwalk/fips_county_crosswalk", assert(2 3) keep(3) nogenerate		
		
		keep state county newspaper_slant newspaper_phrase
		gen year = `yr'
		
		save "$temp/newspapers`yr'.dta", replace
		
	}
	
	clear
	append using "$temp/newspapers2004.dta"
	append using "$temp/newspapers2008.dta"
	append using "$temp/newspapers2012.dta"
	
	save "$data/newspapers.dta", replace

**************************************************************************

* END OF FILE





