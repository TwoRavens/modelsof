// Stata file to process the combined ATUS files and add additional variables
// for estimation. Ideally, the estimation code should do minimal data
// processing.
//
// Jeff Shrader & Matt Gibson
// Creation date: 2014-02-06
// Time-stamp: "2018-02-04 17:28:43 jgs"

clear

local work "/DIRECTORY"
cd "`work'"

display "Work dir is: " "`work'"
capture log close
log using "`work'/logs/ATUS_proc.log", replace
set more off
set matsize 800
timer clear 1
timer on 1


// Processing lat& lon, merging to state FIPS codes
// The state_fips_link file is from statoids
insheet using "`work'/data/state_fips_link.csv", comma clear
gen state_code = substr(hasc, 4, 2)
drop population_2010 zip_range adjective capital d area_mi area_km
// tz offset here is for majority timezone (by county) if state has multiple
// DST is encoded in time zone names now
// gen dst_observe = 0
// replace dst_observe = 1 if regexm(tz_offset_tilde, "~") == 1
destring tz_offset_tilde, gen(tz_offset) ignore("~")
drop tz_offset_tilde
sort state_code
saveold "`work'/data/state_fips_link.dta", replace
insheet using "`work'/data/state_avg_latlon.csv", comma clear
rename state state_code
merge 1:1 state_code using "`work'/data/state_fips_link.dta", keep(3) nogenerate


rename latitude state_lat
rename longitude state_lon
rename time_zone state_time_zone
rename tz_offset state_tz_offset

gen gestfips = substr(fips_string, 3, 2)
sort gestfips
save "`work'/data/state_latlon_fips.dta", replace

// Reading ATUS and merging lat & long
use "`work'/data/ATUS_with_counties.dta", clear
replace longitude = . if COUNTY == "000"
replace latitude = . if COUNTY == "000"
sort gestfips
merge m:1 gestfips using "`work'/data/state_latlon_fips.dta"
rename _merge state_merge

merge m:1 fips using "`work'/data/county_tz/county_time_zone.dta"
drop if _merge == 2
rename _merge county_merge
capture rename timezone time_zone


* Merging lat and long for observations with CBSA identifiers
merge m:1 cbsa using "`work'/data/gis/CBSAcentroids.dta", keep(1 3 4 5) update generate(CBSAmerge)

* Merging lat and long for observations with NECTA identifiers
merge m:1 cbsa using "`work'/data/gis/NECTAcentroids.dta", keep(1 3 4 5) update generate(NECTAmerge)

sort fips
merge m:1 fips using "`work'/data/census/census_pop_density.dta"
drop if _merge == 2
rename _merge popden_county_merge
rename state_fips state_fips_partial
gen state_fips = gestfips
sort state_fips
merge m:1 state_fips using "`work'/data/census/census_pop_density_state.dta"
rename _merge popden_state_merge
foreach i in population housing_units pop_density_land housing_density_land {
   replace `i' = `i'_state if `i' == .
}

// Date
capture: drop date
tostring tudiarydate, gen(date)
gen year = substr(date, 1, 4)
gen month = substr(date, 5, 2)
gen day = substr(date, 7, 2)
destring year month day, replace
drop date
gen date = mdy(month, day, year)
quietly: su tudiarydate
gen time_trend = tudiarydate - r(min)

// BEA variables - states
sort gestfips year
merge m:1 gestfips year using "`work'/data/bea reis/State_BEA.dta", keep(1 3) nogenerate
foreach x in population employment income inc_per_capita {
	rename `x' st_`x'
	gen ln_st_`x' = log(st_`x')
}
// BEA variables - counties/states as available
merge m:1 fips year using "`work'/data/bea reis/County_BEA.dta", keep(1 3) nogenerate
foreach x in employment income inc_per_capita population {
	rename `x' cnty_st_`x'
	replace cnty_st_`x' = st_`x' if missing(cnty_st_`x')
}

