/*------------------------------------------------------------HC_rev_dstat_ahacompare.do

Stuart Craig
Last updated 	20180816
*/


timestamp, output
cap mkdir dstat_ahacompare
cd dstat_ahacompare

tempfile build
loc ctr=0
loc samples "aha ip_all ${proclist}"
foreach sample of local samples {
	loc ++ctr

// -------------------------------- Build an AHA extract with all the bells and whistles

	cap confirm file ${tHC}/temp_aha_subsample.dta // OK to save this to the 
	if _rc!=0 {
		use ${ddHC}/HC_ext_aha.dta, clear
		merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha_hhis.dta, keep(3) nogen
		merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha_counts.dta, keep(3) nogen
		qui gen merge_fips = aha_fips
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_hhis.dta, keep(3) nogen
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_bcbs.dta, keep(3) nogen
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_census_hccicoshare.dta, keep(3) nogen
		merge 1:1 merge_npi merge_year using ${ddHC}/HC_ext_usnwr.dta, keep(1 3)
		qui gen usnwr_match = _m==3
		drop _merge
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_census_sahie.dta, keep(3) nogen
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_census_saipe.dta, keep(3) nogen
		// These have some missings which we will impute as the average 
		// to keep everyone in the sample
		merge m:1 merge_npi merge_year using ${ddHC}/HC_ext_mhc.dta, ///
			keepusing(mhc_amim01 mhc_amim10 mhc_surgm08  mhc_surgm38) keep(1 3) nogen
		merge 1:1 merge_npi merge_year using ${ddHC}/HC_ext_cms_mci.dta, keep(1 3) nogen keepusing(mci_pps_pmt mci_urgeo)
		rename hhi*m syshhi*m
		foreach v of varlist mhc* mci_pps_pmt {
			qui summ `v', mean
			qui replace `v' = r(mean) if `v'==.
		}
		rename mci_pps_pmt prov_pps
		// Drop critical access hospitals
		drop if aha_cah==1
		save ${tHC}/temp_aha_subsample.dta
	}
	else use ${tHC}/temp_aha_subsample.dta, clear

// --------------------------------  Restrict to the relevant sample
	if "`sample'"!="aha" {
		if "`sample'"=="ip_all" merge 1:1 merge_npi merge_year using ${ddHC}/HC_hdata_ip.dta, keep(3) nogen
		else {
			merge 1:1 merge_npi merge_year using ${ddHC}/HC_hdata_`sample'.dta, keep(3) nogen
			// We want to look at a version that does not impose the 
			// 50-episode count restriction (not in paper)
			keep if adj_price<.
		}
	}

// -------------------------------- Generate summary stats and stack the samples
	
	makex, hccishare bcbs rural
	qui gen x_q1 = mhc_amim01 
	qui gen x_q2 = mhc_amim10 
	qui gen x_q3 = mhc_surgm08 
	qui gen x_q4 = mhc_surgm38
	qui gen x_hosphhi = syshhi_15m
	
	// Generate counter vars and collapse 
	bys merge_npi: gen N_h=_n==1
	gen N_ht = 1
	gen N_adms = max(min((1 - aha_prop_care - aha_prop_caid),1),0)*aha_admtot
	collapse (mean) x_* (sum) N_*, fast
	rename N_* x_N_*
	
	// Formatting
	foreach v of varlist x_mdt* x_usnews x_teach x_gov x_nonprofit x_rural x_hosphhi {
		cap drop temp
		rename `v' temp
		qui gen `v' = string(temp,"%4.3f")
		drop temp
	}
	foreach v of varlist x_inssh x_bcbs x_tech x_beds x_pctiu  ///
		 x_medshare x_caidshare x_q? {
		
		cap drop temp
		rename `v' temp
		qui gen `v' = string(temp,"%10.1fc")
		drop temp
	}
	foreach v of varlist x_N_* x_medinc x_ppspmt  {
		cap drop temp
		rename `v' temp
		qui gen `v' = string(temp,"%20.0fc")
		drop temp
	}
	qui gen i=.
	reshape long x_, i(i) j(stat) string
	qui replace i = 1.0 if stat=="mdt_1"
	qui replace i = 1.1 if stat=="mdt_2"
	qui replace i = 1.2 if stat=="mdt_3"
	qui replace i = 1.3 if stat=="hosphhi"
	qui replace i = 2 if stat=="inssh"
	qui replace i = 3 if stat=="bcbs"
	qui replace i = 4 if stat=="tech"
	qui replace i = 5 if stat=="usnews"
	qui replace i = 6 if stat=="beds"
	qui replace i = 7 if stat=="teach"
	qui replace i = 8 if stat=="gov"
	qui replace i = 9 if stat=="nonprofit"
	qui replace i = 10 if stat=="pctiu"
	qui replace i = 11 if stat=="medinc"
	qui replace i = 12 if stat=="rural"
	qui replace i = 13 if stat=="ppspmt"
	qui replace i = 14 if stat=="medshare"
	qui replace i = 15 if stat=="caidshare"
	qui replace i = 16 if stat=="q1"
	qui replace i = 17 if stat=="q2"
	qui replace i = 18 if stat=="q3"
	qui replace i = 19 if stat=="q4"
	qui replace i = 20 if stat=="N_ht"
	qui replace i = 21 if stat=="N_h"

	rename x_ `sample'
	if `ctr'>1 merge 1:1 i using `build', assert(3) nogen
	save `build', replace
}
order stat `samples'
export excel using HC_rev_dstat_ahasample.xls, first(var) replace

exit
