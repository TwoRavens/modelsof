********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES FIGURE 4

* START LOG SESSION
	log using "LOGS/FIG_4", replace

* LOAD DATA
	u "DATA/BUILDING_LV.dta", clear
	
* KEEP EXISTING BUILDINGS TO REFLECT CONTEMPORARY SKYLINE
	drop if yeardestruction != .
	
* ADJUST VARIABLE LABEL	
	label var lv1990 "Land value"
	
* GENERATE FIGURE 4	
	twoway ///
	(bar HEIGHT y_build_coord if y_build_coord>350, color(red) yaxis(1) barwidth(0.01) ) ///
	(scatter lv1990 y_build_coord if y_build_coord>350, mlcolor(black) mfcolor(none) msize(normal) yaxis(2) msymbol(x) ) ///
	, graphregion(color(white)) xtitle("Y-coordinate in projected miles") ///
	legend(order (1 "Building height (meters)" 2 "1990 land value ($/squre foot)")) 
* SAVE FIGURE 4	
	graph export "FIGS\FIG_4.png", width(2400) height(1800) replace	
	
* END LOG SESSION
	log close	
