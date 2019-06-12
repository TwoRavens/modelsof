** EUKLEMS Mar 2008 Release : load data into Stata -- pulling additional output files
** these contain basic skill share data, need these for Denmark, France, Greece, Ireland, Sweden

import delimited "..\input\EUKLEMS\all_countries_alt_08I.txt",  clear
	  		 
	ren _* x*
			
	reshape long x, i(country code var) j(year)
			
	reshape wide x, i(country code year) j(var) string
			
	ren x* *
		
	keep country code year H_EMP LAB H_HS H_LS H_MS LABHS LABLS LABMS
	
	keep if country=="DNK" | country=="FRA" | country=="GRC" 	///
							|  country=="IRL" | country=="SWE"
 	
	foreach skill in HS MS LS {
		rename LAB`skill' LAB_`skill' 
	}
		
	replace code = "23t25" if code=="23" | code=="24" | code=="25"
	
	// collapse chemical industries - weighted means
	
sa "..\temp\EUKLEMS_Mar08_alt", replace
	
	collapse H_HS H_LS H_MS [ w=H_EMP ], by(country code year)
	
sa "..\temp\temp", replace

u "..\temp\EUKLEMS_Mar08_alt", clear

	collapse LAB_HS LAB_LS LAB_MS [ w=LAB ], by(country code year)
	
	merge 1:1 country code year using "..\temp\temp"
		keep if _merg==3
			drop _merg
		
erase "..\temp\temp.dta"
				
sa "..\temp\EUKLEMS_Mar08_alt", replace
