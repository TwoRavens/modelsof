* generating replaceability variable at industry level (1980 employment structure)

u "..\temp\us_census_1980", clear
	
	drop if ind1990==0 | ind1990>960
	
	* merge occupational replacability variable
merge m:1 occ1990 using "..\temp\replaceability_occ_1980"
		drop _mer
					
* generate hours, interact with replaceability
	gen hours = uhrswork*wkswork1
	gen hours_replace = hours*replaceable
			
* bridge census industries to EUKLEMS industries
merge m:1 ind1990 using "..\input\EUKLEMS\xwalk_EUKLEMS-ind1990"
		drop _mer
		
* sum by EUKLEMS industries (weighted using person weights)
	collapse (sum) hours hours_replace [ w=perwt ], by(ind_EUKLEMS)
	
* convert replaceability variable to a fraction
	replace hours_replace = hours_replace/hours
		
	drop hours	
	
	la var hours_repl "fraction of hours replaceable in industry"
		
	so ind_EUKLEMS
	
	compress
	
sa "..\temp\replaceability_ind", replace
