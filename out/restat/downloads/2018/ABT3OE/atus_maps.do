// Stata file to make county level maps. 
//
// Jeff Shrader & Matt Gibson
// Creation date: 2014-03-02
// Time-stamp: "2014-11-03 10:55:38 jgs"

clear

local work "/DIRECTORY"
local map_dir "/DIRECTORY2"
local county_dir "c_05fe14"
local state_dir "s_06se12"
cd "`work'"

capture log close
log using "`work'/logs/atus_maps.log", replace


// To create map files, run the following code.
// You should only need to run this once.
// shp2dta using "`map_dir'/timeznp020/timeznp020", database("`work'/data/timezone_modern") coordinates("`work'/data/timezone_modern_coord") genid(id) replace
// shp2dta using "`map_dir'/tz_us/tz_us", database("`work'/data/timezone") coordinates("`work'/data/timezone_coord") genid(id) replace
// shp2dta using "`map_dir'/`county_dir'/c_05fe14", database("`work'/data/us_county") coordinates("`work'/data/us_county_coord") genid(id) replace

// Manually dropping all observations not from CONUS because I can't get the spmap
// command to work:
use "`work'/data/us_state", clear
drop if FIPS == "72" | FIPS == "15" | FIPS == "78" | FIPS == "02" | FIPS == "" | FIPS == "60" | FIPS == "66"
save "`work'/data/us_state", replace
use "`work'/data/us_state_coord", clear
drop if _ID == 1 |  _ID == 40 |  _ID == 46 |  _ID == 55 |  _ID == 56 | _ID == 4 | _ID == 13
save"`work'/data/us_state_coord", replace


//////////////////////////////////////////////////////////////////////
/// True time zone maps
//////////////////////////////////////////////////////////////////////
use "`work'/data/timezone.dta", clear

drop if inlist(TZID, "America/Nome", "America/Puerto_Rico", "America/Sitka", "America/St_Thomas", "America/Yakutat", "Pacific/Honolulu")
drop if inlist(TZID, "America/Adak", "America/Anchorage", "America/Juneau", "America/Metlakatla")
replace TZID = "America/Chicago" if TZID == "America/North_Dakota/Center" | TZID == "America/North_Dakota/New_Salem" | TZID == "America/North_Dakota/Beulah" 
replace TZID = "America/Denver" if TZID == "America/Boise"
replace TZID = "America/Chicago" if TZID == "America/Menominee"
replace TZID = "America/New_York" if TZID == "America/Kentucky/Louisville" | TZID == "America/Kentucky/Monticello" | TZID == "America/Indiana/Marengo"  | TZID == "America/Indiana/Vevay"
replace TZID = "America/Indiana/Knox" if TZID == "America/Indiana/Vincennes" | TZID == "America/Indiana/Tell_City" | TZID == "America/Indiana/Petersburg"  | TZID == "America/Indiana/Winamac"
replace TZID = "America/New_York" if TZID == "America/Detroit"

encode TZID, gen(tz)
spmap tz using "`work'/data/timezone_coord" ///
  ,id(id) clmethod(unique) ///
  osize(none none none none none none none) ///
  legenda(off) 


use "`work'/data/timezone_modern.dta", clear
drop if inlist(TIMEZONE, "Hawaii-Aleutian", "Alaska", "Atlantic")
encode TIMEZONE, gen(tz)
spmap using "`work'/data/timezone_modern_coord" ///
  ,id(id) clmethod(unique) ///
  osize(vvthin) ///
  ocolor(green) ///
  legenda(off) 
graph export "`work'/graphs/us_time_zones.pdf", replace


//////////////////////////////////////////////////////////////////////
/// State maps
//////////////////////////////////////////////////////////////////////
// shp2dta using "`map_dir'/`state_dir'/s_06se12", database("`work'/data/us_state") coordinates("`work'/data/us_state_coord") genid(id) replace
use "`work'/data/us_state", clear
spmap using "`work'/data/us_state_coord", ///
  id(id) osize(vvthin) /// 
  ocolor(gs3) ///
  legenda(off) 
graph export "`work'/graphs/us_state.pdf", replace


//////////////////////////////////////////////////////////////////////
/// County maps
//////////////////////////////////////////////////////////////////////
// Merge county map with data
use "`work'/data/demographics/demographics_comb.dta", clear
sort fips
save "`work'/data/demographics/demographics_comb.dta", replace

use "`work'/data/us_county.dta", clear
rename FIPS fips
rename TIME_ZONE time_zone
rename STATE state
drop time_zone
sort fips

merge m:1 fips using "`work'/data/demographics/demographics_comb.dta"
// merge ==2 are PR and samoa and whatnot
keep if _merge == 3
drop _merge

// Draw the maps
// Just county
spmap using "`work'/data/us_county_coord" ///
  if state != "AK" & state != "HI"  & state != "PR", ///
  id(id) clmethod(unique) osize(vvthin vvthin vvthin vvthin vvthin vvthin) /// 
  ocolor(gray gray gray gray gray gray) ///
  legenda(off) 
graph export "`work'/graphs/us_county.pdf", replace

// Time zone
replace time_zone = "e" if time_zone == "E" & state == "IN"
encode time_zone, gen(tz)
spmap tz using "`work'/data/us_county_coord" ///
  if state != "AK" & state != "HI"  & state != "PR", ///
  id(id) clmethod(unique) osize(vvthin vvthin vvthin vvthin vvthin vvthin) /// 
  ocolor(gray gray gray gray gray gray) ///
  polygon(data("`work'/data/us_state_coord") ocolor(black) osize(vvthin)) ///
  legenda(off) 
