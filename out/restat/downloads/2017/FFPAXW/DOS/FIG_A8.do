********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES FIGURE A8

* START LOG SESSION
	log using "LOGS/FIG_A8", replace

	* LOAD DATA
		u "DATA/BUILDING_LV.dta", clear

	* GENERATE GRAPH
		twoway ///
		(scatteri 450 1870 450 2014, recast(area) fcolor(gs6) lcolor(white)) ///
		(scatteri 450 1923 450 2014, recast(area) fcolor(white) lcolor(white)) ///
		(scatteri 183 1920 183 1923, recast(area) fcolor(white) lcolor(white)) ///
		(scatteri 60 1916 60 1920, recast(area) fcolor(white) lcolor(white)) ///
		(scatteri 80 1902 80 1916, recast(area) fcolor(white) lcolor(white)) ///	
		(scatteri 40 1893 40 1902, recast(area) fcolor(white) lcolor(white)) ///	
		(scatteri 450 1870 450 1893, recast(area) fcolor(white) lcolor(white)) ///
		(scatter HEIGHT YEAR if RES == 1 & YEAR >= 1870, msymbol(S) mlcolor(dkgreen) mfcolor(dkgreen) msize(small)) ///
		(scatter HEIGHT YEAR if COM == 1 & YEAR >= 1870, mfcolor(none) msymbol(T) mlcolor(orange_red)  ) ///
		(scatter HEIGHT YEAR if COM != 1 & RES != 1 & YEAR >= 1870, mfcolor(none) msymbol(X)  mlcolor(blue)) ///
		,  graphregion(color(white)) xtitle("Year") ytitle("Building height (m)") legend(order(1 "Banned heights" 9 "Commercial" 8 "Residential" 10 "Other")) xlabel(1875[25]2000) ylabel(50[50]450)  // xline(1893,  lcolor(gs8)) xline(1903,  lcolor(gs8)) xline(1916,  lcolor(gs8)) xline(1893,  lcolor(gs8)) xline(1920,  lcolor(gs8)) xline(1923,  lcolor(gs8)) xline(1942,  lcolor(gs8)) xline(1957,  lcolor(gs8)) ylabel(50[50]400) // yscale(log)

	* SAVE FIGURE A7	
		graph export "FIGS\FIG_A8.png", width(2400) height(1800) replace	


* END LOG SESSION
	log close			
