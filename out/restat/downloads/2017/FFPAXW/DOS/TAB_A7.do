********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE A7

* START LOG SESSION
	log using "LOGS/TAB_A7", replace

* LOAD PIN DATA SET
	u "DATA\PIN_USING.dta", clear

	* GENERATE TREND x LAND PRICE INTERACTION
		gen built_trend = yrbuilt - 2000
		gen lLV_trend = lLV*built_trend
	* LABEL VARIABLES	
		label var lLV "Log land price"
		label var lLV_trend "Log land price x (year - 2000)"
		label var lFSI "Log floor area ratio (floor space / parcel area)"
		
	* GENERATE INDICATOR FOR HIGH/LOW LAND PRICE INDICATOR
		sort cc
		by cc: egen mlLV = mean(lLV)
		gen nlLV = lLV - mlLV
		sum  nlLV, d
		gen EXPENSIVE = nlLV > r(p50)
		gen CHEAP = EXPENSIVE == 0
	
	* GENERATE INDICATOR FOR HIGH/LOW DENSITY
		sum lFSI, d
		gen DENSE = lFSI > r(p50)
		gen LDENSE = DENSE == 0
			
			
	* FLOOR AREA REGRESSIONS		

		* [1] FULL SAMPLE
			eststo: areg lFSI lLV lLV_trend, abs(cc) cluster(cc)	
				estadd local Cohort_effects "Yes"
				estadd local Sample "All"

		* [2] HIGH LAND PRICE
			eststo: areg lFSI lLV lLV_trend if EXPENSIVE== 1, abs(cc) cluster(cc)	
				estadd local Cohort_effects "Yes"
				estadd local Sample "High land price"
				
		* [3] LOW LAND PRICE
			eststo: areg lFSI lLV lLV_trend if EXPENSIVE== 0, abs(cc) cluster(cc)	
				estadd local Cohort_effects "Yes"
				estadd local Sample "Low land price"
	
		* [4] HIGH DENSITY
			eststo: areg lFSI lLV lLV_trend if DENSE== 1, abs(cc) cluster(cc)	
				estadd local Cohort_effects "Yes"
				estadd local Sample "High density"

		* [5] LOW DENSITY		
			eststo: areg lFSI lLV lLV_trend if DENSE== 0, abs(cc) cluster(cc)	
				estadd local Cohort_effects "Yes"
				estadd local Sample "Low density"

		* [6] HIGH LAND PRICE AND LOW DENSITY		
			eststo: areg lFSI lLV lLV_trend if EXPENSIVE== 1 & DENSE== 0, abs(cc) cluster(cc)
				estadd local Cohort_effects "Yes"
				estadd local Sample "High land price & low density"	
				
		* [7] HIGH LAND PRICE AND HIGH DENSITY		
			eststo: areg lFSI lLV lLV_trend if EXPENSIVE== 0 & DENSE== 1, abs(cc) cluster(cc)	
				estadd local Cohort_effects "Yes"
				estadd local Sample "Low land price & high density"

	* WRITE TABLE A7				
		esttab using "TABS/TAB_A7.rtf", replace b(3) se(3) onecell label compress r2(3) stats( Cohort_effects   Sample r2 N  ) drop( _cons) ///
		title ("The elasticity of floor area ratio with respect to land price for small residential properties") modelwidth(6) nogap star(* 0.1 ** 0.05 *** 0.01) ///
		note("Data from the Cook County Assessor’s Office (2003 assessment roll). High land price parcels are parcels with an above median land price within (decade) construction cohorts. High density parcels are parcels with an above median floor area ratio. Standard errors in parentheses clustered on cohort effects.")
		eststo clear
	
* END LOG SESSION
 log close		
		
