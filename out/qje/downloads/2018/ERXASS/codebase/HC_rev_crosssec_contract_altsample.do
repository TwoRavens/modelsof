/* ----------------------------------------------HC_rev_crosssec_contract_altsample.do

Stuart Craig
Last updated 	20180816
*/


	timestamp, output
	cap mkdir crosssec
	cd crosssec
	cap mkdir altsample
	cd altsample

	foreach r in norestrict {
	foreach proc in ip  {
		eststo clear
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
		makex, log
		
		cap gen unc_restrict=0
		qui gen share_pcr = ptc_`r'*100
		qui gen share_unc = unc_`r'*100
		
		// No monopolies
		preserve
		drop if x_mdt_1==1
		eststo m`proc'_nomonop: reghdfe share_pcr x_*, absorb(ep_adm_y proc_fe prov_hrrnum) vce(cluster prov_hrrnum)
		restore
		// Without 6+
		preserve
		drop if hcount15>6
		eststo m`proc'_under6: reghdfe share_pcr x_*, absorb(ep_adm_y proc_fe prov_hrrnum) vce(cluster prov_hrrnum)
		restore
		
		esttab m* using HC_rev_crosssec_contract_altsample.csv, replace  ///
		r2 b(%4.3f) se(%4.3f) scalar(Procedure) obslast 
		
	}
	}

exit




