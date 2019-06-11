/*-------------------------------------------------------HC_rev_merger_dstatmeans.do

Stuart Craig
Last updated	20180814
*/

timestamp, output
cap mkdir merger
cd merger

loc sample "without2007"
loc tcap "capneg2"
loc proc ip

foreach d in 5 15  {
foreach r in static diff {
	use ${ddHC}/HC_hdata_`proc'.dta, clear
	qui merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha_mergerroster.dta, nogen keepusing(close5 close15 macq )
	qui merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha.dta, nogen update

	cap drop temp_price
	qbys merge_npi: ipolate adj_price merge_year, gen(temp_price)
	qui replace adj_price = temp_price if adj_price==.
	qui egen m_sysany = max(macq), by(aha_msysid merge_year)
	egen hfe = group(prov_e_npi)
	cap gen logprice = log(1+adj_price)

	// Toggle this to count/not count mergers before 2007 toward t
	keep if inrange(merge_year,2007,2011)

// Define treatment variables
	cap drop treat
	if "`d'"=="any" qui gen treat = m_sysany
	else qui gen treat=close`d'==1
	bys merge_npi (merge_year): replace treat = treat[_n-1]==1 if treat[_n-1]==1
	qui egen evertreat = max(treat), by(merge_npi)
	
	cap drop minyear_merger
	cap drop temp_myear
	qui gen temp_myear = merge_year if treat==1
	qui egen minyear_merger = min(temp_myear), by(merge_npi)
	
// Code up the covariates and clean out years without price observations
	makex, hccishare log
	foreach v of varlist x_* {
		drop if missing(`v')
	}
	cap gen year = merge_year
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
	
	*if "`sample'"=="without2007" drop if merge_year==2007 
	
	// Which data supports the treatment effect?
	cap drop temp_support
	cap drop temp_mintreat
	cap drop temp_maxtreat
	qui egen temp_mintreat = min(treat), by(merge_npi)
	qui egen temp_maxtreat = max(treat), by(merge_npi)
	qui gen temp_support = temp_mintreat==0&temp_maxtreat==1
	
// Bring in the quality scores	
	merge 1:1 merge_npi merge_year using ${ddHC}/HC_ext_mhc.dta, ///
	nogen keepusing(mhc_amim10 mhc_amim01 mhc_surgm08 mhc_surgm38)
	// Impute the average for missings
	foreach v of varlist mhc* {
		qui summ `v', mean
		qui replace `v' = r(mean) if `v'==.
	}
	
	
	makex
	// Make comp measures distance specific
	if "`d'"=="any" {
		qui replace x_mdt_1 = hcount50==1
		qui replace x_mdt_2 = hcount50==2
		qui replace x_mdt_3 = hcount50==3
		qui gen x_hosphhi = syshhi_50m
	}
	else {
		qui replace x_mdt_1 = hcount`d'==1
		qui replace x_mdt_2 = hcount`d'==2
		qui replace x_mdt_3 = hcount`d'==3
		qui gen x_hosphhi = syshhi_`d'm
	}
	// Add price vars
	qui gen x_price = adj_price
	qui gen x_logprice = logprice
	
	// Add in the quality measures:
	pfixdrop x_qual
	qui gen x_qual1=mhc_amim10 
	qui gen x_qual2=mhc_surgm08
	qui gen x_qual3=mhc_surgm38
	qui gen x_qual4=(1 - mhc_amim01/100)*100
	
	if "`r'"=="diff" {
		tsset hfe year
		foreach v of varlist x_* {
			cap drop temp
			qui gen temp = d1.`v'
			qui replace `v' = temp
		}
	}
	if "`sample'"=="without2007" drop if merge_year==2007 
	foreach v of varlist x_* {
		drop if `v'==.
	}
	
	// TOGGLE
	drop if treat==1
	tempfile build
	loc sctr=0
	foreach samp in all evertreat control evertreattest {
		loc ++sctr
		preserve
			// Control vs. treatment
			if "`samp'"=="evertreat" keep if evertreat==1
			if "`samp'"=="control" keep if evertreat==0
			if "`samp'"=="evertreattest" {
				foreach v of varlist x_* {
					* reg `v' evertreat, cluster(hfe)
					reghdfe `v' evertreat, absorb(ep_adm_y) vce(cluster hfe)
					qui replace `v' =  _b[evertreat]/_se[evertreat]
				}
			}
			gen N=1
			unique prov_e_npi
			gen N_h=r(sum)
			
			collapse (mean) x_* (sum) N (first) N_h, fast
			if strpos("`samp'","test")==0 {
				foreach v of varlist x_mdt* x_usnews x_teach x_gov x_nonprofit {
					qui replace `v' = `v'*100
				}
			}
			rename N x_N
			rename N_h x_N_h
			loc ctr=0
			foreach v of varlist x_* {
				loc ++ctr
				loc stub = subinstr("`v'","x_","",.)
				/*
				qui gen x_`ctr'`stub' = string(`v')
				drop `v'
				*/
				rename `v' x_`ctr'`stub'
			}
			* gen x_sample = "`sctr'`samp'"
			gen i=1
			reshape long x_, i(i) j(var) s
			* list
			rename x_ x_`samp'
			if `sctr'>1 merge 1:1 var using `build', assert(3) nogen
			save `build', replace
		restore
	}
	use `build', clear
	
	cap drop stars
	qui gen stars =""
	qui replace stars = stars + "*" if abs(x_evertreattest)>1.64
	qui replace stars = stars + "*" if abs(x_evertreattest)>1.96
	qui replace stars = stars + "*" if abs(x_evertreattest)>2.58
	
	// Get the columns in the right order!
	qui ds x_*
	revlist "`r(varlist)'"
	di "`r(rev)'"
	order var `r(rev)'
	
	outsheet using HC_rev_merger_dstatmeans_`d'_`r'.csv, comma replace
}
}	
	

exit


