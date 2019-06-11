clear all
set mem 400m
set more off
set seed 1111111
set mat 800


cd "C:\Users\Paul\Desktop\DISSERTATION MAIN FOLDER\Alliance Data Folder\Simulation Datasets\"

use "prc2.dta", clear
drop if dyad~=.

/* STEP 3: Split Triadic Data into dyadic data */ 
/* STEP 3a: Assign each pair of countries in a triad a dyadic code */ 
gen dyad1 = (mem1*1000)+mem2
gen dyad2 = (mem1*1000)+mem3
gen dyad3 = (mem2*1000)+mem3

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
gen cap_big = max(cap1,cap2)
gen cap_ratio = cap_big/(cap1 + cap2)

save "bilateral_of_tri.dta", replace




use "practice2.dta", clear

/* STEP 3: Determine which Dyads will form alliances */ 
/* STEP 3a: Specify the parameters of the true DGP */ 
gen bilat=0
gen trilat=0
replace bilat=1 if dyad~=.
replace trilat=1 if triad~=.
gen bi_cap_ratio = bilat*cap_ratio
gen tri_cap_ratio = trilat*cap_ratio
gen cons = -9.85
gen b1=1
gen b2=2
gen b3=9


save "practice3.dta", replace

/* STEP 3b: Files to store values from below loop*/   
tempname memhold
tempfile results
postfile `memhold' rep1 rep2 rep3 rep4 rep5 rep6 using `results'



/* STEP 3c: Loop that determines which dyads form alliances */
/* Because the TRUE DGP has a random, u, it is possible for probit to be "Off" on a given 
draw. Therefore, we must estimate the model 500 times to determine how well probit will 
estimate the true b. */

local s 1
while `s' <=(500) {
di in white `s'


use "practice3.dta", clear

/* Errors are distributed logistically (Why? because this is MY DGP, so I made it so!) */
gen p = uniform()
gen u = ln(p/(1-p))

/* The TRUE DGP */
gen xb = cons +b1*cap_ratio + b2*SameRegion + b3*commonthreat + u

/* Place latent variables, xb, into normal cdf to obtain probability of 1 or 0 observation */
gen prob = 1/(1+exp(-xb))

/* Place probability into probit function. */
gen y = (0.5 < (prob))

*qui {
di in yellow "dyad stats"
tab y if triad==.

di in yellow "triad stats"
tab y if dyad==.
*}

*qui {
save "practice4.dta", replace
drop if triad~=.
rename y yb
save "bilateral.dta", replace

use "practice4.dta", replace
drop if dyad~=.

/* Prepare dependent variable to be incorporated into dyadic dataset */
gen dyad1 = (mem1*1000)+mem2
gen dyad2 = (mem1*1000)+mem3
gen dyad3 = (mem2*1000)+mem3
rename y y1
gen y2 = y1
gen y3 = y1
stack dyad1 y1 dyad2  y2 dyad3 y3, into(dyad y)
duplicates drop dyad y, force
gsort -y dyad
duplicates drop dyad, force
sort dyad
save "practice_tri_y.dta", replace

/* Add dependent variable to dyadic dataset */
use "bilateral_of_tri.dta", clear
sort dyad
merge dyad using "practice_tri_y.dta", nokeep keep(y)
drop _merge
rename y yt
gen multi=1
sort dyad
save "trilateral", replace
use  "bilateral.dta", clear
sort dyad
merge dyad using "trilateral", nokeep keep(yt multi)
replace multi=0 if multi==.
replace yt=0 if yt==.
gen y = yt+yb
drop yt yb 

/* Finally, attempt to reestimate the the parameter on "cap_ratio" using 
logit model (since errors have a logistic distribution) */
logit y cap_ratio SameRegion commonthreat multi

/* Store the estimated coefficient on cap_ratio */
local coef`s'=0
capture local coef`s' = _b[cap_ratio]
capture local se`s' = _se[cap_ratio]

gen c1 = `coef`s''
qui sum c1
if c1==0 {
drop u prob xb y p c1
di in red "We have a problem with b1"
continue
}

local coef2`s' = 0
capture local coef2`s' = _b[SameRegion]
*capture scalar c2 = _b[tri_cap_ratio]
capture local se2`s' = _se[SameRegion]


gen c2 = `coef2`s''
qui sum c2
if c2==0 {
drop u prob xb y p c1 c2
di in red "We have a problem with b2"
continue
}

local coef3`s'=0
capture local coef3`s' = _b[commonthreat]
capture local se3`s' = _se[commonthreat]
gen c3 = `coef3`s''
qui sum c3
if c3==0 {
drop u prob xb y p c1 c2 c3
di in red "We have a problem with b1"
continue
}

gen se = `se3`s''
sum se
if se==0 {
drop u prob xb y p se c1 c2 c3 se
di in red "We have a problem"
continue
}


post `memhold' (`coef`s'') (`coef2`s'') (`coef3`s'') (`se`s'') (`se2`s'') (`se3`s'')

drop u prob xb y p c1 c2 c3 se
*scalar drop c2
local s = `s' + 1
*}
}
/* STEP 3d: Post-loop commands to create variables that will summarize results */
postclose `memhold'
use `results' , clear





/* STEP 4: Report the mean parameter estimate from the 500 simulations */

rename rep1 b1_hat
rename rep4 se1

sum b1_hat, detail
local b_hat = r(mean)
sum se1, detail
local avg_se = r(mean)

gen Squared_Error = (b_hat - 26)^2
sum Squared_Error
local MSE = r(mean)
local SD_EST = r(sd)

local BIAS = `b_hat' - 25
local RMSE = sqrt(`MSE')
local Over_Confidence = `SD_EST'/`avg_se'

di in white "CAP RATIO SIMULATION RESULTS"
di in green "BIAS: " in yellow `BIAS'
di in green "RMSE: " in yellow `RMSE'
di in green "Over Confidence: " in yellow `Over_Confidence'


rename rep2 b2_hat
rename rep5 se2

sum b2_hat, detail
local b_hat = r(mean)
sum se2, detail
local avg_se = r(mean)

gen Squared_Error = (b_hat - 26)^2
sum Squared_Error
local MSE = r(mean)
local SD_EST = r(sd)

local BIAS = `b_hat' - 25
local RMSE = sqrt(`MSE')
local Over_Confidence = `SD_EST'/`avg_se'

di in white "SAME REGION SIMULATION RESULTS"
di in green "BIAS: " in yellow `BIAS'
di in green "RMSE: " in yellow `RMSE'
di in green "Over Confidence: " in yellow `Over_Confidence'




rename rep3 b3_hat
rename rep6 se3

sum b3_hat, detail
local b_hat = r(mean)
sum se3, detail
local avg_se = r(mean)

gen Squared_Error = (b_hat - 26)^2
sum Squared_Error
local MSE = r(mean)
local SD_EST = r(sd)

local BIAS = `b_hat' - 25
local RMSE = sqrt(`MSE')
local Over_Confidence = `SD_EST'/`avg_se'

di in white "COMMON THREAT SIMULATION RESULTS"
di in green "BIAS: " in yellow `BIAS'
di in green "RMSE: " in yellow `RMSE'
di in green "Over Confidence: " in yellow `Over_Confidence'


