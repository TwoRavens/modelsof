/**************************************************************************
	
	Program: combine_years.do
	JS/DT
		
**************************************************************************/

	use "$data/2004/sample.dta", clear
	append using "$data/2008/sample.dta"
	append using "$data/2012/sample.dta"
		
	egen state_county = group(state county)
	egen state_year = group(state year)
	
	save "$temp/county_all.dta", replace
	
	*--------------------------------------------------------------
	* Create "All Counties" data set
	*--------------------------------------------------------------
	
	use "$temp/county_all.dta", clear
	merge m:m state county using "$data/border_pairs.dta", keepusing(state county within_state) keep(1 3) generate(border_county)
	egen any_within_state = max(within_state), by(state county)
	egen state_segment = group(state segment)
	egen state_segment_year = group(state segment year)
	egen segment_year = group(segment year)
	drop within_state
	duplicates drop
	recode border_county (3=1) (1=0) 
	replace border_county = 0 if any_within_state == 0
	sort year dma_name 
	save "$output/sample_allcounties.dta", replace

	*--------------------------------------------------------------
	* Create "County Pairs" data set
	*--------------------------------------------------------------
	
	use "$temp/county_all.dta", clear
	sort state county
	joinby state county using "$data/border_pairs.dta"
	egen state_pair_year = group(state_pair year)
	egen n_state_pair_year = total(1), by(state_pair_year)
	egen state_border = group(dma_code1 dma_code2 state)
	egen state_border_year = group(dma_code1 dma_code2 state year)
	egen tag_border_dma = tag(year state_pair dma_name)
	egen both_market_pop = total(tag_border_dma*market_pop_adult), by(state_pair_year)

	* Congressional District Pair Matches
	egen temp_pair_cd_match = sd(cd_max), by(state_pair_year)
	gen pair_cd_match = (temp_pair_cd_match == 0)
	drop temp_pair_cd_match

	egen pair_pop = total(tot_pop_adult), by(year state_pair dma_name)
	egen pair_vote_pop = total(tot_pop_vote), by(year state_pair dma_name)
	gen pct_pair_pop = pair_pop/both_market_pop
	egen n_pairs_per_county = total(1), by(year state county within_state)
	gen wt = 1/n_pairs_per_county
	gen wt_equal_mkt = (tot_pop_vote/market_vote_pop)*wt*100000
	gen wt_equal_pair = (tot_pop_vote/pair_vote_pop)*100000
	gen wt_equal_mkt_pair = (tot_pop_vote/pair_vote_pop)*wt*100000
	gen wt_equal_county = 840*wt
	gen wt_pop_vote = tot_pop_vote*wt
	keep if within_state == 1 & n_state_pair_year == 2
	save "$output/sample_countypairs.dta", replace
	
	*--------------------------------------------------------------
	* Create own county data set with pair county data
	*--------------------------------------------------------------
	
	use "$output/sample_countypairs.dta", clear
	gen reference = "dem"
	append using "$output/sample_countypairs.dta"
	replace reference = "rep" if missing(reference)
	
	d *_dem*, varlist
	local dem_varlist = r(varlist)
	
	d *_rep*, varlist
	local rep_varlist = r(varlist)
	
	foreach var of local dem_varlist {
		local demvar = subinstr("`var'","_dem","_ownpty",.)
		local repvar = subinstr("`var'","_dem","_othpty",.) 
		gen `demvar' = `var' if reference == "dem"
		gen `repvar' = `var' if reference == "rep"
	} 
	
	foreach var of local rep_varlist {
		local repvar = subinstr("`var'","_rep","_ownpty",.)
		local demvar = subinstr("`var'","_rep","_othpty",.) 
		replace `demvar' = `var' if reference == "dem"
		replace `repvar' = `var' if reference == "rep"
	} 
	
	save "$output/sample_countypairs_own.dta", replace
	
	*--------------------------------------------------------------
	* Create first differences data
	*--------------------------------------------------------------
	
	use "$output/sample_countypairs.dta", clear
	egen cmag_prez_rank = rank(cmag_prez_ptya_base), by(state_pair_year) unique
	keep $df_variables year state state_year state_pair_year cmag_prez_rank 
	reshape wide $df_variables, i(year state state_year state_pair_year) j(cmag_prez_rank)
	foreach var of global df_variables {
		gen `var'_df = `var'2 - `var'1
		egen `var'_dfstd = std(`var'_df)  
	}
	save "$output/sample_pairdfs.dta", replace
	
	*--------------------------------------------------------------
	* Create GRP data
	*--------------------------------------------------------------

	use "$output/sample_allcounties", clear
	keep year dma_code dma_name cmag_* cand_visits*
	duplicates drop
	save "$output/grps.dta", replace


**************************************************************************/

* END OF FILE
