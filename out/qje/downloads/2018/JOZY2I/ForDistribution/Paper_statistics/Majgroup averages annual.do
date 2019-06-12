*Set current directory (change to correct path)
*cd "Replication\Paper_statistics\"



use "working\ELImonthstats.dta", clear
set more off
***The following code creates a new dataset of annual ELI-level statistics ELIyearstats.dta
* by taking observation-weighted averages of the monthly values.
*Also creates a dataset of weighted averages of all the statistics by Major group-year
* (starting from the ELI-year values)
*Convert to annual observations at the ELI level

**First, create sums of variables by ELI-year to calculate 
* ELI-year averages

*Observation and price change counts
by eli year (month), sort: egen yobsns = sum(obsns)
by eli year (month), sort: egen ychangesns = sum(changesns)
by eli year (month), sort: egen ychangesupns = sum(changesupns)
by eli year (month), sort: egen yobs = sum(obs)
by eli year (month), sort: egen ychanges = sum(changes)
by eli year (month), sort: egen ysobs = sum(sizeobs)
by eli year (month), sort: egen ysobs2 = sum(sizeobsnobim)
by eli year (month), sort: egen fbiy = sum(freqnsbi*obsnsbi)
by eli year (month), sort: egen fubiy = sum(frequpnsbi*obsnsbi)
by eli year (month), sort: egen fdbiy = sum(freqdwnsbi*obsnsbi)
by eli year (month), sort: egen obsnsbiy = sum(obsnsbi)

*Price dispersion variables
by eli year (month), sort: egen dispnss = sum(pricedispns*pobsns)
by eli year (month), sort: egen disps = sum(pricedisp*pobs)
by eli year (month), sort: egen dispalls = sum(pricedispall*pobsall)
by eli year (month), sort: egen iqrnss = sum(priceiqrns*pobsns)
by eli year (month), sort: egen iqrs = sum(priceiqr*pobs)
by eli year (month), sort: egen iqralls = sum(priceiqrall*pobsall)
by eli year (month), sort: egen pobsnss = sum(pobsns)
by eli year (month), sort: egen pobss = sum(pobs)
by eli year (month), sort: egen pobsalls = sum(pobsall)
by eli year (month), sort: egen saless = sum(sales)

*Size and dispersion of price change
by eli year (month), sort: egen abss = sum(abs*changes)
by eli year (month), sort: egen SDabsnss = sum(SDabsns*changesns)
by eli year (month), sort: egen absnss = sum(absns*changesns)
by eli year (month), sort: egen absups = sum(absupns*changesupns)
by eli year (month), sort: egen absdws = sum(absdwns*(changesns-changesupns))
by eli year (month), sort: egen size1s = sum(size1*sizeobs)
by eli year (month), sort: egen size2s = sum(size2*sizeobs)
by eli year (month), sort: egen size3s = sum(size3*sizeobs)
by eli year (month), sort: egen size1s2 = sum(size1nobim*sizeobsnobim)
by eli year (month), sort: egen size2s2 = sum(size2nobim*sizeobsnobim)
by eli year (month), sort: egen size3s2 = sum(size3nobim*sizeobsnobim)


*Compute ELI-year average as sum divided by relevant number of observations
by eli year: keep if _n == 1
gen freqnsy = ychangesns/yobsns
gen frequpnsy = ychangesupns/yobsns
gen freqdwnsy = (ychangesns - ychangesupns)/yobsns
gen freqsy = ychanges/yobs
gen freqsaley = saless/pobsalls
gen freqnsbiy = fbiy/obsnsbiy
gen frequpnsbiy = fubiy/obsnsbiy
gen freqdwnsbiy = fdbiy/obsnsbiy
gen pricedispy = disps/pobss
gen pricedispnsy = dispnss/pobsnss
gen pricedispally = dispalls/pobsalls
gen priceiqry = iqrs/pobss
gen priceiqrnsy = iqrnss/pobsnss
gen priceiqrally = iqralls/pobsalls
gen absy = abss/ychanges
gen SDabsnsy = SDabsnss/ychangesns
gen absnsy = absnss/ychangesns
gen absupnsy = absups/ychangesupns
gen absdwnsy = absdws/(ychangesns - ychangesupns)
gen size1y = size1s/ysobs
gen size2y = size2s/ysobs
gen size3y = size3s/ysobs
gen size1ynobim = size1s2/ysobs2
gen size2ynobim = size2s2/ysobs2
gen size3ynobim = size3s2/ysobs2
keep eli year date freqnsy freqsy frequpnsy freqdwnsy freqsaley pricedispy ///
	pricedispnsy pricedispally priceiqry priceiqrnsy priceiqrally majgroup ///
	weight ychangesns yobsns ychanges yobs ysobs ysobs2 absy SDabsnsy absnsy absupnsy absdwnsy ///
	size1y size2y size3y size1ynobim size2ynobim size3ynobim freqnsbiy frequpnsbiy freqdwnsbiy obsnsbiy
