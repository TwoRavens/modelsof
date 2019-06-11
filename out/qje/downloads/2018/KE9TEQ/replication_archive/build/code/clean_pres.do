/**************************************************************************
	
	Program: clean_pres.do
	Last Update: July 2018
	JS/DT
	
	This file prepares county-level Presidential vote 
		data used in the analysis from Congressional Quarterly 
	
**************************************************************************/

/**************************************************************************

	1. Clean data

**************************************************************************/

	* County-Level 2000-2012 U.S. Presidential Election Results
	
	foreach year in 2000 2004 2008 2012 {
	
		import excel using "$input/cq_votes/president/election_results.xlsx", sheet("`year'") firstrow clear
		replace AreaType = "County" if AreaType == "Parish" & State == "Louisiana"

		* Combine Broomfield and Boulder counties
		replace Area = "BOULDER" if Area == "BROOMFIELD" & State == "Colorado"
		
		* Combine votes with Alleghany County to match US Census data
		replace AreaType = "County" if Area == "CLIFTON FORGE" & State == "Virginia"
		replace Area = "ALLEGHANY" if Area == "CLIFTON FORGE" & State == "Virginia"
		
		* Include county-equivalent cities in Virginia
		replace Area = Area + " CITY" if AreaType == "City" & State == "Virginia" & !regexm(Area,".*CITY")
		replace AreaType = "County" if AreaType == "City" & State == "Virginia"
		
		* Rename wards in District of Columbia
		replace Area = "DISTRICT OF COLUMBIA" if State == "District of Columbia"
		replace AreaType = "County" if State == "District of Columbia"
		keep if AreaType == "County" & Area != "Votes Not Reported by County"
		
		rename DemVotes votes_dem
		rename RepVotes votes_rep
		rename Area county_name
		rename State state_name
		rename TotalVotes votes_total

		* Standardize county names
		replace county_name = trim(county_name)
		replace county_name = "DUPAGE" if county_name == "DU PAGE" & state_name == "Illinois"
		replace county_name = "DESOTO" if county_name == "DE SOTO" & state_name == "Mississippi"
		replace county_name = "LASALLE" if county_name == "LA SALLE" & state_name == "Illinois"
		replace county_name = "LAPORTE" if county_name == "LA PORTE" & state_name == "Indiana"
		replace county_name = "ST. MARY'S" if county_name == "ST. MARYS" & state_name == "Maryland"
		replace county_name = "PRINCE GEORGE'S" if county_name == "PRINCE GEORGES" & state_name == "Maryland"
		replace county_name = "QUEEN ANNE'S" if county_name == "QUEEN ANNES" & state_name == "Maryland"
		replace county_name = "LAMOURE" if county_name == "LA MOURE" & state_name == "North Dakota"
		replace county_name = "DEWITT" if county_name == "DE WITT" & state_name == "Texas"
		
		destring votes_*, replace 
		gen votes_other = votes_total - (votes_dem + votes_rep)
		collapse (sum) votes_other votes_total votes_dem votes_rep, by(state_name county_name)
		
		merge 1:1 state_name county_name using "$data/xwalk/fips_county_crosswalk.dta", assert(2 3) keep(3) nogenerate 
		
		gen year = `year'
		gen fips = state*1000+county
		
		drop if county == 301 & state == 48
		keep county_name state_name state county votes_total votes_dem votes_rep year fips
		collapse (sum) votes_total votes_dem votes_rep, by(state_name state county_name county year fips)
		save "$temp/election`year'pres.dta", replace
	
	}
	
/**************************************************************************

	2. Create battleground data file

**************************************************************************/

	import delimited using "$input/election/state_battleground.csv", clear 

	keep numericcode battleground_*

	rename numericcode state
	
	reshape long battleground_, i(state) j(year)
	
	rename battleground_ battleground_index

	gen battleground = inlist(battleground_index, -1, 0, 1)
	
	keep state year battleground battleground_index
	
	save "$temp/battleground", replace
	
/**************************************************************************

	3. Append data

**************************************************************************/

	foreach year in 2000 2004 2008 2012 {
	
		use "$temp/election`year'pres.dta", clear 
	
		merge m:1 year state using "$temp/battleground.dta", keep(1 3)
		
		assert _merge == 3 if year == `year' & `year' != 2000 
		
		drop _merge
		
		save "$data/`year'/pres_votes.dta", replace
	
	}
	
**************************************************************************

* END OF FILE

