set more off
pause off

cd "C:\RESTAT"


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

use "Trade`p'.dta", clear
display "**********************************************************************************`p'"
cap append using "trade_add_`p'"
drop if hs_digits==6&ccode=="CHL"
drop if hs_digits==6&ccode=="MEX"
sort pcode hs_code hs_digits
merge pcode hs_code hs_digits using "temp`p'"
tab _m
local a =  nomencode
drop nomencode
gen nomencode="`a'"
local b =  ccode
drop ccode
gen ccode="`b'"
order nomencode ccode
drop if _m==1
tab nomencode
tab hs_digits _m 
drop _m
egen tradeeffect=sum(trade)
gen hs6= hs_code
replace hs6=substr(hs_code, 1, 6) if  hs_digits>=6
replace  hs6= hs_code if hs_digits<6
save "temp2`p'", replace
}





