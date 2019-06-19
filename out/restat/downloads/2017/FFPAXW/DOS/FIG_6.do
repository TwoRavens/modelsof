********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES FIGURE 6

* START LOG SESSION
	log using "LOGS/FIG_6", replace
	
* LAND PRICE PANEL *************************************************************
	
	* LOAD DATA
		u "DATA/GRID_WIDE.dta", clear

	* RESHAPE INTO LONG FORMAT
		keep dist_cbd dist_lm dist_river  llv* grid_id
		gen llv1880 = llv1873
		gen llv1900 = llv1892
		reshape long  llv, i(grid_id) j(CC) 
			replace CC = 1920 if CC == 1926
			drop if CC<1870
			replace CC = round(CC, 10)
			
	
		* NUMBER OF GRID CELLS 
		local cells = 21

		* GEN CBD-YEAR GRID CELLS
		gen grid_cbd = round(dist_cbd, 0.25)
		gen grid_cbd_year = CC*10000+grid_cbd
		
		* GEN DIST FROM LAKE MICHIGAN GRID CELLS
		gen grid_dlm = round(dist_lm, 0.05)
			qui tab grid_dlm, gen(DGLM)
		* DIST FROM CHICAGO RIVER GRID CELLS
		gen grid_driver = round(dist_river, 0.05)
			qui tab grid_driver, gen(DGR)
		* GEN OUTER BASE CELLS 
		gen DLMB = dist_lm <=0.05*`cells'+1
		gen DRB = dist_river <=0.05*`cells'+1
		
		* REGRESS LN LAND PRICE AGAINST GRID CELLS AND OUTER COMPARISON CELLS
		areg llv DGLM1-DGLM`cells'  DGR1-DGR`cells' DLMB DRB , abs(grid_cbd_year) cluster(grid_cbd_year)
			* READ COEFFS
			forval num = 1/`cells' {
				scalar bDLM`num' = _b[DGLM`num'] 
				scalar ciuDLM`num' = _b[DGLM`num'] + 1.96*_se[DGLM`num']  
				scalar cilDLM`num' = _b[DGLM`num'] - 1.96*_se[DGLM`num'] 
				scalar bDR`num' = _b[DGR`num'] 
				scalar ciuDR`num' = _b[DGR`num'] + 1.96*_se[DGR`num'] 
				scalar cilDR`num' = _b[DGR`num'] - 1.96*_se[DGR`num']  			
				}

	* READ COEFFS INTO NEW DATA SET	
		clear 
		set obs `cells'
		gen CELL = _n
		gen DIST = (CELL-1)*0.05
		foreach name in bDLM ciuDLM cilDLM  bDR ciuDR cilDR {
			gen `name' = .
			forval num = 1/`cells' {
				replace `name' = `name'`num' if CELL== `num'
				}
				}
		sort DIST
		local max =  0.05*`cells'
		drop if DIST > `max'
		
		* GENERATE LAND VALUE PANEL
		twoway ///
			(rcap ciuDLM cilDLM DIST, sort color(red) ) ///
			/// (scatter bDLM DIST, mcolor(red)) ///
			(line bDLM DIST, lcolor(red)) ///
			(rcap ciuDR cilDR DIST, sort color(black) lpattern(dash)) ///
			/// (scatter bDR DIST, mcolor(black)) ///
			(line bDR DIST, lcolor(black) lpattern(dash)) ///
			, graphregion(color(white)) xtitle("Distance (miles)")  ytitle("Land price effect (log points)") ///
			legend(order (1 "Lake Michigan"3 "Chicago River")) yline(0) ///
			xlabel(0[0.1]`max') name(LV, replace)
		
		
* HEIGHT PANEL *****************************************************************
	
	
	* LOAD DATA
		u "DATA/BUILDING_LV.dta", clear

		* NUMBER OF GRID CELLS 
			local cells = 21
		
		* GEN CBD-YEAR GRID CELLS
		gen grid_cbd = round(dist_cbd, 0.25)
		gen grid_cbd_year = CC*10000+grid_cbd

		* GEN DIST FROM LAKE MICHIGAN GRID CELLS
		gen grid_dlm = round(dist_lm, 0.05)
			tab grid_dlm, gen(DGLM)

		* DIST FROM CHICAGO RIVER GRID CELLS
		gen grid_driver = round(dist_river, 0.05)
			tab grid_driver, gen(DGR)

		* GEN OUTER BASE CELLS 
		gen DLMB = dist_lm <=0.05*`cells'+1
		gen DRB = dist_river <=0.05*`cells'+1

		* REGRESS LN HEIGHT AGAINST GRID CELLS AND OUTER COMPARISON CELLS
		areg lHEIGHT DGLM1-DGLM`cells'  DGR1-DGR`cells' DLMB DRB , abs(grid_cbd_year) cluster(grid_cbd_year)
			* READ COEFFS
			forval num = 1/`cells' {
				scalar bDLM`num' = _b[DGLM`num'] 
				scalar ciuDLM`num' = _b[DGLM`num'] + 1.96*_se[DGLM`num']  
				scalar cilDLM`num' = _b[DGLM`num'] - 1.96*_se[DGLM`num'] 
				scalar bDR`num' = _b[DGR`num'] 
				scalar ciuDR`num' = _b[DGR`num'] + 1.96*_se[DGR`num'] 
				scalar cilDR`num' = _b[DGR`num'] - 1.96*_se[DGR`num']  			
				}

		* READ COEFFS INTO NEW DATA SET	
		clear 
		set obs `cells'
		gen CELL = _n
		gen DIST = (CELL-1)*0.05
		foreach name in bDLM ciuDLM cilDLM  bDR ciuDR cilDR {
			gen `name' = .
			forval num = 1/`cells' {
				replace `name' = `name'`num' if CELL== `num'
				}
				}
		sort DIST
		local max =  0.05*`cells'
		drop if DIST > `max'
		
		* GENERATE HEIGHT PANEL
		twoway ///
			(rcap ciuDLM cilDLM DIST, sort color(red) ) ///
			/// (scatter bDLM DIST, mcolor(red)) ///
			(line bDLM DIST, lcolor(red)) ///
			(rcap ciuDR cilDR DIST, sort color(black) lpattern(dash)) ///
			/// (scatter bDR DIST, mcolor(black)) ///
			(line bDR DIST, lcolor(black) lpattern(dash)) ///
			, graphregion(color(white)) xtitle("Distance (miles)")  ytitle("Height effect (log points)") ///
			legend(order (1 "Lake Michigan"3 "Chicago River")) yline(0) ///
			xlabel(0[0.1]`max') name(HEIGHT, replace)
		
		* COMBINE PANELS AND SAVE FIGURE 6
		grc1leg   HEIGHT LV, graphregion(color(white)) col(1)
		graph export "FIGS\FIG_6.png", width(2400) height(1800) replace		
		
* END LOG SESSION
	log close	
