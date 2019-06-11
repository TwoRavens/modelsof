/*----------------------------------------------------------HC_rev_dfig_delvcontracts.do
Creates figures to illustrate the persistence of price and price-to-charge contracts
using the vaginal delivery data

Stuart Craig
Last updated 	20180816
*/


timestamp, output
cap mkdir dfig_delvcontracts
cd dfig_delvcontracts

// Hospital lookup 
	cap prog drop hlu
	prog define hlu
		args h

		sort prov_e_npi ep_adm_m
		list ep_adm_m price charge prop_pc c_type c_??_id* ep_proc* if h_index==`h', noobs
		
	end

// Filler data to get marker sizes right
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


// Bring in the contract cleaned data
	loc proc delv
	use ${ddHC}/HC_cdata_`proc'_i.dta, clear
	keep if inlist(ep_adm_y,2010,2011)

// Pick a hospital with a nice contract split (h_index=17 in the final iteration)
	loc prov "03F1A00A5EF2181FEC485F3BD3A8317B"
	qui summ h if prov_e_npi=="`prov'", mean
	loc h=r(mean)

// Primitive contract IDs
	cap drop c_id
	qui gen c_id = string(c_type)
	qui replace c_id = c_id + " " + string(c_pr_id) if c_type==1
	qui replace c_id = c_id + " " + string(c_pc_id) if c_type==2
	qui replace c_id = c_id + " " + string(c_pr_id) + " " + string(c_pc_id) if c_type==3

// Logitudinally link the contracts
	preserve
		keep if h_index==`h'
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

		qui gen procs=1
		collapse (sum) procs (mean) prod_* fund*  c_type prop_pc (min) mind=ep_adm_d (max) maxd=ep_adm_d, ///
			by(prov_e_npi c_id) fast
		format mind maxd %td
		
		cap drop ppm
		qui gen ppm = procs*(30/(maxd-mind))
		
		sort c_type mind
		list mind maxd c_id c_type ppm procs  prod* fund* prop_pc, ab(32) noobs
		
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
			loc vs "fund* prod*"
			foreach v of varlist `vs' temp_date {
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
			loc vs "fund* prod*"
			foreach v of varlist `vs' temp_date {
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
		* bys merge_c_id: drop if _N>1
		drop if merge_c_id==""
		tempfile cid_key
		save `cid_key', replace
	restore

	cap drop _merge
	cap drop merge_c_id
	qui gen merge_c_id=c_id
	merge m:1 prov_e_npi merge_c_id using `cid_key', update keep(1 3 4) nogen
	qui replace persistent_c_id = c_id if h_index==`h'&persistent_c_id==""


