/********************************************************************
table3.do
********************************************************************/
clear all
cap log close
set more off
set mem 12000m
cd "C:\Users\ok9"

set linesize 255

use completedata1964_acs_1940.dta 

* if 1 then only lfp
local lfp = 1
local incpe = 0
local pct = 1

* fix race
drop other 

* white, black
gen whiteno = (white == 1 & hispan == 0)
drop white 
rename whiteno white

gen blackno = (black == 1 & hispan == 0)
drop black
rename blackno black

gen other = (white == 0 & black == 0)

sort year
replace perwt = 100 if gqtype != 1 & year == 1950

/**********************************
dependent variable
*********************************/

replace incbusfm = incbus + 1.4*incfarm if year >= 1970 & year <= 1990
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

tab edlevel,gen(edgroup)

sort year

tokenize 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014

cd "Z:\wage_res"

foreach q in 50 75 90{

		forvalues t = 1/10 {
			log using table3all_bf_`q'_`t',text replace

		/*Conditional on Age*/
			qreg lincpe black other age2 age3 age4 age5 age6 [pw=perwt] if year==``t'', q(`q')

			
			log close
		}

}

keep if lincpe  > 0 

foreach q in 50 75 90{

		forvalues t = 1/10 {
			log using table3pos_bf_`q'_`t',text replace

		/*Conditional on Age*/
			qreg lincpe black other age2 age3 age4 age5 age6 [pw=perwt] if year==``t'', q(`q')

			
			log close
		}

}


clear
exit

