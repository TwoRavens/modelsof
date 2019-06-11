/*----------------------------------------------HC_rev_crosssec_medanchor_altsample.do

Stuart Craig
Last updated 	20180816
*/


	timestamp, output
	cap mkdir crosssec
	cd crosssec
	cap mkdir altsample
	cd altsample


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
	keep if adj_price<.

	cap drop prov_fe
	egen prov_fe = group(prov_e_npi)
	makex, log
	eststo clear

	preserve
		drop if x_mdt_1==1
		eststo: reghdfe medanchor x_*, absorb(ep_adm_y prov_hrrnum) vce(cluster prov_hrrnum) keepsin
		estadd local Year_FE "Yes"
		estadd local HRR_FE "Yes"
		estadd local Hosp_FE "No"
	restore
	preserve
		drop if hcount15>6
		eststo: reghdfe medanchor x_*, absorb(ep_adm_y prov_hrrnum) vce(cluster prov_hrrnum) keepsin
		estadd local Year_FE "Yes"
		estadd local HRR_FE "Yes"
		estadd local Hosp_FE "No"
	restore
	
	esttab * using HC_rev_crosssec_medanchor_altsample.csv, replace  se r2 obslast ///
		scalar(Year_FE HRR_FE Hosp_FE) star(* 0.10 ** 0.05 *** 0.01) b(%12.3f) se(%12.3f)




exit
