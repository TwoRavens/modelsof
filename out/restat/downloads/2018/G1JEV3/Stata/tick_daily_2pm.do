/*import excel "D:\Docs2\CM_JM\yields_fed2.xlsx", sheet("Sheet1") firstrow
g day0 = substr(A,9,10) */

/* 1)   the S&P 500 cash index back to 1983 (symbol SP)
2)      futures data for the U.S. 10-year T-note back to 1983 (symbol TY)
3)      futures data for the U.S. 5-year T-note back to 1988 (symbol FV)
4)      futures data for the U.S. 2-year T-note back to 1991 (symbol TU)
5)      volume on E-mini S&P500 futures (ES?)
6)      data for the VIX index back to 2003 (symbol IAP)
7)   data on the Eurodollar futures contract (symbol is ED). */

local vars1 "SP TY FV TU ES IAP ED" // 
local k=1
foreach x of local vars1 {
clear
import delimited "$path2\output\1pm daily observations\\`x'.csv"
g date_day = date(date, "MDY")
format %td date_day
drop date
capture recode volume 0=.
foreach var of varlist open-tickcount {
rename `var' `x'_`var' 
}
if `k'==1 {
save "$path3\\Tick_daily2pm.dta", replace
}
else {
joinby date_day using "$path3\\Tick_daily2pm.dta", unmatched(both) update
drop _merge
save "$path3\\Tick_daily2pm.dta", replace
}
local k=1+`k'
}
g year = year(date_day)
g month = month(date_day)
g day = day(date_day)
order date_day day month year, first
save "$path3\\Tick_daily2pm.dta", replace

if ${tick_daily_op}==1 {
use "$path3\\\Tick_5min_events.dta", clear
egen nr_tick=group(hour minute)
drop if hour<13 //keep if hour==13 & minute==0
sort date_day nr_tick
drop hour minute spread*
collapse (first) *open (last) *close (sum) *volu* *tick*, by(date_day day month year)
save "$path3\\Tick_daily2pm.dta", replace 
use "$path3\\\Tick_1min_events.dta", clear
egen nr_tick=group(hour minute)
drop if hour<13 //keep if hour==13 & minute==0
sort date_day nr_tick
drop hour minute 
collapse (first) *open (last) *close (sum) *volu* *tick*, by(date_day day month year)
joinby date_day day month year using "$path3\\Tick_daily2pm.dta", unmatched(both) update
tab _merge
bysort _merge: sum year
drop _merge
joinby date_day day month year using "$path3\\Tick_daily2pm_2017.dta", unmatched(both) update
tab _merge
bysort _merge: sum year
drop _merge
save "$path3\\Tick_daily2pm.dta", replace 
use "$path3\\Tick_daily2pm_2017.dta", clear
joinby date_day day month year using "$path3\\Tick_daily2pm.dta", unmatched(both) update
tab _merge
bysort _merge: sum year
drop _merge
save "$path3\\Tick_daily2pm.dta", replace 
}
//  //
