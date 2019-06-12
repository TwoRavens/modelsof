
**********************************************************
*** CODE FOR ADMINISTRATIVE UPTAKE DATA ANALYSIS *********
**********************************************************

clear
cd "/Users/samtrachtman/Dropbox/ACA Study/Projects/Public Private Field Experiment/APSR production/replication materials/submission_data/administrative"
set matsize 800
set more off

*import and clean PUMA-FIPS crosswalk
	import excel puma_county_crosswalk.xlsx, sheet("geocorr14.csv") firstrow clear
	tostring state puma county, replace
	replace county = "0"+ county if length(county) == 4
	replace state = "0" + state if length(state) == 1
	rename county FIPS
	duplicates tag FIPS, gen(dup_id)
	rename (state puma12) (State Puma)
	save puma_fips_walk, replace

*Import and clean KFF data on potential and actual signups (note this is not to be shared)
	import excel KFF_puma_potential_signups.xlsx, sheet("20150423 puma data feb 2015 upd") firstrow clear 
	//note: data cannot be shared due to data use agreeement
	tostring gestfips puma zcta, replace
	rename (gestfips puma zcta) (State Puma zip)
	replace zip = "0" + zip if length(zip) == 4
	replace zip = "00" + zip if length(zip) == 3
	
*collapse down to PUMA level 
	collapse (mean) one se  puma_selections share sharelowerbound shareupperbound nonelderlyagemedian nonelderlyage25th nonelderlyage75th hispanic white black householdincome25th householdincomemedian householdincome75th yearsofcollege, by (State stateab Puma)
	replace State = "0" + State if length(State) == 1
	merge 1:m State Puma using puma_fips_walk
	//unmatched are from using - they are SBM states 
	drop if _merge == 2
	drop _merge

*merging and saving temp file
	merge m:1 FIPS using county_level_data
	//merge==1 are a couple that changed FIPS codes 
	keep if _merge==3
	save temp_base, replace
	
*subset and collapse for units with multiple PUMAs in a county 
	#delimit;
	keep if dup_id > 0;
	collapse  (sum) one PlanSelections_2015 puma_selections (mean) share sharelowerbound shareupperbound nonelderlyagemedian 
	hispanic white black householdincomemedian yearsofcollege  
	rural_urban unemp_rate 
	percent_fair_poor percent_uninsured  
	pop pop_under_18 pop_over_65 
	dem_2012 
	num_plans_2014 avg_2014_Silver 
	, by (State stateab FIPS);
	save temp, replace;

*subset to obs where either multiple counties in a PUMA, or 1 to 1 overlap ;
	use temp_base, clear;
	keep if dup_id == 0;
	collapse (sum) PlanSelections_2015 (mean) one puma_selections share sharelowerbound shareupperbound nonelderlyagemedian 
	hispanic white black householdincomemedian yearsofcollege  
	rural_urban unemp_rate 
	percent_fair_poor percent_uninsured  
	 dem_2012 
	pop pop_under_18 pop_over_65 
	num_plans_2014 avg_2014_Silver 
	, by (State stateab Puma);
	append using temp;
#delimit cr

*Cleaning
	rename (one puma_selections PlanSelections share) (potential_market_2015 selections_2015 selections_2016 share_2015)
	gen share_2016 = selections_2016/potential_market_2015
	tab State, gen(state)
	gen dem_sq = dem_2012^2

	
  
*************
** TABLE A4**
*************
cd "/Users/samtrachtman/Dropbox/ACA Study/Projects/Public Private Field Experiment/APSR production/replication materials/submission_output/administrative"

	*basic bivariate
	reg share_2015 dem_2012, robust
	outreg2 using raw_puma.xls, dec(5) cti(bivariate) st(coef se) replace  //noparen symbol("")

	xi: reg share_2015 dem_2012 black hispanic yearsofcollege householdincomemedian rural_urban unemp_rate percent_uninsured percent_fair_poor num_plans_2014 avg_2014_Silver pop pop_under_18 pop_over_65  i.State, robust
	outreg2 using raw_puma.xls, dec(5) cti(pref_spec) st(coef se) append  //noparen symbol("")
	margins, dydx(dem_2012) at(dem_2012=(.3 .4 .5))
	
	*FIGURE A1
	rvfplot
	
	*FIGURE A2
	avplot dem_2012

	*with squared term 
	xi: reg share_2015 c.dem_2012##c.dem_2012 black hispanic yearsofcollege householdincomemedian rural_urban unemp_rate percent_uninsured percent_fair_poor num_plans_2014 avg_2014_Silver  pop pop_under_18 pop_over_65 i.State, robust
	outreg2 using raw_puma.xls, dec(5) cti(quadratic) st(coef se) append  //noparen symbol("")
	margins, dydx(dem_2012) at(dem_2012=(.2 .3 .4 .5 .6 .7))


save "/Users/samtrachtman/Dropbox/ACA Study/Projects/Public Private Field Experiment/APSR production/submission_data/administrative/admin_figure_data", replace 
