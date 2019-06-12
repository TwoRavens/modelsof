/*-------------------------------------------------------------HC_rev_dfig_mapdata.do
Map spending and price data for all procs

Stuart Craig
Last updated 20180816
*/

timestamp, output
cap mkdir mapdata
cd mapdata

// Grab the HRR names from Dartmouth data
	use ${ddHC}/HC_ext_atlas_zipcrosswalk.dta, clear
	keep if merge_year==2011
	keep hrr*
	bys hrrnum: keep if _n==1
	rename hrrnum merge_hrr
	tempfile hrrnames
	save `hrrnames'

// Build a file of 2011 prices for each HRR/procedure
	tempfile build
	loc ctr=0
	revlist "${proclist}"
	foreach proc in `r(rev)' {
		loc ++ctr
		use ${ddHC}/HC_hdata_`proc'.dta, clear

		cap drop price
		cap drop medicare
		rename adj_price price
		rename prov_pps medicare
		keep if ep_adm_y==2011
		
		// Create wage adjusted prices (center at IL)
		pfixdrop merge
		qui gen merge_npi = prov_e_npi
		qui gen merge_year = ep_adm_y
		cap drop _merge
		merge m:1 merge* using ${ddHC}/HC_ext_cms_mci.dta, keepusing(mci_wage_index)
		drop if _m<3 // should already be the case
		qui summ mci_wage_index if prov_hrrstate=="IL", mean
		qui gen wageprice = price/(mci_wage_index/r(mean))
		
		// Collapse to HRR
		keep price medicare wageprice prov_hrrnum prov_e_npi 
		cap drop provs
		gen provs=1 // count the providers so we know what we can/can't release
		collapse (mean) price medicare wageprice (sum) provs, by(prov_hrrnum) fast

		rename price `proc'_price
		rename provs `proc'_provs
		rename wageprice `proc'_wageprice
		
		// Keep the PPS payments averaged for the IP sample!
		if "`proc'"=="ip" rename medicare med_price
		else drop medicare
		
		// Stack the files horizontally
		if `ctr'>1 {
			cap drop _merge
			merge 1:1 prov_hrrnum using `build'
			drop _merge
		}
		save `build', replace
	}

// Bring everything together with the spending data	
	qui gen merge_hrr = prov_hrrnum
	qui gen merge_year = 2011
	merge 1:1 merge_hrr merge_year using ${ddHC}/HC_rev_spbdata_2011.dta, nogen
	merge 1:1 merge_hrr merge_year using ${ddHC}/HC_ext_atlas_reimb.dta, nogen keep(3)
	merge 1:1 merge_hrr using `hrrnames', keep(3) nogen
	rename merge_hrr hrrnum
	keep hrr* *spb* *price* *wage* *provs* 
	order hrr* *spb* 
	
	outsheet using HC_rev_dfig_mapdata.csv, comma replace

// Create a summary table to go under the map
	keep hrrnum ip*price* *spb_ip *spb_tot
	loc cl ""
	foreach v of varlist ip* *spb_ip *spb_tot {
		loc cl "`cl' (mean) mean_`v'=`v' (sd) sd_`v'=`v' (min) min_`v'=`v' (max) max_`v'=`v'"
	}
	collapse `cl', fast
	gen i=.
	reshape long mean_ sd_ min_ max_, i(i) j(measure) s
	
	outsheet using HC_rev_dfig_maptable.csv, comma replace
	
exit
