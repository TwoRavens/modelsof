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

/* STEP 1b: Randomly Assign capabilities to each country */ 
gen x = uniform()
sum x
gen ccode  = _n
gen cap = x*100
save "C:\Users\Paul\Desktop\origin.dta", replace




/* STEP 2: Create Triadic Dataset */ 
/* STEP 2a: Identify the number of triads that will be created from the `ob' number of 
countries (i.e. number of combinations from `ob' countries, pick 3) */ 
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
save "practice2.dta", replace


/* STEP 2c: Incorporate the capabilities of each state into the triadic dataset */ 
use "origin.dta", clear
rename ccode mem1
rename cap cap1
sort mem1
save "practice.dta", replace

use "practice2.dta", clear
sort mem1
merge mem1 using "practice.dta", nokeep keep(cap1)
drop _merge
save "practice2.dta", replace

use "practice.dta", clear
rename mem1 mem2
rename cap1 cap2
sort mem2
save "practice.dta", replace

use "practice2.dta", clear
sort mem2
merge mem2 using "practice.dta", nokeep keep(cap2)
drop _merge
save "practice2.dta", replace

use "practice.dta", clear
rename mem2 mem3
rename cap2 cap3
sort mem3
save "practice.dta", replace

use "practice2.dta", clear
sort mem3
merge mem3 using "practice.dta", nokeep keep(cap3)
drop _merge
save "practice2.dta", replace

/* STEP 2d: Create the capability ratio for each triad */ 
gen cap_big = max(cap1,cap2, cap3)
gen cap_ratio = cap_big/(cap1 + cap2 + cap3)

/* STEP 2e: Specify parameters for the true DGP */

/* OPTION 1: Generates probability needed for number of bilateral alliances to be the 
same as in simulation 1 (i.e. still a rare event). NOTE: Produces b_hat = */
*gen cons = -4.4
*gen b = .20

/* OPTION 2: This is probability used in simulation 1 (when data split into dyadic dataset, 
alliances will no longer be a rare event).  NOTE: Produces b_hat = */
*gen cons = -2
*gen b = .20

/* OPTION 3: This is probability that produces a proportion of triadic alliances 
that is consistent with reality */
gen cons = -3.5
gen b = .25

save "trilateral.dta", replace






/* STEP 3: Split Triadic Data into dyadic data */ 
/* STEP 3a: Assign each pair of countries in a triad a dyadic code */ 
gen dyad1 = (mem1*1000)+mem2
gen dyad2 = (mem1*1000)+mem3
gen dyad3 = (mem2*1000)+mem3

save "trilateral.dta", replace

/* STEP 3b: Preparing state labels and capability scores to be placed into dyadic dataset */ 
rename mem1 mem1a
gen mem1b = mem1a
rename mem2 mem2a
gen mem2b = mem2a
rename mem3 mem3a
gen mem3b = mem3a
rename cap1 cap1a
gen cap1b = cap1a
rename cap2 cap2a
gen cap2b = cap2a
rename cap3 cap3a
gen cap3b = cap3a

/* STEP 3c: Convert into dyadic data */ 
stack dyad1 mem1a mem2a cap1a cap2a    dyad2 mem1b mem3a cap1b cap3a  dyad3 mem2b mem3b cap2b cap3b, into(dyad mem1 mem2 cap1 cap2)
duplicates drop dyad, force

/* STEP 3d: Create the capability ratio for each dyad */ 
gen cap_bigd = max(cap1,cap2)
gen cap_ratiod = cap_bigd/(cap1 + cap2)

save "bilateral.dta", replace





/* STEP 4: Determine which Triads will form alliances */ 
/* STEP 4a: Files to store values from below loop*/ 
tempname memhold
tempfile results
postfile `memhold' rep1 rep2 using `results'

/* STEP 4b: Loop that determines which dyads form alliances */
/* Because the TRUE DGP has a random, u, it is possible for probit to be "Off" on 
a given draw.  Therefore, we must estimate the model 500 times to determine how 
well probit will estimate the true b. */
local s 1
while `s' <=(500) {
di `s'

qui {

use "trilateral.dta", clear

/* Errors are distributed normally (Why? because this is MY DGP, so I made it so!) */
gen p = uniform()
gen u = ln(p/(1-p))

/* The TRUE DGP */
gen xb = cons + b*cap_ratio + u

gen y = 0
replace y = 1 if xb > 0

tab y

/* Prepare dependent variable to be incorporated into dyadic dataset */
rename y y1
gen y2 = y1
gen y3 = y1
stack dyad1 y1 dyad2  y2 dyad3 y3, into(dyad y)
duplicates drop dyad y, force
gsort -y dyad
duplicates drop dyad, force
sort dyad
save "practice_y.dta", replace

/* Add dependent variable to dyadic dataset */
use "bilateral.dta", clear
sort dyad
merge dyad using "practice_y.dta", nokeep keep(y)
drop _merge

/* Finally, attempt to reestimate the the parameter on "cap_ratio" 
using probit model (since errors are distributed normally) */

tab y

capture logit y cap_ratiod

/* Store the estimated coefficient on cap_ratio */
local coef`s' = _b[cap_ratiod]
local se`s' = _se[cap_ratiod]

drop y
}
post `memhold' (`coef`s'') (`se`s'')
*rename y3 y 
*drop u prob xb 
local s = `s' + 1
}

/* STEP 4c: Post-loop commands to create variables that will summarize results */
postclose `memhold'
use `results' , clear


save "Triad with Dyad Results", replace


/* STEP 4: Report the mean parameter estimate from the 500 simulations */
rename rep1 b_hat
rename rep2 se

sum b_hat, detail
local b_hat = r(mean)
sum se, detail
local avg_se = r(mean)

gen Squared_Error = (b_hat - .25)^2
sum Squared_Error
local MSE = r(mean)
local SD_EST = r(sd)

local BIAS = `b_hat' - .25
local RMSE = sqrt(`MSE')
local Over_Confidence = `SD_EST'/`avg_se'

di "BIAS: " `BIAS'
di "RMSE: " `RMSE'
di "Over Confidence: " `Over_Confidence'
