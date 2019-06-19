
// Calculates products proximity matrix for 1996-2003   


clear
set more off 
set memory 1400000
*set maxvar 30000
set more off

tempfile en_curso
tempfile a
tempfile b
tempfile tier1
tempfile p_commodity_code_sitc
tempfile reporter
tempfile jp

* Determine the countries that appear in all years
use [COMTRADE Database Exports at HS6 1996 - 2003 - all except for Chile] 

rename reporteriso3 ecode

collapse tradevaluein1000usd, by(ecode year)

keep year ecode

sort ecode
by ecode: gen rank = _n
by ecode: egen max = max(rank)
tab max

keep if max == 8
** only countries available across all years ***

drop max rank

sort ecode
drop if ecode==ecode[_n-1]

sort ecode
save `en_curso',replace
*** This simply produces number of exporters for countries in all years ***


use [COUNTRY POPULATION from WDI]
*** This adds population data as we only want big countries included ***
keep if year == 1996
rename country_code ecode
sort ecode 

merge ecode using `en_curso'
tab _merge
keep if _merge == 3
drop _merge 

*Eliminate those countries with less than 3 million population
drop if population<3000000
sort ecode

tempfile data
save "`data'" 

*Open the database
use [COMTRADE X HS6 1996 - 2003 - all except for Chile] 
keep if year == 1996
drop year 

rename tradevaluein1000usd value 
rename codigo_ine isic7

rename reporteriso3 ecode
sort ecode
merge m:1 ecode using "`data'" 
keep if _merge==3
drop _merge
save `en_curso', replace

*For future operations we need the list of exporting countries
drop if ecode==ecode[_n-1]
*** to have just once each country ***
keep ecode
rename ecode reporter_code
*** just a list of exporting countries ***
save `reporter', replace

*Get one record per country and product
use `en_curso'
sort ecode isic7
by ecode isic7: egen t_value=total(value)
drop if ecode==ecode[_n-1] & isic7==isic7[_n-1]
*** way of again reducing anything double ***
drop value
rename t_value value

*Analyze whether the country has a RCA in the product
rename ecode reporter_code
rename isic7 commodity_code

sort reporter_code year
by reporter_code year: egen x_country=total(value)
*** country total exports ***

sort commodity_code year
by commodity_code year: egen x_product=total(value)
*** commodity total export ***

sort year
by year: egen x_total=total(value)
*** overall total exports ***

ge vcr=(value/x_country)/(x_product/x_total)
replace vcr=1 if vcr>1
replace vcr=0 if vcr<1

keep year reporter_code commodity_code vcr
sort commodity_code
save `en_curso', replace

*Get the number of countries
use `en_curso'
sort reporter_code
drop if reporter_code==reporter_code[_n-1]
keep reporter_code
scalar n_c=_N
save `a', replace

use `en_curso'
ge obs=n_c
save `tier1', replace

