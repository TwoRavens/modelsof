/*------------------------------------------------------------HC_rev_bcbsrobust_all.do

Stuart Craig
Last updated	20180816
*/
timestamp, output
cap mkdir bcbsrobust
cd bcbsrobust


/*
-------------------------------------------

Make sure that the co. BCBS market shares 
have been calculated

-------------------------------------------
*/

	confirm file ${ddHC}/HC_ext_hli_bcbs.dta

	
/*
-------------------------------------------

Next, what share of the HRR is in covered?
- Estimating by disaggregating to zip code
then aggregating back up to HRR

-------------------------------------------
*/

	cap confirm file ${ddHC}/HC_ext_hli_bcbs_hrr.dta
	if _rc!=0 {
		// Bring in the county/zip crosswalk to distribute covered lives to each zip code
		import excel using ${rdHC}/hud/COUNTY_ZIP_032010.xlsx, clear first
		qui ds
		foreach v in `r(varlist)' {
			rename `v' `=lower("`v'")'
		}
		cap drop temp_tot
		qui egen temp_tot = total(tot_ratio), by(county)
		assert round(temp_tot,.0001)==1 // must be 100% within some precision window
		drop temp_tot

		cap drop merge_fips
		cap drop merge_year
		qui gen merge_fips = county
		qui gen merge_year = 2011
		* merge m:1 merge_fips merge_year using `lives'
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_bcbs.dta
		drop if _m<3 // Virgin Islands, PR, Guam, "Other", etc. . . 
		drop _merge
		
		// Zip code covered lives are the residential ratio*lives
		cap drop zip_lives
		qui gen zip_lives = round(res_ratio*hli_totalbook)
		cap drop zip_bcbs 
		qui gen zip_bcbs = round(res_ratio*hli_bcbsbook)
		
		// Obs is a zip/county pair, so now let's add up by zip
		collapse (sum) zip_lives zip_bcbs, by(zip) fast
		rename zip merge_zip
		qui gen merge_year=2011

		// Bring in the HRR crosswalk
		merge m:1 merge_zip merge_year using ${ddHC}/HC_ext_atlas_zipcrosswalk.dta, keepusing(hrr*)
		drop if _m<3 // more PR and 0 population areas
		drop _merge

		collapse (sum) hrr_lives=zip_lives hrr_bcbs=zip_bcbs, by(hrr*) fast // it's all 2011
		rename hrrnum merge_hrr
		gen hrr_bcbspct = hrr_bcbs/hrr_lives
		keep merge_hrr hrr_bcbspct
		
		save ${ddHC}/HC_ext_hli_bcbs_hrr.dta, replace
	}



/*
-------------------------------------------

Now, do the correlation of Medicare/Private
SPB with high/low BCBS share

-------------------------------------------
*/


	use ${ddHC}/HC_rev_spbdata_2011.dta, clear
	merge 1:1 merge_hrr using ${ddHC}/HC_ext_hli_bcbs_hrr.dta, assert(3) nogen
	summ hrr_bcbspct, d
	loc med = r(p50)
	gen high = hrr_bcbspct>r(p50)
	gen low  = hrr_bcbspct<=r(p50)
	gen all=1

	tempfile spb
	cap postclose spb
	postfile spb rho str10 level str10 sample using `spb'

	foreach level in ip tot {
	foreach sample in all high low {
		corr *_spb_`level' if `sample'
		post spb (r(rho)) ("`level'") ("`sample'")
	}
	}
	postclose spb
	use `spb', clear

	egen s = group(sample)
	reshape wide rho, i(s) j(level) s

	rename rhoip Inpatient
	rename rhotot Total
	order sample Total Inpatient
	keep sample Total Inpatient
	gen bcbs_cut = `med'
	outsheet using HC_rev_bcbsrobust_spbcorr.csv, comma replace


