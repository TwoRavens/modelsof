clear
set mem  100m
set more off

cd "../Data" 


use 90_07_scheduled_data, clear

gen flight =1 
bys origin dest flightdate: egen daily_flights=total(flight)

xcollapse (min) min_flt_time = flt_time1, by(origin dest flightdate) saving(ash, replace)
dmerge origin dest flightdate using ash
gen equal = (flt_time1 == min_flt_time)

tempfile temp

save `temp', replace

xcollapse (mean) mean_flt_time = flt_time1, by(origin dest flightdate) saving(ash, replace)
dmerge origin dest flightdate using ash

gen min_rel_mean= min_flt_time/mean_flt_time  

save `temp', replace

keep origin dest flightdate daily_flights
duplicates drop
gen year = year(flightdate)
collapse (mean) daily_flights, by(origin dest year)
reshape wide daily_flights, i(origin dest) j(year)

drop if daily_flights1990*  daily_flights1991*  daily_flights1992*  daily_flights1993 *daily_flights1994 *  daily_flights1995 *  daily_flights1996*  daily_flights2002*  daily_flights2004*  daily_flights2005 * daily_flights1997 *  daily_flights1998 *  daily_flights2000*  daily_flights2001*  daily_flights2003*  daily_flights2007 == .

save `temp'1, replace
use `temp', clear
dmerge origin dest using `temp'1

keep if _m == 3
keep  if  daily_flights1997>=5 &  daily_flights1998>=5 &  daily_flights2000>=5& daily_flights2001>=5& daily_flights2003>=5& daily_flights2007>=5 & daily_flights1991>=5& daily_flights1992>=5& daily_flights1993>=5& daily_flights1994>=5 & daily_flights1995>=5 &  daily_flights1996>=5 &  daily_flights1999>=5& daily_flights2000>=5& daily_flights2002>=5& daily_flights2004>=5 & daily_flights2005>=5& daily_flights2006>=5 & daily_flights2007>=5
save `temp'2, replace


use `temp'2, clear

keep origin dest mean_flt_time flightdate 
*annual_flights 
duplicates drop

collapse (mean) mean ,by(origin dest flightdate)
collapse (mean) mean,by(flightdate)

label var mean_flt_time "Mean Scheduled Elapsed Flight Time"
label var flightdate "Year"
format flightdate %tdCCYY
twoway (scatter mean flight) if  flightdate> 10702
graph save Graph "Figure 1.gph", replace