*We calculate the probability that a product gets a vcr equal to 1
sort commodity_code
by commodity_code: egen n1=count(vcr) if vcr==1
by commodity_code: egen n1_max=max(n1)
replace n1=n1_max if n1==.
ge p=n1/obs
drop n1 n1_max
sort commodity_code
drop if commodity_code==commodity_code[_n-1]
keep commodity_code p
sort commodity_code
save `p_commodity_code_sitc', replace

*Calculate the joint probability
use `tier1'
keep if vcr==1
if _N>1{
sort reporter_code
by reporter_code: egen obs1=count(vcr)
keep if obs1>1
if _N>1{
drop obs1
tempfile b
save `b', replace
*** keeps cases of joint probability, VCR = 1 ***
egen groups = group(reporter_code)
sum groups 
*** this shows it has 38 codes ***
tempfile data
save "`data'"
else{
tempfile a
save `a'
}
}
else{
tempfile a
save `a'
}
}

use "`data'"
keep if groups == 1 
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= 1
drop reporter_code
tempfile 1
save `1', replace 

forvalues i = 1(1)38 {
use "`data'"
keep if groups == `i'
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= `i'
drop reporter_code
tempfile `i'
save ``i''
}

*Add all the files
use `reporter'
forvalues i = 1(1)38 {
append using ``i''
}

drop reporter_code
drop if cc1==.

tempfile en_curso
save `en_curso', replace


*Count the number of cases that two products have comparative advantage
use `en_curso'
sort cc1 cc2
by cc1 cc2: egen nj=count(cc1)
drop if cc1==cc1[_n-1] & cc2==cc2[_n-1]
keep year cc1 cc2 nj
tempfile jp
save `jp', replace


use `tier1'
keep if _n==1
keep obs
cross using `jp'
ge jp=nj/obs
keep year cc1 cc2 jp

rename cc2 commodity_code
sort commodity_code
merge m:1 commodity_code using `p_commodity_code_sitc'
keep if _merge==3
drop _merge
ge cp=jp/p
rename commodity_code cc2
drop if cc1==cc2

sort cc1 cc2
tempfile a
save `a', replace

rename cc1 cc1bis
rename cc2 cc2bis
rename cc1bis cc2
rename cc2bis cc1
rename cp cpbis
rename p pbis
sort cc1 cc2
merge 1:1 cc1 cc2 using `a' 
drop _merge 
drop jp pbis p
ge min_cp=cpbis
replace min_cp=cp if cpbis>cp
drop cpbis cp
rename min_cp proximity
keep year cc1 cc2 proximity

*Calculate density
sort cc1
by cc1: egen denom=total(proximity)

drop year 
 
** just for 1996 **

sort cc1 cc2

tempfile 1996
save "`1996'" 


clear
set more off 
set memory 1400000
*set maxvar 30000
set more off


tempfile en_curso
tempfile a
tempfile b
tempfile tier1
tempfile p_commodity_code_sitc
tempfile reporter
tempfile jp

* Determine the countries that appear in all years
use [COMTRADE Database Exports at HS6 1996 - 2003 - all except for Chile] 

rename reporteriso3 ecode

collapse tradevaluein1000usd, by(ecode year)

keep year ecode

sort ecode
by ecode: gen rank = _n
by ecode: egen max = max(rank)
tab max

keep if max == 8
** only countries available across all years ***

drop max rank

sort ecode
drop if ecode==ecode[_n-1]

sort ecode
save `en_curso',replace
*** This simply produces number of exporters for countries in all years ***


use [COUNTRY POPULATION from WDI]
*** This adds population data as we only want big countries included ***
keep if year == 1997
rename country_code ecode
sort ecode 

merge ecode using `en_curso'
tab _merge
keep if _merge == 3
drop _merge 

*Eliminate those countries with less than 3 million population
drop if population<3000000
sort ecode

tempfile data
save "`data'" 

*Open the database
use [COMTRADE X HS6 1996 - 2003 - all except for Chile] 
keep if year == 1997
drop year 

rename tradevaluein1000usd value 
rename codigo_ine isic7

rename reporteriso3 ecode
sort ecode
merge m:1 ecode using "`data'" 
keep if _merge==3
drop _merge
save `en_curso', replace

*For future operations we need the list of exporting countries
drop if ecode==ecode[_n-1]
*** to have just once each country ***
keep ecode
rename ecode reporter_code
*** just a list of exporting countries ***
save `reporter', replace

*Get one record per country and product
use `en_curso'
sort ecode isic7
by ecode isic7: egen t_value=total(value)
drop if ecode==ecode[_n-1] & isic7==isic7[_n-1]
*** way of again reducing anything double ***
drop value
rename t_value value

*Analyze whether the country has a RCA in the product
rename ecode reporter_code
rename isic7 commodity_code

sort reporter_code year
by reporter_code year: egen x_country=total(value)
*** country total exports ***

sort commodity_code year
by commodity_code year: egen x_product=total(value)
*** commodity total export ***

sort year
by year: egen x_total=total(value)
*** overall total exports ***

ge vcr=(value/x_country)/(x_product/x_total)
replace vcr=1 if vcr>1
replace vcr=0 if vcr<1

keep year reporter_code commodity_code vcr
sort commodity_code
save `en_curso', replace

*Get the number of countries
use `en_curso'
sort reporter_code
drop if reporter_code==reporter_code[_n-1]
keep reporter_code
scalar n_c=_N
save `a', replace

use `en_curso'
ge obs=n_c
save `tier1', replace

*We calculate the probability that a product gets a vcr equal to 1
sort commodity_code
by commodity_code: egen n1=count(vcr) if vcr==1
by commodity_code: egen n1_max=max(n1)
replace n1=n1_max if n1==.
ge p=n1/obs
drop n1 n1_max
sort commodity_code
drop if commodity_code==commodity_code[_n-1]
keep commodity_code p
sort commodity_code
save `p_commodity_code_sitc', replace

*Calculate the joint probability
use `tier1'
keep if vcr==1
if _N>1{
sort reporter_code
by reporter_code: egen obs1=count(vcr)
keep if obs1>1
if _N>1{
drop obs1
tempfile b
save `b', replace
*** keeps cases of joint probability, VCR = 1 ***
egen groups = group(reporter_code)
sum groups 
*** this shows it has 38 codes ***
tempfile data
save "`data'"
else{
tempfile a
save `a'
}
}
else{
tempfile a
save `a'
}
}

use "`data'"
keep if groups == 1 
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= 1
drop reporter_code
tempfile 1
save `1', replace 

forvalues i = 1(1)38 {
use "`data'"
keep if groups == `i'
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= `i'
drop reporter_code
tempfile `i'
save ``i''
}

*Add all the files
use `reporter'
forvalues i = 1(1)38 {
append using ``i''
}

drop reporter_code
drop if cc1==.

tempfile en_curso
save `en_curso', replace


*Count the number of cases that two products have comparative advantage
use `en_curso'
sort cc1 cc2
by cc1 cc2: egen nj=count(cc1)
drop if cc1==cc1[_n-1] & cc2==cc2[_n-1]
keep year cc1 cc2 nj
tempfile jp
save `jp', replace


use `tier1'
keep if _n==1
keep obs
cross using `jp'
ge jp=nj/obs
keep year cc1 cc2 jp

rename cc2 commodity_code
sort commodity_code
merge m:1 commodity_code using `p_commodity_code_sitc'
keep if _merge==3
drop _merge
ge cp=jp/p
rename commodity_code cc2
drop if cc1==cc2

sort cc1 cc2
tempfile a
save `a', replace

rename cc1 cc1bis
rename cc2 cc2bis
rename cc1bis cc2
rename cc2bis cc1
rename cp cpbis
rename p pbis
sort cc1 cc2
merge 1:1 cc1 cc2 using `a' 
drop _merge 
drop jp pbis p
ge min_cp=cpbis
replace min_cp=cp if cpbis>cp
drop cpbis cp
rename min_cp proximity
keep year cc1 cc2 proximity

*Calculate density
sort cc1
by cc1: egen denom=total(proximity)

drop year 
 
** just for 1997 **

sort cc1 cc2

tempfile 1997
save "`1997'" 


clear
set more off 
set memory 1400000
*set maxvar 30000
set more off

tempfile en_curso
tempfile a
tempfile b
tempfile tier1
tempfile p_commodity_code_sitc
tempfile reporter
tempfile jp

* Determine the countries that appear in all years
use [COMTRADE Database Exports at HS6 1996 - 2003 - all except for Chile] 

rename reporteriso3 ecode

collapse tradevaluein1000usd, by(ecode year)

keep year ecode

sort ecode
by ecode: gen rank = _n
by ecode: egen max = max(rank)
tab max

keep if max == 8
** only countries available across all years ***

drop max rank

sort ecode
drop if ecode==ecode[_n-1]

sort ecode
save `en_curso',replace
*** This simply produces number of exporters for countries in all years ***


use [COUNTRY POPULATION from WDI]
*** This adds population data as we only want big countries included ***
keep if year == 1998
rename country_code ecode
sort ecode 

merge ecode using `en_curso'
tab _merge
keep if _merge == 3
drop _merge 

*Eliminate those countries with less than 3 million population
drop if population<3000000
sort ecode

tempfile data
save "`data'" 

*Open the database
use [COMTRADE X HS6 1996 - 2003 - all except for Chile] 
keep if year == 1998
drop year 

rename tradevaluein1000usd value 
rename codigo_ine isic7

rename reporteriso3 ecode
sort ecode
merge m:1 ecode using "`data'" 
keep if _merge==3
drop _merge
save `en_curso', replace

*For future operations we need the list of exporting countries
drop if ecode==ecode[_n-1]
*** to have just once each country ***
keep ecode
rename ecode reporter_code
*** just a list of exporting countries ***
save `reporter', replace

*Get one record per country and product
use `en_curso'
sort ecode isic7
by ecode isic7: egen t_value=total(value)
drop if ecode==ecode[_n-1] & isic7==isic7[_n-1]
*** way of again reducing anything double ***
drop value
rename t_value value

*Analyze whether the country has a RCA in the product
rename ecode reporter_code
rename isic7 commodity_code

sort reporter_code year
by reporter_code year: egen x_country=total(value)
*** country total exports ***

sort commodity_code year
by commodity_code year: egen x_product=total(value)
*** commodity total export ***

sort year
by year: egen x_total=total(value)
*** overall total exports ***

ge vcr=(value/x_country)/(x_product/x_total)
replace vcr=1 if vcr>1
replace vcr=0 if vcr<1

keep year reporter_code commodity_code vcr
sort commodity_code
save `en_curso', replace

*Get the number of countries
use `en_curso'
sort reporter_code
drop if reporter_code==reporter_code[_n-1]
keep reporter_code
scalar n_c=_N
save `a', replace

use `en_curso'
ge obs=n_c
save `tier1', replace

*We calculate the probability that a product gets a vcr equal to 1
sort commodity_code
by commodity_code: egen n1=count(vcr) if vcr==1
by commodity_code: egen n1_max=max(n1)
replace n1=n1_max if n1==.
ge p=n1/obs
drop n1 n1_max
sort commodity_code
drop if commodity_code==commodity_code[_n-1]
keep commodity_code p
sort commodity_code
save `p_commodity_code_sitc', replace

*Calculate the joint probability
use `tier1'
keep if vcr==1
if _N>1{
sort reporter_code
by reporter_code: egen obs1=count(vcr)
keep if obs1>1
if _N>1{
drop obs1
tempfile b
save `b', replace
*** keeps cases of joint probability, VCR = 1 ***
egen groups = group(reporter_code)
sum groups 
*** this shows it has 38 codes ***
tempfile data
save "`data'"
else{
tempfile a
save `a'
}
}
else{
tempfile a
save `a'
}
}

use "`data'"
keep if groups == 1 
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= 1
drop reporter_code
tempfile 1
save `1', replace 

forvalues i = 1(1)38 {
use "`data'"
keep if groups == `i'
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= `i'
drop reporter_code
tempfile `i'
save ``i''
}

*Add all the files
use `reporter'
forvalues i = 1(1)38 {
append using ``i''
}

drop reporter_code
drop if cc1==.

tempfile en_curso
save `en_curso', replace


*Count the number of cases that two products have comparative advantage
use `en_curso'
sort cc1 cc2
by cc1 cc2: egen nj=count(cc1)
drop if cc1==cc1[_n-1] & cc2==cc2[_n-1]
keep year cc1 cc2 nj
tempfile jp
save `jp', replace


use `tier1'
keep if _n==1
keep obs
cross using `jp'
ge jp=nj/obs
keep year cc1 cc2 jp

rename cc2 commodity_code
sort commodity_code
merge m:1 commodity_code using `p_commodity_code_sitc'
keep if _merge==3
drop _merge
ge cp=jp/p
rename commodity_code cc2
drop if cc1==cc2

sort cc1 cc2
tempfile a
save `a', replace

rename cc1 cc1bis
rename cc2 cc2bis
rename cc1bis cc2
rename cc2bis cc1
rename cp cpbis
rename p pbis
sort cc1 cc2
merge 1:1 cc1 cc2 using `a' 
drop _merge 
drop jp pbis p
ge min_cp=cpbis
replace min_cp=cp if cpbis>cp
drop cpbis cp
rename min_cp proximity
keep year cc1 cc2 proximity

*Calculate density
sort cc1
by cc1: egen denom=total(proximity)

drop year 
 
** just for 1998 **

sort cc1 cc2

tempfile 1998
save "`1998'" 

clear
set more off 
set memory 1400000
*set maxvar 30000
set more off


tempfile en_curso
tempfile a
tempfile b
tempfile tier1
tempfile p_commodity_code_sitc
tempfile reporter
tempfile jp

* Determine the countries that appear in all years
use [COMTRADE Database Exports at HS6 1996 - 2003 - all except for Chile] 

rename reporteriso3 ecode

collapse tradevaluein1000usd, by(ecode year)

keep year ecode

sort ecode
by ecode: gen rank = _n
by ecode: egen max = max(rank)
tab max

keep if max == 8
** only countries available across all years ***

drop max rank

sort ecode
drop if ecode==ecode[_n-1]

sort ecode
save `en_curso',replace
*** This simply produces number of exporters for countries in all years ***

use [COUNTRY POPULATION from WDI]
*** This adds population data as we only want big countries included ***
keep if year == 1999
rename country_code ecode
sort ecode 

merge ecode using `en_curso'
tab _merge
keep if _merge == 3
drop _merge 

*Eliminate those countries with less than 3 million population
drop if population<3000000
sort ecode

tempfile data
save "`data'" 

*Open the database
use [COMTRADE X HS6 1996 - 2003 - all except for Chile] 
keep if year == 1999
drop year 

rename tradevaluein1000usd value 
rename codigo_ine isic7

rename reporteriso3 ecode
sort ecode
merge m:1 ecode using "`data'" 
keep if _merge==3
drop _merge
save `en_curso', replace

*For future operations we need the list of exporting countries
drop if ecode==ecode[_n-1]
*** to have just once each country ***
keep ecode
rename ecode reporter_code
*** just a list of exporting countries ***
save `reporter', replace

*Get one record per country and product
use `en_curso'
sort ecode isic7
by ecode isic7: egen t_value=total(value)
drop if ecode==ecode[_n-1] & isic7==isic7[_n-1]
*** way of again reducing anything double ***
drop value
rename t_value value

*Analyze whether the country has a RCA in the product
rename ecode reporter_code
rename isic7 commodity_code

sort reporter_code year
by reporter_code year: egen x_country=total(value)
*** country total exports ***

sort commodity_code year
by commodity_code year: egen x_product=total(value)
*** commodity total export ***

sort year
by year: egen x_total=total(value)
*** overall total exports ***

ge vcr=(value/x_country)/(x_product/x_total)
replace vcr=1 if vcr>1
replace vcr=0 if vcr<1

keep year reporter_code commodity_code vcr
sort commodity_code
save `en_curso', replace

*Get the number of countries
use `en_curso'
sort reporter_code
drop if reporter_code==reporter_code[_n-1]
keep reporter_code
scalar n_c=_N
save `a', replace

use `en_curso'
ge obs=n_c
save `tier1', replace

*We calculate the probability that a product gets a vcr equal to 1
sort commodity_code
by commodity_code: egen n1=count(vcr) if vcr==1
by commodity_code: egen n1_max=max(n1)
replace n1=n1_max if n1==.
ge p=n1/obs
drop n1 n1_max
sort commodity_code
drop if commodity_code==commodity_code[_n-1]
keep commodity_code p
sort commodity_code
save `p_commodity_code_sitc', replace

*Calculate the joint probability
use `tier1'
keep if vcr==1
if _N>1{
sort reporter_code
by reporter_code: egen obs1=count(vcr)
keep if obs1>1
if _N>1{
drop obs1
tempfile b
save `b', replace
*** keeps cases of joint probability, VCR = 1 ***
egen groups = group(reporter_code)
sum groups 
*** this shows it has 38 codes ***
tempfile data
save "`data'"
else{
tempfile a
save `a'
}
}
else{
tempfile a
save `a'
}
}

use "`data'"
keep if groups == 1 
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= 1
drop reporter_code
tempfile 1
save `1', replace 

forvalues i = 1(1)38 {
use "`data'"
keep if groups == `i'
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= `i'
drop reporter_code
tempfile `i'
save ``i''
}

*Add all the files
use `reporter'
forvalues i = 1(1)38 {
append using ``i''
}

drop reporter_code
drop if cc1==.

tempfile en_curso
save `en_curso', replace


*Count the number of cases that two products have comparative advantage
use `en_curso'
sort cc1 cc2
by cc1 cc2: egen nj=count(cc1)
drop if cc1==cc1[_n-1] & cc2==cc2[_n-1]
keep year cc1 cc2 nj
tempfile jp
save `jp', replace


use `tier1'
keep if _n==1
keep obs
cross using `jp'
ge jp=nj/obs
keep year cc1 cc2 jp

rename cc2 commodity_code
sort commodity_code
merge m:1 commodity_code using `p_commodity_code_sitc'
keep if _merge==3
drop _merge
ge cp=jp/p
rename commodity_code cc2
drop if cc1==cc2

sort cc1 cc2
tempfile a
save `a', replace

rename cc1 cc1bis
rename cc2 cc2bis
rename cc1bis cc2
rename cc2bis cc1
rename cp cpbis
rename p pbis
sort cc1 cc2
merge 1:1 cc1 cc2 using `a' 
drop _merge 
drop jp pbis p
ge min_cp=cpbis
replace min_cp=cp if cpbis>cp
drop cpbis cp
rename min_cp proximity
keep year cc1 cc2 proximity

*Calculate density
sort cc1
by cc1: egen denom=total(proximity)

drop year 
 
** just for 1999 **

sort cc1 cc2

tempfile 1999
save "`1999'"

clear
set more off 
set memory 1400000
*set maxvar 30000
set more off


tempfile en_curso
tempfile a
tempfile b
tempfile tier1
tempfile p_commodity_code_sitc
tempfile reporter
tempfile jp

* Determine the countries that appear in all years
use [COMTRADE Database Exports at HS6 1996 - 2003 - all except for Chile] 

rename reporteriso3 ecode

collapse tradevaluein1000usd, by(ecode year)

keep year ecode

sort ecode
by ecode: gen rank = _n
by ecode: egen max = max(rank)
tab max

keep if max == 8
** only countries available across all years ***

drop max rank

sort ecode
drop if ecode==ecode[_n-1]

sort ecode
save `en_curso',replace
*** This simply produces number of exporters for countries in all years ***


use [COUNTRY POPULATION from WDI]
*** This adds population data as we only want big countries included ***
keep if year == 2000
rename country_code ecode
sort ecode 

merge ecode using `en_curso'
tab _merge
keep if _merge == 3
drop _merge 

*Eliminate those countries with less than 3 million population
drop if population<3000000
sort ecode

tempfile data
save "`data'" 

*Open the database
use [COMTRADE X HS6 1996 - 2003 - all except for Chile] 
keep if year == 2000
drop year 

rename tradevaluein1000usd value 
rename codigo_ine isic7

rename reporteriso3 ecode
sort ecode
merge m:1 ecode using "`data'" 
keep if _merge==3
drop _merge
save `en_curso', replace

*For future operations we need the list of exporting countries
drop if ecode==ecode[_n-1]
*** to have just once each country ***
keep ecode
rename ecode reporter_code
*** just a list of exporting countries ***
save `reporter', replace

*Get one record per country and product
use `en_curso'
sort ecode isic7
by ecode isic7: egen t_value=total(value)
drop if ecode==ecode[_n-1] & isic7==isic7[_n-1]
*** way of again reducing anything double ***
drop value
rename t_value value

*Analyze whether the country has a RCA in the product
rename ecode reporter_code
rename isic7 commodity_code

sort reporter_code year
by reporter_code year: egen x_country=total(value)
*** country total exports ***

sort commodity_code year
by commodity_code year: egen x_product=total(value)
*** commodity total export ***

sort year
by year: egen x_total=total(value)
*** overall total exports ***

ge vcr=(value/x_country)/(x_product/x_total)
replace vcr=1 if vcr>1
replace vcr=0 if vcr<1

keep year reporter_code commodity_code vcr
sort commodity_code
save `en_curso', replace


*Get the number of countries
use `en_curso'
sort reporter_code
drop if reporter_code==reporter_code[_n-1]
keep reporter_code
scalar n_c=_N
save `a', replace

use `en_curso'
ge obs=n_c
save `tier1', replace

*We calculate the probability that a product gets a vcr equal to 1
sort commodity_code
by commodity_code: egen n1=count(vcr) if vcr==1
by commodity_code: egen n1_max=max(n1)
replace n1=n1_max if n1==.
ge p=n1/obs
drop n1 n1_max
sort commodity_code
drop if commodity_code==commodity_code[_n-1]
keep commodity_code p
sort commodity_code
save `p_commodity_code_sitc', replace

*Calculate the joint probability
use `tier1'
keep if vcr==1
if _N>1{
sort reporter_code
by reporter_code: egen obs1=count(vcr)
keep if obs1>1
if _N>1{
drop obs1
tempfile b
save `b', replace
*** keeps cases of joint probability, VCR = 1 ***
egen groups = group(reporter_code)
sum groups 
*** this shows it has 38 codes ***
tempfile data
save "`data'"
else{
tempfile a
save `a'
}
}
else{
tempfile a
save `a'
}
}

use "`data'"
keep if groups == 1 
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= 1
drop reporter_code
tempfile 1
save `1', replace 

forvalues i = 1(1)38 {
use "`data'"
keep if groups == `i'
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= `i'
drop reporter_code
tempfile `i'
save ``i''
}

*Add all the files
use `reporter'
forvalues i = 1(1)38 {
append using ``i''
}

drop reporter_code
drop if cc1==.

tempfile en_curso
save `en_curso', replace


*Count the number of cases that two products have comparative advantage
use `en_curso'
sort cc1 cc2
by cc1 cc2: egen nj=count(cc1)
drop if cc1==cc1[_n-1] & cc2==cc2[_n-1]
keep year cc1 cc2 nj
tempfile jp
save `jp', replace


use `tier1'
keep if _n==1
keep obs
cross using `jp'
ge jp=nj/obs
keep year cc1 cc2 jp

rename cc2 commodity_code
sort commodity_code
merge m:1 commodity_code using `p_commodity_code_sitc'
keep if _merge==3
drop _merge
ge cp=jp/p
rename commodity_code cc2
drop if cc1==cc2

sort cc1 cc2
tempfile a
save `a', replace

rename cc1 cc1bis
rename cc2 cc2bis
rename cc1bis cc2
rename cc2bis cc1
rename cp cpbis
rename p pbis
sort cc1 cc2
merge 1:1 cc1 cc2 using `a' 
drop _merge 
drop jp pbis p
ge min_cp=cpbis
replace min_cp=cp if cpbis>cp
drop cpbis cp
rename min_cp proximity
keep year cc1 cc2 proximity

*Calculate density
sort cc1
by cc1: egen denom=total(proximity)

drop year 
 
sort cc1 cc2

tempfile 2000
save "`2000'" 

clear
set more off 
set memory 1400000
*set maxvar 30000
set more off


tempfile en_curso
tempfile a
tempfile b
tempfile tier1
tempfile p_commodity_code_sitc
tempfile reporter
tempfile jp

* Determine the countries that appear in all years
use [COMTRADE Database Exports at HS6 1996 - 2003 - all except for Chile] 

rename reporteriso3 ecode

collapse tradevaluein1000usd, by(ecode year)

keep year ecode

sort ecode
by ecode: gen rank = _n
by ecode: egen max = max(rank)
tab max

keep if max == 8
** only countries available across all years ***

drop max rank

sort ecode
drop if ecode==ecode[_n-1]

sort ecode
save `en_curso',replace
*** This simply produces number of exporters for countries in all years ***


use [COUNTRY POPULATION from WDI]
*** This adds population data as we only want big countries included ***
keep if year == 2001
rename country_code ecode
sort ecode 

merge ecode using `en_curso'
tab _merge
keep if _merge == 3
drop _merge 

*Eliminate those countries with less than 3 million population
drop if population<3000000
sort ecode

tempfile data
save "`data'" 

*Open the database
use [COMTRADE X HS6 1996 - 2003 - all except for Chile] 
keep if year == 2001
drop year 

rename tradevaluein1000usd value 
rename codigo_ine isic7

rename reporteriso3 ecode
sort ecode
merge m:1 ecode using "`data'" 
keep if _merge==3
drop _merge
save `en_curso', replace

*For future operations we need the list of exporting countries
drop if ecode==ecode[_n-1]
*** to have just once each country ***
keep ecode
rename ecode reporter_code
*** just a list of exporting countries ***
save `reporter', replace

*Get one record per country and product
use `en_curso'
sort ecode isic7
by ecode isic7: egen t_value=total(value)
drop if ecode==ecode[_n-1] & isic7==isic7[_n-1]
*** way of again reducing anything double ***
drop value
rename t_value value

*Analyze whether the country has a RCA in the product
rename ecode reporter_code
rename isic7 commodity_code

sort reporter_code year
by reporter_code year: egen x_country=total(value)
*** country total exports ***

sort commodity_code year
by commodity_code year: egen x_product=total(value)
*** commodity total export ***

sort year
by year: egen x_total=total(value)
*** overall total exports ***

ge vcr=(value/x_country)/(x_product/x_total)
replace vcr=1 if vcr>1
replace vcr=0 if vcr<1

keep year reporter_code commodity_code vcr
sort commodity_code
save `en_curso', replace

*Get the number of countries
use `en_curso'
sort reporter_code
drop if reporter_code==reporter_code[_n-1]
keep reporter_code
scalar n_c=_N
save `a', replace

use `en_curso'
ge obs=n_c
save `tier1', replace

*We calculate the probability that a product gets a vcr equal to 1
sort commodity_code
by commodity_code: egen n1=count(vcr) if vcr==1
by commodity_code: egen n1_max=max(n1)
replace n1=n1_max if n1==.
ge p=n1/obs
drop n1 n1_max
sort commodity_code
drop if commodity_code==commodity_code[_n-1]
keep commodity_code p
sort commodity_code
save `p_commodity_code_sitc', replace

*Calculate the joint probability
use `tier1'
keep if vcr==1
if _N>1{
sort reporter_code
by reporter_code: egen obs1=count(vcr)
keep if obs1>1
if _N>1{
drop obs1
tempfile b
save `b', replace
*** keeps cases of joint probability, VCR = 1 ***
egen groups = group(reporter_code)
sum groups 
*** this shows it has 38 codes ***
tempfile data
save "`data'"
else{
tempfile a
save `a'
}
}
else{
tempfile a
save `a'
}
}

use "`data'"
keep if groups == 1 
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= 1
drop reporter_code
tempfile 1
save `1', replace 

forvalues i = 1(1)38 {
use "`data'"
keep if groups == `i'
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= `i'
drop reporter_code
tempfile `i'
save ``i''
}

*Add all the files
use `reporter'
forvalues i = 1(1)38 {
append using ``i''
}

drop reporter_code
drop if cc1==.

tempfile en_curso
save `en_curso', replace


*Count the number of cases that two products have comparative advantage
use `en_curso'
sort cc1 cc2
by cc1 cc2: egen nj=count(cc1)
drop if cc1==cc1[_n-1] & cc2==cc2[_n-1]
keep year cc1 cc2 nj
tempfile jp
save `jp', replace


use `tier1'
keep if _n==1
keep obs
cross using `jp'
ge jp=nj/obs
keep year cc1 cc2 jp

rename cc2 commodity_code
sort commodity_code
merge m:1 commodity_code using `p_commodity_code_sitc'
keep if _merge==3
drop _merge
ge cp=jp/p
rename commodity_code cc2
drop if cc1==cc2

sort cc1 cc2
tempfile a
save `a', replace

rename cc1 cc1bis
rename cc2 cc2bis
rename cc1bis cc2
rename cc2bis cc1
rename cp cpbis
rename p pbis
sort cc1 cc2
merge 1:1 cc1 cc2 using `a' 
drop _merge 
drop jp pbis p
ge min_cp=cpbis
replace min_cp=cp if cpbis>cp
drop cpbis cp
rename min_cp proximity
keep year cc1 cc2 proximity

*Calculate density
sort cc1
by cc1: egen denom=total(proximity)

drop year 
 
gen year = 2001

sort cc1 cc2

tempfile 2001
save "`2001'" 


clear
set more off 
set memory 1400000
*set maxvar 30000
set more off

tempfile en_curso
tempfile a
tempfile b
tempfile tier1
tempfile p_commodity_code_sitc
tempfile reporter
tempfile jp

* Determine the countries that appear in all years
use [COMTRADE Database Exports at HS6 1996 - 2003 - all except for Chile] 

rename reporteriso3 ecode

collapse tradevaluein1000usd, by(ecode year)

keep year ecode

sort ecode
by ecode: gen rank = _n
by ecode: egen max = max(rank)
tab max

keep if max == 8
** only countries available across all years ***

drop max rank

sort ecode
drop if ecode==ecode[_n-1]

sort ecode
save `en_curso',replace
*** This simply produces number of exporters for countries in all years ***

use [COUNTRY POPULATION from WDI]
*** This adds population data as we only want big countries included ***
keep if year == 2002
rename country_code ecode
sort ecode 

merge ecode using `en_curso'
tab _merge
keep if _merge == 3
drop _merge 

*Eliminate those countries with less than 3 million population
drop if population<3000000
sort ecode

tempfile data
save "`data'" 

*Open the database
use [COMTRADE X HS6 1996 - 2003 - all except for Chile] 
keep if year == 2002
drop year 

rename tradevaluein1000usd value 
rename codigo_ine isic7

rename reporteriso3 ecode
sort ecode
merge m:1 ecode using "`data'" 
keep if _merge==3
drop _merge
save `en_curso', replace

*For future operations we need the list of exporting countries
drop if ecode==ecode[_n-1]
*** to have just once each country ***
keep ecode
rename ecode reporter_code
*** just a list of exporting countries ***
save `reporter', replace

*Get one record per country and product
use `en_curso'
sort ecode isic7
by ecode isic7: egen t_value=total(value)
drop if ecode==ecode[_n-1] & isic7==isic7[_n-1]
*** way of again reducing anything double ***
drop value
rename t_value value

*Analyze whether the country has a RCA in the product
rename ecode reporter_code
rename isic7 commodity_code

sort reporter_code year
by reporter_code year: egen x_country=total(value)
*** country total exports ***

sort commodity_code year
by commodity_code year: egen x_product=total(value)
*** commodity total export ***

sort year
by year: egen x_total=total(value)
*** overall total exports ***

ge vcr=(value/x_country)/(x_product/x_total)
replace vcr=1 if vcr>1
replace vcr=0 if vcr<1

keep year reporter_code commodity_code vcr
sort commodity_code
save `en_curso', replace

*Get the number of countries
use `en_curso'
sort reporter_code
drop if reporter_code==reporter_code[_n-1]
keep reporter_code
scalar n_c=_N
save `a', replace

use `en_curso'
ge obs=n_c
save `tier1', replace

*We calculate the probability that a product gets a vcr equal to 1
sort commodity_code
by commodity_code: egen n1=count(vcr) if vcr==1
by commodity_code: egen n1_max=max(n1)
replace n1=n1_max if n1==.
ge p=n1/obs
drop n1 n1_max
sort commodity_code
drop if commodity_code==commodity_code[_n-1]
keep commodity_code p
sort commodity_code
save `p_commodity_code_sitc', replace

*Calculate the joint probability
use `tier1'
keep if vcr==1
if _N>1{
sort reporter_code
by reporter_code: egen obs1=count(vcr)
keep if obs1>1
if _N>1{
drop obs1
tempfile b
save `b', replace
*** keeps cases of joint probability, VCR = 1 ***
egen groups = group(reporter_code)
sum groups 
*** this shows it has 38 codes ***
tempfile data
save "`data'"
else{
tempfile a
save `a'
}
}
else{
tempfile a
save `a'
}
}

use "`data'"
keep if groups == 1 
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= 1
drop reporter_code
tempfile 1
save `1', replace 

forvalues i = 1(1)38 {
use "`data'"
keep if groups == `i'
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= `i'
drop reporter_code
tempfile `i'
save ``i''
}

*Add all the files
use `reporter'
forvalues i = 1(1)38 {
append using ``i''
}

drop reporter_code
drop if cc1==.

tempfile en_curso
save `en_curso', replace


*Count the number of cases that two products have comparative advantage
use `en_curso'
sort cc1 cc2
by cc1 cc2: egen nj=count(cc1)
drop if cc1==cc1[_n-1] & cc2==cc2[_n-1]
keep year cc1 cc2 nj
tempfile jp
save `jp', replace


use `tier1'
keep if _n==1
keep obs
cross using `jp'
ge jp=nj/obs
keep year cc1 cc2 jp

rename cc2 commodity_code
sort commodity_code
merge m:1 commodity_code using `p_commodity_code_sitc'
keep if _merge==3
drop _merge
ge cp=jp/p
rename commodity_code cc2
drop if cc1==cc2

sort cc1 cc2
tempfile a
save `a', replace

rename cc1 cc1bis
rename cc2 cc2bis
rename cc1bis cc2
rename cc2bis cc1
rename cp cpbis
rename p pbis
sort cc1 cc2
merge 1:1 cc1 cc2 using `a' 
drop _merge 
drop jp pbis p
ge min_cp=cpbis
replace min_cp=cp if cpbis>cp
drop cpbis cp
rename min_cp proximity
keep year cc1 cc2 proximity

*Calculate density
sort cc1
by cc1: egen denom=total(proximity)

drop year 
 
** just for 2002 **

sort cc1 cc2

gen year = 2002

tempfile 2002
save "`2002'" 


clear
set more off 
set memory 1400000
*set maxvar 30000
set more off

tempfile en_curso
tempfile a
tempfile b
tempfile tier1
tempfile p_commodity_code_sitc
tempfile reporter
tempfile jp

* Determine the countries that appear in all years
use [COMTRADE Database Exports at HS6 1996 - 2003 - all except for Chile] 

rename reporteriso3 ecode

collapse tradevaluein1000usd, by(ecode year)

keep year ecode

sort ecode
by ecode: gen rank = _n
by ecode: egen max = max(rank)
tab max

keep if max == 8
** only countries available across all years ***

drop max rank

sort ecode
drop if ecode==ecode[_n-1]

sort ecode
save `en_curso',replace
*** This simply produces number of exporters for countries in all years ***


use [COUNTRY POPULATION from WDI]
*** This adds population data as we only want big countries included ***
keep if year == 2003
rename country_code ecode
sort ecode 

merge ecode using `en_curso'
tab _merge
keep if _merge == 3
drop _merge 

*Eliminate those countries with less than 3 million population
drop if population<3000000
sort ecode

tempfile data
save "`data'" 

*Open the database
use [COMTRADE X HS6 1996 - 2003 - all except for Chile] 
keep if year == 2003
drop year 

rename tradevaluein1000usd value 
rename codigo_ine isic7

rename reporteriso3 ecode
sort ecode
merge m:1 ecode using "`data'" 
keep if _merge==3
drop _merge
save `en_curso', replace

*For future operations we need the list of exporting countries
drop if ecode==ecode[_n-1]
*** to have just once each country ***
keep ecode
rename ecode reporter_code
*** just a list of exporting countries ***
save `reporter', replace

*Get one record per country and product
use `en_curso'
sort ecode isic7
by ecode isic7: egen t_value=total(value)
drop if ecode==ecode[_n-1] & isic7==isic7[_n-1]
*** way of again reducing anything double ***
drop value
rename t_value value

*Analyze whether the country has a RCA in the product
rename ecode reporter_code
rename isic7 commodity_code

sort reporter_code year
by reporter_code year: egen x_country=total(value)
*** country total exports ***

sort commodity_code year
by commodity_code year: egen x_product=total(value)
*** commodity total export ***

sort year
by year: egen x_total=total(value)
*** overall total exports ***

ge vcr=(value/x_country)/(x_product/x_total)
replace vcr=1 if vcr>1
replace vcr=0 if vcr<1

keep year reporter_code commodity_code vcr
sort commodity_code
save `en_curso', replace
 
*Get the number of countries
use `en_curso'
sort reporter_code
drop if reporter_code==reporter_code[_n-1]
keep reporter_code
scalar n_c=_N
save `a', replace

use `en_curso'
ge obs=n_c
save `tier1', replace

*We calculate the probability that a product gets a vcr equal to 1
sort commodity_code
by commodity_code: egen n1=count(vcr) if vcr==1
by commodity_code: egen n1_max=max(n1)
replace n1=n1_max if n1==.
ge p=n1/obs
drop n1 n1_max
sort commodity_code
drop if commodity_code==commodity_code[_n-1]
keep commodity_code p
sort commodity_code
save `p_commodity_code_sitc', replace

*Calculate the joint probability
use `tier1'
keep if vcr==1
if _N>1{
sort reporter_code
by reporter_code: egen obs1=count(vcr)
keep if obs1>1
if _N>1{
drop obs1
tempfile b
save `b', replace
*** keeps cases of joint probability, VCR = 1 ***
egen groups = group(reporter_code)
sum groups 
*** this shows it has 38 codes ***
tempfile data
save "`data'"
else{
tempfile a
save `a'
}
}
else{
tempfile a
save `a'
}
}

use "`data'"
keep if groups == 1 
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= 1
drop reporter_code
tempfile 1
save `1', replace 

forvalues i = 1(1)38 {
use "`data'"
keep if groups == `i'
keep year commodity_code 
save `a', replace
keep commodity_code
rename commodity_code cc1
cross using `a'
rename commodity_code cc2
ge reporter_code= `i'
drop reporter_code
tempfile `i'
save ``i''
}

*Add all the files
use `reporter'
forvalues i = 1(1)38 {
append using ``i''
}

drop reporter_code
drop if cc1==.

tempfile en_curso
save `en_curso', replace


*Count the number of cases that two products have comparative advantage
use `en_curso'
sort cc1 cc2
by cc1 cc2: egen nj=count(cc1)
drop if cc1==cc1[_n-1] & cc2==cc2[_n-1]
keep year cc1 cc2 nj
tempfile jp
save `jp', replace

use `tier1'
keep if _n==1
keep obs
cross using `jp'
ge jp=nj/obs
keep year cc1 cc2 jp

rename cc2 commodity_code
sort commodity_code
merge m:1 commodity_code using `p_commodity_code_sitc'
keep if _merge==3
drop _merge
ge cp=jp/p
rename commodity_code cc2
drop if cc1==cc2

sort cc1 cc2
tempfile a
save `a', replace

rename cc1 cc1bis
rename cc2 cc2bis
rename cc1bis cc2
rename cc2bis cc1
rename cp cpbis
rename p pbis
sort cc1 cc2
merge 1:1 cc1 cc2 using `a' 
drop _merge 
drop jp pbis p
ge min_cp=cpbis
replace min_cp=cp if cpbis>cp
drop cpbis cp
rename min_cp proximity
keep year cc1 cc2 proximity

*Calculate density
sort cc1
by cc1: egen denom=total(proximity)

drop year 
 
** just for 2003 **

sort cc1 cc2

gen year = 2003 

tempfile 2003
save "`2003'" 

**********************************************************************************************************************************

use "`1996'" 
append using "`1997'" 
append using "`1998'"
append using "`1999'" 
append using "`2000'"
append using "`2001'"
append using "`2002'"
append using "`2003'"

sort cc1 cc2 year proximity
by cc1 cc2: egen av_prox_96_03 = mean(proximity)

collapse (max) av_prox_96_03, by(cc1 cc2)

sort cc1 cc2

save "Product2Product_Proximity.dta", replace


