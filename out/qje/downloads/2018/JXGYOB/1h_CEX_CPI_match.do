****************************************************************
** This do.file builds a crosswalk from UCCs to CPI categories
****************************************************************

global root "D:\Dropbox\unequal_gains\QJE revision plan\analysis\CEX"
global rootcpi "D:\Dropbox\unequal_gains\QJE revision plan\analysis\CPI"

** 1. Finalize list of UCCs

use "$root/Processed/CEX/merged_int_all_years", clear
tab year
bysort year: distinct ucc

* draw list of UCCs to merge to BLS data
keep ucc uccname uccgroup uccclass
duplicates drop

* same UCC may have been classified to different UCC classes over time 
bysort ucc uccname uccgroup: gen dup=[_n]
keep if dup==1
drop dup 
rename uccclass uccclass_final
save "$root/Processed/CEX/ucc_list_final", replace
* we have 999 UCCs to match to BLS data

** 2. Finalize list of CPI categories to match to 
cd "D:\Dropbox\unequal_gains\QJE revision plan\analysis\CPI\"
use historical_bls_series.dta, clear
merge m:1 item_code using historical_bls_series_names.dta
keep if _merge==3
drop _merge
* keep only series for U.S. as a whole & available for full period
keep if begin_year<2005
keep if end_year>2014
keep if area_code=="0000"
order item_name series_id display_level
save available_price_series_out_of_order, replace
* then we re-created a file by hand:
** starting from file above
** we check manually the category names against those reported in the 
** "CPI Detailed Report Data for January 2017" (saved in folder -- look at the 
** tables reporting "detailed expenditures", e.g. on page 93) so that 
** we properly understand the hierarchies; we have 335 (non-mutually exclusive) 
** categories in the public CPI data 
** the final file is called "available_price_series.dta"


** 2. Finalize CPI data
** here we add yearly inflation to the file "available_price_series", from 2004 to 2015
cd "$rootcpi\Raw"

foreach x in cu.data.0.Current cu.data.1.AllItems cu.data.11.USFoodBeverage ///
cu.data.12.USHousing cu.data.13.USApparel cu.data.14.USTransportation cu.data.15.USMedical ///
cu.data.16.USRecreation cu.data.17.USEducationAndCommunication cu.data.18.USOtherGoodsAndServices ///
cu.data.20.USCommoditiesServicesSpecial {
import delimited `x'.txt, clear 
save `x'.dta, replace
}

use cu.data.0.Current.dta, clear
foreach x in cu.data.1.AllItems cu.data.11.USFoodBeverage ///
cu.data.12.USHousing cu.data.13.USApparel cu.data.14.USTransportation cu.data.15.USMedical ///
cu.data.16.USRecreation cu.data.17.USEducationAndCommunication cu.data.18.USOtherGoodsAndServices ///
cu.data.20.USCommoditiesServicesSpecial {
append using `x'.dta
}
collapse (mean) value, by(year series_id)
keep if inrange(year,2004,2015)
replace series_id=subinstr(series_id," ","",.)
merge m:1 series_id using "$rootcpi\available_price_series.dta"
keep if _merge==3
tab year
* now we have a complete time series, it is balanced by year
* and we have indeed 335 categories
gen base_value=value*(year==2004)
bysort series_id: egen base_value_final=max(base_value)
replace value=value/base_value_final
drop base_value*
drop _merge

rename value price_index_rel2004
egen id=group(series_id)
tsset id year
gen infl=price_ind/L.price_ind-1
drop id

sort hierarchical_ordering year
order hierarchical_ordering item_name price_index_rel2004 infl MainCategory Subcategory year 

* report simple summary stats to check everything is fine
sum infl, d
bysort Main: sum infl
bysort Sub: sum infl
bysort Good_or_Service: sum infl

save "$rootcpi\historical_cpi_final", replace

keep hierarchical_ordering item_name series_id MainCategory Subcategory display_level
duplicates drop 
sort hierarchical_ordering display_level
save "$rootcpi\cpi_list_final", replace

** 3. Conduct Merge CPI-CES
** the match is conducted by hand in an excel file; then we convert this to dta
import excel "$rootcpi\match_cpi_cex.xls", sheet("Sheet1") firstrow clear
save "$rootcpi/match_cpi_cex.dta", replace

** there are some duplicates UCC (with different names)
use "$rootcpi/match_cpi_cex.dta", clear
* except in one case we always matched the same ucc to just one cpi category, so we
* can just ignore the name differences
bysort ucc: gen dup=[_n]
keep if dup==1
drop dup
replace series_id=subinstr(series_id," ","",.)
save "$rootcpi/match_cpi_cex.dta", replace

** now merge data with expenditures & inflation

* a) merge crosswalk to CEX data
use "$root/Processed/CEX/merged_int_all_years", clear
merge m:1 ucc using  "$rootcpi/match_cpi_cex.dta"
keep if _merge==3 
drop _merge

* b) now compute income statistics by CPI series_id

* we do this by income quintiles like with the Nielsen data
* note that we've already dropped reporting less than 5k in income

gen income_quintile=.
* first quintile if makes below 20k
replace income_quintile=1 if income<=20000
* second quintile if makes between 20k & 40k
replace income_quintile=2 if income>20000 & income<=40000
* third quintile if makes between 40k & 60k
replace income_quintile=3 if income>40000 & income<=60000
* fourth quintile if makes between 60k & 100k 
replace income_quintile=4 if income>60000 & income<=100000
* fifth quintile if makes above 100k
replace income_quintile=5 if income>100000 

gen double spending=cost*4*finlwt21
* note: the weights finlwt21 sum up to the full population in each quarter
foreach i in 1 2 3 4 5 {
gen double spending_incq`i'=spending*(income_quintile==`i')
}

collapse (sum) spending*, by(year series_id)
merge 1:1 series_id year using "$rootcpi\historical_cpi_final"
keep if _merge==3
drop _merge
save "$rootcpi\cpi_cex_2004_2015_final", replace
