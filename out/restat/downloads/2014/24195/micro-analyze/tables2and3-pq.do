**** tables2and3-pq.do****

clear
set mem 1300m
set more off

capture log close

log using tables2and3-pq.log, replace text

*****    PART A: Create resid80.dta: This data set has for each percentile in locations 1-10 the percentile in the location 0 residual distribution   ***********************

*** This is a dummy dataset of residuals
use ../censusmicro/census80.dta
keep Dage Dedu
sort Dage Dedu 
by Dage Dedu: keep if _n==1
expand 4501
sort Dage Dedu
by Dage Dedu: gen resid = -2.101 + _n/1000
sum resid
sort Dage Dedu resid
save allobs.dta, replace

* Read in 1980 data and set up percentiles for residuals. *
use ../censusmicro/census80.dta
keep if hoursamp == 1
egen beta80 = mean(lincwgb), by(Dage Dedu size_a)
gen resid = lincwgb - beta80

keep size_a Dage Dedu resid
* Calculate percentiles within cell 
sort size_a Dage Dedu resid
by size_a Dage Dedu: gen pct = _n/_N

gen pctile = int(pct*1000)/10
replace resid = round(resid,.001)
sort size_a Dage Dedu resid
by size_a Dage Dedu resid: keep if _n==1
sort size_a Dage Dedu resid
save resid80.dta, replace

keep if size_a==0
drop size_a
rename pct pct0
rename pctile pctile0
sort Dage Dedu resid
by Dage Dedu: gen dpctile0 = pctile0[_n+1]-pctile0
by Dage Dedu: gen dresid = resid[_n+1]-resid
by Dage Dedu: gen last = _n==_N
merge Dage Dedu resid using allobs.dta
**should be 2 or 3
drop _merge

sort Dage Dedu resid
***Interpolate Percentiles for the gaps 
by Dage Dedu: replace pct0 = pct0[_n-1] if pct0==.
by Dage Dedu: replace dpctile0 = dpctile0[_n-1] if dpctile0==.
by Dage Dedu: replace dresid = dresid[_n-1] if dresid==.
by Dage Dedu: replace last = last[_n-1]

by Dage Dedu: replace pctile0 = pctile0[_n-1]+dpctile0/(dresid*1000) if pctile0==.
*** These are below the min
replace pctile0 = 0 if pctile0==.
*** These are above the max
by Dage Dedu: replace pctile0 = 100 if last==1 & last[_n-1]==1 
replace pct0 = 0 if pct0==.
drop last dresid dpctile0

expand 11 
sort Dage Dedu resid
by Dage Dedu resid: gen size_a = _n-1

sort size_a Dage Dedu resid
merge size_a Dage Dedu resid using resid80.dta
tab size_a _merge
** these are residual values not observed in the data
drop if _merge==1
drop _merge

*** Get rid of repeated pctiles
sort Dage Dedu size_a pctile pct
by Dage Dedu size_a pctile: keep if _n==1

*** Fill in missing pctiles: Note these are mostly because of repeated values of resid of up to a 5.5 percentage point rage *******
sort Dage Dedu size_a pctile pct
by Dage Dedu size_a: gen first = (_n==1)
by Dage Dedu size_a: gen last = (_n==_N)
by Dage Dedu size_a: gen expvar = round((pctile[_n+1]-pctile)*10)
replace expvar = expvar+round(pctile*10) if first==1
replace expvar = 1001-round(pctile*10) if last==1
by Dage Dedu size_a: gen dpctile0 = pctile0[_n+1]-pctile0
by Dage Dedu size_a: gen dpctile = pctile[_n+1]-pctile

expand expvar
** Interpolate pctile0 for these added observations
sort Dage Dedu size_a pctile pct
by Dage Dedu size_a pctile: replace pctile0 = pctile0[1]+(_n-1)*dpctile0/_N if first==0 & last==0

by Dage Dedu size_a pctile: gen ref = round(_N-10*dpctile)+1
by Dage Dedu size_a pctile: replace pctile0 = pctile0[ref]+(_n-ref)*dpctile0/(_N-ref+1) if first==1
by Dage Dedu size_a pctile: replace pctile0 = pctile0[1]+(_n-1)*0.1 if last==1
** Fill in to iterate pctile by 0.1
sort Dage Dedu size_a pctile pctile0
by Dage Dedu size_a pctile: replace pctile = pctile[1]+_n/10-.1 if _n>1 & first==0
sort Dage Dedu size_a pctile pctile0
by Dage Dedu size_a pctile: replace pctile = _n/10-.1 if first==1
*** At the ends of the distribution tails, interpolation can be wrong
replace pctile0 = 0 if pctile0<0
replace pctile0 = 100 if pctile0>100

