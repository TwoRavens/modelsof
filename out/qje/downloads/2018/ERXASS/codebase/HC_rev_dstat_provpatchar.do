/*----------------------------------------------------HC_rev_dstat_provpatchar.do
Provider and patient characteristics
	
Stuart Craig
Last updated 	20180816
*/



foreach proc of global proclist {

// Patient characteristics
	use ${ddHC}/HC_epdata_`proc'.dta, clear
	
	// Bring in the price index from the hospital file
	// to guarantee consistent sample selection
	cap gen merge_npi = prov_e_npi
	cap gen merge_year = ep_adm_y
	merge m:1 merge_npi merge_year using ${ddHC}/HC_hdata_`proc'.dta, ///
		keep(3) nogen keepusing(adj_price)
	keep if adj_price<.&inrange(ep_adm_y,2008,2011)
	
	forvalues a=2/6 {
		qui gen age`a' = pat_age==`a'
	}
	qui levelsof pat_prod, local(prods)
	foreach prod of local prods {
		cap drop prod_`prod'
		qui gen prod_`prod' = pat_prod=="`prod'"
	}
	gen funding = real(pat_fund)
	rename pat_female female
	rename pat_charlson6 charlson
	bys prov_e_npi: gen N_h=_n==1
	bys prov_e_npi ep_adm_y: gen N_ht=_n==1
	keep age? female charlson N_* prod_* funding
	foreach v of varlist age? female charlson /* prod* funding */ {
		qui gen mean_`v' 	= `v'
		qui gen sd_`v'		= `v'
		qui gen min_`v'		= `v'
		qui gen max_`v'		= `v'
	}
	qui gen N_i=1
	collapse (mean) mean* (sd) sd* (min) min* (max) max* (sum) N_h N_ht N_i, fast
	gen i=1
	tempfile pat
	save `pat', replace

// Provider characteristics
	use ${ddHC}/HC_hdata_`proc'.dta, clear
	keep if adj_price<.&inrange(merge_year,2008,2011)
	gen merge_fips = prov_fips
	merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_bcbs.dta, keep(3) nogen
	merge m:1 merge_npi merge_year using ${ddHC}/HC_ext_mhc.dta, keep(1 3) nogen
	
	// Get them ordered to reduce formatting later
	qui gen _01_mdt1		= hcount15==1
	qui gen _01_mdt2		= hcount15==2
	qui gen _01_mdt3		= hcount15==3
	qui gen _01_mdt_4plus	= hcount15>3
	qui gen _01hosphhi	= syshhi_15m
	qui gen _02inshhi  	= hli_hhi_all
	qui gen _03a_hccish = hcci_coshare
	qui gen _03b_bcbssh	= hli_bcbsms
	qui gen _04tech	  	= aha_techtot
	qui gen _05usnews	= usnwr_match
	qui gen _06beds		= aha_bdtot
	qui gen _07teach	= aha_teaching
	qui gen _08gov		= aha_own_gov
	qui gen _09nonprofit= aha_own_np
	qui gen _095forprofit=aha_own_fp
	qui gen _10pctiu	= sahie_pctui/100
	qui gen _11medinc	= saipe_medinc
	qui gen _12rural	= mci_urgeo=="RURAL"
	qui gen _13pps		= prov_pps
	qui gen _14careshare= aha_prop_care*100
	qui gen _15caidshare= aha_prop_caid*100
	qui gen _16amideath = 1 - mhc_amim01/100  if mhc_amim01>0
	qui gen _17amiaspir = mhc_amim10/100  if mhc_amim10>0
	qui gen _18anti1hr	= mhc_surgm08/100 if mhc_surgm08>0
	qui gen _19clots24hr= mhc_surgm38/100 if mhc_surgm38>0 // these are scaled for regressions, but undo for excel table
	cap drop _merge
	foreach v of varlist _* {
		qui gen mean_`v' 	= `v'
		qui gen sd_`v'		= `v'
		qui gen min_`v'		= `v'
		qui gen max_`v'		= `v'
	}
	bys prov_e_npi: gen N_h = _n==1
	gen N_ht=1
	
	collapse (mean) mean* (sd) sd* (min) min* (max) max* (sum) N_h N_ht, fast
	gen i=1
	merge 1:1 i using `pat', assert(3) nogen
	
	reshape long mean_ sd_ min_ max_, i(N_h) j(v) s
	
	timestamp, output
	cap mkdir dstat_provpatchar
	cd dstat_provpatchar
	outsheet using HC_rev_provpatchar_`proc'.csv, replace comma
}


exit
