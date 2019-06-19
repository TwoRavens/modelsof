


clear
set more off



* gets statistics on net-delays for each flight segment, by crew_rating (2004 is first year with late-aircraft information, 1995 is first year with tail numbers)
**************************************


forvalues j = 1993(1)2009 {
	forvalues k = 1(1)12 {
		
	* loads delays data
	use year month carrier arrdelay origin dest taxiin taxiout cancelled diverted tailnum using "on_time_performance_`j'_`k'.dta", clear
	
	* drops flights that had to ended at same location (flights returning to origin)
	drop if origin==dest
	egen mkt=concat(origin dest)
	drop if (strlen(origin)~=3 | strlen(dest)~=3)
	drop origin dest
	drop if diverted==1
	drop diverted
	
		
	* destrings variables
	destring arrdelay, replace force
	
	
	* generates quarter variable
	generate quarter=.
	replace quarter=1 if month>=1 & month<=3
	replace quarter=2 if month>=4 & month<=6
	replace quarter=3 if month>=7 & month<=9
	replace quarter=4 if month>=10 & month<=12
	drop month
	drop if quarter==.
	
	* generates indicators for different buckets of delays
	local varloop "15 30 45 60 90 120 180"
	foreach x of local varloop {
		
		gen pct_arr`x'=0
		replace pct_arr`x'=1 if arrdelay>=`x'

	}
	

	* calculates delay statistics by segment-carrier-month	
	gen num_obs=1
	collapse (p50) p50_arr=arrdelay p50_taxiin=taxiin p50_taxiout=taxiin (mean) avg_arr=arrdelay avg_taxiin=taxiin avg_taxiout=taxiin pct_cancel=cancelled ///
	pct_arr15 pct_arr30 pct_arr45 pct_arr60 pct_arr90 pct_arr120 pct_arr180 (sum) num_obs, by(year quarter mkt carrier)
	
	
	* sorts and saves the data
	compress
	sort year quarter mkt carrier
	save "delays_`j'_`k'.dta", replace
	
	}
}






* merges data and appends files
**************************************

* appends data
clear 
gen temp=.
forvalues j = 1993(1)2009 {
	forvalues k = 1(1)12 {
		
	append using "delays_`j'_`k'.dta"
	*erase "delays_`j'_`k'.dta"
	
	}
}
drop temp


* sorts and saves data
sort mkt carrier year quarter 
save "delays_all.dta", replace




















