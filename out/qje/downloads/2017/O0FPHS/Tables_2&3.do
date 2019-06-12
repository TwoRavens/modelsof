*THIS DO FILE RUNS THE REGRESSIONS FOR THE FOLLOWING TABLES:
* Table 2: First Stage, 819-level
* Table 5: Network Spillovers and Passengers, 819-level

clear 
set more off

cd "/Users/dyanag/Dropbox/PROJECTS/Airplanes/data/Working Data/"


*-------- TABLE 2:  Effect on Air Links, Airport Level -------------*
	*use "MAIN_connections_June2017_withNL.dta", replace // Data with proprietary variables from ICAO/Orbis
	 use "Data_for_Tables2&3.dta", replace 			 	 // Data without proprietary variables
	set more off
	global CONTROLS0 	"nrcities_55to65 regdum*"
	global CONTROLS1989  "z_EIGEN_1989 totnr_twice1989 totnr_weekly1989 totnr_daily1989  ltotnr_cityconnects1989 totnr_states_twice1989 ltotnr_seats1989 ltotnr_flights1989 ltotnr_passengers1989 nrcities_55to65"
	global TZONE_DistEq "timezone_fullhours ldist_eq" 
	global NLPOP819 "Lights92_025grid pop90_025grid"
	global CONTROLS0_EI "EIGEN89_55to65 regdum*"
	capture erase "results/Table2.xls"
	capture erase "results/Table2.txt"

	qui:reg totnr_weekly1989	   		share_below6000_w500 $CONTROLS0, cl(countrycode)
			outreg2 	 				share_below6000_w500 using "results/Table2.xls", se dec(2) nocons keep(share_below6000_w500) 
	qui:reg totnr_weekly2014	   		share_below6000_w500 $CONTROLS0, cl(countrycode)
			outreg2 	 				share_below6000_w500 using "results/Table2.xls", se dec(2) nocons keep(share_below6000_w500) 
	qui:reg totnr_weekly2014	   		share_below6000_w500 $CONTROLS0 $CONTROLS1989 , cl(countrycode)
			outreg2 	 				share_below6000_w500 using "results/Table2.xls", se dec(2) nocons keep(share_below6000_w500) 
			sum totnr_weekly1989 totnr_weekly2014 if e(sample)==1
	qui:reg totnr_weekly2014	   		share_below6000_w500 $CONTROLS0 $CONTROLS1989  $TZONE_DistEq, cl(countrycode)
			outreg2 	 				share_below6000_w500 using "results/Table2.xls", se dec(2) nocons keep(share_below6000_w500) 
	qui:reg totnr_weekly2014	   		share_below6000_w500 $CONTROLS0 $CONTROLS1989  $TZONE_DistEq $NLPOP819, cl(countrycode)
			outreg2 	 				share_below6000_w500 using "results/Table2.xls", se dec(2) nocons keep(share_below6000_w500) 

	qui:reg z_EIGEN_1989	   		    shareEI_below6000_w500 $CONTROLS0_EI $TZONE_DistEq $NLPOP819, cl(countrycode)
			outreg2 	 				shareEI_below6000_w500 using "results/Table2.xls", se dec(2) nocons keep(shareEI_below6000_w500) 
	qui:reg z_EIGEN_2014	   		    shareEI_below6000_w500 $CONTROLS0_EI $TZONE_DistEq $NLPOP819 $CONTROLS1989 , cl(countrycode)
			outreg2 	 				shareEI_below6000_w500 using "results/Table2.xls", se dec(2) nocons keep(shareEI_below6000_w500) 
	qui:reg zEIGEN_90to00	   			shareEI_below6000_w500 $CONTROLS0_EI $TZONE_DistEq $NLPOP819 $CONTROLS1989, cl(countrycode)
			outreg2 	 				shareEI_below6000_w500 using "results/Table2.xls", se dec(2) nocons keep(shareEI_below6000_w500) 
	qui:reg zEIGEN_90to10	   			shareEI_below6000_w500 $CONTROLS0_EI $TZONE_DistEq $NLPOP819 $CONTROLS1989, cl(countrycode)
			outreg2 	 				shareEI_below6000_w500 using "results/Table2.xls", se dec(2) nocons keep(shareEI_below6000_w500)
	qui:reg zEIGEN_90to10	   								   share_below6000_w500 $CONTROLS0_EI $TZONE_DistEq $NLPOP819 $CONTROLS1989, cl(countrycode)
			outreg2 	 									   share_below6000_w500   using "results/Table2.xls", se dec(2) nocons keep(share_below6000_w500)
	qui:reg zEIGEN_90to10	   			shareEI_below6000_w500 share_below6000_w500 $CONTROLS0_EI $TZONE_DistEq $NLPOP819 $CONTROLS1989, cl(countrycode)
			outreg2 	 									   using "results/Table2.xls", se dec(2) nocons keep(shareEI_below6000_w500 share_below6000_w500)

			sum totnr_weekly2014  z_EIGEN_1989 z_EIGEN_2014 zEIGEN_90to00 zEIGEN_90to10 zEIGEN_90to10 totnr_weekly2014 if e(sample)==1

