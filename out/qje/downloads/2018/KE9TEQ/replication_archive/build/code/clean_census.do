/**************************************************************************
	
	Program: clean_census.do
	Last Update: January 2018
	JS/DT
	
	This file prepares Census district data used in the analysis.
	
**************************************************************************/

/**************************************************************************

	0. Define macros and programs 

**************************************************************************/

	global statefiles = "01 04 05 06 08 09 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56"    

	capture program drop recode_census
	program define recode_census
		local year = `1'
		gen pop16_`year' = male16_`year' + female16_`year'
		gen pop18_`year' = male18_`year' + female18_`year'
		keep statea countya *_`year' 
		rename statea state
		rename countya county
		drop if state == 2
		drop if county == 5 & state == 15
		replace county = 13 if county == 14 & state == 8
		collapse (sum) *_`year', by(state county)
	end

/**************************************************************************

	1. Census regions

**************************************************************************/

	import excel "$input/census/census_regions.xls", clear sheet("CODES09") cellrange(A6:D70) case(lower) firstrow
	destring statefips, gen(state)
	drop if state == 0
	destring region, replace
	keep state region
	save "$temp/census_regions.dta", replace

/**************************************************************************

	2. Percent foreign born (NHGIS)

**************************************************************************/

	* 2000
	insheet using "$input/census/nhgis0006_ds151_2000_county.csv", clear
	gen foreign_born_pct2000 = gi8002/(gi8001+gi8002)
	drop state county
	rename statea state
	rename countya county
	keep state county foreign_born_pct2000
	tempfile census2000_foreign
	save `census2000_foreign', replace

	* 2010
	insheet using "$input/census/nhgis0006_ds177_20105_2010_county.csv", clear
	gen foreign_born_pct2010 = jwue003/jwue001
	drop state county
	rename statea state
	rename countya county
	keep state county foreign_born_pct2010
	tempfile census2010_foreign
	save `census2010_foreign', replace

	* Merge files together
	use `census2000_foreign', clear
	merge 1:1 state county using `census2010_foreign', keep(3) nogenerate
	gen foreign_born_pct2004 = 0.6*foreign_born_pct2000 + 0.4*foreign_born_pct2010
	gen foreign_born_pct2008 = 0.2*foreign_born_pct2000 + 0.8*foreign_born_pct2010
	drop foreign_born_pct2000 foreign_born_pct2010
	reshape long foreign_born_pct, i(state county) j(year)
	tempfile census_foreign
	save "$temp/census_foreign.dta", replace


/**************************************************************************

	3. 16-19 year old information (NHGIS)

**************************************************************************/

	* 2000
	insheet using "$input/census/nhgis0002_ds149_2000_county.csv", clear
	egen male16_2000 = rowtotal(f59017 f59018 f59019 f59020) 
	egen female16_2000 = rowtotal(f59120 f59121 f59122 f59123) 
	egen male18_2000 = rowtotal(f59019 f59020)
	egen female18_2000 = rowtotal(f59122 f59123)
	recode_census 2000
	tempfile census2000
	save `census2000', replace

	* 2010
	insheet using "$input/census/nhgis0002_ds181_2010_county.csv", clear
	egen male16_2010 = rowtotal(lgj019 lgj020 lgj021 lgj022) 
	egen female16_2010 = rowtotal(lgj123 lgj124 lgj125 lgj126)
	egen male18_2010 = rowtotal(lgj021 lgj022)
	egen female18_2010 = rowtotal(lgj125 lgj126)
	recode_census 2010
	tempfile census2010
	save `census2010', replace

	* Merge files together
	use `census2000', clear
	merge 1:1 state county using `census2010', keep(3) nogenerate
	
	foreach age in 16 18  {
	
		foreach type in pop male female {
	
			gen `type'`age'_2004 = 0.6*`type'`age'_2000 + 0.4*`type'`age'_2010
			gen `type'`age'_2008 = 0.2*`type'`age'_2000 + 0.8*`type'`age'_2010
			
			* Use 2010 data for 2012
			gen `type'`age'_2012 = `type'`age'_2010
			
		}

	}

	reshape long pop16_ pop18_ male16_ male18_ female16_ female18_, i(state county) j(year)
	rename pop16_ pop16
	rename pop18_ pop18
	rename male16_ male16
	rename male18_ male18
	rename female16_ female16
	rename female18_ female18
	sort year state county
	save "$temp/census_pop1618.dta", replace    

