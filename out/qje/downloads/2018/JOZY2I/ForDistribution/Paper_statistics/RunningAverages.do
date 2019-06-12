** This code creates monthly running averages of the past twelve months for frequency
* and size statistics (used in Figures 15, A3 and A4).

use "working\ELImonthstats.dta", clear

sort eli year month
global obsl
global changel
global changeupl
global iqrl 
global iqrnsl
global absnsl
global absupnsl
global absdwnsl
global SDabsnsl
global pobsl 
global pobsnsl
*For each statistic, we take the observation-weighted average of the current month
*and previous 11 months, to construct a 12 month running average. 
*First, create observation weighted running sums of past 12 months for each variable
forvalues i = 0/11 {
by eli: gen pobsns`i' = pobsns[_n-`i']
by eli: gen pobs`i' = pobs[_n-`i']
by eli: gen iqrs`i' = priceiqr[_n-`i']*pobs[_n-`i']
by eli: gen iqrnss`i' = priceiqrns[_n-`i']*pobsns[_n-`i']
by eli: gen obsns`i' = obsns[_n-`i']
by eli: gen changesns`i' = changesns[_n-`i']
by eli: gen changesupns`i' = changesupns[_n-`i']
by eli: gen absnss`i' = absns[_n-`i']*changesns[_n-`i']
by eli: gen SDabsnss`i' = SDabsns[_n-`i']*changesns[_n-`i']
by eli: gen absupnss`i' = absupns[_n - `i']*changesupns[_n-`i']
by eli: gen absdwnss`i' = absdwns[_n - `i']*(changesns[_n-`i'] - changesupns[_n-`i'])
replace obsns`i' = 0 if obsns`i' == .
replace changesns`i' = 0 if changesns`i' == .
replace changesupns`i' = 0 if changesupns`i' == .
replace pobsns`i' = 0 if pobsns`i' == .
replace pobs`i' = 0 if pobs`i' == .
replace iqrs`i' = 0 if iqrs`i' == .
replace iqrnss`i' = 0 if iqrnss`i' == .
replace absnss`i' = 0 if absnss`i' == .
replace absupnss`i' = 0 if absupnss`i' == .
replace absdwnss`i' = 0 if absdwnss`i' == .
replace SDabsnss`i' = 0 if SDabsnss`i' == .
if `i' < 11 {
	global obsl $obsl  obsns`i' +
	global changel $changel changesns`i' +
	global changeupl $changeupl changesupns`i' +
	global iqrl $iqrl iqrs`i' +
	global iqrnsl $iqrnsl iqrnss`i' + 
	global absnsl $absnsl absnss`i' +
	global absupnsl $absupnsl absupnss`i' +
	global absdwnsl $absdwnsl absdwnss`i' +
	global SDabsnsl $SDabsnsl SDabsnss`i' +
	global pobsl $pobsl pobs`i' +
	global pobsnsl $pobsnsl pobsns`i' +
}
}
global obsl $obsl obsns11
global changel $changel changesns11
global changeupl $changeupl changesupns11
global iqrl $iqrl iqrs11
global iqrnsl $iqrnsl iqrnss11 
global absnsl $absnsl absnss11
global absupnsl $absupnsl absupnss11
global absdwnsl $absdwnsl absdwnss11
global SDabsnsl $SDabsnsl SDabsnss11
global pobsl $pobsl pobs11
global pobsnsl $pobsnsl pobsns11
gen changesum = $changel
gen changeupsum = $changeupl
gen obssum = $obsl
gen iqrsum = $iqrl
gen iqrnssum = $iqrnsl
gen absnssum = $absnsl
gen absupnssum = $absupnsl
gen absdwnssum = $absdwnsl
gen SDabsnssum = $SDabsnsl
gen pobssum = $pobsl
gen pobsnssum = $pobsnsl

*Next, divide by relelvant number of observations of past 12 months to construct 
*observation-weighted average
gen freq12 = changesum/obssum
gen frequp12 = changeupsum/obssum
gen freqdw12 = (changesum-changeupsum)/obssum
gen iqr12 = iqrsum/pobssum
gen iqrns12 = iqrnssum/pobsnssum
gen abs12 = absnssum/changesum
gen absup12 = absupnssum/changeupsum
gen absdw12 = absdwnssum/(changesum-changeupsum)
gen SDabs12 = SDabsnssum/changesum
replace freq12 = . if obssum == 0
replace frequp12 = . if obssum == 0
replace freqdw12 = . if obssum == 0
replace iqr12 = . if pobssum == 0
replace iqrns12 = . if pobsnssum == 0
replace abs12 = . if changesum == 0
replace absup12 = . if changeupsum == 0
replace absdw12 = . if (changesum-changeupsum) == 0
replace SDabs12 = . if changesum == 0
drop obsnsmg
by year month majgroup, sort: egen obsnsmg = sum(obssum)
keep eli year month date majgroup freq12 frequp12 freqdw12 iqr12 iqrns12 abs12 absup12 absdw12 SDabs12 weight obsnsmg
save "working\ELI12.dta", replace

