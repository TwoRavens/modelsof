/* -----------------------------------------------------HC_rev_crosssec_price_altsample.do

Stuart Craig
Last updated 	20180816
*/


	timestamp, output
	cap mkdir crosssec
	cd crosssec
	cap mkdir altsample
	cd altsample

	
	loc proc ip
	loc lhs price
	use ${ddHC}/HC_hdata_`proc'.dta, clear

	makex, log
	foreach v of varlist x_* {
		drop if `v'==.
	}
	drop if merge_year==2007
	keep if adj_price<.
	
	// We only use risk adjusted prices
	cap drop logprice
	qui gen logprice = log(1+adj_price)
	eststo clear

	// No monopolies
	preserve
		drop if x_mdt_1==1
		unique prov_e_npi
		gen no_monop=logprice
		eststo: reghdfe no_monop x_* 				, absorb(ep_adm_y prov_hrrnum) vce(cluster prov_hrrnum) keepsin
		estadd local Year_FE "Yes"
		estadd local HRR_FE "Yes"
		estadd local Hosp_FE "No"
		
	restore

	// Only fairly concentrated markets
	preserve
		drop if hcount15>6
		unique prov_e_npi
		gen no6plus=logprice
		eststo: reghdfe no6plus x_* 				, absorb(ep_adm_y prov_hrrnum) vce(cluster prov_hrrnum) keepsin
		estadd local Year_FE "Yes"
		estadd local HRR_FE "Yes"
		estadd local Hosp_FE "No"
	restore

	esttab * using HC_rev_crosssec_price_altsample.csv, replace   se r2 obslast ///
		scalar(Year_FE HRR_FE Hosp_FE) star(* 0.10 ** 0.05 *** 0.01) b(%12.3f) se(%12.3f)	

exit
