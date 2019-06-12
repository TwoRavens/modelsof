clear 
set more off

cd "/Users/dyanag/Dropbox/PROJECTS/Airplanes/data/Working Data/"

	global CONTROLS0_EI "EIGEN89_55to65 regdum*"
	global CONTROLS1989  "z_EIGEN_1989 totnr_twice1989 totnr_weekly1989 totnr_daily1989  ltotnr_cityconnects1989 totnr_states_twice1989 ltotnr_seats1989 ltotnr_flights1989 ltotnr_passengers1989 nrcities_55to65" // QJE R&R
	global LIGHTS "Lights92_025grid pop90_025grid" 
	global AIRPORTS	"ldist"
	global GEO3 "avgprec avgtemp"
	global GDP90 "lrgdpna_pc1990"
	global TZONE_DistEq "timezone_fullhours ldist_eq" 

	*-----------------------------------------------------------------------------*
	*-------       TABLE 4: Effect on Night Lights (100-mile radius) -------------*
	*-----------------------------------------------------------------------------*
	
	*use "NLall_spatial_025deg.dta", replace  // Data with proprietary variables from ICAO/Orbis
	 use "Data_for_Tables4&5.dta", replace	  // Data without proprietary variables 
	set more off
	preserve
	keep  if mi_to_nid1<100		
		*Standardizing lights in sample
		foreach v in NLchange_9210_025grid NLgrowth_92to10_025grid Lights92_025grid Lights10_025grid {
			capture drop xm xsd
			egen xm=mean(`v')
			egen xsd=sd(`v')
			gen sz`v'=(`v'-xm)/xsd
			drop xm xsd
		}
		capture erase "results/Table_4.xls"
		capture erase "results/Table_4.txt"
		qui: reg Lights92_025grid 		shareEI_below6000_w500   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq , cl(countrycode)
		outreg2 	 					shareEI_below6000_w500   using "results/Table_4.xls", se nocons dec(2) keep(shareEI_below6000_w500) 
		qui: reg Lights10_025grid  		shareEI_below6000_w500   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq , cl(countrycode)
		outreg2 	 					shareEI_below6000_w500   using "results/Table_4.xls", se nocons dec(2) keep(shareEI_below6000_w500) 
		qui: reg NLchange_9210_025grid  shareEI_below6000_w500   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq  , cl(countrycode)
		outreg2 	 					shareEI_below6000_w500   using "results/Table_4.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		qui: reg NLchange_9210_025grid  shareEI_below6000_w500   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 , cl(countrycode)
		outreg2 	 				    shareEI_below6000_w500   using "results/Table_4.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		qui: reg NLchange_9210_025grid  shareEI_below6000_w500   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989  $GEO3 $GDP90 , cl(countrycode)
		outreg2 	 				    shareEI_below6000_w500   using "results/Table_4.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		
		ivreg2    NLchange_9210_025grid (zEIGEN_90to10=shareEI_below6000_w500)    $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3  $GDP90 , cl(countrycode) first
		outreg2 	 					    zEIGEN_90to10   using "results/Table_4.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		ivreg2  szNLchange_9210_025grid (zEIGEN_90to10=shareEI_below6000_w500)    $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3  $GDP90 , cl(countrycode) first
		outreg2 	 					    zEIGEN_90to10   using "results/Table_4.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		
		qui: reg   NLgrowth_92to10_025grid shareEI_below6000_w500   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq  $LIGHTS $CONTROLS1989 , cl(countrycode)
		outreg2 	 					 shareEI_below6000_w500   using "results/Table_4.xls", se nocons dec(3) keep(shareEI_below6000_w500)  
		qui: reg   NLgrowth_92to10_025grid shareEI_below6000_w500   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989  $GEO3  $GDP90 , cl(countrycode)
		outreg2 	 					 shareEI_below6000_w500   using "results/Table_4.xls", se nocons dec(3) keep(shareEI_below6000_w500)  
		
		ivreg2     NLgrowth_92to10_025grid (zEIGEN_90to10=shareEI_below6000_w500)    $TZONE_DistEq $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90 , cl(countrycode) first
		outreg2 	 						  zEIGEN_90to10   using "results/Table_4.xls", se nocons dec(3) keep(zEIGEN_90to10)  
		ivreg2  szNLgrowth_92to10_025grid (zEIGEN_90to10=shareEI_below6000_w500)    $TZONE_DistEq $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90 , cl(countrycode) first
		outreg2 	 						  zEIGEN_90to10   using "results/Table_4.xls", se nocons dec(2) keep(zEIGEN_90to10)  
			sum Lights10_025grid  szNLchange_9210_025grid NLgrowth_92to10_025grid if e(sample)==1
	restore

			
	*---------------------------------------------------------------------------------*
	*-------   	   TABLE 5:  Effect on Night Lights, Spatial Patterns     ------------*
	*---------------------------------------------------------------------------------*
	use "NLall_spatial_025deg.dta", replace
	gen shareEI89below_ldist=shareEI_below6000_w500*ldist
		set more off
		capture erase "results/Table_5.xls"
		capture erase "results/Table_5.txt"
		*all distances
		qui: reg NLchange_9210_025grid	  shareEI_below6000_w500 shareEI89below_ldist   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS 								if mi_to_nid1<999999, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500 shareEI89below_ldist  using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500 shareEI89below_ldist)
		*<500
		qui: reg NLchange_9210_025grid	  shareEI_below6000_w500 shareEI89below_ldist   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS 								if mi_to_nid1<500, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500 shareEI89below_ldist  using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500 shareEI89below_ldist)
		qui: reg NLchange_9210_025grid	  shareEI_below6000_w500 shareEI89below_ldist   $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90 	if mi_to_nid1<500, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500 shareEI89below_ldist  using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500 shareEI89below_ldist)
		*<100 MILES
		qui: reg NLchange_9210_025grid	  shareEI_below6000_w500    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1<100, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500   using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		*<100 MILES
		ivreg2 NLchange_9210_025grid 	  (zEIGEN_90to10=shareEI_below6000_w500)    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1<100, cl(countrycode) first
		outreg2 	 			   		   			    		   using "results/Table_5.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		*100-200 MILES
		qui: reg NLchange_9210_025grid	  shareEI_below6000_w500    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1>=100 &  mi_to_nid1<200, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500   using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		ivreg2 NLchange_9210_025grid 	 (zEIGEN_90to10=shareEI_below6000_w500)    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90  if mi_to_nid1>=100 &  mi_to_nid1<200, cl(countrycode) first
		outreg2 	 			   		   			    		   using "results/Table_5.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		*200-300 MILES
		qui: reg NLchange_9210_025grid	  shareEI_below6000_w500    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1>=200 &  mi_to_nid1<300, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500   using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		ivreg2 NLchange_9210_025grid 	 (zEIGEN_90to10=shareEI_below6000_w500)    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90  if mi_to_nid1>=200 &  mi_to_nid1<300, cl(countrycode) first
		outreg2 	 			   		   			    		   using "results/Table_5.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		*300-500 MILES
		qui: reg NLchange_9210_025grid	  shareEI_below6000_w500    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1>=300 &  mi_to_nid1<500, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500   using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		ivreg2 NLchange_9210_025grid 	 (zEIGEN_90to10=shareEI_below6000_w500)    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90  if mi_to_nid1>=300 &  mi_to_nid1<500, cl(countrycode) first
		outreg2 	 			   		   			    		   using "results/Table_5.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		*---- GROWTH ----*
		*<100 MILES
		qui: reg NLgrowth_92to10_025grid shareEI_below6000_w500    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1<100, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500   using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		*<100 MILES
		ivreg2 NLgrowth_92to10_025grid 	  (zEIGEN_90to10=shareEI_below6000_w500)    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1<100, cl(countrycode) first
		outreg2 	 			   		   			    		   using "results/Table_5.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		*100-200 MILES
		qui: reg NLgrowth_92to10_025grid  shareEI_below6000_w500    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1>=100 &  mi_to_nid1<200, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500   using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		ivreg2 NLgrowth_92to10_025grid 	 (zEIGEN_90to10=shareEI_below6000_w500)    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90  if mi_to_nid1>=100 &  mi_to_nid1<200, cl(countrycode) first
		outreg2 	 			   		   			    		   using "results/Table_5.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		*200-300 MILES
		qui: reg NLgrowth_92to10_025grid  shareEI_below6000_w500    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1>=200 &  mi_to_nid1<300, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500   using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		ivreg2 NLgrowth_92to10_025grid   (zEIGEN_90to10=shareEI_below6000_w500)    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90  if mi_to_nid1>=200 &  mi_to_nid1<300, cl(countrycode) first
		outreg2 	 			   		   			    		   using "results/Table_5.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		*300-500 MILES
		qui: reg NLgrowth_92to10_025grid  shareEI_below6000_w500    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90   if mi_to_nid1>=300 &  mi_to_nid1<500, cl(countrycode)
		outreg2 	 			   		  shareEI_below6000_w500   using "results/Table_5.xls", se nocons dec(2) keep(shareEI_below6000_w500)  
		ivreg2 NLgrowth_92to10_025grid   (zEIGEN_90to10=shareEI_below6000_w500)    				  $CONTROLS0_EI $AIRPORTS $TZONE_DistEq $LIGHTS $CONTROLS1989 $GEO3 $GDP90  if mi_to_nid1>=300 &  mi_to_nid1<500, cl(countrycode) first
		outreg2 	 			   		   			    		   using "results/Table_5.xls", se nocons dec(2) keep(zEIGEN_90to10)  
		
