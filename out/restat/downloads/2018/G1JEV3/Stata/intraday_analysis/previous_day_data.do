set more off

use "$path1\\AnnouncementReleases1.dta", clear
sum
use "$path1\\FED_dissent_date.dta", clear
sum year
use "$path1\FED_dissent_6dayW.dta", clear
drop if window1<-1
drop if window1>1
tab window1
save "$path1\FED_dissent_3dayW.dta", replace
replace date_day=date_day+1 if date_FOMC==133
replace day=day+1 if date_FOMC==133
drop date_BS date_day2
save "$path1\FED_dissent_3dayW.dta", replace
use "$path1\FED_dissent_6dayW.dta", clear
replace date_day=date_day+1 if date_FOMC==133
replace day=day+1 if date_FOMC==133
drop date_BS date_day2
save "$path1\FED_dissent_6dayW2.dta", replace

use "$path3\\Tick_5min_events_dissent.dta", clear
joinby date_day using "$path1\FED_dissent_3dayW.dta", unmatched(master) update
tab _merge
/*
// for 17sep2001 use SP_close of 1092.58 from 10sep2001
// for 17aug2007 use SP_close of 1414.84 from 16sep2007
// For 22jan2008 use ES futures quote of 1271.25 (ES) or 1325.27 as the closing value of the SP
// For 08oct2008 use SP_close of 997.88 from previous day
*/
drop _merge
sum SP* if day==21 & month==1 & year==2008
replace hour=hour+1
local vars1 "SP TY FV TU ES IAP ED" // 
egen x_close=rowmax(*_close)
drop if x_close==.
drop x_close
keep if hour<=10 | hour>=15
sort date_day hour minute
egen time=group(date_day hour minute)
tsset time
foreach x of local vars1 {
g `x'_close_lag=L.`x'_close
g `x'_open_lag=L.`x'_open
g `x'_close_fw=F.`x'_close
g `x'_open_fw=F.`x'_open
}
local vars1 "ESVol_log ESVol spread_CS_ES spread_CS_SP tickC_SP tickC_ES" // 
g ESVol_log = ln(ES_volume)
g ESVol = ES_volume
rename SP_tickcou tickC_SP
rename ES_tickcou tickC_ES
foreach x of local vars1 {
g `x'_lag=L.`x'
g `x'_fw=F.`x'
}
keep if window==0 //keep if window==-1  //drop if minute>0
collapse (mean) dissent (firstnm) *lag (lastnm) *fw, by(date_day day month year date_FOMC) 
sum SP*
sum SP* ES* dissent if date_FOMC==74 |  date_FOMC==123  |  date_FOMC==127 | date_FOMC==134
tab date_day if date_FOMC==74 |  date_FOMC==123  |  date_FOMC==127  | date_FOMC==134 // no data for previous day 17sep2001 (monday), 22jan2008 (previous day is Martin Luther King Jr. Day)
save "$path3\\Tick_5min_events_lagfw.dta", replace
