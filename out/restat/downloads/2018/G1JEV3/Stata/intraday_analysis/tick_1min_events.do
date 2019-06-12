/* 1)   the S&P 500 cash index back to 1983 (symbol SP)
2)      futures data for the U.S. 10-year T-note back to 1983 (symbol TY)
3)      futures data for the U.S. 5-year T-note back to 1988 (symbol FV)
4)      futures data for the U.S. 2-year T-note back to 1991 (symbol TU)
5)      volume on E-mini S&P500 futures (ES?)
6)      data for the VIX index back to 2003 (symbol IAP)
7)   data on the Eurodollar futures contract (symbol is ED). */

set more off
clear
import delimited "$path2\output\1m intraday observations\\SP_1.csv"
g date_day = date(date, "MDY")
format %td date_day
g hour = substr(time,1,2)
g minute = substr(time,4,5)
destring hour minute, force replace
drop date time
capture recode volume 0=.
foreach var of varlist open-tickcount {
rename `var' SP_`var' 
}
save "$path3\\Tick_1min_events.dta", replace
forv x=2/4 {
clear
import delimited "$path2\output\1m intraday observations\\SP_`x'.csv"
g date_day = date(date, "MDY")
format %td date_day
g hour = substr(time,1,2)
g minute = substr(time,4,5)
destring hour minute, force replace
drop date time
capture recode volume 0=.
foreach var of varlist open-tickcount {
rename `var' SP_`var' 
}
joinby date_day hour minute using "$path3\\Tick_1min_events.dta", unmatched(both) update
drop _merge
save "$path3\\Tick_1min_events.dta", replace
}
//

local vars1 "TY FV TU ES IAP ED" // 
foreach x of local vars1 {
clear
import delimited "$path2\output\1m intraday observations\\`x'.csv"
g date_day = date(date, "MDY")
format %td date_day
g hour = substr(time,1,2)
g minute = substr(time,4,5)
destring hour minute, force replace
drop date time
capture recode volume 0=.
foreach var of varlist open-tickcount {
rename `var' `x'_`var' 
}
joinby date_day hour minute using "$path3\\Tick_1min_events.dta", unmatched(both) update
drop _merge
save "$path3\\Tick_1min_events.dta", replace
}
g year = year(date_day)
g month = month(date_day)
g day = day(date_day)
order date_day hour minute day month year, first
save "$path3\\Tick_1min_events.dta", replace

use "$path3\\Tick_1min_events.dta", clear // Merge TickData with Dissent and FOMC Events
joinby date_day using "$path1\\FED_dissent_date.dta", unmatched(both) update
tab _merge
drop _merge
joinby date_day using "$path1\\AnnouncementReleases1.dta", unmatched(master) update
tab _merge
drop _merge
drop if year<1993 //No press statements before then
compress
save "$path3\\Tick_1min_events_dissent.dta", replace
joinby date_day hour minute using "$path3\\Tick_5min_events_dissent.dta", unmatched(both) update
tab _merge
drop _merge
compress
save "$path3\\Tick_1min_events_dissent2.dta", replace
