*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Figure A.8 of the web appendix of Berman and Couttenier (2014)									  *
* This version: september 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
						*---------------------------------------------------------------------------------------*
						*---------------------------------------------------------------------------------------*
						*    		FIGURE A.8- Agricultural Commodities and conict: an illustration		   *    
						*---------------------------------------------------------------------------------------*
						*---------------------------------------------------------------------------------------*
					
					
					**** COFFEE ****
					*--------------*

* Figure all countries	*				
use "$Output_data\data_BC_Restat2014", clear	
	bys year : egen t = sum(conflict_c3) if suitable40_coffee == 1
	bys year : egen conflict40 = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_coffee == 1
	bys year : egen tot_gid_suitable  = max(t)
	drop t

	bys year : egen t = sum(conflict_c3) if suitable40_coffee == 0
	bys year : egen conflict = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_coffee == 0
	bys year : egen tot_gid  = max(t)
	drop t

	gen ratio_s = conflict40 / tot_gid_suitable
	gen ratio  	= conflict / tot_gid


	collapse (mean) price_coffee  ratio* , by(year)
	keep if year > 1988
	label var ratio_s 	"Unsuitable cells"
	label var ratio 	"Suitable cells"
	label var price_coffee 	"World price ($)"

	twoway 	(line ratio year, yaxis(1) lpattern(dash) lwidth(medthick )  ) ///
			(line ratio_s year, yaxis(1) lpattern(dash_dot) lwidth(medthick) ) /// 
			(line price_coffee year, yaxis(2) lwidth(medthick )  ), ytitle("% of conflict")  graphregion(color(white)) title("")

			
* Figure Ivory Coast *
use "$Output_data\data_BC_Restat2014", clear
	keep if iso3 =="CIV" 
	bys year : egen t = sum(conflict_c3) if suitable40_coffee == 1
	bys year : egen conflict40 = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_coffee == 1
	bys year : egen tot_gid_suitable  = max(t)
	drop t

	bys year : egen t = sum(conflict_c3) if suitable40_coffee == 0
	bys year : egen conflict = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_coffee == 0
	bys year : egen tot_gid  = max(t)
	drop t

	gen ratio_s = conflict40 / tot_gid_suitable
	gen ratio  	= conflict / tot_gid


	collapse (mean) price_coffee  ratio* , by(year)
	keep if year > 1988
	label var ratio_s 	"Unsuitable cells"
	label var ratio 	"Suitable cells"
	label var price_coffee 	"World price ($)"

	twoway 	(line ratio year, yaxis(1) lpattern(dash) lwidth(medthick )  ) ///
			(line ratio_s year, yaxis(1) lpattern(dash_dot) lwidth(medthick) ) /// 
			(line price_coffee year, yaxis(2) lwidth(medthick )  ), ytitle("% of conflict")  graphregion(color(white)) title("")

					
					**** SORGHUM ****
					*--------------*
 					
* Figure all countries	*				
use "$Output_data\data_BC_Restat2014", clear		
	bys year : egen t = sum(conflict_c3) if suitable40_sorghum == 1
	bys year : egen conflict40 = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_sorghum == 1
	bys year : egen tot_gid_suitable  = max(t)
	drop t

	bys year : egen t = sum(conflict_c3) if suitable40_sorghum == 0
	bys year : egen conflict = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_sorghum == 0
	bys year : egen tot_gid  = max(t)
	drop t

	gen ratio_s = conflict40 / tot_gid_suitable
	gen ratio  	= conflict / tot_gid


	collapse (mean) price_sorghum  ratio* , by(year)
	keep if year > 1988
	label var ratio_s 	"Unsuitable cells"
	label var ratio 	"Suitable cells"
	label var price_sorghum 	"World price ($)"

	twoway 	(line ratio year, yaxis(1) lpattern(dash) lwidth(medthick )  ) ///
			(line ratio_s year, yaxis(1) lpattern(dash_dot) lwidth(medthick) ) /// 
			(line price_sorghum year, yaxis(2) lwidth(medthick )  ), ytitle("% of conflict")  graphregion(color(white)) title("")

				
