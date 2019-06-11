/*--------------------------------------------------------------------HC_rev_dfig_mergercount.do

Stuart Craig
Last updated	20180816
*/

timestamp, output

/*
------------------------------------------------

Number of transactions by year (figure)

------------------------------------------------
*/


	// This is essentially a cleaned up version of the raw data
	use ${ddHC}/HC_ext_aha_mergers_raw.dta, clear
	
	// Count up the transactions by year
	keep if trans_id<.
	bys trans_id: gen N_t=_n==1
	tab year
	collapse (sum) N_t, by(year) fast
	drop if year>2011
	tw 	bar N year, fi(50) ylab(0(20)100) barw(0.7) ///
		|| scatter N year, msymbol(none) mlab(N) mlabpos(12) mlabc(black) mlabsize(medsmall) ///
		legend(off) ytitle("Number of Mergers") xtitle(Year) xlab(2001/2011,angle(90)) 
	graph export HC_rev_dfig_mergercount.png, replace

exit
