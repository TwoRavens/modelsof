/**************************************************************************
	
	Program: clean_visits.do
	Political Advertising Project
	Last Update: July 2016
	JS/DT
	
	This file prepares Shaw candidate visit data used in the analysis.
	
**************************************************************************/

/**************************************************************************

	1. 2004 (original raw file includes 2000) 

**************************************************************************/

	insheet using "$input/visits/candidate_visits_bydma_2000_2004.csv", clear
	keep if dma_code != .
	collapse (sum) *_2004, by(dma_code)
	rename bush_2004 rep_pres_visits2004
	rename kerry_2004 dem_pres_visits2004
	rename cheney_2004 rep_vp_visits2004
	rename edwards_2004 dem_vp_visits2004
	reshape long rep_pres_visits dem_pres_visits rep_vp_visits dem_vp_visits, i(dma_code) j(year)
	tempfile visits_2004
	save `visits_2004'

/**************************************************************************

	2. 2008 

**************************************************************************/	

	insheet using "$input/visits/candidate_visits_bycounty_2008.csv", clear
	drop state city
	rename statefipscode state
	rename countyfipscode county
	drop if inlist(state,.,2) | missing(county)
	rename mccain rep_pres_visits
	rename obama dem_pres_visits
	rename palin rep_vp_visits
	rename biden dem_vp_visits
	collapse (sum) *_visits, by(state county)
	merge 1:m state county using "$data/xwalk/dma_county_map.dta", keep(1 3)
	duplicates t state county, gen(dups)
	replace dups = dups + 1
	* Collapse from county to DMA level
	/*CHECK*/
	collapse (mean) *_visits [pw=1/dups], by(dma_code)
	gen year = 2008
	tempfile visits_2008
	save `visits_2008'
	
/**************************************************************************

	3. 2012 

**************************************************************************/	

	import excel "$input/visits/visits2012_dma.xlsx", sheet("visits2012") firstrow clear

	keep O B Ro Ry ID NAME

	rename Ro rep_pres_visits
	rename O dem_pres_visits
	rename Ry rep_vp_visits
	rename B dem_vp_visits
	
	collapse (sum) *_visits (first) NAME, by(ID)

	rename ID dma_code
	rename NAME dma_name

	gen year = 2012
	
	tempfile visits_2012
	save `visits_2012'

/**************************************************************************

	5. Append data 

**************************************************************************/	

	foreach year in 2004 2008 2012 {

		use `visits_`year'', clear
		
		egen cand_visits_dem = rowtotal(dem_pres_visits dem_vp_visits)
		egen cand_visits_rep = rowtotal(rep_pres_visits rep_vp_visits)
		egen pres_visits = rowtotal(dem_pres_visit rep_pres_visits)
		egen cand_visits = rowtotal(dem_pres_visits dem_vp_visits rep_pres_visits rep_vp_visits)
		gen cand_visits_ptydf = cand_visits_dem - cand_visits_rep
		
		save "$data/`year'/candidate_visits", replace

	}
	
**************************************************************************/	

* END OF FILE