*Adjust bi-montly frequency values to be comparable to monthly frequency
foreach x of varlist freqnsbiy frequpnsbiy freqdwnsbiy {
gen `x'adj = 1 - ((1-`x')^(0.5))
}
gen totobsnsy = yobsns + obsnsbiy
*Weighted average between (adjusted) bi-monthly and monthly frequency 
gen freqnscomby = (yobsns/totobsnsy)*freqnsy + (obsnsbiy/totobsnsy)*freqnsbiyadj
replace freqnscomby = freqnsy if freqnsbiyadj == .
replace freqnscomby = freqnsbiyadj if freqnsy == .
gen frequpnscomby = (yobsns/totobsnsy)*frequpnsy + (obsnsbiy/totobsnsy)*frequpnsbiyadj
replace frequpnscomby = frequpnsy if frequpnsbiyadj == .
replace frequpnscomby = frequpnsbiyadj if frequpnsy == .
gen freqdwnscomby = (yobsns/totobsnsy)*freqdwnsy + (obsnsbiy/totobsnsy)*freqdwnsbiyadj
replace freqdwnscomby = freqdwnsy if freqdwnsbiyadj == .
replace freqdwnscomby = freqdwnsbiyadj if freqdwnsy == .
save "working\ELIyearstats.dta", replace


**The below constructs a dataset "Mgavgsy.dta" of summary statistics by major group
*Calculate summary statistics by major group
*Variable names above had included "ns" to denote variables computed only with non-sale
*observations. This is dropped below, as almost all the variables that we work with
*exclude sales
rename freqnsy freqy
rename frequpnsy frequpy
rename freqdwnsy freqdwy
rename absy abssaley
rename SDabsnsy SDabsy
rename absnsy absy
rename absupnsy absupy
rename absdwnsy absdwy
rename freqnscomby freqcomby
rename frequpnscomby frequpcomby
rename freqdwnscomby freqdwcomby
*Create weighted mean and weighted median for each variable by major group-year
foreach var of varlist freqy freqsy frequpy freqdwy freqsaley abssaley SDabsy absy ///
	absupy absdwy size1y size2y size3y size1ynobim size2ynobim size3ynobim ///
	 freqcomby frequpcomby freqdwcomby priceiqrally priceiqrnsy {
local stat `var'
gen wu = weight
replace wu = . if `var' == . 
by year majgroup (eli), sort: egen totw = sum(wu)
gen adjwght = wu/totw
by year majgroup (eli), sort: egen `stat'mean = sum(adjwght*`var')
by year majgroup (`var'), sort: gen `stat'sum = sum(adjwght)
by year majgroup (`var'), sort: gen lag`stat'sum = `stat'sum[_n-1]
gen `stat'med = ((lag`stat'sum < 0.5 & lag`stat'sum != . & `stat'sum >= 0.5) | (lag`stat'sum == . & `stat'sum >= 0.5))
replace `stat'med = `var'*`stat'med
by year majgroup (eli), sort: egen `stat'median = sum(`stat'med)
drop `stat'sum lag`stat'sum `stat'med wu totw adjwght
}
by year majgroup, sort: gen nm = (_n == 1)
keep if nm == 1
drop if majgroup == .
keep year majgroup date *mean *median
save "working\Mgavgsy.dta", replace
use "working\ELIyearstats.dta", clear

