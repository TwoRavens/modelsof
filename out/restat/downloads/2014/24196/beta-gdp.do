drop _all
set more off
set logtype text
clear matrix
set virtual on
capture log close
set mem 3g
set matsize 2000

log using beta-gdp, replace

use world_child3

*************************************
***	REGRESSIONS
*************************************

/* 
run xi: regressions with -xi: reg- so we can also save r2 and compare graphs with hertz
*/

gen height100=imputed_height/100
gen beta=. 
gen sig=.
gen mean_ht=.
gen mean_infant=.

* Run country specific regressions

foreach num of numlist 1/38 {
	xi: reg infant height100 malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 urban age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.yearc if infant_exp==1 & countryid==`num', robust 
	sum height100 if e(sample)
	replace mean_ht=r(mean) if e(sample)
	sum infant if e(sample)
	replace mean_infant=r(mean) if e(sample)
	* first generate local var for z-score
	local z=_b[height100]/_se[height100]
	display `z'
	* z-dist for significance
	local p`num'=2*(1-normal(abs(`z')))
	display `p`num''
	* gen var for if significant i.e if p-value < 0.05
	replace sig=1 if `p`num''<0.05 & e(sample)
	replace sig=0 if `p`num''>0.05 & e(sample)
	replace beta=-_b[height100] if e(sample)
	}


/* note that in above code we generate beta as (-) the estimated marginal effect.
This is because infant is a negative measure of health and makes the graph more confusing
if we include estimated effects. By reversing the sign we are not changing
the relationship but we are making the graph easier to interpret to the casual reader
*/

collapse (mean) beta sig mean_ht mean_infant, by(countryid)
sort countryid

save beta-country, replace

use penn, clear

collapse (mean) lgdp, by(country)

egen countryid=group(country)

* merge in ME for plotting against avg gdp

sort countryid
merge countryid using beta-country

tab _merge

* scatter plot of avg GDP against the ME for sig and insig countries

twoway (scatter beta lgdp if sig==1, msymbol(circle)) (scatter beta lgdp if sig==0, msymbol(diamond_hollow)) (lfit beta lgdp if sig==1, lpattern(solid)) (lfit beta lgdp , lpattern(dash)), title("Intergenerational Correlation Coefficient" "Against Average GDP, by Country") subtitle("Infant Mortality") legend(order(1 "Countries with Significant Intergenerational Correlation" 2 "Countries with Insignificant Intergenerational Correlation" 3 "Countries with Significant Intergenerational Correlation" 4 "All Countries")) ytitle("Intergenerational Correlation") xtitle("Country Log GDP, average over period 1970-2000") legend(rows(4))

log close
exit