/*
-------------------------------------------

PQ decomp with high/low BCBS

-------------------------------------------
*/

	// Need to check that the right age range was calculated previously in the "decomp2" files
	loc decompyear=2011
	foreach side in high low {
		foreach t in private public {
			clear all
			set maxvar 10000
			use ${tHC}/decomp2_`t'_`decompyear'_over55.dta, clear

			merge 1:1 merge_hrr using ${ddHC}/HC_ext_hli_bcbs_hrr.dta, assert(3) nogen
			qui summ hrr_bcbspct, d
			gen high = hrr_bcbspct>r(p50)
			if "`side'"=="high" keep if high==1
			else keep if high==0
			
			cap drop v_spending
			qui gen v_spending=0
			foreach pricevar of varlist price* {
				cap assert `pricevar'==0
				if _rc==0 continue 
				
				loc volvar = subinstr("`pricevar'","price","vol",.)
				loc num = subinstr("`pricevar'","price","",.)
				
				loc pmin=0
				loc vmin=0
				qui gen v_lnp`num' = ln(`pricevar' + `pmin')
				qui gen v_lnq`num' = ln(`volvar' + `vmin')
				qui gen v_lnpq`num' = ln((`pricevar' + `pmin')*(`volvar' + `vmin'))
				qui gen v_pq`num' = `pricevar'*`volvar'
				cap qui corr v_lnq`num' v_lnp`num', c
				qui gen cov2_`num'=r(cov_12)*2
				qui gen count`num' = `volvar'*enroll
				qui replace v_spending = v_spending + v_pq`num'
				di ., _c
			}
			
			collapse (sd) v_* (first) cov2_* (sum) count* totspend*, fast
			gen i=.
			reshape long v_lnp v_lnq v_lnpq v_pq cov2_ count totspend, i(i) j(drg) s
			foreach v of varlist v_* {
				qui replace `v' = `v'^2 // transform to variance
			}

			qui gen share_p 	= v_lnp/v_lnpq
			qui gen share_q 	= v_lnq/v_lnpq
			qui gen share_cov 	= cov2_/v_lnpq

			// Save a dataset of the DRG-level decomp
			outsheet using HC_rev_pqdecomp_drglevel_`t'_bcbs`side'.csv, comma replace
			save ${tHC}/HC_rev_pqdecomp_drglevel_`t'_bcbs`side'.dta, replace


		}	
	}
	
	// Create summary tables (Appendix Table XXVI)
	foreach t in private public {
		insheet using HC_rev_pqdecomp_drglevel_`t'_bcbshigh.csv, comma clear
		drop if inrange(drg,876,897)
		collapse (mean) share* [aw=totspend], fast
		gen high=1
		tempfile privatehigh
		save `privatehigh'
		insheet using HC_rev_pqdecomp_drglevel_`t'_bcbslow.csv, comma clear
		drop if inrange(drg,876,897)
		collapse (mean) share* [aw=totspend], fast
		append using `privatehigh'
		replace high=0 if high==.
		outsheet using HC_rev_pqdecomp_agg_bcbs_`t'.csv, comma replace
	}




/*
-------------------------------------------

Price decomp with BCBS

-------------------------------------------
*/

	use ${ddHC}/HC_ext_hli_bcbs.dta, clear
	keep if merge_year==2011
	qui summ hli_bcbsms, d
	loc med = r(p50)

	foreach side in high low {
	foreach ttype in month {
		
		cap confirm file HC_pricedecomp_4ways_t`ttype'_`side'.dta
		if _rc!=0 {
		cap postclose decomp
		postfile decomp d level r2 str10 proc N CoV using HC_pricedecomp_4ways_t`ttype'_`side'.dta, replace

		// Can toggle multiple treatments of time here
		forval way = 3/3 {
		di ""
		di "Version: `way'", _c
		foreach proc of global proclist {
		if "`proc'"=="ip" continue
		di "`proc'", _c
		qui {
		
		//-------------------------------------------Load the data
			
			use ${ddHC}/HC_epdata_`proc'.dta, clear
			
			// Make this the same as the regression samples
			keep if inrange(ep_adm_y,2010,2011)
			keep if adj_price<.
			
			// Build some fixed effects 
			cap gen ep_adm_m = mofd(ep_adm_d)
			cap gen ep_adm_q = qofd(ep_adm_d)
			cap egen hfe = group(prov_e_npi)
			cap egen hrrfe = group(prov_hrrnum)
			
			cap gen pat_mkt=1
			foreach v of varlist pat_prod pat_fund pat_mkt {
				cap confirm numeric var `v'
				if _rc!=0 {
					cap drop temp
					rename `v' temp
					qui egen `v' = group(temp)
				}
			}
			
			cap drop _merge
			qui gen merge_fips = prov_fips
			cap gen merge_year=2011
			merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_bcbs.dta, keep(3) nogen
			gen high = hli_bcbsms>`med'
			if "`side'"=="high" keep if high
			else keep if !high
			
		//-------------------------------------------How are we treating time?	
			
			cap drop time
			if "`ttype'"=="year"  qui egen time = group(ep_adm_y)
			if "`ttype'"=="qtr"   qui egen time = group(ep_adm_q)
			if "`ttype'"=="month" qui egen time = group(ep_adm_m)
			
			// Way 1 is no control for month
			loc time ""
			// Way 2 is to control for month in aggregate
			if `way'==2 loc time time
			// Way 3 is to control for month of level
			if `way'==3 {
				cap drop hfe
				qui egen hfe = group(prov_e_npi time)
				cap drop hrrfe
				qui egen hrrfe = group(prov_hrrnum time)
			}
			if `way'==4 {
				if "`ttype'"=="month" keep if ep_adm_m==ym(2011,1)
				if "`ttype'"=="year" keep if ep_adm_y==2011
				if "`ttype'"=="qtr"   keep if qofd(ep_adm_d)==yq(2011,1)
			}
		//-------------------------------------------Calculate the aggregate measures	
			// Grab the sample size
			qui count
			loc N=r(N)
			// Grab average within-hospital-month CoV
			preserve
				collapse (mean) mean_price=price (sd) sd_price = price, by(prov_e_npi ep_adm_m) fast
				qui gen cov = sd/mean
				qui summ cov, mean
				loc cov = r(mean)
			restore

		//-------------------------------------------Pull the R2 from the level regressions	
			
			loc pc "pat_age pat_female"
			loc ins "pat_prod pat_fund"
			loc drg ""
			if "`proc'"=="ip" loc drg "ep_drg"
			qui reghdfe price, absorb(`pc' `drg' `time') keepsin
			post decomp (`way') (1) (e(r2)) ("`proc'") (`N') (`cov')
			
			qui reghdfe price, absorb(`pc' `drg' `time' `ins') keepsin
			post decomp (`way') (2) (e(r2)) ("`proc'") (`N') (`cov')
			
			qui reghdfe price, absorb(`pc' `drg' `time' `ins' hrrfe) keepsin
			post decomp (`way') (3) (e(r2)) ("`proc'") (`N') (`cov')
			
			qui reghdfe price, absorb(`pc' `drg' `time' `ins' hfe) keepsin
			post decomp (`way') (4) (e(r2)) ("`proc'") (`N') (`cov')
			
			qui reghdfe price charge, absorb(`pc' `drg' `time' `ins' hfe) keepsin
			post decomp (`way') (5) (e(r2)) ("`proc'") (`N') (`cov')
			
		}
		}
		}
		postclose decomp
		}

		// Need to alter this as well if going for multiple time treatments
		forval way=3/3 {
			qui {
				use HC_pricedecomp_4ways_t`ttype'_`side'.dta, clear
				keep if d==`way'
				drop d
				rename r2 r2_
				reshape wide r2, i(proc) j(level)

				qui gen s=.
				loc ctr=0
				foreach proc of global proclist {
					if "`proc'"=="ip" continue
					loc ++ctr
					replace s = `ctr' if proc=="`proc'"
				}
				sort s
				drop s
			}
			list
			outsheet using HC_rev_pricedecomp_v`way'_t`ttype'_`side'bcbs.csv, comma replace
		}
	}
	}

	
/*
-------------------------------------------

Variation Table(s)

-------------------------------------------
*/
	

	use ${ddHC}/HC_ext_hli_bcbs.dta, clear
	keep if merge_year==2011
	qui summ hli_bcbsms, d
	global medbcbs = r(p50)
	
	foreach side in all high low {

	tempfile build
	loc c=0
	foreach proc of global proclist {
		* if inlist("`proc'","ip") continue
		loc ++c
		
		use if ep_adm_y==2011 using ${ddHC}/HC_epdata_`proc'.dta, clear
		keep if ep_adm_d<mdy(2,1,2011) // just jan 2011
		cap rename pat_funding_type pat_fund
		cap rename pat_product pat_prod
		cap rename pat_mkt_sgmnt pat_mkt
		cap gen pat_mkt=1 // inpatient stuff is missing this
		keep if adj_price<.
		
		cap drop _merge
		qui gen merge_fips = prov_fips
		cap gen merge_year=2011
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_bcbs.dta, keep(3) nogen
		gen high = hli_bcbsms>${medbcbs}
		if "`side'"=="high" keep if high
		if "`side'"=="low" drop if high
		
		preserve
			collapse (mean) price, by(prov_hrrnum) fast
			collapse (mean) mean=price (sd) sd=price, fast
			gen cov=sd/mean
			rename cov cov_acrosshrr
			gen proc="`proc'"
			tempfile acrosshrr
			save `acrosshrr'
		restore
		preserve
			collapse (mean) price (first) prov_hrrnum, by(prov_e_npi) fast
			collapse (mean) mean=price (sd) sd=price, by(prov_hrrnum) fast
			gen cov=sd/mean
			collapse (mean) cov, fast
			rename cov cov_withinhrr
			gen proc="`proc'"
			tempfile withinhrr
			save `withinhrr'
		restore
		collapse (mean) mean=price (sd) sd=price, by(prov_e_npi) fast
		gen cov=sd/mean
		collapse (mean) cov, fast
		rename cov cov_withinhosp
		gen proc="`proc'"
		merge 1:1 proc using `acrosshrr', assert(3) nogen
		merge 1:1 proc using `withinhrr', assert(3) nogen
		keep proc cov* 
		
		gen sort =`c'
		if `c'>1 append using `build'
		save `build', replace
	}
	sort sort
	outsheet using HC_rev_varsummary_`side'bcbs.csv, comma replace
	}
	

/*
-------------------------------------------

Main regs with BCBS

-------------------------------------------
*/

	use ${ddHC}/HC_ext_hli_bcbs.dta, clear
	qui summ hli_bcbsms, d
	loc med = r(p50)


	foreach side in all high low {

	loc proc ip
	loc lhs price
	// Remember to loop over procs and prices/charges

	use ${ddHC}/HC_hdata_`proc'.dta, clear
	makex, hccishare
	foreach v of varlist x_* {
		drop if `v'==.
	}
	drop if merge_year==2007
	keep if adj_price<.
	
	cap drop merge_fips
	cap drop merge_year
	qui gen merge_year = 2011
	qui gen merge_fips = prov_fips
	merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_bcbs.dta, keep(3) nogen
	gen high = hli_bcbsms>`med'
	if "`side'"=="high" keep if high
	if "`side'"=="low" drop if high
	
	pfixdrop yeardum_
	pfixdrop dhrr_	
	qui tab prov_hrrnum, gen(dhrr_)
	qui tab ep_adm_y, gen(yeardum_)

	cap drop prov_fe
	qui egen prov_fe = group(prov_e_npi)

	// We only use risk adjusted prices
	cap drop logprice
	qui gen logprice = log(1+adj_price)
	eststo clear
	
	loc x ""
	if "`side'"=="all" loc x "bcbs"
	makex, log hccishare `x'
	drop x_inssh

	eststo: reghdfe logprice x_* 				, absorb(ep_adm_y) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "No"
	estadd local Hosp_FE "No"
	eststo: reghdfe logprice x_* 				, absorb(ep_adm_y prov_hrrnum) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "Yes"
	estadd local Hosp_FE "No"

	makex, log hccishare `x'
	eststo: reghdfe logprice x_* 				, absorb(ep_adm_y) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "No"
	estadd local Hosp_FE "No"
	
	makex, log hccishare `x'
	eststo: reghdfe logprice x_* 				, absorb(ep_adm_y prov_hrrnum) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "Yes"
	estadd local Hosp_FE "No"
	
	
	esttab * using HC_rev_crosssec_price_bcbs`side'.csv, replace /* nopa */ se r2 obslast ///
		scalar(Year_FE HRR_FE Hosp_FE) star(* 0.10 ** 0.05 *** 0.01) b(%12.3f) se(%12.3f)	
}
	





/*
-------------------------------------------

Share of charge regs BCBS
- We don't need the HHI version

-------------------------------------------
*/



	use ${ddHC}/HC_ext_hli_bcbs.dta, clear
	qui summ hli_bcbsms, d
	loc med = r(p50)

	foreach side in all high low {
	foreach r in norestrict {

	eststo clear
	* foreach proc in ip hip knr delc delv ptca col kmri composite {
	foreach proc in ip {
		* use ${tHC}/temp_prelimpcc_`proc'.dta, clear
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
	keep if adj_price<.
	
	cap gen unc_restrict=0
	qui gen share_pcr = ptc_`r'*100
	qui gen share_unc = unc_`r'*100
	cap gen proc = "`proc'"
	cap egen proc_fe = group(proc)
	
	// BCBS restriction
		qui gen merge_fips = prov_fips
		merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_bcbs.dta, keep(3) nogen
		qui gen high = hli_bcbsms>`med'
		if "`side'"=="high" keep if high
		if "`side'"=="low" drop if high
		
		loc x ""
		if "`side'"=="all" loc x "bcbs"
		
		makex, log hccishare `x'
		eststo m`proc': reghdfe share_pcr x_*	, absorb(ep_adm_y proc_fe prov_hrrnum) vce(cluster prov_hrrnum) keepsin
		estadd local Procedure "`proc'"
	}

	esttab m* using HC_rev_crosssec_contract_`r'_bcbs`side'.csv, replace  ///
		r2  b(%4.3f) se(%4.3f) scalar(Procedure) obslast 

	}
	}




/*
-------------------------------------------

Medanchor BCBS version

-------------------------------------------
*/
	use ${ddHC}/HC_ext_hli_bcbs.dta, clear
	qui summ hli_bcbsms, d
	global bcbsmed = r(p50)

	foreach side in all high low {

	* use ${tHC}/temp_prelimpcc_ip.dta, clear
	use medanchor merge_npi merge_year c_type adj_price using ${ddHC}/HC_cdata_ip_medid.dta, clear
	keep if c_type==1
	keep if adj_price<.
	collapse medanchor, by(merge_npi merge_year) fast
	
	merge 1:1 merge_npi merge_year using ${ddHC}/HC_hdata_ip.dta, keep(3) nogen

	cap gen merge_fips = prov_fips
	merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_bcbs.dta, keep(3) nogen
	qui gen high = hli_bcbsms>${bcbsmed}
	if "`side'"=="high" keep if high
	if "`side'"=="low" drop if high

	replace medanchor = medanchor*100

	loc x ""
	if "`side'"=="all" loc x "bcbs"	
	
	cap drop prov_fe
	egen prov_fe = group(prov_e_npi)
	makex, hccishare log `x'
	eststo clear
	// MDT + other
	drop x_inssh 
	eststo: reghdfe medanchor x_*, absorb(ep_adm_y) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "No"
	estadd local Hosp_FE "No"
	// MDT + other + HRR FE
	eststo: reghdfe medanchor x_*, absorb(ep_adm_y prov_hrrnum) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "Yes"
	estadd local Hosp_FE "No"
	// MDT + insurer + other + HRR FE
	makex, hccishare log `x'
	eststo: reghdfe medanchor x_*, absorb(ep_adm_y prov_hrrnum) vce(cluster prov_hrrnum) keepsin
	estadd local Year_FE "Yes"
	estadd local HRR_FE "Yes"
	estadd local Hosp_FE "No"


	esttab * using HC_rev_crosssec_medanchor_`side'bcbs.csv, replace /* nopa */ se r2 obslast ///
		scalar(Year_FE HRR_FE Hosp_FE) star(* 0.10 ** 0.05 *** 0.01) b(%12.3f) se(%12.3f)


	}
*/

/*
-------------------------------------------

Merger results BCBS

-------------------------------------------
*/

	
	foreach side in high low {
	loc proc ip

	* foreach proc of global proclist {
	foreach proc in ip {
	eststo clear
	foreach d in 5 10 15 20 25 30 50 {
	use ${ddHC}/HC_hdata_`proc'.dta, clear
	merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha_mergerroster.dta, nogen keepusing(close`d' neigh*)
	merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha.dta, nogen update

	cap drop temp_price
	qbys merge_npi: ipolate adj_price merge_year, gen(temp_price)
	qui replace adj_price = temp_price if adj_price==.
	
	egen hfe = group(prov_e_npi)
	cap gen logprice = log(1+adj_price)
	egen sfe = group(aha_msysid)
	
	
// Toggle this to count/not count mergers before 2007 toward t
	keep if inrange(merge_year,2007,2011)
	
	gen merge_fips = prov_fips
	merge m:1 merge_fips merge_year using ${ddHC}/HC_ext_hli_bcbs.dta, keep(3) nogen
	gen high = hli_bcbsms>${bcbsmed}
	* if `d'==15 STOP
	if "`side'"=="high" keep if high
	else drop if high
	
	
	
// Define treatment variables
	cap drop treat
	bys merge_npi (merge_year): gen treat=close`d'==1
	bys merge_npi (merge_year): replace treat = treat[_n-1]==1 if treat[_n-1]==1
	qui egen evertreat = max(treat), by(merge_npi)
	
	cap drop treat_tp2
	bys merge_npi (merge_year): gen treat_tp2=close`d'[_n+2]==1
	bys merge_npi (merge_year): replace treat_tp2 = treat_tp2[_n-1] if treat_tp2[_n-1]==1
	
// Neighbors
	cap drop neighbor
	gen neighbor = neigh`d'==1
	bys merge_npi (merge_year): replace neighbor = neighbor[_n-1]==1 if neighbor[_n-1]==1

	
// Calculate time since merger:
	cap gen year = merge_year
	gen temp_year = year if treat==1
	egen minyear = min(temp_year), by(merge_npi)
	gen t = year - minyear if evertreat==1
	replace t=0 if evertreat==0
	
	if "`tcap'"=="capneg1" {
		qui replace t = min(t,2) if t<.
		qui replace t = max(t,-1) if t<.
	}
	if "`tcap'"=="capneg2" {
		qui replace t = min(t,2) if t<.
		qui replace t = max(t,-2) if t<.
	}
	if "`tcap'"=="nocap" {
		qui replace t = min(t,3) if t<.
		qui replace t = max(t,-4) if t<.
	}
	if "`tcap'"=="with_tp4" {
		qui replace t = min(t,4) if t<.
		qui replace t = max(t,-4) if t<.
	}
	
	qui summ t
	forval i=`=r(min)+1'/`r(max)' {
		if `i'<0 loc tlab "neg`=abs(`i')'" 
		else loc tlab "`i'"
		cap drop t_`tlab'
		gen t_`tlab' = evertreat==1&t==`i'
		
	}
	
	
// Calculate time since neighbor
	cap drop everneighbor
	qui egen everneighbor = max(neighbor), by(merge_npi)
	cap drop temp_year
	qui gen temp_year = year if neighbor==1
	cap drop minyear
	qui egen minyear = min(temp_year), by(merge_npi)
	qui gen nt = year - minyear if everneighbor==1
	qui replace nt=0 if everneighbor==0
	if "`tcap'"=="capneg1" {
		qui replace nt = min(nt,2) if nt<.
		qui replace nt = max(nt,-1) if nt<.
	}
	if "`tcap'"=="capneg2" {
		qui replace nt = min(nt,2) if nt<.
		qui replace nt = max(nt,-2) if nt<.
	}
	if "`tcap'"=="nocap" {
		qui replace nt = min(nt,3) if nt<.
		qui replace nt = max(nt,-4) if nt<.
	}
	if "`tcap'"=="with_tp4" {
		qui replace nt = min(nt,4) if nt<.
		qui replace nt = max(nt,-4) if nt<.
	}
	qui summ nt
	forval i=`=r(min)+1'/`r(max)' {
		* if `i'==-1 continue
		if `i'<0 loc tlab "neg`=abs(`i')'" 
		else loc tlab "`i'"
		cap drop nt_`tlab'
		gen nt_`tlab' = everneighbor==1&nt==`i'
		
	}
	
	
// Code up the covariates and clean out years without price observations
	makex, hccishare log
	foreach v of varlist x_* {
		drop if missing(`v')
	}
	drop x_mdt*
	keep if inrange(year,2007,2011)&adj_price<.
	
// Clean out the bail-out mergers using capacity in the pre-merger period

	cap drop capacity
	gen capacity = mci_adc/mci_beds
	qui summ capacity, d
	cap drop temp_drop1
	cap drop temp_drop2
	gen temp_drop1 = capacity<r(p1)
	egen temp_drop2 = max(temp_drop1), by(merge_npi)
	drop if temp_drop2==1

	if "`sample'"=="without2007" drop if merge_year==2007 
		// want to do this after the weight construction!
	qui summ t
	loc tmin = abs(r(min))
	cap drop t_neg`tmin'
	qui summ nt
	loc tmin = abs(r(min))
	cap drop nt_neg`tmin'
		
		
	foreach weight in none {	
		cap drop pwgt
		if "`weight'"=="none" gen pwgt = 1
		else gen pwgt = mw_`weight'


	// Stanard spec
		eststo std_`weight'_`d': reghdfe logprice treat x_* [aw=pwgt], absorb(hfe year) vce(cluster hfe sfe) keepsin
		estadd local Distance `d'
		estadd local Controls "Yes"

		eststo stdnocon_`weight'_`d': reghdfe logprice treat [aw=pwgt], absorb(hfe year) vce(cluster hfe sfe) keepsin
		estadd local Distance `d'
		estadd local Controls "No"

		
		
	}
	}

	foreach weight in none    {
	foreach t in    std stdnocon {
			esttab `t'_`weight'_* using HC_bcbs`side'_`sample'_`tcap'_`t'_`weight'.csv, ///
				replace keep(treat*) star(* .1 ** .05 *** .01)  ///
				b(%4.3f) se(%4.3f) scalar(Controls Distance N_clust1 N_clust2) lab
	}
	}


	}
	}



exit

