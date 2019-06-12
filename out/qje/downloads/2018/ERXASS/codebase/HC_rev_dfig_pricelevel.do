/*----------------------------------------------------------------HC_rev_dfig_pricelevel.do
Creates all price summary graph

Stuart Craig
Last updated 20180816
*/

	timestamp, output

// Calculate average prices/charges/Medicare rates	
	tempfile temptable
	loc ctr = 0
	foreach proc of global proclist {
		loc ctr = `ctr'+1
		
		use ${ddHC}/HC_hdata_`proc'.dta, clear
		
		// Prepare the price variables
		rename medprice medicare
		if "`proc'"=="ip" replace medicare = prov_pps
		cap drop paid
		qui gen paid = adj_price - medicare
		cap drop charge
		qui gen charge = adj_charge - adj_price // these are the marginal contributions of each
		
		keep if ep_adm_y==2011
		collapse (mean) paid medicare charge adj_price adj_charge [aw=prov_vol], fast by(prov_e_npi) // not necessary anymore
		collapse (mean) paid medicare charge adj_price adj_charge, fast
		
		gen cohort = "`proc'"
		
		foreach v of varlist medicare paid charge adj_price adj_charge {
			qui replace `v' = round(`v')
		}
		
		if `ctr'>1 append using `temptable'
		save `temptable', replace
	}
	cap drop *pct
	
// Format numbers with commas
	foreach v of varlist adj_charge adj_price medicare {
		loc vn = subinstr("`v'","adj_","",.)
		qui gen str_`vn' = string(`v',"%12.0fc")
	}
		
// Build the bar labels
	qui gen chrg_amt = "$" + str_charge
	qui gen chrg_pct = "(" + string(round(100*(adj_charge/adj_price))) + "%)"
	qui gen paid_amt = "$" + str_price
	qui gen paid_pct = "(100%)"
	qui gen medc_amt = "$" + str_med 
	qui gen medc_pct = "(" + string(round(100*(medicare/adj_price))) + "%)"
	drop str*
	
	cap drop order
	qui gen order = .
	loc ctr = 0
	foreach proc of global proclist {
		loc ctr = `ctr'+1
		
		loc pn ""
		if "`proc'"=="ip" loc pn "Inpatient "
		if "`proc'"=="hip" loc pn "Hip Replacement "
		if "`proc'"=="knr" loc pn "Knee Replacement "
		if "`proc'"=="delc" loc pn "Cesarean Delivery "
		if "`proc'"=="delv" loc pn "Vaginal Delivery "
		if "`proc'"=="lap" loc pn "Lap. Chole. "
		if "`proc'"=="app" loc pn "Appendectomy "
		if "`proc'"=="cabg" loc pn "CABG "
		if "`proc'"=="ptca" loc pn "PTCA "
		if "`proc'"=="col" loc pn "Colonoscopy "
		if "`proc'"=="kmri" loc pn "Lower Limb MRI "

		qui replace order = `ctr' if cohort=="`proc'"
		label define order `ctr' "`pn'", modify
	}
	label val order order
	
	qui gen labpos_charge 	= adj_charge
	qui gen labpos_price	= adj_price
	qui gen labpos_medicare	= medicare
	loc top=33000
	qui replace labpos_charge = `top' if inlist(cohort,"kmri","col","delc","delv")
	qui replace labpos_price  = `top'-6000 if inlist(cohort,"kmri","col","delc","delv")
	qui replace labpos_medicare   = `top'-12000 if inlist(cohort,"kmri","col","delc","delv")
	
	foreach v of varlist labpos_* {
		qui replace `v' = `v' + 2600
		qui gen `v'_2 = `v' - 2600
	}
	
// Online version (full color)
	format medicare %12.0fc
	tw 	bar medicare order, color("$blu")	barw(.9) fintensity(50) ///
	 || rbar adj_price medicare order, color("178 90 99") barw(.9)  ///
	 || rbar adj_charge adj_price order, lpattern(solid) color(gs14) barw(.9) lstyle(solid) lw(vvvthin) xlabel(1/`=_N', noticks valuelabel angle(45) labsize(small)) ///
		xtitle("") ytitle("") legend(order( 3 "Charge" 2 "Negotiated Price" 1 "Medicare"  ) rows(1) ring(0) pos(11) size(small)) ylab(,labsize(medsmall)) ///
	 || scatter labpos_charge order, ms(none) mla(chrg_amt) mlabpos(12) mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_price order, ms(none) mla(paid_amt) mlabpos(12) mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_medicare   order, ms(none) mla(medc_amt) mlabpos(12)  mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_charge_2 order, ms(none) mla(chrg_pct) mlabpos(12) mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_price_2 order, ms(none) mla(paid_pct) mlabpos(12) mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_medicare_2   order, ms(none) mla(medc_pct) mlabpos(12)  mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 aspect(.6) 
	graph export HC_rev_dfig_pricelevel.png, as(png) replace
	outsheet using ${oHC}/HC_rev_dfig_pricelevel.csv, comma replace

// Greyscale version for publication
	tw 	bar medicare order, color(gs9)	lpattern(solid) lstyle(solid) lw(vvvthin) barw(.9) fintensity(50) ///
	 || rbar adj_price medicare order, lpattern(solid) lstyle(solid) lw(vvvthin) color(gs7) barw(.9)  ///
	 || rbar adj_charge adj_price order, lpattern(solid) color(gs15) barw(.9) lstyle(solid) lw(vvvthin) xlabel(1/`=_N', noticks valuelabel angle(45) labsize(small)) ///
		xtitle("") ytitle("") legend(order( 3 "Charge" 2 "Negotiated Price" 1 "Medicare"  ) rows(1) ring(0) pos(11) size(small)) ylab(,labsize(medsmall)) ///
	 || scatter labpos_charge order, ms(none) mla(chrg_amt) mlabpos(12) mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_price order, ms(none) mla(paid_amt) mlabpos(12) mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_medicare   order, ms(none) mla(medc_amt) mlabpos(12)  mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_charge_2 order, ms(none) mla(chrg_pct) mlabpos(12) mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_price_2 order, ms(none) mla(paid_pct) mlabpos(12) mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 || scatter labpos_medicare_2   order, ms(none) mla(medc_pct) mlabpos(12)  mlabgap(0) mlabcolor(black) mlabsize(small) ///
	 aspect(.6) 
	graph export HC_pub_dfig_pricelevel.png, as(png) replace
	graph export HC_pub_dfig_pricelevel.tif, as(tif) replace width(5000)
	outsheet using ${oHC}/HC_rev_dfig_pricelevel.csv, comma replace



exit
