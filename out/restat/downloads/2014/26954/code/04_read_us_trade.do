/*
The programs and data files replicate the descriptive statistics and the estimation results in the paper

	Hornok, Cec’lia and Mikl—s Koren, forthcoming. ÒPer-Shipment Costs and the Lumpiness of International Trade.Ó Review of Economics and Statistics.

Please cite the above paper when using these programs.

For your convenience, we reproduce some of the data resources here. Although all of these are widely available macroeconomic data, please check with the data vendors whether you have the right to use them.

Our software and data are provided AS IS, and we assume no liability for their use or misuse. 

If you have any questions about replication, please contact Mikl—s Koren at korenm@ceu.hu.
*/

*** Reads data from the monthly trade statistics published by the U.S. Census Bureau, merges with importer-country variables and reports shipment-level statistics. The output is data/derived/usa_export_2009_with_gravity.dta.

clear all
set more off

tempfile census units

* units of measurement come from a different file
* using the December commodity-level file is sufficient
infix str commodity 2-11 str UNIT_QY1 62-64 str UNIT_QY2 65-67 using data/census/trade/12/EXP_COMM.TXT, clear
duplicates drop commodity, force
save `units', replace

clear
save `census', replace emptyok

foreach month of any 01 02 03 04 05 06 07 08 09 10 11 12 {

	infix df 1-1 str commodity 2-11 cty_code 12-15 district 16-17 year 18-21 month 22-23 cards_mo 24-38 qty1_mo 39-53 qty2_mo 54-68 ///
			all_val_mo 69-83 air_val_mo 84-98 air_wgt_mo 99-113 ves_val_mo 114-128 ves_wgt_mo 129-143 cnt_val_mo 144-158 cnt_wgt_mo 159-173 ///
			cards_yr 174-188 qty1_yr 189-203 qty2_yr 204-218 all_val_yr 219-233 air_val_yr 234-248 air_wgt_yr 249-263 ves_val_yr 264-278 ///
			ves_wgt_yr 279-293 cnt_val_yr 294-308 cnt_wgt_yr 309-323 using data/census/trade/`month'/EXP_DETL.TXT, clear
	
	keep if cards_mo!=0
	keep if df==1  /* exclude re-exports */
	drop df district year cnt_* *_yr
	
	append using `census'
    save `census', replace
	
}

ren cty_code census_code
compress

* add units of measurement
merge m:1 commodity using `units',
drop _m

destring commodity, replace


* labeling
lab var commodity "10-digit product code"
lab var census_code "Census country code"
lab var month "Month"
lab var cards_mo "Number of shipments"
lab var qty1_mo "Traded quantity - in 1st unit of measure"
lab var qty2_mo "Traded quantity - in 2nd unit of measure"
lab var all_val_mo "Traded value"
lab var air_val_mo "Traded value, shipped by air"
lab var air_wgt_mo "Traded weight in kg, shipped by air"
lab var ves_val_mo "Traded value, shipped by vessel"
lab var ves_wgt_mo "Traded weight in kg, shipped by vessel"
lab var UNIT_QY1 "1st quantity unit of measure"
lab var UNIT_QY2 "2nd quantity unit of measure"


* drop low value shipment lines
drop if comm==9809005000   /* SHIPMENTS VALUED $20,000 AND UNDER, NOT IDENTIFIED BY KIND */
drop if comm==9880002000    /* CANADA LOW VAL SHIPMTS & SHIPMTS NOT IDEN BY KIND */
drop if comm==9880004000    /* LOW VALUE ESTIMATE, EXCLUDING CANADA */


* unit of quantity shall be in kg
replace qty1_mo = qty2_mo if (UNIT_QY1!="KG" & UNIT_QY2=="KG")
replace UNIT_QY1 = UNIT_QY2 if (UNIT_QY1!="KG" & UNIT_QY2=="KG")
drop qty2_mo UNIT_QY2
ren qty1_mo all_qty_mo
ren UNIT_QY1 unit_qty
lab var all_qty_mo "Traded quantity"
lab var unit_qty "Quantity unit of measure"


* 6-digit HS product codes
ren comm hs10
gen hs6 = int(hs10/10000)
save `census', replace

* B.E.C.
clear
tempfile bec_codes
import excel using data/unsd/hs2bec.xls, sheet("HS2007 - BEC correlation") cellrange(E7:F5058) firstrow
destring HS2007 BEC, replace
replace HS2007 = round(HS2007*100)
ren HS2007 hs6
ren BEC bec
keep if !missing(hs6,bec)
collapse (min) bec, by(hs6)
save `bec_codes'

use `census'
merge m:1 hs6 using `bec_codes', keep(match)
drop _m
drop if (bec>300 & bec<400) | (bec>30 & bec<40) | bec==7 /* drop fuels and unclassified */
lab var hs6 "6-digit HS product code"
lab var bec "BEC product code"

* keep only unique transport mode
gen ground_val = all_val - air_val - ves_val
gen byte air = air_val > 0
gen byte sea = ves_val > 0
gen byte ground = ground_val > 0
gen modes = air + sea + ground
tab modes
keep if modes==1
drop modes
gen byte mode = air+2*sea+3*ground
label var mode "Transport mode (1 Air 2 Sea 3 Ground)"
label def mode 1 "Air" 2 "Sea" 3 "Ground"
label val mode mode
drop air sea ground air_val ves_val ground_val

* importers list
merge m:1 census_code using data/census/country_list, keep(match)
drop _m


* number of shipments per entry
sum cards, detail
	* "more than half contain only one shipment"
	* "the average number of shipment is 4.8"


********************************************
* Table 2: median shipment size - U.S.
********************************************
gen importer = "_r.o.w"
* selected low per-shipment cost importers
replace importer = "1 Canada" if census_code==1220
replace importer = "2 Germany" if census_code==4280
replace importer = "3 Israel" if census_code==5081
replace importer = "4 Singapore" if census_code==5590
* selected high per-shipment cost importers
replace importer = "5 Chile" if census_code==3370
replace importer = "6 China" if census_code==5700
replace importer = "7 Russia" if census_code==4621
replace importer = "8 Venezuela" if census_code==3070
lab var importer "Selected importers"
gen ssize = all_val_mo/cards_mo
tabstat ssize [fweight = cards_mo], statistics(median) by(importer) columns(variables)
drop ssize


* saving labels
foreach v of var * {
	local l`v' : variable label `v'
      if `"`l`v''"' == "" {
		local l`v' "`v'"
		}
	}