replace pctile = round(pctile,0.1)
** Interpolations from above often generate increments other than 0.1
replace pctile0 = round(pctile0,0.1)

keep size_a Dage Dedu pctile pctile0 
sort Dage Dedu size_a pctile0
save resid80.dta, replace


**********************************************************************
***** PART B: Create temp.dta (1980, 1990, 2000, 2007) ***************
***** This has the inputs needed to do the quantity adjustments ******

capture program drop getshr
program define getshr

clear
use ../censusmicro/census`1'.dta

keep if hoursamp == 1

* Add weights for 1980. *
if `1' == 80 {
   gen perwt = 1
}

**** thetaXX is the population share of each age-educ-size cell. ****
egen totwt = sum(perwt)
egen jwt = sum(perwt), by(Dage Dedu size_a)
gen theta`1' = jwt/totwt

/**** betaXX is the weighted average log-wage in each age-educ-size cell. ****/
egen beta`1' = sum(perwt*lincwgb/jwt), by(Dage Dedu size_a)

/* For each age-educ-size cell, keep the population share (QUANTITY) and average wage (PRICE). */
collapse (mean) theta`1' beta`1' [aw=perwt], by(Dage Dedu size_a)

if `1' ~= 80 {
	sort Dage Dedu size_a 
   	merge Dage Dedu size_a using temp.dta
	tab _merge
	drop _merge
}


if "`1'" == "07" {

**** sthetaXX is the population share of each age-educ cell. ****
	egen stheta80 = sum(theta80), by(Dage Dedu)
	egen stheta90 = sum(theta90), by(Dage Dedu)
	egen stheta00 = sum(theta00), by(Dage Dedu)
	egen stheta07 = sum(theta07), by(Dage Dedu)

**** fracXX is the share of city size within each age-educ cell. ****
* E.g., if frac80 = 0.05 for a cell with size=1, age=3, and educ=2, this means that 5% of the population with age=3 and educ=2 lives in a city with size=1. *
	gen frac80 = theta80/stheta80
	gen frac90 = theta90/stheta90
	gen frac00 = theta00/stheta00
	gen frac07 = theta07/stheta07

**** theta80inYY is the counterfactual population share of each age-educ-size cell in year YY if 
*      - the city size distribution within each age-educ cell is fixed to year 1980
*      - the age-educ distribution changes with year YY ****
	gen theta80in80 = theta80
 	gen theta80in90 = frac80*stheta90
 	gen theta80in00 = frac80*stheta00
	gen theta80in07 = frac80*stheta07

	keep size_a Dage Dedu theta* beta*
}

sort Dage Dedu size_a
save temp.dta, replace

end

getshr 80
getshr 90
getshr "00"
getshr "07"



****************************************************************************************************
***** PART C: Create cfact`1'.dta 
***** This data set has counterfactual residuals in each year ****

capture program drop cfact
program define cfact

clear
use ../censusmicro/census`1'.dta

keep if hoursamp == 1

