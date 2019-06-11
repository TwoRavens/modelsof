/* ------------------------------------------------------HC_var_pqdecomp_counterfactuals.do

Stuart Craig
Last updated 20180816
*/

timestamp, output
cap mkdir pqdecomp
cd pqdecomp
cap mkdir counterfactuals
cd counterfactuals

/*--------------------------------------------------------------------1 Create counterfactual SPB 
																		for Medicare prices/casemix */

foreach decompyear in 2011 {	
foreach ag in tot 2 3 4 5 6 {																

	// Calculate national enrollees
	use ${ddHC}/HC_rev_pqdecomp_medbene.dta, clear
	keep if merge_year=="`decompyear'"&!inlist(merge_hrr,999)
	collapse (sum) atlas_Bh, fast
	qui summ atlas_Bh
	loc nat_enroll=r(mean)
	
	use ${ddHC}/HC_ext_ahd_nedata.dta, clear
	keep if inrange(year,2008,2011) // match years in HCCI
	if "`decompyear'"!="all" keep if year==`decompyear'
	//drgtotalpayment is price var
	
	// National price and volume for each DRG
	preserve
		collapse (sum) drgcases drgtotalpayment, by(drgnum) fast
		rename drgcases 		nat_volume
		rename drgtotalpayment	nat_spending
		qui gen nat_price = nat_spending/nat_volume
		qui gen nat_enroll = `nat_enroll'
		
		tempfile nat
		save `nat', replace
	restore
	
	
	pfixdrop merge
	cap drop _merge
	qui gen merge_zip = substr(ziphcris,1,5)
	qui gen merge_year = year
	merge m:1 merge_zip merge_year using ${ddHC}/HC_ext_atlas_zipcrosswalk.dta
	keep if _m==3
	
	collapse (sum) drgtotalpayment drgcases, by(hrrnum drgnum) fast
	
	cap drop _merge
	merge m:1 drgnum using `nat'
	drop if _m==2
	drop _merge
	
	cap drop hrr_price 
	qui gen hrr_price = drgtotalpayment/drgcases
	
	cap drop raw_spending 
	cap drop pfix_spending
	cap drop vfix_spending
	qui gen raw_spending 	= drgtotalpayment
	qui gen pfix_spending 	= drgcases*nat_price
	qui gen vfix_spending 	= hrr_price*nat_volume
	
	pfixdrop merge
	qui gen merge_year="`decompyear'" // comes from the loop!
	qui gen merge_hrr = hrrnum
	cap drop _merge
	merge m:1 merge_hrr merge_year using ${ddHC}/HC_rev_pqdecomp_medbene.dta
	drop if _m==2
	rename atlas_Bh hrr_enroll
	
	collapse (sum) *spending (mean) hrr_enroll nat_enroll, by(hrrnum) fast
	
	pfixdrop spe_
	qui gen spe_raw = raw_spending/hrr_enroll
	qui gen spe_pfix = pfix_spending/hrr_enroll
	qui gen spe_vfix = vfix_spending/nat_enroll
	summ spe* 
	save ${ddHC}/HC_rev_pqdecomp_pub_`decompyear'.dta, replace
	
	keep spe* 
	
	tw 		kdensity spe_raw, lw(medthick) ///
			|| 	kdensity spe_pfix, lw(medthick) lpattern(dot) ///
			|| 	kdensity spe_vfix, lw(medthick) lpattern(dash) lcolor("${red}") ///
			xtitle("") ytitle("") legend(label(1 "Raw") label(2 "Fixed Price") label(3 "Fixed Quantity") rows(1)) ///
			/* note("Nominal spending") */ ylabel(,nolab) xlab(, format(%10.0fc))
		graph export HC_rev_pqdecomp_pub_`decompyear'.png, as(png) replace
		graph export HC_rev_pqdecomp_pub_`decompyear'.eps, as(eps) replace
		
	// Create the tables
	foreach spendingmeasure of varlist spe* {
		loc prefix = subinstr("`spendingmeasure'","spe_","",.)
		
		foreach stat in p10 p25 p50 p75 p90 mean sd {
			cap drop `prefix'_`stat'
			qui gen `prefix'_`stat' = `spendingmeasure'
		}
		cap drop `prefix'_N
		qui gen `prefix'_N=1
		
		cap drop `prefix'_gini
		qui egen `prefix'_gini = gini(`spendingmeasure')
	}
	
	collapse (p10) *p10 (p25) *p25 (p50) *p50 (p75) *p75 (p90) *p90 (mean) *mean *gini (sd) *sd (sum) *N
		
		foreach s in raw pfix vfix {
			cap drop `s'_cov
			qui gen `s'_cov = `s'_sd/`s'_mean
		}
		
		qui gen i=.
		reshape long raw pfix vfix, i(i) j(stat) string
		
		qui replace stat = subinstr(stat,"_","",.)
		qui replace i = 1 	if stat=="mean"
		qui replace i = 2 	if stat=="sd"
		qui replace i = 3 	if stat=="cov"
		qui replace i = 4 	if stat=="gini"
		qui replace i = 5 	if stat=="p10"
		qui replace i = 6 	if stat=="p25"
		qui replace i = 7 	if stat=="p50"
		qui replace i = 8 	if stat=="p75"
		qui replace i = 9 	if stat=="p90"
		qui replace i = 10	if stat=="N"

		sort i
		foreach v of varlist raw pfix vfix {
			rename `v' medicare_`v'
		}
		save ${tHC}/temp_medicaretable.dta, replace
	
																		
