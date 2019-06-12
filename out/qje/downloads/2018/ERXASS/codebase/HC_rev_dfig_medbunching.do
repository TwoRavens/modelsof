/*-------------------------------------------------------------HC_rev_dfig_medbunching.do

Stuart Craig
Last updated	20180816
*/


timestamp, output
cap mkdir dfig_medanchor
cd dfig_medanchor

use if c_type==1 using ${ddHC}/HC_cdata_ip_medid, clear
keep if c_type==1

cap drop negepcount
cap drop hindex
bys prov_e_npi: gen negepcount = -_N
egen hindex = group(negepcount prov_e_npi)

keep if hindex<11 // keeps the preserve small
forval i=1/2 {
	preserve
		qui keep if hindex==`i'
		qui count
		
		qui gen count=1
		collapse (sum) count, by(prov_e_npi ep_drg price ep_medprice c_type) fast
		
		gen logprice = log(price)
		gen logmed   = log(ep_medprice)
		gen l45 = logmed
	// Create the figure	
		tw 	scatter logprice logmed, ms(Oh) mc("${blu}") || ///
			lfit l45 logmed, lw(medthick) lc(black) /// 
			xtitle("Log(Medicare)") ytitle("Log(Price)") ///
			legend(order(2 "45 degree") pos(5) ring(0) row(1)) ///
			ylab(7(1)11) xlab(8(1)10) 
		graph export HC_rev_dfig_medanchor_now_`i'.png, replace
	// B/W version	
		tw 	scatter logprice logmed, ms(Oh) mc(gs6) || ///
			lfit l45 logmed, lw(medthick) lc(black) /// 
			xtitle("Log(Medicare)") ytitle("Log(Price)") ///
			legend(order(2 "45 degree") pos(5) ring(0) row(1)) ///
			ylab(7(1)11) xlab(8(1)10) 
		graph export HC_pub_dfig_medanchor_now_`i'.tif, replace width(5000)
		
	restore
}

exit

