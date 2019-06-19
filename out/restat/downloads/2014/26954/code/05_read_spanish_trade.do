/*
The programs and data files replicate the descriptive statistics and the estimation results in the paper

	Hornok, Cec’lia and Mikl—s Koren, forthcoming. ÒPer-Shipment Costs and the Lumpiness of International Trade.Ó Review of Economics and Statistics.

Please cite the above paper when using these programs.

For your convenience, we reproduce some of the data resources here. Although all of these are widely available macroeconomic data, please check with the data vendors whether you have the right to use them.

Our software and data are provided AS IS, and we assume no liability for their use or misuse. 

If you have any questions about replication, please contact Mikl—s Koren at korenm@ceu.hu.
*/

*** Reads data from the shipment-level trade statistics published by the Agencia Tributaria, merges with importer-country variables and reports shipment-level statistics. The output is data/derived/spain_export_2009_with_gravity.dta.

clear all
set more off

tempfile twelvemonths

clear
save `twelvemonths', replace emptyok

local months jan feb mar apr may jun jul aug sep oct nov dec
foreach month in `months' {
	import delimited using data/agenciatributaria/`month'.csv, clear
	
	keep if flow=="E" /* only export */
	keep month cn8 country_final transport_mode weight value_stat

	ren country_final iso2
	
	* decode mode of transport
	gen mode="air" if transport_mode==4
	replace mode="sea" if transport_mode==1
	replace mode="ground" if transport_mode==2 | transport_mode==3   /* rail, road */
	drop if transport_mode>4   /* post, fixed mechanism, inland waterway, self-propulsion, unknown */
	drop transport_mode

	gen cards=1  /* each obs is one shipment */

	* change units of measurement
	replace weight=weight/1000 /* from gramm to kg */
	replace value_stat=value_stat/100   /* from eurocents to euros */

	* drop low value shipments below EUR 2000
	drop if value_stat<2000

	* within-EU27 importers
	gen byte eu27 = (iso2=="AT" | iso2=="BE" | iso2=="BG" | iso2=="CZ" | iso2=="CY" | iso2=="DE" | iso2=="DK" | iso2=="EE" | iso2=="ES" | iso2=="FI" | iso2=="FR" | iso2=="GB" | iso2=="GR" | iso2=="HU" | iso2=="IE" | iso2=="IT" | iso2=="LT" | iso2=="LU" | iso2=="LV" | iso2=="NL" | iso2=="MT" | iso2=="PL" | iso2=="PT" | iso2=="RO" | iso2=="SI" | iso2=="SK" | iso2=="SE")

	append using `twelvemonths'
      save `twelvemonths', replace
}

* convert values from euro to US$

import delimited using data/eurostat/ert_bil_eur_m.tsv, delimiter(tab) clear 
ren v1 i
reshape long v, i(i) j(j)
gen date = real(substr(v,1,4))*100+real(substr(v,6,2)) if i=="statinfo,unit,currency\time"
egen edate = min(date), by(j)
drop date j
drop if i=="statinfo,unit,currency\time"
destring v, force replace
keep if i=="END,NAC,USD" & edate>=200901 & edate<=200912
gen month = edate-200900
drop edate
ren v usd_eur

merge 1:m month using `twelvemonths'
tab _m
drop _m
* FIXME: check formula
replace value_stat = value_stat*usd_eur
drop usd_eur
save `twelvemonths', replace


* B.E.C.
clear
tempfile bec_codes
import excel using data/eurostat/CN_BEC_2009.xls, sheet("Sheet1") firstrow
destring CN BEC, force replace
ren CN cn8
ren BEC bec
keep if !missing(cn8,bec)
drop if !missing(END)  /* drop CN codes ending before 2009 */
drop START END
save `bec_codes'

use `twelvemonths'
merge m:1 cn8 using `bec_codes', keep(match)
drop _m
drop if (bec>300 & bec<400) | bec==700 /* drop fuels and unclassified */


* label variables
lab var iso2 "ISO2 code of final destination country"
lab var cn8 "8-digit CN product code"
lab var mode "Transport mode (air, sea, ground)"
lab var month "Month of shipping"
lab var cards "Number of shipments"
lab var weight "Traded weight in kg"
lab var value_stat "Traded value in euro"
lab var eu27 "Importer is EU27 member"
lab var bec "BEC product code"


* same set of importers as for US
* importers list
merge m:1 iso2 using data/census/country_list, keep(match)
drop _m census_code
save `twelvemonths', replace


*******************************************
* Table 2: median shipment size - Spain
********************************************
gen importer = "_r.o.w"
* selected low per-shipment cost importers
replace importer = "1 France" if iso2=="FR"
replace importer = "2 Germany" if iso2=="DE"
replace importer = "3 Japan" if iso2=="JP"
replace importer = "4 USA" if iso2=="US"
* selected high per-shipment cost importers
replace importer = "5 Algeria" if iso2=="DZ"
replace importer = "6 China" if iso2=="CN"
replace importer = "7 Russia" if iso2=="RU"
replace importer = "8 South Africa" if iso2=="ZA"
lab var importer "Selected importers"
tabstat value_stat, statistics(median) by(importer) columns(variables)


* saving labels
foreach v of var * {
	local l`v' : variable label `v'
      if `"`l`v''"' == "" {
		local l`v' "`v'"
		}
	}

* collapse to product-mode-country-month
collapse (sum) cards weight value, by(cn8 bec iso2 importer mode month eu27)

* collapse to product-mode-country
collapse (sum) cards weight value (count) nmonth=month, by(cn8 bec iso2 importer mode eu27)

* attach labels
foreach v of var * {
	label var `v' "`l`v''"
	}
label var nmonth "Number of months with shipment"


* add country variables
gen exporter = "ESP"
sort iso2 cn8 mode
merge m:1 exporter iso2 using data/derived/merged_importer_data
drop _m exporter


************************************************************
* Table 2: shipments per month, months with shipment - Spain
************************************************************
gen n = cards/nmonth
lab var n "Number of shipments per month"
tabstat n nmonth, statistics(median) by(importer) columns(variables)
drop n


* LHS vars
gen lx = ln(value)
gen ln = ln(cards)
gen lh = ln(nmonth)
gen lnh = ln(cards/nmonth)
gen lv = lx-ln
gen lq = ln(weight)-ln
gen lp = lv-lq


* label LHS vars
label var lx "ln total margin per importer-product"
label var ln "ln number of shipments"
label var lh "ln number of months with shipment"
label var lnh "ln average shipment number per month"
label var lv "ln value ssize"
label var lq "ln quantity ssize"
label var lp "ln price"


* clustering groups
gen cn2 = int(cn8/1000000)
egen cty_cn2 = group(iso2 cn2)


* product-mode dummies
egen prodmode = group(cn8 mode)

saveold data/derived/spain_export_2009_with_gravity, replace
