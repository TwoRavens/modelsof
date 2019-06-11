/* ------------------------------------------------------------HC_rev_pqdecomp_vardecomp.do

Stuart Craig
Last updated 20180816
*/



foreach agegroup in all over55 {
	
	timestamp, output
	cap mkdir pqdecomp
	cd pqdecomp
	cap mkdir `agegroup'
	cd `agegroup'

/*
-----------------------------------------------------

First, prepare extracts for the variance
decomp. In particular, we need HRR level
price and quantity for every DRG, for both
private and public payers

-----------------------------------------------------
*/

	loc decompyear "2011"
	cap confirm file ${tHC}/decomp2_private_`decompyear'_`agegroup'.dta
	if _rc!=0 {

		use ${ddHC}/HC_rev_pqdecomp_ip.dta, clear
		keep if inrange(year(fst_admtdt),2008,2011) // should already be done
		if "`decompyear'"!="all" keep if year(fst_admtdt)==`decompyear'
		
		// Select age group
		if "`agegroup'"=="over55" keep if real(age_band)==6 // keeping 55-64 only
		if "`agegroup'"=="all" drop if real(age_band)==1
		
		keep if price>0
		qui gen vol=1
		collapse (mean) price (sum) vol, by(drg hrrnum) fast
		rename price 	hrr_price
		rename vol 		hrr_vol
	
	// Bring in the HRR membership numbers
		loc evar "enroll_6"
		if "`agegroup'"=="all" loc evar "enroll_tot"
		cap drop _merge
		pfixdrop merge
		qui gen merge_hrr 	= hrrnum
		qui gen merge_year = `decompyear'
		merge m:1 merge_hrr merge_year using ${ddHC}/HC_rev_pqdecomp_prvenroll.dta, ///
			keepusing(`evar')
		qui drop if _m==2
		drop _merge

		gen double vol = hrr_vol/`evar'
		gen double price = hrr_price
		gen double totspend = hrr_vol*hrr_price
		
		drop hrr_*
		reshape wide price vol totspend, i(hrrnum) j(drg) s
		
		save ${tHC}/decomp2_private_`decompyear'_`agegroup'.dta, replace
	}

	cap confirm file ${tHC}/decomp2_public_`decompyear'_`agegroup'.dta
	if _rc!=0 {
		
		use ${ddHC}/HC_ext_ahd_nedata.dta, clear
		keep if inrange(year,2008,2011) // match years in HCCI
		if "`decompyear'"!="all" keep if year==`decompyear'
		
		// Bring in HRRs
		pfixdrop merge
		cap drop _merge
		qui gen merge_zip = substr(ziphcris,1,5)
		qui gen merge_year = year
		merge m:1 merge_zip merge_year using ${ddHC}/HC_ext_atlas_zipcrosswalk.dta
		keep if _m==3
		
		collapse (sum) drgtotalpayment drgcases, by(hrrnum drgnum) fast
		// Make this file like the private one
		gen hrr_price = drgtotalpayment/drgcases
		gen hrr_vol = drgcases
		drop drgtotalpayment drgcases
		gen drg = string(drgnum)
		qui replace drg = "0" + drg if length(drg)<3 // 2x?
		drop drgnumber
		
		// Bring in enrollee/beneficiary numbers
		pfixdrop merge
		qui gen merge_hrr = hrrnum
		qui gen merge_year = "`decompyear'"
		cap drop _merge
		merge m:1 merge_hrr merge_year using ${ddHC}/HC_rev_pqdecomp_medbene.dta
		drop if _m==2
		drop _merge
		rename atlas_Bh enrollee
		
		// Calculate key vars and reshape 
		gen double vol = hrr_vol/enrollee
		gen double price = hrr_price
		gen double totspend = hrr_vol*hrr_price
		
		drop hrr_* 
		reshape wide price vol totspend, i(hrrnum) j(drg) s
		
		save ${tHC}/decomp2_public_`decompyear'_`agegroup'.dta, replace
	}


/*
-----------------------------------------------------

Run the full decomposition--one public one private

-----------------------------------------------------
*/
	loc decompyear "2011"
	foreach t in private public {
		clear all
		set maxvar 10000
		use ${tHC}/decomp2_`t'_`decompyear'_`agegroup'.dta, clear

		cap drop v_spending
		qui gen v_spending=0
		foreach pricevar of varlist price* {
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
		outsheet using HC_rev_pqdecomp_`decompyear'_drglevel_`t'.csv, comma replace
		save ${tHC}/HC_rev_pqdecomp_`decompyear'_drglevel_`t'.dta, replace

	}
	


/*
--------------------------------------------

Create a big table: 
Get 25 biggest DRG's, present averages 
across DRGs

--------------------------------------------
*/
	loc decompyear=2011
	use ${tHC}/HC_rev_pqdecomp_`decompyear'_drglevel_private.dta, clear
	gen private=1
	append using ${tHC}/HC_rev_pqdecomp_`decompyear'_drglevel_public.dta
	replace private=0 if private==.
	bys drg: gen N=_N
	tab N
	drop if N==1
	bys private (totspend): gen rank = _N+1-_n
	egen averagerank = mean(rank), by(drg)


	// Merge on the DRG descriptions
	cap gen merge_msdrg=drg
	merge m:1 merge_msdrg using ${ddHC}/HC_ext_cms_drgcrosswalk.dta, keepusing(msdrg_description) 
	drop if _m==2
	drop _merge

	sort averagerank drg private
	list drg msdrg_description share* v_pq count private totspend in 1/100

	// Drop the psych stuff
	drop if inrange(real(drg),876,897)

// Medciare and private spending weight (average)
	gen simple=1
	foreach v of varlist totspend* {
		preserve
			collapse (mean) share* [aw=`v'], by(private) fast
			qui gen msdrg_description = "Average Shares"
			tempfile agg
			save `agg', replace
		restore
		preserve
			keep in 1/20 // top 10
			append using `agg'
			sort private averagerank drg
			keep share* *drg* private
			reshape wide share_p share_q share_cov, i(drg) j(private)
			outsheet using HC_rev_pqdecomp_`decompyear'_aggsharetable_`v'weight.csv, comma replace
		restore
	}
// Also produce a full list for the online appendix
	preserve
		collapse (mean) share* [aw=totspend], by(private) fast
		qui gen msdrg_description0 = "Average Shares"
		tempfile agg
		save `agg', replace
	restore
	sort private averagerank drg
	keep share* *drg* private
	reshape wide share_p share_q share_cov msdrg_description, i(drg) j(private)
	append using `agg'
	outsheet using HC_rev_pqdecomp_`decompyear'_aggsharetable_all.csv, comma replace

}	
	
exit
