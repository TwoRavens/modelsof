* Analysis_descriptive_stats.do
* TRI descriptive stats for Appendix

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/Analysis_descriptive_stats.log", replace
set matsize 11000

* Reading data
use "`work'/Data/Masters/PM_treatment.dta", clear

* Variable labels
label variable onsite_air "Onsite air"
label variable onsite_water "Onsite water"
label variable onsite_land "Onsite land"
label variable onsite_other "Offsite other"
label variable offsite_water "Offsite water"
label variable offsite_land "Offsite land"
label variable offsite_other "Offsite other"
label variable recy_recov_trtd "Recycled or treated"
label variable mindist_rolling "Dist. to nonattain monitor (km)"

****************************
* Primary descriptive stats
****************************
* Stats
eststo clear
estpost summarize onsite_air onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd PMmindist nonattainPWPM treated, listwise
	
* Table	
esttab using "`work'/Tables/Descriptive_stats.tex", cells("mean(fmt(2)) sd min max") substitute(mean Mean sd Stdev min Min max Max) label nomtitle nonumber /*longtable*/ replace

* Stats by attainment status
eststo clear
bysort nonattainPWPM: eststo: estpost summarize onsite_air onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd mindist_rolling treated

* Table	
esttab using "`work'/Tables/Descriptive_stats_byNA.tex", b(a1) se(a1) cells("mean(fmt(%-12.2fc)) sd(fmt(%-12.2fc))") ///
	substitute(mean Mean sd Stdev (1) "Attainment counties" (2) "Nonattainment counties") label replace


****************************
* Leakage descriptive stats
****************************
use "`work'/Data/Masters/PM_intrafirm.dta", clear

* Variable labels
label variable onsite_air "Onsite air"
label variable onsite_water "Onsite water"
label variable onsite_land "Onsite land"
label variable onsite_other "Offsite other"
label variable offsite_water "Offsite water"
label variable offsite_land "Offsite land"
label variable offsite_other "Offsite other"
label variable recy_recov_trtd "Recycled or treated"
label variable mindist_rolling "Dist. to nonattain monitor (km)"

* Subset to attainment counties
keep if nonattainPWPM==0

* Generate dummy for leakage-receiving plants
gen leakageplant = (otherplants_treated>=1)
replace leakageplant = . if missing(otherplants_treated)

* Stats by leakage status
eststo clear
bysort leakageplant: eststo: estpost summarize onsite_air onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd

* Table	
esttab using "`work'/Tables/Descriptive_stats_byLKG.tex", b(a1) se(a1) cells("mean(fmt(%-12.0fc)) sd(fmt(%-12.0fc))") ///
	substitute(mean Mean sd Stdev (1) "Other plants" (2) "Leakage plants") label replace


timer off 1
timer list 1
capture log close





