********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES FIGURE 2

* START LOG SESSION
	log using "LOGS/FIG_2", replace

* GENERATE PRE-1870 OBSERVATIONS
	set obs 3
	gen buildingnumberebn = .
	gen officialname = ""
	gen CC  = .
	gen HEIGHT = . 
	
	replace buildingnumberebn = 131024 if _n == 1
	replace officialname = "Holy Name Cathedral" if _n == 1
	replace CC = 1850 if _n == 1
	replace HEIGHT = 74.68 if _n == 1
	
	replace buildingnumberebn = 209289 if _n == 2
	replace officialname = "University Hall" if _n == 2
	replace CC = 1860 if _n == 2
	replace HEIGHT = 17.57 if _n == 2	
	
	replace buildingnumberebn = 212561 if _n == 3
	replace officialname = "Chicago Water Tower" if _n == 3
	replace CC = 1860 if _n == 3
	replace HEIGHT = 55.63 if _n == 3	

* APPEND OBSERVATIONS FROM 1850s AND 1860s NOT USED IN REST OF THE ANALYSIS	
	append using  "DATA/BUILDING_LV.dta"

* TALLEST BUILDINGS  AND HEIGHT BY PERCENTILE
	egen maxheight = max(HEIGHT), by(CC)
	egen medianheight = median(HEIGHT), by(CC)
	egen pc75height = pctile(HEIGHT), by(CC) p(75)	
	egen pc90height = pctile(HEIGHT), by(CC) p(90)	 
	egen pc95height = pctile(HEIGHT), by(CC) p(95)	 
	egen pc99height = pctile(HEIGHT), by(CC) p(99)		
	
	
* GENERATE LABEL VARIABLE 
	 gen MAXNAMEH = officialname if HEIGHT == maxheight
* CONSOLIDATE DATA SET
	 duplicates drop maxheight medianheight pc75height pc90height pc95height pc99height MAXNAMEH, force
	
* GENERATE TALLEST BUILDINGS IN THE WORLD HEIGHTS
	gen worldfloors = . 
	replace worldfloors = 30 if CC == 1890
	replace worldfloors = 50 if CC == 1900
	replace worldfloors = 57 if CC == 1910
	replace worldfloors = 57 if CC == 1920
	replace worldfloors = 102 if CC == 1930	
	replace worldfloors = 102 if CC == 1940
	replace worldfloors = 102 if CC == 1950
	replace worldfloors = 102 if CC == 1960
	replace worldfloors = 108 if CC == 1970
	replace worldfloors = 108 if CC == 1980
	replace worldfloors = 108 if CC == 1990
	replace worldfloors = 108 if CC == 2000
	replace worldfloors = 163 if CC == 2010

* GENERATE TALLEST BUILDINGS IN THE WORLD NAMES 	
	gen worldheight = . 
	gen worldheightname = ""
	replace worldheight = 142 if CC == 1850
	replace worldheightname = "Strasbourg (France) Cathedral" if CC == 1850
	replace worldheight = 142 if CC == 1860
	replace worldheightname = ""	 if CC == 1860 
	replace worldheight = 147 if CC == 1870
	replace worldheight = 151 if CC == 1880
	replace worldheight = 151 if CC == 1890
	replace worldheight = 186.57 if CC == 1900
	replace worldheightname = "Singer Building, New York"	 if CC == 1900 		
	replace worldheight = 241 if CC == 1910
	replace worldheight = 241 if CC == 1920
	replace worldheightname = ""	 if CC == 1920 		
	replace worldheight = 381 if CC == 1930
	replace worldheightname = "Empire State Building, New York"	 if CC == 1930 			
	replace worldheight = 381 if CC == 1940
	replace worldheightname = ""	 if CC == 1940 	
	replace worldheight = 381 if CC == 1950
	replace worldheightname = ""	 if CC == 1950 	
	replace worldheight = 381 if CC == 1950
	replace worldheightname = ""	 if CC == 1950 		
	replace worldheight = 381 if CC == 1960
	replace worldheightname = ""	 if CC == 1960 			
	replace worldheight = 442 if CC == 1970
	replace worldheightname = ""	 if CC == 1970 				
	replace worldheight = 442 if CC == 1980
	replace worldheightname = ""	 if CC == 1980 					
	replace worldheight = 452 if CC == 1990
	replace worldheight = 509.2 if CC == 2000
	replace worldheightname = "Taipei 101, Taipei"	 if CC == 2000			
	replace worldheight = 828 if CC == 2010
	replace worldheightname = "Burj Khalifa, Dubai"	 if CC == 2010				

*	ADJUST VARIABLE 
	gen WORLDPOST = 11
	replace WORLDPOST = 4 if CC == 1850
	sort CC
	gen POS = 9 if CC > 1950
	replace POS = 3 if CC <=1950
	replace POS = 9 if CC ==1970
	replace POS = 6 if CC == 2000
	replace POS = 9 if CC == 1920	
	replace MAXNAMEH = "" if CC == 1980
	replace MAXNAMEH = "" if CC == 1990
	replace MAXNAMEH = "" if CC == 1940
	replace MAXNAMEH = "" if CC == 2010
	replace MAXNAMEH = "" if CC == 1910
	replace MAXNAMEH = "" if CC == 1900
	replace MAXNAMEH = "" if CC == 1890
	drop if MAXNAMEH == "Civic Opera Building"
	
* GENERATE FIGURE	
	twoway ///
		(line medianheight CC , lcolor(gs10) lpattern(shortdash))  ///
		(line pc75height CC, lcolor(gs10) lpattern(longdash)) ///
		(line pc90height CC, lcolor(gs10) lpattern(solid))  	///
		(line maxheight CC, lcolor(black) lpattern(solid))  	///
		(line worldheight CC, lpattern(dash)  lcolor(black) )  	///	
		(scatter maxheight CC if MAXNAMEH != "", mlabel(MAXNAMEH) mlabv(POS) mlabcolor(black) mcolor(black) mlcolor(black)) ///
		(scatter worldheight CC if worldheightname != "", mlabel(worldheightname) mlabv(WORLDPOS) mlabcolor(black) mcolor(none) mlcolor(black) msymbol(s) ) ///
		, xlabel(1850[20]2010) yscale(log) ylabel(25 50 100 250 500 750) ytitle("Height in meters (log scale)") legend(off)   graphregion(color(white))	
		graph export "FIGS\FIG_2.png", width(2400) height(1800) replace	
	
* END LOG SESSION
	log close
