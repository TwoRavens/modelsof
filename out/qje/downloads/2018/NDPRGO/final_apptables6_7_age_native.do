/********************************************************************
table4.do
********************************************************************/
clear all
cap log close
set more off
set mem 12000m
cd C:\Users\ok9\Downloads\acs2014

set linesize 255

use completedata1964_acs_1940.dta

* fix race
cap drop other blacknative blackforeign whitenative whiteforeign othernative otherforeign

* white, black
gen whiteno = (white == 1 & hispan == 0)
drop white 
rename whiteno white

gen blackno = (black == 1 & hispan == 0)
drop black
rename blackno black

gen other = (white == 0 & black == 0)

gen blacknative= black==1 & native==1
gen blackforeign= black==1 & foreign==1
gen whitenative= white==1 & native==1
gen whiteforeign= white==1 & foreign==1 
gen othernative= other==1 & native==1
gen otherforeign= other==1 & foreign==1

sort year
replace perwt = 100 if gqtype != 1 & year == 1950

/**********************************
dependent variable
*********************************/

replace incbusfm = incbus00 if year >= 2000
replace incbusfm = incbus00*1.4 if year >= 2000 & ind1950 == 105
replace incbusfm = 0 if incbusfm == 999999
 
replace incwage = 0 if incwage == 99999
replace incbusfm = 0 if incbusfm < 0

replace incwage = 1.2*incwage if ind1950 == 105
replace incbusfm = 1.4*incbusfm if ind1950 == 105 & year <= 1960

gen incpe= incwage+incbusfm /*Including business and farm data*/

replace incpe=incwage if incpe==.
/*************Deflating*******************/
merge year using cpi_acs.dta
gen rincpe = incpe/cpi*100
drop _merge cpi
/****************************************/


gen lincpe = log(rincpe+1)

/*****************************************/
cap drop N
cap drop i
cap drop pct
sort year lincpe
by year: egen N = total(perwt) 
by year lincpe: egen temp = total(perwt)
gen half = temp/2
by year: gen runsum = sum(perwt)
gen runsum_n_1 = runsum[_n-1]
by year: replace runsum_n_1 = 0 if _n==1
gen i = .
by year lincpe: replace i = half+runsum_n_1 if _n==1
replace i = i[_n-1] if i==.
gen pct = i/N*100
drop runsum runsum_n_1 half temp N i

tab edlevel, gen(edgroup)
gen wpa = (year==1940 & empstat>1 & lincpe>1)/*Creating a variable that shows observations in the WPA*/


tokenize 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014

foreach q in 50 90 {

		forvalues t = 1/10 {
			log using apptable3_acs_nativeall_bf_`q'_`t',text replace

			/*Conditional on Age*/
			* 19-64
			qreg lincpe  blacknative blackforeign whiteforeign othernative otherforeign age2 age3 age4 age5 age6 [pw=perwt] if year==``t'', q(`q')

			log close
		}

}

foreach q in 50 90 {
	
	forvalues t = 1/10 {
		log using apptable3_acs_nativerankall_bf_`q'_`t',text replace
		
		/*Conditional on Age*/	
		* 19-64
			qreg pct blacknative blackforeign whiteforeign othernative otherforeign age2 age3 age4 age5 age6  [pw=perwt] if year==``t'', q(`q')

		log close
		}

}

foreach q in 50 90 {

		forvalues t = 1/10 {
			log using apptable3_acs_1964all_bf_`q'_`t',text replace

			/*Conditional on Age*/
			* 19-64
			qreg lincpe  black other age2 age3 age4 age5 age6 age7 age8 age9 [pw=perwt] if year==``t'', q(`q')

			log close
		}

}

foreach q in 50 90 {
	
	forvalues t = 1/10 {
		log using apptable3_acs_1964rankall_bf_`q'_`t',text replace
		
		/*Conditional on Age*/	
		* 19-64
			qreg pct black other age2 age3 age4 age5 age6 age7 age8 age9 [pw=perwt] if year==``t'', q(`q')

		log close
		}

}

clear
