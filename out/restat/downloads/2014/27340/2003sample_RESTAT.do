//This do file selects observations that were present in 2003. 
// Jiro Yoshida
// 2014.1.30
// modified on 2014/2/21

cd "C:\Users\juy18\Downloads\rent_index"
log using 2003, replace smcl

clear
*set mem 64m
set matsize 1000
set more off
set type double




use full.dta, clear

// reduce the file size by focusing on major 11 MSAs
keep if msa_name4=="Atlanta"|msa_name4=="Boston" |msa_name4=="Dallas" |msa_name4=="Detroit" |msa_name4=="Houston" |msa_name4=="Los_Angeles" |msa_name4=="Miami" |msa_name4=="New_York" |msa_name4=="San_Francisco" |msa_name4=="Seattle" |msa_name4=="Washington"


//  Explanation of timing variables
//  movein_date is a string variable representing the move-in date
//  m_date is a %td variable representing the move-in date
//  pmt_date is a %d variable representing the first day of the move-in month
//  pmt_month is a number that represents the month of the move-in date
//  p_mth is a string variable that represents the month of the move-in date
//  pmt_year is a number that represents the year of the move-in date

// generating a new variable, "first_month_lease"
// The variable, “last_activity_date” is the first day of the first month of a lease contract 
// (i.e., the first day of the move-in month). 
// maintain "last_activity_date" because this variable is used in other codes.
gen first_month_lease = mofd(pmt_date)
format %tm first_month_lease

// generating the number of payments, "num_pmt" 
// (i.e., the number of months) for a lease contract in the data set.  
// pmt_series is the index of the first payment in a 24-month backward payment sequence
// It looks like the index starts with 0.
// So, if pmt_series ==5, payments were made between 5th and 23th months.
gen num_pmt = 23 - pmt_series +1 

//generating "last_month_lease"
// The last month of a lease contract
gen last_month_lease = first_month_lease + num_pmt - 1
format %tm last_month_lease

// generating %t variables that represent the first day of the move-in month
gen leasemonth=mofd(pmt_date)
gen leasequarter=qofd(pmt_date)
gen leaseyear=yofd(pmt_date)

// generating log rent
gen lnrent=ln(rent)

// identify properties that exist in 2003
encode property_id, generate( property_id2)
gen s2003=0

levelsof property_id2 if last_month_lease >= tm(2003m1) &  first_month_lease <= tm(2003m12)

foreach p in `r(levels)' {
replace s2003=1 if property_id2==`p'
}

// dropping unnecessary variables
drop property_id2  msa_name1 msa_name2 msa_name3 unit_id1

// save dta

save 11MSAs, replace

//construct RRI, mean, and median rents

*"New_York" /// is excluded because only 263 leases are kept

foreach m in  ///
"Atlanta" ///
"Boston" ///
"Dallas" ///
"Detroit" ///
"Houston" ///
"Los_Angeles" ///
"Miami" ///
"San_Francisco" ///
"Seattle" ///
"Washington" ///
{

cd "C:\Users\juy18\Downloads\rent_index"
capture noisily use 11MSAs, clear
 if _rc==111 {
	continue
	}

keep if msa_name4=="`m'"
local msaorig= msa
*keep if msa==12060

// maintain properties that are included in the sample of 2003
capture keep if s2003==1
if _rc==111 {
	continue
	}
drop s2003


display "--------- 2003 Sample including non-repeat-leases ---------------------"
display as text "MSA is `m'"
tab leasequarter


/*establishing variables needed for repeat sales regression*/
sort unit_id pmt_date
gen apprate=lnrent-lnrent[_n-1] if unit_id[_n-1]==unit_id
gen firstquarter=leasequarter[_n-1] if unit_id==unit_id[_n-1]
gen secondquarter=leasequarter if unit_id==unit_id[_n-1]
gen time=1960+(leasequarter-1)/4
*correction from here april 24 2012
quietly summarize firstquarter
local min=r(min)
quietly summarize secondquarter
local max=r(max)
*correction end here 
/* a clumsy trick to get the graphs right*/
gen minplusone=r(min)+1
quietly summarize minplusone
local minplusone=r(mean)



/*this creates the repeat sales variables-- -1 for first sales, +1 for second*/
forvalues j=`min'/`max'  {
	gen rsquarter`j'=(secondquarter==`j')-(firstquarter==`j') 
	}
