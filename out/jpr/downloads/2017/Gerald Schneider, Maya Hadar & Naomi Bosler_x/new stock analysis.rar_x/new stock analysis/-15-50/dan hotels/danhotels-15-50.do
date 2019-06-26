***************/This file performs the event study for Dan Hotels

**/open ceasefires data (if the day is Friday (5) or Saturday (6), shift to Sunday (0))
use ceasefires.dta, clear
gen day=dow(date)
rename date event_date_real
gen event_date=event_date_real
replace event_date=event_date_real+1 if day==6
replace event_date=event_date_real+2 if day==5
format event_date %td

**/sort for merging, save and close
sort event_date
gen set=_n
sort set
save ceasefires_WORK.dta, replace
clear

**/open ta100, sort for merging with danhotels
use ta100.dta
sort date
save, replace

**/open danhotels, sort for merging with ta100 and merge
use danhotels, clear
sort date
merge date using ta100.dta
keep if _merge==3
drop _merge

**/shift values for Friday to Sunday (both traded traded Sunday-Thursday)

gen day=dow(date)
gen date1=date
replace date1=date+2 if day==5
gen day1=dow(date1)
drop day date
rename date1 date
rename day1 day

sort date

gen days =_n
tsset days
gen d_ta100= D.ta100
gen d_danhotels=D.danhotels

**/Expand the data by 24 for the 24 events where nature!=3

expand 24
format date %td
sort date
by date: gen set=_n
sort set

**/merge datasets and save
merge set using ceasefires_WORK.dta	
drop _merge
rename set group_id

************************/The event study can now begin!*******************************
**/Count the number of trading days from the observation to the event date

sort group_id date
by group_id: gen datenum=_n
by group_id: gen target=datenum if date==event_date
egen td=min(target), by(group_id)
drop target
gen dif=datenum-td

save danhotels_WORK, replace

**************************For the [-3,0] event window*********************************
**/Now we generate the estimation window and the event window

by group_id: gen event_window=1 if dif>=-3 & dif<=0
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-50
egen count_est_obs=count(estimation_window), by(group_id)
replace event_window=0 if event_window==.
replace estimation_window=0 if estimation_window==.

drop count_event_obs count_est_obs

*****/ESTIMATING NORMAL PERFORMANCE

gen predicted_d_danhotels=.
egen id=group(group_id)
***/ Note in my analysis id=group_id
forvalues i=1(1)24 { /*note: replace 24 with the highest value of id */ 
	l id group_id if id==`i' & dif==0
	reg d_danhotels d_ta100 if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_d_danhotels = p if id==`i' & event_window==1 
	drop p
}  

*****/CALCULATING ABNORMAL AND CUMULATIVE ABNORMAL RETURNS

sort id date
gen abnormal_d_danhotels=d_danhotels-predicted_d_danhotels if event_window==1
by id: egen CAR_d_danhotels = sum(abnormal_d_danhotels)

keep if dif==0 
rename CAR_d_danhotels danhotels_3
keep  event_id danhotels_3
sort event_id
save danhotels_3.dta, replace

**************************For the [-5,0] event window*********************************

use  danhotels_WORK, clear

******/Now we generate the estimation window and the event window

by group_id: gen event_window=1 if dif>=-5 & dif<=0
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-50
egen count_est_obs=count(estimation_window), by(group_id)
replace event_window=0 if event_window==.
replace estimation_window=0 if estimation_window==.

drop count_event_obs count_est_obs

*****/ESTIMATING NORMAL PERFORMANCE

gen predicted_d_danhotels=.
egen id=group(group_id)
***/ Note in my analysis id=group_id
forvalues i=1(1)24 { /*note: replace 24 with the highest value of id */ 
	l id group_id if id==`i' & dif==0
	reg d_danhotels d_ta100 if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_d_danhotels = p if id==`i' & event_window==1 
	drop p
}  

*****/CALCULATING ABNORMAL AND CUMULATIVE ABNORMAL RETURNS
sort id date
gen abnormal_d_danhotels=d_danhotels-predicted_d_danhotels if event_window==1
by id: egen CAR_d_danhotels = sum(abnormal_d_danhotels)
keep if dif==0

sort event_id
rename CAR_d_danhotels danhotels_5
merge event_id using danhotels_3.dta, keep(danhotels_3)
keep event_id danhotels_3 danhotels_5
sort event_id
save danhotels_CAR, replace
