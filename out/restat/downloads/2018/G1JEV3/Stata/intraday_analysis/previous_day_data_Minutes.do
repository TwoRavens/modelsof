set more off
use "$path3\\Tick_5min_events_dissent.dta", clear
joinby date_day using "$path1\FED3_dissent_date_MinutesPre02.dta", unmatched(master) update
tab _merge
drop _merge
replace hour=hour+1
local vars1 "SP" //  TY FV TU ES IAP ED
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
keep if date_M<. //keep if window==0 //keep if window==-1  //drop if minute>0
collapse (mean) dissent (firstnm) *lag (lastnm) *fw, by(date_day day month year date_FOMC) 
sum SP*
save "$path3\\Tick_Minutes_lagfw.dta", replace
