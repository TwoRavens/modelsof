	

clear
clear matrix
set mem 4000m
set more off


* cleans and merges t100 segment data 
 
forvalues j = 1993(1)2008 {

	use  year quarter origin dest carrier origin_country_name dest_country_name carrier departures_scheduled departures_performed seats passengers ///
	distance using "t100segment`j'.dta", clear
	
	* keeps quarter and domestic travel
	keep if origin_country_name=="United States of America"
	keep if dest_country_name=="United States of America"
	drop origin_country_name dest_country_name
	
	* drops observations with same origin and dest
	drop if origin==dest
	egen mkt=concat(origin dest)
	drop origin dest
	
	* total for each segment	
	rename carrier mkttkcarrier
	sort mkt year quarter mkttkcarrier
	bysort mkt year quarter mkttkcarrier: egen t100_schdepts=total(departures_scheduled)
	bysort mkt year quarter mkttkcarrier: egen t100_depts=total(departures_performed)
	bysort mkt year quarter mkttkcarrier: egen t100_seats=total(seats)
	bysort mkt year quarter mkttkcarrier: egen t100_pass=total(passengers)
	gen t100_loadfactor=t100_pass/t100_seats
				
	* gets rid of replicated observations
	sort mkt year quarter mkttkcarrier
	drop if (mkt[_n]==mkt[_n-1] & year[_n]==year[_n-1] & quarter[_n]==quarter[_n-1] & mkttkcarrier[_n]==mkttkcarrier[_n-1]) 
	
	* sorts and save data
	keep mkt year quarter mkttkcarrier t100_schdepts t100_depts t100_seats t100_pass t100_loadfactor
	save "capacity_`j'.dta", replace

}


* combines files and saves data
clear
gen temp=.
forvalues j = 1993(1)2008 {
	append using "capacity_`j'.dta"
}
forvalues j = 1993(1)2008 {
	erase "capacity_`j'.dta"
}
drop temp

sort mkt year quarter mkttkcarrier
save "capacity_segment.dta", replace