/*the coefficients in the following regression are the mean log rents by quarter (relative to the first sample in the quarter) for the whole sameple--the variable meanrent is the resulting series, renormalized to quarter 185*/
gen meanrent=0
xi:regress lnrent i.leasequarter

	forvalues j=`minplusone'/`max' {
	gen gamma`j'=_b[_Ileasequar_`j']  
	capture replace meanrent=gamma`j' if leasequarter==`j'
		if _rc==111 {
		continue
		}
}
gen normfactormn=_b[_Ileasequar_185]
gen normmeanrent=(meanrent-normfactormn)


// median log rents
gen medianrent=0
bsqreg lnrent _Ileasequar*

	forvalues j=`minplusone'/`max' {
	gen theta`j'=_b[_Ileasequar_`j']  
	replace medianrent=theta`j' if leasequarter==`j'
}
gen normfactormd=_b[_Ileasequar_185]
gen normmedianrent=(medianrent-normfactormd)


/*this command drops observations that are not well-defined, or are not repeat sales (in which case both first and second quarter==.*/
drop if firstquarter==secondquarter
gen rsindex=0
/*the repeat sales regression, followed by the lining up of the coefficient into a series (rsindex) to form the repeat sales index, also normalized to quarter 185*/
regress apprate rsquarter*,nocon 
predict rshat
forvalues j=`min'/`max'  {
	gen beta`j'= _b[rsquarter`j'] 
	replace rsindex=beta`j' if leasequarter==`j'	
	}
	

gen normfactorrs=_b[rsquarter185]
gen normrsindex=(rsindex-normfactorrs)
sort leasequarter
/*WHAT CITY IS THIS?*/

*local msa=msa_name4
*local msa "Atlanta"

*scatter normmeanrent normrsindex leasequarter, connect(l l) *title(`m')

/*these commands to follow implement the Case-Shiller (really, FHFA) correction for heteroskedasticity for the repeat sales regression; these are collected in the series normgrsindex*/ 

gen esq=(apprate-rshat)^2
gen gap=secondquarter-firstquarter
gen gapsq=gap*gap
quietly reg esq gap gapsq
predict esqhat
regress apprate rsquarter* [aweight=1/esqhat], nocon
gen grsindex=0
gen grsindex_l=0
gen grsindex_u=0

forvalues j=`min'/`max'  {
	gen delta`j'= _b[rsquarter`j'] 
	
	gen se_l`j'= _se[rsquarter`j'] 
	gen delta_l`j'= _b[rsquarter`j']-1*_se[rsquarter`j'] 
	
	gen delta_u`j'= _b[rsquarter`j']+1*_se[rsquarter`j'] 
	
	replace grsindex=delta`j' if leasequarter==`j'	
	replace grsindex_l=delta_l`j' if leasequarter==`j'	
	replace grsindex_u=delta_u`j' if leasequarter==`j'	
	
	}
gen normfactorgrs=_b[rsquarter185]
gen normfactorgrs_l= _b[rsquarter185]-2*_se[rsquarter185]
gen normfactorgrs_u= _b[rsquarter185]+2*_se[rsquarter185]

gen normgrsindex=(grsindex-normfactorgrs)
gen normgrsindex_l=(grsindex_l-normfactorgrs)
gen normgrsindex_u=(grsindex_u-normfactorgrs)


*****

display "--------- 2003 Sample for repeat-leases only ---------------------"
display as text "MSA is `m'"
tab leasequarter


