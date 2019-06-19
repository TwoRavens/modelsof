
* REPLICATE DELL JONES OLKEN 2012 AND THEN EVALUATE ACROSS ENSEMBLE
* File first creates their dataset following their original replication files in the AEJ paper
* Then it bootstraps the specification in Table 2, Col 2
* Finally, it writes out a few files that R scripts then use to generate both future projections and the figures


clear
clear matrix
clear mata
set more off
set matsize 800
set mem 200m

* INSERT DIRECTORY WHERE REPLICATION FILE WAS UNZIPPED INTO QUOTATION MARKS:
cd "C:\Users\Elisa Cascardi\Desktop\BDLMS_Replication"
cd data/DJO/

/* May need to install cgmreg: ssc install cgmreg */

*************************
***----WDI sample
*************************


global rfe = 1 /*1 for region*year, 2 for year only*/
global maineffectsonly = 0 /*1 to drop all interactions*/


* This sample is the sample of all countries 
* Init GDP is defined based on your first year in the data
* Must have at least 20 years of GDP data
use climate_panel, clear

* restrict to 2003
keep if year <= 2003

encode parent, g(parent_num)
gen lgdp=ln(rgdpl)
encode fips60_06, g(cc_num)
sort country_code year
tsset cc_num year
g lngdpwdi = ln(gdpLCU)

*calculate GDP growth
gen temp1 = l.lngdpwdi
gen g=lngdpwdi-temp1
replace g = g * 100 
drop temp1
summarize g

g lnag = ln(gdpWDIGDPAGR) 
g lnind = ln(gdpWDIGDPIND) 
g lninvest = ln(rgdpl*ki/100)

foreach X in ag ind gdpwdi invest {
	g g`X' = (ln`X' - l.ln`X')*100
}


* Drop if less than 20 yrs of GDP data
g tempnonmis = 1 if g != .
replace tempnonmis = 0 if g == .
bys fips60_06: egen tempsumnonmis = sum(tempnonmis)
drop if tempsumnonmis  < 20
	
* Make sure all subcomponents are non-missing in a given year
g misdum = 0
for any ag ind : replace misdum = 1 if gX == .
for any ag ind : replace gX = . if misdum == 1


preserve
keep if lnrgdpl_t0 < . 
bys fips60_06: keep if _n == 1 
xtile initgdpbin = ln(lnrgdpl_t0), nq(2)
keep fips60_06 initgdpbin
tempfile tempxtile
save `tempxtile',replace
restore

merge n:1 fips60_06 using `tempxtile', nogen
tab initgdpbin, g(initxtilegdp)

preserve
keep if wtem50 < . 
bys fips60_06: keep if _n == 1 
xtile initwtem50bin = wtem50 , nq(2)
keep fips60_06 initwtem50bin
save `tempxtile',replace
restore

merge n:1 fips60_06 using `tempxtile', nogen
tab initwtem50bin, g(initxtilewtem)

* save version for calculating parameters below
save djo_dataset_param, replace

tsset
foreach Y in wtem wpre  {
	gen `Y'Xlnrgdpl_t0 =`Y'*lnrgdpl_t0 
	for var initxtile*: gen `Y'_X =`Y'*X	
	label var `Y'Xlnrgdpl_t0 "`Y'.*inital GDP pc"
	for var initxtile*: label var `Y'_X "`Y'* X"
}

capture {
	for var wtem* wpre*: g fdX = X - l.X \ label var fdX "Change in X"
	for var wtem* wpre*: g L1X = l1.X 
	for var wtem* wpre*: g L2X = l2.X 
	for var wtem* wpre*: g L3X = l3.X 
	for var wtem* wpre*: g L4X = l4.X 
	for var wtem* wpre*: g L5X = l5.X 
	for var wtem* wpre*: g L6X = l6.X 
	for var wtem* wpre*: g L7X = l7.X 
	for var wtem* wpre*: g L8X = l8.X 
	for var wtem* wpre*: g L9X = l9.X 
	for var wtem* wpre*: g L10X = l10.X
	 
}

	tab year, gen (yr)
