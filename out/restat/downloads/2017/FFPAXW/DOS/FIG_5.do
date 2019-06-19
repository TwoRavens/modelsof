********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES FIGURE 5

* START LOG SESSION
	log using "LOGS/FIG_5", replace

	* LOAD DATA
		u "DATA/GRID_WIDE.dta", clear
	* GENERATE CBD GRID
		replace dist_cbd = round(dist_cbd, 1)
		keep dist_cbd nllv* grid_id
	* GENERATE 1880 and 1900 OBS	
		gen nllv1880 = nllv1873
		gen nllv1900 = nllv1892
	* ADJUST LABELS AND GRID	
		reshape long nllv , i(grid_id) j(CC) 
			replace CC = 1920 if CC == 1926
			drop if CC == 1965
			drop if CC<1870
			replace CC = round(CC, 10)
			drop if dist_cbd > 13
	* AGGREGAGTE TO GRIDS		
		collapse (mean) nllv , by(CC dist_cbd)
	* GENERATE FIGURE
		twoway (contour nllv CC dist_cbd, interp(no)  heatmap ccuts(-2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5)  crule(linear) scolor(white) ecolor(blue) ) /// crule(intensity) levels(20)
		,  graphregion(color(white)) xlabel(0[1]13) ylabel(1870[20]2010) xtitle("Distance from CBD (miles)") ytitle("Construction date cohort" ".") ztitle("Normalized log land value") title("Land price")
	* SAVE LEFT PANEL	
		graph export "FIGS\FIG_5a.png", width(2400) height(1800) replace		
		
* HEIGHT PANEL

	* LOAD DATA
		u "DATA/BUILDING_LV.dta", clear	
	* GENERATE CBD GRID	
		replace dist_cbd = round(dist_cbd, 1)	
		keep grid_id HEIGHT CC dist_cbd
		drop if CC == .	
	* COLLAPSE TO GRID	
		collapse (mean) HEIGHT , by(CC dist_cbd)
	* ADD 1880 and 1980 OBS	
		reshape wide HEIGHT , i(dist_cbd) j(CC)
			gen HEIGHT1880 = HEIGHT1870
			gen HEIGHT1900 = HEIGHT1890
		reshape long HEIGHT , i(dist_cbd) j(CC)
	* ADJUST GRID	
		drop if CC<1870
	* GENERATE FIGURE
		twoway (contour HEIGHT CC dist_cbd, interp(shepard)  heatmap ccuts(20 30 40 50 60 70 80 90 100 110 120 130 140 150  ) crule(linear) scolor(white) ecolor(blue) ) ///
		,  graphregion(color(white)) xlabel(0[1]13) ylabel(1870[20]2010) xtitle("Distance to CBD (miles)") ytitle("Construction date cohort" ".") ztitle("Mean height of constructed tall buildings (meters)") title("Building height") 	
	* SAVE RIGHT PANEL	
		graph export "FIGS\FIG_5b.png", width(2400) height(1800) replace	
		
* END LOG SESSION
	log close			