cd "C:\Users\juy18\Downloads\rent_index\2003sample"
save `m'_2003sample, replace

use `m'_2003sample, clear
//create final version of msa data set
rename normmeanrent `m'mean2003sample
rename normmedianrent `m'median2003sample
rename normrsindex `m'rs2003sample
rename normgrsindex `m'rshet2003sample
rename normgrsindex_l `m'rshet_l2003sample
rename normgrsindex_u `m'rshet_u2003sample

keep time `m'mean2003sample `m'median2003sample `m'rs2003sample `m'rshet2003sample `m'rshet_l2003sample `m'rshet_u2003sample

sort time 
duplicates drop time, force

/*create data to be merged*/ 
cd "C:\Users\juy18\Downloads\rent_index\rri"
merge 1:1 time using `m'_rri

// add BLSI
drop _merge
cd "C:\Users\juy18\Downloads\rent_index"
merge 1:1 time using BLS2003_q

foreach var of varlist BLSI*  {
	rename `var' `: var label `var''_BLSI
 }

foreach var of varlist *_BLSI  {
	label variable `var' `var'_2003simulated  
} 
 
foreach var of varlist numprop*  {
	rename `var' `: var label `var''_numprop
 }

sort time

// add actual BLS index
drop _merge
merge 1:1 time using bls_index_norm

sort time
drop if `m'rshet2003sample==.

keep time `m'* month _merge

 
// Remove aging adjustments
// BLS_Actual series are adjusted (inflated) for the annual depreciation rate.
// To make an apple-to-apple comparison with RRI, we generate BLS_Adjusted
// by deflating BLS_Actual by the depreciation rate.
/* BLS age bias adjustment (Annual rate in percent)
Source: Walter F. Lane, William C. Randolph, and Stephen A. Berenson, 
“Adjusting the CPI shelter index to compensate for effect of depreciation,”
Monthly Labor Review, October 1988, pp. 34-37.
Atlanta  	0.17%/year
Boston 	0.36%/year
Dallas 	0.14%/year
Detroit	0.24%/year
Houston	0.11%/year
Los Angeles	0.22%/year
Miami	0.16%/year
New York 	0.36%/year
San Francisco 	0.23%/year
Seattle 	0.25%/year
Washington, DC.	0.17%/year
*/


gen MSA="`m'"

if MSA=="Atlanta" local d 0.0017
if MSA=="Boston" local d 0.0036
if MSA=="Dallas" local d 0.0014
if MSA=="Detroit" local d 0.0024
if MSA=="Houston" local d 0.0011
if MSA=="Los Angeles" local d 0.0022
if MSA=="Miami" local d 0.0016
if MSA=="New York" local d 0.0036
if MSA=="San Francisco" local d 0.0023
if MSA=="Seattle" local d 0.0025
if MSA=="Washington" local d 0.0017

gen qtr = time - 2006
gen  `m'_BLSAdj =  (1+`m'_BLSA_r_n)*((1-`d')^ qtr)-1
drop qtr MSA

label variable `m'_BLSAdj "`m'_BLS_Adjusted"

cd "C:\Users\juy18\Downloads\rent_index\rri2003sample"
save `m'rri2003sample, replace


twoway (connected `m'rshet2003sample time, msymbol(O)) (line `m'rshet_l2003sample time) (line `m'rshet_u2003sample time) (connected `m'rshet time, msymbol(Oh) clpattern(dash)) (connected `m'median2003sample time, msymbol(t)) (connected `m'mean2003sample time, msymbol(s)) (connected `m'mean time, msymbol(sh) clpattern(dash))
graph export `m'rshet2003sample.png, replace

twoway (connected `m'rshet2003sample time, msymbol(O)) (line `m'rshet_l2003sample time) (line `m'rshet_u2003sample time) (connected `m'rshet time, msymbol(Oh) clpattern(dash)) (connected `m'_BLSI time, msymbol(t)) (connected `m'_BLSA_r_n time, msymbol(s))(connected `m'_BLSAdj time, msymbol(sh)) 
graph export `m'RRI_BLS2003.png, replace

}

log close
