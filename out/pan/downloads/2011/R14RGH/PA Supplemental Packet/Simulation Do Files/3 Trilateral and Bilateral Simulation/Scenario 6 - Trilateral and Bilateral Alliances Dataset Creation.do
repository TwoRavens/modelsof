clear all
set mem 400m
set more off
set seed 1111111
set mat 800


cd "C:\Users\Paul\Desktop\DISSERTATION MAIN FOLDER\Alliance Data Folder\Simulation Datasets\"

/* STEP 1: Create Fictional International System */ 
/* STEP 1a: Specify number of countries */ 
local ob 100
set obs `ob'

/* STEP 1: Randomly Assign capabilities to each country */ 
*gen x = ibeta(4,1,uniform())
gen x = uniform()
sum x
gen ccode  = _n
gen cap = x*100
save "practice.dta", replace
*hist cap

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
save "practice.dta", replace


/* STEP 2: Assign rivals */
/* STEP 2a: Identify the number of dyads that will be created from the `ob' number of 
countries (i.e. number of combinations from `ob'=100 countries, pick 2 = 4950 combinations) */ 
use "practice.dta", clear
drop x ccode cap
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
save "prc2.dta", replace

/* STEP 2c: Incorporate the capabilities of each state into the dyadic dataset */ 
use "practice.dta", clear
rename ccode mem1
rename region region1
rename cap cap1
sort mem1
save "practicel.dta", replace

use "prc2.dta", clear
sort mem1
merge mem1 using "practicel.dta", nokeep keep(cap1 region1)
drop _merge
save "prc2.dta", replace

use "practicel.dta", clear
rename mem1 mem2
rename cap1 cap2
rename region region2
sort mem2
save "practicel.dta", replace

use "prc2.dta", clear
sort mem2
merge mem2 using "practicel.dta", nokeep keep(cap2 region2)
drop _merge
save "prc2.dta", replace

/* STEP 2d: Determine which dyads are rivals */ 
gen probr = uniform()
sum probr
gen r1 = (0.40 > (probr))  if region1==region2
tab r1
gen r2 = (0.01 > (probr))
tab r2
gen rt = r1+r2
replace rt=0 if rt==.
gen r=0
replace r=1 if rt>0
keep dyad mem1 mem2 r
save "rival dyads.dta", replace

*stop

/* Create List of each country's rivals */
use "rival dyads.dta", clear
keep if r==1
rename mem2 rival
*rename cap2 rival_cap
*keep mem1 rival rival_cap
keep mem1 rival
gen rival_ccode = rival
save "rival dyads2.dta", replace
reshape wide rival_ccode, i(mem1) j(rival)
qui describe rival_ccode*
qui return list
qui local K = r(k) - 1
di `K'
local i 1
foreach var of varlist rival_ccode* {
rename `var' threat`i'
local i = `i' + 1
}
di `ob'
local r_num = (`ob'-1)
di `r_num'
local i 1
while `i' <=(`r_num') {
gen rival`i'=0
local i = `i' + 1
}
save "rival dyads2.dta", replace
drop if mem1>0
save "mem threats1.dta", replace
use "rival dyads2.dta", clear
levels mem1, local(member)
foreach m in `member' {
use "rival dyads2.dta", clear
di in red `m'
keep if mem1==`m'
local j 1
local k 0
while `j' <=(`r_num') {
di in yellow `j'
local i = 1 + `k'
while `i' <=(`K') { 
di in green `i'
if (threat`i'~=. & rival`j'==0) {
replace rival`j'=threat`i'
}
if rival`j'>0 {
continue, break
}
local i = `i' + 1
}
local k = `i'
local j = `j' + 1
}
save "temp.dta", replace
use  "mem threats1.dta", clear
append using "temp.dta"
save  "mem threats1.dta", replace
}
use "mem threats1.dta", clear
drop threat*
*capture program drop DropRival
*program define DropRival
local i 1
while `i' <=(`r_num') {
di `i'
replace rival`i'=. if rival`i'==0
local i = `i' + 1
}
dropmiss
*di "dropped missing"
*end
*qui DropRival
capture program drop ThreatZero
program define ThreatZero
syntax varlist(min=1 numeric)
local j 1
foreach var of varlist `varlist' {
di `var'
replace rival`j'=0 if rival`j'==.
local j = `j' + 1
}
end
ThreatZero rival*
save "mem threats1.dta", replace

/*   reverse */
/* Create List of each country's rivals */
use "rival dyads.dta", clear
keep if r==1
rename mem1 rival
*rename cap1 rival_cap
keep mem2 rival
gen rival_ccode = rival
save "rival dyads3.dta", replace
reshape wide rival_ccode, i(mem2) j(rival)
qui describe rival_ccode*
qui return list
qui local K = r(k) - 1
di `K'
local i 1
foreach var of varlist rival_ccode* {
rename `var' threat`i'
local i = `i' + 1
}
di `ob'
local r_num = (`ob'-1)
di `r_num'
local i 1
while `i' <=(`r_num') {
gen rival`i'=0
local i = `i' + 1
}
save "rival dyads3.dta", replace
drop if mem2>0
save "mem threats2.dta", replace
use "rival dyads3.dta", clear
levels mem2, local(member)
foreach m in `member' {
use "rival dyads3.dta", clear
di in red `m'
keep if mem2==`m'
local j 1
local k 0
while `j' <=(`r_num') {
di in yellow `j'
local i = 1 + `k'
while `i' <=(`K') { 
di in green `i'
if (threat`i'~=. & rival`j'==0) {
replace rival`j'=threat`i'
}
if rival`j'>0 {
continue, break
}
local i = `i' + 1
}
local k = `i'
local j = `j' + 1
}
save "temp.dta", replace
use  "mem threats2.dta", clear
append using "temp.dta"
save  "mem threats2.dta", replace
}
use "mem threats2.dta", clear
drop threat*
*capture program drop DropRival
*program define DropRival
local i 1
while `i' <=(`r_num') {
di `i'
replace rival`i'=. if rival`i'==0
local i = `i' + 1
}
dropmiss
*di "dropped missing"
*end
*qui DropRival
capture program drop ThreatZero
program define ThreatZero
syntax varlist(min=1 numeric)
local j 1
foreach var of varlist `varlist' {
di `var'
replace rival`j'=0 if rival`j'==.
local j = `j' + 1
}
end
ThreatZero rival*
rename mem2 mem1
save "mem threats2.dta", replace

use "mem threats1.dta", clear
append using "mem threats2.dta"
save "mem threats.dta", replace

*use "mem threats.dta", clear



/* STEP 2: Create Triadic Dataset */ 
/* STEP 2a: Identify the number of triads that will be created from the `ob' number of 
countries (i.e. number of combinations from `ob' countries, pick 3) */ 
use "practice.dta", clear
local choose 3
drop x ccode cap
local n_fact = exp(lnfactorial(`ob'))
local k_fact = exp(lnfactorial(`choose'))
local n_minus_k_fact = exp(lnfactorial(`ob' - `choose'))
local  group_num = round(`n_fact'/(`k_fact'*`n_minus_k_fact'))
di `group_num'
set obs `group_num'


