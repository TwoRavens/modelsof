********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE 4

* START LOG SESSION
	log using "LOGS/TAB_4", replace

* HEIGHT REGRESSIONS*************************************************************
	* LOAD DATA
		u "DATA/BUILDING_LV.dta", clear

		* GENERATE YEAR TREND WITH 0-VALUE IN 2000
			gen Y = YEAR-2000
			label var Y "Year - 2000"
		
		* GENERATE 0.1 DISTANCE FROM CH RIVER DUMMY
			gen Dr = dist_river < 0.1
			label var Dr "River within 0.1 mile (dummy)"

		* GENERATE INTERACTIONS OF DISTANCE AND YEAR TREND
			gen Dr_Y = Dr*Y
			label var Dr_Y "River x (year - 2000)"	

			gen ldist_cbd_Y = ldist_cbd*Y
			label var ldist_cbd_Y "Log distance to CBD x (year - 2000)"

			gen ldist_lm_Y = ldist_lm*Y
			label var ldist_lm_Y "Log distance to Lake Michigan x (year - 2000)"
		
				
		* HEIGHT REGRESSION
			
			* [1] BASIC MODEL, NO INTERACTIONS
			eststo: reg lHEIGHT ldist_cbd  ldist_lm  Dr Y , robust
				estadd local Unit = "Buildings"
				estadd local Use = "All"
			
			* [2] [1] & YEAR TREND INTERACTION
			eststo: reg lHEIGHT ldist_cbd  ldist_lm  Dr Y ldist_cbd_Y ldist_lm_Y Dr_Y, robust
				estadd local Unit = "Buildings"
				estadd local Use = "All"		

			* [3] [2] RESTRICTED TO COMMERCIAL BUILDINGS
			eststo: reg lHEIGHT ldist_cbd  ldist_lm  Dr Y ldist_cbd_Y ldist_lm_Y Dr_Y if COM == 1, robust
				estadd local Unit = "Buildings"
				estadd local Use = "Commercial"		
			
			* [4] [2] RESTRICTED TO RESIDENTIAL BUILDINGS
			eststo: reg lHEIGHT ldist_cbd  ldist_lm  Dr Y ldist_cbd_Y ldist_lm_Y Dr_Y if RES == 1, robust
				estadd local Unit = "Buildings"
				estadd local Use = "Residential"
	
	
* LAND PRICE REGRESSIONS********************************************************
	
	* LOAD DATA
		u "DATA/GRID_WIDE.dta", clear

		* RESHAPE INTO LONG FORMAT
			gen nllv1880 = nllv1873
			gen nllv1900 = nllv1892
			gen llv1880 = llv1873
			gen llv1900 = llv1892
			reshape long nllv llv, i(grid_id) j(CC) 
				replace CC = 1920 if CC == 1926
				replace CC = round(CC, 10)
	
		* GENERATE YEAR TREND WITH 0-VALUE IN 2000
				gen Y = CC - 2000
				label var Y "Year - 2000"
				
		* GENERATE 0.1 DISTANCE FROM CH RIVER DUMMY
			gen Dr = dist_river <=0.1
				label var Dr "River within 0.1 mile (dummy)"
		
		* GENERATE INTERACTIONS OF DISTANCE AND YEAR TREND
			gen ldist_cbd_Y = ldist_cbd * Y
				label var ldist_cbd_Y "Log distance from CBD x (year - 2000)"

			gen ldist_lm_Y = ldist_lm * Y 
				label var ldist_lm_Y "Log distance from Lake Michigan x (year - 2000)"

			gen Dr_Y = Dr * Y
				label var Dr_Y "River x (year - 2000)"
			
			
		* LAND PRICE REGRESSION
	
			* [5] BASIC MODEL, NO INTERACTIONS
			eststo: reg llv  ldist_cbd  ldist_lm  Dr Y , robust	
				estadd local Unit = "Gridd cells"
				estadd local Use = "All"
				
			* [6] [5] & YEAR TREND INTERACTION
			eststo: reg llv ldist_cbd  ldist_lm  Dr Y ldist_cbd_Y ldist_lm_Y Dr_Y, robust	
				estadd local Unit = "Gridd cells"
				estadd local Use = "All"
				
	
	* WRITE TABLE
	esttab using "TABS/TAB_4.rtf", replace b(3) se(3) onecell label compress r2(3) stats(Unit  Use  N r2, fmt(%18.3g)) sfmt(2 2 2 3 3)   ///
	title ("Pooled gradient estimates") modelwidth(6) nogap star(* 0.1 ** 0.05 *** 0.01)  ///
	mtitles("Log height" "Log height" "Log height" "Log height" "Log land price" "Log land price") ///
	note("Notes:	Data used in columns (1-4) is a cross-section of building constructions. Data used in columns (5) and (6) is a panel where grid cells define the spatial dimension and cohorts (see Table 2) are the time dimension. Grid cells are defined as 330 x 330 feet tracts that closely follow the Chicago grid street structure. Robust stand-ard errors in parentheses.")
	eststo clear		
	
* END LOG SESSION
 log close	
	
