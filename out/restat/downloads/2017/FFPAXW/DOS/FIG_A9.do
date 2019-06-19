********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES FIGURE A9

* START LOG SESSION
	log using "LOGS/FIG_A9", replace

	* LOAD DATA 
		u "DATA/CONSTR_WORLD.dta", clear
	 
	 * GENERATE WEIGHTS FOR PSEUDO CHICAGO SAMPLE
	 * BE AWARE, THE COMPUTATION CAN TAKE SOME TIME
		
		* COMMERCIAL BUILDINGS
				psmatch2 CH lHEIGHT   if USE_COMMERCIAL == 1 &( constr_cost != . & HEIGHT != . ) & country == "U.S.A." | CH == 1   , kernel  k(biweight) 
				gen WCHC = _weight if USE_COMMERCIAL == 1

		* RESIDENTIAL BUILDINGS
				psmatch2 CH lHEIGHT  if USE_RESIDENTIAL & ( constr_cost != . & HEIGHT != . ) & country == "U.S.A." | CH == 1   ,    kernel k(biweight) 
				gen  WCHR = _weight		if USE_RESIDENTIAL == 1

		* COMBINE WEIGHTS TO ONE VARIABLE		
				gen WCH = .
				replace WCH = WCHC if USE_COMMERCIAL == 1
				replace WCH = WCHR if USE_RESIDENTIAL == 1	
	 
	* KERNEL DENSITY DISTRIBUTIONS
		twoway  (kdensity lHEIGHT if CH == 1 & FLOORS >= 5, kernel(gaussian) lcolor(black)) ///
				(kdensity lHEIGHT if constr_cost != . & lgfa != . & FLOORS >= 5, kernel(gaussian) lcolor(red) lpattern(dot)) ///
				(kdensity lHEIGHT if country == "U.S.A." & constr_cost != . & lgfa != . & FLOORS >= 5, kernel(gaussian) lcolor(red) lpattern(dash)) ///
				(kdensity lHEIGHT if country == "U.S.A." & constr_cost != . & lgfa != . & FLOORS >= 5 [w=WCH] , kernel(gaussian) lcolor(red))	///
				, legend(order(1 "Chicago" 2 "World" 3 "USA" 4 "Pseudo Chicago" ) ) ytitle("Kernel density (Gaussian)") xtitle("Log tall building height (five floors and more)") graphregion(fcolor(white))
				graph export "FIGS\FIG_A9.png", width(2400) height(1800) replace	

* END LOG SESSION
	log close	
