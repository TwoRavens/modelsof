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
save "practice.dta", replace






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
save "practice2.dta", replace

/* STEP 2c: Incorporate the capabilities of each state into the dyadic dataset */ 
use "practice.dta", clear
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

/* STEP 2d: Create the capability ratio for each dyad */ 
gen cap_big = max(cap1,cap2)
gen cap_ratio = cap_big/(cap1 + cap2)









/* STEP 3: Determine which Dyads will form alliances */ 
/* STEP 3a: Specify the parameters of the true DGP */ 
gen cons = -2.75
*gen cons = -3.0
gen b = .25
save "practice2.dta", replace

/* STEP 3b: Files to store values from below loop*/   
tempname memhold
tempfile results
postfile `memhold' rep1 rep2 using `results'


/* STEP 3c: Loop that determines which dyads form alliances */
/* Because the TRUE DGP has a random, u, it is possible for probit to be "Off" on a given 
draw. Therefore, we must estimate the model 500 times to determine how well probit will 
estimate the true b. */
local s 1
while `s' <=(500) {
di `s'

qui {

/* Errors are distributed normally (Why? because this is MY DGP, so I made it so!) */
gen p = uniform()
gen u = ln(p/(1-p))

/* The TRUE DGP */
gen xb = cons + b*cap_ratio + u

gen y = 0
replace y = 1 if xb >= 0


tab y


/* Finally, attempt to reestimate the the parameter on "cap_ratio" using 
probit model (since errors are distributed normally) */
capture logit y cap_ratio

/* Store the estimated coefficient on cap_ratio */
local coef`s' = _b[cap_ratio]
local se`s' = _se[cap_ratio]
}
post `memhold' (`coef`s'') (`se`s'')
drop u p xb y
local s = `s' + 1
}

/* STEP 3d: Post-loop commands to create variables that will summarize results */
postclose `memhold'
use `results' , clear



save "Dyad with Dyad Results", replace


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

