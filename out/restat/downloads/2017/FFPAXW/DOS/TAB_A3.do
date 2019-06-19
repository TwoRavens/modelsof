********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE A3

* START LOG SESSION
	log using "LOGS/TAB_A3", replace
* LOAD DATA
	u "DATA/BUILDING_LV.dta", clear

	* OPEN DECADE LOOP
		foreach num of numlist 1870 1890 1910 1920 1930 1940 1950 1960 1970 1980 1990 2000 2010 {
	
		* SET INITIAL VALUES TO MEAN COORDINATES
			sum x_build_coord  if CC == `num'
				local ini_x = r(mean)
			sum y_build_coord if CC == `num'
				local ini_y = r(mean)
		* NLS ESTIMATION	
			eststo: nl (lHEIGHT = {c}+{a}*log( sqrt([ {x_coord} - x_build_coord]^2 + [ {y_coord} - y_build_coord]^2)    )  ) if CC == `num'  , initial(x_coord `ini_x' y_coord `ini_y') 
				scalar H_cbd_x_`num' =  _b[/x_coord]
				scalar H_cbd_y_`num' =  _b[/y_coord]
				scalar H_d_cbd_`num' =  _b[/a]
				estadd scalar Cohort = `num'
	* CLOSE DECADE LOOP	
		}
	
* WRITE TABLE A3	
	esttab using "TABS/TAB_A3.rtf", replace b(3) se(3) onecell label compress r2(3) aic(1) stats( Cohort  N  r2 , fmt(%18.3g)) ///
	title ("NLS estimates of CBD coordinates - building height") modelwidth(6) nogap star(* 0.1 ** 0.05 *** 0.01) note("Notes:	Unit of observation is new constructions. Standard errors in parentheses.")
	eststo clear
	
	
* END LOG SESSION
 log close	
