/**************************************************************************
	
	Program: append_advertising.do
	Last Update: February 2018
	JS/DT
	
	This file prepares advertising files for analysis.
	
**************************************************************************/

	args year

/**************************************************************************

	1. Append all advertising files together
	
**************************************************************************/

	if `year' == 2004 {

		use "$temp/cmag2004pres.dta", clear
		append using "$temp/cmag2004nonpres"
		save "$temp/advertising_2004.dta", replace

	}
	
	else if `year' == 2008 {

		use using "$temp/cmag2008pres"
		append using "$temp/cmag2008nonpres"
		save "$temp/advertising_2008.dta", replace

	}

	else if `year' == 2012 {
		
		use "$temp/wesleyan2012pres", clear
		append using "$temp/wesleyan2012downballot"
		append using "$temp/wesleyan2012gov"
		append using "$temp/wesleyan2012house"
		append using "$temp/wesleyan2012senate"

		* Create 15m and 30m variables to allow for comparisons with other data
		qui d grp* imp*, varlist
		local vars = r(varlist)

		foreach var of local vars {

			gen `var'_15m = `var'
			gen `var'_30m = `var'

		}
		
		save "$temp/advertising_2012.dta", replace

	}
		
/**************************************************************************

	2. Create variables used in analysis
	
**************************************************************************/
	
	* Abbreviations for sex-age groups
	local male_2_plus = "m2_p"
	local male_18_34 = "m18_34"
	local male_35_64 = "m35_64"
	local male_65_plus = "m65_p"
	local male_35_plus = "m35_p"
	local male_18_plus = "m18_p"
	local female_2_plus = "f2_p"
	local female_18_34 = "f18_34"
	local female_35_64 = "f35_64"
	local female_65_plus = "f65_p"
	local female_35_plus = "f35_p"
	local female_18_plus = "f18_p"	
	
	global groups_cmag = "m2_p m18_34 m35_64 m65_p m35_p m18_p f2_p f18_34 f35_64 f65_p f35_p f18_p"
	global groups_cmag_all = "$groups_cmag a2_p a18_34 a35_64 a65_p a35_p a18_p"
	
	use "$temp/advertising_`year'.dta", clear
	
	gen prez_sample = (office == "pres" & inlist(party,"dem","rep") & scope == "local" & inrange(period,0,2))

	foreach group of global groups_cmag {

		foreach incr in 15m 30m {
			
			gen c_imps_prez_ptya_`group'_`incr' = imps_`group'_`incr' if prez_sample
			gen c_nads_prez_ptya_`group'_`incr' = nads if prez_sample
			gen c_uniq_prez_ptya_`group'_`incr' = nunique if prez_sample
			
			gen c_imps_prez_ptya_180d_`group'_`incr' = imps_`group'_`incr' if office == "pres" & inlist(party,"dem","rep") & scope == "local" & inrange(period,0,4)
			gen c_imps_prez_ptya_120d_`group'_`incr' = imps_`group'_`incr' if office == "pres" & inlist(party,"dem","rep") & scope == "local" & inrange(period,0,3)
			gen c_imps_prez_ptya_30d_`group'_`incr' = imps_`group'_`incr' if office == "pres" & inlist(party,"dem","rep") & scope == "local" & inrange(period,0,1)
			
			gen c_imps_prez_ptya_natl_`group'_`incr' = imps_`group'_`incr' if office == "pres" & inlist(party,"dem","rep") & inrange(period,0,2)
			gen c_imps_prez_ptya_pro_`group'_`incr' = imps_`group'_`incr' if prez_sample & tone == "pro" 
			gen c_imps_prez_ptya_neg_`group'_`incr' = imps_`group'_`incr' if prez_sample & inlist(tone,"con","att")
			
			gen c_imps_prez_ptya_scan_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "can" 
			gen c_imps_prez_ptya_spty_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "pty" 
			gen c_imps_prez_ptya_sint_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "int" 
			gen c_imps_prez_ptya_shyb_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "hyb" 
			gen c_imps_prez_ptya_soth_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "oth" 
				
			gen c_imps_oth_ptya_`group'_`incr' = imps_`group'_`incr' if office != "pres"  & scope == "local" & inrange(period,0,2)
			gen c_nads_oth_ptya_`group'_`incr' = nads if office != "pres"  & scope == "local" & inrange(period,0,2) 
			gen c_uniq_oth_ptya_`group'_`incr' = nunique if office != "pres"  & scope == "local" & inrange(period,0,2) 
			
			gen c_imps_oth_ptya_180d_`group'_`incr' = imps_`group'_`incr' if office != "pres" & scope == "local" & inrange(period,0,4)
			gen c_imps_oth_ptya_120d_`group'_`incr' = imps_`group'_`incr' if office != "pres"  & scope == "local" & inrange(period,0,3)
			gen c_imps_oth_ptya_30d_`group'_`incr' = imps_`group'_`incr' if office != "pres"  & scope == "local" & inrange(period,0,1)
			
			gen c_imps_oth_ptya_natl_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2)
			gen c_imps_oth_ptya_pro_`group'_`incr' = imps_`group'_`incr' if office != "prez" & scope == "local" & inrange(period,0,2) & tone == "pro" 
			gen c_imps_oth_ptya_neg_`group'_`incr' = imps_`group'_`incr' if office != "prez" & scope == "local" & inrange(period,0,2) & inlist(tone,"con","att") 

			gen c_imps_oth_ptya_scan_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "can" 
			gen c_imps_oth_ptya_spty_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "pty" 
			gen c_imps_oth_ptya_sint_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "int" 
			gen c_imps_oth_ptya_shyb_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "hyb" 
			gen c_imps_oth_ptya_soth_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "oth" 
			
			foreach party in dem rep {

					gen c_imps_prez_`party'_`group'_`incr' = imps_`group'_`incr' if prez_sample & party == "`party'"
					gen c_nads_prez_`party'_`group'_`incr' = nads if prez_sample & party == "`party'"
					gen c_uniq_prez_`party'_`group'_`incr' = nunique if prez_sample & party == "`party'"
					
					gen c_imps_prez_`party'_180d_`group'_`incr' = imps_`group'_`incr' if office == "pres" & scope == "local" & inrange(period,0,4) & party == "`party'"
					gen c_imps_prez_`party'_120d_`group'_`incr' = imps_`group'_`incr' if office == "pres" & scope == "local" & inrange(period,0,3) & party == "`party'"
					gen c_imps_prez_`party'_30d_`group'_`incr' = imps_`group'_`incr' if office == "pres" & scope == "local" & inrange(period,0,1) & party == "`party'"
					
					gen c_imps_prez_`party'_natl_`group'_`incr' = imps_`group'_`incr' if office == "pres" & inrange(period,0,2) & party == "`party'"
					gen c_imps_prez_`party'_pro_`group'_`incr' = imps_`group'_`incr' if prez_sample & tone == "pro" & party == "`party'"
					gen c_imps_prez_`party'_neg_`group'_`incr' = imps_`group'_`incr' if prez_sample & inlist(tone,"con","att") & party == "`party'"
					
					gen c_imps_prez_`party'_scan_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "can" & party == "`party'"
					gen c_imps_prez_`party'_spty_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "pty" & party == "`party'"
					gen c_imps_prez_`party'_sint_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "int" & party == "`party'"
					gen c_imps_prez_`party'_shyb_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "hyb" & party == "`party'"
					gen c_imps_prez_`party'_soth_`group'_`incr' = imps_`group'_`incr' if prez_sample & sponsor == "oth" & party == "`party'"				
			
					gen c_imps_oth_`party'_`group'_`incr' = imps_`group'_`incr' if office != "pres" & scope == "local" & inrange(period,0,2) & party == "`party'"
					gen c_nads_oth_`party'_`group'_`incr' = nads if office != "pres" & scope == "local" & inrange(period,0,2) & party == "`party'"
					gen c_uniq_oth_`party'_`group'_`incr' = nunique if office != "pres" & scope == "local" & inrange(period,0,2) & party == "`party'"
					
					gen c_imps_oth_`party'_180d_`group'_`incr' = imps_`group'_`incr' if office != "pres" & scope == "local" & inrange(period,0,4) & party == "`party'"
					gen c_imps_oth_`party'_120d_`group'_`incr' = imps_`group'_`incr' if office != "pres" & scope == "local" & inrange(period,0,3) & party == "`party'"
					gen c_imps_oth_`party'_30d_`group'_`incr' = imps_`group'_`incr' if office != "pres" & scope == "local" & inrange(period,0,1) & party == "`party'"
					
					gen c_imps_oth_`party'_natl_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & party == "`party'"
					gen c_imps_oth_`party'_pro_`group'_`incr' = imps_`group'_`incr' if office != "pres" & scope == "local" & inrange(period,0,2) & tone == "pro" & party == "`party'"
					gen c_imps_oth_`party'_neg_`group'_`incr' = imps_`group'_`incr' if office != "pres" & scope == "local" & inrange(period,0,2) & inlist(tone,"con","att") & party == "`party'"

					gen c_imps_oth_`party'_scan_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "can" & party == "`party'"
					gen c_imps_oth_`party'_spty_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "pty" & party == "`party'"
					gen c_imps_oth_`party'_sint_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "int" & party == "`party'"
					gen c_imps_oth_`party'_shyb_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "hyb" & party == "`party'"
					gen c_imps_oth_`party'_soth_`group'_`incr' = imps_`group'_`incr' if office != "pres" & inrange(period,0,2) & sponsor == "oth" & party == "`party'"				
			
			}

		}

	}

	collapse (sum) c_* est_cost*, by(year dma_name)

	d *_f*, varlist
	local vars = r(varlist)
	foreach female_group of local vars {

		local male_group = subinstr("`female_group'","_f","_m",.)
		local all_group = subinstr("`female_group'","_f","_a",.)
		
		if regexm("`female_group'","imps") {
		
			gen `all_group' = `female_group' + `male_group'
			
		}
		
		* For number of ads and number of unique ads, do not add female and male impressions
		else if (regexm("`female_group'","nads") | regexm("`female_group'","uniq")){
		
			gen `all_group' = `female_group'
				
		}
		 
	}
	
	* Create GRP measures
	merge m:1 dma_name using "$data/nielsen/`year'/nielsen_data.dta", gen(nielsen_merge)
	egen nielsen_merge_min = min(nielsen_merge), by(year)
	egen nielsen_merge_max = max(nielsen_merge), by(year)
	assert nielsen_merge_min == nielsen_merge_max if year != 2004
	keep if nielsen_merge == 3
	drop nielsen_merge*

	foreach group of global groups_cmag_all {
	
			d c_imps*`group'*, varlist
			local vars = r(varlist)
			
			foreach var of local vars {
			
				local name = subinstr("`var'","imps","grp",.)
				gen `name' = `var'/(market_viewers_`group'*10)   
			
			}				
			
	}     
	   
	* Create GRP Party Difference measure
	d c_grp*_dem* c_imps*_dem* c_nads*_dem* c_uniq*_dem*, varlist
	local vars = r(varlist)
	foreach dem_group of local vars {
	
		 local rep_group = subinstr("`dem_group'","_dem","_rep",.)
		 local ptyd_group = subinstr("`dem_group'","_dem","_ptyd",.)
		 gen `ptyd_group' = `dem_group' - `rep_group'
		 
	}

	keep year dma_name dma_code market_viewers* c_*
	sort year dma_name

	* Create abbreviated values
	foreach type in prez oth {
	
		foreach party in ptya ptyd dem rep {
		
			gen cmag_`type'_`party'_base = c_imps_`type'_`party'_a18_p_30m/10
			gen cmag_`type'_`party'_grp = c_grp_`type'_`party'_a18_p_30m
			gen cmag_`type'_`party'_uniq = c_uniq_`type'_`party'_a18_p_30m
			gen cmag_`type'_`party'_1knads = c_nads_`type'_`party'_a18_p_30m/1000
			gen cmag_`type'_`party'_pro = c_imps_`type'_`party'_pro_a18_p_30m/10
			gen cmag_`type'_`party'_neg = c_imps_`type'_`party'_neg_a18_p_30m/10
			gen cmag_`type'_`party'_180days = c_imps_`type'_`party'_180d_a18_p_30m/10
			gen cmag_`type'_`party'_120days = c_imps_`type'_`party'_120d_a18_p_30m/10
			gen cmag_`type'_`party'_30days = c_imps_`type'_`party'_30d_a18_p_30m/10
			gen cmag_`type'_`party'_natl = c_imps_`type'_`party'_natl_a18_p_30m/10
			gen cmag_`type'_`party'_2plus = c_imps_`type'_`party'_a2_p_30m/10
						
		}
		
	}

	keep cmag* dma* market_viewers* year

	save "$data/`year'/advertisements.dta", replace
	
**************************************************************************

* END OF FILE
