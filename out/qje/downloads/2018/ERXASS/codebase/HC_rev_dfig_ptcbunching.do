/*-------------------------------------------------------------HC_rev_dfig_ptcbunching.do

Stuart Craig
Last updated	21080816
*/


	timestamp, output
	cap mkdir dfig_ptcbunching
	cd dfig_ptcbunching

	// Find the biggest PTC hospitals
	use ${ddHC}/HC_cdata_ip_medid, clear
	keep if c_type==2
	cap drop negepcount
	cap drop hindex
	bys prov_e_npi: gen negepcount = -_N
	egen hindex = group(negepcount prov_e_npi)

	// Are all DRGs paid at the same PTC ratio? 
	forval h=1/1 {
		preserve
			keep if hindex==`h'
			keep if c_type==2
			qui gen count=1
			collapse (sum) count, by(prov_e_npi ep_drg price charge c_type) fast

			gen ptc = price/charge
			gen logprice = log(price)
			gen logcharge = log(charge)

			tw 	scatter logprice logcharge if c_type==2, ms(Oh) mc("${blu}")  || ///
				lfit logcharge logcharge, lw(medthick) lc("${red}") ///
					xtitle("ln(Charge)") ytitle("ln(Price)") ///
					legend(order(2 "45 Degree Line") ring(0) pos(11) row(1))
			graph export HC_rev_ptcbunching_`h'.png, replace
		restore
	}	
		
		
exit	
	


