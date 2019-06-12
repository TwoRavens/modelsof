* merging World Robotics with EUKLEMS data and task measures

u "..\temp\DOT_tasks_ind", clear
merge 1:1 ind_EUKLEMS using "..\temp\replaceability_ind"
	assert _merge==3
		drop _merge
		
sa "..\output\tasks_ind", replace

u "..\temp\robots_clean", clear
merge 1:m country year code_robots using "..\output\EUKLEMS"
		
	tab _merge
	tab _merge if code_robots!=""
		
	* diagnose unmatched observations 	
	do unmatched_country-year.do
		drop if unmatched_country_year=="country not covered in World Robotics data" | ///
				unmatched_country_year=="country not covered in EUKLEMS data" 
				
	do unmatched_industry.do
		drop if unmatched_industry=="too aggregated in EUKLEMS data" | 	///
				unmatched_industry=="too disaggregated in EUKLEMS data"
		
		// what remains unmatched? 
	assert _merge==3 | 															///
			unmatched_country_year=="year not covered in World Robotics data" | ///
			unmatched_industry=="industry not covered in World Robotics data" | ///
			unmatched_industry=="industry not covered in EUKLEMS data" 		  | ///
			| CAPITSH==. | ( country=="CZE" & year>=1995 ) | ( country=="SVN" & year>=1995 )
		
	drop _mer
				
	* robot prices, deflated
	replace price_robots = price_robots/1000
		la var price_robots "Unit price of Robots (US) in historical US$"
	
	gen price_robots_real = price_robots/VA_P_US*100				
		la var price_robots_real "Unit price of Robots in 2005 US$"
	
	* task measures
	gen ind_EUKLEMS = code_euklems 
	
merge m:1 ind_EUKLEMS using "..\output\tasks_ind"
	assert _merge==3 if code_euklems!=""

	* ordering, labels  
	local varli "country year code_robots ind_robots code_euklems ind_EUKLEMS desc delvrd delvrd_raw"
	local varli "`varli' imp_delvrd stock stock_clean_12 imp_stock_clean"
	local varli "`varli' stock_pim_* price_robots price_robots_real"
	local varli "`varli' VA VA_local VA_QI VA_P_US EMP H_EMP LAB LAB_local LAB_QI CAP CAP_local CAP_QI"
	local varli "`varli' CAPLAB CAPIT* CAPIT_QI CAPNIT CAPNIT_QI TFPva_I hours_replace robots_dot91_phs task_*"
	
	keep `varli'
	order `varli'
		
	do labels_robots
	
	la data "EUKLEMS & World Robotics; nominal values expressed in millions"

sa "..\output\robots_EUKLEMS", replace 
