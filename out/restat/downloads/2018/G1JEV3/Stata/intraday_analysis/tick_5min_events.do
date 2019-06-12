/*import excel "D:\Docs2\CM_JM\yields_fed2.xlsx", sheet("Sheet1") firstrow */
/* 1)   the S&P 500 cash index back to 1983 (symbol SP)
2)      futures data for the U.S. 10-year T-note back to 1983 (symbol TY)
3)      futures data for the U.S. 5-year T-note back to 1988 (symbol FV)
4)      futures data for the U.S. 2-year T-note back to 1991 (symbol TU)
5)      volume on E-mini S&P500 futures (ES?)
6)      data for the VIX index back to 2003 (symbol IAP)
7)   data on the Eurodollar futures contract (symbol is ED). */
set more off
local vars1 "SP TY FV TU ES IAP ED" // 
local k=1
foreach x of local vars1 {
clear
import delimited "$path2\output\5m intraday observations\\`x'.csv"
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
capture rename spread_corwin_schultz spread_CS_`x'
if `k'==1 {
save "$path3\\Tick_5min_events.dta", replace
}
else {
joinby date_day hour minute using "$path3\\Tick_5min_events.dta", unmatched(both) update
drop _merge
save "$path3\\Tick_5min_events.dta", replace
}
local k=1+`k'
}
g year = year(date_day)
g month = month(date_day)
g day = day(date_day)
order date_day hour minute day month year, first
save "$path3\\Tick_5min_events.dta", replace

use "$path1\\AnnouncementReleases.dta", clear // Hour, minute, date of FOMC Events
g year = year(Meetingdate)
g month = month(Meetingdate)
g day = day(Meetingdate)
g hh_GSS= hh(TimeofannouncementGrkaynak)
g mm_GSS = mm(TimeofannouncementGrkaynak)
g hh_GW= hh(TimeofannouncementGorodniche)
g mm_GW = mm(TimeofannouncementGorodniche)
g hh_LM = hh(TimeofannouncementLuccaMoen)
g mm_LM = mm(TimeofannouncementLuccaMoen)
g date_day = Meetingdate
format %td date_day
g FOMC_unscheduled1=0
replace FOMC_unscheduled1=1 if Meetingtype=="U"
keep year-day date_day FOMC_unscheduled1 *_GW *_LM *_GSS
order date_day year-day FOMC_unscheduled1
save "$path1\\AnnouncementReleases1.dta", replace

use "$path3\\Tick_5min_events.dta", clear // Merge TickData with Dissent and FOMC Events
joinby date_day using "$path1\\FED_dissent_date.dta", unmatched(both) update
tab _merge
drop _merge
joinby date_day using "$path1\\AnnouncementReleases1.dta", unmatched(both) update
tab _merge
sum year if _merge==2
sum year if _merge==1
sum year if _merge==3 // FOMC announcements go from 1994 to 2016 (15jun2016)
tab date_day if _merge==3 & year==2016 // Last intraday session is 15jun2016 
tab date_day if _merge==2
drop if _merge==2
drop _merge
drop if year<1993 //No press statements before then
compress
save "$path3\\Tick_5min_events_dissent.dta", replace
