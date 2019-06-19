


clear
*set mem 8000m
set processors 2
set more off


** cleans and merges the fare data into a usable form


forvalues i = 1(1)4 {
	forvalues j = 1993(1)2010 {

	* cleans coupon data
	clear
	use itinid mktid seqnum coupons year quarter origin originaptind dest destaptind break coupontype tkcarrier opcarrier rpcarrier passengers fareclass distance using "origin_and_destination_survey_db1bcoupon_`j'_`i'.dta"
	rename seqnum coupseqnum
	rename coupons totcoupons
	rename origin couporigin
	rename originaptind couporiginaptind
	rename dest coupdest	
	rename destaptind coupdestaptind
	rename break coupbreak
	rename tkcarrier couptkcarrier
	rename opcarrier coupopcarrier 
	rename rpcarrier couprpcarrier
	rename passengers couppassengers
	rename fareclass coupfareclass
	rename distance coupdistance
	sort itinid
	save "coupon`j'_`i'.dta", replace

	* cleans market data
	clear 
	use itinid mktid mktcoupons origin originaptind dest destaptind tkcarrierchange opcarrierchange rpcarrier tkcarrier opcarrier passengers mktfare mktdistance mktmilesflown nonstopmiles using "origin_and_destination_survey_db1bmarket_`j'_`i'.dta"
	rename origin mktorigin	
	rename originaptind mktoriginaptind
	rename dest mktdest	
	rename destaptind mktdestaptind
	rename tkcarrierchange mkttkcarrierchange 
	rename opcarrierchange mktopcarrierchange
	rename tkcarrier mkttkcarrier
	rename opcarrier mktopcarrier 
	rename rpcarrier mktrpcarrier
	rename passengers mktpassengers
	rename nonstopmiles mktnonstopmiles
	sort itinid mktid	
	save "market`j'_`i'.dta", replace

	* cleans ticket data
	clear
	use itinid origin originaptind roundtrip online dollarcred rpcarrier passengers itinfare bulkfare distance milesflown using "origin_and_destination_survey_db1bticket_`j'_`i'.dta"	
	rename origin tktorigin	
	rename originaptind tktoriginaptind
	rename roundtrip tktroundtrip
	rename online tktonline
	rename dollarcred tktdollarcred
	rename rpcarrier tktrpcarrier
	rename passengers tktpassengers
	rename itinfare tktitinfare
	rename bulkfare tktbulkfare
	rename distance tktdistance
	rename milesflown tktmilesflown

	* merges cleaned coupon data
	sort itinid
	merge itinid using "coupon`j'_`i'.dta"
	tab _merge
	drop _merge	

	* merges cleaned market data
	sort itinid mktid
	merge itinid mktid using "market`j'_`i'.dta"
	tab _merge
	drop _merge	

	* erases old files 
	erase "coupon`j'_`i'.dta"
	erase "market`j'_`i'.dta"

	* saves the big data set
	compress
	save "fares_`j'_`i'.dta", replace

}
}




