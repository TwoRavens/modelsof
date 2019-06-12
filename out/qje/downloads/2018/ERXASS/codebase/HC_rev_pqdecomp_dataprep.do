/* -------------------------------------------------------------HC_rev_pqdecomp_dataprep.do

Stuart Craig
Last updated 20180816
*/


/*
----------------------------------------------------

Create the pooled dataset of ben/enrollment counts																	

----------------------------------------------------
*/ 
	// Medicare
	cap confirm file ${ddHC}/HC_rev_pqdecomp_medbene.dta
	if _rc!=0 {																		
		use ${ddHC}/HC_ext_atlas_reimb.dta, clear
		keep if inrange(merge_year,2008,2011)|merge_year==. // includes missing for "all"
		collapse (sum) atlas_Bh, by(merge_hrr) fast
		qui gen year = "all"
		append using ${ddHC}/HC_ext_atlas_reimb.dta
		qui replace year = string(merge_year) if year==""
		keep if inrange(merge_year,2008,2011)|merge_year==. // includes missing for "all"
		drop merge_year
		rename year merge_year
		keep merge* atlas_Bh
		save ${ddHC}/HC_rev_pqdecomp_medbene.dta, replace
	}
	// HCCI
	cap confirm file ${ddHC}/HC_rev_pqdecomp_prvenroll.dta
	if _rc!=0 {
		forval y=2007/2011 {
			use ${ddHC}/HC_raw_spbrollup_`y'.dta, clear
			drop if real(pat_age)>6|real(pat_age)==1
			gen age = real(pat_age)
			collapse (sum) enroll_=enroll_month_count, by(pat_hrrnum age) fast
			qui replace enroll_ = enroll_/12
			reshape wide enroll_, i(pat_hrrnum) j(age)
			egen enroll_tot = rowtotal(enroll_*)
			
			rename pat_hrrnum merge_hrr
			qui gen merge_year=`y'
			keep merge* enroll_*
			if `y'>2007 append using ${ddHC}/HC_rev_pqdecomp_prvenroll.dta
			save ${ddHC}/HC_rev_pqdecomp_prvenroll.dta, replace
		}
	}

/*				
----------------------------------------------------

Next, clean the inpatient file for decomposition
(no trims, just minimal cleans to get the HRR
and drgs right)

----------------------------------------------------
*/
	cap confirm file ${ddHC}/HC_rev_pqdecomp_ip.dta
	if _rc!=0 {
	
	// Load in the raw HCCI data
		use ${rdHC}/HCCI_main/inpatient_episodes_2007_2011_fix.dta, clear
		// Drop anyone over 65
		drop if real(age_band)>6
		
	// Correct the zip code and bring in prov HRR
		cap drop _merge
		pfixdrop merge
		qui gen merge_npi = prov_e_npi
		merge m:1 merge_npi using ${ddHC}/HC_ext_mar_npixref.dta
		drop if _m==2
		drop _merge
		qui replace prov_e_npi = corr_npi if corr_npi!=""

	// Collapse to episode level (clean minimally!)
		keep if year(fst_admtdt)>2007
		drop if real(drg)>998 // includes missing

		foreach v of varlist drg prov_e_npi {
			cap drop c1
			cap drop c2
			bys patid admit_id `v': gen c1=1 if _n==1&!missing(`v') // you can have more than one value if second is missing
			qui egen c2 = count(c1), by(patid admit_id)
			drop if c2>1&c2<. // missing prov_e_npi is ok as long as we have a zip!
			// at this point it's sorted admit_id `v'
			by patid admit_id: replace `v' = `v'[_N] if missing(`v')
		}
		by patid admit_id: replace total_calc_allwd = sum(total_calc_allwd)
		by patid admit_id: replace total_calc_allwd = total_calc_allwd[_N]
		by patid admit_id: keep if _n==_N // keep the last one!
		
		keep total_calc_allwd patid fst_admtdt admit_id prov_e_npi prov_zip_code drg age_band

	// Correct the zip code using AHA when possible
		cap drop _merge
		pfixdrop merge
		qui gen merge_npi = prov_e_npi
		qui gen merge_year = year(fst_admtdt)
		merge m:1 merge* using ${ddHC}/HC_ext_aha.dta
		drop if _m==2
		drop _merge
		qui replace prov_zip_code = substr(aha_provzip,1,5) if aha_provzip!="" // never
		drop if inlist(prov_zip_code,"","00000") // we'll never find these guys
	// Bring in HRRs by zip
		cap drop _merge
		pfixdrop merge
		qui gen merge_zip = prov_zip_code
		qui gen merge_year = year(fst_admtdt)
		merge m:1 merge* using ${ddHC}/HC_ext_atlas_zipcrosswalk.dta
		drop if _m==2
		
		drop aha*
		drop if hrrnum==.

		rename total_calc_allwd price
		
		save ${ddHC}/HC_rev_pqdecomp_ip.dta, replace
	}	
exit
