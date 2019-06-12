// Clean up the data created by weather_data.m
//
// Jeff Shrader & Matt Gibson
// Creation date: 2015-01-30
// Time-stamp: "2016-07-25 22:51:21 jgs"

clear

local work "/DIRECTORY"
local weather "`work'/ghcn/daily"
cd "`work'"

capture log close
log using "`work'/logs/atus_weather.log", replace

// First, to make the dataset that feeds into matlab, run:
use "`work'/data/atus_proc.dta", clear
keep latitude longitude
gen latitude_round = 2.5*round(latitude/2.5)
gen longitude_round = 360+longitude if longitude < 0
replace longitude_round = 2.5*round(longitude_round/2.5)
drop latitude longitude
duplicates drop 
outsheet using "`work'/data/atus_lat_lon_for_weather.csv", comma replace nonames

// Now to clean up the data that results from the matlab code
insheet using "`work'/data/atus_temperature.csv", clear nonames
rename v1 latitude_round
rename v2 longitude_round
// Run over all days
reshape long v, i(latitude_round longitude_round) j(date)
replace date = date + d(1jan2003) - 3
format date %td
rename v temperature

// Temp is given in Kelvin from NOAA
replace temperature = temperature - 272.15

// Save
sort latitude_round longitude_round date
saveold "`work'/data/atus_temperature.dta", replace

// Station data on precipitation, min, and max temp
use "`work'/data/atus_proc.dta", clear
keep tudiarydate *fips* COUNTY cbsa
rename COUNTY county_fips
rename tudiarydate date
rename cbsa cbsafp
drop state_fips_partial fix_fips fips_string gestfips
duplicates drop
sort date state_fips county_fips cbsa
tostring date, replace
save "`work'/data/atus_for_gchnd.dta", replace

foreach s in "state" "county" "cbsa" {
    if "`s'" == "state" {
        local id "`s'_fips"
    }
    else if "`s'" == "county" {
        local id "state_fips `s'_fips"
    }
    else {
        local id "cbsafp"
    }
    forvalues y = 2003(1)2013 {
            
        use "`weather'/`y'_`s'.dta", clear
        if "`s'" == "cbsa" {
            tostring `id', replace
        }
        * Reshape by element
        reshape wide value num_obs, i(`id' date) j(element) string
        rename valuePRCP prcp
        rename valueTMAX tmax
        rename valueTMIN tmin
        rename valueSNOW snow
        drop valueTAVG num_obsTAVG
        merge 1:m date `id' using "`work'/data/atus_for_gchnd.dta", keep(match) nogen
        keep date `id' prcp snow tmax tmin num_obs*
        save "`work'/data/weather/gchnd_`s'_`y'.dta", replace
    }
    clear
    cd "`work'/data/weather"
    local allfiles : dir . files "gchnd_`s'_*"
    append using `allfiles'
    rename date tudiarydate
    sort `id' tudiarydate
    duplicates drop
    save "`work'/data/weather/gchnd_`s'.dta", replace
}


