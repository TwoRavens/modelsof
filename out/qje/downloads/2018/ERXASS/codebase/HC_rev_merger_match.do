/*---------------------------------------------------------------HC_rev_merger_match.do

Stuart Craig
Last updated	20180816
*/

timestamp, output
cap mkdir merger
cd merger
cap mkdir match
cd match


// Can change the number of neighbors and everything looks good
loc n=10
loc sample "without2007"
loc tcap "capneg2" // irrelevant without ES specification
loc proc ip 


eststo clear
foreach d in  5 10 15 20 25 30 50 {
	use ${ddHC}/HC_hdata_`proc'.dta, clear
	merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha_mergerroster.dta, nogen keepusing(close`d' neigh*)
	merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha.dta, nogen update

	// Interpolate missing prices (no extrapolation)
	cap drop temp_price
	qbys merge_npi: ipolate adj_price merge_year, gen(temp_price)
	qui replace adj_price = temp_price if adj_price==.
	
	egen sfe = group(aha_msysid)
	egen hfe = group(prov_e_npi)
	cap gen logprice = log(1+adj_price)
	
// Toggle this to count/not count mergers before 2007 toward t
	keep if inrange(merge_year,2007,2011)
	

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
	keep if inrange(year,2007,2011)&adj_price<.
	
// Matching

	pfixdrop mw_
	loc neighbs=`n'
	tempfile mw
	loc ctr=0
	forval y=2007/2010 {
	preserve
		keep if year==`y'&(t==-1|evertreat==0)
		qui count
		if r(N)==0 {
			restore
			continue
		}
		loc matchcontrols "x_*"
	
		// Manahanobis dist
		psmatch2 evertreat, neighbor(`neighbs') mahal(`matchcontrols')
		rename _weight mw_mahal
	
		// Within-state Mahal. dist
		cap drop mw_stmahal
		qui gen mw_stmahal=.
		qui levelsof prov_hsastate, local(states)
		foreach state of local states {
			cap psmatch2 evertreat if prov_hsastate=="`state'", neighbor(`neighbs') mahal(`matchcontrols')
			if _rc!=0 continue
			qui replace mw_stmahal=_weight if prov_hsastate=="`state'"
		}
		
		// KNN off the probit
		psmatch2 evertreat `matchcontrols', n(`neighbs')
		rename _weight mw_knn
		
		// Linderooth/Dranove weights
		gen urban = mci_urgeo=="LURBAN"
		qui gen xdl_output=aha_admtot
		qui gen xdl_input1=aha_fte
		qui gen xdl_input2=aha_techtot
		foreach j1 in output  input1 input2 {
			foreach j2 in output  input1  input2 {
				gen xdl_`j1'X`j2' = xdl_`j1'*xdl_`j2'
			}
		}
		psmatch2 evertreat x_medshare x_caidshare urban hcount15 x_nonprofit x_beds xdl_*, n(`neighbs')
		rename _weight mw_dl
		
		loc ++ctr
		keep hfe mw_*
		di `ctr'
		if `ctr'>1 append using `mw'
		collapse (sum) mw_*, by(hfe) fast
		save `mw', replace
	restore
	}
	merge m:1 hfe using `mw', nogen
	drop x_mdt*
	
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
	// want to do this after the weight construction because we need pre-merger lags!
qui summ t
loc tmin = abs(r(min))
cap drop t_neg`tmin'
		
	
foreach weight in none dl mahal stmahal knn logit {
	cap drop pwgt
	if "`weight'"=="none" gen pwgt = 1
	else gen pwgt = mw_`weight'


// Stanard spec
	eststo std_`weight'_`d': reghdfe logprice treat x_* [aw=pwgt], absorb(hfe year) vce(cluster hfe sfe) keepsin
	estadd local Distance `d'
	estadd local Controls "Yes"
	
}
}

foreach weight in none dl mahal stmahal knn  {
foreach t in    std stdnocon {
		esttab `t'_`weight'_* using HC_`sample'_`tcap'_`t'_`weight'_n`n'.csv, ///
			replace keep(treat*) star(* .1 ** .05 *** .01)  ///
			b(%4.3f) se(%4.3f) scalar(Controls Distance N_clust1 N_clust2) lab
}
}


exit


