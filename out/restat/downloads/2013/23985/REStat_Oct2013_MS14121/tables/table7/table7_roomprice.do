/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/


	version 12

	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name
	local sig {bind:{hi:[RP : `dofile'.do]}}		// a signature in notes
	

* Set the number of repetitions

	local nreps 100
	
	
* Start from the data combo

	project, uses("`pdir'/data_combo.dta")
	use "`pdir'/data_combo.dta"


* Convert the following variables to log

  	foreach v of varlist revpar age nrooms roomprice Lroomprice ///
		occrate Loccrate m_pop m_income {
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

	local indepvars franchised nrooms age h_rentcar h_resto h_ac ///
		h_outcafe h_confrm h_train h_airport h_pool h_fitness ///
		m_pop m_income Loccrate ///
		i.brand_id i.m_tour i.m_hcompdec i.m_resto i.monthdate
		
	local meanvars avnrooms avage av_Im_tour_* avLoccrate 
	
	
* Number of hotels
	
	countby hotel_id	// see ado project directory
	

* Run regressions and save estimates for later

	set seed 1001

	xi: sqreg roomprice `indepvars' `meanvars', q(.25 .5 .75) reps(`nreps')

	estimates save "`dofile'.ster", replace

	// are brand fixed effects significant
	xi: testparm i.brand_id, equation(q25)
	xi: testparm i.brand_id, equation(q50)
	xi: testparm i.brand_id, equation(q75)
	
	project, creates("`dofile'.ster")
