/********************************************************************
table4.do
********************************************************************/
clear all
cap log close
set more off
set mem 12000m
cd "/Users/patrickbayer/dropbox/Pat's Stuff"

set linesize 255

use completedata1964_acs_1940.dta 

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
/*************Deflating*******************/
merge year using cpi_acs.dta
gen rincwage = incwage/cpi*100
drop _merge cpi
/****************************************/


gen lrincwage = log(rincwage+1)


cap drop N
cap drop i
cap drop pct
sort year incwage
by year: egen N = total(perwt) 
by year incwage: egen temp = total(perwt)
gen half = temp/2
by year: gen runsum = sum(perwt)
gen runsum_n_1 = runsum[_n-1]
by year: replace runsum_n_1 = 0 if _n==1
gen i = .
by year incwage: replace i = half+runsum_n_1 if _n==1
replace i = i[_n-1] if i==.
gen pct = i/N*100
drop runsum runsum_n_1 half temp N i

gen agegrp = .
replace agegrp = 1 if age1==1
replace agegrp = 2 if age2==1
replace agegrp = 3 if age3==1
replace agegrp = 4 if age4==1
replace agegrp = 5 if age5==1
replace agegrp = 6 if age6==1

sort year

tokenize 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014

forvalues t = 1/10 {
	log using apptable1_pw_`t'_90,text replace

	/*Conditional on Age*/
	qreg lrincwage black other age2 age3 age4 age5 age6 [pw=perwt] if year==``t'', q(90)

	log close
	
}

forvalues t = 1/10 {
	log using apptable1rank_pw_`t'_90,text replace

	/*Conditional on Age*/
	qreg pct black other age2 age3 age4 age5 age6 [pw=perwt] if year==``t'', q(90)

	log close
	
}

