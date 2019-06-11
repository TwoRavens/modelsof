/*-----------------------------------------------------HC_rev_crosssec_price.do

Stuart Craig
Last updated	20180816
*/


timestamp, output
cap mkdir crosssec
cd crosssec
cap mkdir price
cd price

loc pl "${proclist} composite"
foreach proc in `pl' {
	use ${ddHC}/HC_hdata_`proc'.dta, clear
	keep if adj_price<.&merge_year>2007

	loc lhs adj_price 
	cap drop logprice
	gen logprice = log(1+`lhs')

	cap drop procfe
	if "`proc'"=="composite" qui egen procfe = group(proc)
	else gen procfe = 1

	// Main price regression
	eststo clear
	makex, log
	drop x_inssh
	eststo: reghdfe logprice x_*, absorb(merge_year procfe) vce(cluster prov_hrrnum) keepsin
	makex, log
	eststo: reghdfe logprice x_*, absorb(merge_year procfe) vce(cluster prov_hrrnum) keepsin
	eststo: reghdfe logprice x_*, absorb(prov_hrrnum merge_year procfe) vce(cluster prov_hrrnum) keepsin
	qui summ logprice, mean
	estadd local meanLHS=r(mean)
	unique prov_e_npi
	estadd local N_h=r(sum)
	esttab * using HC_rev_crosssec_price_`proc'_`lhs'.csv, ///
		replace  star(* .1 ** .05 *** .01)  ///
		b(%4.3f) se(%4.3f) scalar(r2 meanLHS N_h) obslast lab

	
}

exit