*Create expenditure-weighted averages across ELI's for each major group-month
foreach var of varlist freq12 frequp12 freqdw12 iqr12 iqrns12 abs12 absup12 absdw12 SDabs12 {
local stat `var'
gen wu = weight
replace wu = . if `var' == . 
by year month majgroup (eli), sort: egen totw = sum(wu)
gen adjwght = wu/totw
by year month majgroup (eli), sort: egen `stat'mean = sum(adjwght*`var')
by year month majgroup (`var'), sort: gen `stat'sum = sum(adjwght)
by year month majgroup (`var'), sort: gen lag`stat'sum = `stat'sum[_n-1]
gen `stat'med = ((lag`stat'sum < 0.5 & lag`stat'sum != . & `stat'sum >= 0.5) | (lag`stat'sum == . & `stat'sum >= 0.5))
replace `stat'med = `var'*`stat'med
by year month majgroup (eli), sort: egen `stat'median = sum(`stat'med)
drop `stat'sum lag`stat'sum `stat'med wu totw adjwght
}
by year month majgroup, sort:  keep if _n == 1
drop if majgroup == .
keep year month  majgroup date *mean *median obsnsmg
tempfile f12
save "`f12'"

*Create average across all ELI's
use "working\ELI12.dta"
foreach var of varlist freq12 frequp12 freqdw12 iqr12 iqrns12 abs12 absup12 absdw12 SDabs12 {
local stat `var'
gen wu = weight
replace wu = . if `var' == . 
by year month (eli), sort: egen totw = sum(wu)
gen adjwght = wu/totw
by year month (eli), sort: egen `stat'mean = sum(adjwght*`var')
by year month (`var'), sort: gen `stat'sum = sum(adjwght)
by year month (`var'), sort: gen lag`stat'sum = `stat'sum[_n-1]
gen `stat'med = (lag`stat'sum < 0.5 & lag`stat'sum != . & `stat'sum >= 0.5)
replace `stat'med = `var'*`stat'med
by year month (eli), sort: egen `stat'median = sum(`stat'med)
drop `stat'sum lag`stat'sum `stat'med wu totw adjwght
}
by year month, sort: keep if _n == 1
keep year month majgroup date *mean *median
replace majgroup = 13
append using "`f12'"
drop if year == 1986 & (month == 11 | month == 12)
sort majgroup year month
save "working\Freq12.dta", replace

*Merge in major group inflation values
sort majgroup year month 
merge 1:1 majgroup year month using "working\MGinflation.dta"
sort majgroup year month
drop _merge
drop if year < 1977
save "working\Freq12.dta", replace

*Create an average for all food ELI's (combine major groups 1 and 2)
use "working\ELI12.dta", clear
keep if majgroup == 0 | majgroup == 1
by year month, sort: egen obs2 = sum(obsnsmg)
drop obsnsmg
rename obs2 obsnsmg
foreach var of varlist freq12 frequp12 freqdw12 iqr12 iqrns12 abs12 absup12 absdw12 SDabs12 {
local stat `var'
gen wu = weight
replace wu = . if `var' == . 
by year month (eli), sort: egen totw = sum(wu)
gen adjwght = wu/totw
by year month (eli), sort: egen `stat'mean = sum(adjwght*`var')
by year month (`var'), sort: gen `stat'sum = sum(adjwght)
by year month (`var'), sort: gen lag`stat'sum = `stat'sum[_n-1]
gen `stat'med = (lag`stat'sum < 0.5 & lag`stat'sum != . & `stat'sum >= 0.5)
replace `stat'med = `var'*`stat'med
by year month (eli), sort: egen `stat'median = sum(`stat'med)
drop `stat'sum lag`stat'sum `stat'med wu totw adjwght
}
by year month, sort: keep if _n == 1
keep year month majgroup date *mean *median obsnsmg
replace majgroup = 1
sort year month
*Merge in food inflation
tempfile f12
save "`f12'"
use "working\MGinflation.dta", clear
keep if majgroup == 1
sort year month
merge 1:1 year month using "`f12'"
drop _merge
drop if year < 1977
save "working\Foodfreq12.dta", replace




