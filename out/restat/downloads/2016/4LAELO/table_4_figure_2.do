*****************************************************************************
* table_4_figure_2.do
* Byrne, Kovak, and Michaels - REStat
* Quality-Adjusted Price Measurement
*
* Estimates regressions documenting closing price gaps within technology
* between China and Taiwan, and presents resuls in Table 4 and Figure 2.
*
*****************************************************************************

set more off
capture log close
clear
clear matrix

log using table_4_figure_2.txt, text replace

use wafer, clear

rename priceperwafer pw 
generate w=waferspurchased/1000
generate lnw=ln(w)

* keep china and taiwan
keep if inlist(loc,1,8) 

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

* collapse to the technology, quarter, location level
collapse (mean) pw metallayers polylayers masklayers epitax lnw (rawsum) weight ///
         [aw=waferspurchased], by(wafer line quarter loc)
reshape wide pw metallayers polylayers masklayers epitax lnw weight, ///
        i(wafer line quarter) j(loc)

* calculate price and layer etc. gaps by technology and quarter
gen dpw = pw1/pw8
gen dmetallayers = metallayers1/metallayers8
gen dpolylayers = polylayers1/polylayers8
gen dmasklayers = masklayers1/masklayers8
gen depitax = epitax1/epitax8
replace depitax = 0 if depitax >= .
gen dlnw = lnw1/lnw8

* calculate weight by technology and quarter
gen weight = weight1 + weight8

*****************************************
* Entry time measures

sort wafer line
merge n:1 wafer line using last_entry
keep if _merge == 3 // drops technologies without Chinese entry or not in data
drop _merge

gen entry_time = quarter - last_entry
sum entry_time
sum dpw if entry_time < 0 // better be no observations - confirmed
sum entry_time if dpw < .
keep if last_entry < . & entry_time >= 0 & dpw < .

*****************************************
* calculate quarterly and yearly average price gaps

bysort entry_time: egen qtravg = mean(dpw)
gen entry_yr = floor((entry_time-1)/4)
bysort entry_yr: egen yravg = mean(dpw)
replace yravg = . if !(mod(entry_time,4)==0)

*****************************************
* regressions

egen tech = group(wafer line)
tab tech

* (1) linear trend, no controls
reg dpw entry_time i.tech, robust
outreg2 using table_4.xls, replace

* (2) linear trend with controls
reg dpw entry_time dmetallayers dpolylayers dmasklayers depitax dlnw i.tech, robust
outreg2 using table_4.xls, append

* (3) quadratic trend, no controls
gen entry_time_sq = entry_time^2
reg dpw entry_time entry_time_sq i.tech, robust
outreg2 using table_4.xls, append

* (4) quadratic trend with controls
reg dpw entry_time entry_time_sq dmetallayers dpolylayers dmasklayers depitax dlnw i.tech, robust
outreg2 using table_4.xls, append
matrix Var = e(V)

* Construct quadratic prediction for graph
margins, at((mean) _all entry_time==0 entry_time_sq==0) // predicted value gives the offset for the quadratic prediction
matrix A = r(b)
local offset = A[1,1]
disp `offset'
matrix V = r(V)
gen quadratic_prediction = entry_time*_b[entry_time] + entry_time_sq*_b[entry_time_sq] + `offset'
gen quadratic_se = sqrt( entry_time^2 * Var[1,1] + entry_time_sq^2 * Var[2,2] ///
						+ 2*entry_time*entry_time_sq*Var[2,1] )
scalar se_mult = 1.645
gen quadratic_ci1 = quadratic_prediction + se_mult*quadratic_se
gen quadratic_ci2 = quadratic_prediction - se_mult*quadratic_se
				   
*****************************************
* Data underlying vintage figure (Figure 2)

keep dpw entry_time wafer line qtravg quadratic*

* output values for 200mm 180nm technology and within-technology quadratic fit
preserve
keep if wafer==200 & line==180
keep wafer line dpw entry_time
outsheet using figure_2_200_180.csv, comma names replace
restore

* output values for  cross-technology average
collapse (median) qtravg quadratic*, by(entry_time)
outsheet using figure_2_avg_quad.csv, comma names replace

		 
log close