*Calculate averages across all ELI's (this will be major group 13)
rename freqnsy freqy
rename frequpnsy frequpy
rename freqdwnsy freqdwy
rename absy abssaley
rename SDabsnsy SDabsy
rename absnsy absy
rename absupnsy absupy
rename absdwnsy absdwy
rename freqnscomby freqcomby
rename frequpnscomby frequpcomby
rename freqdwnscomby freqdwcomby
foreach var of varlist freqy freqsy frequpy freqdwy freqsaley abssaley SDabsy absy ///
	absupy absdwy size1y size2y size3y size1ynobim size2ynobim size3ynobim ///
	freqcomby frequpcomby freqdwcomby priceiqrally priceiqrnsy {
local stat `var'
gen wu = weight
replace wu = . if `var' == . 
by year (eli), sort: egen totw = sum(wu)
gen adjwght = wu/totw
by year (eli), sort: egen `stat'mean = sum(adjwght*`var')
by year (`var'), sort: gen `stat'sum = sum(adjwght)
by year (`var'), sort: gen lag`stat'sum = `stat'sum[_n-1]
gen `stat'med = ((lag`stat'sum < 0.5 & lag`stat'sum != . & `stat'sum >= 0.5) | (lag`stat'sum == . & `stat'sum >= 0.5))
replace `stat'med = `var'*`stat'med
by year (eli), sort: egen `stat'median = sum(`stat'med)
drop `stat'sum lag`stat'sum `stat'med wu totw adjwght
}
keep if year ~= year[_n-1]
replace majgroup = 13
keep year majgroup date *mean *median
append using "working\Mgavgsy.dta"
sort majgroup year
drop if year == 1976
save "working\Mgavgsy.dta", replace


*The code below constructs a dataset of weighted quantiles for the distribution of 
* average absolute price change across ELIs. It takes the average absolute price 
* change by ELI, and for each year computes weighted quantiles. This is used in 
* Figure A2 in the paper

use "working\ELIyearstats.dta", clear
local stat absnsy
local var `stat'
*Construct weighted quantiles
gen wu = weight
replace wu = . if `var' == . 
by year (eli), sort: egen totw = sum(wu)
gen adjwght = wu/totw
by year (`var'), sort: gen `stat'sum = sum(adjwght)
by year (`var'), sort: gen lag`stat'sum = `stat'sum[_n-1]
gen `stat'p10 = ((lag`stat'sum < 0.1 & lag`stat'sum != . & `stat'sum >= 0.1) | (lag`stat'sum == . & `stat'sum >= 0.1))
replace `stat'p10 = `var'*`stat'p10
by year (eli), sort: egen `stat'q10 = sum(`stat'p10)
gen `stat'p25 = ((lag`stat'sum < 0.25 & lag`stat'sum != . & `stat'sum >= 0.25) | (lag`stat'sum == . & `stat'sum >= 0.25))
replace `stat'p25 = `var'*`stat'p25
by year (eli), sort: egen `stat'q25 = sum(`stat'p25)
gen `stat'med = ((lag`stat'sum < 0.5 & lag`stat'sum != . & `stat'sum >= 0.5) | (lag`stat'sum == . & `stat'sum >= 0.5))
replace `stat'med = `var'*`stat'med
by year (eli), sort: egen `stat'median = sum(`stat'med)
gen `stat'p75 = ((lag`stat'sum < 0.75 & lag`stat'sum != . & `stat'sum >= 0.75) | (lag`stat'sum == . & `stat'sum >= 0.75))
replace `stat'p75 = `var'*`stat'p75
by year (eli), sort: egen `stat'q75 = sum(`stat'p75)
gen `stat'p90 = ((lag`stat'sum < 0.9 & lag`stat'sum != . & `stat'sum >= 0.9) | (lag`stat'sum == . & `stat'sum >= 0.9))
replace `stat'p90 = `var'*`stat'p90
by year (eli), sort: egen `stat'q90 = sum(`stat'p90)
drop `stat'sum lag`stat'sum `stat'med `stat'p10 `stat'p25 `stat'p75 `stat'p90 wu totw adjwght
by year (eli), sort: keep if _n == 1
keep year date absnsymedian absnsyq*
save "working\Abssize_qtiles.dta", replace



