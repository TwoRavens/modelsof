** EUKLEMS Mar 2008 Release: clean labour data

u "..\temp\EUKLEMS_Mar08_labor", clear

* generate additional variables

	local sexes "F M"
	local ages "29 49 50PLUS"
	local skills "HS MS LS"
	
	foreach var in H LAB {
	
		foreach age in `ages' {
			gen `var'_`age' = 0
		} 
		
		foreach skill in `skills' {
			gen `var'_`skill' = 0
		}
		
		foreach sex in `sexes' {
			gen `var'_`sex' = 0
		}
		
		foreach age in `ages' {
			foreach skill in `skills' {
				foreach sex in `sexes' {
				
					replace `var'_`skill' = `var'_`skill' + `var'_`skill'_`age'_`sex'
					replace `var'_`age' = `var'_`age' + `var'_`skill'_`age'_`sex'
					replace `var'_`sex' = `var'_`sex' + `var'_`skill'_`age'_`sex'
					
				}
			}
		}
		
		gen check_`var'_skill = `var'_LS + `var'_MS + `var'_HS
		gen check_`var'_age = `var'_29 + `var'_49 + `var'_50PLUS
		gen check_`var'_sex = `var'_F + `var'_M
	}
	
	sum check_*

* merge with "additional output files" data, which has basic skill vars for missing countries

	drop if country=="DNK" | country=="FRA" | country=="GRC" 	///
							|  country=="IRL" | country=="SWE"
							
	append using "..\temp\EUKLEMS_Mar08_alt.dta"

* cross walk to robots industries		
		
	do xwalk_ind_EUKLEMS_to_robots
	do rename_robots_industries
	
* merge with other EUKLEMS data for hours and wage bill

	merge 1:1 country code_euklems year using "..\output\EUKLEMS.dta"
		keep if _mer==3
	
	local varlist "country code_euklems code_rob ind_rob year"
	local varlist "`varlist' H_HS H_MS H_LS H_F H_M H_29 H_49 H_50PLUS"
	local varlist "`varlist' LAB_HS LAB_MS LAB_LS LAB_F LAB_M LAB_29 LAB_49 LAB_50PLUS"
	local varlist "`varlist' H_EMP LAB_QI"
	
	keep `varlist'
	order `varlist'
	
sa "..\output\EUKLEMS_labor", replace
