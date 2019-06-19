*****************************************************************************
* table_3.do
* Byrne, Kovak, and Michaels - REStat
* Quality-Adjusted Price Measurement
*
* Estimates hedonic wafer price regressions
*
*****************************************************************************

set more off
capture log close
clear
clear matrix

log using table_3.txt, text replace

use wafer, clear

gen lnpw = ln(priceperwafer)
generate w=waferspurchased/1000
generate lnw=ln(w)

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


* Table 3

* no attribute controls
reg lnpw china malaysia singapore usa ///		 
		 q2-q28 [aw=weight], cluster(quarter)
	outreg2 using table_3.xls, replace ctitle("no attribute controls")
		 
* linear attribute controls
reg lnpw china malaysia singapore usa ///
         wafer150 wafer300 line4-line6 line8-line12 ///
		 metallayers polylayers masklayers epitax lnw ///
		 q2-q28 [aw=weight], cluster(quarter)
	outreg2 using table_3.xls, append ctitle("linear attribute controls")

* flexible attribute controls
egen tech = group(wafer line)
sum tech // range of tech
sum tech if wafer==200 & line==180 // omitted tech to skip
quietly tab tech, gen(t)
reg lnpw china malaysia singapore usa ///
         t1-t6 t8-t16 ///
		 metallayers polylayers masklayers epitax lnw ///
		 q2-q28 [aw=weight], cluster(quarter)
	outreg2 using table_3.xls, append ctitle("flexible attribute controls")

* china and taiwan only
reg lnpw china ///
         t1-t6 t8-t16 ///
		 metallayers polylayers masklayers epitax lnw ///
		 q2-q28 [aw=weight] if inlist(loc,1,8), cluster(quarter)
	outreg2 using table_3.xls, append ctitle("china and taiwan only")
		
log close

