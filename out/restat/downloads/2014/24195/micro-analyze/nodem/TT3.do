**** tables2and3-cres.do****

clear
set mem 1300m
set more off

capture log close

log using TT3.log, replace text

*****    PART A: Create resid80.dta: This data set has for each percentile in locations 1-10 the percentile in the location 0 residual distribution   ***********************

*** This is a dummy dataset of residuals
use ../../censusmicro/census80.dta
keep Dage Dedu
keep if _n==1
expand 45001
gen resid = -2.1001 + _n/10000
drop Dage Dedu
sum resid
sort resid
save allobs.dta, replace

* Read in 1980 data and set up percentiles for residuals. *
use ../../censusmicro/census80.dta
keep if hoursamp == 1
egen beta80 = mean(lincwgb), by(size_a)
gen resid = lincwgb - beta80

keep size_a resid
* Calculate percentiles within cell 
sort size_a resid
by size_a: gen pct = _n/_N

gen pctile = int(pct*10000)/100
replace resid = round(resid,.0001)
sort size_a resid
by size_a resid: keep if _n==1
sort size_a resid
save resid80.dta, replace

keep if size_a==0
drop size_a
rename pct pct0
rename pctile pctile0
sort resid
gen dpctile0 = pctile0[_n+1]-pctile0
gen dresid = resid[_n+1]-resid
gen last = _n==_N
merge resid using allobs.dta
**should be 2 or 3
drop _merge

sort resid
***Interpolate Percentiles for the gaps 
replace pct0 = pct0[_n-1] if pct0==.
replace dpctile0 = dpctile0[_n-1] if dpctile0==.
replace dresid = dresid[_n-1] if dresid==.
replace last = last[_n-1]

replace pctile0 = pctile0[_n-1]+dpctile0/(dresid*10000) if pctile0==.
*** These are below the min
replace pctile0 = 0 if pctile0==.
*** These are above the max
replace pctile0 = 100 if last==1 & last[_n-1]==1 
replace pct0 = 0 if pct0==.
drop last dresid dpctile0

expand 11 
sort resid
by resid: gen size_a = _n-1

sort size_a resid
merge size_a resid using resid80.dta
tab size_a _merge
** these are residual values not observed in the data
drop if _merge==1
drop _merge

*** Get rid of repeated pctiles
sort size_a pctile pct
by size_a pctile: keep if _n==1

*** Fill in missing pctiles: Note these are mostly because of repeated values of resid of up to a 5.5 percentage point rage *******
sort  size_a pctile pct
by size_a: gen first = (_n==1)
by size_a: gen last = (_n==_N)
by size_a: gen expvar = round((pctile[_n+1]-pctile)*100)
replace expvar = expvar+round(pctile*100) if first==1
replace expvar = 10001-round(pctile*100) if last==1
by size_a: gen dpctile0 = pctile0[_n+1]-pctile0
by size_a: gen dpctile = pctile[_n+1]-pctile

expand expvar
** Interpolate pctile0 for these added observations
sort size_a pctile pct
by size_a pctile: replace pctile0 = pctile0[1]+(_n-1)*dpctile0/_N if first==0 & last==0

by size_a pctile: gen ref = round(_N-100*dpctile)+1
by size_a pctile: replace pctile0 = pctile0[ref]+(_n-ref)*dpctile0/(_N-ref+1) if first==1
by size_a pctile: replace pctile0 = pctile0[1]+(_n-1)*0.01 if last==1
** Fill in to iterate pctile by 0.01
sort size_a pctile pctile0
by size_a pctile: replace pctile = pctile[1]+_n/100-.01 if _n>1 & first==0
sort size_a pctile pctile0
by size_a pctile: replace pctile = _n/100-.01 if first==1
*** At the ends of the distribution tails, interpolation can be wrong
replace pctile0 = 0 if pctile0<0
replace pctile0 = 100 if pctile0>100

replace pctile = round(pctile,0.01)
** Interpolations from above often generate increments other than 0.01
replace pctile0 = round(pctile0,0.01)

keep size_a pctile pctile0 
sort size_a pctile0
save resid80.dta, replace

