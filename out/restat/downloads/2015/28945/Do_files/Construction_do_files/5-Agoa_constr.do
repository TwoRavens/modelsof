*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs the AGAO shock used in Berman and Couttenier (2014)												  *
* This version: nov. 29, 2013																								  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
**************************************************************************************************
**************************************************************************************************
*D - COMPUTE AGAO EXPOSURE ***********************************************************************
**************************************************************************************************
**************************************************************************************************
*
********************************
* COUNTRY-SPECIFIC EXPORTS HS4 *
********************************
*
cd "$trade"
*
forvalues x=1989(1)2007{
use comtrade\baci`x', clear
drop if year==.
destring exp, replace force
rename exp code
sort code
merge code using comtrade\country_codes_iso, nokeep
tab _merge
tab iso3 if _merge == 2
collapse (sum) trade, by(hs6 iso3 year)
save comtrade\temp`x', replace
}
use comtrade\temp1989, clear
forvalues x=1990(1)2007{
append using comtrade\temp`x'
}
sort hs6 year
forvalues x=1989(1)2007{
erase comtrade\temp`x'.dta
}
destring hs6, replace force
sort iso3 hs6 year
*

rename iso3 iso_o
sort iso_o
cd "$Output_data"
save export_hs6_all, replace
*
*************************
* AGOA PRODUCT COVERAGE *
*************************
*
clear
insheet using "$Data\agoa\hts_8_agoa.txt", tab
rename digithtscode hts8
tostring hts8, replace
*
replace hts8 = "0"+hts8 if length(hts8)==7
replace hts8 = "00"+hts8 if length(hts8)==6
g hs6        = substr(hts8,1,6)
*
destring hs6, replace force
sort hs6
g test=1
collapse (sum) test, by(hs6)
drop test
save "$Data\agoa\agoa_hs6", replace
*
*************************
* Merge with trade data *
*************************
*
use "$Output_data\export_hs6_all", clear
*
sort iso_o
merge iso_o using "$Data\agoa\year_agoa", nokeep
tab _merge
drop _merge
*
replace year_agoa = 2020 if year_agoa==.
sort hs6
merge hs6 using "$Data\agoa\agoa_hs6", nokeep
tab _merge
g agoa_product=(_merge==3)
keep  year hs6 trade iso_o year_agoa agoa_product
sort iso_o hs6 year
tab agoa
*
***********************************************
* Share of trade exposed to AGOA (since 1990) *
***********************************************
*
keep if year > 1990
drop if year >= year_agoa
*
bys iso_o: egen trade_iso         = sum(trade) if agoa_product!=.
bys iso_o: egen temp              = sum(trade) if agoa_product==1
bys iso_o: egen trade_iso_agoa    = mean(temp)
drop temp
*
g share_agoa                      = trade_iso_agoa/trade_iso
*
bys iso_o: sum share_agoa
drop trade_iso* 
sort iso_o hs6 year
*
collapse (mean) share_agoa year_agoa, by(iso_o)
*
rename iso_o iso3
sort iso3
save "$Output_data\share_agoa", replace
*
erase "$Data\agoa\agoa_hs6.dta"
erase "$Output_data\export_hs6_all.dta"
*