/* STEP 2b: Loop that places all of the countries into all of the triadic combinations */
tempname memhold2
tempfile results2
postfile `memhold2' rep1 rep2 rep3 rep4 using `results2'

local i1 1
local h 1
while `i1' <=(`ob') {
local i2 = `i1'+1
while `i2' <=(`ob') {
local i3 = `i2' + 1
while `i3'<=(`ob') {
*local dyad`i'`j' = (`i1'*10000)+(`i2'*1000) + `i3'
local dyad`i'`j' = `h'
local mem`h' = `i1'
local ccode`h' = `i2'
local cccd`h' = `i3'
post `memhold2' (`dyad`i'`j'') (`mem`h'') (`ccode`h'') (`cccd`h'')
local i3 = `i3' + 1
local h = `h' + 1
}
local i2 = `i2' + 1
}
local i1 = `i1' + 1
}

postclose `memhold2'
use `results2' , clear

rename rep1 triad
rename rep2 mem1
rename rep3 mem2
rename rep4 mem3
sort mem1
save "prc2.dta", replace


/* STEP 2c: Incorporate the capabilities of each state into the triadic dataset */ 
use "practice.dta", clear
rename ccode mem1
rename cap cap1
rename region region1
sort mem1
save "practicel.dta", replace

use "prc2.dta", clear
sort mem1
merge mem1 using "practicel.dta", nokeep keep(cap1 region1)
drop _merge
save "prc2.dta", replace

use "practicel.dta", clear
rename mem1 mem2
rename cap1 cap2
rename region1 region2
sort mem2
save "practicel.dta", replace

use "prc2.dta", clear
sort mem2
merge mem2 using "practicel.dta", nokeep keep(cap2 region2)
drop _merge
save "prc2.dta", replace

use "practicel.dta", clear
rename mem2 mem3
rename cap2 cap3
rename region2 region3
sort mem3
save "practicel.dta", replace

use "prc2.dta", clear
sort mem3
merge mem3 using "practicel.dta", nokeep keep(cap3 region3)
drop _merge
save "prc2.dta", replace

save "trilateral.dta", replace










