********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE A6

* START LOG SESSION
	log using "LOGS/TAB_A6", replace

	* LOAD DATA 
		u "DATA/CONSTR_WORLD.dta", clear

	* [1] SMALL BUILDINGS 
		sum FLOORS if lufa != . & lgfa != . & lHEIGHT != . & FLOORS < 5 , d
			local mean = r(mean)	
		eststo: reg conversion lHEIGHT  if FLOORS < 5 , robust
			estadd local Country_effects "-"
			estadd local Decade_effects "-"
			estadd scalar Semi_elasticity = 0
			estadd scalar Floors = round(`mean', 0.1)
			estadd local Land_use "All"
			estadd local Data "Observed"
			estadd local Buildings "Small"	
			estadd local Region "World"			
 	
	* [2] TALL COMMERCIAL BUILDINGS 
		sum FLOORS if lufa != . & lgfa != . & lHEIGHT != . & FLOORS >= 5 & USE_COMMERCIAL == 1 , d
			local mean = r(mean)	
		eststo: reg conversion lHEIGHT   if FLOORS >= 5 & USE_COMMERCIAL == 1, robust 
			estadd local Country_effects "-"
			estadd local Decade_effects "-"
			estadd scalar Semi_elasticity = 0
			estadd scalar Floors = round(`mean', 0.1)
			estadd local Land_use "Commercial"
			estadd local Data "Observed"
			estadd local Buildings "Tall"	
			estadd local Region "World"			

	* [3] TALL RESIDENTIAL BUILDINGS 
		sum FLOORS if lufa != . & lgfa != . & lHEIGHT != . & FLOORS >= 5 & USE_RESIDENTIAL == 1 , d
			local mean = r(mean)	
		eststo: reg conversion lHEIGHT   if FLOORS >= 5 & USE_RESIDENTIAL == 1, robust 
			estadd local Country_effects "-"
			estadd local Decade_effects "-"
			estadd scalar Semi_elasticity = 0
			estadd scalar Floors = round(`mean', 0.1)
			estadd local Land_use "Residential"
			estadd local Data "Observed"
			estadd local Buildings "Tall"	
			estadd local Region "World"			
 
	* WRITE TABLE A6
		esttab using "TABS/TAB_A6.rtf", replace b(3) se(3) onecell label compress r2(3) stats( Floors   Data Land_use Buildings Region r2 N , fmt(%18.3g ) ) drop( _cons) ///
		title ("Height effects on usable floor space") modelwidth(6) nogap star(* 0.1 ** 0.05 *** 0.01) ///
		note("Notes: Data from Emporis. Small buildings have less than five floors. Tall buildings have five or more floors. For a small percentage of buildings height is imputed based on floors using an auxiliary regression of height against floors (on average height increases by 3.6 meters per floor). Robust standard errors in parentheses.")
		eststo clear

* END LOG SESSION
 log close		
		
