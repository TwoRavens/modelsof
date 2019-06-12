/*----------------------------------------------------HC_rev_crosssec_price_levels.do

Stuart Craig
Last updated	20180816
*/

	timestamp, output
	cap mkdir crosssec
	cd crosssec
	cap mkdir price
	cd price

	loc proc ip
	use ${ddHC}/HC_hdata_`proc'.dta, clear
	keep if adj_price<.&merge_year>2007

	if "`proc'"=="ip" merge 1:1 merge_npi merge_year ///
		using ${ddHC}/HC_hdata_`proc'_phyindex.dta, keep(3) nogen
	assert adj_plusphy>0

	foreach lhs of varlist adj_price {
		// Main price regressions
		eststo clear
		makex, log
		drop x_inssh
		eststo: reghdfe `lhs' x_*, absorb(merge_year) vce(cluster prov_hrrnum)
		makex, log
		eststo: reghdfe `lhs' x_*, absorb(merge_year) vce(cluster prov_hrrnum)
		eststo: reghdfe `lhs' x_*, absorb(prov_hrrnum merge_year) vce(cluster prov_hrrnum)
		esttab * using HC_rev_crosssec_price_levels_`proc'.csv, ///
			replace  star(* .1 ** .05 *** .01)  ///
			b(%4.3f) se(%4.3f) scalar(r2) obslast lab

	}	

exit