// Adding naps, bedtime, waketime
// To add more variables, go edit ATUS_activity_file_process.do, run that
// code, then re-run this file.
/*
format tucaseid %14.0f
tostring tucaseid, gen(id) u
merge 1:1 id using "`work'/data/atus_sleep_activity.dta"
drop _merge
*/

// Adding coastal distance
merge m:1 fips using "`work'/data/gis/Stata inputs/CntyCoastDistances.dta", keep(1 3) nogenerate
merge m:1 cbsa using "`work'/data/gis/Stata inputs/NECTACoastDistances.dta", keep(1 3 4 5) update nogenerate
merge m:1 cbsa using "`work'/data/gis/Stata inputs/CBSACoastDistances.dta", keep(1 3 4 5) update nogenerate
merge m:1 state_fips using "`work'/data/gis/Stata inputs/StateCoastDistances.dta", keep(1 3 4 5) update nogenerate

* Dummies for largest CSAs
bysort fips: egen CSAmode = mode(CSA)
gen top10CSA = 0
replace top10CSA = 1 if inlist(CSAmode, "408", "348", "176", "548", "488") | inlist(CSAmode, "428", "220","715", "500", "378")
gen top10CSAstr = "000"
replace top10CSAstr = CSAmode if top10CSA==1
encode top10CSAstr, generate(top10CSAcodes)

// Adding state and federal marginal tax rates
gen state2let = state_code
sort year state2let
merge m:1 year state2let using "`work'/data/at.dta", keep(1 3) nogenerate

// Variable handling
gen sleep_base = t010101
gen sleep_exnap = sleep_base - nap_sst1
gen sleep_exnap_sst2 = sleep_base - nap_sst2
forvalues i = 1/7 {
   gen sleep_exnap`i' = sleep_base - nap`i'
}
gen sleep = sleep_exnap
gen work = (t050101 + t050102)

// Putting things in minutes/week
foreach v of varlist nap* *sleep* work {
   replace `v' = `v'*7
}
gen ln_sleep = ln(sleep)
gen ln_sleep_base = ln(sleep_base)

replace trernwa = . if trernwa <= 0
replace tehruslt = . if tehruslt <= 0
gen wkly_wage = trernwa/100
gen ln_trernwa = ln(trernwa)
gen wage = trernhly/100
gen ln_wkly_wage = ln(wkly_wage)
gen income = wage*work
gen sleep_ln_sleep = sleep*ln_sleep
gen ln_wage = ln(wage)
gen ln_wage_hr_wk = ln(trernwa/tehruslt)
replace ln_wkly_wage = . if tehruslt == .
gen wage_summ_stat = trernwa/tehruslt
gen other_time = 24*60*7 - sleep - work
gen leis_ln_sleep = other_time*ln_sleep
gen northeast = 0
replace northeast = 1 if gereg == 1


* Filling in tz offset with offset from a known county within same cbsa where possible
sort cbsa tz_offset
bysort cbsa: replace tz_offset = tz_offset[_n-1] if (CBSAmerge==4 | NECTAmerge==4) & missing(tz_offset)
bysort cbsa: replace time_zone = time_zone[_n-1] if (CBSAmerge==4 | NECTAmerge==4) & missing(time_zone)
* Setting all NECTA-merge records to EST
replace time_zone="E" if NECTAmerge==4
replace tz_offset=-5 if NECTAmerge==4
* Manually coding remaining CBSAs
replace time_zone="P" if inlist(cbsa, "41420", "49700") & (CBSAmerge==4 | NECTAmerge==4)
replace time_zone="M" if inlist(cbsa, "41620", "14260", "36260") & (CBSAmerge==4 | NECTAmerge==4)
replace time_zone="C" if inlist(cbsa, "33340", "36420", "12420", "32820", "27140", "29180", "22220", "44180") | inlist(cbsa, "40420", "47020", "43340", "18580", "33860", "16580", "20740", "28660") ///
	| inlist(cbsa, "13140", "27900", "11540", "21780", "22900", "19460", "44100", "41060") | inlist(cbsa, "25060", "14540", "26380") & (CBSAmerge==4 | NECTAmerge==4)
