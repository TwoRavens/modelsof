* computing DOT task measures for census 1990 (David Dorn) occupations
	
	local occvar "`1'"
	
u "..\temp\DOT_1971", clear
merge m:1 occ_dot_3dig using "..\temp\dot_1991_phys_occ3"
	
	local var "robots_dot91_phs"
	
	gen `var' = ( phys_reachng + phys_handlng ) 					///
		/( phys_climbng + phys_balncng + phys_stoppng + phys_kneelng 		///
		 + phys_crouchg + phys_crawlng + phys_fingrng + phys_feeling 		///
		 + phys_talking + phys_hearing + phys_tstngsmllng + phys_acuityn 	///
		 + phys_acuityf + phys_dpthprc + phys_accmdtn + phys_colrvsn 		///
		 + phys_fldvisn ) if _merge==3
	
	replace `var' = 0 if `var'==. & _merge==3
		
	qui sum `var'
	replace `var' = ( `var' - r(min) )/( r(max) - r(min) )
	sum `var'
		
	collapse `var' (rawsum) wt [ w=wt ], by(`occvar' female)
	
	so `occvar' female
	by `occvar': gen n = _N
	
	expand 2 if n==1, gen(imputed)
		replace female = 1-female if imputed==1 
	
	so `occvar' female
	
	drop n
		
	la var wt "cell size"
	
	order `occvar' female imputed wt `var'
	
sa "..\temp\DOT_tasks", replace
