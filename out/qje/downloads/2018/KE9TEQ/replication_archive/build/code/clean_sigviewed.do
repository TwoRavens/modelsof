/**************************************************************************
	
	Program: clean_sigviewed.do
	Last Update: February 2018
	JS/DT
	
	This file prepares data files related to significantly viewed pairs. 
	
**************************************************************************/

/**************************************************************************

	1. DMA-level "significantly viewed" data 

**************************************************************************/

	insheet using "$input/fcc/sigviewed_stations.csv", clear
	drop state countyname
	rename statecode state
	rename countycode county
	sort state county
	joinby state county using "$data/xwalk/dma_county_map.dta", unmatched(both)
	assert _merge != 1
	drop if _merge == 2
	drop _merge
	drop if multi_dma == 1
	rename dma_name dma_name_station
	save "$temp/sigviewed_station_dma", replace

/**************************************************************************

	2. County-level "significantly viewed" data 

**************************************************************************/

	insheet using "$input/fcc/sigviewed_stations.csv", clear
	drop state countyname
	rename statecode state
	rename countycode county
	joinby state county using "$data/xwalk/dma_county_map.dta", unmatched(both)
	assert _m != 1
	drop if _merge == 2
	drop _merge
	drop if multi_dma == 1
	sort city
	merge m:m city using "$temp/sigviewed_station_dma.dta"
	assert _m == 3
	drop _merge
	gen sigviewed = (dma_name != dma_name_station)
	collapse (max) sigviewed, by(state county)
	save "$data/sigviewed_counties", replace

**************************************************************************

* END OF FILE
