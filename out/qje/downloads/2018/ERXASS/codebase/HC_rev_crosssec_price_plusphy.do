/*------------------------------------------------HC_rev_crosssec_price_plusphy.do

Stuart Craig
Last updated	20180816
*/

timestamp, output
cap mkdir crosssec
cd crosssec
cap mkdir price
cd price

/*
----------------------------------------------

Create a combined physician + facility
price index (original ip file did not include
physician amounts, everything else is fine)

----------------------------------------------
*/

	foreach proc in ip {
	cap confirm file ${ddHC}/HC_hdata_`proc'_phyindex.dta
	if _rc!=0 {
		
		di "==================================================="
		di " `proc'"
		di "==================================================="
		
		if "`proc'"=="ip" {
			use price charge pat_age pat_female ep_adm_y ep_adm_d prov_e_npi pat_id *drg* ///
				using ${ddHC}/HC_epdata_ip.dta, clear
				
			cap drop _merge
			cap gen prov_enpi = prov_e_npi
			merge m:1 prov_enpi pat_id ep_adm_d using ${ddHC}/../../physwap/PHY_pindex_ip.dta, ///
				keepusing(ep_phy_allwd_amt) keep(1 3) nogen
			qui replace ep_phy_allwd = 0 if ep_phy_allwd==.	
				// very small number but want to keep sample sizes the same
		}
		else use ${ddHC}/HC_epdata_`proc'.dta, clear
		
		cap drop plusphy
		qui gen plusphy = price + ep_phy_allwd
		cap drop adj_plusphy
		
		cap drop temp_hy
		qui egen temp_hy = group(ep_adm_y prov_e_npi)

		cap drop prov_vol
		qbys temp_hy: gen prov_vol = _N

		cap drop in_sample
		qui gen in_sample = prov_vol>=50
		
		xi: reghdfe price i.pat_age pat_female if in_sample, absorb(temp_hy ep_drg, savefe)
		qui summ plusphy if e(sample), mean
		qui gen adj_plusphy = r(mean) + __hdfe1__ if e(sample)

		bys prov_e_npi ep_adm_y: keep if _n==1
		keep prov_e_npi ep_adm_y adj_plusphy
		rename prov_e_npi merge_npi
		rename ep_adm_y merge_year

		save ${ddHC}/HC_hdata_`proc'_phyindex.dta, replace
	}
	}
	
/*
----------------------------------------------

Run Table IV equivalent

----------------------------------------------
*/	
	

	eststo clear
	loc pl "${proclist} composite"
	foreach proc in `pl' {
		use ${ddHC}/HC_hdata_`proc'.dta, clear
		keep if adj_price<.&merge_year>2007

		if "`proc'"=="ip" merge 1:1 merge_npi merge_year using ${ddHC}/HC_hdata_`proc'_phyindex.dta, keep(3) nogen
		assert adj_plusphy>0
		
		foreach lhs of varlist adj_plusphy {
		cap drop logprice
		gen logprice = log(1+`lhs')

		cap drop procfe
		if "`proc'"=="composite" qui egen procfe = group(proc)
		else gen procfe = 1
		
		// Main price regression
		makex, log
		drop x_inssh
		eststo r1_`proc': reghdfe logprice x_*, absorb(merge_year procfe) vce(cluster prov_hrrnum) keepsin
		makex, log
		eststo r2_`proc': reghdfe logprice x_*, absorb(merge_year procfe) vce(cluster prov_hrrnum) keepsin
		eststo r3_`proc': reghdfe logprice x_*, absorb(prov_hrrnum merge_year procfe) vce(cluster prov_hrrnum) keepsin
		estadd local proc "`proc'"
		esttab *_`proc' using HC_rev_crosssec_price_plusphy_`proc'.csv, /// 
			replace  star(* .1 ** .05 *** .01)  ///
			b(%4.3f) se(%4.3f) scalar(r2) obslast lab		
		}	
	}
	esttab r3_* using HC_rev_crosssec_price_plusphy_allproc.csv, /// 
			replace  star(* .1 ** .05 *** .01)  ///
			b(%4.3f) se(%4.3f) scalar(r2 proc) obslast lab		


exit

