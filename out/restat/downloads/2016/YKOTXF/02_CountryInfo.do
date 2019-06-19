
cap clear mata
clear
clear all
set more off
cap log close
set mem 10g
set matsize 11000

/*

Dofile: 02_CountryInfo.do 

Date: Dec. 10, 2016 
Aim: merge info on destination countries together, this includes info on taxes, distance, gdp, pop...

Inputs: 
- updates_loretz_data_with_Haven.dta 
- dist_cepii.dta 
- population_worldbank.dta
- gdp_worldbank.dta
- iso_pays.dta
- cname_pays.dta
- tax_rates.dta 
- FSI2011.dta 
- dum_tax 

Output: info_country

*/ 

cd $datapath

use updates_loretz_data_with_Haven, clear 
sort iso2 
save eatr_, replace 

use dist_cepii, clear 
keep if iso_o=="FRA" 
rename iso_d iso3 
drop iso_o 
sort iso3 
save dist_fra, replace

use population_worldbank, clear 
keep if year==1999
drop year 
sort iso3 
save pop, replace 

use gdp_worldbank, clear 
keep if year==1999
drop year 
sort iso3 
save gdp, replace 

use iso_pays, clear 
sort pays 
save iso_pays, replace

use cname_pays, clear 
sort cname, 
save cname_pays, replace 

use tax_rates.dta, clear
drop if year==2000
egen group=group(name)
replace tax_rate=33 if name=="Australia" & year==1995
replace tax_rate=36 if name=="Australia" & year==1999
duplicates drop
tsset group year
g tax99= tax_rate
g tax98=l1.tax_rate
g tax97=l2.tax_rate
g tax96=l3.tax_rate
drop group tax_rate
keep if year==1999
drop year
rename name cname

replace cname="Bahamas"		if cname=="Bahamas, The"
replace cname="Central African Republic"		if cname=="Central African Rep"
replace cname="Congo, Democratic Republic"		if cname=="Congo, Democratic Republic of"
replace cname="Congo"		if cname=="Congo, Republic of"
replace cname="Cote d'Ivoire"		if cname=="Cote d' Ivoire (Ivory Coast)"
replace cname="Ethiopia (1993-)"		if cname=="Ethiopia"
replace cname="Guinea-Bissau"		if cname=="Guinea"
replace cname="Korea, South"		if cname=="Korea, Republic of"
replace cname="Kyrgyzstan"		if cname=="Kyrgyz Republic"
replace cname="Pakistan (1972-)"		if cname=="Pakistan"
replace cname="Russia"		if cname=="Russian Federation"
replace cname="Slovakia"		if cname=="Slovak Republic"
replace cname="United States"		if cname=="United States (Federal Data)"
replace cname="St Vincent and the Grenadines"		if cname=="St. Vincent and The Grenadines"
replace cname="St Kitts and Nevis"		if cname=="St. Kitts and Nevis"
replace cname="St Lucia"		if cname=="Saint Lucia"

sort cname 
merge cname using cname_pays 
rename pays iso2

replace iso2="BM" if cname=="Bermuda"
replace iso2="VG" if cname=="British Virgin Islands"
replace iso2="KY" if cname=="Cayman Islands" 
replace iso2="GG" if cname=="Channel Islands, Guernsey" 
replace iso2="JE" if cname=="Channel Islands, Jersey" 
replace iso2="GI" if cname=="Gibraltar"  
replace iso2="HK" if cname=="Hong Kong" 
replace iso2="IM" if cname=="Isle of Man" 
replace iso2="MO" if cname=="Macau"
replace iso2="MC" if cname=="Monaco"
replace iso2="PR" if cname=="Puerto Rico" 
replace iso2="VI" if cname=="US Virgin Islands" 
replace iso2="WS" if cname=="Western Samoa"
replace iso2="MK" if cname=="Yugoslavia" 

drop _m 
drop if iso2==""
rename iso2 pays 
sort pays 
merge pays using iso_pays 
replace iso3="COD" if pays=="CD"
replace iso3="IOT" if pays=="IO"
replace iso3="LIE" if pays=="LI"
replace iso3="MYT" if pays=="YT"
replace iso3="VAT" if pays=="VA"
replace iso3="VIR" if pays=="VI"
replace iso3="GGY" if cname=="Channel Islands, Guernsey" 
replace iso3="JEY" if cname=="Channel Islands, Jersey" 
replace iso3="IMN" if cname=="Isle of Man" 
replace iso3="MCO" if cname=="Monaco"
rename pays iso2 
drop _m

sort iso3 
merge iso3 using dist_fra 
tab _m 
drop if _m==2
drop _m 

sort iso3 
merge iso3 using gdp
tab _m 
drop if _m==2
drop _m 

sort iso3 
merge iso3 using pop
tab _m 
drop if _m==2
drop _m 

sort iso3 
merge iso3 using FSI2011
tab _m 
drop if _m==2
drop _m 
replace secrecyscore=0 if secrecyscore==. 
replace fsivalue=0 if fsivalue==. 


sort iso2 
merge iso2 using dum_tax
drop _m 

g EU15=0
foreach i in DE BE LU DK ES GR IE IT NL GB PT SE FI AT {
replace EU15=1 if iso2=="`i'"
}


sort iso2 
merge iso2 using eatr_
drop _m 
sort iso2 

save info_country, replace

erase dist_fra.dta 
erase gdp.dta 
erase pop.dta 
