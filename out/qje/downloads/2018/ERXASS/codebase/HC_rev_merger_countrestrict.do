/*---------------------------------------------------------------HC_rev_merger_countrestrict.do

Stuart Craig
Last updated	20180816
*/

timestamp, output
cap mkdir merger
cd merger
cap mkdir countrestrict
cd countrestrict

// Can do any 10 count interval between 0 and 100 and they all look good
foreach restrict in 40 10 {
foreach sample in  without2007   {
foreach tcap in  capneg2  {

cap postclose ES
postfile ES str8  t b se d str20 weight str10 flex using HC_count`restrict'_`sample'_`tcap'_ES.dta, replace

foreach proc in ip {
eststo clear
foreach d in  5 10 15 20 25 30 50 {
use ${ddHC}/HC_hdata_`proc'.dta, clear
merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha_mergerroster.dta, nogen keepusing(close`d' neigh*)
merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha.dta, nogen update
merge 1:1 merge_year merge_npi using ${ddHC}/HC_hdata_countrestrict.dta, nogen

// Interpolate missing prices (no extrapolation)
	cap drop temp_price
	qbys merge_npi: ipolate adj_price merge_year, gen(temp_price)
	qui replace adj_price = temp_price if adj_price==.

	egen sfe = group(aha_msysid)
	egen hfe = group(prov_e_npi)
	*cap gen logprice = log(1+adj_price)
	cap drop logprice
	qui gen logprice = log(1 + adj_price_r`restrict')

// Toggle this to count/not count mergers before 2007 toward t
	keep if inrange(merge_year,2007,2011)


// Define treatment variables
	cap drop treat
	bys merge_npi (merge_year): gen treat=close`d'==1
	bys merge_npi (merge_year): replace treat = treat[_n-1]==1 if treat[_n-1]==1
	qui egen evertreat = max(treat), by(merge_npi)
	
// Calculate time since merger:
	cap gen year = merge_year
	gen temp_year = year if treat==1
	egen minyear = min(temp_year), by(merge_npi)
	gen t = year - minyear if evertreat==1
	replace t=0 if evertreat==0
	
* 	qui replace t=0 if minyear<=2007
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
		* if `i'==-1 continue
		if `i'<0 loc tlab "neg`=abs(`i')'" 
		else loc tlab "`i'"
		cap drop t_`tlab'
		gen t_`tlab' = evertreat==1&t==`i'
		
	}
	
// Code up the covariates and clean out years without price observations
	makex, hccishare log
	foreach v of varlist x_* {
		drop if missing(`v')
	}
	drop x_mdt*
	keep if inrange(year,2007,2011)&logprice<.

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

// Timing specification	
	eststo timing_`weight'_`d': reghdfe logprice t_* [aw=pwgt], absorb(hfe year) vce(cluster hfe sfe) keepsin
	foreach v of varlist t_* {
		post ES ("`v'") (_b[`v']) (_se[`v']) (`d') ("`weight'") ("flex")
	}
	qui summ t
	loc mint = abs(r(min))
	post ES ("t_neg`mint'") (0) (0) (`d') ("`weight'") ("nocontrol")
	
	
}
}

foreach weight in none    {
foreach t in    std stdnocon {
		esttab `t'_`weight'_* using HC_count`restrict'_`sample'_`tcap'_`t'_`weight'.csv, ///
			replace keep(treat*) star(* .1 ** .05 *** .01)  ///
			b(%4.3f) se(%4.3f) scalar(Controls Distance N_clust1 N_clust2) lab
}
}
foreach weight in none   {
foreach t in timing  {
		esttab `t'_`weight'_* using HC_count`restrict'_`sample'_`tcap'_`t'_`weight'.csv, ///
			replace keep(t_*) star(* .1 ** .05 *** .01)  ///
			b(%4.3f) se(%4.3f) scalar(Controls Distance N_clust1 N_clust2) lab
}
}

}
}
postclose ES
}
}
exit