/* STEP 2: Create Dyadic Dataset */ 
/* STEP 2a: Identify the number of dyads that will be created from the `ob' number of 
countries (i.e. number of combinations from `ob'=100 countries, pick 2 = 4950 combinations) */ 
use "practice.dta", clear
drop x ccode cap
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
save "prc2.dta", replace

/* STEP 2c: Incorporate the capabilities of each state into the dyadic dataset */ 
use "practice.dta", clear
rename ccode mem1
rename cap cap1
rename region region1
sort mem1
save "practicel.dta", replace

use "prc2.dta", clear
sort mem1
merge mem1 using "practicel.dta", nokeep keep(cap1 region1)
drop _merge
save "prc2.dta", replace

use "practicel.dta", clear
rename mem1 mem2
rename cap1 cap2
rename region1 region2
sort mem2
save "practicel.dta", replace

use "prc2.dta", clear
sort mem2
merge mem2 using "practicel.dta", nokeep keep(cap2 region2)
drop _merge
save "prc2.dta", replace

save "bilateral.dta", replace

append using "trilateral.dta"

order dyad triad mem1 mem2 mem3 cap1 cap2 cap3
save "k-ads", replace


use "mem threats.dta", clear
*use "k-ads", clear

*stop






describe
return list
local k = r(k) - 1
di `k'

use "k-ads", clear
save "k-ads2", replace

local j 1
while `j' <=(3){
di in yellow `j'
local i 1
while `i' <=(`k') {
di in white `i'
use "mem threats.dta", clear
rename rival`i'  rival_`j'`i'
rename mem1 mema
rename mema mem`j'
sort mem`j'
save "mem threats2.dta", replace
use "k-ads2", clear
sort mem`j'
merge mem`j' using "mem threats2.dta", nokeep keep(rival_`j'`i')
replace rival_`j'`i'=0 if rival_`j'`i'==.
drop _merge
save "k-ads2", replace
local i = `i' + 1
}
local j = `j' + 1
}

replace region3=0 if region3==.
gen SameRegion = 0
replace SameRegion=1 if region1==region2 & region1==region3 & triad~=.
replace SameRegion=1 if region1==region2 & dyad~=.
replace cap3 = 0 if cap3==.
gen cap_big = max(cap1,cap2, cap3)
gen cap_ratio = cap_big/(cap1 + cap2 + cap3)
gen total_cap = cap1 + cap2 + cap3
save "prc2.dta", replace

stop
** Ceate commonthreat variable

set more off
use "prc2.dta", clear
capture drop id
gen id = _n
save "prc2.dta", replace
keep id
drop if id>0
save "prc2_store", replace
use "prc2.dta", clear
sum id
local N = r(N)

local i 1
while `i' <=(`N') {
di in yellow `i'
qui {
use "prc2.dta", clear
keep if id==`i'
sum id
local s = r(mean)
save "p", replace

keep rival_1*
xpose, clear
rename v1 t1
save "p1", replace
use "p", clear
keep rival_2*
xpose, clear
rename v1 t2
save "p2", replace
use "p", clear
keep rival_3*
xpose, clear
rename v1 t3
save "p3", replace
use "p1", clear
cross using "p2"
cross using "p3"
gen commonthreat=0
replace commonthreat=1 if t1==t2 & t1==t3
gen id = `s'
sort id
save "p_store", replace
use "p", clear
sort id
merge id using "p_store", nokeep keep(commonthreat)
save "p", replace
use "prc2_store", clear
append using "p"
save "prc2_store", replace
}
local i = `i' + 1
}




stop

gen commonthreat=0


replace commonthreat=1 if (rival_11>0 & ((rival_11==rival21 & rival_11==rival_31) | (rival_11==rival_21 & rival_11==rival_32)  | (rival_11==rival_22 & rival_11==rival_31)  | (rival_11==rival_22 & rival_11==rival_32))) | (rival_12>0 & ((rival_12==rival_21 & rival_12==rival_31) | (rival_12==rival_21 & rival_12==rival_32)  | (rival12==rival_22 & rival_12==rival_31)  | (rival_12==rival_22 & rival_12==rival_32) & (rival_11>0 | rival_12>0))) & triad~=.
tab commonthreat if triad~=.
replace commonthreat=1 if dyad~=. & ((rival_11>0 & ((rival_11==rival_21) | (rival_11==rival_22)))  | (rival_12>0 & ((rival_12==rival21) | (rival_12==rival_22))))
tab commonthreat if dyad~=.
tab commonthreat if triad~=.


*replace commonthreat=1 if (rival11==rival21 & rival11==rival31 & rival11>0) & triad~=.
*replace commonthreat=1 if (rival11==rival21 & rival11>0) & dyad~=.


save "prc2.dta", replace
