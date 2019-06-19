set more off
pause off

cd "C:\RESTAT\"

tempfile temp

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
KOR
MEX
PER
TUR
USA
ZAF
";

#delimit cr
foreach p of global ppp {

use "file_`p'_master.dta", clear
display "**********************************************************************************`p'"
drop if case_id=="a"
drop var
rename  inv_cty_code pcode
keep  case_id pcode duty
sort  case_id
qui by  case_id: gen check=_N
tab check
drop check

save `temp', replace

use "file_`p'_prod.dta", clear
cap replace  hs_code=var8 if hs_code=="."
keep case_id hs_code hs_digits
sort case_id
merge case_id using `temp'
tab _m
keep if _m==3
drop _m
replace  hs_code="" if  hs_code=="MI"
replace  hs_digits="" if  hs_digits=="MI"
replace  hs_code="" if  hs_code=="."
replace  hs_digits="" if  hs_digits=="."

drop if  hs_code==""& hs_digits==""
tab hs_digits
destring hs_digits, replace
tab  hs_digits
sort case_id hs_code
qui by  case_id hs_code: gen check=_N
tab check
drop check
sort pcode hs_code
qui by  pcode hs_code: gen check=_N
tab check
drop check
sort  pcode hs_code hs_digits
save "temp`p'", replace
}

use "file_JPN_master.dta", clear
display "**********************************************************************************`p'"
drop if case_id=="a"
drop var
rename  inv_cty_code pcode
keep  case_id pcode duty
gen hs_code="260200011"
gen hs_digits=9
sort  case_id
qui by  case_id: gen check=_N
tab check
drop check
sort  pcode hs_code hs_digits
save tempJPN, replace


use "tempARG.dta", clear
keep if hs_digits==11
gen str8 a=substr( hs_code, 1, 8) 
replace hs_code=a
drop a
sort  case_id hs_code hs_digits pcode
qui by case_id hs_code hs_digits pcode: gen check=_N
tab check
qui by case_id hs_code hs_digits pcode: gen check2=_n
keep if check2==1
drop check check2
sort pcode hs_code
qui by pcode hs_code: gen check=_N
tab check
drop check
replace hs_digits=8 
sort pcode hs_code hs_digits
save `temp', replace

use "tempARG.dta", clear
drop if hs_digits==11
append using `temp'
sort pcode hs_code hs_digits
save "tempARG.dta", replace

use "tempIDN.dta", clear
gen str9 a=substr( hs_code, 1, 9) 
replace hs_code=a
drop a
sort  case_id hs_code hs_digits pcode
qui by case_id hs_code hs_digits pcode: gen check=_N
tab check
qui by case_id hs_code hs_digits pcode: gen check2=_n
keep if check2==1
drop check check2
sort pcode hs_code
qui by pcode hs_code: gen check=_N
tab check
drop check
replace hs_digits=9 
sort pcode hs_code hs_digits
save "tempIDN.dta", replace



