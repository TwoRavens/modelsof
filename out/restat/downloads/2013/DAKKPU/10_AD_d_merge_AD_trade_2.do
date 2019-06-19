set more off
pause off

local ph0 "C:\RESTAT\"

cd "`ph0'"

local hs88hs07 "`ph0'hs88hs07"
local hs88hs02 "`ph0'hs88hs02"
local hs88hs96 "`ph0'hs88hs96"


#delimit ;
global ppp "
ARG
AUS
BRA
CAN
CHL
CHN
COL
EUN
IDN
IND
JPN
MEX
PER
TUR
USA
";

#delimit cr
foreach p of global ppp {

use "temp2`p'.dta", clear
display "**********************************************************************************`p'"
display "*****************************************************************drop if hs_digits==4"
drop if hs_digits==4
		*CONVERT TO HS88
		tab nomencode
		gen hs07=hs6 if nomencode=="H3"
		sort hs07
		merge hs07 using `hs88hs07'
		tab _m 
		drop if _m==2
		drop _m
		gen hscode=hs88 if nomencode=="H3"
		drop hs07 hs88

		gen hs02=hs6 if nomencode=="H2"
		sort hs02
		merge hs02 using `hs88hs02.dta'
		tab _m 
		drop if _m==2
		drop _m
		replace hscode=hs88 if nomencode=="H2"
		drop hs02 hs88

		gen hs96=hs6 if nomencode=="H1"
		sort hs96
		merge hs96 using `hs88hs96.dta'
		tab _m 
		drop if _m==2
		drop _m
		replace hscode=hs88 if nomencode=="H1"
		drop hs96 hs88

		rename hscode hs88
		save "temp3`p'", replace
}


use "temp2TUR", clear
tab nomencode
keep if hs_digits==4
keep hs6
rename hs6 hs4
sort hs4
save temp1, replace

use "TradeTUR.dta", clear
gen str4 hs4=substr(hs_code, 1, 4)
sort hs4
merge hs4 using temp1
tab _m
keep if _m==3
drop _m
gen str6 hs6=substr(hs_code, 1, 6)
collapse (sum) trade, by( nomencode ccode pcode yrtr hs4 hs6)
sort pcode hs4
save temp2, replace


use "temp2TUR", clear
keep if hs_digits==4
drop trade
rename hs6 hs4
sort pcode hs4
qui by pcode hs4: gen check=_N
tab check
drop check
sort pcode hs4
merge pcode hs4 using temp2
tab _m
drop if _m==2
drop _m
gen hs07=hs6 
sort hs07
merge hs07 using `hs88hs07.dta'
tab _m
drop if _m==2
drop _m
gen hscode=hs88
drop hs07 hs88 hs4 
rename hscode hs88
append using "temp3TUR"
egen test=sum(trade)
sum test tradeeffect
drop test
save "temp3TUR", replace

*****************************************************************************************************

use "temp2IND", clear
tab nomencode
keep if hs_digits==4
keep hs6
rename hs6 hs4
sort hs4
save temp1, replace

use "TradeIND.dta", clear
gen str4 hs4=substr(hs_code, 1, 4)
sort hs4
merge hs4 using temp1
tab _m
keep if _m==3
drop _m
gen str6 hs6=substr(hs_code, 1, 6)
collapse (sum) trade, by( nomencode ccode pcode yrtr hs4 hs6)
sort pcode hs4
save temp2, replace


use "temp2IND", clear
keep if hs_digits==4
drop trade
rename hs6 hs4
sort pcode hs4
qui by pcode hs4: gen check=_N
tab check
drop check
sort pcode hs4
merge pcode hs4 using temp2
tab _m
drop if _m==2
drop _m
gen hs02=hs6 
sort hs02
merge hs02 using `hs88hs02.dta'
tab _m
drop if _m==2
drop _m
gen hscode=hs88
drop hs02 hs88 hs4 
rename hscode hs88
append using "temp3IND"
egen test=sum(trade)
sum test tradeeffect
drop test
save "temp3IND", replace

erase temp1.dta
erase temp2.dta
