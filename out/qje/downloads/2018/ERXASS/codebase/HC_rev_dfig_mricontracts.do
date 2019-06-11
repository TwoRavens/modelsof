/*-----------------------------------------------------------HC_rev_dfig_mricontracts.do
Creates figures to illustrate the persistence of MRI price agreements

Stuart Craig
Last updated 20180816
*/


timestamp, output
cap mkdir dfig_mricontracts
cd dfig_mricontracts

// Contract lookup program (only used to understand what's going on inside the hospital)
	cap prog drop hlu
	prog define hlu
		args h

		sort prov_e_npi ep_adm_m
		list ep_adm_m price charge prop_pc c_type c_??_id* ep_proc* if h_index==`h', noobs
		
	end

// Filler data to ensure proper sizing of markers
	cap confirm file ${tHC}/temp_filler.dta
	if _rc!=0 {
		clear
		input count amt str6 type
			1 . "price"
			1 . "charge"
			1 . "prop"
		end
		expand 5
		bys type: gen c_rank=_n
		save ${tHC}/temp_filler.dta, replace
	}

// MRI contracts at the two largest hospitals
loc proc kmri
if "`proc'"=="ip" continue
forval h=1/2 {

	use ${ddHC}/HC_cdata_`proc'_i.dta, clear

// First, create logitudinal link of contracts
	cap drop c_id
	qui gen c_id = string(c_type)
	qui replace c_id = c_id + " " + string(c_pr_id) if c_type==1
	qui replace c_id = c_id + " " + string(c_pc_id) if c_type==2
	qui replace c_id = c_id + " " + string(c_pr_id) + " " + string(c_pc_id) if c_type==3

	preserve
		keep if h_index==`h'
		qui count
		
		drop if c_type==-9
		
		qui levelsof  pat_prod, local(prods)
		foreach prod of local prods {
			cap drop prod_`prod'
			qui gen prod_`prod'=pat_prod=="`prod'"
		}
		qui levelsof pat_fund, local(funds)
		foreach fund of local funds {
			cap drop fund_`fund'
			qui gen fund_`fund'=pat_fund=="`fund'"
		}
		qui levelsof pat_mkt, local(segs)
		foreach seg of local segs {
			cap drop seg_`seg'
			qui gen seg_`seg'=pat_mkt=="`seg'"
		}

		qui gen procs=1
		collapse (sum) procs (mean) prod_* fund* seg_*  c_type prop_pc (min) mind=ep_adm_d (max) maxd=ep_adm_d, ///
			by(prov_e_npi c_id) fast
		format mind maxd %td
		
		cap drop ppm
		qui gen ppm = procs*(30/(maxd-mind))
		
		sort c_type mind
		list mind maxd c_id c_type ppm procs prod* fund* prop_pc, ab(32) noobs
		
		cap drop next_c_id
		qui gen next_c_id="" 
			
		// Matching
		cap drop temp_n
		qui gen temp_n=_n
		qui summ temp_n
		loc N=r(max)
		forval n=1/`N' {
			cap drop temp_potmatch
			qui gen temp_potmatch=1
			qui replace temp_potmatch=0 if temp_n==`n' // can't match to yourself
			
			// Dates
			cap drop temp_date
			qui gen temp_date = mind
			qui summ maxd if temp_n==`n', mean
			qui replace temp_date = r(mean) if temp_n==`n'
			
			// Calculate standardized Euclidean distance
			cap drop temp_pdist
			qui gen temp_pdist=0
			loc vs "fund* prod* seg*"
			foreach v of varlist `vs' ppm temp_date {
				qui summ `v'
				cap drop sample_var
				qui gen sample_var = r(Var)
				qui summ `v' if temp_n==`n', mean
				cap drop temp_add
				qui gen temp_add = (((`v'-r(mean))^2)/sample_var)
				qui replace temp_pdist = temp_pdist + temp_add
				drop sample_var
			}
			qui replace temp_pdist=sqrt(temp_pdist)
			di `n'
			* list mind maxd c_id c_type ppm procs c_anybag prod* fund* temp_pdist, ab(32) noobs
			// Take the minimizer
			qui {
				bys temp_potmatch (temp_pdist): replace temp_potmatch=0 if _n>1
			}
			sort mind
			qui count if temp_potmatch
			assert inlist(r(N),0,1)
			* if r(N)==0 continue
			qui levelsof c_id if temp_potmatch, local(next)
			qui replace next_c_id=`next' if temp_n==`n'
			
		}
		drop temp*
		
		sort mind
		cap drop temp_n
		qui gen temp_n=_n
		qui summ temp_n
		loc N=r(max)
		forval n=1/`N' {
			cap drop temp_potmatch
			qui gen temp_potmatch=1
			qui replace temp_potmatch=0 if temp_n==`n'
			
			// Dates
			cap drop temp_date
			qui gen temp_date = maxd
			qui summ mind if temp_n==`n', mean
			qui replace temp_date = r(mean) if temp_n==`n'
			
			cap drop temp_pdist
			qui gen temp_pdist=0
			loc vs "fund* prod* seg*"
			foreach v of varlist `vs' ppm temp_date {
				qui summ `v'
				cap drop sample_var
				qui gen sample_var = r(Var)
				qui summ `v' if temp_n==`n', mean
				cap drop temp_add
				qui gen temp_add = (((`v' - r(mean))^2)/sample_var)
				qui replace temp_pdist = temp_pdist + temp_add
				drop sample_var
			}
			qui replace temp_pdist=sqrt(temp_pdist)
			qui {
				bys temp_potmatch (temp_pdist): replace temp_potmatch=0 if _n>1
			}
			sort mind
			qui count if temp_potmatch
			assert inlist(r(N),0,1)
			qui levelsof c_id if temp_potmatch	, local(prev)
			qui levelsof c_id if temp_n==`n'	, local(curr)
			qui replace next_c_id="" if c_id!=`prev'&next_c_id==`curr'
			list mind maxd c_id c_type ppm procs  prod* fund* temp_pdist next_c_id, ab(32) noobs
		}
		list mind maxd c_id c_type ppm procs  prod* fund* temp_pdist next_c_id, ab(32) noobs
		
		// Create a key
		forval n=1/`N' {
			qui levelsof next_c_id if temp_n==`n', local(next)
			qui levelsof c_id if temp_n==`n', local(master)
			loc next `next'
			loc master `master'
			qui replace c_id = "`master'" if c_id=="`next'"
		}
		keep c_id next_c_id prov_e_npi
		rename next_c_id merge_c_id
		rename c_id persistent_c_id
		drop if merge_c_id==""
		tempfile cid_key
		save `cid_key', replace
	restore

// Merge the contract key to show how the matching links them
	cap drop _merge
	cap drop merge_c_id
	qui gen merge_c_id=c_id
	merge m:1 prov_e_npi merge_c_id using `cid_key', update keep(1 3 4) nogen
	qui replace persistent_c_id = c_id if h_index==`h'&persistent_c_id==""


// Create a figure 
	preserve
		keep if h_index==`h'
		cap drop temp_vol
		bys persistent_c_id: gen temp_vol=-_N if c_type>-9
		cap drop c_rank
		qui egen c_rank = group(temp_vol persistent_c_id)
		
		cap drop count
		qui gen count=1
		collapse (sum) count, by(ep_adm_m persistent_c_id c_rank price) fast
		rename price amt
		qui gen type="price"
		tempfile prices
		save `prices', replace
	restore

	keep if h_index==`h'
	cap drop temp_vol
	bys persistent_c_id: gen temp_vol=-_N if c_type>-9
	cap drop c_rank
	qui egen c_rank = group(temp_vol persistent_c_id)
	
	cap drop temp_top3
	qui gen temp_top3 = inrange(c_rank,1,3)
	qui summ temp_top3, mean
	loc top3: di %2.0f r(mean)*100
	di `top3'
	
	cap drop count
	qui gen count=1
	collapse (sum) count, by(ep_adm_m persistent_c_id c_rank prop_pc) fast
	
	rename prop_pc amt
	qui gen type="prop"
	append using `prices'
	append using ${tHC}/temp_filler.dta
	
	global xmin = ym(2008,1)
	global xmax	= ym(2012,1)
	global ms "mlw(medthick) msize(vsmall)"
	
	qui summ amt if c_rank==1&type=="price" [aw=count], mean
	loc p_1 = round(r(mean))
	qui summ amt if c_rank==2&type=="price" [aw=count], mean
	loc p_2 = round(r(mean))
	
	qui summ amt if type=="price" [aw=count]
	qui replace amt = amt - r(mean)
	
	tw 	scatter amt ep_adm_m if c_rank==1&type=="price" [aw=count], ${ms} msymbol(Oh)  || ///
		scatter amt ep_adm_m if c_rank==2&type=="price" [aw=count], ${ms} msymbol(X) || ///
		scatter amt ep_adm_m if c_rank==3&type=="price" [aw=count], ${ms} msymbol(Th) || ///
		scatter amt ep_adm_m if !inrange(c_rank,1,3)&type=="price" [aw=count], ${ms} msymbol(+) msize(tiny) mlw(medium) mlc(gs7) ///
		legend(off) ///
		xlab(${xmin}(12)${xmax},format(%tm) angle(270) labsize(medium)) ylab(,format(%10.0fc) labsize(medium)) ///
		ytitle("Price Relative to the Mean", size(medium)) xtitle("") xsize(1) ysize(1) ///
		saving(price, replace)
	graph export HC_rev_dfig_mricontracts_h`h'_p1_`p_1'_p2_`p_2'_top3`top3'.png, replace
	
	// B/W version for publication
	tw 	scatter amt ep_adm_m if c_rank==1&type=="price" [aw=count], ${ms} msymbol(Oh) col(gs12)  || ///
		scatter amt ep_adm_m if c_rank==2&type=="price" [aw=count], ${ms} msymbol(X) col(gs9) || ///
		scatter amt ep_adm_m if c_rank==3&type=="price" [aw=count], ${ms} msymbol(Th) col(gs6) || ///
		scatter amt ep_adm_m if !inrange(c_rank,1,3)&type=="price" [aw=count], ${ms} msymbol(+) msize(tiny) mlw(medium) mlc(gs7) ///
		legend(off) ///
		xlab(${xmin}(12)${xmax},format(%tm) angle(270) labsize(medium)) ylab(,format(%10.0fc) labsize(medium)) ///
		ytitle("Price Relative to the Mean", size(medium)) xtitle("") xsize(1) ysize(1) ///
		saving(price, replace)
	graph export HC_rev_dfig_mricontracts_h`h'_p1_`p_1'_p2_`p_2'_top3`top3'.tif, replace width(5000)

}

exit
