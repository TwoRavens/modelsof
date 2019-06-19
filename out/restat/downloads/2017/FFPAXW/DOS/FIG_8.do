********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES FIGURE 8

* START LOG SESSION
	log using "LOGS/FIG_8", replace

	* LOAD DATA
		u "DATA/BUILDING_LV.dta", clear

* DATA PREP ********************************************************************	
		
	* GENERATE INDICATOR FOR NON-COMMERCIAL NON-RESIDENTIAL BUILDINGS		
			gen OTHER = 1-COMMERICIAL-RESIDENTIAL		
	
	* GENERATE YEAR TREND WITH 0-VALUE IN 2000
				gen Y = YEAR - 2000
				label var Y "Year - 2000"		
		
	* GEN INTERACTIONS
	
		* LAND PRICE x LAND USE INTERACTIONS
		gen lLV_RES = lLV * RESIDENTIAL		
		gen lLV_COM = lLV * COM
		gen lLV_OTHER = lLV * OTHER
		
		* LAND PRICE x LAND USE x TIME TREND INTERACTIONS
		gen lLV_Y = lLV*Y
		gen lLV_Y_COM = lLV*Y*COMMERICIAL
		gen lLV_Y_RES = lLV*Y*RESIDENTIAL
		gen lLV_Y_OTHER = lLV*Y*OTHER

		* COHORT EFFECTS x LAND USE INTERACTIONS
		tab CC, gen(CCD)
		foreach var of varlist CCD* {
			gen COM_`var' = COMMERICIAL *`var'
			gen RES_`var' = RESIDENTIAL *`var'
			}

		* LABEL GENERATED VARIABLES 	
			label var lLV_COM "Log land price x commercial"
			label var lLV_RES "Log land price x residential"
			label var lLV_OTHER "Log land price x (1 - commercial - residential)"
			label var lLV_Y "Log land price x (Year - 2000)"	
			label var lLV_Y_COM "Log land price x commercial  x (year - 2000)"
			label var lLV_Y_RES "Log land price x residential  x (year - 2000)"
			label var lLV_Y_OTHER "Log land price x (1 - commercial - residential)  x (year - 2000)"
		
		* GENERATE DISTANCE FROM RIVER DUMMY FOR IV GENERATION		
			gen Dr = dist_river < 0.1
			label var Dr "River within 0.1 mile (dummy)"
		
		* GENERATE IVs (INTERACTIONS OF GEOGRAPHIC FEATURES, LAND USE, AND TIME TREND
		local IV ldist_cbd ldist_lm Dr
		* ldist_lm ldist_river 
		foreach var of varlist `IV' {
			gen IV_COM_`var' = `var' * COMMERICIAL
			gen IV_RES_`var' = `var' * RESIDENTIAL
			gen IV_OTHER_`var' = `var' * OTHER
			* gen IV_Y_`var' = `var' * (YEAR - 2000)
			gen IV_COM_Y_`var' = `var' * (CC - 2000) * COMMERICIAL
			gen IV_RES_Y_`var' = `var' * (CC - 2000) * RESIDENTIAL
			gen IV_OTHER_Y_`var' = `var' * (CC - 2000) * OTHER
			}
	* DEFINE PERIODS
		gen PERIOD = 1 if YEAR <= 1920
		replace PERIOD = 2 if YEAR > 1920 & YEAR <=1957
		replace PERIOD = 3 if YEAR > 1957
		
	* SAVE TEMPORARY DATA SET 
	save "DATA/TEMP/temp_lwr.dta", replace