* Add weights for 1980. *
if `1' == 80 {
   gen perwt = 1
}

****************************************************************************************************

* Keep only location 0 observations. Counterfactuals are built entirely off of this distribution. 
keep if size_a == 0

egen jwt = sum(perwt), by(Dage Dedu)
egen beta0 = sum(perwt*lincwgb/jwt), by(Dage Dedu)
gen resid = lincwgb - beta0

sort Dage Dedu resid
by Dage Dedu: gen pct0 = sum(perwt/jwt)

keep Dage Dedu resid pct0

*** Create 1 obs per percentile by 0.1 incrememnts within x
gen pctile0 = int(pct0*1000)/10
sort Dage Dedu pctile0 pct0
by Dage Dedu pctile0: keep if _n==1

*** Fill in missing pctiles
sort Dage Dedu pctile0
by Dage Dedu: gen first = (_n==1)
by Dage Dedu: gen last = (_n==_N)
by Dage Dedu: gen expvar = round((pctile0[_n+1]-pctile0)*10)
by Dage Dedu: gen dresid = resid[_n+1]-resid
by Dage Dedu: gen dresidlag = dresid[_n-1]
by Dage Dedu: gen dpctile0 = pctile0[_n+1]-pctile0
by Dage Dedu: gen Nlag = round((pctile-pctile[_n-1])*10)
replace expvar = expvar+round(pctile0*10) if first==1
replace expvar = 1001-round(pctile0*10) if last==1

expand expvar
sort Dage Dedu pctile0
**Interpolate residuals
by Dage Dedu pctile0: replace resid = resid+(_n-1)*dresid/_N if first==0 & last==0
by Dage Dedu pctile0: gen ref = round(_N-dpctile0*10)+1
by Dage Dedu pctile0: replace resid = resid+(_n-ref)*dresid/(_N-ref+1) if first==1
by Dage Dedu pctile0: replace resid = resid+(_n-1)*dresidlag/Nlag if last==1
**Fill out missing percentiles
by Dage Dedu pctile0: replace pctile0 = pctile0[1]+_n/10-.1 if _n>1 & first==0
sort Dage Dedu pctile0
by Dage Dedu pctile0: replace pctile0 = _n/10-.1 if first==1
replace pctile0 = round(pctile0,0.1)

expand 11
sort Dage Dedu pctile0
by Dage Dedu pctile0: gen size_a = _n-1

sort Dage Dedu size_a pctile0
merge Dage Dedu size_a pctile0 using resid80.dta
**these are pctiles without matches from 1980
drop if _merge==1
drop _merge

rename resid cresid

** ReNormalize and Recenter counterfactual distributions to be mean 0

sort Dage Dedu size_a pctile cresid 
replace pctile = pctile/100
by Dage Dedu size_a: gen dcdf = (pctile-pctile[_n-1])
by Dage Dedu size_a: gen pdf = (pctile-pctile[_n-1])/.001

by Dage Dedu size_a: replace dcdf = pctile if _n==1
by Dage Dedu size_a: replace pdf = pctile/.001 if _n==1

replace pdf=0 if pdf==.
replace dcdf=0 if dcdf==.

egen integ = sum(pdf/1000), by(Dage Dedu size_a)
tab integ

egen mncresid = sum(cresid*dcdf), by(Dage Dedu size_a)
sum mncresid
replace cresid = cresid-mncresid

*********************************************************************************************

sort Dage Dedu size_a pctile cresid 
merge Dage Dedu size_a using temp.dta
drop _merge

** Counterfactual Wages With No Mean Adjustment, Only Residual Adjustment 

gen cwagex = beta`1' + cresid

save cwage`1'.dta, replace

end

cfact 80
cfact 90
cfact 00
cfact 07

****************************************************************************************************


****************************************************************************************************


***** PART D: tables 2 column 2 and 3 column 2 *****

capture program drop output
program define output

clear
use cwage`1'.dta

gen pyear = 1900 + `1'
replace pyear = 2000 + `1' if pyear < 1950
gen qyear = 1900 + `2'
replace qyear = 2000 + `2' if qyear < 1950

/* We want to create all of the distribution measures, that will be listed below, given all 
   combinations of base years for prices and quantities. The program cfact is called for each of 
   these combinations, where `1' is the PRICE YEAR and `2' is the QUANTITY YEAR. */

/**** NO QUANTITY REWEIGHT (Actual) ****/
gen nowt = theta`1'

/**** FULL QUANTITY REWEIGHT (1980 Quantities) ****/
gen newt = theta`2'

/**** 1980 CITY SIZE DISTRIBUTION QUANTITY REWEIGHT (1980 City Size Profile) ****/
gen newcwt = theta80in`2'

gen pdf_noq=pdf*nowt/1000

save ttemp,replace

gen pdf_ccq=pdf*newcwt/1000

sort cresid pctile
egen Mno = sum(cresid*pdf_ccq)
egen Vno = sum(((cresid-Mno)^2)*pdf_ccq)
gen cdf = sum(pdf_ccq)
gen q10 = cresid if cdf>=.1 & cdf[_n-1]<.1
egen Q10 = max(q10)
gen q50 = cresid if cdf>=.5 & cdf[_n-1]<.5
egen Q50 = max(q50)
gen q90 = cresid if cdf>=.9 & cdf[_n-1]<.9
egen Q90 = max(q90)
drop cdf q10 q50 q90

sort pyear qyear cresid
by pyear qyear: keep if _n==1

* Residual Prices and Quantities
gen Q5010 = Q50-Q10 
gen Q9050 = Q90-Q50

keep  pyear qyear Vno Q9050 Q5010

if `1' ~= 80 | `2'~=80 {
	append using final_r.dta
}
sort pyear qyear 
save final_r.dta, replace

