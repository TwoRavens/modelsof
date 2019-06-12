
/********************************************************************
table10.do
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
merge year using cpi_acs.dta
gen rincpe = incpe/cpi*100
drop _merge cpi
/****************************************/


gen lincpe = log(rincpe+1)
gen zerearn=(lincpe<=0)
	 

/*****************************************/

gen schyears = 18*(edlevel==11)+16*(edlevel==10)+15*(edlevel==9)+14*(edlevel==8)+13*(edlevel==7)+12*(edlevel==6)+11*(edlevel==5)+10*(edlevel==4)+9*(edlevel==3)+6*(edlevel==2)+2*(edlevel==1)+0*(edlevel==0)
gen collegemore = (edlevel==11 | edlevel==10)
gen somecollege = (edlevel==7 | edlevel==8 | edlevel==9)
gen hs = (edlevel==6)
gen somehs = (edlevel==3 | edlevel==4 | edlevel==5)
gen grade58 = (edlevel==2)
gen grade04 = (edlevel==1)


log using table10a_bf,text replace

tokenize 1940 1950 1960 1970 1980 1990 2000 2007 2010 2014

	forvalues t = 1/10 {
		
		reg lincpe black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & collmore == 1 & lincpe>0
		
		* some college
		reg lincpe black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & somecoll == 1 & lincpe>0
		* HS degree
		reg lincpe black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & hs == 1 & lincpe>0
		
		* Some HS
		reg lincpe black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & somehs == 1 & lincpe>0
	
		* Eight years or less
		reg lincpe black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & less8 == 1	 & lincpe>0	
		
		
		}


log close

log using table10b_bf,text replace

foreach q in 50{
	
	forvalues t = 1/10 {
		
		qreg lincpe black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & collmore == 1
		
		* some college
		reg zerearn black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & somecoll == 1
		* HS degree
		reg zerearn black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & hs == 1
		
		* Some HS
		reg zerearn black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & somehs == 1
	
		* Eight years or less
		reg zerearn black other age2 age3 age4 age5 age6 i.edlevel [pw=perwt] if year==``t'' & less8 == 1		
		
		
		}

}
log close

	
