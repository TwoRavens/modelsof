clear
set more off
cd "`w_dir'"

insheet using "ucdpGED.txt"



*for start-date
*split dates
gen year_new = substr(date_start, 1, 4)
gen month = substr(date_start, 6, 2)
gen day = substr(date_start, 9, 2)

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

*gen stata compatible start date
gen start_date = mdy(month, day, year_new)

*making user-friendly common date format
format start_date %td



*for end-date
*drop previously used variables
drop year_new month day 
*split dates
gen year_new = substr(date_end, 1, 4)
gen month = substr(date_end, 6, 2)
gen day = substr(date_end, 9, 2)

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

*gen stata compatible start date
gen end_date = mdy(month, day, year_new)
drop month day

*making user-friendly common date format
format end_date %td



*check length with respect to event type
gen length = end_date-start_date
tab length event_type, miss

*seven observations have a false event type and are dropped
drop if event_type==0 | event_type==4



*generate start and end months of event
generate start_month=mofd(start_date)
format start_month %tm
generate end_month=mofd(end_date)
format end_month %tm

*calculate duration in months
gen duration_month = end_month-start_month



*prepare count variable of number of fatal events
gen fatal_events = 1


*gen distance to capital variable
joinby isonumber using "capitals17 Jun 2013.dta", unmatch(both)
foreach var of varlist lat lon lat_c* lon_c* {
gen r`var'=`var'*_pi/180
}
gen distance_to_c = 2*6378*asin(sqrt((sin((rlat-rlat_c)/2))^2+cos(rlat)*cos(rlat_c)*(sin((rlon-rlon_c)/2))^2))
forvalues i=1/6 {
gen distance_to_cc`i' = 2*6378*asin(sqrt((sin((rlat-rlat_cc`i')/2))^2+cos(rlat)*cos(rlat_cc`i')*(sin((rlon-rlon_cc`i')/2))^2))
}


*turning dataset in event-month format
*fatality estimates are divided equally if event occured in more than one month
gen diff=end_month-start_month+1
expand diff
bysort uniq: gen month=start_month+_n-1
foreach var of varlist deaths_a-low_est fatal_event {
gen `var'_split = `var'/diff
replace `var' = 0 if end_month!=month
}
drop fatal_events_split
list uniq diff start_m end_m month best_est best_est_split in 1/100



*aggregating at dyad-month level
gen isonumbermin=isonum
gen distance_min=distance_to_c
gen distance_mean=distance_to_c
forvalues i=1/6 {
gen distance_min_c`i'=distance_to_cc`i'
gen distance_mean_c`i'=distance_to_cc`i'
}
replace dyad_u=10000*dyad_id if dyad_u==31391 & type==1
collapse (max) year active_year conflict_id dyad_id side_a_id side_b_id isonumber /*
*/ (min) isonumberm distance_min* /*
*/ (mean) distance_mean* /*
*/ (sum) deaths_a deaths_b civilian_deaths unknown best_est high_est /*
*/ low_est fatal_events deaths_a_split deaths_b_split civilian_deaths_split /*
*/ unknown_split best_est_split high_est_split low_est_split /*
*/, by(dyad_unique month)



*generate cross border fighting indicator
gen crossborder = (isonumbermin != isonumber )



*format data as stata-month
format month %tm



*save total file
local sysdate = c(current_date)
save "ucdpGED_dyadmonth_complete_`sysdate'.dta", replace



*save state-based data
keep if dyad_u<20000
save "ucdpGED_dyadmonth_state_`sysdate'.dta", replace



*save non-state data
use "ucdpGED_dyadmonth_complete_`sysdate'.dta", clear
keep if dyad_u>19999 & dyad_u<30000
save "ucdpGED_dyadmonth_nonstate_`sysdate'.dta", replace



*save osv data
use "ucdpGED_dyadmonth_complete_`sysdate'.dta", clear
keep if dyad_u>30000
save "ucdpGED_dyadmonth_osv_`sysdate'.dta", replace