use ttemp,clear

gen pdf_ccq=pdf*newcwt/1000

sort cwagex pctile
egen Mno = sum(cwagex*pdf_ccq)
egen Vno = sum(((cwagex-Mno)^2)*pdf_ccq)
gen cdf = sum(pdf_ccq)
gen q10 = cwagex if cdf>=.1 & cdf[_n-1]<.1
egen Q10 = max(q10)
gen q50 = cwagex if cdf>=.5 & cdf[_n-1]<.5
egen Q50 = max(q50)
gen q90 = cwagex if cdf>=.9 & cdf[_n-1]<.9
egen Q90 = max(q90)
drop cdf q10 q50 q90

sort pyear qyear cwagex
by pyear qyear: keep if _n==1

* Residual Prices and Quantities
gen Q5010 = Q50-Q10 
gen Q9050 = Q90-Q50

keep  pyear qyear Vno Q9050 Q5010

if `1' ~= 80 | `2'~=80 {
	append using final_rw.dta
}
sort pyear qyear 
save final_rw.dta, replace

end

/* We want all PY = QY and QY = 80 runs. */
output 80 80

*output 90 80
output 90 90

*output 00 80
output 00 00

*output 07 80
output 07 07


use final_r,clear
*** Table 2, Column 2
l if pyear==qyear
*l if qyear==1980
use final_rw,clear
*** Table 3, Column 2
l if pyear==qyear
*l if qyear==1980

****************************************************************************************************
****************************************************************************************************


***** PART E: Table 3 Column 3, Table A2 Column 3  *****

*****  Create beta80.dta: slopes of the means back in the 80s

use ../censusmicro/census80.dta
keep if hoursamp == 1
egen beta80 = mean(lincwgb), by(Dage Dedu size_a)
sort Dage Dedu size_a
by Dage Dedu size_a: keep if _n==1
sort Dage Dedu size_a
by Dage Dedu: gen diff=beta80-beta80[1]
keep Dage Dedu size_a diff
sort Dage Dedu size_a
save beta80,replace



capture program drop cbeta
program define cbeta

clear
use ../censusmicro/census`1'.dta
keep if hoursamp == 1

/* Add weights for 1980. */
if `1' == 80 {
   gen perwt = 1
}

egen jwt = sum(perwt), by(Dage Dedu size_a)
egen beta0 = sum(perwt*lincwgb/jwt), by(Dage Dedu size_a)
sort Dage Dedu size_a 
by Dage Dedu size_a: keep if _n==1
sort Dage Dedu size_a
keep Dage Dedu size_a beta0

* Counterfactual means "b"
gen cbeta0b=beta0 if size_a==0
by Dage Dedu: replace cbeta0b=cbeta0b[_n-1] if cbeta0b[_n-1]~=.
merge Dage Dedu size_a using beta80.dta
tab _merge
drop _merge
replace cbeta0b=cbeta0b+diff

sort Dage Dedu size_a
merge Dage Dedu size_a using temp.dta
drop _merge
sort Dage Dedu size_a

