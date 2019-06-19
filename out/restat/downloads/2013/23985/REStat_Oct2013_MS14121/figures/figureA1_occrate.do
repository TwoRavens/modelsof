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


* Find the standard deviation of roomprice per hotel

	collapse (sd) stdev = occrate, by(hotel_id)
	
	
* The mean across hotels

	sum stdev
	local sdmean = r(mean)
	
	
* Determine the 5% quantile category for each hotel

	xtile fivepc = stdev, nq(20)
	
	
* Reduce to the mean per quantile

	collapse (mean) stdev, by(fivepc)
	
	
* The label value of each quantile

	gen x5pc = fivepc * 5
	
	
* Draw the figure

	twoway bar stdev x5pc, ///
		ylabel(0 1 3 5 7 9 12.17 15 17 20 25) ///
		xlabel(5(5)100) ///
		xtitle("") ytitle("") ///
		barwidth(2.5) ///
		yline(`sdmean') ///
		plotregion(margin(b = 0)) ///
		title(Hotel-level Std.Deviations in Occupancy during Jan.'01-Oct.'03.) ///
		scale(.8)

	graph export "`dofile'.png", replace width(1600)
	project, creates("`dofile'.png")
