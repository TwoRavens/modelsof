********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES FIGURE 7

* START LOG SESSION
	log using "LOGS/FIG_7", replace

* LOAD DATA
	u "DATA/BUILDING_LV.dta", clear

	* SET MEAN HEIGHT WITHIN DECADE TO ZERO
			egen meanlHEIGHT = mean(lHEIGHT), by(CC)
			gen nlHEIGHT = lHEIGHT-meanlHEIGHT
	* GENERATE INDICATOR FOR NON-COMMERCIAL NON-RESIDENTIAL BUILDINGS		
			gen OTHER = 1-COMMERICIAL-RESIDENTIAL
	
	* GENERATE FIGURE
			twoway ///
				(scatter nlHEIGHT nlLV if COMMERICIAL == 1, mcolor(none) mlcolor(red) msize(large) msymbol(T)) ///
				(lfit nlHEIGHT nlLV if COMMERICIAL == 1 , lcolor(red) lpattern(solid)) ///
				(scatter nlHEIGHT nlLV if RESIDENTIAL == 1, mcolor(none) mlcolor(dkgreen) msize(small) msymbol(Sh)) ///
				(lfit nlHEIGHT nlLV if RESIDENTIAL == 1 , lcolor(dkgreen) lpattern(longdash)) ///
				(scatter nlHEIGHT nlLV if OTHER == 1, mcolor(none) mlcolor(blue) msymbol(X) ) /// msize(tiny) 
				(lfit nlHEIGHT nlLV if OTHER == 1, lcolor(blue) lpattern(shortdash)) ///
				(function y=x , lcolor(black) range(-2 2)lpattern(solid) lwidth(thick)) ///
				,  legend(order(1 "Commercial" 3 "Residential" 5 "Other") cols(3))  graphregion(color(white)) xtitle("Log land value (at construction) normalized to mean") ytitle("Log building height normalized to mean") xlabel(-5[1]4) 
	* SAVE FIGURE 7			
				graph export "FIGS\FIG_7.png", width(2400) height(1800) replace				
			
* END LOG SESSION
	log close