*-------------------- TABLE 3: NETWORK SPILLOVERS  --------------------*
	*use "MAIN_connections_June2017_withNL.dta", replace // Data with proprietary variables from ICAO/Orbis
	use "Data_for_Tables2&3.dta", replace 			 	 // Data without proprietary variables
	global CONTROLS1989_2 "totnr_weekly_55to651989  totnr_weekly_20to551989  totnr_weekly_65to1001989"
	set more off
	capture erase "results/Table3.xls"
	capture erase "results/Table3.txt"

	reg 	totnr_weekly_55to652014		 shareEI_below6000_w500 						  $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq, cl(countrycode)
			outreg2 	 				 shareEI_below6000_w500 using "results/Table3.xls", se dec(2) nocons keep(shareEI_below6000_w500)
	ivreg2 	totnr_weekly2014  	   		 (totnr_weekly_55to652014=shareEI_below6000_w500) $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq , cl(countrycode)	ffirst
			outreg2 	 		  		  totnr_weekly_55to652014 using "results/Table3.xls", se dec(2) nocons keep(totnr_weekly_55to652014)
	ivreg2 	totnr_weekly2014  	   		 (totnr_weekly_55to652014=shareEI_below6000_w500) $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq $NLPOP819, cl(countrycode)	ffirst
			outreg2 	 		  		  totnr_weekly_55to652014 using "results/Table3.xls", se dec(2) nocons keep(totnr_weekly_55to652014)
	reg 	totnr_weekly_20to552014		 shareEI_below6000_w500 						  $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq, cl(countrycode)
			outreg2 	 				 shareEI_below6000_w500 using "results/Table3.xls", se dec(2) nocons keep(shareEI_below6000_w500)
	ivreg2 	totnr_weekly_20to552014		 (totnr_weekly_55to652014=shareEI_below6000_w500) $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq, cl(countrycode)	ffirst
			outreg2 	 		  		  totnr_weekly_55to652014 using "results/Table3.xls", se dec(2) nocons keep(totnr_weekly_55to652014)
	ivreg2 	totnr_weekly_20to552014		 (totnr_weekly_55to652014=shareEI_below6000_w500) $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq $NLPOP819, cl(countrycode)	ffirst
			outreg2 	 		  		  totnr_weekly_55to652014 using "results/Table3.xls", se dec(2) nocons keep(totnr_weekly_55to652014)
	reg 	totnr_weekly_65to1002014	 shareEI_below6000_w500 						  $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq, cl(countrycode)
			outreg2 	 				 shareEI_below6000_w500 using "results/Table3.xls", se dec(2) nocons keep(shareEI_below6000_w500)
	ivreg2 	totnr_weekly_65to1002014	 (totnr_weekly_55to652014=shareEI_below6000_w500) $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq, cl(countrycode)	ffirst
			outreg2 	 		  		  totnr_weekly_55to652014 using "results/Table3.xls", se dec(2) nocons keep(totnr_weekly_55to652014)
	ivreg2 	totnr_weekly_65to1002014	 (totnr_weekly_55to652014=shareEI_below6000_w500) $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq $NLPOP819, cl(countrycode)	ffirst
			outreg2 	 		  		  totnr_weekly_55to652014 using "results/Table3.xls", se dec(2) nocons keep(totnr_weekly_55to652014)
	reg 	totnr_passengers2014	     shareEI_below6000_w500 						  $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq, cl(countrycode)
			outreg2 	 				 shareEI_below6000_w500 using "results/Table3.xls", se dec(3) nocons keep(shareEI_below6000_w500) 
	ivreg2 	totnr_passengers2014	    (z_EIGEN_2014=shareEI_below6000_w500) 			  $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq, cl(countrycode)	ffirst
			outreg2 	 		  		 z_EIGEN_2014 using "results/Table3.xls", se dec(3) nocons keep(z_EIGEN_2014)
	ivreg2 	totnr_passengers2014	    (z_EIGEN_2014=shareEI_below6000_w500) 			  $CONTROLS0_EI $CONTROLS1989 $CONTROLS1989_2  $TZONE_DistEq $NLPOP819, cl(countrycode)	ffirst
			outreg2 	 		  		 z_EIGEN_2014 using "results/Table3.xls", se dec(3) nocons keep(z_EIGEN_2014)

			
	
