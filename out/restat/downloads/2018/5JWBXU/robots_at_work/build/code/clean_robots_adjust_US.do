* adjusting US robot deliveries using a fixed ratio
	
	gen northam = ( country=="US" | country=="CAN" | country=="MEX" )
	
	foreach var in delvrd /*stock*/ { // stocks are zero for CAN, MEX in 2011
		
		bys northam year: egen `var'_northam = total(`var') if northam==1 & year==2011
		bys northam country year: egen `var'_northam_cntry = total(`var') if northam==1 & year==2011
		
		gen adjustUS_`var'_ = `var'_northam_cntry/`var'_northam if country=="US"
		bys country: egen adjustUS_`var' = mean(adjustUS_`var'_) if country=="US"
		
		drop `var'_northam `var'_northam_cntry adjustUS_`var'_
	
	}
	
	drop northam
