*****************************************************************************
* table_2.do
* Byrne, Kovak, and Michaels - REStat
* Quality-Adjusted Price Measurement
*
* Calculates wafer price descriptives in Table 2
*
*****************************************************************************

set more off
capture log close
clear
clear matrix

log using table_2.txt, text replace

use wafer, clear

* merge in weights
sort loc wafer line quarter
merge m:1 loc wafer line quarter using isuppli_shipments
keep if _merge == 3 // only dropping weight for bins that don't show up in GSA data
drop _merge

* apportion each bin's weight to the observations in that bin
bysort loc wafer line quarter: egen totalwafersbin = sum(waferspurchased)
gen obsfracofbin = waferspurchased / totalwafersbin // transaction's fraction of bin total
bysort loc wafer line quarter: gen binship_oneperbin = shipments if _n == 1
bysort loc wafer line quarter: egen binship = mean(binship_oneperbin)
bysort quarter: egen totalwafersqtr = sum(binship_oneperbin) // avoids multiple counts per bin
gen binfracofqtr = binship / totalwafersqtr // bin's fraction of quarterly total
gen weight = obsfracofbin * binfracofqtr

* summary stats table
gen lineold = line5 | line4 // larger than 250nm
sum priceperwafer waferspurchased metallayers masklayers polylayers ///
    wafer150 wafer200 wafer300 line12 line11 line10 line9 line8 line7 line6 ///
	lineold [aw=weight], separator(0)
bysort year: sum priceperwafer waferspurchased metallayers masklayers polylayers ///
    wafer150 wafer200 wafer300 line12 line11 line10 line9 line8 line7 line6 ///
	lineold [aw=weight], separator(0)

log close
