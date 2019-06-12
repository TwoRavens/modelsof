/*--------------------------------------------------------HC_rev_dfig_chargecompare.do

Stuart Craig
Last updated 	20180816
*/

timestamp, output

foreach proc of global proclist {

	use ${ddHC}/HC_hdata_`proc'.dta, clear

	// Keep 2011 (no inflation adjustment)
	gen year = ep_adm_y
	keep if year==2011
	
	// Use risk adjusted prices and charges
	collapse (mean) adj_price adj_charge [aw=prov_vol], by(prov_e_npi) fast
	qui reg adj_price adj_charge
	loc r = "0" + substr(string(sqrt(e(r2))),1,4)
	loc b = "0" + substr(string(_b[adj_charge]),1,4)
	
	foreach v of varlist adj_price adj_charge {
		qui replace `v' = round(`v')
		format `v' %12.0fc
	}
	qui replace adj_price = round(adj_price)
	qui replace adj_charge = round(adj_charge)
	compress
	
	tw scatter adj_price adj_charge, msize(medsmall) msymbol(circle) ///
		title("Correlation: `r'", size(medlarge)) ///
		xtitle("Chargemaster Price") ytitle("Negotiated Price") legend(off) 
		 
	graph export HC_rev_dfig_chargecompare_`proc'_2011.png, as(png) replace
	
}

exit
