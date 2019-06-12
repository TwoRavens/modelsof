set more off
clear

import excel "$path1\Minutes release dates2.xlsx", sheet("Sheet1")
g date = A
replace date=regexr(date," PM","")
replace date=regexr(date,"PM","")
g time_hour=word(date,-1)
g month0=word(date,1)
g day0=word(date,2)
replace day0=regexr(day,",","")
g year0=word(date,3)
replace year0=regexr(year,",","")
replace date=regexr(date,time_hour,"") 

g date_day = date(date,"MDY")
format %td date_day
g hour = 12 if time_hour=="12:00" //substr(time,1,2)
g minute = 0 if time_hour=="12:00" //substr(time,4,5)  
replace hour=14 if time_hour=="2:00"
replace minute=0 if time_hour=="2:00"
replace hour=16 if time_hour=="4:30"
replace minute=30 if time_hour=="4:30"
replace hour=14 if time_hour=="2:10"
replace minute=10 if time_hour=="2:10"
destring hour minute day0 year0, force replace
g year = year(date_day)
g month = month(date_day)
g day = day(date_day)
sum year year0 day day0
pwcorr year year0
pwcorr day day0
drop date A time_hour day0 year0 month0
rename hour M_hour
rename minute M_minute
g date_day_Minute = date_day
save "$path1\Minutes_pre2002.dta", replace

use "$path1\\FED_dissent_date.dta", clear
sum year
keep date_day-quarter ffr_nr dissent_la FOMC_public_vote dissent period_past_dissent period_total_dissent dissent_lag //edit date_day date_FOMC FOMC_public_vote period_past_dissent period_total_dissent dissent_lag dissent
tsset date_FOMC
drop date_day day
g Dp1_lag = (period_past_dissent==2 & period_past_dissent<.)
g Dp2_lag = (period_past_dissent==3 & period_past_dissent<.)
g dissent_p1_lag = (period_past_dissent>=2 & period_past_dissent<.)
g dissent_p2_lag = (period_past_dissent>=3 & period_past_dissent<.)
g dissent_p3_lag = (period_past_dissent>=4 & period_past_dissent<.)
save "$path1\FED_dissent_date_extralags.dta", replace

use "$path1\\FED_dissent_date_governors.dta", clear //use "$path1\\FED_votes93_13f.dta", clear
g dummy_LG = 0
replace dummy_LG = 1 if members=="Mr. Lacker" & dissent==1
replace dummy_LG = 1 if members=="Ms. George" & dissent==1
g dummy_LGH = dummy_LG  //Mr. Hoenig Mr. Lacker Ms. George (Note Mr. Hoenig voted many times, therefore in fraction he voted less than 25% against)
replace dummy_LGH = 1 if members=="Mr. Hoenig" & dissent==1
collapse (max) dummy_*, by(date_F)
save "$path1\dummies_LGH.dta", replace
use "$path1\FED_dissent_date_extralags.dta", clear
joinby date_FOMC using "$path1\dummies_LGH.dta", unmatched(both) update
tab _merge
drop _merge
save "$path1\FED_dissent_date_extralags.dta", replace

g period = 1 if year>2002
replace period = 1 if year==2002 & month>=2
replace period = 2 if year>2007
replace period = 2 if year==2007 & month>=3
replace period = 3 if year>2009
replace period = 3 if year==2009 & month>=7
replace period = 0 if period==.
bysort period: sum dissent_p* dissent_lag dissent
bysort period: sum dummy_*

