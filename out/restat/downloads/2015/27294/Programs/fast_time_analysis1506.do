
clear
set mem 990m
set more off

cd "../Data"  
 
use oag, clear

drop if outliers ==1 
gen flight=1
drop min_flt_time 
xcollapse (min) min_flt_time = flt_time1, by(origin dest flightdate) saving(trash, replace)
dmerge origin dest flightdate using trash
gen fastest_flight_time = (min_flt_time == flt_time1)
gen share_of_fastest_flights=0
bys origin dest flightdate: egen daily_flights=total(flight)
bys origin dest flightdate: egen daily_fastest_flights=total(fastest_flight_time)
replace share_of_fastest_flights = daily_fastest_flights/daily_flights  

xcollapse (mean) mean_flt_time = flt_time1 if fastest_flight_time ==0, by(origin dest flightdate) saving(trash, replace)
dmerge origin dest flightdate using trash
drop if origin ==origin[_n-1] & dest==dest[_n-1] & flightdate==flightdate[_n-1]

keep if daily_flights >4

bys flightdate: egen mean_fastest_flight_QY = mean(min_flt_time)
bys flightdate: egen mean_mean_flight_QY = mean(mean_flt_time)

gen rel_time_change = mean_fastest_flight_QY/mean_mean_flight_QY
sort flightdate

bys flightdate: egen total_daily_flights= total(daily_flights)
bys flightdate: tab total_daily_flights

drop if flightdate==flightdate[_n-1]

label var mean_fastest_flight_QY  "Average Shortest Scheduled Flight Time"
label var mean_mean_flight_QY  "Mean Median Flight Time"
label var rel_time_change "Relative Min. vs. Mean Scheduled Flight Time"

label var flightdate "Date"
format flightdate %tdNN/DD/CCYY 

twoway (scatter mean_fastest_flight_QY  flightdate) 
graph save Graph "Figure 2.gph", replace

twoway (scatter rel_time_change flightdate) 
graph save Graph "Figure 3.gph", replace