* collapse to product-mode-country-month
collapse (sum) cards all_qty all_val air_* ves_*, by(hs10 bec census_code importer mode unit_qty month)


* collapse to product-mode-country
collapse (sum) cards all_qty all_val air_* ves_* (count) nmonth=month, by(hs10 bec census_code importer mode unit_qty)


* attach labels
foreach v of var * {
	label var `v' "`l`v''"
	}
label var nmonth "Number of months with trade"
save `census', replace


* census country code to 2-digit iso
merge m:1 census_code using data/census/country_list, keep(match)
drop _m
lab var census_code "Census country code"
lab var iso2 "2-digit ISO country code"

* add country variables
gen exporter = "USA"
merge m:1 exporter iso2 using data/derived/merged_importer_data
drop _m exporter


************************************************************
* Table 2: shipments per month, months with shipment - U.S.
************************************************************
gen n = cards/nmonth
lab var n "Number of shipments per month"
tabstat n nmonth, statistics(median) by(importer) columns(variables)
drop n


* only trade in kilogram
gen weight = all_qty_mo if unit_qty=="KG"
replace weight = air_wgt + ves_wgt if mode!=3
label var weight "Weight in kilogram"
gen byte kg = !missing(weight)
tab kg
label var kg "Trade quantity is in kilogram"
drop air_* ves_* all_qty


* LHS vars
gen lx=ln(all_val)
gen ln=ln(cards)
gen lv=lx-ln
gen lh=ln(nmonth)
gen lnh=ln-lh
gen lq=ln(weight)-ln
gen lp=lv-lq
drop if weight==0	/* for these lq and lp are not defined */


* label LHS vars
label var lx "ln total margin per importer-product"
label var ln "ln number of shipments"
label var lh "ln number of months with shipment"
label var lnh "ln average shipment number per month"
label var lv "ln value ssize"
label var lq "ln quantity ssize"
label var lp "ln price"


* clustering groups
gen hs2 = int(hs10/100000000)
lab var hs2 "2-digit HS product code"
egen cty_hs2 = group(census_code hs2)


* product-mode dummies
egen prodmode = group(hs10 mode)

saveold data/derived/usa_export_2009_with_gravity, replace
