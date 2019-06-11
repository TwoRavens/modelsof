/*--------------------------------------------------------HC_rev_merger_eventstudy.do

Stuart Craig
Last updated 20180816
*/


	timestamp, output
	cap mkdir merger
	cd merger
	cap mkdir eventstudy
	cd eventstudy

// Create area bar for year of merger
	clear
	input t greyt greyb
	-.5 .2 -.2
	.5 .2 -.2
	end
	tempfile filler
	save `filler'

// Collect the results from HC_rev_merger_main.do
// and graph the coefficients
	foreach d in 5 10 15 20 25 30 50 {
		use ../main/HC_without2007_capneg2_ES, clear
		keep if d==`d'
		keep if flex=="nocontrol"

		list

		rename t temp
		gen t = real(substr(temp,-1,1))
		replace t=-t if strpos(temp,"neg")>0
		qui summ t
		loc xmin=r(min)
		loc xmax=r(max)

		gen ul=b+1.96*se
		gen ll=b-1.96*se
		replace ul = min(ul,.2)
		replace ll = max(ll,-.2)
		append using `filler'

		tw 	rarea greyt greyb t, fc(gs13) lc(gs13) || ///
			rspike ul ll t, lc("${blu}") lw(medthick) || ///
			scatter b t, mlc("${blu}") mfc("${blu}") ms(O) msize(medlarge) ///
			ylab(-.2(.1).2,format(%3.2f) labsize(large)) ///
			yline(0,lc(black) lp(solide) lw(medthick)) ///
			xtitle("Year Relative to Merger", size(large)) legend(off) ///
			ytitle("Log Price Relative to {&tau}-2", size(large)) ///
			xlab(`xmin'(1)`xmax', labsize(large))
		graph export HC_rev_merger_ES_`d'm.png, replace
		
		tw 	rarea greyt greyb t, fc(gs13) lc(gs13) || ///
			rspike ul ll t, lc(gs5) lw(medthick) || ///
			scatter b t, col(gs5) ms(O) msize(medlarge) ///
			ylab(-.2(.1).2,format(%3.2f) labsize(large)) ///
			yline(0,lc(black) lp(solide) lw(medthick)) ///
			xtitle("Year Relative to Merger", size(large)) legend(off) ///
			ytitle("Log Price Relative to {&tau}-2", size(large)) ///
			xlab(`xmin'(1)`xmax', labsize(large))
		graph export HC_pub_merger_ES_`d'm.tif, replace width(5000)
		
	}

exit
