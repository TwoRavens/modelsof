* generating DOT task variables at industry level (1980 employment structure)

u "..\temp\us_census_1980", clear
		
	drop if ind1990==0 | ind1990>960
	
	* merge DOT variables
		// first merge in occ1990dd variable
	drop occ
	gen occ = occ1990
	
	replace occ = 353 if occ==349
	
merge m:1 occ using "..\input\Autor-Dorn\occ1990_occ1990dd", keepusing(occ1990dd)	
	drop _merge 
	
	replace occ1990dd = 873 if occ1990dd==874
	
	do xwalk_occ1990dd-occ1990ddgg
	tab occ if occ1990ddgg==. // code 905 is unemployed, last worked in military
	
	gen female = sex==2
		
merge m:1 occ1990ddgg female using "..\temp\DOT_tasks"

	keep if _mer!=2
	drop _mer
	
	* impute missing task measures
	local taskvars "robots_dot91_phs"
	
	foreach var in `taskvars' {
			
		forval i = 0/1 {	
			
			sum `var' if female==`i' [w=perwt]
			
			replace `var' = r(mean) if `var'==. & female==`i'
		}
	}
		
		// task measures constructed by David Autor & David Dorn, following ALM
merge m:1 occ1990dd using "..\input\Autor-Dorn\occ1990dd_task_alm"
	tab occ1990 if _merge!=3
		drop _merge 
merge m:1 occ1990dd using "..\input\Autor-Dorn\occ1990dd_task_offshore"
	tab occ1990 if _merge!=3
		drop _merge 
					
* bridge census industries to EUKLEMS industries
merge m:1 ind1990 using "..\input\EUKLEMS\xwalk_EUKLEMS-ind1990"
	drop _mer
		
* sum by EUKLEMS industries (weighted using person weights)
	collapse (mean) robots_dot91_phs task_* [ w=perwt ], by(ind_EUKLEMS)
	
	so ind_EUKLEMS
	
sa "..\temp\DOT_tasks_ind", replace
