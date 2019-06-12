// Kuttner FED surprise
clear
import excel "$pathF2\\Kuttner_fed_surprise.xls", firstrow
rename A Date
save "$pathF2\\FED_surprise.dta", replace

clear
import excel "$pathF2\\CHRIS-CME_FF1.xls", firstrow  //import excel "$pathF2\\CME_FF1.xls", firstrow
sort Date
g year = year(Date)
g day = day(Date)
g month = month(Date)
g quarter = ceil(month/3) 
*bysort year month: egen D0 = max(day)
g D = 31
replace D = 30 if month==11 | month==4 | month==6 | month==9
replace D = 28 if month==2
g leap_year = year/4
replace leap_year = leap_year- int(year/4)
replace leap_year = (leap_year==0)
replace D = 29 if month==2 & leap_year==1
tab D
g last_3days = D-2
g dummy_3days = (day>=last_3days)
tsset Date
g Settle0 = 100-Settle
g Kuttner_surprise = L.Settle0
replace Kuttner_surprise = Settle0-Kuttner_surprise
replace Kuttner_surprise = (D/(D-day))*Kuttner_surprise if dummy_3days==0
joinby Date using "$pathF2\\FED_surprise.dta", unmatched(both) update
tab _merge
drop _merge
replace Kuttner_surprise = round(100*Kuttner_surprise)
replace Kuttner_surprise = Surprise if Kuttner_surprise==.
g abs0 = abs(Kuttner_surprise)
g abs1 = abs(Surprise)
replace Kuttner_surprise = Surprise if abs0>abs1
sum Kuttner_surprise Surprise if Surprise<. 
pwcorr Kuttner_surprise Surprise
*drop if year<1993
*drop if year==2014 & month>=3
drop leap_year last_3days abs0 abs1
pwcorr Kuttner_surprise Surprise
keep Date year- quarter D dummy_3days Kuttner_surprise FFrate FOMC_meeting
rename FOMC_meeting FOMC_meeting_Kuttner
drop FFrate FOMC_meeting_Kuttner
save "$pathF2\\FED_surprise.dta", replace
save "$path1\\FED_surprise.dta", replace
