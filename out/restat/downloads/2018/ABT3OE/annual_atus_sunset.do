// Stata file to calculate annual average sunset time for ATUS
//
// Jeff Shrader & Matt Gibson
// Creation date: 2014-03-02
// Time-stamp: "2014-10-29 11:56:31 jgs"

clear
local work "/DIRECTORY"
cd "`work'"

// This is only run as part of atus_proc.do, so it doesn't get its own log
use "`work'/data/atus_for_annual_sunset.dta", clear

gen year = year(date_keep)
gen doy = doy(date_keep)
egen id = group(latitude longitude year)
replace fips = "" if state == ""

duplicates drop

tsset id doy
tsfill, full

spread latitude longitude year time_zone tz_offset state, by(id)
spread fips, by(id)
gen date = mdy(1,1,year) + doy - 1
drop date_keep
// Fixing historical time zones in indiana 
replace time_zone = "C" if (fips == "18027" | fips == "18037" | fips == "18083" | fips == "18101" | fips == "18125") & date < td(4nov2007)
replace time_zone = "C" if (fips == "18131") & date < td(11mar2007)
replace time_zone = "e" if state == "IN" & date < td(2apr2006) & time_zone == "E"

// Getting time zone offset right
gen observe_dst = 1
replace observe_dst = 0 if time_zone == "e" | time_zone == "h" | time_zone == "m"
gen dst = 0
rename tz_offset tz_offset_nodst
replace dst = 1 if observe_dst == 1 & date >= td(6apr2003) & date < td(26oct2003)
replace dst = 1 if observe_dst == 1 & date >= td(4apr2004) & date < td(31oct2004)
replace dst = 1 if observe_dst == 1 & date >= td(3apr2005) & date < td(30oct2005)
replace dst = 1 if observe_dst == 1 & date >= td(2apr2006) & date < td(29oct2006)
replace dst = 1 if observe_dst == 1 & date >= td(11mar2007) & date < td(4nov2007)
replace dst = 1 if observe_dst == 1 & date >= td(9mar2008) & date < td(2nov2008)
replace dst = 1 if observe_dst == 1 & date >= td(8mar2009) & date < td(1nov2009)
replace dst = 1 if observe_dst == 1 & date >= td(14mar2010) & date < td(7nov2010)
replace dst = 1 if observe_dst == 1 & date >= td(13mar2011) & date < td(6nov2011)
replace dst = 1 if observe_dst == 1 & date >= td(11mar2012) & date < td(4nov2012)
replace dst = 1 if observe_dst == 1 & date >= td(10mar2013) & date < td(3nov2013)
replace dst = 1 if observe_dst == 1 & date >= td(9mar2014) & date < td(2nov2014)
replace dst = 1 if observe_dst == 1 & date >= td(8mar2015) & date < td(1nov2015)
gen tz_offset = tz_offset_nodst + dst

solar_calculator latitude longitude date tz_offset
drop sun_ra sun_dec solar_noon
rename sunset_time sunset_time_avg
rename sunrise_time sunrise_time_avg
rename sunlight_duration sunlight_duration_avg

replace tz_offset = tz_offset_nodst
solar_calculator latitude longitude date tz_offset
drop sun_ra sun_dec solar_noon sunrise_time sunlight_duration
rename sunset_time sunset_time_avg_nodst

collapse (mean) sunset_time_avg* sunrise_time_avg sunlight_duration_avg, by(latitude longitude year)
sort year latitude longitude
saveold "`work'/data/atus_annual_sunset.dta", replace