replace time_zone="E" if inlist(cbsa, "15380", "10580", "19380", "16700", "42540", "12260", "29620", "20500") | inlist(cbsa, "16860", "11700", "42340", "15940", "16620", "23060", "28020", "40220") ///
	| inlist(cbsa, "17980", "46540", "31340", "14020", "38940", "25860", "45220", "13780") | inlist(cbsa, "25500", "27740", "10500", "28700", "31420", "26580", "46660", "12020") ///
	| inlist(cbsa, "41540", "48540") & (CBSAmerge==4 | NECTAmerge==4)
replace tz_offset = -8 if time_zone=="P"
replace tz_offset = -7 if time_zone=="M"
replace tz_offset = -6 if time_zone=="C"
replace tz_offset = -5 if time_zone=="E"
assert !missing(time_zone) if (CBSAmerge==4 | NECTAmerge==4)

// Mixing state and county lat/lon
replace latitude = state_lat if latitude == .
replace longitude = state_lon if longitude == .
replace time_zone = state_time_zone if time_zone == ""
replace tz_offset = state_tz_offset if tz_offset == .

// solar_calculator is an ado file that has a copy in the Code/ directory
// Annual average sunset time calculated in separate file
rename date date_keep
preserve
// To create the dataset that you load into annual_atus_sunset.do, run the
// following code
keep latitude longitude date_keep tz_offset time_zone fips state
duplicates drop
drop if latitude == .
save "`work'/data/atus_for_annual_sunset.dta", replace
do "`work'/code/annual_atus_sunset.do"
restore

sort year latitude longitude
capture drop _merge
merge m:1 year latitude longitude using "`work'/data/atus_annual_sunset.dta"
keep if _merge == 3
drop _merge

// Correcting time zone for historical places
replace state_time_zone = "e" if state == "IN" & date < td(2apr2006) & time_zone == "E"
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


// Average distance from ideal time zone boundary
bysort time_zone: egen east_long = max(longitude)
gen tzdistance = longitude - east_long - 1

// Interactions

// Create factor vars
gen race = ptdtrace
replace race = 5 if race > 5
replace race = 5 if race == 3

gen hispanic = 0
replace hispanic = 1 if pehspnon == 2

gen educ = 0
replace educ = 1 if peeduca <= 38
replace educ = 2 if peeduca == 39
replace educ = 3 if peeduca >= 40 & peeduca <= 42
replace educ = 4 if peeduca >= 43 & peeduca != .

gen gender = pesex - 1
gen holiday = trholiday

// Generating all controls explicitly to aid including in tables
gen age = teage
gen age2 = age*age

foreach i of varlist educ gereg trdtind1 trdtocc1 tudiaryday year race {
   quietly: tab `i', gen(`i'_)
}
tab trdtocc1, gen(primary_occupation_)
tab trdtind1, gen(primary_industry_)

// Solar timing
// Based on equinox
gen date = mdy(3,20,year)
solar_calculator latitude longitude date tz_offset
drop sun_ra sun_dec solar_noon sunrise_time sunlight_duration
rename sunset_time sunset_time_equinox
drop date

// No DST
rename tz_offset tz_offset_temp
rename tz_offset_nodst tz_offset
solar_calculator latitude longitude date tz_offset
drop sun_ra sun_dec solar_noon sunrise_time sunlight_duration
rename sunset_time sunset_time_nodst
rename tz_offset tz_offset_nodst
rename tz_offset_temp tz_offset

// Daily
rename date_keep date
solar_calculator latitude longitude date tz_offset

// within tz differences
gen doy = doy(date)
bysort time_zone doy: egen min_sunset = min(sunset_time)
gen sunset_diff_doy = sunset_time - min_sunset
drop min_sunset
bysort time_zone month: egen min_sunset = min(sunset_time)
gen sunset_diff_mon = sunset_time - min_sunset

