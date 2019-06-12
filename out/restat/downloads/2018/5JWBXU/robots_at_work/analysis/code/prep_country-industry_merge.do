* robots: prep country-industry-level data

u if $robotcountries & $robotindustries using "..\input\robots_EUKLEMS", clear
	
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
		// use info on wage bills and TFP from 2006 if missing in 2007 
	foreach var in LAB LAB_QI TFPva_I { // BEL
		by country code_eukl: replace `var' = `var'[_n-1] if `var'==. & `var'[_n-1]!=. & year==2007
	}
	
		// use info on wage bills and TFP from 1995 if missing in 1993
	foreach var in LAB LAB_QI TFPva_I { // HUN
		by country code_euklem: replace `var' = `var'[_n+2] if `var'==. & `var'[_n+2]!=. & year==1993
	}
	
	keep if $robotyears 
		
sa "..\temp\robots_country-industry_merged", replace
		
		// skills data
u "..\input\EUKLEMS_labor", clear
		
	keep country code_euklems year H_HS H_MS H_LS LAB_HS LAB_MS LAB_LS
	
		// use info from 1995 if missing in 1993 (HUN)
	so country code year
	foreach var in H_HS H_MS H_LS LAB_HS LAB_MS LAB_LS {
		by country code_euklems: replace `var' = `var'[_n+2] if `var'==. & `var'[_n+2]!=. & year==1993
	}
		
	drop if LAB_HS==.
	
	keep if year==1993 | year==2005
	replace year = 2007 if year==2005
	
	foreach skill in HS MS LS {
		ren H_`skill' H_SH_`skill'
		ren LAB_`skill' LAB_SH_`skill'
	}
	
merge 1:1 country code_euklems year using "..\temp\robots_country-industry_merged"
	keep if _mer==3
		drop _mer
		
sa "..\temp\robots_country-industry_merged", replace
		
		// country-level data
merge m:1 country year using "..\temp\robots_country"
	drop _mer
	
		// industry-level data 
merge m:1 code_euklems year using "..\temp\robots_industry"
	drop _mer
	
		// prior outcomes 
merge m:1 code_euklems country using "..\temp\EUKLEMS_pre"
	drop if _mer==2
		drop _mer

* labelling and clean-up
	
	foreach var in VA VA_QI CAP_QI CAPITSHR H_EMP H_HS H_MS H_LS LAB LAB_local LAB_QI LAB_HS LAB_MS LAB_LS {
		la var c_all_`var' "country total: all industries"
	}
	foreach var in stock_pim_10 H_EMP LAB LAB_local LAB_QI VA VA_QI CAP_QI {
		la var c_robot_using_`var' "country total: robot-using industries"
	}
	foreach var in stock_pim_10 H_EMP LAB LAB_local LAB_QI VA VA_QI CAP_QI {
		la var c_robot_using_smpl_`var' "country total: robot-using industries included in analysis sample"
	}
	foreach var in stock_pim_10 H_EMP VA VA_QI {
		la var ind_sample_`var' "industry total: countries included in analysis sample"
	}	
		
	local varlist "country code_robots ind_robots code_euklems desc"
	local varlist "`varlist' hours_replace robots_dot91_phs task_* year"	
	local varlist "`varlist' VA VA_local VA_QI VA_P_US EMP H_EMP LAB LAB_local LAB_QI pre_*"
	local varlist "`varlist' stock_pim_10 stock_pim_5 stock_pim_15 price_robots price_robots_real"	
	local varlist "`varlist' CAP CAP_local CAP_QI CAPLAB CAPIT CAPIT_QI CAPIT_QPH CAPITSHR CAPNIT CAPNIT_QI TFPva_I"
	local varlist "`varlist' H_SH_HS H_SH_MS H_SH_LS LAB_SH_HS LAB_SH_MS LAB_SH_LS"
	local varlist "`varlist' c_all* c_robot_using_smpl* c_robot_using_rob* ind_sample*"
	
	keep `varlist'
	order `varlist' 
	
	la data ""
	
	compress
	
sa "..\temp\robots_country-industry_merged", replace
