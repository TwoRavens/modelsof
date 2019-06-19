/*	Written by Andy Cohn, March 09
 This program makes a Stata dataset of the Imbs et al 2005 QJE data sectoral price data
	according to BGW conventions
	There are 11 European countries vs. US (numeraire)
	prices in the raw files are in $ terms, and price differentials are computed as log difference
	i.e q_usd=log(price European country/price US)
	to get nominal prices, note 
	q_usd = p(ij) - s(ij) where s(ij) is log price of the dollar
*/


clear
capture log close
set more off
set mem 700m
set varabbrev off
capture program drop _all
set maxvar 32000
version 10

global programpath "P:\BerginGlickWu Replication\data_creation\programs"
global outpath1 "P:\BerginGlickWu Replication\data_creation\datasets"
global datapath1 "P:\BerginGlickWu Replication\data_creation\original\ImbsRawdata"

cd "$programpath"

local pricedata_eu 		"prices_lc.csv"
local pricedata_us		"US_prices.csv"
local xrdata			"xrdata.csv"

** Countries: Belgium, Germany, Denmark, Italy, Ireland, France, Germany, Netherlands, Portugal, Finland, United Kingdom, United States
local countrylist		 be de dk es it ie fr gr nl pt fl uk us
tempfile tomerge
tempfile xr

*****************************************************************************
*** Insheeting xr data, creating date variable, and reshaping. Merged in below
*** Note currency is dollar price, i.e. $/pound
insheet using "$datapath1/`xrdata'", comma names clear
drop if code == ""									// Dropping blank rows
gen date2 = date(code, "MDY")								// Generating date variable
gen mo = month(date2)
gen yr = year(date2)
gen date = ym(yr, mo)
format date %tm
drop code date2 mo yr
gen us = 1											// Need US exchange rate with itself
sort date
foreach country of local countrylist {
	rename `country' xr_`country'
}
save "`xr'", replace

*****************************************************************************
*** First insheeting US data, creating date variable. Then doing same with EU data and merging
insheet using "$datapath1/`pricedata_us'", comma names clear
drop if code == ""									// Dropping blank rows
gen date2 = date(code, "MDY")								// Generating date variable
gen mo = month(date2)
gen yr = year(date2)
gen date = ym(yr, mo)
format date %tm
drop code date2 mo yr
sort date
save "`tomerge'", replace


insheet using "$datapath1/`pricedata_eu'", comma names clear
drop if code == ""									// Dropping blank rows
gen date2 = date(code, "MDY")								// Generating date variable
gen mo = month(date2)
gen yr = year(date2)
gen date = ym(yr, mo)
format date %tm
drop code date2 mo yr
sort date

merge date using "`tomerge'", unique
tab _merge
assert _merge == 3
drop _merge

*****************************************************************************
** Now creating log price differentials : q_usd (England) = log(USDprice England/USDprice US)

** First reshaping along sector
reshape long `countrylist', i(date) j(sector)

*** Merging in XR data
sort date sector
merge date using "`xr'"
tab _merge
keep if _merge==3
drop _merge


foreach country of local countrylist {	
	replace `country' = log(`country'/us)				// Log difference of price wrt US
	rename `country' p_`country'
	replace xr_`country' = log(xr_`country')				// Log of nominal exchange rate
	rename xr_`country' s_`country'
}

** Reshaping countries long
reshape long p_ s_, i(date sector) j(country) string
sort country sector date
egen sectorid = group(sector)

*****************************************************************************

drop if country == "ie" | country=="us"	// Dropping Ireland (no data) and US (can't have pair with itself)
gen weight = 1							// Equal weights

egen pairid = group(country)
sort pairid
drop country weight
reshape wide p_ s_, i(date sector) j(pairid)
sort sector date


save "$outpath1/imbsdata_sectoral_lc_wide.dta", replace

capture log close
exit
