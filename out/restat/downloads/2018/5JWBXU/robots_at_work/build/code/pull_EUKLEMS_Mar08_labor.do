** EUKLEMS Mar 2008 Release : load data into Stata -- labour files

import delimited "..\input\EUKLEMS\all_labour_input_08I.txt",  clear
	  		 
	ren _* x*
			
	reshape long x, i(country code var) j(year)
			
	reshape wide x, i(country code year) j(var) string
			
	ren x* *
		
	do labels_EUKLEMS_ind

	local order "country code desc year"
	
	order `order'
	so `order'
	
	replace country="US" if country=="USA-SIC"
		
	do labels_EUKLEMS_labor
	
sa "..\temp\EUKLEMS_Mar08_labor", replace
