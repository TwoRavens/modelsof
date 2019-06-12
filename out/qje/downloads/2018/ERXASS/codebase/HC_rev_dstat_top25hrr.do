/*-----------------------------------------------------------------HC_rev_dstat_top25hrr.do

Stuart Craig
Last updated 	20180816
*/

timestamp, output
cap mkdir dstat_top25hrr
cd dstat_top25hrr



/*
-----------------------------------------------------

Create a list of the 25 most populated HRRs

-----------------------------------------------------
*/
	* 2011 edit
	use ${ddHC}/enrollment/HC_enrollment_all.dta, clear
	keep if merge_year==2011
	collapse (sum) enrollee_equiv, by(merge_hrr) fast // do it across years
	gsort -enrollee_equiv
	
	keep in 1/25
	tempfile hrrpop
	save `hrrpop', replace

/*
-----------------------------------------------------

Calculate the mean and relative sd for each of the
HRRs across all clinical cohorts

-----------------------------------------------------
*/
	loc ctr=0
	foreach proc of global proclist {
		loc ++ctr
		
		use ${ddHC}/HC_hdata_`proc'.dta, clear
		keep if adj_price<.&inrange(merge_year,2008,2011)
		
		cap drop price
		qui gen price = adj_price
		cap gen year = ep_adm_y
		cpigen
		qui summ cpi if year==2011, mean
		qui replace cpi = cpi/r(mean)
		qui replace price = price/cpi
		cap drop medicare
		qui gen medicare = medprice/cpi
		if "`proc'"=="ip" qui replace medicare = prov_pps/cpi
		collapse (mean) price medicare (first) prov_hrr* [aw=prov_vol], by(prov_e_npi ep_adm_y) fast
		/*
		keep if year==2011
		cap gen medicare = prov_pps
		*/
		keep prov_e_npi ep_adm_y price medicare prov_hrr*
		
		loc cl ""
		foreach v of varlist price medicare {
			loc cl "`cl' (mean) mean_`v'=`v' (sd) sd_`v'=`v'"
		}
		qui gen N_ht_`proc'=1
		bys prov_e_npi: gen N_h=_n==1
		collapse `cl' (sum) N_ht N_h, by(prov_hrr*) fast
		
		foreach p in price medicare {
			qui gen cov_`p' = sd_`p'/mean_`p'
		}
		set obs `=_N+1'
		qui replace prov_hrrnum=-9 if prov_hrrnum==.
		foreach v of varlist mean* cov* sd* {
			qui summ `v', mean
			qui replace `v'=r(mean) if prov_hrrnum==-9
		}
		drop sd*
		reshape long mean_ cov_, i(prov_hrrnum) j(mkt) s
		rename N* N*_
		foreach v of varlist mean* cov* N* {
			rename `v' `v'`proc'
		}
		keep if mkt=="price"|prov_hrrnum==-9
		replace prov_hrrnum=-8 if mkt=="medicare"
		// The national average price here is different from table 3 because it's not weighted by HRR!
		cap gen merge_hrr= prov_hrrnum 
		merge m:1 merge_hrr using `hrrpop'
		keep if _m==3|merge_hrr==-9|merge_hrr==-8
		drop _merge
		save `hrrpop', replace
	}

/*
-----------------------------------------------------

Clean up the table(s)

-----------------------------------------------------
*/	
	order prov* *_ip *hip *knr *delc *delv *ptca *col
	outsheet using HC_rev_dstat_top25hrr_raw.csv, comma replace
	
	keep prov* mean* cov*
	foreach v of varlist mean* {
		cap drop temp
		rename `v' temp
		qui gen `v' = string(temp,"%12.0fc")
		drop temp
	}
	foreach v of varlist cov* {
		cap drop temp
		rename `v' temp
		qui gen `v' = string(temp,"%4.3f")
		drop temp
	}
	order prov* *_ip *hip *knr *delc *delv *ptca *col
	outsheet using HC_rev_dstat_top25hrr_clean.csv, comma replace
	
exit
