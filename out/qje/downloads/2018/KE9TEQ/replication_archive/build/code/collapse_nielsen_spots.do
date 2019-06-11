/**************************************************************************
	
	Program: collapse_nielsen_impressions_2012.do
	Last Update: January 2018
	JS/DT
	
	This program is called by Nielsen data pressions data Nielsen.
	
**************************************************************************/

	cd "/Volumes/projects/advertising/build/temp"
	set more off
	args imonth ifile min

	insheet using UOC_`ifile'_`imonth'.txt, delim("~") clear

	gen nads = 1
	egen tv_pp = rowtotal(children_* female_* male_*) 
	
	* Note age ranges overlap but are mutually exclusive for each observation
	egen tv_pp_fem18plus = rowtotal(female_18_20 female_21_24 female_25_29 female_25_34 female_30_34 female_35_39 female_35_49 female_40_44 female_45_49 female_50_54 female_55_64 female_65_plus male_18_20 male_21_24 male_25_29 male_25_34 male_30_34 male_35_39 male_35_49 male_40_44 male_45_49 male_50_54 male_55_64 male_65_plus)

	foreach var in male female {
		gen `var'_adj_2_5 = children_2_5/2
		gen `var'_adj_6_11 = children_6_11/2
			egen tv_pp_`var'_2_plus = rowtotal(`var'*)
		egen tv_pp_`var'_18_34 = rowtotal(`var'_18_20 `var'_21_24 `var'_25_29 `var'_25_34 `var'_30_34)
		egen tv_pp_`var'_35_64 = rowtotal(`var'_35_39 `var'_35_49 `var'_40_44 `var'_45_49 `var'_50_54 `var'_55_64)
		egen tv_pp_`var'_65_plus = rowtotal(`var'_65_plus)
		egen tv_pp_`var'_35_plus = rowtotal(tv_pp_`var'_35_64 tv_pp_`var'_65_plus)
		egen tv_pp_`var'_18_plus = rowtotal(tv_pp_`var'_18_34 tv_pp_`var'_35_plus)
	}

	foreach type in 2_plus 18_34 35_64 65_plus 35_plus 18_plus {
		egen tv_pp_all_`type' = rowtotal(tv_pp_female_`type' tv_pp_male_`type')
	}

	gen nads_tv_hh = (tv_hh > 0 & tv_hh != .)
	gen nads_expenditure = (expenditure > 0 & expenditure != .)
	gen nads_both = nads_tv_hh*nads_expenditure
	gen tv_hh1 = tv_hh if nads_expenditure == 1
	gen expenditure1 = expenditure if nads_tv_hh == 1
	gen air_date = substr(report_date, 1, 11)
	gen stata_date = date(air_date, "MDY")
	format stata_date %td
	gen time = substr(report_date,13,8) + substr(report_date,25,2)
	gen stata_time = Clock(time,"hms")
	format stata_time %tC
	gen hour = hh(stata_time)
	gen minute = mm(stata_time)
	gen increment = floor(minute/`min')
	collapse (rawsum) nads* tv_hh* tv_pp* (sum) minutes=nads minutes_tv_hh=nads_tv_hh  minutes_expenidture=nads_expenditure minutes_both=nads_both expenditure* [fweight=duration], by(distributor market_name stata_date hour increment)
	local year = substr("`imonth'",1,4)
	outsheet using ../data/nielsen/`year'/summary_`ifile'_`imonth'_`min'm.csv, comma replace

**************************************************************************

* END OF FILE
