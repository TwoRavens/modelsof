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

	project, uses("tableA2_revpar_ols1.ster")
	project, uses("tableA2_revpar_ols2.ster")
	project, uses("tableA2_revpar_xtreg.ster")
	
	project, uses("tableA2_roomprice_ols1.ster")
	project, uses("tableA2_roomprice_ols2.ster")
	project, uses("tableA2_roomprice_xtreg.ster")
	
	project, uses("tableA2_occrate_ols1.ster")
	project, uses("tableA2_occrate_ols2.ster")
	project, uses("tableA2_occrate_xtreg.ster")
	

* Overall -outreg- options

	local myopts starlevels(10 5 1) starloc(1) se bdec(3) varlabels squarebrack ///
		summstat(N \ N_clust) ///
		summtitle("Observations" \ "Number of Hotels") merge
		

* Load saved estimates and build table. For Brand fixed effects, see regression output

	estimates use "tableA2_revpar_ols1.ster"
	local r2 : display %5.2f `e(r2)'	
	qui outreg , `myopts'   ctitles("", "RevPar" \ "", " " \ "", "OLS") ///
		addrows("R2", "`r2'" \ "Brand fixed effects", "Yes***")  
	
	estimates use "tableA2_revpar_ols2.ster"
	local r2 : display %5.2f `e(r2)'
	qui outreg , `myopts' ctitles("", "RevPar" \ "", "Hetero" \ "", "OLS") ///
		addrows("R2", "`r2'" \ "Brand fixed effects", "Yes***")

	estimates use "tableA2_revpar_xtreg.ster"
	local r2 : display %5.2f `e(r2_o)'	// overall
	qui outreg , `myopts' ctitles("", "RevPar" \ "", "Hetero" \ "", "RE") ///
		addrows("R2", "`r2'" \ "Brand fixed effects", "Yes***")


	estimates use "tableA2_roomprice_ols1.ster"
	local r2 : display %5.2f `e(r2)'
	qui outreg , `myopts' ctitles("", "RoomPrice" \ "", " " \ "", "OLS") ///
		addrows("R2", "`r2'" \ "Brand fixed effects", "Yes***")

	estimates use "tableA2_roomprice_ols2.ster"
	local r2 : display %5.2f `e(r2)'
	qui outreg , `myopts' ctitles("", "RoomPrice" \ "", "Hetero" \ "", "OLS") ///
		addrows("R2", "`r2'" \ "Brand fixed effects", "Yes***")

	estimates use "tableA2_roomprice_xtreg.ster"
	local r2 : display %5.2f `e(r2_o)'	// overall
	qui outreg , `myopts' ctitles("", "RoomPrice" \ "", "Hetero" \ "", "RE") ///
		addrows("R2", "`r2'" \ "Brand fixed effects", "Yes***")


	estimates use "tableA2_occrate_ols1.ster"
	local r2 : display %5.2f `e(r2)'
	qui outreg , `myopts' ctitles("", "OccRate" \ "", " " \ "", "OLS") ///
		addrows("R2", "`r2'" \ "Brand fixed effects", "Yes***")

	estimates use "tableA2_occrate_ols2.ster"
	local r2 : display %5.2f `e(r2)'
	qui outreg , `myopts' ctitles("", "OccRate" \ "", "Hetero" \ "", "OLS") ///
		addrows("R2", "`r2'" \ "Brand fixed effects", "Yes***")

	estimates use "tableA2_occrate_xtreg.ster"
	local r2 : display %5.2f `e(r2_o)'	// overall
	qui outreg , `myopts' ctitles("", "OccRate" \ "", "Hetero" \ "", "RE") ///
		addrows("R2", "`r2'" \ "Brand fixed effects", "Yes***")
		

* Save the combined version
	
	outreg using "`dofile'.doc", replace replay ///
		title(Table A2: Balanced Sample: Franchise Status Treated as Exogenous) 

	project, creates("`dofile'.doc")
