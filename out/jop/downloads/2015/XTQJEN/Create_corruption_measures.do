
/* 	This do file creates the corruption measures used in the
	text. 
	
	Please see README.txt for details on the data files. 
	
	Set the line "cd" below to the directory where the 
	data files have been extracted. 
	
	All computations were done in Stata 12. 
	
	Please direct any questions, comments, or spotted errors to: 
	marko.klasnja@gmail.com
	
	*/

clear *
set more off
cd "C:/Users/`c(username)'/Dropbox/Romania/do files/disadv_JOP_replication/final"

/*--------------------------------------------------------------------------*/
/* PROCUREMENT: OPAQUE PROCEDURE */
/*--------------------------------------------------------------------------*/

use _data_gov_contracts, clear

gen date1 = award_date
	format date1 %tg
	
* clean likely errors in contract values
gen diff_value = value_RON/est_value if est_currency == "RON"
	replace diff_value = value_EUR/est_value if est_currency == "EUR"
	gen value_erorr = (diff_value > 3 & diff_value ~= .)
	drop if value_erorr == 1
	* before March 2009
	drop if value_EUR > 500000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Lucrari" & date1 < 17988
	drop if value_EUR > 75000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Servicii" & date1 < 17988
	drop if value_EUR > 75000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Furnizare" & date1 < 17988
	* March 2009-July 2010
	drop if value_EUR > 750000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Lucrari" & date1 >= 17988 & date1 < 18475
	drop if value_EUR > 100000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Servicii" & date1 >= 17988 & date1 < 18475
	drop if value_EUR > 100000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Furnizare" & date1 >= 17988 & date1 < 18475 
	* July 2010-January 2011
	drop if value_EUR > 1000000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Lucrari" & date1 >= 18475 & date1 < 18659
	drop if value_EUR > 100000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Servicii" & date1 >= 18475 & date1 < 18659
	drop if value_EUR > 125000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Furnizare" & date1 >= 18475 & date1 < 18659			
	* After January 2011
	drop if value_EUR > 4845000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Lucrari" & date1 >= 18659
	drop if value_EUR > 125000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Servicii" & date1 >= 18659
	drop if value_EUR > 125000 & announcement_type == "Anunt de atribuire la cerere de oferta" ///
		& acq_type == "Furnizare" & date1 >= 18659
		
* opaque procedure dummy
gen opaque = (procedure_type ~= "Licitatie deschisa") ///
	if announcement_type ~= "Anunt de atribuire la cerere de oferta"
replace opaque = 0 if procedure_type == "Licitatie restransa" ///
	& announcement_type ~= "Anunt de atribuire la cerere de oferta"
	
* standardize measure relative to product market
bys cpv1: egen mean_opaque = mean(opaque)
bys cpv1: egen sd_opaque = sd(opaque)
gen opaque1 = (opaque - mean_opaque)/sd_opaque
egen mean_opaque_all = mean(opaque)
egen sd_opaque_all = sd(opaque)
replace opaque1 = (opaque - mean_opaque_all)/sd_opaque_all if opaque1 == .
drop opaque
rename opaque1 opaque
bys auth_city county: egen count_opaque = count(opaque)
collapse opaque count_opaque pop_2008 pop_margin city_code_unq, ///
	by(auth_city county)

save __opaque_procedure, replace


/*--------------------------------------------------------------------------*/
/* PROCUREMENT: PRICE PER QUANTITY */
/*--------------------------------------------------------------------------*/

use _pp_direct_acquisitions, clear

* remove annuled tenders
drop if ext_number1 == "10c"
* remove duplicates among rest
duplicates tag ext_number, gen(dupl)
drop if dupl == 1 & ext_number1 == "10a"

* clean price data
foreach x in max_price closing_price {
	split `x', parse("  ")
	replace `x'1 = trim(`x'1)
	replace `x'1 = "" if `x'1 == "-"
	replace `x'1 = subinstr(`x'1, ",", "", .)
	destring `x'1, replace
	* clean up currency
	replace `x'2 = trim(`x'2)
	replace `x'2 = upper(`x'2)
	for any RON EUR USD: gen `x'_X = (`x'2 == "X") ///
		if `x'1 ~= .
	drop `x' `x'2
	rename `x'1 `x'
	}
