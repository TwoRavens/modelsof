/*-----------------------------------------------------------------------HC_cdata.do
Generates preliminary contracts for the relevantly available date ranges. 

Stuart Craig
Last updated	20180816
*/

	foreach proc of global proclist {
	cap confirm file ${ddHC}/HC_cdata_`proc'_i.dta
	if _rc!=0 {
		use ${ddHC}/HC_epdata_`proc'.dta, clear
		
		// MRIs don't rely on charges so can be sent back to 2008
		// Everything else is subject to the charge reporting problem
		// until 2010
		if "`proc'"=="kmri" keep if inrange(ep_adm_y,2008,2011)
		else keep if inlist(ep_adm_y,2010,2011)

		
		// Clean charges and prices (round to nearest 1 cent?)
		cap drop temp_price
		qui gen temp_price = round(ep_fac_allwd,0.01)
		cap drop temp_charge
		qui gen temp_charge = round(ep_fac_submt,0.01)
		// We want to accomodate out of range charges for MRIs since we know 
		// most is fixed price anyway (or can't distinguish). Irrelevant for 
		// analysis since we don't look for contract differentiation, but 
		// important to keep these classified for the price series figures
		if "`proc'"!="kmri" {
			foreach v of varlist temp_charge   {
				drop if `v'<=0
				cap drop p1
				cap drop p99
				qui egen p1 = pctile(`v'), by(ep_adm_y ep_drg) p(1)
				qui egen p99 =pctile(`v'), by(ep_adm_y ep_drg) p(99)
				drop if !inrange(`v',p1,p99)
			}
			drop p1 p99
		}
		// Hospital ID ordered by provider volume
		cap drop h_index
		cap drop tot_vol
		bys prov_e_npi: gen tot_vol=-_N
		qui egen h_index=group(tot_vol prov_e_npi)

		// Calculate price/charge ratio
		cap drop prop_pc
		qui gen prop_pc = round(temp_price/temp_charge,.001) // have to round but be careful with what you do with it

		// 2 types of "contracts"
		cap drop c_pr_id
		cap drop c_pc_id
		cap drop n
		qui gen n=_n
		qui gen c_pr_id=n
		qui gen c_pc_id=n
		bys prov_e_npi ep_drg temp_price   	(n): replace c_pr_id=c_pr_id[1] if _n>1
		bys prov_e_npi ep_drg prop_pc 		(n): replace c_pc_id=c_pr_id[1] if _n>1
		foreach v of varlist c_??_id {
			bys prov_e_npi ep_drg `v': replace `v'=. if _N==1
		}

		// What kind of contract are you on?
		cap drop temp_cmin
		cap drop temp_cmax
		cap drop temp_multicharge
		qui egen temp_cmin = min(temp_charge) if c_pr_id<., by(c_pr_id)
		qui egen temp_cmax = max(temp_charge) if c_pr_id<., by(c_pr_id)
		// Some obs with the same price have different charges
		qui gen temp_multicharge = temp_cmax!=temp_cmin

		cap drop temp_prcontract
		qui gen temp_prcontract = c_pr_id<.
		cap drop temp_pccontract
		qui gen temp_pccontract = c_pc_id<.

		tab temp_prcontract temp_multicharge
		tab temp_pccontract temp_multicharge if !temp_prcontract

		cap drop c_type
		qui gen c_type=-9
		qui replace c_type=1 if temp_prcontract&temp_multicharge // repeated prices with different charges
		qui replace c_type=2 if temp_pccontract&!temp_prcontract&c_type==-9 // giving preference to the price contracts
		qui replace c_type=3 if temp_pccontract&temp_prcontract&c_type==-9
		if "`proc'"=="kmri" replace c_type=1 if c_type==3
		tab c_type

		drop temp* tot_vol n 
		
		save ${ddHC}/HC_cdata_`proc'_i.dta, replace
	}
	}

	// Create a hospital level extract
	foreach proc of global proclist {
	cap confirm file ${ddHC}/HC_cdata_`proc'_h.dta
	if _rc!=0 {
		use ${ddHC}/HC_cdata_`proc'_i.dta, clear
		
		cap drop pps_norestrict
		qui gen pps_norestrict = c_type==1
		cap drop ptc_norestrict
		qui gen ptc_norestrict = c_type==2
		cap drop unc_norestrict
		qui gen unc_norestrict = !inlist(c_type,1,2)
		foreach ctype in pps ptc {
			qui gen `ctype'_restrict = `ctype'_norestrict if inlist(c_type,1,2)
		}
		collapse (mean) *restrict, by(prov_e_npi ep_adm_y) fast
		save ${ddHC}/HC_cdata_`proc'_h.dta, replace
	}
	}
	
	// Create a Medicare identified inpatient extract
	cap confirm file ${ddHC}/HC_cdata_ip_medid.dta
	if _rc!=0  {
		use ${ddHC}/HC_cdata_ip_i.dta, clear
		bys prov_e_npi: gen negepcount = -_N
		egen hindex = group(negepcount prov_e_npi)

		// Here we quantiy the extent to which these are pegged to Medicare
		preserve
			keep if c_type==1
			gen count=1
			collapse (sum) count, by(prov_e_npi ep_drg price ep_medprice) fast
			gen ratio = round(price/ep_medprice,.01)
			summ ratio, d
			bys prov_e_npi ratio: gen N=_N
			summ N, d
			cap drop medanchor
			qui gen medanchor=N>1
			tab medanchor
			tempfile medanchor
			save `medanchor', replace
		restore

		merge m:1 prov_e_npi ep_drg price ep_medprice using `medanchor', keepusing(medanchor) keep(1 3) nogen //assert(3) nogen

		save ${ddHC}/HC_cdata_ip_medid.dta, replace
	}
exit
