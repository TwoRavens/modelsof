/*-----------------------------------------------HC_rev_crosssec_price_altmeasures.do

Stuart Craig
Last updated 	20180816
*/

	timestamp, output
	cap mkdir crosssec
	cd crosssec
	cap mkdir price
	cd price


/*
----------------------------------------------

Use ICD9 code to risk adjust

----------------------------------------------
*/

	cap confirm file ${ddHC}/HC_hdata_diagFE.dta
	if _rc!=0 {
		use price pat_age pat_female ep_adm_y prov_e_npi *diag* ///
			using ${ddHC}/HC_epdata_ip.dta, clear

		cap drop temp_hy
		qui egen temp_hy = group(ep_adm_y prov_e_npi)

		cap drop prov_vol
		qbys temp_hy: gen prov_vol = _N

		cap drop temp_diagFE
		qui egen temp_diagFE = group(ep_diag1)

		cap drop in_sample
		qui gen in_sample = prov_vol>=50

		xi: reghdfe price i.pat_age pat_female if in_sample, absorb(temp_hy temp_diagFE, savefe)
		qui summ price if e(sample), mean
		qui gen adj_price_diag_r50 = r(mean) + __hdfe1__ if e(sample)

		bys prov_e_npi ep_adm_y: keep if _n==1
		keep prov_e_npi ep_adm_y adj_price_diag_r50
		rename prov_e_npi merge_npi
		rename ep_adm_y merge_year
		save ${ddHC}/HC_hdata_diagFE.dta, replace
	}

	
/*
----------------------------------------------

Add Charlson Score to risk adjustment

----------------------------------------------
*/

	cap confirm file ${ddHC}/HC_hdata_charlson.dta
	if _rc!=0 {
		use price pat_age pat_female pat*6* ep_adm_y prov_e_npi ep_drg *diag* ///
			using ${ddHC}/HC_epdata_ip.dta, clear

		drop if pat_6moenroll=="N"|pat_charlson6==.	
			
		cap drop temp_hy
		qui egen temp_hy = group(ep_adm_y prov_e_npi)

		cap drop prov_vol
		qbys temp_hy: gen prov_vol = _N

		cap drop temp_diagFE
		qui egen temp_diagFE = group(ep_drg)

		cap drop in_sample
		qui gen in_sample = prov_vol>=50

		xi: reghdfe price i.pat_age pat_female i.pat_charlson6 if in_sample, absorb(temp_hy temp_diagFE, savefe)
		qui summ price if e(sample), mean
		qui gen adj_price_charlson = r(mean) + __hdfe1__ if e(sample)

		bys prov_e_npi ep_adm_y: keep if _n==1
		keep prov_e_npi ep_adm_y adj_price_charlson
		rename prov_e_npi merge_npi
		rename ep_adm_y merge_year
		save ${ddHC}/HC_hdata_charlson.dta, replace
	}

	
/*
----------------------------------------------

Different count restrictions and
version with log before adjustment

----------------------------------------------
*/

	cap confirm file ${ddHC}/HC_hdata_countrestrict.dta
	if _rc!=0 {
		use price charge pat_age pat_female ep_adm_y prov_e_npi *drg* ///
			using ${ddHC}/HC_epdata_ip.dta, clear

		cap drop temp_hy
		qui egen temp_hy = group(ep_adm_y prov_e_npi)

		cap drop prov_vol
		bys temp_hy: gen prov_vol = _N

		foreach pv in price {
		forval restrict=10(10)100 {
			cap drop in_sample 
			qui gen in_sample = prov_vol>=`restrict'
			
			xi: reghdfe `pv' i.pat_age pat_female if in_sample, absorb(temp_hy ep_drg, savefe) 
			cap drop adj_`pv'_r`restrict'
			qui summ `pv' if e(sample), mean
			qui gen adj_`pv'_r`restrict' = r(mean) + __hdfe1__  if e(sample)
			* qui replace adj_`pv'_r`restrict'=. if adj_`pv'_r`restrict'<=0
			
			cap drop logprice
			qui gen logprice = log(`pv')
			xi: reghdfe logprice i.pat_age pat_female if in_sample, absorb(temp_hy ep_drg, savefe)
			cap drop adj_log`pv'_r`restrict'
			qui summ logprice
			qui gen adj_log`pv'_r`restrict' = r(mean) + __hdfe1__ if e(sample)
			
		}

		}

		keep prov_e_npi ep_adm_y adj_*_r*
		bys prov_e_npi ep_adm_y: keep if _n==1
		rename prov_e_npi 	merge_npi
		rename ep_adm_y		merge_year
		save ${ddHC}/HC_hdata_countrestrict.dta, replace
	}

	
/*
----------------------------------------------

Regressions

----------------------------------------------
*/

	use ${ddHC}/HC_hdata_ip.dta, clear

	merge m:1 aha_id merge_year using ${ddHC}/HC_ext_hcris_dprice.dta, keep(1 3) nogen
	merge m:1 merge_npi merge_year using ${ddHC}/HC_hdata_countrestrict.dta, assert(3) nogen
	merge m:1 merge_npi merge_year using ${ddHC}/HC_hdata_diagFE.dta, assert(3) nogen
	merge m:1 merge_npi merge_year using ${ddHC}/HC_hdata_charlson.dta, keep(1 3) nogen

	keep if inrange(merge_year,2008,2011)
	foreach lhs of varlist adj_price_charlson adj_price_r* adj_logprice_r* dprice price adj_price_diag { 
		eststo clear
		
		if "`lhs'"=="dprice" {
			preserve
				cap drop logprice
				qui gen logprice = log(1 + adj_price)
				drop if dprice==.
				makex, log
				drop x_inssh
				eststo: reghdfe logprice x_*, absorb(merge_year) vce(cluster prov_hrrnum)
				makex, log
				eststo: reghdfe logprice x_*, absorb(merge_year) vce(cluster prov_hrrnum)
				eststo: reghdfe logprice x_*, absorb(prov_hrrnum merge_year) vce(cluster prov_hrrnum)
			restore
		}
		
		cap drop logprice
		if strpos("`lhs'","log")>0 qui gen logprice = `lhs'
		else qui gen logprice = log(1 + `lhs')
		
		makex, log
		drop x_inssh
		eststo: reghdfe logprice x_*, absorb(merge_year) vce(cluster prov_hrrnum)
		makex, log
		eststo: reghdfe logprice x_*, absorb(merge_year) vce(cluster prov_hrrnum)
		eststo: reghdfe logprice x_*, absorb(prov_hrrnum merge_year) vce(cluster prov_hrrnum)
		esttab * using HC_rev_crosssec_price_altmeasures_`lhs'.csv, ///
			replace  star(* .1 ** .05 *** .01)  ///
			b(%4.3f) se(%4.3f) scalar(r2) obslast lab
			
	}


exit
