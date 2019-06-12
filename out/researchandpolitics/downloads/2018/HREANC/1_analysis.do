/*
1. baseline with controls
2. alternative state capacity measures
3. instrumental variable

Appendix
1. The number of lagged terms
2. Alternative democracy measure
3. Adding linear trends
4. GMM
5. Mechanisms
6. Subsample (excluding old democracies)
7. long-term averages
8. Initial state capacity
9. Military expenditure
*/

/*
ssc install reghdfe
ssc install xtivreg2
*/


log using statacapacity.txt, text replace

clear all
set more off
set matsize 1000



******************************************************
* 1. Main Results (for Figure 2 and Appendix Table A4)
******************************************************

cap erase output/out.xml
cap erase output/out.txt

use Data_full, clear

local nsim = 1000

* baseline with control variables
global lags = "Capacity_l1 Capacity_l2"
global covar = "lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 rivalry_l1 threat_l1 war_l1"

bootstrap  _b, rep(`nsim') seed(123) cl(ccode): reghdfe Capacity demo_l1 $lags, a(ccode year) 
outreg2 using output/out.xml, excel dec(3) nocons

bootstrap  _b, rep(`nsim') seed(123) cl(ccode): reghdfe Capacity demo_l1 lnpop_l1 elf_l1 $lags, a(ccode year) 
outreg2 using output/out.xml, excel dec(3) nocons

bootstrap  _b, rep(`nsim') seed(123) cl(ccode): reghdfe Capacity demo_l1 logGDP_l1 agri_l1 literacy_l1 $lags, a(ccode year) 
outreg2 using output/out.xml, excel dec(3) nocons

bootstrap  _b, rep(`nsim') seed(123) cl(ccode): reghdfe Capacity demo_l1 min_l1 resources_l1 $lags, a(ccode year) 
outreg2 using output/out.xml, excel dec(3) nocons

bootstrap  _b, rep(`nsim') seed(123) cl(ccode): reghdfe Capacity demo_l1 log_aid_l1 exports_l1 $lags, a(ccode year) 
outreg2 using output/out.xml, excel dec(3) nocons

bootstrap  _b, rep(`nsim') seed(123) cl(ccode): reghdfe Capacity demo_l1 rivalry_l1 threat_l1 war_l1 $lags, a(ccode year) 
outreg2 using output/out.xml, excel dec(3) nocons

bootstrap  _b, rep(`nsim') seed(123) cl(ccode): reghdfe Capacity demo_l1 $lags $covar, a(ccode year) 
outreg2 using output/out.xml, excel dec(3) nocons

** long run effect /* 0.133 (0.066) */
bootstrap longrun=(_b[demo_l1]/(1-_b[Capacity_l1]-_b[Capacity_l2])), rep(`nsim') seed(123) cl(ccode): reghdfe Capacity demo_l1 $lags $covar, a(ccode year)

xtset ccode year
xtsum Capacity

**********************************************
* Table 1. Alternative State Capacity Measure
**********************************************

cap erase output/out.xml
cap erase output/out.txt

global covar = "lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 threat_l1 rivalry_l1 war_l1"
local nsim = 1000

use Data_full, clear
sum rpe_agri
g rpe_agri_sd = (rpe_agri - r(mean))/r(sd)

sum pubcorr
g pubcorr_sd = (pubcorr - r(mean))/r(sd)


foreach var of varlist rpe_agri_sd pubcorr_sd logmilper {
   tsset ccode year
   forvalues i = 1/4 {
      bysort ccode (year): g `var'_l`i' = L`i'.`var'
      }
   xtset, clear
   bootstrap  _b, rep(`nsim') seed(123) cl(ccode): reghdfe `var' demo_l1 `var'_l1 `var'_l2, a(ccode year)
   outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons

   bootstrap  _b, rep(`nsim') seed(123) cl(ccode): reghdfe `var' demo_l1 `var'_l1 `var'_l2 $covar, a(ccode year)
   outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons 
   }

********************************
* Table 2. Instrumental Variable
********************************


use Data_full, clear
global lags = "Capacity_l1 Capacity_l2"
global covar = "lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 rivalry_l1 threat_l1 war_l1"

xtset ccode year
sort ccode year 
qui tab year, g(yr)
qui tab ccode, g(ccode)

*ssc install ivreg2
*ssc install xtivreg2
*ssc install ranktest 

cap erase output/out.xml
cap erase output/out.txt

qui areg demo_l1 $lags yr1-yr50 L.demo_wave, a(ccode)
outreg2 using output/out.xml, excel dec(3) keep(L.demo_wave) nocons

qui areg demo_l1 $lags yr1-yr50 $covar L.demo_wave, a(ccode)
outreg2 using output/out.xml, excel dec(3) keep(L.demo_wave) nocons

qui areg demo_l1 $lags yr1-yr50 $covar L.demo_wave sCapacity_l1 sCapacity_l2, a(ccode)
outreg2 using output/out.xml, excel dec(3) keep(L.demo_wave) nocons


xtivreg2  Capacity $lags yr1-yr50  (demo_l1 = L.demo_wave), fe  cl(ccode)  first
outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons

xtivreg2  Capacity $lags yr1-yr50 $covar  (demo_l1 = L.demo_wave), fe  cl(ccode)  first
outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons

xtivreg2  Capacity $lags yr1-yr50 $covar sCapacity_l1  (demo_l1 = L.demo_wave), fe  cl(ccode)  first
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 sCapacity_l1) nocons

* spacial lag also instrumented
xtivreg2  Capacity $lags yr1-yr50 $covar  (demo_l1 sCapacity_l1 = L.demo_wave sCapacity_l2), fe  cl(ccode)  first
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 sCapacity_l1) nocons


*** for plotting the first stage ***
/*
use Data_full, clear
qui areg demo i.year, a(ccode)
predict demo_res, res
qui areg demo_wave i.year, a(ccode)
predict demo_wave_res, res

keep ccode region year demo demo_res demo_wave demo_wave_res
saveold fg_firststage, replace version(12)
*/

/* ****************** Appendix **************************** */

***********************************************
** Table A5. The number of lagged terms 
***********************************************

cap erase output/out.xml
cap erase output/out.txt

global covar = "lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 rivalry_l1 threat_l1 war_l1"
use Data_full, clear

reghdfe Capacity demo_l1 $covar, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons 

reghdfe Capacity demo_l1 Capacity_l1 $covar, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

reghdfe Capacity demo_l1 Capacity_l1 Capacity_l2 $covar, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

reghdfe Capacity demo_l1 Capacity_l1 Capacity_l2 Capacity_l3 $covar, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

reghdfe Capacity demo_l1 Capacity_l1 Capacity_l2 Capacity_l3 Capacity_l4 $covar, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

**************************************************
** Table A6 Alternative democracy measure 
**************************************************

cap erase output/out.xml
cap erase output/out.txt

global lags = "Capacity_l1 Capacity_l2"
global covar = "demoyrs demo_demoyrs lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 rivalry_l1 threat_l1 war_l1"

use Data_full, clear
drop if year ==0 | year == 2010

bysort ccode (year): g polity_cleaned_l1 = polity_cleaned[_n-1]
sum polity_cleaned_l1
replace polity_cleaned_l1 = (polity_cleaned_l1 - `r(mean)')/`r(sd)'
g polity_cleaned_l1_sq = polity_cleaned_l1^2
g polity2_l1_sq = polity2_l1^2

** generate democracy duration
** for binary democracy indicator
bysort ccode (year): g demo_start = 1960 if demo_polity ==1 & year == 1960
bysort ccode (year): replace demo_start = year if demo_polity ==1 & demo_polity[_n-1]==0
bysort ccode (year): replace demo_start = demo_start[_n-1] if demo_polity ==1 & demo_start[_n-1]!=.
g demoyrs1 = 0
replace demoyrs1 = year - demo_start if demo_start!=.
** for polity_cleaned
drop demo_start
g demo_tmp = polity_cleaned>=5
bysort ccode (year): g demo_start = 1960 if demo_tmp ==1 & year == 1960
bysort ccode (year): replace demo_start = year if demo_tmp ==1 & demo_tmp[_n-1]==0
bysort ccode (year): replace demo_start = demo_start[_n-1] if demo_tmp ==1 & demo_start[_n-1]!=.
g demoyrs2 = 0
replace demoyrs2 = year - demo_start if demo_start!=.

** Democracy measured by Polity>6
g demoyrs = demoyrs1
g demo_demoyrs = demo_polity_l1 * demoyrs

reghdfe Capacity demo_polity_l1 $lags, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(demo_polity_l1) nocons //noas
unique ccode if e(sample)

reghdfe Capacity demo_polity_l1 $lags $covar, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(demo_polity_l1 $covar) nocons //noas
unique ccode if e(sample)

* Democracy measured by Polity 
drop demo_demoyrs
g demo_demoyrs = polity2_l1 * demoyrs
reghdfe Capacity polity2_l1 polity2_l1_sq $lags, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(polity2_l1*) nocons //noas
unique ccode if e(sample)

reghdfe Capacity polity2_l1 polity2_l1_sq $lags $covar, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(polity2_l1* $covar) nocons //noas
unique ccode if e(sample)

* Democracy measured by Polity (cleaned measure)
replace demoyrs = demoyrs2
drop demo_demoyrs
g demo_demoyrs = polity_cleaned_l1 * demoyrs

reghdfe Capacity polity_cleaned_l1 $lags, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(polity_cleaned_l1*) nocons //noas
unique ccode if e(sample)

reghdfe Capacity polity_cleaned_l1 $lags $covar, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(polity_cleaned_l1* $covar) nocons //noas
unique ccode if e(sample)

reghdfe Capacity polity_cleaned_l1 polity_cleaned_l1_sq $lags, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(polity_cleaned_l1*) nocons //noas
unique ccode if e(sample)

reghdfe Capacity polity_cleaned_l1 polity_cleaned_l1_sq $lags $covar, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(polity_cleaned_l1* $covar) nocons //noas
unique ccode if e(sample)


********************
** Table A7. GMM
********************

global lags = "Capacity_l1 Capacity_l2"
global covar = "lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 rivalry_l1 threat_l1 war_l1"

* ssc install xtabond2
use Data_full, clear
sort ccode year
xtset ccode year
qui tab year, g(yr)
qui tab ccode, g(ccode)

cap erase output/out.xml
cap erase output/out.txt

* using lagged terms
xtabond2 Capacity L.demo L.Capacity L2.Capacity yr1-yr50 $covar, gmm(L.Capacity, lag(2 4) eq(both)) iv(yr1-yr50 $covar, eq(level)) 
outreg2 using output/out.xml, excel dec(3) keep(L.demo L.Capacity L2.Capacity  $covar) nocons
unique ccode if e(sample)

xtabond2 Capacity L.demo L.Capacity L2.Capacity yr1-yr50 $covar, gmm(L.Capacity, lag(2 5) eq(both)) iv(yr1-yr50 $covar, eq(level)) 
outreg2 using output/out.xml, excel dec(3) keep(L.demo L.Capacity L2.Capacity  $covar) nocons
unique ccode if e(sample)

xtabond2 Capacity L.demo L.Capacity L2.Capacity  yr1-yr50 $covar, gmm(L.Capacity, lag(2 6) eq(both)) iv(yr1-yr50 $covar, eq(level)) 
outreg2 using output/out.xml, excel dec(3) keep(L.demo L.Capacity L2.Capacity $covar) nocons
unique ccode if e(sample)

* spatial lag
xtabond2 Capacity L.demo L.Capacity L2.Capacity L.Cap_region yr1-yr50 $covar, gmm(L.Capacity, lag(2 6) eq(both)) iv(yr1-yr50 L.Cap_region $covar, eq(level)) 
outreg2 using output/out.xml, excel dec(3) keep(L.demo L.Capacity L2.Capacity L.Cap_region $covar) nocons
unique ccode if e(sample)

* spatial lag also instrumented
xtabond2 Capacity L.demo L.Capacity L2.Capacity L.Cap_region yr1-yr50 $covar, gmm(L.Capacity, lag(2 6) eq(both)) gmm(L.Cap_region, lag(1 1) eq(both)) iv(yr1-yr50 $covar, eq(level)) 
outreg2 using output/out.xml, excel dec(3) keep(L.demo L.Capacity L2.Capacity L.Cap_region $covar) nocons
unique ccode if e(sample)


***************************
** Table A8. Adding trends
***************************

cap erase output/out.xml
cap erase output/out.txt

use Data_full, clear
g year2 = year^2
g year3 = year^3

reg Capacity demo_l1 i.year i.ccode, cl(ccode)
outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons
predict Cap_fe, xb

reg Capacity demo_l1 c.year#i.ccode i.year i.ccode, cl(ccode)
outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons
predict Cap_td1, xb

reg Capacity demo_l1 (c.year c.year2)#i.ccode i.year i.ccode, cl(ccode)
outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons
predict Cap_td2, xb

reg Capacity demo_l1 (c.year c.year2 c.year3)#i.ccode i.year i.ccode, cl(ccode)
outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons
predict Cap_td3, xb

/* ** for plotting */
/* reg Capacity demo_l1 Capacity_l1 Capacity_l2 i.year i.ccode, cl(ccode) */
/* predict Cap_lag2, xb */
/* keep country ccode year Capacity Cap_* demo */
/* saveold fg_modelfit, replace version(12) */



******************************************************
* Table A10. Mechanism contestation and participation
******************************************************

cap erase output/out.xml
cap erase output/out.txt
use Data_full, clear

reghdfe Capacity demo_l1 $lags $covar, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 contdim_l1) nocons
unique ccode if e(sample)

reghdfe Capacity contdim_l1 $lags $covar, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 contdim_l1) nocons
unique ccode if e(sample)

reghdfe Capacity partdim_l1 $lags $covar, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 partdim_l1) nocons
unique ccode if e(sample)



*** for mediation analysis (Figure A8) ***
/*
use Data_full, clear
* Capacity
global lags = "Capacity_l1 Capacity_l2"
global covar = "lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 rivalry_l1 threat_l1 war_l1"
reghdfe Capacity demo_l1 contdim_l1 partdim_l1 $lags $covar, a(ccode year) 
keep if e(sample) 
keep ccode year Capacity demo_l1 contdim_l1 partdim_l1 $lags $covar
saveold Data_mediation, replace version(11)
*/


********************************
* Table A11. Sumsample
********************************

cap erase output/out.xml
cap erase output/out.txt

use Data_full, clear
**excluding solid democracies and post-1991 democracies)
keep if inlist(type, 1, 2, 3)

* baseline with control variables
global lags = "Capacity_l1 Capacity_l2"
global covar = "lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 rivalry_l1 threat_l1 war_l1"

reghdfe Capacity demo_l1 $lags, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

reghdfe Capacity demo_l1 lnpop_l1 elf_l1 $lags, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

reghdfe Capacity demo_l1 logGDP_l1 agri_l1 literacy_l1 $lags, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

reghdfe Capacity demo_l1 min_l1 resources_l1 $lags, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

reghdfe Capacity demo_l1 log_aid_l1 exports_l1 $lags, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

reghdfe Capacity demo_l1 rivalry_l1 threat_l1 war_l1 $lags, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons

reghdfe Capacity demo_l1 $lags $covar, a(ccode year) cl(ccode)
outreg2 using output/out.xml, excel dec(3) nocons


********************************
* Table A12. long term averages 
********************************

* look all good
* the results from RPE are much noiser (but also consistent)

global covar0 = "lnpop elf logGDP agri literacy min resources log_aid exports rivalry threat war"
global covar = "L.lnpop L.elf L.logGDP  L.agri L.literacy  L.min L.resources L.log_aid L.exports L.rivalry L.threat L.war"

cap erase output/out.xml
cap erase output/out.txt

** 5 year avearge
use Data_full, clear
g yr5 = int((year-1960)/5)
foreach var of varlist Capacity demo $covar0 {
	bysort ccode yr5: egen `var'_yr5 = mean(`var')
	drop `var'
	ren `var'_yr5 `var'
}
keep if mod(year-1960,5)==0 // keep 1960, 1965, 1970 ...

xtset ccode yr5
areg Capacity L.demo i.year $covar , a(ccode) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(L.demo) nocons
unique ccode if e(sample)

forvalues i= 1/4 {
   areg Capacity L.demo i.year L(1/`i').Capacity $covar, a(ccode) cl(ccode) 
	outreg2 using output/out.xml, excel dec(3) keep(L.demo L(1/`i').Capacity) nocons
	unique ccode if e(sample)
}
	
** 10 year average
use Data_full, clear
g yr10 = int((year-1960)/10)
foreach var of varlist Capacity demo $covar0 {
	bysort ccode yr10: egen `var'_yr10= mean(`var')
	drop `var'
	ren `var'_yr10 `var'
}
keep if mod(year-1960,10)==0 // keep 1960, 1970 ...

xtset ccode yr10
areg Capacity L.demo i.year $covar, a(ccode) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(L.demo) nocons
unique ccode if e(sample)

forvalues i= 1/2 {
   areg Capacity L.demo i.year L(1/`i').Capacity $covar, a(ccode) cl(ccode) 
	outreg2 using output/out.xml, excel dec(3) keep(L.demo L(1/`i').Capacity) nocons
	unique ccode if e(sample)
}

*************************************
** Table A13. Initial State Capacity 
*************************************

cap erase output/out.xml
cap erase output/out.txt

use Data_full, clear
global lags = "Capacity_l1 Capacity_l2"
global covar = "lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 rivalry_l1 threat_l1 war_l1"

reghdfe Capacity demo_l1 $lags, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 $lags) nocons //noas
unique ccode if e(sample)

reghdfe Capacity demo_l1 $lags c.init_Capacity#i.year, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 $lags) nocons //noas
unique ccode if e(sample)

reghdfe Capacity demo_l1 $lags c.init_xDemavg#i.year, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 $lags) nocons //noas
unique ccode if e(sample)

reghdfe Capacity demo_l1 $lags c.init_StateHist#i.year, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 $lags) nocons //noas
unique ccode if e(sample)

reghdfe Capacity demo_l1 $lags c.init_Capacity#i.year c.init_StateHist#i.year, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 $lags) nocons //noas
unique ccode if e(sample)

reghdfe Capacity demo_l1 $lags c.init_Capacity#i.year c.init_StateHist#i.year $covar, a(ccode year) cl(ccode) 
outreg2 using output/out.xml, excel dec(3) keep(demo_l1 $lags) nocons //noas
unique ccode if e(sample)  


*****************************************************************
* Table A14. Military Expenditure as Measure of Coercive Capacity 
*****************************************************************

cap erase output/out.xml
cap erase output/out.txt

global covar = "lnpop_l1 elf_l1 logGDP_l1 agri_l1 literacy_l1 min_l1 resources_l1 log_aid_l1 exports_l1 threat_l1 rivalry_l1 war_l1"
local nsim = 1000

use Data_full, clear
g logmilex = log(milex)
g logmilexpc = log(milexpc)


foreach var of varlist logmilper logmilex logmilexpc {
   tsset ccode year
   forvalues i = 1/2 {
      bysort ccode (year): g `var'_l`i' = L`i'.`var'
   }   
   xtset, clear
   reghdfe `var' demo_l1 `var'_l1 `var'_l2, a(ccode year) cl(ccode)
   outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons

   reghdfe `var' demo_l1 `var'_l1 `var'_l2 $covar, a(ccode year) cl(ccode)
   outreg2 using output/out.xml, excel dec(3) keep(demo_l1) nocons 
   }



log close



/* ******* Prepare intermediate files for plotting various figures ********* */

/* * for descriptive figure (autocracy only) */
/* use Data_full, clear */
/* tab demo_yr, g(demo_yr) */

/* keep if inrange(demo_yr,-9,10)   // 66 countries left */
/* collapse Capacity, by(demo_yr) */
/* twoway conn Capacity demo_yr */
/* saveold fg_rawdyn, replace */

/* /\*********************** */
/* * discriptive figures */
/* ***********************\/ */

/* * describe */
/* use Data_full, clear */
/* xtset ccode year */
/* xtsum Capacity */
/* /\* */
/* between: 0.84 */
/* within: 0.49 */
/* *\/ */
/* keep if autocracy */
/* collapse Capacity, by(year) */

/* /\* China: -0.29->0.55 (0.84) *\/ */
/* sum Capacity if ccode==710 & int(year/10)==196, d */
/* sum Capacity if ccode==710 & int(year/10)==200, d */
/* /\*US: 1.12->2.04 (0.92)*\/ */
/* sum Capacity if ccode==2 & int(year/10)==196, d */
/* sum Capacity if ccode==2 & int(year/10)==200, d */

/* *************** */
/* * scatterplot */
/* *************** */

/* use Data_full, clear */
/* ren rpe_agri rpc */
/* sum rpc */
/* g rpc_sd = (rpc - r(mean))/r(sd) */
/* sum pubcorr */
/* g pubcorr_sd = (pubcorr - r(mean))/r(sd) */
/* global covariates = "lnpop elf logGDP agri literacy min resources log_aid exports threat rivalry war" */
/* tabstat Capacity rpc_sd pubcorr_sd logmilper demo demo_polity polity2 contdim partdim $covariates, s(N mean median sd min max) c(s) */

/* keep ccode year Capacity rpc pubcorr logGDP tax logmilper  */
/* foreach var of varlist Capacity rpc pubcorr logmilper logGDP tax   { */
/* qui areg `var' i.year, a(ccode) */
/* predict `var'_res, res */
/* } */
/* saveold fg_scatterplot, replace version(12) */

/* ******************* */
/* * democratization */
/* ******************* */
/* use Data_full, clear */
/* bysort year demo: gen countrynum=_N */
/* collapse countrynum, by(year demo) */
/* sort demo year */
/* save fg_demo, replace */

/* ****************************** */
/* * evolution of state capacity */
/* ****************************** */

/* * list of countries + years of begining / democratization */
/* /\* without variation*\/  */
/* use Data_full, clear */
/* keep if inlist(type, 1, 4, 5) */
/* bysort ccode (year): drop if ccode ==ccode[_n-1] */
/* keep type country year */
/* sort type country */
/* /\* with variation*\/ */
/* use Data_full, clear */
/* keep if inlist(type, 2, 3) */
/* g check = 0  */
/* bysort ccode (year): replace check=1 if demo==1 & demo[_n-1]==0  // democratize */
/* bysort ccode (year): replace check=2 if demo==0 & demo[_n-1]==1  // reverse */
/* keep if check>0 */
/* keep type country year check */
/* sort type country year */
/* hist year if check==1 // years of democritazaion */
/* hist year if check==2 // years of reversal */
/* saveold fg_demoyr, replace */

/*  ***************************** */
/* * dynamic effect */
/* ***************************** */

/* cap erase output/out.xml */
/* cap erase output/out.txt */

/* use Data_full, clear */
/* tab demo_yr, g(demo_yr) */

/* * dynamic effect */
/* qui reghdfe Capacity demo_yr1-demo_yr23 i.year, a(ccode year) cl(ccode)  */
/* outreg2 using output/out.xml, excel dec(3) keep(demo_yr*) nocons sideway stats(coef se) noas noparen */

/* qui reghdfe Capacity demo_yr1-demo_yr23 Capacity_l1 Capacity_l2 i.year, a(ccode year) cl(ccode)  */
/* outreg2 using output/out.xml, excel dec(3) keep(demo_yr*) nocons sideway stats(coef se) noas noparen */

/* *********************** */
/* * for mapping */
/* *********************** */

/* use Data_full, clear */
/* keep country isocode demo year */
/* replace isocode="COD" if isocode=="ZAR"  // congo, democratic */
/* replace isocode="CSK" if isocode=="CZE"  // czech */
/* keep if inlist(year,1970,1985,2000) */
/* saveold fg_map, replace */

