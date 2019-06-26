clear
set more off
cd "`w_dir'"

insheet using "MILC_bearb.txt"
drop if cow==.


*turn dataset into long format, splits multiple dyad observation into multiple
* single dyad observations
forvalues i=1/5 {
rename dyad`i'_id dyadid`i'
}
gen id=_n
reshape long dyadid , i(id) j(dyadnr)
drop if dyadid==0
drop id

*generate unique dyad id to enable merging with GED data
gen dyad_unique = 10000 + dyadid


*for start-date
*split dates
gen year_new = substr(start, 1, 4)
gen month = substr(start, 6, 2)
gen day = substr(start, 9, 2)

*remove "?" from unknown months and days
gen month1 = month
replace month1 = "00" if month=="0?" | month=="1?" | month=="??"
tab month month1, miss

gen test = "00" if day=="0?" | day=="1?" | day=="2?" | day=="??"
tab day test, miss
gen day1 = day 
replace day1 = "00" if day=="0?" | day=="1?" | day=="2?" | day=="??"
tab day1, miss
drop test day month

rename day1 day
rename month1 month

*destringing variables "year", "month", "day"
destring year_new, gen(year_num)
destring month, gen(month_num)
destring day, gen(day_num)

*removing (unnessary) string variables "year", "month", "day"
drop year_new month day

*renaming numerical date variables
ren day_num day
ren month_num month
ren year_num year_new

*replace unknown days with random day
gen random_day = int((uniform()*28)+1)
count if day==0
gen flag_sd=1 if day==0
replace day=random_day if day==0

*flag events with unknown month
count if month==0
gen flag_sm=1 if month==0
replace month=1 if month==0
*drop if month==0

*gen stata compatible start date
gen start_date = mdy(month, day, year_new)

*making user-friendly common date format
format start_date %td



*for end-date
*split dates
drop year_new month* day* random_day
gen year_new = substr(end, 1, 4)
gen month = substr(end, 6, 2)
gen day = substr(end, 9, 2)

*remove "?" from unknown months and days relabel ongoing efforts
replace year_new="2007" if year_new=="ONGO" | year_new=="ongo"
drop if year_new=="uncl"

gen month1 = month
replace month1 = "00" if month=="0?" | month=="1?" | month=="??"
replace month1 = "01" if month=="NG" | month=="ar" | month=="ng"
tab month month1, miss

gen test = "00" if day=="0?" | day=="1?" | day=="2?" | day=="??" | day=="?"
replace test = "01" if day=="as" | month=="by" | month==""
tab day test, miss
gen day1 = day 
replace day1 = "00" if day=="0?" | day=="1?" | day=="2?" | day=="??" | day=="?"
replace day1 = "01" if day=="as" | day=="by" | day==""
tab day1, miss
drop test day month

rename day1 day
rename month1 month

*destringing variables "year", "month", "day"
destring year_new, gen(year_num)
destring month, gen(month_num)
destring day, gen(day_num)

*removing (unnessary) string variables "year", "month", "day"
drop year_new month day

*renaming numerical date variables
ren day_num day
ren month_num month
ren year_num year_new

*replace unknown days/months with random day / month
gen random_day = int((uniform()*28)+1)
count if day==0
gen flag_ed=1 if day==0
replace day=random_day if day==0 & flag_sd==1
replace day=day(start_date) if day==0 & flag_sd==.

gen random_month = int((uniform()*12)+1)
count if month==0
gen flag_em=1 if month==0
replace month=month(start_date) if month==0 & flag_sm==.
drop if month==0 & flag_sm==1

*gen stata compatible start date
gen end_date = mdy(month, day, year_new)

*code start date = end date for events with unknown start month
replace start_date=end_date if flag_sm==1  

*making user-friendly common date format
format end_date %td

sort start_date


*check that random dates did not create negative duration
foreach var of varlist flag_* {
replace `var' = 0 if `var'==.
}
gen flag_start=flag_sm+flag_sd
gen flag_end=flag_em+flag_sd
gen length=end_date-start_date
tab length flag_start, miss
tab length flag_end, miss