use ../../censusmicro/census80.dta
keep if hoursamp == 1
egen beta80 = mean(lincwgb), by(size_a)
sort size_a
by size_a: keep if _n==1
sort size_a
gen diff=beta80-beta80[1]
keep size_a diff
save beta80,replace


**********************************************************************
***** PART B: Create temp.dta (1980, 1990, 2000, 2007) ***************
***** This has the inputs needed to do the quantity adjustments ******

capture program drop getshr
program define getshr

clear
use ../../censusmicro/census`1'.dta

keep if hoursamp == 1

* Add weights for 1980. *
if `1' == 80 {
   gen perwt = 1
}

**** thetaXX is the population share of each age-educ-size cell. ****
egen totwt = sum(perwt)
egen jwt = sum(perwt), by(size_a)
gen theta`1' = jwt/totwt

/**** betaXX is the weighted average log-wage in each age-educ-size cell. ****/
egen beta`1' = sum(perwt*lincwgb/jwt), by(size_a)

/* For each age-educ-size cell, keep the population share (QUANTITY) and average wage (PRICE). */
collapse (mean) theta`1' beta`1' [aw=perwt], by(size_a)

if `1' ~= 80 {
	sort size_a 
   	merge size_a using temp.dta
	tab _merge
	drop _merge
}

if "`1'" == "07" {
	gen theta80in80 = theta80
 	gen theta80in90 = theta80
 	gen theta80in00 = theta80
	gen theta80in07 = theta80
	keep size_a theta* beta*
}

sort size_a
save temp.dta, replace

end

getshr 80
getshr 90
getshr "00"
getshr "07"


capture program drop cbeta
program define cbeta

clear
use ../../censusmicro/census`1'.dta
keep if hoursamp == 1

/* Add weights for 1980. */
if `1' == 80 {
   gen perwt = 1
}

egen jwt = sum(perwt), by(size_a)
egen beta0 = sum(perwt*lincwgb/jwt), by(size_a)
sort size_a 
by size_a: keep if _n==1
keep size_a beta0

* first adjustment
gen cbeta0b=beta0 if size_a==0
replace cbeta0b=cbeta0b[_n-1] if cbeta0b[_n-1]~=.
merge size_a using beta80.dta
drop _merge
replace cbeta0b=cbeta0b+diff

