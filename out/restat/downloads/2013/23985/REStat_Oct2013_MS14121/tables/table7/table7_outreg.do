/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/


	version 12

	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name
	local sig {bind:{hi:[RP : `dofile'.do]}}		// a signature in notes
	
	
* The number of hotels (see log files that contain the regressions)

	local nhotels "1,194"
	
	
* Link the estimates from all regressions

	project, uses("table7_revpar.ster")
	project, uses("table7_roomprice.ster")
	project, uses("table7_occrate.ster")
	

* Overall -outreg- options

	local myopts starlevels(10 5 1) starloc(1) se bdec(3) varlabels squarebrack merge
		

* Load saved estimates and build table. For Brand fixed effects, see regression output

	estimates use "table7_revpar.ster"
	
	local psr2_1 : display %5.2f 1 - e(sumadv1) / e(sumrdv1)
	local psr2_2 : display %5.2f 1 - e(sumadv2) / e(sumrdv2)
	local psr2_3 : display %5.2f 1 - e(sumadv3) / e(sumrdv3)
	
	qui outreg , `myopts' eq_merge ctitles("", RevPar, RevPar, RevPar \ "", Q25, Q50, Q75) ///
		summstat(reps, reps, reps \ N, N, N) ///
		summtitle(Reps \ N) ///
		addrows("nhotels", "`nhotels'", "`nhotels'", "`nhotels'" \ ///
			"Pseudo-R2", "`psr2_1'", "`psr2_2'", "`psr2_3'" \ ///
			"Brand fixed effects", "Yes***", "Yes***", "Yes***")	
	
		
	estimates use "table7_roomprice.ster"
	
	local psr2_1 : display %5.2f 1 - e(sumadv1) / e(sumrdv1)
	local psr2_2 : display %5.2f 1 - e(sumadv2) / e(sumrdv2)
	local psr2_3 : display %5.2f 1 - e(sumadv3) / e(sumrdv3)
	
	qui outreg , `myopts' eq_merge ctitles("", RoomPrice, RoomPrice, RoomPrice \ "", Q25, Q50, Q75) ///
		summstat(reps, reps, reps \ N, N, N) ///
		summtitle(Reps \ N) ///
		addrows("nhotels", "`nhotels'", "`nhotels'", "`nhotels'" \ ///
			"Pseudo-R2", "`psr2_1'", "`psr2_2'", "`psr2_3'" \ ///
			"Brand fixed effects", "Yes***", "Yes***", "Yes***")
		
		
	estimates use "table7_occrate.ster"
	
	local psr2_1 : display %5.2f 1 - e(sumadv1) / e(sumrdv1)
	local psr2_2 : display %5.2f 1 - e(sumadv2) / e(sumrdv2)
	local psr2_3 : display %5.2f 1 - e(sumadv3) / e(sumrdv3)
	
	qui outreg , `myopts' eq_merge ctitles("", OccRate, OccRate, OccRate \ "", Q25, Q50, Q75) ///
		summstat(reps, reps, reps \ N, N, N) ///
		summtitle(Reps \ N) ///
		addrows("nhotels", "`nhotels'", "`nhotels'", "`nhotels'" \ ///
			"Pseudo-R2", "`psr2_1'", "`psr2_2'", "`psr2_3'" \ ///
			"Brand fixed effects", "Yes***", "Yes***", "Yes***")	
	


* Save the combined version
	
	outreg using "`dofile'.doc", replace replay ///
		title(Table 7: Quantile Regressions: Franchise Status Treated as Exogenous)

	project, creates("`dofile'.doc")
