/*----------------------------------------------------------------HC_rev_crosssec_medanchor.do

Stuart Craig
Last updated 	20180816
*/

timestamp, output
cap mkdir crosssec
cd crosssec
cap mkdir medanchor
cd medanchor

foreach version in nomin min20 {

	use ${ddHC}/HC_cdata_ip_medid.dta, clear
	keep if adj_price<.
	bys prov_e_npi  ep_drg: gen N=_N
	keep if c_type==1
	if "`version'"=="min20" drop if N<20
	collapse (mean) medanchor, by(prov_e_npi ep_adm_y) fast
	gen merge_npi=prov_e_npi
	gen merge_year = ep_adm_y

	merge 1:1 merge_npi merge_year using ${ddHC}/HC_hdata_ip.dta, keep(3) nogen

	// Rescale for 0-100
	summ medanchor, d
	replace medanchor = medanchor*100
	keep if adj_price<.

	cap drop prov_fe
	egen prov_fe = group(prov_e_npi)
	makex, hccishare log
	eststo clear
	// MDT + other
	drop x_inssh
	eststo: reghdfe medanchor x_*, absorb(ep_adm_y) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "No"
	estadd local Hosp_FE "No"
	makex, hccishare log
	// MDT + other + HRR FE
	eststo: reghdfe medanchor x_*, absorb(ep_adm_y) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "Yes"
	estadd local Hosp_FE "No"
	// MDT + insurer + other + HRR FE
	eststo: reghdfe medanchor x_*, absorb(ep_adm_y prov_hrrnum) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "Yes"
	estadd local Hosp_FE "No"
	qui summ medanchor, mean
	estadd local MeanLHS = r(mean)
	unique prov_e_npi
	estadd local N_h = r(sum)

	esttab * using HC_rev_crosssec_medanchor_`version'.csv, replace /* nopa */ se r2 obslast ///
		scalar(Year_FE HRR_FE Hosp_FE MeanLHS N_h) star(* 0.10 ** 0.05 *** 0.01) b(%12.3f) se(%12.3f)

}



exit
