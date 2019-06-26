cd "ENTER-YOUR-DIRECTORY-HERE/Data"

import delimited dyadic.txt, delimiter(space) clear 
bysort ccode1 year: egen degree = total(wca)
gen isolate = 0
replace isolate = 1 if degree==0
duplicates drop ccode1 year, force
keep ccode1 year degree isolate
compress
sort ccode1 year
save netdata.dta, replace

import delimited monadic.txt, delimiter(space) clear
rename ccode ccode1
merge 1:1 ccode1 year using netdata.dta, keepus(degree* isolate) keep(1 3)
drop _merge*

foreach var of varlist democ lnmilex lnmilper lncinc lngdpcap {
	replace `var' = "" if `var'=="NA"
	destring `var', replace
}

/* Generate 5-year time dummies */
gen dum8589 = 1 if year > 1984 & year < 1990
replace dum8589 = 0 if dum8589==.
gen dum9094 = 1 if year > 1989 & year < 1995
replace dum9094 = 0 if dum9094==.
gen dum9599 = 1 if year > 1994 & year < 2000
replace dum9599 = 0 if dum9599==.
gen dum0004 = 1 if year > 1999 & year < 2005
replace dum0004 = 0 if dum0004==.
gen dum0510 = 1 if year > 2004
replace dum0510 = 0 if dum0510==.

/* Get the variables in order */
tsset ccode1 year, yearly
gen DV_imports = f.lnarmsimp
gen DV_exports = f.lnarmsexp
gen DV_total = f.lnarmstot
gen lndegree = ln(degree + 1)

/* Generate an ordinal DV for comparison to SAOM */
summ DV_total if DV_total!=0
egen DV_tot_cat = cut(DV_total), at(0, `r(min)', 3.91, 6.21, 7.60, 9.90) icodes
replace DV_tot_cat = DV_tot_cat + 1

capture drop arms_imp
gen arms_imp = 1 if lnarmsimp>0 /* Flag arms importing states */

/***************************/
/* Estimate some FE models */
/***************************/

cd "ENTER-YOUR-DIRECTORY-HERE/Data"

xtreg DV_imports lndegree isolate lnmilex lnmilper lngdpcap democ lncinc dum*, fe

xtreg DV_imports lndegree lnmilex lnmilper lngdpcap democ lncinc dum* if arms_imp==1, fe
summ lndegree
margins, at(lndegree=(`r(min)'(.1)`r(max)') (median) lnmilex lnmilper lngdpcap democ lncinc dum8589 dum9094 dum9599 dum0004 dum0510)

xtreg DV_exports lndegree isolate lnmilex lnmilper lngdpcap democ lncinc dum*, fe
summ lndegree
margins, at(lndegree=(`r(min)'(.1)`r(max)') (median) isolate lnmilex lnmilper lngdpcap democ lncinc dum8589 dum9094 dum9599 dum0004 dum0510)

xtreg DV_total lndegree isolate lnmilex lnmilper lngdpcap democ lncinc dum*, fe
summ lndegree
margins, at(lndegree=(`r(min)'(.1)`r(max)') (median) isolate lnmilex lnmilper lngdpcap democ lncinc dum8589 dum9094 dum9599 dum0004 dum0510)

ologit DV_tot_cat lndegree isolate lnmilex lnmilper lngdpcap democ lncinc dum*, vce(cluster ccode)

/* To more closely match the ordinal logit model used for in-sample prediction, do this */
ologit DV_tot_cat lndegree isolate lnmilex lnmilper lngdpcap democ lncinc dum* if year > 1994, vce(cluster ccode)
