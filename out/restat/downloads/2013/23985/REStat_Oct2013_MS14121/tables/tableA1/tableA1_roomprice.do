/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/


	version 12

	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name
	local sig {bind:{hi:[RP : `dofile'.do]}}		// a signature in notes
	
	
* Start from the data combo

	project, uses("`pdir'/data_combo.dta")
	use "`pdir'/data_combo.dta"

		
* Convert the following variables to log

  	foreach v of varlist revpar age nrooms roomprice Loccrate m_pop ///
  		m_income occrate Lroomprice {
 		replace `v' = log(`v')
  	}
  	

* Generate means by hotel, do not include obs that will be omitted
* in the regressions because of missing lag values

	drop if mi(Lroomprice, Loccrate)

	xi i.m_tour
	foreach v of varlist nrooms age _Im_tour_* Loccrate {
		by hotel_id: egen av`v' = mean(`v')
	}
	

* Define independent variables		

	local indepvars nrooms age h_rentcar h_resto h_ac ///
		h_outcafe h_confrm h_train h_airport h_pool h_fitness ///
		m_pop m_income Loccrate ///
		i.brand_id i.m_tour i.m_hcompdec i.m_resto i.monthdate
		
	local meanvars avnrooms avage av_Im_tour_* avLoccrate
	
	
* Run regressions and save estimates for later

	// see ado project directory for -ivregress2-
	ivregress2 2sls roomprice (franchised = propofran) ///
		`indepvars' `meanvars', first vce(cluster hotel_id)        
				
		
		
	// save the First-stage regression summary statistics
	preserve
	estat firststage
	mat saveres = r(singleresults)
	drop _all
	svmat saveres
	list
	save "`dofile'_saveres.dta", replace
	restore
	
	
	// restore the first stage estimates 
	estimates restore first
	
	// are brand fixed effects significant
	testparm i.brand_id
	
	estimates save "`dofile'.ster", replace
	
	project, creates("`dofile'.ster")
	project, creates("`dofile'_saveres.dta")