by Dage Dedu: egen tot_a=sum(theta80in`1')
by Dage Dedu: egen tot_a2=sum(theta80)

* Counterfactual Means "a"
by Dage Dedu: egen cbeta0a=sum(beta0*theta80in`1'/tot_a)
by Dage Dedu: egen diff2=sum(diff*theta80in`1'/tot_a)
replace cbeta0a=cbeta0a+diff-diff2

* Counterfactual Means "a" using qyear=80
by Dage Dedu: egen cbeta0a2=sum(beta0*theta80/tot_a2)
by Dage Dedu: egen diff22=sum(diff*theta80/tot_a2)
replace cbeta0a2=cbeta0a2+diff-diff22

sort Dage Dedu size_a
keep D* size_a cbeta*

save cbeta`1'.dta, replace

end

cbeta 80
cbeta 90
cbeta "00"
cbeta "07"


capture program drop output2
program define output2


clear
use cwage`1'.dta

gen pyear = 1900 + `1'
replace pyear = 2000 + `1' if pyear < 1950
gen qyear = 1900 + `2'
replace qyear = 2000 + `2' if qyear < 1950

/* We want to create all of the distribution measures, that will be listed below, given all 
   combinations of base years for prices and quantities. The program cfact is called for each of 
   these combinations, where `1' is the PRICE YEAR and `2' is the QUANTITY YEAR. */

gen newcwt = theta80in`2'
gen pdf_ccq=pdf*newcwt/1000

sort Dage Dedu size_a
merge Dage Dedu size_a using cbeta`1'
tab _m
drop _m

* counterfactual wages
gen cwage_a=cresid+cbeta0a
gen cwage_b=cresid+cbeta0b
replace cwage_a=cresid+cbeta0a2 if qyear==1980

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

sort pyear qyear 
by pyear qyear: keep if _n==1

* Residual Prices and Quantities
gen Qa5010 = Qa50-Qa10 
gen Qa9050 = Qa90-Qa50
gen Qb5010 = Qb50-Qb10 
gen Qb9050 = Qb90-Qb50

keep pyear qyear V* Qa5010 Qa9050 Qb5010 Qb9050

if `1' ~= 80 | `2'~=80 {
	append using final_wab.dta
}
sort pyear qyear 
save final_wab.dta, replace

end

/* We want all PY = QY and QY = 80 runs. */
output2 80 80
*output2 90 80
output2 90 90
*output2 00 80
output2 00 00
*output2 07 80
output2 07 07

*** Table 3 Column 3
l Va Qa9050 Qa5010 if pyear==qyear
*** Table A2 Column 3
l Vb Qb9050 Qb5010

*l if qyear==1980


****************************************************************************************************
***** PART F: Residuals Quantity Adjustments Only: Table 2 Column 1 and Table A2 Column 1 

capture program drop onlyq
program define onlyq

clear
use ../censusmicro/census`1'.dta
keep if hoursamp == 1

if `1' == 80 {
   gen perwt = 1
}

egen jwt = sum(perwt), by(Dage Dedu size_a)
egen beta0 = sum(perwt*lincwgb/jwt), by(Dage Dedu size_a)
gen resid = lincwgb - beta0


sort Dage Dedu size_a
merge Dage Dedu size_a using temp.dta
drop _merge

