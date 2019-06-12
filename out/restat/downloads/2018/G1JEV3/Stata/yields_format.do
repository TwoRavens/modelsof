// formats daily yields series to Stata
set more off
clear all
import excel "$pathF4\HistoricalOvernightTreasGCRepoPriDealerSurvRate.xlsx", sheet("Sheet1") firstrow
rename Date date_day
format %td date_day
g year = year(date_day)
g month = month(date_day)
g day = day(date_day)
order tgc_repo, last
destring tgc_repo, force replace
save "$path3\\REPO.dta", replace
clear
import excel "$pathF4\T5YIFR.xls", sheet("Sheet1") firstrow
rename Date date_day
format %td date_day
g year = year(date_day)
g month = month(date_day)
g day = day(date_day)
order T5YIFR, last
save "$path3\\T5YIFR.dta", replace

clear
import excel "$pathF4\DFF.xls", sheet("Sheet1") firstrow
rename Date date_day
save "$pathF\DFF.dta", replace
clear
import excel "$pathF4\DTB3.xls", sheet("Sheet1") firstrow
rename Date date_day
save "$pathF\yields_d.dta", replace
clear
import excel "$pathF4\DGS3MO.xls", sheet("Sheet1") firstrow
rename Date date_day
joinby date_day using "$pathF\yields_d.dta", unmatched(both) update
tab _merge
drop _merge
joinby date_day using "$pathF\USATB.dta", unmatched(both) update
tab _merge
drop _merge day-quarter
joinby date_day using "$pathF\DFF.dta", unmatched(master) update
tab _merge
drop _merge
save "$pathF\yields_d.dta", replace

clear
import excel "$pathF4\yields_fed2.xlsx", sheet("Sheet1") firstrow
g date_day = date(A, "YMD")
joinby date_day using "$pathF\yields_d.dta", unmatched(master) update
tab _merge
drop _merge
format %td date_day
g year = year(date_day)
g month = month(date_day)
g day = day(date_day)

g day0 = substr(A,9,10)
g year0 = substr(A,1,4)
g month0 = substr( substr(A,6,7), 1, 2)
destring day0 year0 month0, replace force

g date_day2= mdy(month0,day0,year0)
pwcorr date_day*
sum date_day*
drop if year==.
drop if year<1992
drop A day0 year0 month0
g quarter = ceil(month/3)
order date_day day month year quarter, first
save "$pathF\yields_d.dta", replace
save "$path1\yields_d.dta", replace
