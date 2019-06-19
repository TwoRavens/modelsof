************************
* fixcwalk.do
* fixes problem with VA counties and cleans up Justin McCreary's cwalk
* first created by Alan Barreca 1/2006
* edited 6/2006
************************

drop _all
set memory 1000m
set more off
capture log close

log using /3310/research/foodstamps/vitals_natality/log/fixcwalk.log, replace

local cwalkpath="/3310/research/foodstamps/vitals_natality/cwalk"

use `cwalkpath'/nat_cwalkraw.dta, clear

rename fstate stfips
rename fcounty countyfips

*FIX (VA and other) COUNTIES
do /3310/research/foodstamps/census/dofiles/makedata/countyfix.do

sort stfips countyfips

save /3310/research/foodstamps/vitals_natality/cwalk/nat_cwalk.dta, replace

log close