use "$path1\\FED_dissent_date.dta", clear //use "$path1\FED_dissent_date_extralags.dta", clear
keep date_day-quarter ffr_nr dissent_la dissent_ma FOMC_public_vote dissent period_past_dissent period_total_dissent dissent_lag //edit date_day date_FOMC FOMC_public_vote period_past_dissent period_total_dissent dissent_lag dissent
tsset date_FOMC //g dissent_lag2=L2.dissent_lag g dissent_lag3=L3.dissent_lag
g dissent_la_lag=L.dissent_la
g dissent_ma_lag=L.dissent_ma //g dissent_la_lag2=L2.dissent_la //g dissent_la_lag3=L3.dissent_la
joinby year month using "$path1\Minutes_pre2002.dta", unmatched(both) update
tab _merge
sum year if _merge==3
drop if year>r(max)
drop if year<r(min)
drop if year==2002 & month>3
drop if year==1996 & month<5
drop _merge //sort year month
egen time=group(year month)
bysort time: egen nr_pers=count(time)
tab nr_pers //tsset time
g Dissent_minute=dissent_lag  //replace Dissent_minute=dissent_lag2 if Dissent_minute==. //replace Dissent_minute=dissent_lag3 if Dissent_minute==.
g Dissent_la_minute=dissent_la_lag 
g Dissent_both_minute=0
replace Dissent_both_minute=1 if dissent_la_lag==1 & dissent_ma_lag==1
sum Dissent_minute M_hour if M_hour<.  //sum Dissent_minute if M_hour==.
egen date_M=group(date_day)
sum date_M
local d1=1+r(min)
local d2=r(max)
quietly {
forv d=`d1'/`d2' {
forv d2=1/3 {
sum dissent_lag if date_M==`d'-`d2' 
replace Dissent_minute=r(min) if Dissent_minute==. & date_M==`d'
sum dissent_la_lag if date_M==`d'-`d2' 
replace Dissent_la_minute=r(min) if Dissent_la_minute==. & date_M==`d'
sum ffr if date_M==`d'-`d2' 
replace ffr=r(min) if ffr==. & date_M==`d'
sum dissent_la_lag if date_M==`d'-`d2' & dissent_ma_lag==1 
replace Dissent_both_minute=r(min) if Dissent_both_minute==. & date_M==`d'
}
replace Dissent_both_minute=0 if Dissent_both_minute==. & date_M==`d'
}
}
drop if M_hour==.
drop date_M time
egen date_M=group(date_day)
keep month year day date_day ffr_nr M_hour- date_M
save "$path1\FED_dissent_date_MinutesPre02.dta", replace
collapse (max) ffr_nr nr_pers-Dissent_both_minute, by(date_day date_M month year day M_hour M_minute date_day_Minute)
save "$path1\FED2_dissent_date_MinutesPre02.dta", replace
sum Dissent*_minute M_hour M_minute if M_hour<.
tab Dissent_minute
tab Dissent_la_minute
tab Dissent_both_minute

use "$path1\FED2_dissent_date_MinutesPre02.dta", clear  //g date_day_Minute=date_day
format %td date_day_Minute
joinby date_day using "$path1\AnnouncementReleases1.dta", unmatched(both) update
tab _merge
drop if year<1996
drop if year>2002
drop if year==2002 & month>=3 // Excluded because there was already a meeting with public votes on March19
g FOMC_Minute_sday = (date_day_Minute==date_day) //if date_day_Minute<. & date_day<. //(_merge==3)
replace FOMC_Minute_sday = 0 if hh_GW==.
tsset date_day
g date0=date_day if _merge!=1
g lag_FOMC=L.date0
g fw_FOMC=F.date0
g lag2_FOMC=L2.date0
g fw2_FOMC=F2.date0
g lag3_FOMC=L3.date0
g fw3_FOMC=F3.date0
sum lag_FOMC fw_FOMC lag2_FOMC fw2_FOMC lag3_FOMC fw3_FOMC if _merge!=3
g FOMC_1dayBMin=(lag_FOMC<.) //g FOMC_2dayBMin=(lag2_FOMC<.)
g FOMC_1or2dayBMin=(lag_FOMC<. | lag2_FOMC<.) //g FOMC_1or2or3dayBMin=(lag_FOMC<. | lag2_FOMC<. | lag3_FOMC<.)
g M_S_samehour=(M_hour==hh_GW) if FOMC_Minute_sday==1 //_merge==3
g M_S_timedf=60*(M_hour-hh_GW) if FOMC_Minute_sday==1 //_merge==3
replace M_S_timedf=M_S_timedf+(M_minute-mm_GW)
g M_S_timedf_abs=abs(M_S_timedf)
drop if _merge==2
drop _merge date0-fw3_FOMC FOMC_unsc
log using "$pathF\Minutes_FOMCann.log", replace
// Of the 45 Minute Publications before March 2002, none happen on the same day 
// as FOMC meetings, but 5 (all "unanimity" minutes) happen 1 or 2 days after 
tab FOMC_Minute_sday 
tab M_S_samehour
sum M_S_timedf, d  //tab M_S_timedf_abs
bysort Dissent_minute: tab FOMC_1dayBMin
bysort Dissent_minute: tab FOMC_1or2dayBMin
log close
drop date_day
rename date_day_Minute date_day
sort date_day
keep M_hour- Dissent_both_minute FOMC_1dayBMin FOMC_1or2dayBMin
order date*, first
save "$path1\FED3_dissent_date_MinutesPre02.dta", replace