// Create a figure of our test case
	preserve
		keep if h_index==`h'
		cap drop temp_vol
		bys persistent_c_id: gen temp_vol=-_N
		cap drop c_rank
		qui egen c_rank = group(temp_vol persistent_c_id)
		
		cap drop count
		qui gen count=1
		collapse (sum) count, by(ep_adm_m persistent_c_id c_rank price) fast
		rename price amt
		
		qui summ amt [aw=count], mean
		qui replace amt = amt - r(mean)
		*/
		qui gen type="price"
		tempfile prices
		save `prices', replace
	restore
	preserve
		keep if h_index==`h'
		cap drop temp_vol
		bys persistent_c_id: gen temp_vol=-_N
		cap drop c_rank
		qui egen c_rank = group(temp_vol persistent_c_id)
		
		cap drop cout
		qui gen count=1
		collapse (sum) count, by(ep_adm_m persistent_c_id c_rank charge) fast
		rename charge amt
		qui gen type="charge"
		tempfile charges
		save `charges', replace
	restore
		keep if h_index==`h'
		cap drop temp_vol
		bys persistent_c_id: gen temp_vol=-_N
		cap drop c_rank
		qui egen c_rank = group(temp_vol persistent_c_id)
		
		cap drop count
		qui gen count=1
		collapse (sum) count, by(ep_adm_m persistent_c_id c_rank prop_pc) fast
		
		rename prop_pc amt
		qui gen type="prop"
		append using `prices'
		append using `charges'
		append using ${tHC}/temp_filler.dta
		
		global xmin = ym(2010,1)
		global xmax	= ym(2012,1)
		global ms "mlw(medthick)"

	// Main table
		// For the legend
		tw 	scatter amt ep_adm_m if c_rank==1&type=="price" [aw=count], ${ms} msymbol(circle_hollow)  msize(medsmall) || ///
			scatter amt ep_adm_m if c_rank==2&type=="price" [aw=count], ${ms} msymbol(Th)  msize(medsmall)  ///
			legend(order(1 "Contract #1" 2 "Contract #2") row(1) pos(11) ring(0)) ///
			xlab(${xmin}(12)${xmax},format(%tm) angle(270) labsize(medium)) ///
			ylab(,format(%10.0fc) labsize(medium)) ///
			xtitle("Month", size(medlarge)) ytitle("Price ($) Relative to the Mean", size(medlarge)) xsize(1) ysize(1) ///
			title("Panel A: Repeated Prices", pos(12)) 
		graph export HC_rev_dfig_delvcontracts_`h'_legend.png, replace
		// Prices	
		tw 	scatter amt ep_adm_m if c_rank==1&type=="price" [aw=count], ${ms} msymbol(circle_hollow)  msize(small) || ///
			scatter amt ep_adm_m if c_rank==2&type=="price" [aw=count], ${ms} msymbol(Th)  msize(small)  ///
			xlab(${xmin}(12)${xmax},format(%tm) angle(270) labsize(medium)) ///
			ylab(,format(%10.0fc) labsize(medium)) ///
			xtitle("Month", size(medlarge)) ytitle("Price ($) Relative to the Mean", size(medlarge)) xsize(1) ysize(1) ///
			title("Panel A: Repeated Prices", pos(12)) legend(off) ///
			saving(price, replace)
		// Price to charge
		tw 	scatter amt ep_adm_m if c_rank==1&type=="prop" [aw=count], ${ms} msymbol(circle_hollow)  msize(small) || ///
			scatter amt ep_adm_m if c_rank==2&type=="prop" [aw=count], ${ms} msymbol(Th)  msize(small) ///
			xlab(${xmin}(12)${xmax},format(%tm) angle(270) labsize(medium)) ///
			ylab(,format(%3.2fc) labsize(medium)) ///
			xtitle("Month", size(medlarge)) ytitle("Share of Charges", size(medlarge)) xsize(1) ysize(1)  ///
			title("Panel B: Repeated Share of Charges", pos(12)) legend(off) ///
			saving(pc, replace)
		graph combine price.gph pc.gph, imargin(0 0 0 0)
		graph export HC_rev_dfig_delvcontracts_`h'.png, replace
			
	// Balck and white version		
		// For the legend
		tw 	scatter amt ep_adm_m if c_rank==1&type=="price" [aw=count], col(gs2) ${ms} msymbol(circle_hollow)  msize(medsmall) || ///
			scatter amt ep_adm_m if c_rank==2&type=="price" [aw=count], col(gs8) ${ms} msymbol(Th)  msize(medsmall)  ///
			legend(order(1 "Contract #1" 2 "Contract #2") row(1) pos(11) ring(0)) ///
			xlab(${xmin}(12)${xmax},format(%tm) angle(270) labsize(medium)) ///
			ylab(,format(%10.0fc) labsize(medium)) ///
			xtitle("Month", size(medlarge)) ytitle("Price ($) Relative to the Mean", size(medlarge)) xsize(1) ysize(1) ///
			title("Panel A: Repeated Prices", pos(12)) 
		graph export HC_pub_dfig_delvcontracts_`h'_legend.tif, replace width(5000)
		// Prices	
		tw 	scatter amt ep_adm_m if c_rank==1&type=="price" [aw=count], col(gs2) ${ms} msymbol(circle_hollow)  msize(small) || ///
			scatter amt ep_adm_m if c_rank==2&type=="price" [aw=count], col(gs8) ${ms} msymbol(Th)  msize(small)  ///
			xlab(${xmin}(12)${xmax},format(%tm) angle(270) labsize(medium)) ///
			ylab(,format(%10.0fc) labsize(medium)) ///
			xtitle("Month", size(medlarge)) ytitle("Price ($) Relative to the Mean", size(medlarge)) xsize(1) ysize(1) ///
			title("Panel A: Repeated Prices", pos(12)) legend(off) ///
			saving(price, replace)
		// Price to charge
		tw 	scatter amt ep_adm_m if c_rank==1&type=="prop" [aw=count], col(gs2) ${ms} msymbol(circle_hollow)  msize(small) || ///
			scatter amt ep_adm_m if c_rank==2&type=="prop" [aw=count], col(gs8) ${ms} msymbol(Th)  msize(small) ///
			xlab(${xmin}(12)${xmax},format(%tm) angle(270) labsize(medium)) ///
			ylab(,format(%3.2fc) labsize(medium)) ///
			xtitle("Month", size(medlarge)) ytitle("Share of Charges", size(medlarge)) xsize(1) ysize(1)  ///
			title("Panel B: Repeated Share of Charges", pos(12)) legend(off) ///
			saving(pc, replace)	
		graph combine price.gph pc.gph, imargin(0 0 0 0)
		graph export HC_pub_dfig_delvcontracts_`h'.tif, replace width(5000)	
		
exit