/*--------------------------------------------------------------------2 Create counterfactual SPB 
																		for HCCI prices/casemix */



																		
// First, compute the national membership and DRG specific volume and prices
																		
	// Pull national membership numbers
	use ${ddHC}/HC_raw_spbrollup_`decompyear'.dta, clear
	keep if inrange(real(pat_age),2,6)
	if "`ag'"!="tot" keep if real(pat_age)==`ag' // restrict to 55-64
	
	qui summ enroll_month
	loc nat_enroll = r(mean)*r(N)/12
	
	// National DRG-specific price and volume
	use ${ddHC}/HC_rev_pqdecomp_ip.dta, clear
	keep if inrange(year(fst_admtdt),2008,2011) // should already be done
	if "`decompyear'"!="all" keep if year(fst_admtdt)==`decompyear'
	keep if inrange(real(age_band),2,6)
	if "`ag'"!="tot" keep if real(age_band)==`ag'
	qui gen vol=1	
	collapse (mean) price (sum) vol, by(drg) fast
	rename price nat_price
	rename vol nat_vol
	qui gen nat_enroll = `nat_enroll'
	rename drg merge_drg
	tempfile nat
	save `nat', replace
	
// Second, calculate the counterfactuals	
	use ${ddHC}/HC_rev_pqdecomp_ip.dta, clear
	keep if inrange(year(fst_admtdt),2008,2011) // should already be done
	if "`decompyear'"!="all" keep if year(fst_admtdt)==`decompyear'
	keep if inrange(real(age_band),2,6) // exclude under 16s and over 64 no matter what
	if "`ag'"!="tot" keep if real(age_band)==`ag'
	
	qui gen vol=1
	* rename ep_medprice price_medicare
	collapse (mean) price (sum) vol, by(drg hrrnum)
	rename price 	hrr_price
	rename vol 		hrr_vol
	
	// Bring in the HRR membership numbers
	cap drop _merge
	
	pfixdrop merge
	qui gen merge_year 	= `decompyear'
	qui gen merge_hrr 	= hrrnum
	merge m:1 merge_hrr  merge_year  using ${ddHC}/HC_rev_pqdecomp_prvenroll.dta
	qui drop if _m==2
	drop _merge
	// Use the age group specific enrollment #
	gen enroll_h = enroll_`ag'
	
	// Bring in national price and volume
	cap drop _merge
	pfixdrop merge
	qui gen merge_drg = drg
	merge m:1 merge_drg using `nat'
	drop if _m==2
	
	cap drop raw_spending
	cap drop pfix_spending
	cap drop vfix_spending
	cap drop med_spending
	qui gen raw_spending 	= hrr_vol	*	hrr_price
	qui gen pfix_spending 	= hrr_vol	*	nat_price
	qui gen vfix_spending	= nat_vol	*	hrr_price
	* qui gen med_spending	= hrr_vol	*	price_medicare
	
	// Sum up spending and divide by Bh (or B)
	collapse (sum) *spending (mean) enroll_h nat_enroll, by(hrrnum) fast
	pfixdrop spe
	qui gen spe_raw 	= raw_spending/enroll_h
	qui gen spe_pfix	= pfix_spending/enroll_h
	qui gen spe_vfix	= vfix_spending/nat_enroll // here we have nat volumes, so we need to use nat enroll
	* qui gen spe_med		= med_spending/enrollee_equiv
	save ${ddHC}/HC_rev_pqdecomp_prv_`decompyear'_`ag'.dta, replace
	
