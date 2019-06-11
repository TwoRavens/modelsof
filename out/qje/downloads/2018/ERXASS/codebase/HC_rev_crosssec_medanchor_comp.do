/*-------------------------------------------------HC_rev_crosssec_medanchor_comp.do

Stuart Craig
Last updated	20180816
*/

timestamp, output
cap mkdir crosssec
cd crosssec
cap mkdir comp
cd comp

// Bring in the data and clean
	use ${ddHC}/HC_cdata_ip_medid.dta, clear
	keep if adj_price<.
	keep if c_type==1
	collapse (mean) medanchor, by(prov_e_npi ep_adm_y) fast
	gen merge_npi=prov_e_npi
	gen merge_year = ep_adm_y
	merge 1:1 merge_npi merge_year using ${ddHC}/HC_hdata_ip.dta, keep(3) nogen

// Rescale for 0-100
	summ medanchor, d
	replace medanchor = medanchor*100
	keep if adj_price<. // ensuring consistent samples

// Construct variable radius HHI
	cap drop hhi_var
	qui gen hhi_var = .
	qui replace hhi_var = syshhi_20m if mci_urgeo=="RURAL"	
	qui replace hhi_var = syshhi_15m if mci_urgeo=="OURBAN"
	qui replace hhi_var = syshhi_10m if mci_urgeo=="LURBAN"	
		
	makex, log hccishare
	eststo clear
// For benchmarking
	eststo: reghdfe medanchor x_*			, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum) keepsin
	estadd local Distance "15m"

// All HHI measures
	drop x_mdt*
	foreach v of varlist syshhi_5m syshhi_15m syshhi_30m hhi_var hcount15 {
		cap drop comp_measure
		if strpos("`v'","hhi")>0 qui gen comp_measure =log(1+`v'*10000)
		else qui gen comp_measure=`v'
		eststo: reghdfe medanchor comp_measure x_*, vce(cluster prov_hrrnum) absorb(prov_hrrnum ep_adm_y) keepsin
		estadd local Distance "`v'"
	}	

// Competition quartiles
	cap drop Q4_hhi
	qui egen Q4_hhi = xtile(syshhi_15m), by(ep_adm_y) nq(4)
	forval q=2/4 {
		cap drop hhiq`q'
		qui gen hhiq`q' = Q4_hhi==`q'
	}
	eststo: reghdfe medanchor hhiq? x_*, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum) keepsin
	estadd local Distance "15m"
	eststo: reghdfe medanchor hhiq4 x_*, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum) keepsin
	estadd local Distance "15m"
	esttab * using HC_rev_crosssec_medanchor_comp.csv, replace se r2 obslast ///
		scalar(Distance) star(* 0.10 ** 0.05 *** 0.01) b(%12.3f) se(%12.3f)

		

exit




