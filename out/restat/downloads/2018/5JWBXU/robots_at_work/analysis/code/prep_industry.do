* robots: prepare industry-level dataset

u if $robotsample using "..\input\robots_EUKLEMS", clear
	
	local varlist "stock_pim_10 H_EMP VA VA_QI" 
	
	collapse ( rawsum ) `varlist' , by(ind_rob code_rob code_euklems year)
	
	so code_rob year
	
	foreach var in `varlist' {
	
		ren `var' ind_sample_`var'
	}
		
	order ind_robots code_robots code_euklems year ind_sample_stock_pim_10 		///
		ind_sample_H_EMP ind_sample_VA ind_sample_VA_QI 
	
		// add task variables
	gen ind_EUKLEMS = code_euklems
	
merge m:1 ind_EUKLEMS using "..\input\tasks_ind"
	keep if _mer==3
		drop _mer
	
sa "..\temp\robots_industry", replace