sort size_a
merge size_a using temp.dta
drop _merge
sort size_a
egen tot_a=sum(theta80in`1')

* second adjustment
egen cbeta0a=sum(beta0*theta80in`1'/tot_a)
egen diff2=sum(diff*theta80in`1'/tot_a)

replace cbeta0a=cbeta0a+diff-diff2

sort size_a
keep size_a cbeta*
save cbeta`1'.dta, replace

end

cbeta 80
cbeta 90
cbeta "00"
cbeta "07"


****************************************************************************************************
***** PART C: Create cfact`1'.dta 
***** This data set has counterfactual residuals in each year ****

capture program drop cfact
program define cfact

clear
use ../../censusmicro/census`1'.dta

keep if hoursamp == 1

* Add weights for 1980. *
if `1' == 80 {
   gen perwt = 1
}

****************************************************************************************************

* Keep only location 0 observations. Counterfactuals are built entirely off of this distribution. 
keep if size_a == 0

egen jwt = sum(perwt)
egen beta0 = sum(perwt*lincwgb/jwt)
gen resid = lincwgb - beta0

sort resid
gen pct0 = sum(perwt/jwt)

keep resid pct0

*** Create 1 obs per percentile by 0.01 incrememnts within x
gen pctile0 = int(pct0*10000)/100
sort pctile0 pct0
by pctile0: keep if _n==1

*** Fill in missing pctiles
sort pctile0
gen first = (_n==1)
gen last = (_n==_N)
gen expvar = round((pctile0[_n+1]-pctile0)*100)
gen dresid = resid[_n+1]-resid
gen dresidlag = dresid[_n-1]
gen dpctile0 = pctile0[_n+1]-pctile0
gen Nlag = round((pctile-pctile[_n-1])*100)
replace expvar = expvar+round(pctile0*100) if first==1
replace expvar = 10001-round(pctile0*100) if last==1

expand expvar
sort pctile0
**Interpolate residuals
by pctile0: replace resid = resid+(_n-1)*dresid/_N if first==0 & last==0
by pctile0: gen ref = round(_N-dpctile0*100)+1
by pctile0: replace resid = resid+(_n-ref)*dresid/(_N-ref+1) if first==1
by pctile0: replace resid = resid+(_n-1)*dresidlag/Nlag if last==1
**Fill out missing percentiles
by pctile0: replace pctile0 = pctile0[1]+_n/100-.01 if _n>1 & first==0
sort pctile0
by pctile0: replace pctile0 = _n/100-.01 if first==1
replace pctile0 = round(pctile0,0.01)

expand 11
sort pctile0
by pctile0: gen size_a = _n-1

sort size_a pctile0
merge size_a pctile0 using resid80.dta
**these are pctiles without matches from 1980
drop if _merge==1
drop _merge

rename resid cresid

** ReNormalize and Recenter counterfactual distributions to be mean 0

sort size_a pctile cresid 
replace pctile = pctile/100
by size_a: gen dcdf = (pctile-pctile[_n-1])
by size_a: gen pdf = (pctile-pctile[_n-1])/.0001
by size_a: replace dcdf = pctile if _n==1
by size_a: replace pdf = pctile/.0001 if _n==1
replace pdf=0 if pdf==.
replace dcdf=0 if dcdf==.
egen mncresid = sum(cresid*dcdf), by(size_a)
sum mncresid
replace cresid = cresid-mncresid

sort size_a pctile cresid 
merge size_a using temp.dta
drop _merge

sort size_a pctile cresid 
merge size_a using cbeta`1'
tab _m
drop _m

sort size_a pctile cresid 

save cwage`1'.dta, replace

end

cfact 80
cfact 90
cfact 00
cfact 07

****************************************************************************************************


****************************************************************************************************


***** PART E: tables 3 column 3  *****



****************************************************************************************************

capture program drop output
program define output


clear
use cwage`1'.dta

gen year = 1900 + `1'
replace year = 2000 + `1' if year < 1950
gen pdf_ccq=pdf*theta80in`1'/10000


* counterfactual wages
gen cwage_b=cresid+cbeta0b
gen cwage_a=cresid+cbeta0a


sort cwage_b pctile
egen Mb = sum(cwage_b*pdf_ccq)
egen Vb = sum(((cwage_b-Mb)^2)*pdf_ccq)
gen cdf = sum(pdf_ccq)
gen q10 = cwage_b if cdf>=.1 & cdf[_n-1]<.1
egen Qb10 = max(q10)
gen q50 = cwage_b if cdf>=.5 & cdf[_n-1]<.5
egen Qb50 = max(q50)
gen q90 = cwage_b if cdf>=.9 & cdf[_n-1]<.9
egen Qb90 = max(q90)
drop cdf q10 q50 q90

sort cwage_a pctile
egen Ma = sum(cwage_a*pdf_ccq)
egen Va = sum(((cwage_a-Ma)^2)*pdf_ccq)
gen cdf = sum(pdf_ccq)
gen q10 = cwage_a if cdf>=.1 & cdf[_n-1]<.1
egen Qa10 = max(q10)
gen q50 = cwage_a if cdf>=.5 & cdf[_n-1]<.5
egen Qa50 = max(q50)
gen q90 = cwage_a if cdf>=.9 & cdf[_n-1]<.9
egen Qa90 = max(q90)
drop cdf q10 q50 q90

sort year 
by year: keep if _n==1

* Residual Prices and Quantities
gen Qa5010 = Qa50-Qa10 
gen Qa9050 = Qa90-Qa50
gen Qb5010 = Qb50-Qb10 
gen Qb9050 = Qb90-Qb50

keep year V* Qa5010 Qa9050 Qb5010 Qb9050

if `1' ~= 80 {
	append using final_w.dta
}
sort year 
save final_w.dta, replace

end

output 80
output 90
output 00
output 07


l


****************************************************************************************************


log close