replace closing_price = max_price if closing_price == . & max_price ~= .
drop if closing_price == .
drop if cpv1 == .
drop max_price_* closing_price_* max_price

* clean quantity data
destring quantity, replace
gen ppq = closing_price/quantity

* remove unlikely values
sum ppq, d
drop if ppq < r(p1)
drop if ppq > r(p99)

* standardize relative to product market
bys cpv1: egen mean_ppq = mean(ppq)
bys cpv1: egen sd_ppq = sd(ppq)
egen mean_ppq_all = mean(ppq)
egen sd_ppq_all = sd(ppq)
gen ppq1 = (ppq - mean_ppq)/sd_ppq
replace ppq1 = (ppq - mean_ppq_all)/sd_ppq_all if ppq1 == .

drop ppq
rename ppq1 ppq
bys auth_city county: egen count_ppq = count(ppq)
collapse ppq count_ppq pop_2008 pop_margin city_code_unq, ///
	by(auth_city county)

save __ppq, replace


/*--------------------------------------------------------------------------*/
/* PROCUREMENT: SINGLE-BIDDER CONTRACT */
/*--------------------------------------------------------------------------*/

use _data_gov_contracts.dta, clear

keep auth_city county cpv1 number_bids city_code_unq pop_2008 pop_margin
destring number_bids, replace
drop if number_bids == .

* some values of number_bids are extremely unlikely
quietly sum number_bids, d
drop if number_bids > 100
* create an indicator (single bid == 1, multiple bids = 0)
gen single_bid = (number_bids == 1)

* standardize relative to product market
bys cpv1: egen single_bid_mean = mean(single_bid)
bys cpv1: egen single_bid_sd = sd(single_bid)
gen no_bids = (single_bid - single_bid_mean)/single_bid_sd

* count the number of contracts
bys auth_city county: egen count_single_bid = count(no_bids)
* average by locality
collapse no_bids count_single_bid pop_2008 pop_margin city_code_unq, ///
	by(auth_city county)
rename no_bids single_bid
save __single_bid, replace


/*--------------------------------------------------------------------------*/
/* MISSING INFRASTRUCTURE */
/*--------------------------------------------------------------------------*/

use _infrastructure_fiscal_data, clear

* multi-level model predicting change in water/sewer infrastructure 
xtmixed pipes t_water e_total et_capital local_cop margin_local_cop ///
	floods tax_eff eq_grant roads_county vehicle_km_county gdp_county pipes_county ///
	t_water_county county_cop margin_county_cop e_total_county et_capital_county ///
	|| county_code_unq: , vce(robust)
	
* capture residuals, standardize to mean 0, sd 1
predict resid1, residuals
egen resid = std(resid1)
drop resid1
replace resid = - resid


keep city_code_unq resid pop_2008 pop_margin
rename resid infrastr

save __missing_infrastructure, replace


/*--------------------------------------------------------------------------*/
/* MERGE ALL */
/*--------------------------------------------------------------------------*/

use __opaque_procedure, clear
merge 1:1 city_code_unq using __ppq", update
drop _m
merge 1:1 city_code_unq using __single_bid", update
drop _m
merge 1:1 city_code_unq using __missing_infrastructure", update
drop _m

la var opaque "Opaque procedure"
la var single_bid "Single bidder contract"
la var ppq "Price per quantity"
la var count_opaque "Opaque procedure (# of contracts per locality)"
la var count_single_bid "Single bidder contract (# of contracts per locality)"
la var count_ppq "Price per quantity (# of contracts per locality)"
la var infrastr "Missing infrastructure"
la var pop_2008 "2008 population"

rename auth_city locality
la var locality "Locality"
la var county "County"
la var city_code_unq "Locality code"
la var pop_margin "Population margin"

order locality county city_code_unq opaque ppq single_bid count_opaque count_ppq ///
	count_single_bid infrastr

save corruption_data, replace

erase __opaque_procedure.dta
erase __ppq.dta
erase __single_bid.dta
erase __missing_infrastructure.dta
