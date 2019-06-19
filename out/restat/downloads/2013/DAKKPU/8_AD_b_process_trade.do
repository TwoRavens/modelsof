set more off
pause off

cd "C:\RESTAT\"

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

insheet using "file_`p'_2008.txt", clear
display "***********************************************************************************`p'"
tab nomencode
drop  quantity qtytoken tradeflow
rename  tradevalue trade
rename  year yrtr
rename  reporteriso3 ccode
rename  partneriso3 pcode
drop if pcode=="UNS"
gen hs_code=rtrim( productcode)
gen hs_digits=length(hs_code)
tab hs_digits
tab yrtr
drop productcode
sort ccode pcode hs_code
qui by ccode pcode hs_code: gen check=_N
tab check
drop check 
collapse (sum)  trade, by(nomencode yrtr ccode pcode hs_code hs_digits)
sort pcode hs_code ccode
qui by pcode hs_code ccode: gen check=_N
tab check
drop check
save "Trade`p'.dta", replace

}


********************************************************************************************
use "TradeARG.dta", clear
gen str6 hs6=substr(hs_code, 1, 6)
collapse (sum)  trade, by( nomencode ccode pcode yrtr  hs6 hs_digits)
tab hs_digits
replace hs_digits=6
rename hs6 hs_code
sort pcode hs_code
qui by pcode hs_code: gen check=_N
tab check
drop check
save trade_add_ARG, replace



use "TradeAUS.dta", clear
gen str8 hs8=substr(hs_code, 1, 8)
collapse (sum)  trade, by( nomencode ccode pcode yrtr  hs8 hs_digits)
tab hs_digits
replace hs_digits=8
rename hs8 hs_code
sort pcode hs_code
qui by pcode hs_code: gen check=_N
tab check
drop check
save trade_add_AUS, replace


use "TradeIND.dta", clear
gen str6 hs6=substr(hs_code, 1, 6)
collapse (sum)  trade, by( nomencode ccode pcode yrtr  hs6 hs_digits)
tab hs_digits
replace hs_digits=6
rename hs6 hs_code
sort pcode hs_code
qui by pcode hs_code: gen check=_N
tab check
drop check
save trade_add_IND, replace

use "TradeIND.dta", clear
gen str4 hs4=substr(hs_code, 1, 4)
collapse (sum)  trade, by( nomencode ccode pcode yrtr  hs4 hs_digits)
tab hs_digits
replace hs_digits=4
rename hs4 hs_code
sort pcode hs_code
qui by pcode hs_code: gen check=_N
tab check
drop check
append using trade_add_IND
save trade_add_IND, replace


use "TradePER.dta", clear
gen str8 hs8=substr(hs_code, 1, 8)
collapse (sum)  trade, by( nomencode ccode pcode yrtr  hs8 hs_digits)
tab hs_digits
replace hs_digits=8
rename hs8 hs_code
sort pcode hs_code
qui by pcode hs_code: gen check=_N
tab check
drop check
save trade_add_PER, replace


use "TradeTUR.dta", clear
gen str6 hs6=substr(hs_code, 1, 6)
collapse (sum)  trade, by( nomencode ccode pcode yrtr  hs6 hs_digits)
tab hs_digits
replace hs_digits=6
rename hs6 hs_code
sort pcode hs_code
qui by pcode hs_code: gen check=_N
tab check
drop check
save trade_add_TUR, replace

use "TradeTUR.dta", clear
gen str4 hs4=substr(hs_code, 1, 4)
collapse (sum)  trade, by( nomencode ccode pcode yrtr  hs4 hs_digits)
tab hs_digits
replace hs_digits=4
rename hs4 hs_code
sort pcode hs_code
qui by pcode hs_code: gen check=_N
tab check
drop check
append using trade_add_TUR
save trade_add_TUR, replace



********************************************************************************************

