/*-----------------------------------------------------HC_rev_crosssec_price_quality.do

Stuart Craig
Last updated	20180816
*/


timestamp, output
cap mkdir crosssec
cd crosssec
cap mkdir quality
cd quality


foreach proc in ip {
	use ${ddHC}/HC_hdata_`proc'.dta, clear
	keep if adj_price<.&merge_year>2007

	foreach lhs of varlist adj_price price {
	cap drop logprice
	gen logprice = log(1+`lhs')

	// Bring in quality measures and adjust them to go the same direction
	merge m:1 merge_npi merge_year using ${ddHC}/HC_ext_mhc.dta
	qui replace mhc_amim01 = (1 - mhc_amim01/100)
	// Standardize to be mean=0, sd=1
	foreach v of varlist mhc* {
		qui summ `v', mean
		qui replace `v' = r(mean) if `v'==.
		qui summ `v'
		qui replace `v' = (`v' - r(mean))/r(sd)
	}
	drop if _m==2
	drop _merge
	
	makex, log
	eststo clear
	// Baseline
	eststo: reghdfe logprice x_*, absorb(prov_hrrnum merge_year) vce(cluster prov_hrrnum)
	// Each score individually
	foreach v of varlist mhc_amim01 mhc_amim10 mhc_surgm08 mhc_surgm38 {
		eststo: reghdfe logprice `v' x_*, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum)
	}
	// All 4 focal measures
	eststo: reghdfe logprice mhc_amim01 mhc_amim10 mhc_surgm08 mhc_surgm38 x_*, ///
		absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum)
	// ALL measures
	eststo: reghdfe logprice mhc* x_*, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum)
	
	esttab * using HC_rev_crosssec_price_quality_`proc'_`lhs'.csv, ///
		replace  star(* .1 ** .05 *** .01)  ///
		b(%4.3f) se(%4.3f) scalar(r2) obslast lab ///
		keep(x_* mhc_amim01 mhc_amim10 mhc_surgm08 mhc_surgm38)
		

	}	
}


exit

