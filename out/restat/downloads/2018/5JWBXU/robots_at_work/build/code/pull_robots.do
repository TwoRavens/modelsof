*** Robots: load World Robotics data into Stata -- industry data
	
clear
	
	local indlist "10-12 13-15 16 17-18 19 19-22 19-22u 20-21 22 23 24 24-28"
	local indlist "`indlist' 25 260 261 262 26-27 263 265 271 275 279 28 29 291"
	local indlist "`indlist' 293 2931 2932 2933 2934 2939 299 2999 29a 30 90"
	local indlist "`indlist' 91 99 A-B C D E F M"
	
	gen code_robots	= ""
	
sa "..\temp\robots_delvrd", replace
sa "..\temp\robots_stock", replace
	
	local path_delvrd "robot deliveries"	
	local path_stock "robot stocks"
	
	foreach var in delvrd stock {
				
		foreach name in `indlist' {
			
			import excel "..\input\IFR/`path_`var''/`name'.xlsx", clear cellrange(A7:T90)
				 
			rename A cntry_name
			
			local varli "B C D E F G H I J K L M N O P Q R S T"
			tokenize `varli'
			local i = 1
			local j = 1992
			while "``i''"!="" {
				local j = `j' + 1
				ren ``i'' `var'`j'
				local ++i
			}
			
			reshape long `var', i(cntry_name) j(year)
			
			gen code_robots = "`name'"
				 
			append using "..\temp\robots_`var'"

sa "..\temp\robots_`var'", replace
		}
	}
	
u "..\temp\robots_delvrd", clear

	merge 1:1 cntry_name code_robots year using "..\temp\robots_stock"
		drop _mer
		
	merge m:1 code_robots using "..\input\IFR\ind_IFR.dta"
		drop _mer
		
	do rename_robots_country
			
	keep if country!=""
	
	so cntry_name ind year
	
	local varlist "country cntry_name year ind code_robots level levelup subcategories ind code_robots delvrd stock"
	
	keep `varlist'
	order `varlist'
	
	compress

sa "..\temp\robots_raw", replace

erase "..\temp\robots_delvrd.dta"
erase "..\temp\robots_stock.dta"
