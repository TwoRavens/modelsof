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

	project, uses("tableA1_revpar.ster")
	project, uses("tableA1_roomprice.ster")
	project, uses("tableA1_occrate.ster")
	

* Overall -outreg- options

	local myopts starlevels(10 5 1) starloc(1) se bdec(3) varlabels squarebrack ///
		summstat(N \ N_clust) ///
		summtitle("Observations" \ "Number of hotels") merge
		

* Load saved estimates and build table. For Brand fixed effects, see regression output

	project, uses("tableA1_revpar_saveres.dta")
	use "tableA1_revpar_saveres.dta"
	
	local aR2 : dis %5.2f saveres2
	
	local F : dis %5.2f saveres4
	local df1 = saveres5
	local df2 = saveres6
	local prob = Ftail(`df1',`df2',`F')
	if `prob' < .01 local star ***
	if inrange(`prob',.01,.05) local star **
	if inrange(`prob',.05,.1) local star *
	dis "F(`df1',`df2') = `F'   prob = `prob'"
	dis "`F'`star'"
	
	estimates use "tableA1_revpar.ster"
	
	qui outreg , `myopts' ctitles("", "RevPar") ///
		addrows("Brand fixed effects", "yes***" \ ///  see testparm i.brand_id results
		"F-statistics on significance of IV", "`F'`star'" \ ///
		"Adjusted R2", "`aR2'")  
		

	project, uses("tableA1_roomprice_saveres.dta")
	use "tableA1_roomprice_saveres.dta"
	
	local aR2 : dis %5.2f saveres2
	
	local F : dis %5.2f saveres4
	local df1 = saveres5
	local df2 = saveres6
	local prob = Ftail(`df1',`df2',`F')
	if `prob' < .01 local star ***
	if inrange(`prob',.01,.05) local star **
	if inrange(`prob',.05,.1) local star *
	dis "F(`df1',`df2') = `F'   prob = `prob'"
	dis "`F'`star'"
		
	estimates use "tableA1_roomprice.ster"
	qui outreg , `myopts' ctitles("", "RoomPrice") ///
		addrows("Brand fixed effects", "yes***" \ ///  see testparm i.brand_id results
		"F-statistics on significance of IV", "`F'`star'" \ ///
		"Adjusted R2", "`aR2'")  
		

	project, uses("tableA1_occrate_saveres.dta")
	use "tableA1_occrate_saveres.dta"
	
	local aR2 : dis %5.2f saveres2
	
	local F : dis %5.2f saveres4
	local df1 = saveres5
	local df2 = saveres6
	local prob = Ftail(`df1',`df2',`F')
	if `prob' < .01 local star ***
	if inrange(`prob',.01,.05) local star **
	if inrange(`prob',.05,.1) local star *
	dis "F(`df1',`df2') = `F'   prob = `prob'"
	dis "`F'`star'"
		
	estimates use "tableA1_occrate.ster"
	qui outreg , `myopts' ctitles("", "OccRate") ///
		addrows("Brand fixed effects", "yes***" \ ///  see testparm i.brand_id results
		"F-statistics on significance of IV", "`F'`star'" \ ///
		"Adjusted R2", "`aR2'")  


* Save the combined version
	
	outreg using "`dofile'.doc", replace replay ///
		title("Table A1: First-Stage Results for Franchise Dummy (in Table 5), Unbalanced Sample") 

	project, creates("`dofile'.doc")