*sometimes this occurred and is corrected by denoting as one-day event
replace end_date=start_date if flag_end>0 & month==0
replace end_date=start_date if flag_ed==1 & flag_sd==1
replace start_date=end_date if flag_sm==1
replace start_date=end_date if flag_sd==1 & flag_sm==0 & month(start_date)==month(end_date)
list conflict_name start end start_date end_date if length<0 & flag_end<1 & flag_start<1 
*two cases are relevant for the sample and are corrected manually
replace end_date=start_date in 2580
replace end_date=start_date in 1562
list conflict_name start end start_date end_date if length<0 & flag_end!=1 & flag_start!=1 

*check how many cases with problematic lenght remain
replace length=end_date-start_date
list conflict_name start end start_date end_date flag* if length<0 
tab length, miss
tab length flag_start, miss
tab length flag_end, miss


*inspect events longer than a month
gen long_measure=.
foreach var of varlist good_office-pko {
replace long_measure=1 if `var'==1
}
count if length>30
list conflict_name start end start_date end_date long_measure if length>30 
/* 
the following events lasted longer than a month and were not long measures:
-Burundi 1999-01-18  obs. 1470
-2x DRC 2002-02-25 obs. 2618/2619
-3x Somalia 2003-01-17 obs 3014, 3020, 3021
-Somalia   2003-04-?? obs. 3102
The DRC events must be coding mistakes since the source is from march 2002
*/
replace end_date=end_date-365 in 2618/2619
list conflict_name start end start_date end_date long_measure if length>30 

*check remaining long cases
replace length=end_date-start_date
tab length long_measure, miss
tab length if long_measure==., miss

*gen duration variable which stores number of months in which measure took place
gen duration_months=(year(end_date)-year(start_date))*12+month(end_date)-month(start_date)

list conflict start end start_d end_d if dur>1 & long_m==.

*check relevance of negative duration events and drop
list conflict if length<0
drop if length <0

*turn data into event-day format
gen id=_n
gen diff=end_date-start_date+1
expand diff
bysort id: replace start_date=start_date+_n-1
drop end_date diff
rename start_date date
list id conflict start end date in 1/50

*gen third party activity variables by type of thirdparty and activity
rename fact_findinding fact_finding
foreach var of varlist  /*
*/ indirect_talks1 direct_talks1 unclear_talks1 /*
*/ bilateral_talks1 arbitration good_office fact_finding /*
*/ observer_mission pko {
gen `var'state = (tp_state==1 & `var'==1)
gen `var'gstate = (tp_group_state==1 & `var'==1)
gen `var'igo = (tp_igo==1 & `var'==1)
gen `var'gigo = (tp_group_igo==1 & `var'==1)
gen `var'other = (tp_other==1 & `var'==1)
gen `var'p5 = (p5==1 & `var'==1)
gen `var'neighbor = (neighbor==1 & `var'==1)
gen `var'un = (un==1 & `var'==1)
gen `var'min1igo = (igo==1 & `var'==1)
gen tp_total`var' = tp_total if `var'==1
replace tp_total`var' = 0 if `var'==0
}



*aggregate on a dyad-day level
collapse (max) /*
*/ indirect_talks1* direct_talks1* unclear_talks1* /*
*/ bilateral_talks1* arbitration* good_office* fact_finding* /*
*/ observer_mission* pko* /*
*/ (mean) tp_total* /*
*/ (max) cow_id-incomp_terr dyadid, by(dyad_unique date)

*generate year identifier
gen year = year(date)

*code Egypt as part of Africa
replace reg_id = 4 if cow_id == 651

*order variables
order cow_id gw_id reg_id dyad_unique dyadid year date incomp*



*aggregate on dyad_month level
generate month=mofd(date)
format month %tm
collapse (max) /*
*/ indirect_talks1* direct_talks1* unclear_talks1* /*
*/ bilateral_talks1* arbitration* good_office* fact_finding* /*
*/ observer_mission* pko* /*
*/ (mean) tp_total* /*
*/ (max) cow_id gw_id reg_id dyadid year incomp*, by(dyad_unique month)

*order variables
order cow_id gw_id reg_id dyad_unique dyadid year month incomp*


*events with unknown dyad are dropped
drop if dyad_u==1


*save dataset
sort month
sort dyad_unique, stable
local sysdate = c(current_date)
save "MILC_dyadmonth_`sysdate'.dta", replace



