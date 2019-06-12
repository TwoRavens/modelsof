
/********************************************************************
table4.do
********************************************************************/
clear all
cap log close
set more off
set mem 12000m
cd "C:\Users\ok9\Downloads"
set linesize 255



use C:\Users\ok9\Downloads\acs2014\complete_all_1314_w.dta


drop _merge temp
cap drop incpe _merge rincpe lincpe edgroup*

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

replace incbusfm =  incbus + 1.4*incfarm if year >= 1970 & year <= 1990
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
merge year using C:\Users\ok9\Downloads\acs2014\cpi_acs.dta
gen rincpe = incpe/cpi*100
gen rincpe_w = rincpe/temp_w 
replace rincpe_w = 0 if rincpe == 0
drop _merge cpi
/****************************************/


gen lincpe = log(rincpe_w+1)
	 
drop if lincpe == .
/*****************************************/

tab edlevel,gen(edgroup)

sort year lincpe
drop pct* 

save shortdata_new_2.dta, replace

keep if black==0 & other==0

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

sort year lincpe 
keep pct lincpe year
duplicates drop year lincpe, force
save shortdata_new_3.dta, replace

use shortdata_new_2.dta, clear
nearmrg year using shortdata_new_3, nearvar(lincpe)

cd C:\Users\ok9\Downloads
tokenize 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014

drop age1 age2 age3 age4 age5 age6 
gen age1 = (age>24)*(age<30)
gen age2 = (age>29)*(age<35)
gen age3 = (age>34)*(age<40)
gen age4 = (age>39)*(age<45)
gen age5 = (age>44)*(age<50)
gen age6 = (age>49)*(age<55)

gen regN = (region==11 | region==12 | region==13 )
gen regS = (region==31 | region==32 | region==33 | region==34)
gen regM = (region==21 | region==22 | region==23)
gen regW = (region==41 | region==42 | region==43)

foreach q in 50 75 90  {
	
	forvalues t = 1/10 {
		log using table4_w_all_bf_`q'_`t',text replace
		
		/*Conditional on Age*/	
 
		qreg pct black other age2-age6  regN regM regS regW [pw=perwt] if year==``t'', q(`q')
		log close
		
		}

}

keep if lincpe  > 0 
	
foreach q in 50 75 90{
	
	forvalues t = 1/10{
		log using table4_w_pos_bf_`q'_`t',text replace
		
		/*Conditional on Age*/	

		qreg pct black other age2-age6  regN regM regS regW [pw=perwt] if year==``t'' , q(`q')
		log close
		
		}

}

clear
exit