* Figure Kenya	*				
use "$Output_data\data_BC_Restat2014", clear
	keep if iso3 == "KEN"
	bys year : egen t = sum(conflict_c3) if suitable40_sorghum == 1
	bys year : egen conflict40 = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_sorghum == 1
	bys year : egen tot_gid_suitable  = max(t)
	drop t

	bys year : egen t = sum(conflict_c3) if suitable40_sorghum == 0
	bys year : egen conflict = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_sorghum == 0
	bys year : egen tot_gid  = max(t)
	drop t

	gen ratio_s = conflict40 / tot_gid_suitable
	gen ratio  	= conflict / tot_gid


	collapse (mean) price_sorghum  ratio* , by(year)
	keep if year > 1988
	label var ratio_s 	"Unsuitable cells"
	label var ratio 	"Suitable cells"
	label var price_sorghum 	"World price ($)"

	twoway 	(line ratio year, yaxis(1) lpattern(dash) lwidth(medthick )  ) ///
			(line ratio_s year, yaxis(1) lpattern(dash_dot) lwidth(medthick) ) /// 
			(line price_sorghum year, yaxis(2) lwidth(medthick )  ), ytitle("% of conflict")  graphregion(color(white)) title("")

					**** MAIZE ****
					*-------------*
 				 	
* Figure all countries	*				
use "$Output_data\data_BC_Restat2014", clear	
	bys year : egen t = sum(conflict_c3) if suitable40_maize == 1
	bys year : egen conflict40 = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_maize == 1
	bys year : egen tot_gid_suitable  = max(t)
	drop t

	bys year : egen t = sum(conflict_c3) if suitable40_maize == 0
	bys year : egen conflict = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_maize == 0
	bys year : egen tot_gid  = max(t)
	drop t

	gen ratio_s = conflict40 / tot_gid_suitable
	gen ratio  	= conflict / tot_gid


	collapse (mean) price_maize  ratio* , by(year)
	keep if year > 1988
	label var ratio_s 	"Unsuitable cells"
	label var ratio 	"Suitable cells"
	label var price_maize 	"World price ($)"

	twoway 	(line ratio year, yaxis(1) lpattern(dash) lwidth(medthick )  ) ///
			(line ratio_s year, yaxis(1) lpattern(dash_dot) lwidth(medthick) ) /// 
			(line price_maize year, yaxis(2) lwidth(medthick )  ), ytitle("% of conflict")  graphregion(color(white)) title("")
				
* Figure Ethiopia	*
use "$Output_data\data_BC_Restat2014", clear	
	keep if iso3 == "ETH"
	bys year : egen t = sum(conflict_c3) if suitable40_maize == 1
	bys year : egen conflict40 = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_maize == 1
	bys year : egen tot_gid_suitable  = max(t)
	drop t

	bys year : egen t = sum(conflict_c3) if suitable40_maize == 0
	bys year : egen conflict = max(t)
	drop t 

	bys year : egen t = count(gid) if suitable40_maize == 0
	bys year : egen tot_gid  = max(t)
	drop t

	gen ratio_s = conflict40 / tot_gid_suitable
	gen ratio  	= conflict / tot_gid


	collapse (mean) price_maize  ratio* , by(year)
	keep if year > 1988
	label var ratio_s 	"Unsuitable cells"
	label var ratio 	"Suitable cells"
	label var price_maize 	"World price ($)"

	twoway 	(line ratio year, yaxis(1) lpattern(dash) lwidth(medthick )  ) ///
			(line ratio_s year, yaxis(1) lpattern(dash_dot) lwidth(medthick) ) /// 
			(line price_maize year, yaxis(2) lwidth(medthick )  ), ytitle("% of conflict")  graphregion(color(white)) title("")

							