* LWR **************************************************************************
	
	* OPEN PERIOD LOOP 
		foreach PER of numlist 1/3 {
		
		* OPEN LAND USE LOOP
			foreach  USE in COMMERICIAL RESIDENTIAL OTHER { 
			
			* LOAD TEMPORARY DATA SET
			u "DATA/TEMP/temp_lwr.dta", clear 
			
			
			* RESTRICT DATA SET TO PERIOD
				keep if PERIOD == `PER'
			* RESTRICT DATA SET TO LAND USE 	
				keep if `USE' == 1
		
			* PERARE FOR LWR LOOPS
			sort YEAR
			sum YEAR
			local N = r(N)
				gen lFHEIGHT = . 
				gen w = .		
				gen dist_w = .
				gen temp_w = .
				gen height_w =.
				gen tdist = . 
				gen gdist = . 
				gen hdist = .
				gen BETA = .
				sort HEIGHT
				
				* OPEN LWR LOOP 
				forval num = 1/ `N' {
					* DEFINE BANDWIDTH ADJUSTEMENT FACTOR DUE TO  MULTIPLE COMPONENTS ENTERING WEIGHT (HIGHER VALUES IMPLY MORE SMOOTHING)
						local BWA = 3
					// GEN TIME DISTANCE WEIGHT
					qui replace  tdist=((YEAR-YEAR[`num'] )^2)^0.5 // GENERATES TIME DISTANCE
					qui sum tdist 
					local tbw =  [ 1.06*r(sd)*r(N)^(-1/5) ] *`BWA' // DEFINES BANDWIDTH
					qui replace temp_w = 1/(`tbw'*(2*_pi)^0.5)*exp(-0.5* ((YEAR-YEAR[`num'])/`tbw')^2 )
					qui sum temp_w 
					quietly  replace temp_w = temp_w/r(mean)	
					// GEN GEOGRAPHIC DISTANCE WEIGHT
					qui replace  gdist= ( [(x_build_coord-x_build_coord[`num'])^2+(y_build_coord-y_build_coord[`num'])^2]^0.5 )  / 5280 // GENERATES GEOGRAPHIC DISTANCE
					qui sum  gdist
					local dbw = [1.06*r(sd)*r(N)^(-1/5) ] *`BWA' // DEFINES BANDWIDTH
					qui replace dist_w = 1/(`dbw'*(2*_pi)^0.5)*exp(-0.5* ((gdist)/`dbw')^2 )
					qui sum dist_w 
					quietly  replace dist_w = dist_w/r(mean)	
					// COMBINE TIME DISTANCE AND GEOGRAPHIC DISTANCE WEIGHTS 
					qui replace w = temp_w  * dist_w 
					qui sum w 
					quietly  replace w = w/r(mean)
					// RUN LOCALLY WEIGHTED REGRESSION
					qui areg lHEIGHT lLV  [w=w] if _n != `num', abs(CC)
					// RECOVER PREDITED LEVELS AND DERIVATIVES	
						qui replace BETA = _b[lLV]  if `USE' ==1 &  _n == `num'
							label var BETA "Elasticity of height with respect to land price"
						qui predict temp
						qui replace lFHEIGHT = temp if  _n == `num' & `USE' ==1
						drop temp
					// DISPLACE THE STAGE IN THE LOOP	
					display `num'/`N' * 100 " % of `USE' of period " `PER'
				* CLOSE LWR LOOP
				}
				
				* SAVE TEMPORARY DATA SET
				save "DATA/TEMP/temp_`USE'_P`PER'", replace
			
		* CLOSER LAND USE LOOP 
		}
	* CLOSE PERIOD LOOP 
	}

* COMBINE DATA SETS WITH HEIGHT ELASTICITIES BY USE AND PERIOD
	u DATA/TEMP/temp_COMMERICIAL_P1, clear
		append using DATA/TEMP/temp_RESIDENTIAL_P1
		append using DATA/TEMP/temp_OTHER_P1		
		append using DATA/TEMP/temp_COMMERICIAL_P2
		append using DATA/TEMP/temp_RESIDENTIAL_P2
		append using DATA/TEMP/temp_OTHER_P2
		append using DATA/TEMP/temp_COMMERICIAL_P3
		append using DATA/TEMP/temp_RESIDENTIAL_P3
		append using DATA/TEMP/temp_OTHER_P3
		
	* DROP OUTLINER FOR IMPROVED ILLUSTRATION
	drop if BETA < -0.2
	drop if BETA > 0.8
	* GENERATE AUX. VARIABLE FOR DEFINITION OF Y-AXIS
	gen rBETA = round(BETA, 0.1)
		sum rBETA
		local minB = r(min)
		local maxB = r(max)
	
	* GENERATE FIGURE	
				twoway 	(scatter BETA YEAR if RESIDENTIAL == 1	,  msymbol(S) mlcolor(dkgreen) mfcolor(dkgreen) msize(small)) /// 
						(scatter BETA YEAR if COMMER == 1	,  mfcolor(none) msymbol(T) mlcolor(orange_red)  ) /// 
						(scatter BETA YEAR if OTHER ==1, mfcolor(none) msymbol(X)  mlcolor(blue) ) /// 
						, xline(1919.5) xline(1956.5) xlabel(1870[20]2015) ylabel(`minB'[0.1]`maxB') graphregion(color(white))  legend(order(1 "Residential" 2 "Commercial" 3 "Other") cols(3)) xtitle("Construction year") ytitle("Elasticity of height" "with respect to land price") 
	* SAVE FIGURE 8	
		graph export "FIGS/FIG_8.png", width(2400) height(1800) replace			

* END LOG SESSION
	log close
		