/**************************************************************************

	4. Income and poverty data (SAIPE) 

**************************************************************************/

	foreach year in 2000 2004 2008 {
		local year_abbrev = substr("`year'",3,2) + ""
		infix state 1-2 county 4-6 npoverty 8-15 income 134-139 using "$input/census/SAIPE-est`year_abbrev'ALL.txt", clear 
		gen year = `year'
		* Replace  Counties (See known data issues in README.txt)
		drop if state == 2
		drop if (county == 5 & state == 15)
		sort year state county 
		tempfile saipe`year'
		save `saipe`year''
	}

	use `saipe2000', clear
	append using `saipe2004'
	append using `saipe2008'
	save "$temp/census_saipe.dta", replace    

/**************************************************************************

	5. Density and land (Gazeteer) 

**************************************************************************/

	* 2010 Gazeteer Map Data by County
	insheet using "$input/census/Gaz_counties_national.txt", clear
	keep geoid pop10 aland_sqmi intptlat intptlong
	gen state = int(geoid/1000)
	gen county = mod(geoid,1000)

	* Drop Alaska
	drop if state == 2
	drop if county == 5 & state == 15
	sort state county
	save "$temp/gazeteer_county_2010", replace    

/**************************************************************************

	6. Population data by 5 year age buckets (2000-2010)

**************************************************************************/

	foreach file of global statefiles {
	
		insheet using "$input/census/CO-EST00INT-ALLDATA-`file'.csv", clear
		recode year (2=2000) (6=2004) (10=2008)
		keep if inlist(year,2000,2004,2008)
		keep state county stname ctyname year agegrp tot_pop tot_male tot_female
	
		gen age_range = 1 if inrange(agegrp,0,4)
		replace age_range = 2 if inrange(agegrp,5,7)
		replace age_range = 3 if inrange(agegrp,8,13)
		replace age_range = 4 if inrange(agegrp,14,18)
		drop if age_range == .
		
		* Replace Hawaii Counties
		if "`file'" == "15" {
			drop if county == 5 
		}
		
		* Drop Loving County (TX) 
		if "`file'" == "48" {
			drop if county == 301
		}
		
		* Merge Broomfield County, CO into Boulder County 
		if "`file'" == "08" {
			replace county = 13 if county == 14 
			replace ctyname = "Boulder" if county == 13
		}
	
		collapse (sum) tot_pop tot_male tot_female, by(state county stname ctyname year age_range)
		reshape wide tot_pop tot_male tot_female, i(state county stname ctyname year) j(age_range)
		tempfile popfile`file'
		save `popfile`file''

	}

	clear
	foreach file of global statefiles {
		append using `popfile`file''
	}

	save "$temp/census_pop2000.dta", replace 

/**************************************************************************

	7. Population data by 5 year age buckets (2012) 

**************************************************************************/

	insheet using "$input/census/CC-EST2012-ALLDATA.csv", clear

	keep if year == 5
			
	keep state county stname ctyname agegrp tot_pop tot_male tot_female

	gen age_range = 1 if inrange(agegrp,1,4)
	replace age_range = 2 if inrange(agegrp,5,7)
	replace age_range = 3 if inrange(agegrp,8,13)
	replace age_range = 4 if inrange(agegrp,14,18)
	drop if age_range == .

	* Replace Alaska Counties
	drop if state == 2

	* Recode Hawaii County
	drop if state == 48 & county == 301
	drop if state == 15 & county == 5

	replace county = 13 if county == 14 & state == 8

	collapse (sum) tot_pop tot_male tot_female, by(state county age_range)
	reshape wide tot_pop tot_male tot_female, i(state county) j(age_range)

	gen year = 2012

	save "$temp/census_pop2012.dta", replace
		
/**************************************************************************

	8. Population data by race (2000-2010)

**************************************************************************/

	insheet using "$input/census/CO-EST00INT-SEXRACEHISP.csv", clear
	
	keep state county sex race origin popestimate*

	collapse (sum) popestimate*, by(state county sex race origin)
	
	reshape long popestimate, i(state county race origin sex) j(year)
	
	gen temp_tot_pop = popestimate if sex == 0 & race == 0 & origin == 0
	egen race_tot_pop = mean(temp_tot_pop), by(state county year)
	
	gen pop_share_black_hisp = popestimate/race_tot_pop if race == 2 & sex == 0 & origin == 2 
	gen pop_share_white_hisp = popestimate/race_tot_pop if race == 1 & sex == 0 & origin == 2
	gen pop_share_asian_hisp = popestimate/race_tot_pop if race == 4 & sex == 0 & origin == 2
	gen pop_share_black_all = popestimate/race_tot_pop if race == 2 & sex == 0 & origin == 0 
	gen pop_share_white_all = popestimate/race_tot_pop if race == 1 & sex == 0 & origin == 0
	gen pop_share_asian_all = popestimate/race_tot_pop if race == 4 & sex == 0 & origin == 0
	gen pop_share_hispanic_all = popestimate/race_tot_pop if origin == 2 & sex == 0 & race == 0
	collapse (mean) race_tot_pop pop_share_*, by(state county year)
	
	gen pop_share_black = pop_share_black_all - pop_share_black_hisp
	gen pop_share_white = pop_share_white_all - pop_share_white_hisp
	gen pop_share_asian = pop_share_asian_all - pop_share_asian_hisp
	gen pop_share_hispanic = pop_share_hispanic_all - pop_share_black_hisp - pop_share_white_hisp - pop_share_asian_hisp
	gen pop_share_other = 1 - (pop_share_black + pop_share_white + pop_share_hispanic + pop_share_asian)
	gen pop_share_minority = 1 - pop_share_white
	
	keep year state county pop_share_black pop_share_white pop_share_asian pop_share_hispanic pop_share_minority pop_share_other
	sort year state county
	
	save "$temp/census_race_pop.dta", replace

/**************************************************************************

	9. 5 Yr ACS (2012)

**************************************************************************/

	* B03002: HISPANIC OR LATINO ORIGIN BY RACE
	* B05002: PLACE OF BIRTH BY NATIVITY AND CITIZENSHIP STATUS
	* B15003: EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER
	* B17001: POVERTY STATUS IN THE PAST 12 MONTHS BY SEX BY AGE
	* B19001: HOUSEHOLD INCOME IN THE PAST 12 MONTHS (IN 2015 INFLATION-ADJUSTED DOLLARS)
	* B19013: MEDIAN HOUSEHOLD INCOME IN THE PAST 12 MONTHS (IN 2015 INFLATION-ADJUSTED DOLLARS)

	* Race
	insheet using "$input/acs/ACS_12_5YR_B03002_with_ann.csv", names clear
	drop in 1
	
	destring geoid2, gen(fips)
	gen state = floor(fips/1000)
	gen county = mod(fips,1000)
	rename hd01_vd01 n_total
	rename hd01_vd03 n_white
	rename hd01_vd04 n_black
	rename hd01_vd06 n_asian
	rename hd01_vd12 n_hispanic
	
	destring n_*, replace
	gen n_other = n_total - (n_white + n_black + n_asian + n_hispanic)
	gen n_minority = n_total - n_white
	
	foreach type in white black asian hispanic other minority {
	
		gen pop_share_`type' = n_`type' / n_total
		
	}
	
	keep state county pop_share_*
	save "$temp/acs_12_5yr_race.dta", replace

	* Poverty
	insheet using "$input/acs/ACS_12_5YR_B17001_with_ann.csv", names clear
	drop in 1
	
	destring geoid2, gen(fips)
	gen state = floor(fips/1000)
	gen county = mod(fips,1000)
	
	rename hd01_vd01 n_total
	rename hd01_vd02 n_poverty

	destring n_*, replace
	
	gen pct_poverty = n_poverty / n_total
	
	keep state county pct_poverty
	save "$temp/acs_12_5yr_poverty.dta", replace
	
	* Nativity
	insheet using "$input/acs/ACS_12_5YR_B05002_with_ann.csv", names clear
	drop in 1
	
	destring geoid2, gen(fips)
	gen state = floor(fips/1000)
	gen county = mod(fips,1000)
	
	rename hd01_vd01 n_total
	rename hd01_vd13 n_foreign
	
	destring n_*, replace
	gen foreign_born_pct = n_foreign / n_total
	
	keep state county foreign_born_pct
	
	save "$temp/acs_12_5yr_nativity.dta", replace

	* Education
	insheet using "$input/acs/ACS_12_5YR_B15003_with_ann.csv", names clear
	drop in 1
	
	destring geoid2, gen(fips)
	gen state = floor(fips/1000)
	gen county = mod(fips,1000)
	
	destring hd*, replace
	rename hd01_vd01 n_total
	
	egen n_dropout = rowtotal(hd01_vd02 hd01_vd03 hd01_vd04 hd01_vd05 hd01_vd06 hd01_vd07 hd01_vd08 hd01_vd09 hd01_vd10 hd01_vd11 hd01_vd12 hd01_vd13 hd01_vd14 hd01_vd15 hd01_vd16)

	egen n_hsplus = rowtotal(hd01_vd17 hd01_vd18 hd01_vd19 hd01_vd20)
	egen n_colplus = rowtotal(hd01_vd21 hd01_vd22 hd01_vd23 hd01_vd24 hd01_vd25)
	
	foreach type in dropout hsplus colplus {
		gen edu_`type' = n_`type' / n_total
	}
	
	keep state county edu_*
	
	save "$temp/acs_12_5yr_education.dta", replace
	
	* Income
	insheet using "$input/acs/ACS_12_5YR_B19013_with_ann.csv", names clear
	drop in 1
	
	destring geoid2, gen(fips)
	gen state = floor(fips/1000)
	gen county = mod(fips,1000)
	rename hd01_vd01 income

	destring income, replace
	keep state county income
	
	save "$temp/acs_12_5yr_income.dta", replace
		
	* Append files together
	use "$temp/acs_12_5yr_race.dta", clear
	merge 1:1 state county using "$temp/acs_12_5yr_nativity.dta", assert(3) nogenerate
	merge 1:1 state county using "$temp/acs_12_5yr_education.dta", assert(3) nogenerate
	merge 1:1 state county using "$temp/acs_12_5yr_income.dta", assert(1 3) nogenerate
	merge 1:1 state county using "$temp/acs_12_5yr_poverty.dta", assert(1 3) nogenerate

	gen year = 2012
	
	save "$temp/acs_12_5yr.dta", replace
		
