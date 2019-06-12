/**************************************************************************
	
	Program: clean_nielsen.do
	Last Update: February 2018
	JS/DT
	
	This file prepares Nielsen universe estimate data for analysis.
	
**************************************************************************/

	args year

/**************************************************************************

	1. Universal Estimates 

**************************************************************************/

	if inlist(`year',2004,2008) {

		global MONTHS2004="200407 200408 200409 200410 200411"
		global MONTHS2008="200807 200808 200809 200810 200811"

		insheet using "$input/nielsen/Local_UEs_2008_2009.csv", clear		
		
	}
	
	else if `year' == 2012 {
	
		insheet using "$input/nielsen/2012/AdIntel/UESpotTV.tsv", clear
		keep if startdate == "2012-10-01"
		rename marketcode market_code
		collapse (sum) children_* female_* male_*, by(market_code)
		merge 1:1 market_code using "$input/nielsen/market_code_name_xwalk", assert(3) nogen
		
	}
	
	gen year = `year'
	
	egen market_viewers = rowtotal(children_* female_* male_*)
	egen children_2_11 = rowtotal(children_2_5 children_6_11)

	foreach sex in male female {
		local sex1 = substr("`sex'",1,1)
		gen `sex'_2_11 = children_2_11/2
		egen market_viewers_`sex1'2_p = rowtotal(`sex'_2_11 `sex'_12_17 `sex'_18_20 `sex'_21_24 `sex'_25_34 `sex'_35_49 `sex'_50_54 `sex'_55_64 `sex'_65_plus)
		egen market_viewers_`sex1'18_34 = rowtotal(`sex'_18_20 `sex'_21_24 `sex'_25_34)
		egen market_viewers_`sex1'35_64 = rowtotal(`sex'_35_49 `sex'_50_54 `sex'_55_64)
		egen market_viewers_`sex1'35_p = rowtotal(`sex'_35_49 `sex'_50_54 `sex'_55_64 `sex'_65_plus)
		egen market_viewers_`sex1'18_p = rowtotal(`sex'_18_20 `sex'_21_24 `sex'_25_34 `sex'_35_49 `sex'_50_54 `sex'_55_64 `sex'_65_plus)
		rename `sex'_65_plus market_viewers_`sex1'65_p
	}

	foreach group of global agegroups {
		egen market_viewers_a`group' = rowtotal(market_viewers_m`group' market_viewers_f`group')
	}

	drop if inlist(market_name,"ANCHORAGE","FAIRBANKS","JUNEAU")

	rename market_name nielsen_dma
	rename market_code dma_code
	replace nielsen_dma = subinstr(nielsen_dma," ","",.)
	sort nielsen_dma

	merge m:1 nielsen_dma using $data/xwalk/dma_map, assert(3) nogenerate keepusing(dma_name)

	drop nielsen_dma
	keep year dma_name dma_code market_viewers*
	save $data/nielsen/`year'/nielsen_data.dta, replace

/**************************************************************************

	2. Ratings Estimates (2004 and 2008 only)

**************************************************************************/

	if inlist(`year',2004,2008) {

	   foreach incr in 15m 30m {

			foreach month of global MONTHS`year' {
				foreach file in SpotTV NetClearTV SynClearTV {
					* (See README.txt for known data issues)
					if (`month' == 200811 & "`file'" == "SynClearTV") continue
					insheet using "$data/nielsen/`year'/summary_`file'_`month'_`incr'.csv", clear
					tempfile `month'_`file'
					save ``month'_`file'', replace
				}
			}

			clear
			gen temp = ""	
			foreach month of global MONTHS`year' {
				foreach file in SpotTV NetClearTV SynClearTV {
					if (`month' == 200811 & "`file'" == "SynClearTV") continue
					append using ``month'_`file''
				}
			}

			rename stata_date date
			rename nads_tv_hh tv_nads
			rename minutes_tv_hh tv_minutes
			gen stata_date = date(date,"DMY")
			format stata_date %td
			keep distributor stata_date hour increment tv_pp* tv_nads tv_minutes
			collapse (sum) tv_pp* tv_nads tv_minutes, by(distributor stata_date hour increment)
			d tv_pp* tv_nads tv_minutes, varlist
			local vars = r(varlist)
			foreach var of local vars {
				rename `var' `var'_`incr'
			}
			sort distributor stata_date hour increment
			if "`incr'" == "15m" rename increment quarterhour
			if "`incr'" == "30m" rename increment halfhour
			save $data/nielsen/nielsen_ratings`year'_`incr'.dta, replace
			
		}

	}
	
**************************************************************************

* END OF FILE
	
