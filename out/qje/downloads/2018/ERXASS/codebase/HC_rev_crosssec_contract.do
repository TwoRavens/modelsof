/*-------------------------------------------------------------HC_rev_crosssec_contract.do

Stuart Craig
Last updated 20180816
*/

timestamp, output
cap mkdir crosssec
cd crosssec
cap mkdir contract
cd contract

foreach version in nomin min20 {
eststo clear
foreach proc of global proclist {

	use ${ddHC}/HC_cdata_`proc'_i.dta, clear
	
	// Show that this is robust to a 20 count minimum
	bys prov_e_npi ep_drg: gen N=_N
	if "`version'"=="min20" drop if N<20
	// Sample consistency--years already restricted to 2010-2011 in contract file
	keep if adj_price<. 
	
	// One version where we control for the unclassifieds, another where we don't
	cap drop pps_norestrict
	qui gen pps_norestrict = c_type==1
	cap drop ptc_norestrict
	qui gen ptc_norestrict = c_type==2
	cap drop unc_norestrict
	qui gen unc_norestrict = !inlist(c_type,1,2)
	foreach ctype in pps ptc {
		qui gen `ctype'_restrict = `ctype'_norestrict if inlist(c_type,1,2)
	}
	collapse (mean) *restrict , by(prov_e_npi ep_adm_y) fast
	
	// Bring in the RHS variables 
	merge 1:1 prov_e_npi ep_adm_y using ${ddHC}/HC_hdata_`proc'.dta, keep(3) nogen
	
	qui gen share_pcr = ptc_norestrict*100
	qui gen share_unc = unc_norestrict*100
	cap gen proc = "`proc'"
	cap egen proc_fe = group(proc)
	loc c nocontrol // always no control in final versions (doesn't materially effect results)
	loc u ""
	if "`c'"=="control" loc u "share_unc"
	makex, log hccishare
	drop x_inssh
	eststo m1`proc': reghdfe share_pcr `u' x_*	, ///
		absorb(ep_adm_y proc_fe) vce(cluster prov_hrrnum) keepsin
	makex, log hccishare
	eststo m2`proc': reghdfe share_pcr `u' x_*	, ///
		absorb(ep_adm_y proc_fe) vce(cluster prov_hrrnum) keepsin
	estadd local Procedure "`proc'"
	eststo m3`proc': reghdfe share_pcr `u' x_*	, ///
		absorb(ep_adm_y proc_fe prov_hrrnum) vce(cluster prov_hrrnum) keepsin
	estadd local Procedure "`proc'"
	// Store summary stats for the panel heading
	qui summ share_pcr, mean
	estadd local MeanLHS = r(mean)
	unique prov_e_npi
	estadd local N_h = r(sum)
	
	esttab m*`proc' using HC_rev_crosssec_contract_`proc'_`version'_`c'.csv, replace  ///
		r2 b(%4.3f) se(%4.3f) scalar(Procedure MeanLHS N_h) obslast 

}
esttab m3* using HC_rev_crosssec_contract_allproc_`version'_`c'.csv, replace  ///
			r2 b(%4.3f) se(%4.3f) scalar(Procedure MeanLHS N_h) obslast
}


exit