/**************************************************************************

	10. Append data 

**************************************************************************/

	use "$temp/census_pop2000.dta", clear
	append using "$temp/census_pop2012.dta"
	merge 1:1 year state county using "$temp/census_saipe.dta", keep(1 3) nogenerate
	merge m:1 state county using "$temp/gazeteer_county_2010.dta", keep(1 3) nogenerate
	merge 1:1 year state county using "$temp/census_pop1618.dta", keep(1 3) nogenerate
	merge 1:1 year state county using "$temp/census_race_pop.dta", keep(1 3) nogenerate
	merge 1:1 year state county using "$temp/census_foreign.dta", keep(1 3) nogenerate
	merge 1:1 year state county using "$temp/acs_12_5yr.dta", keep(1 3 4) assert(1 2 3 4) update nogenerate
	merge m:1 state using "$temp/census_regions.dta", assert(2 3) keep(3) nogenerate

	foreach type in pop male female {

		gen tot_`type'_adult = tot_`type'2 + tot_`type'3 + tot_`type'4 + `type'18
		gen tot_`type'_all = tot_`type'1 + tot_`type'2 + tot_`type'3 + tot_`type'4 
	
	}
	
	gen density = pop10/aland_sqmi
	replace pct_poverty = npoverty/pop10 if year != 2012
	
	save "$data/census.dta", replace

**************************************************************************

* END OF FILE