local numyears = r(r) - 1

if $rfe == 1 {
	foreach X of num 1/`numyears' {
			foreach Y in MENA SSAF LAC WEOFF EECA SEAS {
				quietly gen RY`X'X`Y'=yr`X'*_`Y'
				quietly tab RY`X'X`Y'
			}
			quietly gen RYPX`X'=yr`X'*initxtilegdp1
		}
}
else if $rfe == 2 {
	foreach X of num 1/`numyears' {
			quietly gen RY`X'=yr`X'		
		}
}

*--Create a region x year variable for clustering
g region=""
foreach X in _MENA   _SSAF   _LAC    _WEOFF  _EECA _SEAS {
	replace region="`X'" if `X'==1
}

g regionyear=region+string(year)
encode regionyear, g(rynum)	


************************
* Here are our additions
************************

* Write out a file giving what countries are "poor", as well as country average precipitation. 
* Will use these to evaluate clim coefficients.
preserve
collapse (mean) initxtilegdp1 wpre (first) country, by(fips)
drop if initxtilegdp1==.  //looks like this is just Myanmar
outsheet using poor_countries.csv, comma replace
restore

* Check that we can replicate regression. Looks good
* Note: to run cgmreg, need to install ado from Jonah Gelbach website: 
*		http://gelbach.law.yale.edu/~gelbach/ado/cgmreg.ado
cgmreg g wtem wtem_initxtilegdp1 wpre wpre_initxtilegdp1 RY* i.cc_num, cluster(parent_num rynum)
lincom wtem + wtem_initxtilegdp1
lincom wpre + wpre_initxtilegdp1

* Slim down the dataset a little so bootstrap is faster
keep g wtem wtem_initxtilegdp1 wpre wpre_initxtilegdp1 RY* cc_num parent_num rynum initxtilegdp1  year //only keeping the variables we need
reg g wtem wtem_initxtilegdp1 wpre wpre_initxtilegdp1 RY* i.cc_num, cluster(parent_num)
predict smpl if e(sample)
drop if smpl==.  //keeping the insample stuff
drop smpl
save djo_dataset, replace

* average growth rate for the sample over the study period
summ g if initxtilegdp1==1, det

* Now bootstrap regression in Col 2 of Table 2, sampling countries. 1000 replicates
set seed 8675309
capture postutil clear
postfile boot runum temp_beta prec_beta using boot_djo, replace
forvalues i = 1/1000 {
	use djo_dataset, clear
	bsample, cl(parent_num)  //sample countries with replacement
	qui xtreg g wtem wtem_initxtilegdp1 wpre wpre_initxtilegdp1 RY*, fe i(cc_num)
	qui lincom wtem + wtem_initxtilegdp1
	local betat = `r(estimate)'
	qui lincom wpre + wpre_initxtilegdp1
	post boot (`i') (`betat') (`r(estimate)')
	di "`i'"
	}
postclose boot

* See how we did -- boostrapped CI is about identical to what's in the paper
use boot_djo, clear
hist temp_beta
_pctile temp_beta, p(2.5 97.5)
di "95% CI is `r(r1)' to `r(r2)'"

* Write out a csv copy for figure making
outsheet using boot_djo.csv, comma replace

* Calculate parameters such that we can replicate their projection exercise, as best we can make out from the instructions in
*	appendix III of their NBER working paer
use djo_dataset_param, clear
drop if year<1971
collapse (mean) g, by(fips) //average growth rate per country
summ g if fips=="US"
gen g_us = r(mean)
tempfile gr
save `gr', replace
use djo_dataset_param, clear
keep if year==1971
keep fips lgdp
summ lgdp if fips=="US"
gen lgdp_us = r(mean)
tempfile base
save `base', replace
use djo_dataset_param, clear
keep if year==2003 
gen poor = (initxtilegdp1==1)
keep fips rgdpl poor
merge 1:1 fips using `gr'
drop _merge
merge 1:1 fips using `base'
drop _merge
gen beta = (g - g_us)/(lgdp_us - lgdp)
outsheet using djo_paramdata.csv, comma replace

