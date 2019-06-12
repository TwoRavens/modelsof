// Stata file to process the combined ATUS files and add additional variables for
// estimation. Ideally, the estimation code should do minimal data processing.
//
// Jeff Shrader & Matt Gibson
// Creation date: 2014-02-06
// Time-stamp: "2018-02-04 17:44:26 jgs"

// Preliminaries
clear

local work "/DIRECTORY"

capture log close
log using "`work'/logs/ATUS_proc.log", replace
set more off
timer clear 1
timer on 1


//////////////////////////////////////////
// Data Processing
//////////////////////////////////////////
use "`work'/data/atus_proc.dta", clear
keep tucaseid sleep t010101 latitude longitude fips sunset_time sunrise_time sunset_time_avg sunlight_duration
format tucaseid %14.0f
tostring tucaseid, gen(id) u
sort id
save "`work'/data/atus_trunc.dta", replace
use "`work'/data/atus_activity.dta", clear
format tucaseid %14.0f
tostring tucaseid, gen(id) u
// We will make a sleep specific dataset
// Keep just the sleep coded activities
keep if trcodep == 10101

// Sleep spells are defined by tuactdur24
gen total_sleep = tuactdur24
gen long_sleep = tuactdur
gen sleep_night2 = tuactdur if start_time >= 19
// Nap spells are sleep spells defined by the following criteria
gen nap1 = tuactdur if start_time > 9 & start_time < 18 & stop_time < 20
gen nap2 = tuactdur if start_time > 9 & start_time < 17 & stop_time < 20
gen nap3 = tuactdur if start_time > 9 & start_time < 20 & stop_time < 20
gen nap4 = tuactdur if start_time > 9 & start_time < 18 & stop_time < 18
gen nap5 = tuactdur if start_time > 9 & start_time < 18
gen nap6 = tuactdur if start_time > 9 & start_time < 20
gen nap7 = tuactdur if start_time > 12 & start_time < 18 & stop_time < 20


// Adding some ATUS data to get sleep pre-sunset
sort id
merge m:1 id using "`work'/data/atus_trunc.dta"
// Non mergers are people who report no sleep
drop _merge

// Naps based on sunrise and sunset
// This sunset time should handle second day stop times, but those are a very
// small number of observations.
gen nap_sst1 = tuactdur if start_time > sunrise_time ///
       & start_time < sunset_time & stop_time < sunset_time
gen nap_sst2 = tuactdur if start_time > sunrise_time+2 ///
       & start_time < sunset_time & stop_time < sunset_time
gen nap_sst3 = tuactdur if start_time > sunrise_time+2 ///
       & start_time < sunset_time 

// Inference on night shift work
gen night_shift = (start_time > 6 & start_time < 18 & stop_time < 22 & tuactdur24 > 200)

// Building a proxy for bedtime -- we don't actually know that this is
// bedtime since they don't tell us that information, but we can take
// the start of their first nighttime sleep or the start of their longest
// sleep session. I am using roughly the same division of the day as our
// prefered nap variable. We are also only taking day 1 values.
bysort tucaseid (tuactivity_n): egen waketime = max(stop_time) if ///
       stop_time <= sunrise_time+4 & start_time <= 24
bysort tucaseid (tuactivity_n): egen bedtime = min(start_time) if ///
       start_time >= sunset_time-2 & start_time <= sunrise_time+22
// A little illustrative plot. I am disguising the round number heaping, since
// that is a feature of the ATUS data but distracts from the point of the graph
// which is to check whether these definitions are intuitively appealing. 
twoway (hist waketime, width(1)) (hist bedtime, color(blue) width(1)), legend(label(1 "Wake time") label(2 "Bedtime"))
graph export "`work'/graphs/bedtime_waketime_hist.pdf", replace as(pdf)

save "`work'/data/atus_plus_activities.dta", replace

collapse (sum) total_sleep long_sleep sleep_night2 nap* tucaseid ///
       (max) night_shift waketime bedtime, by(id)

label var total_sleep "Should be the same as ATUS reported sleep. Truncated at 24 hours"
label var long_sleep "All sleep reported in diary, untruncated."
label var sleep_night2 "Sleep only reported on night 2 of diary, untruncated."
label var nap1 "Sleep that starts after 9 and before 6pm, ending before 8pm."
label var nap2 "Sleep that starts after 9 and before 5pm, ending before 8pm."
label var nap3 "Sleep that starts after 9 and before 8pm, ending before 8pm."
label var nap4 "Sleep that starts after 9 and before 6pm, ending before 6pm."
label var nap5 "Sleep that starts after 9 and before 6pm, no set ending."
label var nap6 "Sleep that starts after 9 and before 8pm, no set ending."
label var nap7 "Sleep that starts after 12 and before 6pm, ending before 8pm."
label var nap_sst1 "Sleep start after sunrise and before sunset, ending before sunset."
label var nap_sst2 "Sleep start after sunrise and before sunset, no end time."
label var night_shift "Inference on night shift worker based on long daytime sleep."
label var bedtime "Probable bedtime"
label var waketime "Probable morning rise time"
sort id
save "`work'/data/atus_sleep_activity.dta", replace


//////////////////////////////////////////
// Simple analysis
//////////////////////////////////////////
clear
use "`work'/data/atus_proc.dta", clear
sort tucaseid
merge 1:1 tucaseid using "`work'/data/atus_sleep_activity.dta"

keep if inrange(sleep, 2, 16)

/////////////////////////////////
// Locals for sets of controls
/////////////////////////////////
local geographic = "latitude gereg_*"
local individual = "race_* gender age age2"
local time = "holiday tudiaryday_* year_*"
local ind_occ = "primary_occupation_*" 
local base_control = "`geographic' `individual' `time' `ind_occ'"

local iv "sunset_time" 

local lhs "ln_wkly_wage" 
label var `lhs' "ln(wage)"

quietly: su sleep if `lhs' != .
local avg_sleep = r(mean)

forvalues i = 1/4 {
   gen sleep_nonaps`i' = sleep - nap`i'/60
}


