/**************************************************************************
	
	Program: collapse_nielsen_impressions_2012.do
	Last Update: January 2018
	JS/DT
	
	This file prepares AdIntel impressions data Nielsen.
	
**************************************************************************/

/**************************************************************************

	1. Prepare distributor crosswalk
	
**************************************************************************/
/*
	insheet using "$input/nielsen/2012/AdIntel/Distributor.tsv", clear
	keep distributorcode abbreviation
	drop if inlist(substr(distributorcode,1,1),"I","N")
	save "$temp/distributor_crosswalk_code_id", replace
	
	* See create_nielsen_distributors.bsh
	insheet using "$temp/AdIntel_SpotTV_Distributors.txt", clear
	duplicates drop	
	merge 1:1 distributorcode using "$temp/distributor_crosswalk_code_id", keep(3) keepusing(abbreviation)
	rename abbreviation distributor
	keep distributorid distributor
	destring distributorid, replace
	drop if missing(distributorid)
	save "$temp/distributor_crosswalk_name_id", replace

/**************************************************************************

	2. Collapse impressions data
	
**************************************************************************/	

	insheet using "$input/nielsen/2012/AdIntel/ImpSpotTV.tsv", clear
		
	egen tv_pp = rowtotal(children_* female_* male_*) 
	
	foreach var in male female {
		gen `var'_adj_2_5 = children_2_5/2
		gen `var'_adj_6_11 = children_6_11/2
			egen tv_pp_`var'_2_plus = rowtotal(`var'*)
		egen tv_pp_`var'_18_34 = rowtotal(`var'_18_20 `var'_21_24 `var'_25_34)
		egen tv_pp_`var'_35_64 = rowtotal(`var'_35_49 `var'_50_54 `var'_55_64)
		egen tv_pp_`var'_65_plus = rowtotal(`var'_65_plus)
		egen tv_pp_`var'_35_plus = rowtotal(tv_pp_`var'_35_64 tv_pp_`var'_65_plus)
		egen tv_pp_`var'_18_plus = rowtotal(tv_pp_`var'_18_34 tv_pp_`var'_35_plus)
	}

	foreach type in 2_plus 18_34 35_64 65_plus 35_plus 18_plus {
		egen tv_pp_all_`type' = rowtotal(tv_pp_female_`type' tv_pp_male_`type')
	}

	rename periodyearmonth year_month
	
	rename timeintervalnumber time_interval_number
	
	rename uc_dim_bridge_occ_impspottv_key key
	
	collapse (sum) tv_hh* tv_pp*, by(distributorid year_month time_interval_number dayofweek key)
	
	merge m:1 distributorid using "$temp/distributor_crosswalk_name_id", keep(3) keepusing(distributor)

	save "$data/nielsen/nielsen_ratings2012", replace

	drop if missing(key)

	save "$data/nielsen/nielsen_ratings2012_key", replace
*/	
/**************************************************************************

	3. Collapse impressions data to spotkey level
	
**************************************************************************/	

	import delimited using "$temp/AdIntel_SpotTV.txt", varnames(1) clear
	
	gen hour = substr(adtime,1,2)
	gen minute = substr(adtime,4,2) 

	gen year = substr(addate,1,4)
	gen month = substr(addate,6,2)
	gen day = substr(addate,9,2)
	
	destring hour minute year month day, replace
		
	gen date = mdy(month,day,year)
	format date %td
	
	gen hour_interval = hour
	
	gen minute_interval = 15 if inrange(minute,3,14)
	replace minute_interval = 28 if inrange(minute,15,27)
	replace minute_interval = 33 if inrange(minute,28,32)
	replace minute_interval = 45 if inrange(minute,33,44)
	replace minute_interval = 58 if inrange(minute,45,57)
	replace minute_interval = 0 if inrange(minute,58,59)
	replace hour_interval = hour_interval + 1 if minute_interval == 0
	replace date = date + 1 if hour_interval == 24
	recode hour_interval (24=0)
	replace minute_interval = 3 if inrange(minute,0,2) 
	
	rename uc_dim_bridge_occ_impspottv_key key
	
	collapse (min) key_min=key (max) key_max=key, by(distributorid minute_interval hour_interval date)
		
	merge m:1 hour_interval minute_interval using "$data/xwalk/time_interval_dictionary.dta", assert(2 3) keep(3) nogenerate keepusing(time_interval_number)	
		
	save "$temp/nielsen_spotkey_ratings2012_full.dta", replace

	collapse (mean) time_interval_number (min) key_min=key_min (max) key_max=key_max, by(distributorid minute_interval hour_interval date)
	
	assert key_min == key_max
	drop key_min
	rename key_max key
	rename date date_interval

	merge m:1 key using "$data/nielsen/nielsen_ratings2012_key", keep(3) nogen
	
	save "$data/nielsen/nielsen_spotkey_ratings2012_full", replace
	
**************************************************************************

* END OF FILE
