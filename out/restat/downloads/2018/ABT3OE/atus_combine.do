* File to combine the ATUS datasets
* The ATUS sum, cps, and resp datasets are combined to create a day by 
* individual dataset that has activities and demographics
*
* Jeff Shrader & Matthew Gibson
* Creation date: 2013-09-03
* Time-stamp: "2018-02-04 17:45:34 jgs"
*
* How to use this program
* . Edit the locals at the top of the program to control which ATUS files
*   you want to use. For instance, if you want to use the 2003-2016 combined
*   file, you would set local atusmain to "0316"
* . Make sure your paths are in the if statements under "Set paths". You can
*   set different paths for where the raw data lives (ext_dir) and where the
*   processed data lives (atus_dir).
* . They do the file!

* Set main directory
local work "/DIRECTORY"

** Edit these locals to control behavior and paths
* What files are going to be processed
local atusmain "0316"
local atusrostec "1116"
local atuswb "1013"

* Set paths
local ext_dir = "`work'/data"
local atus_dir = "`work'/data"
** Nothing below here needs to be edited for the code to run

** Merge base ATUS datasets together to create file contaning demographics
* and daily time use summaries
use "`ext_dir'/atus`atusmain'/atussum.dta", clear
de
merge 1:1 tucaseid using "`ext_dir'/atus`atusmain'/atusresp.dta"
su _merge
assert r(mean) == 3
drop _merge

* We end up dropping lots of the CPS data, why?
* Answer: Because this is all of the people who were
* contacted from the CPS. 
sort tucaseid tulineno
merge 1:m tucaseid tulineno using "`ext_dir'/atus`atusmain'/atuscps.dta"
* Summary stats on the difference between ATUS and non-ATUS CPS sample
* ATUS is richer
ttest prernwa if prernwa != -1, by(tratusr)
* ATUS also works slightly longer
ttest pehruslt if pehruslt > -1, by(tratusr)
keep if _merge == 3
drop _merge
drop tratusr

* Stata-formatted dates
tostring tudiarydate, replace
gen year = substr(tudiarydate,1,4)
gen month = substr(tudiarydate,5,2)
gen day = substr(tudiarydate,7,2)
destring year, replace
destring month, replace
destring day, replace
gen date = mdy(month,day,year)
drop year month day
format date %td
label var date "Stata formatted version of tudiarydate"

* Geocode

* Outputting combined daily dataset
compress
save "`atus_dir'/atus`atusmain'_day.dta", replace

* Activities file
*
* Some notes on the activity file
* tuactivity_n is a sequential ID of activities for each individual. This is
* one way you can figure out if the activity is at the beginning or end of the
* day. It is not certain, however, since different people record different
* numbers of activities. All activities start at 4am on day 1. They are allowed
* to end whenever they do on day 2, but tuactdur24 will truncate activity
* lengths as if they ended at 4am of day 2. Thus, you can tell if something
* is happening in the middle of the second night if you see that tuactdur !=
* tuactdur24. 

* Generate starting and stopping times for sleep
gen start_hour = substr( tustarttim, 1, 2)
gen stop_hour = substr(tustoptime, 1, 2)
gen start_min = substr( tustarttim, 4, 2)
gen stop_min = substr(tustoptime, 4, 2)
destring start_* stop_*, replace
gen start_time = start_hour + start_min/60
gen stop_time = stop_hour + stop_min/60

* You always know that something starting at 4am is starting on day 1
* Thus, you can also take the associated stopping time and add 24
replace stop_hour = stop_hour + 24 if start_time < 4
replace start_hour = start_hour + 24 if start_time < 4
* Another case is when start time < 24 and stop time is on next day
replace stop_hour = stop_hour + 24 if stop_time < start_time
* Last case is when a single activity lasts the entire day
replace stop_hour = stop_hour + 24 if stop_time >= start_time & tuactdur >= 1440

* Recasting start and stop times
drop stop_time start_time
gen double start_time = start_hour + start_min/60
gen double stop_time = stop_hour + stop_min/60

* Verifying
gen double spell = (stop_time - start_time)*60
su spell tuactdur
drop spell
* These should be exactly the same
format tucaseid %14.0f
sort tucaseid
save "`atus_dir'/atus_activity.dta", replace

*
   
