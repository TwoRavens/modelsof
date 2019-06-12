*** Robots: load PWT 8.0 exchange rate data into Stata

u "..\input\PWT\pwt80.dta", clear 
 
	keep countrycode year xr
	rename countrycode country
	replace country="UK" if country=="GBR"
	replace country="US" if country=="USA"
	replace country="GER" if country=="DEU"
		
sa "..\temp\PWT_xrates.dta", replace
