* robots: prepare country-level datasets

		// robots and basic other variables for robot-using industries
	foreach case in robot_using robot_using_smpl {
u if code_rob!="" & $robotcountries using "..\input\robots_EUKLEMS", clear

			// keep unmatched industries, but tag them - drop them for "robot sample" dataset
		gen unmatched = ( code_robots=="90" | code_robots=="91" | code_robots=="99" )
		
		if "`case'"=="robot_using_smpl" {
			drop if unmatched==1
		}
		
			// use info on capital from 1995 if missing in 1993, 1994; and from 2005 or 2006 if missing in 2007
		local capitalvars "CAP CAP_local CAP_QI CAPLAB CAPIT CAPIT_QI CAPIT_QPH CAPITSHR CAPNIT CAPNIT_QI"
		so country ind_robots year
		
		foreach var in `capitalvars' { // HUN 
			by country ind_robots: replace `var' = `var'[_n+2] if `var'==. & `var'[_n+2]!=. & year==1993
		}
		foreach var in `capitalvars' { // BEL (2006) & KOR (2005)
			forval i = 1/2 {
				by country ind_robots: replace `var' = `var'[_n-`i'] if `var'==. & `var'[_n-`i']!=. & year==2007
			}
		}
		
		so country code_eukl year
			// use info on wage bills from 2006 if missing in 2007 
		foreach var in LAB LAB_QI { // BEL
			by country code_eukl: replace `var' = `var'[_n-1] if `var'==. & `var'[_n-1]!=. & year==2007
		}
		
			// use info on wage bills from 1995 if missing in 1993
		foreach var in LAB LAB_QI { // HUN
			by country code_euklem: replace `var' = `var'[_n+2] if `var'==. & `var'[_n+2]!=. & year==1993
		}
		
			// drop intermediate years
		keep if $robotyears
				
		local varlist "stock_pim_10 H_EMP LAB LAB_local LAB_QI VA VA_QI CAP CAP_QI" 
			
			// missings!
		collapse ( mean ) price_rob* ( rawsum ) `varlist' , by(country year)
		
		so country year
		by country: gen missing = ( VA[1]==0 | VA[2]==0 )

		drop if missing
			drop missing
				
		foreach var in H_EMP LAB LAB_local LAB_QI CAP_QI {	
			replace `var' = . if `var'==0
		}
			
		foreach var in `varlist' {
			ren `var' c_`case'_`var'
		}
		
		local name_robot_using "robot-using"
		local name_robot_using_smpl "robot-using-sample"
		
sa "..\temp\robots_country_`name_`case''", replace
	}

		// basic macro variables for whole economies
u "..\input\EUKLEMS.dta", clear
		// use info on capital from 1995 if missing in 1993, 1994; and from 2005 or 2006 if missing in 2007
	local capitalvars "CAP CAP_local CAP_QI CAPLAB CAPIT CAPIT_QI CAPIT_QPH CAPITSHR CAPNIT CAPNIT_QI"
	so country ind year
	
	foreach var in `capitalvars' { // HUN 
		by country ind_robots: replace `var' = `var'[_n+2] if `var'==. & `var'[_n+2]!=. & year==1993
	}
	foreach var in `capitalvars' { // BEL (2006) & KOR (2005)
		forval i = 1/2 {
			by country ind_robots: replace `var' = `var'[_n-`i'] if `var'==. & `var'[_n-`i']!=. & year==2007
		}
	}
		
	so country code_eukl year
		// use info on wage bills from 2006 if missing in 2007 
	foreach var in LAB LAB_QI { // BEL
		by country code_eukl: replace `var' = `var'[_n-1] if `var'==. & `var'[_n-1]!=. & year==2007
	}
	
		// use info on wage bills from 1995 if missing in 1993
	foreach var in LAB LAB_QI { // HUN
		by country code_euklem: replace `var' = `var'[_n+2] if `var'==. & `var'[_n+2]!=. & year==1993
	}	
	
		// keep TOT only
	keep if code_eukl=="TOT"
	
		// drop intermediate years
	keep if $robotyears
		
	keep country year H_EMP LAB LAB_local LAB_QI VA VA_QI CAP CAP_QI CAPITSHR
	
	keep if country=="AUS" | country=="AUT" | country=="BEL" | country=="DNK" 	///
			| country=="FIN" | country=="FRA" | country=="GER" | country=="GRC"	///
			| country=="HUN" | country=="IRL" | country=="ITA" | country=="NLD"	///
			| country=="KOR" | country=="ESP" | country=="SWE" | country=="UK" 	///
			| country=="US" 
		
	foreach var in H_EMP LAB LAB_local LAB_QI CAP CAP_QI {	
		replace `var' = . if `var'==0
	}

sa "..\temp\robots_country_all", replace

		// add skill variables for whole economies  
u "..\input\EUKLEMS_labor", clear

	keep if code_eukl=="TOT" & ( (year==1993 & country!="HUN")  | (year==1995 & country=="HUN") | year==2005 )
	
	replace year = 1993 if year==1995
	replace year = 2007 if year==2005
	
	keep country year H_HS H_MS H_LS LAB_HS LAB_MS LAB_LS

sa "..\temp\tempfile", replace

u "..\temp\robots_country_all", replace
	
	merge 1:1 country year using "..\temp\tempfile"
		keep if _mer==3 
		drop _mer
	
sa "..\temp\robots_country_all", replace

		// rename and order variables
	local varlist "VA VA_QI CAP CAP_QI CAPITSHR H_EMP H_HS H_MS H_LS"
	local varlist "`varlist' LAB LAB_local LAB_QI LAB_HS LAB_MS LAB_LS"
	
	local newvarlist ""
	
	foreach var in `varlist' {
	
		ren `var' c_all_`var'
		local newvarlist "`newvarlist' c_all_`var'"
	}
	
merge 1:1 country year using "..\temp\robots_country_robot-using"
	drop _mer
merge 1:1 country year using "..\temp\robots_country_robot-using-sample"
	drop _mer
	
		// robot density, rank		
	gen c_robot_using_rob = c_robot_using_stock_pim_10/c_robot_using_H_EMP
	so year c_robot_using_rob
	by year: gen c_robot_using_rob_pctile = _n/_N
	
	order country year `newvarlist' price_robots* c_robot_using_* c_robot_using_smpl_* 
	
sa "..\temp\robots_country", replace

erase "..\temp\robots_country_robot-using.dta"
erase "..\temp\robots_country_robot-using-sample.dta"
erase "..\temp\robots_country_all.dta"	
cap erase "..\temp\tempfile.dta" 
