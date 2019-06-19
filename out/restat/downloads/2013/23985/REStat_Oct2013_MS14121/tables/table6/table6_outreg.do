/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/


	version 12

	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name
	local sig {bind:{hi:[RP : `dofile'.do]}}		// a signature in notes
	
	
* Link the estimates from all regressions

	project, uses("table6_revpar_reg1.ster")
	project, uses("table6_revpar_reg2.ster")
	project, uses("table6_roomprice_reg1.ster")
	project, uses("table6_roomprice_reg2.ster")
	project, uses("table6_occrate_reg1.ster")
	project, uses("table6_occrate_reg2.ster")
	

* Overall -outreg- options

	local myopts starlevels(10 5 1) starloc(1) se bdec(3) varlabels squarebrack ///
		summstat(N \ N_clust) ///
		summtitle("Observations" \ "Number of hotels (clusters)")  merge
		

* Load saved estimates and build table. For Brand fixed effects, see regression output

	estimates use "table6_revpar_reg1.ster"
	qui outreg , `myopts' ctitles("", "RevPar") ///
		addrows("Brand fixed effects", "Yes***")  
	
	estimates use "table6_revpar_reg2.ster"
	qui outreg , `myopts' ctitles("", "RevPar") ///
		addrows("Brand fixed effects", "Yes***")
	
	
	estimates use "table6_roomprice_reg1.ster"
	qui outreg , `myopts' ctitles("", "RoomPrice") ///
		addrows("Brand fixed effects", "Yes***")
	
	estimates use "table6_roomprice_reg2.ster"
	qui outreg , `myopts' ctitles("", "RoomPrice") ///
		addrows("Brand fixed effects", "Yes***")
	
	
	estimates use "table6_occrate_reg1.ster"
	qui outreg , `myopts' ctitles("", "OccRate") ///
		addrows("Brand fixed effects", "Yes***")
	
	estimates use "table6_occrate_reg2.ster"
	qui outreg , `myopts' ctitles("", "OccRate") ///
		addrows("Brand fixed effects", "Yes***")
	


* Save the combined version
	
	outreg using "`dofile'.doc", replace replay ///
		title(Table 6: Testing For Nonlinear Impacts of Organizational Form) 

	project, creates("`dofile'.doc")
