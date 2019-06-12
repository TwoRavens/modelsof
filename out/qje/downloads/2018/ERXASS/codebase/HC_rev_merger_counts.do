/*---------------------------------------------------------HC_rev_merger_counts.do

Stuart Craig
Last updated	20180816
*/

	timestamp, output
	cap mkdir merger
	cd merger

// Count up the number of unique targets/acquirers/transactions by year
	tempfile build
	loc ctr=0
	foreach year in 2007 2008 2009 2010 2011 all {
		loc ++ctr
		use ${ddHC}/HC_ext_aha_mergers_raw.dta, clear // good count match to mergercat
		keep if inrange(year,2007,2011)

	// Separate counts for each distance
		cap drop temp_targ
		qui gen temp_targ = trans_id<.
		qui egen closeinf = max(temp_targ), by(year msysid)
		foreach d in 5 10 15 20 25 30 50 inf {
			cap drop temp_trans_count
			qui gen temp_trans_count = trans_id<. if close`d'==1
			bys trans_id: replace temp_trans_count=0 if _n>1|trans_id==.
			rename temp_trans_count trans_count_`d'
			
			cap drop temp_targ_count
			qui gen temp_targ_count = trans_id<.&close`d'==1
			rename temp_targ_count tar_count_`d'
			
			cap drop temp_acq_count
			qui gen temp_acq_count = trans_id==.&close`d'==1
			rename temp_acq_count acq_count_`d'

		}
	// Total up across years for "all" rows
		if "`year'"=="all" collapse (sum)  trans* (max) tar* acq* (first) enpi, by(id) fast
		else keep if year==`year'
		foreach vt in tar acq trans {
			rename `vt'_count* *_`vt'_count
		}

	// Clean the table
		collapse (sum) *count*
		loc rl ""
		foreach d in 5 10 15 20 25 30 50 inf {
			loc rl "`rl' _`d'_"
		}
		gen i=1
		reshape long `rl', i(i) j(vt) s
		list
		gen y = "`year'"
		if `ctr'>1 append using `build'
		save `build', replace
	}
	gen order = 1
	replace order = 2 if vt=="tar_count"
	replace order = 3 if vt=="acq_count"
	sort y order
	outsheet using HC_rev_merger_counts.csv, comma replace

	
exit



