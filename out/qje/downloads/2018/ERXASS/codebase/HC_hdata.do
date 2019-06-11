/* -----------------------------------------------------------------------HC_epdata_hdata.do
Creates a hospital-year extract to be used as the source for all subsequent analysis
on price

Stuart Craig
Last updated 20180816
*/


foreach proc of global proclist {
* foreach proc in ip {
	cap confirm file ${ddHC}/HC_hdata_`proc'.dta
	if _rc!=0 {
		
		// Bring in the episode data and collapse it down
		use ${ddHC}/HC_epdata_`proc'.dta, clear
		
		qui gen prov_vol=1
		rename ep_medprice medprice
		sort prov_e_npi prov_hrrnum prov_hsanum // maximize the population of these fields across the years
		
		collapse 	(mean) prov_pps price charge plusphy adj_price* adj_charge adj_plus medprice ///
					(last) prov_fips prov_hrr* prov_hsa* ///
					(sum) prov_vol , ///
					by(prov_e_npi ep_adm_y) fast

					
	//------------------------------------- Bring in the covariates

	// AHA
		// Mainfile
		pfixdrop merge
		cap drop _merge
		qui gen merge_year = ep_adm_y
		qui gen merge_npi  = prov_e_npi
		merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha.dta, keep(3) nogen 
		
		// Hospital mkt structure
		cap drop _merge
		merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha_counts.dta	, keep(3) nogen
		merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha_hhis.dta	, keep(3) nogen
		foreach v of varlist hhi_*m {
			rename `v' sys`v' // for consistency with old code
		}
	
	// HLI data
		cap drop _merge
		pfixdrop merge
		qui gen merge_year = ep_adm_y
		qui gen merge_fips = prov_fips
		merge m:1 merge_year merge_fips using ${ddHC}/HC_ext_hli_hhis.dta, keep(3) nogen // this ok?
		
	// County shares (from SAHIE and HCCI)	
		cap drop _merge
		pfixdrop merge
		qui gen merge_fips = prov_fips
		qui gen merge_year = ep_adm_y
		qui replace merge_year = 2008 if merge_year==2007
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_census_hccicoshare.dta, keep(3) nogen
		
	// USNWR	
		cap drop _merge
		pfixdrop merge
		qui gen merge_npi = prov_e_npi
		qui gen merge_year = ep_adm_y
		merge 1:1 merge_npi merge_year using ${ddHC}/HC_ext_usnwr.dta
		drop if _m==2
		qui gen usnwr_match = _m==3
		drop _merge
		
	// SAHIE
		pfixdrop merge
		qui gen merge_fips = prov_fips
		qui gen merge_year	 = ep_adm_y
		qui replace merge_year = 2008 if merge_year==2007 // DON'T DO THIS
		cap drop _merge
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_census_sahie.dta, keep(3) nogen

	// SAIPE
		pfixdrop merge
		qui gen merge_fips = prov_fips
		qui gen merge_year	 = ep_adm_y
		cap drop _merge
		qui replace merge_year=2008 if merge_year==2007
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_census_saipe.dta, keep(3) nogen

	// MCI--at this point we need this to bring in the urban/rural flag
		pfixdrop merge
		qui gen merge_npi = prov_e_npi
		qui gen merge_year = ep_adm_y
		cap drop _merge
		merge 1:1 merge_npi merge_year using ${ddHC}/HC_ext_cms_mci.dta, keep(3) nogen			

		save ${ddHC}/HC_hdata_`proc'.dta, replace
	
	}
}
exit
