
cap clear mata
clear
clear all
set more off
cap log close
set mem 10g
set matsize 11000

/*

Dofile: 01_TradeDataset.do 

Date: Dec. 10, 2016 
Aim: combine French customs data with intra-firm information collected by INSEE

Inputs: 
- cadre-b-c.dta (Insee) 
- DP1223LOUVAIN_1999_12.txt (French Customs data) 

Output: base_trade99

*/ 

cd $datapath

*******************************
*** prepare intrafirm data 
*******************************
use cadre-b-c.dta, clear
destring siren, replace force
drop if cadre==" "
drop if cadre==""
drop if cadre=="p"
drop if siren==0
drop if siren==46
drop if siren==1459
drop if siren==82001
replace cadre="Import" if cadre=="C"
replace cadre="Export" if cadre=="B"
drop if siren==.
sort siren
drop if extra<0
destring sh, replace force
drop if sh==.
duplicates drop
egen tot=sum(val), by(siren pays sh cadre) 
g w=val/tot
replace intra=w*intra
replace extra=w*extra
replace tiers=w*tiers
collapse (sum) val intra extra tiers w, by(sh pays siren cadre)   /* here we have collapsed transaction to have annual flows */

keep if cadre=="Export"
rename val export_mondia
rename intra intra_x
rename extra extra_x 
rename tiers tiers_x 
label var intra_x "Share of intra firm exports"
label var extra_x "Share of extra firm exports" 
label var tiers_x "Share of tiers firm exports"
label var export_mondia "Value of Exports, Survey Intrafirm" 
rename pays iso2 
rename sh hs4
drop cadre 
duplicates drop
sort siren hs4 iso2 
save intra_x, replace 

*******************************
*** prepare trade data 
*******************************
clear
insheet using DP1223LOUVAIN_1999_12.txt, delimiter(";") clear 
rename v1 year 
rename v2 siren 
rename v3 nc8
rename v4 iso2 
rename v5 import 
rename v6 mqty 
rename v7 musup 
rename v8 export 
rename v9 xqty 
rename v10 xusup 


label var import "Value of Imports (custom data)"
label var mqty "Quantity of Imports (custom data)"
label var export "Value of Exports (custom data)"
label var xqty "Quantity of Exports (custom data)"
tostring nc8, replace
replace nc8="0"+nc8 if length(nc8)==7
replace nc8="00"+nc8 if length(nc8)==6
drop if length(nc8)<8
g hs4=substr(nc8,1,4)
destring hs4, replace 
sort siren hs4 iso2 

*******************************
***merge trade and intra-trade 
*******************************

joinby siren hs4 iso2 using intra_x.dta, unmatched(both)
egen t1=group(siren) if _m==2
egen t2=group(siren) if _m==3
sum t1 t2 
drop t1 t2 
replace export_mondia=export_mondia/6.55957
egen exporths4=sum(export), by(siren iso2 hs4) 
g test=exporths4/export_mondia 
sum test if _m==3, d /* 98% of exports in custom data are equal to exports in m the dataset ondialisation */
drop test 
drop if _m==2 
drop _m 

drop w 

save base_trade99, replace
 
* 4,209,512 observations 
* 183,454 firms 
* 235 countries 
* 10,343 8-digit products 
* 1,243 4-digit products 
* Value of exports: 282 billion euros (almost same as aggregate figures given by INSEE)
 








