/*-------------------------------------------------HC_rev_crosssec_contract_comp.do

Stuart Craig
Last updated	20180816
*/

timestamp, output
cap mkdir crosssec
cd crosssec
cap mkdir comp
cd comp


foreach r in norestrict {

eststo clear
foreach proc in ip  {
	if "`proc'"=="composite" {
		tempfile build
		loc ctr=0
		foreach p2 in hip knr delc delv ptca col {
			loc ++ctr
			use ${ddHC}/HC_cdata_`p2'_h.dta, clear
			merge 1:1 prov_e_npi ep_adm_y using ${ddHC}/HC_hdata_`p2'.dta, keep(3 4) update nogen
			gen proc="`p2'"
			if `ctr'>1 append using `build'
			save `build', replace
		}
	}
	else {
		use ${ddHC}/HC_cdata_`proc'_h.dta, clear
		merge 1:1 prov_e_npi ep_adm_y using ${ddHC}/HC_hdata_`proc'.dta, keep(3) nogen
	}
	cap gen proc_fe = 1
	keep if adj_price<.

	cap gen unc_restrict=0
	qui gen share_pcr = ptc_`r'*100
	qui gen share_unc = unc_`r'*100
	
// Competition version
	cap drop hhi_var
	qui gen hhi_var = .
	qui replace hhi_var = syshhi_20m if mci_urgeo=="RURAL"	
	qui replace hhi_var = syshhi_15m if mci_urgeo=="OURBAN"
	qui replace hhi_var = syshhi_10m if mci_urgeo=="LURBAN"	
	
	makex, log hccishare
	eststo clear
	// For benchmarking
	eststo: reghdfe share_pcr x_*			, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum)
	estadd local Distance "15m"

	// All HHI measures
	drop x_mdt*
	foreach v of varlist syshhi_5m syshhi_15m syshhi_30m hhi_var hcount15 {
		cap drop comp_measure
		qui gen comp_measure =log(1+`v'*10000)
		eststo: reghdfe share_pcr comp_measure x_*, vce(cluster prov_hrrnum) absorb(prov_hrrnum ep_adm_y)
		estadd local Distance "`v'"
	}	

	// Competition quartiles
	cap drop Q4_hhi
	qui egen Q4_hhi = xtile(syshhi_15m), by(ep_adm_y) nq(4)
	forval q=2/4 {
		cap drop hhiq`q'
		qui gen hhiq`q' = Q4_hhi==`q'
	}
	eststo: reghdfe share_pcr hhiq? x_*, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum)
	estadd local Distance "15m"
	eststo: reghdfe share_pcr hhiq4 x_*, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum)
	estadd local Distance "15m"
	esttab * using HC_rev_crosssec_contract_comp.csv, replace se r2 obslast ///
		scalar(Distance) star(* 0.10 ** 0.05 *** 0.01) b(%12.3f) se(%12.3f)

}
}

exit