graph export "`work'/graphs/us_time_zones_county.pdf", replace


// TZ offset (normal time)
spmap tz_offset using "`work'/data/us_county_coord" ///
  if state != "AK" & state != "HI" & state != "PR", ///
  id(id) fcolor(Blues) clbreaks(-8(1)-5) clnumber(4) ///
  clmethod(unique) mosize(vvthin) legenda(off) osize(vvthin)
graph export "`work'/graphs/us_tz_offset_county.pdf", replace

// Sunset time
replace longitude = LON if longitude == .
replace latitude = LAT if latitude == .
capture drop date
capture drop sunset_time sunrise_time sun_ra sun_dec solar_noon sunlight_duration
gen date = td(1mar2012)
solar_calculator latitude longitude date tz_offset
spmap sunset_time using "`work'/data/us_county_coord" if state != "AK"  & state != "PR" & state != "HI" , id(id) fcolor(Reds) clmethod(eqint) clnumber(6) legenda(on)


// To verify that we are getting things assigned correctly
spmap longitude using "`work'/data/us_county_coord" if state != "AK"  & state != "PR" & state != "HI" , id(id) fcolor(Reds) clmethod(eqint) clnumber(6) legenda(on)
spmap latitude using "`work'/data/us_county_coord" if state != "AK"  & state != "PR" & state != "HI" , id(id) fcolor(Reds) clmethod(eqint) clnumber(6) legenda(on)


//////////////////////////////////////////////////////////////////////
/// ATUS based maps
//////////////////////////////////////////////////////////////////////
// Bringing in ATUS merge
use "`work'/data/atus_proc.dta", clear
collapse (min) tz_offset (max) observe_dst (mean) latitude longitude sleep wage ln_wage cnty_st_inc_per_capita coast_dist sunset_time_avg* ln_st_inc_per_capita st_pacific st_atlantic, by(fips state_code)
sort fips
drop if length(fips) > 5
save "`work'/data/atus_county_collapse.dta", replace
gen test = substr(fips, 3, 3)
keep if test == "000"
drop test
rename state_code state
foreach v of varlist latitude longitude tz_offset observe_dst sleep wage ln_wage cnty_st_inc_per_capita coast_dist sunset_time_avg sunset_time_avg_nodst ln_st_inc_per_capita st_pacific st_atlantic {
   rename `v' `v'_state
}
sort state
save "`work'/data/atus_state_collapse.dta", replace


use "`work'/data/us_county.dta", clear
rename FIPS fips
rename STATE state
sort fips
merge m:1 fips using "`work'/data/atus_county_collapse.dta"
gen county_obs = 0
replace county_obs = 1 if _merge == 3
drop if _merge == 2
drop _merge

sort state
merge m:1 state using "`work'/data/atus_state_collapse.dta"
drop _merge

// matching state records with county records
foreach v of varlist latitude longitude tz_offset observe_dst sleep wage ln_wage cnty_st_inc_per_capita coast_dist sunset_time_avg sunset_time_avg_nodst ln_st_inc_per_capita st_pacific st_atlantic {
   replace `v' = `v'_state if `v' == .
}

// maps
// Sleep map, not for publication
spmap sleep using "`work'/data/us_county_coord" ///
  if state != "AK"  & state != "PR" & state != "HI" & state != "VI" & state != "GU" & state != "AS" ///
  ,id(id) fcolor(Blues) clnumber(5) legenda(on)
graph export "`work'/graphs/sleep_map.pdf", replace

// Sleep map, not for publication
gen tz_offset_keep = tz_offset
foreach i in "20mar2012" "20jun2012" "21dec2012" {
   capture drop date
   gen date = td(`i')
   replace tz_offset = tz_offset_keep
   replace tz_offset = tz_offset + observe_dst if date >= td(11mar2012) & date < td(4nov2012)
   capture drop sunset_time sunrise_time sun_dec sun_ra solar_noon sunlight_duration
   solar_calculator latitude longitude tz_offset  date
   spmap sunset_time using "`work'/data/us_county_coord" ///
     if state != "AK"  & state != "PR" & state != "HI" & state != "VI" & state != "GU" & state != "AS" ///
     ,id(id) fcolor(Reds) clnumber(5) legenda(on)
   graph export "`work'/graphs/sunset_time_county_map_`i'.pdf", replace
}

// Which counties do we have county level data for?
replace county_obs = 0 if county_obs == .
spmap county_obs using "`work'/data/us_county_coord" ///
  if state != "AK"  & state != "PR" & state != "HI" & state != "VI" & state != "GU" & state != "AS" ///
  ,id(id) fcolor(white "31 120 180") clmethod(unique) legenda(off) ///
  osize(vvthin vvthin) /// 
  ocolor(black black) ///
  //polygon(data("`work'/data/us_state_coord") ocolor(black) osize(vthin)) ///
graph export "`work'/graphs/county_obs_map.pdf", replace


//////////////////////////////////////////////////////////////////////
/// American city time zones
//////////////////////////////////////////////////////////////////////
insheet using "`work'/data/us_cities_size_location.csv", clear
bysort rank: gen count = _n
drop if count == 1
drop count
destring estimate, ignore(",") replace
destring census,  ignore(",") replace
rename estimate pop_est
rename census pop_census

split landarea, p(" k") destring ignore(",")
drop landarea2
rename landarea1 land_area
drop landarea