drop min_sunset
bysort time_zone: egen min_sunset = min(sunset_time)
gen sunset_diff_min = sunset_time - min_sunset

// Distance interactions
gen tzd_year = tzdistance*year
gen tzd_time = tzdistance*time_trend
gen tzd_month = tzdistance*month
gen tzd_age = tzdistance*age
gen tzd_age2 = tzdistance*(age^2)
gen tzd_lat = tzdistance*latitude
egen lat_cut_freq = cut(latitude ), group(5)
// Cuts at 10, 25, 50, 75, 90 
egen lat_cut_pctile = cut(latitude ), at(19.5 31.1 34.088 38.865 41.095 44.24 62) icodes
egen age_cut = cut(age), group(4)
egen age_cut2 = cut(age), group(5)
tab age_cut2, gen(age_cut2_)

quietly: su latitude
local min = floor(r(min))
local max = ceil(r(max))
egen lat_cut_each = cut(latitude), at(`min'(1)`max')


// Time based interactions
gen dayofyear = doy(date)
gen winter = 0
replace winter = 1 if dayofyear > 265 | dayofyear < 78
gen tzd_lat_winter = tzdistance*(-1*latitude)*winter
gen tzd_lat_summer = tzdistance*latitude*(1-winter)

// CBSA updating

replace fips = cbsa + "0" if (CBSAmerge==4 | NECTAmerge==4)


// Making some continuous versions of categorical variables
gen income_cat = . if hefaminc == -1
replace income_cat = 0 if hefaminc == 1
replace income_cat = 6000 if hefaminc == 2
replace income_cat = 8000 if hefaminc == 3
replace income_cat = 11000 if hefaminc == 4
replace income_cat = 13500 if hefaminc == 5
replace income_cat = 17000 if hefaminc == 6
replace income_cat = 22000 if hefaminc == 7
replace income_cat = 27000 if hefaminc == 8
replace income_cat = 32000 if hefaminc == 9
replace income_cat = 37500 if hefaminc == 10
replace income_cat = 45000 if hefaminc == 11
replace income_cat = 55000 if hefaminc == 12
replace income_cat = 65000 if hefaminc == 13
replace income_cat = 90000 if hefaminc == 14
replace income_cat = 125000 if hefaminc == 15
replace income_cat = 300000 if hefaminc == 16


gen income_cat_hu = . if hufaminc <= -1
replace income_cat_hu = 2500 if hufaminc == 1
replace income_cat_hu = 6000 if hufaminc == 2
replace income_cat_hu = 8000 if hufaminc == 3
replace income_cat_hu = 11000 if hufaminc == 4
replace income_cat_hu = 13500 if hufaminc == 5
replace income_cat_hu = 17000 if hufaminc == 6
replace income_cat_hu = 22000 if hufaminc == 7
replace income_cat_hu = 27000 if hufaminc == 8
replace income_cat_hu = 32000 if hufaminc == 9
replace income_cat_hu = 37500 if hufaminc == 10
replace income_cat_hu = 45000 if hufaminc == 11
replace income_cat_hu = 55000 if hufaminc == 12
replace income_cat_hu = 65000 if hufaminc == 13
replace income_cat_hu = 90000 if hufaminc == 14
replace income_cat_hu = 125000 if hufaminc == 15
replace income_cat_hu = 300000 if hufaminc == 16



gen median_wage = .
replace median_wage = 44888.16 if year == 2013
replace median_wage = 44321.67 if year == 2012
replace median_wage = 42979.61 if year == 2011
replace median_wage = 41673.83 if year == 2010
replace median_wage = 40711.61 if year == 2009
replace median_wage = 41334.97 if year == 2008
replace median_wage = 40405.48 if year == 2007
replace median_wage = 38651.41 if year == 2006
replace median_wage = 36952.94 if year == 2005
replace median_wage = 35648.55 if year == 2004
replace median_wage = 34064.95 if year == 2003


gen years_educ = 0
replace years_educ = 1 if peeduca == 32
replace years_educ = 5 if peeduca == 33
replace years_educ = 7 if peeduca == 34
replace years_educ = 9 if peeduca == 35
replace years_educ = 10 if peeduca == 36   
replace years_educ = 11 if (peeduca == 37 | peeduca == 38)
replace years_educ = 12 if peeduca == 39
replace years_educ = 14 if (peeduca == 40 | peeduca == 41 | peeduca == 42)
replace years_educ = 16 if peeduca == 43
replace years_educ = 18 if (peeduca == 44 | peeduca == 45)
replace years_educ = 20 if peeduca == 46


// Merge in the weather data
// This is created from weather_data.m
// The weather file is cleaned up by atus_weather_clean.do
gen longitude_round = 360+longitude if longitude < 0
replace longitude_round = 2.5*round(longitude_round/2.5)
gen latitude_round = 2.5*round(latitude/2.5)
merge m:1 latitude_round longitude_round date using "`work'/Data/atus_temperature.dta"
drop if _merge == 2
drop _merge

// Merge the precipitation and other weather data
rename cbsa cbsafp
tostring tudiarydate, replace
rename COUNTY county_fips
// First merge county
merge m:1 tudiarydate state_fips county_fips using "`work'/Data/weather/gchnd_county.dta"
foreach i in "prcp" "snow" "tmax" "tmin" {
    rename `i' `i'_county
}
foreach i in "PRCP" "SNOW" "TMAX" "TMIN" {
    rename num_obs`i' num_obs`i'_county
}
drop _merge
// CBSA
merge m:1 tudiarydate cbsafp using "`work'/Data/weather/gchnd_cbsa.dta"
foreach i in "prcp" "snow" "tmax" "tmin" {
    rename `i' `i'_cbsa
}
foreach i in "PRCP" "SNOW" "TMAX" "TMIN" {
    rename num_obs`i' num_obs`i'_cbsa
}
drop _merge
// State
merge m:1 tudiarydate state_fips using "`work'/Data/weather/gchnd_state.dta"
foreach i in "prcp" "snow" "tmax" "tmin" {
    rename `i' `i'_state
}
foreach i in "PRCP" "SNOW" "TMAX" "TMIN" {
    rename num_obs`i' num_obs`i'_state
}
drop _merge

// Put it all together
foreach i in "prcp" "snow" "tmax" "tmin" {
    gen `i' = `i'_county
    replace `i' = `i'_cbsa if `i' == .
    replace `i' = `i'_state if `i' == .
}
foreach i in "PRCP" "SNOW" "TMAX" "TMIN" {
    gen num_obs`i' = num_obs`i'_county
    replace num_obs`i' = num_obs`i'_cbsa if num_obs`i' == .
    replace num_obs`i' = num_obs`i'_state if num_obs`i' == .
}
drop prcp_* snow_* tmax_* tmin_* num_obs*_*
rename cbsafp cbsa
rename county_fips COUNTY

// Lags of temperature
rename date date0
rename temperature temperature0
forvalue i = 1/10 {
   gen date = date0-`i'
   merge m:1 latitude_round longitude_round date using "`work'/Data/atus_temperature.dta"
   drop if _merge == 2
   drop _merge date
   rename temperature temperatureL`i'
}
rename date0 date

// Adding CPI
* US. Bureau of Labor Statistics, Consumer Price Index for All Urban Consumers: All Items [CPIAUCSL], retrieved from FRED, Federal Reserve Bank of St. Louis https://research.stlouisfed.org/fred2/series/CPIAUCSL/. 
gen ym = ym(year, month)
merge m:1 ym using "`work'/Data/cpi.dta"
drop if _merge == 2
drop _merge

// Aggregating up to high-level uses
// Sleep is t010101 - t010199
// All other activities can be put into their 2 digit category, resulting in 20 categories
foreach i of numlist 1/16,18,50 {
   if length("`i'") == 1 {
      local prefix "0`i'"
   }
   else {
      local prefix "`i'"
   }
   egen time_cat_`prefix' = rowtotal(t`prefix'*)
}

egen time_cat_00 = rowtotal(t010101-t010199)
replace time_cat_01 = time_cat_01 - time_cat_00
   
label var time_cat_00 "Sleep"
label var time_cat_01 "Personal care"
label var time_cat_02 "Housework"
label var time_cat_03 "Caring for HH member"
label var time_cat_04 "Caring for non-HH member"
label var time_cat_05 "Work"
label var time_cat_06 "Education"
label var time_cat_07 "Shopping for personal goods"
label var time_cat_08 "Professional and personal services"
label var time_cat_09 "Household services"
label var time_cat_10 "Government services"
label var time_cat_11 "Eating and drinking"
label var time_cat_12 "Socializing and relaxing"
label var time_cat_13 "Sports, exercise, and recreation"
label var time_cat_14 "Religious activities"
label var time_cat_15 "Volunteering"
label var time_cat_16 "Telephone calls"
label var time_cat_18 "Travel"
label var time_cat_50 "Missing or error"



egen timeagg_1 = rowtotal(time_cat_05)
egen timeagg_2 = rowtotal(time_cat_*)
replace timeagg_2 = timeagg_2 - timeagg_1

// Make the time use categories even coarser
gen time_c_1 = time_cat_05
gen time_c_2 = time_cat_00
gen time_c_3 = time_cat_01 + time_cat_02 + time_cat_03 + time_cat_04 + time_cat_06 + time_cat_07 + time_cat_08 + time_cat_09 ///
       + time_cat_10
gen time_c_4 = time_cat_11 + time_cat_12 + time_cat_13 + time_cat_14 + time_cat_16 + time_cat_18 + time_cat_15
label var time_c_2 "Sleep"
label var time_c_1 "Work"
label var time_c_3 "Home production"
label var time_c_4 "Leisure"




// Labeling
label var sunset_time "Sunset time"
label var ln_wage "ln(wage)"
label var latitude "Latitude"
label var other_time "All other time"
label var wage_summ_stat "Hourly wage"
label var sleep "Sleep"
label var ln_sleep "Log(sleep)"

label var race_1 "Race, white"
label var race_2 "Race, black"
label var race_3 "Race, Asian"
label var race_4 "Race, other"
label var educ_1 "Less than high school"
label var educ_2 "High school"
label var educ_3 "Some college"
label var educ_4 "College"
label var gender "Female"
label var age "Age"
label var gereg_1 "Northeast"
label var gereg_2 "Midwest"
label var gereg_3 "South"
label var gereg_4 "West"
label var holiday "Holiday"
label var tudiaryday_1 "Sunday"
label var tudiaryday_2 "Monday"
label var tudiaryday_3 "Tuesday"
label var tudiaryday_4 "Wednesday"
label var tudiaryday_5 "Thursday"
label var tudiaryday_6 "Friday"
label var tudiaryday_7 "Saturday"


drop if tucaseid == .

// Re-scaling time variables so they are hours per week
// Variables are currently min/wk, so dividing by 60
foreach var in total_sleep long_sleep sleep_night2 nap1 nap2 nap3 nap4 nap5 nap6 nap7 nap_sst1 nap_sst2 sleep_base sleep_exnap sleep_exnap_sst2 sleep_exnap1 sleep_exnap2 ///
	sleep_exnap3 sleep_exnap4 sleep_exnap5 sleep_exnap6 sleep_exnap7 sleep work other_time  time_c_1 time_c_2 time_c_3 time_c_4 {
	replace `var' = `var'/60
	summarize `var'
}
foreach var of varlist time_c_* {
   replace `var' = `var'*7
}

// Saving
save "`work'/data/atus_proc.dta", replace
log close



