/* DataPrep_Magnet.do */
* This file imports the original csv files for the magnet.

/* IMPORT AUXILIARY FILES FOR 2004-2006 MAGNET DATA */

** Size
insheet using $Externals/Data/Nielsen/Homescan/MagnetPurchases/product_size1_codes.csv, comma names clear
rename module product_module_code
rename code size1
save $Externals/Calculations/Homescan/Transactions/product_size1_codes.dta, replace
	

/* PREP 2004-2006 MAGNET DATA */
/* Insheet and save */
forvalues year = 2004/2006 {
	local yeartext = `year'
	if `year'==2005 {
		local yeartext = 2086
	}
	/* Import and organize variables */
	infix long household_code 1-8 str purchase_date_string 9-14 int product_module_code 15-18	///
		str brand 19-24 size1 25-31 double upc 35-46 /// multi 32-34 : Note: multi always = 1 in 2004-2006
		str upc_descr 47-76 byte quantity 77-78 price_paid_deal 79-83 ///
		price_paid_nondeal 84-88 coupon_value 89-92 str flavor 93-98 /// style 123-128
		long type 129-134 int retailer_code 147-150 str channel_id 151 using /// Hunt checked and this looks like the retailer_code used elsewhere in Homescan.
		"$Externals/Data/Nielsen/Homescan/MagnetPurchases/u`yeartext'fnl.txt", clear
		
	drop if household_code==. // for some reason stata adds empty lines.
	format household_code %12.0g
	format upc %012.0f

	gen int purchase_date=mdy(real(substr(purchase_date_string,3,2)),real(substr(purchase_date_string,5,2)),real("20"+substr(purchase_date_string,1,2)))
	format purchase_date %td
	drop purchase_date_string
	
	gen expend = cond(price_paid_deal!=.,price_paid_deal/100,price_paid_nondeal/100)-coupon_value/100

	
	/* Get percent lean */
		* Note that in the "style" codes there is "reduced fat", but there are no style codes for the modules/types that have the pct_lean gradations.
		* Only populated for product_module_code 737 (ground beef), and particular types: ground beef and other beef.
	gen pct_lean="85" if strpos(upc_descr,"80-89%") & inlist(type,30760,30761) // Need this inlist or else populates 30763, which has pct_lean="" in the nutrition facts.
	replace pct_lean="80" if strpos(upc_descr,"80%") & inlist(type,30760,30761)
	replace pct_lean="95" if strpos(upc_descr,"90%+") & inlist(type,30760,30761)

		* Assign mode for missing ground beef. The mode is 85
	replace pct_lean="85" if product_module_code==737&inlist(type,30760,30761)&pct_lean==""
	
	* For upc_descr without pct_lean value: use guesses
	replace pct_lean="85" if type==30760 & pct_lean=="" // Other option: 90
	replace pct_lean="85" if type==30761 & pct_lean=="" // Other option: 90
	replace pct_lean="84" if type==30635 & pct_lean=="" // Other option: 96
	
	/* Get and clean the lbs variable */
	include Code/DataPrep/Homescan/Clean_lbs.do 
	
	
	* gen Grams = 453.59*lbs*multi // Per the manual, the total size is weight * multi. However, these weights appear to be for the whole package. Multi is the number of units, but the lbs weight is for the whole package. Hunt spot checked this e.g. for product_module_code 720, which is rolls. Multi is often 6, but these are typically one-pound bags. And quantity is often large when multi is small, and vice versa. Katie's code agreed with Hunt.
	gen Grams = 453.59*lbs
	
	
	**RD: Create product groups for random weight products instead of lumping them all together
	
	gen product_group_code=.
	//Random Weight Raw Meat 
	replace product_group_code=9901 if  product_module_code==706 |  product_module_code==703   |  product_module_code==718 ///
	|  product_module_code==702 |  product_module_code==719 |  product_module_code==707  |  product_module_code==704 |  product_module_code==721 ///
	|  product_module_code==737 |  product_module_code==738 |  product_module_code==741  ///
	|  product_module_code==740 |  product_module_code==739 |  product_module_code==742
	
	//Random Weight Fish and Seafood
	replace product_group_code=9902 if  product_module_code==717 |  product_module_code==715
	
	//Random Weight Lunch Meat
	replace product_group_code=9903 if product_module_code==708 |  product_module_code==731 |  product_module_code==732 |  product_module_code==733 ///
	|  product_module_code==734 |  product_module_code==735  |  product_module_code==736 
	
	//Random Weight Bread 
	replace product_group_code=9904 if product_module_code==710 | product_module_code==720 | product_module_code==725 | product_module_code==723 | product_module_code==724
	
	//Random Weight Cheese & Nuts
	replace product_group_code=9905 if product_module_code==701 |  product_module_code==716 | product_module_code==730 
	
	//Random Weight Sweets
	replace product_group_code=9906 if product_module_code==713 | product_module_code==722 | product_module_code==726 | product_module_code==728 | product_module_code==729 | product_module_code==727 
	
	//Random Weight Produce
	replace product_group_code=4001 if product_module_code==711 | product_module_code==712
	
	//Random Weight Prepared
	replace product_group_code=9909 if product_module_code==709 | product_module_code==749
	
	//Randdom Weight Other 
	replace product_group_code=9910 if product_module_code==705 | product_module_code==714 
	
	
	keep household_code purchase_date product_module_code type pct_lean quantity expend Grams retailer_code product_group_code
	compress
	save $Externals/Calculations/Homescan/Transactions/MagnetTransactions_`year'.dta, replace
}









