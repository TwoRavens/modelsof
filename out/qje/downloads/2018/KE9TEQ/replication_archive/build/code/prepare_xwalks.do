/**************************************************************************
	
	Program: prepare_xwalks.do
	Last Update: February 2018
	JS/DT
	
	This file prepares crosswalks used in the analysis.
	
**************************************************************************/

/**************************************************************************

	1. DMA Names

**************************************************************************/

	insheet using "$input/xwalk/dma_name_map.csv", clear names
	drop if inlist(nielsen_dma,"ANCHORAGE","FAIRBANKS","JUNEAU")
	
	* Fill in missing values of crosswalk (i.e., NONE[n]) to allow for 1:1 mapping
	gen _nn = _n
	tostring _nn, gen(_ns)
	replace cmag1_dma = "NONE" + _ns if missing(cmag1_dma)
	replace cmag2_dma = "NONE" + _ns if missing(cmag2_dma)
	gen dma_name = county_dma 
	
	* All markets are provided in 2012 data
	gen cmag_sample2012 = 1
	
	foreach var in cmag1_dma cmag2_dma {
		replace `var' = upper(`var')
	}
	
	keep nielsen_dma nielsen_code county_dma cmag1_dma cmag2_dma dma_name cmag_sample* newsbank_dma
	save "$data/xwalk/dma_map", replace

/**************************************************************************

	2. State--County FIPS

**************************************************************************/

	insheet using "$input/xwalk/state_fips_labels.csv", clear
	drop name
	drop if alphacode == ""
	sort alphacode
	save "$data/xwalk/state_crosswalk.dta", replace

/**************************************************************************

	3. DMA--County FIPS; DMA Name--DMA Code 

**************************************************************************/

	insheet using "$input/xwalk/fips_dma_map_addendum.csv", clear names
	tempfile fips_dma_map_addendum
	save `fips_dma_map_addendum'

	insheet using "$input/xwalk/fips_dma_map.csv", clear names
	
	rename fips_state_code state
	rename fips_county_code county
	
	* Replace Counties (see README.txt for known data issues)
	replace dma_code = 656 if state == 12 & county == 59
	replace dma_name = "PANAMA CITY" if state == 12 & county == 59
	
	* Recode Miami-Dade to match census data
	recode county (25=86) if state == 12
	
	* Recode Alaska DMAs 
	drop if state == 2
	
	* Recode Hawaii DMAs
	replace county = 9 if county == 5 & state == 15
	
	keep state county county_name dma_code dma_name
	
	append using `fips_dma_map_addendum'
	duplicates drop 
	order state county
	replace dma_name = subinstr(dma_name," ","",.)
	egen total_dma = total(1), by(state county)
	gen multi_dma = (total_dma > 1)
	sort state county
	
	save "$data/xwalk/dma_county_map.dta", replace
	
	keep dma_name dma_code
	duplicates drop
	save "$data/xwalk/dma_code_map.dta", replace

/**************************************************************************

	4. State Name--State FIPS 

**************************************************************************/

	insheet using "$input/xwalk/state_fips_labels.csv", clear names
	tempfile state_fips_labels
	rename numericcode state_fips
	rename alphacode state
	drop if missing(state) 
	save "$data/xwalk/state_fips_labels.dta", replace
	
/**************************************************************************

	5. State Name, County Name--State-County FIPS 

**************************************************************************/

	copy "$input/xwalk/fips_county_crosswalk.dta" "$data/xwalk/fips_county_crosswalk.dta", replace 

/**************************************************************************

	6. Nielsen Time Interval Impressions (2012 Impressions) 

**************************************************************************/

	insheet using "$input/xwalk/time_interval_dictionary.csv", clear
	save "$data/xwalk/time_interval_dictionary.dta", replace 

**************************************************************************

* END OF FILE
	
