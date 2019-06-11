/* ImportHomescan.do */
* This imports the Homescan data but does not otherwise prepare or deflate.

/* SETUP */

/* HOUSEHOLDS */
clear
save $Externals/Calculations/Homescan/Household-Panel.dta, replace emptyok
forvalues year = 2004/$MaxYear {
	import delimited using $Nielsen/HMS/`year'/Annual_Files/panelists_`year'.tsv, clear delimiter(tab)
	
	drop type_of_residence *_occupation scantrack_* dma_descr /// *_employment
		kitchen_appliances tv_items household_internet_connection member_*_employment
	
	append using $Externals/Calculations/Homescan/Household-Panel.dta
	saveold $Externals/Calculations/Homescan/Household-Panel.dta, replace
}

compress
saveold $Externals/Calculations/Homescan/Household-Panel.dta, replace


/* TRIPS */
	* This also has total_spent if ever needed later.
forvalues year = 2004/$MaxYear { 
	import delimited using $Nielsen/HMS/`year'/Annual_Files/trips_`year'.tsv, delimiter(tab) varnames(1) clear 
	rename purchase_date datestring
	rename store_zip3 zip3
	gen purchase_date = mdy(real(substr(datestring,6,2)),real(substr(datestring,9,2)),real(substr(datestring,1,4)))
	format %td purchase_date
	keep trip_code_uc household_code purchase_date retailer_code store_code_uc zip3
	compress
	saveold $Externals/Calculations/Homescan/Trips/trips_`year'.dta, replace 
}




/* RETAILERS */
include Code/DataPrep/Homescan/GetStoreCodeListandStoreCounts.do
import delimited using $Nielsen/HMS/Master_Files/Latest/retailers.tsv, clear delimiters("\t") 
include Code/DataPrep/OtherNielsen/GetChannelTypes.do 
keep retailer_code channel_type C_* MajorChannel
compress 
saveold $Externals/Calculations/OtherNielsen/Retailers.dta, replace



/* UPC-Info */
import delimited using $Nielsen/HMS/Master_Files/Latest/products.tsv, clear delimiter(tab) bindquotes(nobind) stripquotes(yes) // These last two options are needed because there are double quotes in some of the upc names
gen byte NonFood = cond(inlist(department_code,0,7,8,9)==1 /// 0 is health&beauty (includes diet aids and vitamins); 8 is alcohol
	| inlist(product_group_code,508,2004) /// 508 is pet food, 2004 is ice.     (department_code==0 & (inlist(product_group_code,6005,6018)==0&product_module_code!=210)) | /// This code would keep diet aids and vitamins from department_code 0, but drop everything else.
	| inlist(product_module_code,1224,1448,4480) /// Drop retort pouch bags, fruit protectors, and fresh flowers
	| (product_module_code>=126&product_module_code<=236) /// Various unclassified non-food modules
	, 1,0) // Drop ice
	
drop dataset_found_uc size1_change_flag_uc // According to the manual, size1_change_uc is relevant for the RMS dataset but not needed for Homescan.
format upc %012.0f  
replace size1_units=trim(size1_units) // several extra spaces.
compress
saveold $Externals/Calculations/OtherNielsen/UPC-Info.dta, replace




/* PURCHASES */
	* Merge with the trip information to save time on data prep later
forvalues year = 2004/$MaxYear {
	import delimited using $Nielsen/HMS/`year'/Annual_Files/purchases_`year'.tsv, delimiter(tab) varnames(1) clear
	
	** Merge UPCs and immediately drop non-food transactions
	merge m:1 upc upc_ver_uc using $Externals/Calculations/OtherNielsen/UPC-Info.dta, keepusing(NonFood) keep(match master) nogen
	drop if NonFood==1
	
	** Merge trips info
	merge m:1 trip_code_uc using $Externals/Calculations/Homescan/Trips/trips_`year'.dta, keep(match master) keepusing(household_code purchase_date retailer_code store_code_uc) nogen
	
	** Get expenditures. The expend variable is final price paid net of coupon_value
	gen expend = total_price_paid-coupon_value
	
	keep upc upc_ver_uc household_code purchase_date retailer_code quantity expend store_code_uc
	compress
	saveold $Externals/Calculations/Homescan/Transactions/Transactions_`year'.dta, replace
}


/* 2004-2006 MAGNET TRANSACTIONS */
include Code/DataPrep/Homescan/DataPrep_Magnet.do 
