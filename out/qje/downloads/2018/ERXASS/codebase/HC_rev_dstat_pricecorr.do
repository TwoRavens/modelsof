/*-----------------------------------------------------------HC_rev_dstat_pricecorr.do
Produces pairwise correlation of prices across cohorts
	
Stuart Craig
Last updated 	20180816
*/
timestamp, output
cap mkdir dstat_pricecorr
cd dstat_pricecorr

/*
-----------------------------------------------

Building a summary file of hospital prices

-----------------------------------------------
*/

	tempfile build
	loc ctr=0
	foreach proc of global proclist  {
		loc ++ctr
		
		use ${ddHC}/HC_hdata_`proc'.dta, clear
		keep if adj_price<.&inrange(merge_year,2008,2011)
		
		loc pps ""
		if "`proc'"=="ip" loc pps "prov_pps"
		keep adj_price prov_e_npi prov_vol ep_adm_y `pps'
		rename adj_price price

		// Keep 2011 only
		keep if ep_adm_y==2011
		// Additionally summarize Medicare prices for ip file
		if "`proc'"=="ip" {
			qui gen price_med = prov_pps
			qui gen meanprice_med = prov_pps
		}
		
		// Collapse down to a hospital and build a wide file of all procs
		gen meanprice = price
		keep meanprice* price* prov_e_npi ep_adm_y
		rename price price_`proc'		  // weighted by that year's activity
		rename meanprice meanprice_`proc'
		
		if `ctr'>1 {
			cap drop _merge
			merge 1:1 prov_e_npi ep_adm_y using `build'
			drop _merge
		}
		save `build', replace
	}

/*
-----------------------------------------------

Calculate correlation coefficients, storing
as columns

-----------------------------------------------
*/

	loc ctr=0
	foreach v1 of varlist price* {
		loc v1n = subinstr("`v1'","price_","",.)
		foreach v2 of varlist price* {
			loc v2n = subinstr("`v2'","price_","",.)
			loc ++ctr
			
			cap drop stdl
			cap drop stdr
			qui summ `v1' if `v1'<.&`v2'<.
			qui gen stdl = (`v1' - r(mean))/r(sd) if `v1'<.&`v2'<.
			qui summ `v2' if `v1'<.&`v2'<.
			qui gen stdr = (`v2' - r(mean))/r(sd) if `v1'<.&`v2'<.
			qui reg stdl stdr if `v1'<.&`v2'<.
			qui gen `v1n'_rho_`v2n' = string(_b[stdr],"%4.3f")
			cap drop temp_tstat
			qui gen temp_tstat = _b[stdr]/_se[stdr]
			// We are going to delete the stars from the excel file but 
			// want to see which are significant (quickly)
			if "`v1n'"!="`v2n'" {
				qui replace `v1n'_rho_`v2n' = `v1n'_rho_`v2n'+"*" if temp_tstat>1.64
				qui replace `v1n'_rho_`v2n' = `v1n'_rho_`v2n'+"*" if temp_tstat>1.96
				qui replace `v1n'_rho_`v2n' = `v1n'_rho_`v2n'+"*" if temp_tstat>2.58
			}
		}
	}
	drop std* temp_tstat
	

/*
-----------------------------------------------

Collapse results to table format

-----------------------------------------------
*/	

	foreach v of varlist meanprice_* {
		loc vn = subinstr("`v'","meanprice_","",.)
		qui gen stdprice_`vn' = `v'
		qui gen minprice_`vn' = `v'
		qui gen maxprice_`vn' = `v'
		qui gen ctprice_`vn' = `v'
	}
	collapse (mean) meanprice* (first) *rho* (sd) stdprice* (min) minprice* (max) maxprice* (count) ctprice*, fast
	qui gen i=.
	loc rlist "med_rho_"
	foreach proc of global proclist {
		loc rlist "`proc'_rho_ `rlist'"
	}
	reshape long meanprice_ stdprice_ minprice_ maxprice_ ctprice_ `rlist', i(i) j(proc) s
	qui gen maxminratio = maxprice/minprice
	drop maxprice minprice
	
	foreach v of varlist meanprice* stdprice* ctprice* {
		cap drop temp
		rename `v' temp
		qui gen `v' = string(temp,"%12.0fc")
	}
	drop maxminratio
		
	order proc mean std ctprice ${proclist} med
	loc ctr = 0
	foreach proc of global proclist {	
		loc ctr = `ctr'+1
		
		qui replace i = `ctr' if proc=="`proc'"
	}
	sort i 
	export excel using HC_rev_dstat_pricecorr.xls, first(var) replace


exit
