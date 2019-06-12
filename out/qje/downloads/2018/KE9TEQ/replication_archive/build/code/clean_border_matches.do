/**************************************************************************
	
	Program: clean_border_matches.do
	Last Update: July 2016
	JS/DT
	
	This file prepares data files related to county border pairs. 
	
**************************************************************************/

/**************************************************************************

	1. Recode Border Pairs 

**************************************************************************/

	insheet using "$input/geocode/border_matches.csv", clear name
	rename county fips1
	rename v2 fips2
	* Remove matches from Clifton Forge County, VA or Kalawao County, HI
	drop if inlist(fips1, 51560, 15005) | inlist(fips2, 51560, 15005)
	foreach n in 1 2 {
		gen state = floor(fips`n'/1000)
		gen county = mod(fips`n',1000)
		* Remove Alaska and Other Territories
		drop if inlist(state,2,72,.)
		sort state county
		merge m:m state county using "$data/xwalk/dma_county_map.dta", keepusing(dma_code dma_name multi_dma)
		rename dma_code dma_code`n'
		rename dma_name dma_name`n'
		rename multi_dma multi_dma`n'
		rename state state`n'
		rename county county`n'
		drop _merge 
	}
	drop if dma_code1 >= dma_code2 | multi_dma1 == 1 | multi_dma2 == 1
	gen state_pair = _n
	keep state* county* dma_code* dma_name* state_pair
	gen within_state = (state1 == state2)
	reshape long state county, i(state_pair within_state dma_code* dma_name*) j(rank)
	drop rank
	sort state county
	save "$data/border_pairs.dta", replace

/**************************************************************************

	2. Border Segment FE

**************************************************************************/
	
	import excel using "$input/geocode/county_nearest_border.xlsx", clear firstrow
	rename STATEFP  state
	rename COUNTYFP county
	egen segment = group(LEFT_FID RIGHT_FID)
	keep state county segment 
	save "$data/segment.dta",replace

**************************************************************************

* END OF FILE
