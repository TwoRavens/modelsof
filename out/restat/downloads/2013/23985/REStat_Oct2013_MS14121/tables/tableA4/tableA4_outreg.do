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

	project, uses("tableA4_revpar.ster")
	project, uses("tableA4_roomprice.ster")
	project, uses("tableA4_occrate.ster")
	

* Overall -outreg- options

	local myopts starlevels(10 5 1) starloc(1) se bdec(3) varlabels squarebrack ///
		summstat(N \ N_clust) ///
		summtitle("Observations" \ "Number of hotels") merge
		

* Load saved estimates and build table. For Brand fixed effects, see regression output

	estimates use "tableA4_revpar.ster"
	qui outreg , `myopts' ctitles("", "RevPar") ///
		addrows("Brand fixed effects", "Yes***") 
	
	estimates use "tableA4_roomprice.ster"
	qui outreg , `myopts' ctitles("", "RoomPrice") ///
		addrows("Brand fixed effects", "Yes***")

	estimates use "tableA4_occrate.ster"
	qui outreg , `myopts' ctitles("", "OccRate") ///
		addrows("Brand fixed effects", "Yes***")


* Save the combined version
	
	outreg using "`dofile'.doc", replace replay ///
		title("Table A4: IV Estimations with Alternative Instruments for Franchise Status: Hotel Density + Distance to Franchisor's Headquarters") 

	project, creates("`dofile'.doc")