*** City Size Adjusted Quantities
sort resid
egen Mcq = sum(resid*theta80in`1'*perwt/jwt)
egen Vcq = sum(((resid-Mcq)^2)*theta80in`1'*perwt/jwt)
gen cdf = sum(theta80in`1'*perwt/jwt)
gen q10 = resid if cdf>=.1 & cdf[_n-1]<.1
egen Q10 = max(q10)
gen q50 = resid if cdf>=.5 & cdf[_n-1]<.5
egen Q50 = max(q50)
gen q90 = resid if cdf>=.9 & cdf[_n-1]<.9
egen Q90 = max(q90)

* Residual Prices and Quantities
gen Qcq5010 = Q50-Q10 
gen Qcq9050 = Q90-Q50
drop Q50 Q10 Q90 Q50 cdf q10 q50 q90

**** Actuals
sort resid
egen M = sum(resid*theta`1'*perwt/jwt)
egen V = sum(((resid-M)^2)*theta`1'*perwt/jwt)
gen cdf = sum(theta`1'*perwt/jwt)
gen q10 = resid if cdf>=.1 & cdf[_n-1]<.1
egen Q10 = max(q10)
gen q50 = resid if cdf>=.5 & cdf[_n-1]<.5
egen Q50 = max(q50)
gen q90 = resid if cdf>=.9 & cdf[_n-1]<.9
egen Q90 = max(q90)

* Residual Prices and Quantities
gen Q5010 = Q50-Q10 
gen Q9050 = Q90-Q50

drop Q50 Q10 Q90 Q50 cdf q10 q50 q90

**** Full Quantity adjustment
sort resid
egen Mfq = sum(resid*theta80*perwt/jwt)
egen Vfq = sum(((resid-Mfq)^2)*theta80*perwt/jwt)
gen cdf = sum(theta80*perwt/jwt)
gen q10 = resid if cdf>=.1 & cdf[_n-1]<.1
egen Q10 = max(q10)
gen q50 = resid if cdf>=.5 & cdf[_n-1]<.5
egen Q50 = max(q50)
gen q90 = resid if cdf>=.9 & cdf[_n-1]<.9
egen Q90 = max(q90)

* Residual Prices and Quantities
gen Qfq5010 = Q50-Q10 
gen Qfq9050 = Q90-Q50

drop Q50 Q10 Q90 Q50 cdf q10 q50 q90

keep Vcq V Vfq Q*
keep if _n==1

if `1' == 80 | `1' == 90 {
gen year=1900+`1'
}
else {
gen year=2000+`1'
}

order year

if `1' ~= 80 {
	append using quantity.dta
}

sort year
save quantity,replace

end

qui onlyq 80
qui onlyq 90
qui onlyq 00
qui onlyq 07

*** Actual Residual Dispersion
l V Q9050 Q5010

*** Table 2 Column 1 - City Size Only Ajustment to Quantities
l Vcq Qcq9050 Qcq5010

*** Table A2 Column 1 - Full 1980 Quantity Adjustment
l Vfq Qfq9050 Qfq5010


****************************************************************************************************
***** PART G: Wages, Quantity Adjustments Only: Table 3 Column 1 and Table A2 Column 2

capture program drop onlyq3
program define onlyq3

clear
use ../censusmicro/census`1'.dta
keep if hoursamp == 1

if `1' == 80 {
   gen perwt = 1
}

egen jwt = sum(perwt), by(Dage Dedu size_a)

sort Dage Dedu size_a
merge Dage Dedu size_a using temp.dta
drop _merge

sort lincwgb 
egen Mcq = sum(lincwgb*theta80in`1'*perwt/jwt)
egen Vcq = sum(((lincwgb-Mcq)^2)*theta80in`1'*perwt/jwt)
gen cdf = sum(theta80in`1'*perwt/jwt)
gen q10 = lincwgb if cdf>=.1 & cdf[_n-1]<.1
egen Q10 = max(q10)
gen q50 = lincwgb if cdf>=.5 & cdf[_n-1]<.5
egen Q50 = max(q50)
gen q90 = lincwgb if cdf>=.9 & cdf[_n-1]<.9
egen Q90 = max(q90)

* Residual Prices and Quantities
gen Qcq5010 = Q50-Q10 
gen Qcq9050 = Q90-Q50

drop Q50 Q10 Q90 Q50 cdf q10 q50 q90


sort lincwgb
egen M = sum(lincwgb*theta`1'*perwt/jwt)
egen V = sum(((lincwgb-M)^2)*theta`1'*perwt/jwt)
gen cdf = sum(theta`1'*perwt/jwt)
gen q10 = lincwgb if cdf>=.1 & cdf[_n-1]<.1
egen Q10 = max(q10)
gen q50 = lincwgb if cdf>=.5 & cdf[_n-1]<.5
egen Q50 = max(q50)
gen q90 = lincwgb if cdf>=.9 & cdf[_n-1]<.9
egen Q90 = max(q90)

* Residual Prices and Quantities
gen Q5010 = Q50-Q10 
gen Q9050 = Q90-Q50

drop Q50 Q10 Q90 Q50 cdf q10 q50 q90

sort lincwgb
egen Mfq = sum(lincwgb*theta80*perwt/jwt)
egen Vfq = sum(((lincwgb-Mfq)^2)*theta80*perwt/jwt)
gen cdf = sum(theta80*perwt/jwt)
gen q10 = lincwgb if cdf>=.1 & cdf[_n-1]<.1
egen Q10 = max(q10)
gen q50 = lincwgb if cdf>=.5 & cdf[_n-1]<.5
egen Q50 = max(q50)
gen q90 = lincwgb if cdf>=.9 & cdf[_n-1]<.9
egen Q90 = max(q90)

* Total Prices and Quantities
gen Qfq5010 = Q50-Q10 
gen Qfq9050 = Q90-Q50

drop Q50 Q10 Q90 Q50 cdf q10 q50 q90

keep Vcq V Vfq Q*
keep if _n==1

if `1' == 80 | `1' == 90 {
gen year=1900+`1'
}
else {
gen year=2000+`1'
}

order year

if `1' ~= 80 {
	append using quantity3.dta
}

sort year
save quantity3,replace

end

qui onlyq3 80
qui onlyq3 90
qui onlyq3 00
qui onlyq3 07

*** Actual Wage Dispersion
l V Q9050 Q5010

*** Table 3 Column 1 - City Size Only Ajustment to Quantities
l Vcq Qcq9050 Qcq5010

*** Table A2 Column 2 - Full 1980 Quantity Adjustment
l Vfq Qfq9050 Qfq5010





log close
