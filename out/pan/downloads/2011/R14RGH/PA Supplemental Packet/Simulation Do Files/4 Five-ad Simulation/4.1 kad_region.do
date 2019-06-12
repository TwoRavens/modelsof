clear all
set mem 7700m
set more off
set seed 1111111
set mat 800

*cd "C:\Users\Paul\Desktop\Methods Paper Simulations\"

cd "/tmp/poastpd/"


** ASSIGN COUNTRIES TO REGIONS
/* STEP 1a: Specify number of countries */ 
local ob 100
set obs `ob'

/* STEP 1: Randomly Assign capabilities to each country */ 
gen ccode  = _n


/* Assign each country to one of 5 regions */
gen g = uniform()
gen region = 0

replace region=1 if g<.10 & g>=0
replace region=2 if g<.20 & g>=.10
replace region=3 if g<.30 & g>=.20
replace region=4 if g<.40 & g>=.30
replace region=5 if g<.50 & g>=.40
replace region=6 if g<.60 & g>=.50
replace region=7 if g<.70 & g>=.60
replace region=8 if g<.80 & g>=.70
replace region=9 if g<.90 & g>=.80
replace region=10 if g<=1 & g>=.90

/*
replace region=1 if g<.05 & g>=0
replace region=2 if g<.10 & g>=.05
replace region=3 if g<.15 & g>=.10
replace region=4 if g<.20 & g>=.15
replace region=5 if g<.25 & g>=.20
replace region=6 if g<.30 & g>=.25
replace region=7 if g<.35 & g>=.30
replace region=8 if g<.40 & g>=.35
replace region=9 if g<.45 & g>=.40
replace region=10 if g<.50 & g>=.45
replace region=11 if g<.55 & g>=.50
replace region=12 if g<.60 & g>=.55
replace region=13 if g<.65 & g>=.60
replace region=14 if g<.70 & g>=.65
replace region=15 if g<.75 & g>=.70
replace region=16 if g<.80 & g>=.75
replace region=17 if g<.85 & g>=.80
replace region=18 if g<.90 & g>=.85
replace region=19 if g<.95 & g>=.90
replace region=20 if g<1 & g>=.95
*/

save "Region", replace


*** DETERMINE WHICH K-ADS ARE IN THE SAME REGION

** Add Region
local i 1
while `i' <=(5) {
use "Region.dta", clear
rename ccode mem`i'
sort mem`i'
save "region2.dta", replace
use "Complete Kad dataset.dta", clear
sort mem`i'
merge mem`i' using "region2.dta", nokeep keep(region)
rename region region`i'
replace region`i'=0 if region`i'==.
drop _merge
save "Complete Kad dataset.dta", replace
local i = `i' + 1 
}

gen SameRegion = 0
replace SameRegion=1 if (region1==region2==region3==region4==region5) | (region1==region2==region3==region4 & region5==0) | (region1==region2==region3 & region4==0 & region5==0) | (region1==region2 & region3==0 & region4==0 & region5==0) 

drop region1 region2 region3 region4 region5

save "Complete Kad dataset with regions.dta", replace






** CREATE DYAD DATASET
/* STEP 1: Create Fictional International System */ 
/* STEP 1a: Specify number of countries */ 
local ob 100
set obs `ob'

/* STEP 1b: Randomly Assign capabilities to each country */ 
gen x = uniform()
sum x
gen ccode  = _n
save "dyad for kad.dta", replace

/* STEP 2: Create Dyadic Dataset */ 
/* STEP 2a: Identify the number of dyads that will be created from the `ob' number of 
countries (i.e. number of combinations from `ob'=100 countries, pick 2 = 4950 combinations) */ 
use "dyad for kad.dta", clear
drop ccode
local  dyad_num = round((`ob'*(`ob'-1))/2)
set obs `dyad_num'

/* STEP 2b: Loop that places all of the countries into all possible dyadic combinations */ 
tempname memhold2
tempfile results2
postfile `memhold2' rep1 rep2 rep3 using `results2'
local i 1
local h 1
while `i' <=(`ob') {
local j = `i'+1
while `j' <=(`ob') {
local dyad`i'`j' = ((`i'*100)+`j')
local mem`h' = `i'
local ccode`h' = `j'
post `memhold2' (`dyad`i'`j'') (`mem`h'') (`ccode`h'')
local j = `j' + 1
local h = `h' + 1
}
local i = `i' + 1
}

postclose `memhold2'
use `results2' , clear
rename rep1 dyad
rename rep2 mem1
rename rep3 mem2
sort mem1
save "dyad for kad2.dta", replace


** incorporate capabilities data
/* STEP 2c: Incorporate the capabilities of each state into the dyadic dataset */ 
use "practice.dta", clear
capture rename mem2 ccode
capture rename cap2 cap
rename ccode mem1
rename cap cap1
sort mem1
save "practice.dta", replace

use "dyad for kad2.dta", clear
sort mem1
merge mem1 using "practice.dta", nokeep keep(cap1)
drop _merge
save "dyad for kad2.dta", replace

use "practice.dta", clear
rename mem1 mem2
rename cap1 cap2
sort mem2
save "practice.dta", replace

use "dyad for kad2.dta", clear
sort mem2
merge mem2 using "practice.dta", nokeep keep(cap2)
drop _merge
save "dyad for kad2.dta", replace

/* STEP 2d: Create the capability ratio for each dyad */ 
gen cap_big = max(cap1,cap2)
gen cap_ratio = cap_big/(cap1 + cap2)


save "dyad for kad2.dta", replace


** incorporate region data
/* STEP 2c: Incorporate the capabilities of each state into the dyadic dataset */ 
use "Region", clear
capture rename mem2 ccode
capture rename region2 region
rename ccode mem1
rename region region1
sort mem1
save "Region", replace

use "dyad for kad2.dta", clear
sort mem1
merge mem1 using "Region", nokeep keep(region1)
drop _merge
save "dyad for kad2.dta", replace

use "Region", clear
rename mem1 mem2
rename region1 region2
sort mem2
save "Region", replace

use "dyad for kad2.dta", clear
sort mem2
merge mem2 using "Region", nokeep keep(region2)
drop _merge
save "dyad for kad2.dta", replace

/* STEP 2d: Create the capability ratio for each dyad */ 
gen SameRegion = 0
replace SameRegion=1 if (region1==region2)
drop region1 region2

gen dyad = (mem1*1000)+mem2

save "dyad for kad2.dta", replace
