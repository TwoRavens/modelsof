/*---------------------------------------------------------------HC_raw_spbdata_55plus.do

Stuart Craig
Last updated 20180816
*/

	
/*
---------------------------------------------

Create risk adjusted SPB files

---------------------------------------------
*/	

forvalues y=2007/2011 {
cap confirm file ${ddHC}/HC_rev_spbdata_55plus_`y'.dta B
if _rc!=0 {
		di "=========================================================="
		di "				`y'"
		di "=========================================================="
		
	//-------------------------------- 1. Calculate private spending per beneficiary
		use ${ddHC}/HC_raw_spbrollup_`y'.dta, clear
		// Restrict to the under 65s
		drop if real(pat_age)>6
		keep if real(pat_age)==6
		
		// First calculate national enrollment (enrollee year equivalents)
		// and national spb
		qui summ enroll_month
		loc b_n = r(mean)*r(N)/12 // Bn
		foreach t in ip op phy tot {
			qui summ spending_`t'
			loc nat_spb_`t' = r(mean)*r(N)/`b_n'
		}
		
		// Next, calculate national subgroup SPB 
		collapse (sum) spending* enroll_month, by(pat_age pat_gender) fast
		qui gen b_tot = enroll_month/12
		foreach t in ip op phy tot {
			qui gen nat_sub_spb_`t' = spending_`t'/b_tot
		}
		tempfile nat
		save `nat', replace
		
		// Create expected observed SPB ratio at HRR level
		use ${ddHC}/HC_raw_spbrollup_`y'.dta, clear
		// Restrict to the under 65s
		drop if real(pat_age)>6
		keep if real(pat_age)==6
		
		collapse (sum) spending* enroll_month, by(pat_age pat_gender pat_hrrnum) fast
		qui gen b_hi = enroll_month/12 // beneficiaries for HRR h and subgroup i
		foreach t in ip op phy tot {
			qui gen o_spb_`t' = spending_`t'
		}
		
		cap drop _merge
		merge m:1 pat_age pat_gender using `nat'
		assert _merge==3
		drop _merge
		
		// Predict spending off Si and Bhi for each subgroup i
		foreach t in ip op phy tot {
			qui gen e_spb_`t' = b_hi*nat_sub_spb_`t' // predict spending off Bhi and Si
		}
		// Sum up and divide by beneficiaries
		collapse (sum) e_spb* o_spb* b_hi, by(pat_hrr) fast
		foreach v of varlist e_spb* o_spb* {
			qui replace `v' = `v'/b_hi
		}
		
		// Adjusted SPB is (observed/expected)*average
		foreach t in ip op phy tot {
			qui gen adj_`t' = (o_spb_`t'/e_spb_`t')*`nat_spb_`t''
		}
		
	//-------------------------------- 2. Bring in the ATLAS data on Medicare SPB

		cap drop _merge
		pfixdrop merge
		qui gen merge_year = `y' // the spending file does not carry around the year, so we pull it from the loop 
		qui gen merge_hrr = pat_hrrnum
		merge 1:1 merge_year merge_hrr using ${ddHC}/HC_ext_atlas_reimb.dta
		drop if _m<3
		drop _merge
		
		
		foreach t in ip op phy tot {
			rename atlas_spb_`t' medc_spb_`t'
			rename adj_`t' 		 priv_spb_`t'
		}
		keep merge_hrr merge_year medc_spb* priv_spb* 
		save ${ddHC}/HC_rev_spbdata_55plus_`y'.dta, replace
	
}
}
exit
