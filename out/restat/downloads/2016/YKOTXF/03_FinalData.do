cap clear mata
clear
clear all
set more off
cap log close
set mem 10g
set matsize 11000

/*

Dofile: 03_FinalData.do 

Date: Dec. 10, 2016 
Aim: merge firm level information with information about destination countries and product level information

Inputs: 
- lifi
- info_country
- rauch
- base_trade99
- country_hq (computed from lifi)
- country_affiliates (computed from lifi)

Output: base_dmpt

*/ 

cd $datapath



*******************************
*** prepare ownership data 
*******************************
use lifi.dta, clear 
keep if  year==1999
duplicates drop siren , force 
destring siren, replace
keep paystg siren  natact effetgr n16gr apedef
sort siren  
save lifi_temp, replace 

*******************************
*** prepare country data 
*******************************

use info_country, clear 
sort iso2 
save info_country, replace 

*******************************
*** prepare product data 
*******************************

use rauch, clear
rename sh hs4
sort hs4 
save rauch_, replace 

*******************************
*** merge datasets  
*******************************
use country_hq, clear
rename iso2_tg iso2 
keep if year=="1999"
keep iso2 siren 
sort siren iso2
save hq99, replace

use country_affiliates, clear
rename pays iso2 
keep if year=="1999"
keep iso2 siren 
sort siren iso2 
save af99, replace

use base_trade99, clear 
sort siren 
merge siren using lifi_temp
tab _m 
drop if _m==2 /* finance firms */
drop _m 
replace natact="0" if natact==""
sort hs4 
merge hs4 using rauch_ 
tab _m 
drop if _m==2
drop _m 

sort iso2 
merge iso2 using info_country 
drop if iso2=="QQ" | iso2=="QT" | iso2=="YT"
egen test1=sum(export)
keep if _m==3 
keep if eatr!=. & emtr!=.
egen test2=sum(export)
sum test1 test2 
drop test1 test2

drop _m 
tostring siren, replace 
g _=length(siren) 
tab _
replace siren="0"+siren if _==8 
replace siren="00"+siren if _==7 
drop _
sort siren iso2 
merge siren iso2 using hq99 
tab _m 
drop if _m==2 
g related=1 if _m==3
drop _m 
sort siren iso2 
merge siren iso2 using af99 
tab _m 
drop if _m==2 
replace related=1 if _m==3
drop _m 

save base_dmpt, replace 


erase rauch_.dta 
erase base_trade99.dta 
erase info_country.dta 
erase lifi_temp.dta 
