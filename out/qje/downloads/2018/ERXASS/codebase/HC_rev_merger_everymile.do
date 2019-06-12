/*---------------------------------------------------------------HC_rev_merger_everymile.do

Stuart Craig
Last updated	20180816
*/

	timestamp, output
	cap mkdir merger
	cd merger

	loc sample "without2007"
	loc tcap "capneg2"
	loc proc ip

// Calculate the merger TE for every mile between 1 and 50
	tempfile results
	cap postclose results
	postfile results b se d using HC_rev_merger_everymile.dta, replace

	forval d=1/50 {
	qui {
		use ${ddHC}/HC_hdata_`proc'.dta, clear
		qui merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha_mergerroster.dta, nogen keepusing(close`d' neigh*)
		qui merge 1:1 merge_year merge_npi using ${ddHC}/HC_ext_aha.dta, nogen update

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

		if "`sample'"=="without2007" drop if merge_year==2007 
			
		reghdfe logprice treat, absorb(hfe year) vce(cluster sfe hfe) keepsin
		post results (_b[treat]) (_se[treat]) (`d')
	}
	di ., _c
	if mod(`d',20)==0 di `d'
	}
	postclose results

// Load in the data and graph
	use HC_rev_merger_everymile.dta, clear
	gen ul=b + 1.64*se
	gen ll=b - 1.64*se

	tw 	rarea ul ll d, fintensity(inten50) || ///
		line b d, lw(medthick) xtitle("Distance (Miles)") ///
		ylab(-.2(.1).3,format("%2.1f")) legend(off)  ///
		yline(0,lc(black) lw(medthick) lp(solid)) ///
		title("Post-Merger Effect on Log Prices")
	graph export HC_rev_merger_everymile.png, replace

exit