// Third, make a density plots of the spending variation
	
	tw 		kdensity spe_raw, lw(medthick) ///
		|| 	kdensity spe_pfix, lw(medthick) lpattern(dot) ///
		|| 	kdensity spe_vfix, lw(medthick) lpattern(dash) lcolor("${red}") /// 
		/* || 	kdensity spe_med, lw(medthick) lpattern(shortdash_dot) lcolor("${red}") */ ///
		xtitle("") ytitle("") legend(label(1 "Raw") label(2 "Fixed Price") label(3 "Fixed Quantity") rows(1)) ///
		/* note("Nominal spending") */ ylabel(, nolab) xlab(, format(%10.0fc))
	graph export HC_rev_pqdecomp_prv_`decompyear'_`ag'.png, as(png) replace
	graph export HC_rev_pqdecomp_prv_`decompyear'_`ag'.eps, as(eps) replace
	
	
// Fourth, collapse down to tables	
	keep spe*
	foreach spendingmeasure of varlist spe* {
		loc prefix = subinstr("`spendingmeasure'","spe_","",.)
		
		foreach stat in p10 p25 p50 p75 p90 mean sd {
			cap drop `prefix'_`stat'
			qui gen `prefix'_`stat' = `spendingmeasure'
		}
		cap drop `prefix'_N
		qui gen `prefix'_N=1
		
		cap drop `prefix'_gini
		qui egen `prefix'_gini = gini(`spendingmeasure')
	}		
	collapse (p10) *p10 (p25) *p25 (p50) *p50 (p75) *p75 (p90) *p90 (mean) *mean *gini (sd) *sd (sum) *N
	
	foreach s in raw pfix vfix  {
		cap drop `s'_cov
		qui gen `s'_cov = `s'_sd/`s'_mean
	}
	
	qui gen i=.
	reshape long raw pfix vfix , i(i) j(stat) string
	
	qui replace stat = subinstr(stat,"_","",.)
	qui replace i = 1 	if stat=="mean"
	qui replace i = 2 	if stat=="sd"
	qui replace i = 3 	if stat=="cov"
	qui replace i = 4 	if stat=="gini"
	qui replace i = 5 	if stat=="p10"
	qui replace i = 6 	if stat=="p25"
	qui replace i = 7 	if stat=="p50"
	qui replace i = 8 	if stat=="p75"
	qui replace i = 9 	if stat=="p90"
	qui replace i = 10 	if stat=="N"
	
	merge 1:1 i stat using ${tHC}/temp_medicaretable.dta
	drop if _m==2
	drop _merge
	
	outsheet i stat raw pfix vfix medicare* ///
		using HC_rev_pqdecomp_`decompyear'_`ag'.csv, comma replace
		
	

// Correlate the counterfactual measures
	use ${ddHC}/HC_rev_pqdecomp_prv_`decompyear'_`ag'.dta, clear
	rename hrrnum merge_hrr 
	foreach v of varlist spe_* {
		rename `v' prv_`v'
	}
	keep prv* merge_hrr
	tempfile prv
	save `prv', replace
	
	// Medicare numbers aren't age specific
	use ${ddHC}/HC_rev_pqdecomp_pub_`decompyear'.dta, clear
	rename hrrnum merge_hrr
	foreach v of varlist spe_* {
		rename `v' pub_`v'
	}
	keep pub* merge_hrr
	merge 1:1 merge_hrr using `prv'
	drop _merge
	
	cap log close
	log using HC_var_pqdecomp_counterfactuals_corr_`decompyear'_`ag'.txt, text replace
	corr *spe*
	log close
	
}
}
exit
