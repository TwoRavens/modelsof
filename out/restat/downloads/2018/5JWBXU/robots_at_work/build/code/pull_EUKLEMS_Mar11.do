*** EUKLEMS Mar 2009 release and 2011 Updates : load data into Stata -- basic
	
import delimited "..\input\EUKLEMS\all_countries_09I.txt",  clear
	  		 
	ren _* x*
			
	reshape long x, i(country code var) j(year)
			
	reshape wide x, i(country code year) j(var) string
			
	ren x* *
		
	do labels_EUKLEMS_ind

	local order "country code desc year"
	
	order `order'
	so `order'
	
	do labels_EUKLEMS_var
	
sa "..\temp\EUKLEMS_Mar11", replace

** drop disaggregated industries for Korea, Japan

u "..\temp\EUKLEMS_Mar11", clear

	drop if country=="JPN" | country=="KOR"

	collapse year, by(code)
		gen ind_some = 1
				
sa "..\temp\ind_some", replace

u "..\temp\EUKLEMS_Mar11", clear
	
	merge m:1 code using "..\temp\ind_some"
		keep if _merge==3
			drop _merg
	
	drop ind_some	
	drop if country=="JPN"
		
sa "..\temp\EUKLEMS_Mar11", replace

erase "..\temp\ind_some.dta"
