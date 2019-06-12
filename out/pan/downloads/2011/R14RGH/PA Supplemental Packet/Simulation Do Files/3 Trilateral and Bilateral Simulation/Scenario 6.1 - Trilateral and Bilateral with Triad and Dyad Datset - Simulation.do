clear all
set mem 400m
set more off
set seed 1111111
set mat 800


cd "C:\Users\Paul\Desktop\DISSERTATION MAIN FOLDER\Alliance Data Folder\Simulation Datasets\"

use "prc2.dta", clear
/* STEP 3: Determine which Dyads will form alliances */ 
/* STEP 3a: Specify the parameters of the true DGP */ 
gen cons = -9.85
*gen cons = -27
gen b1=1
gen b2=2
gen b3=9


/* STEP 3b: Files to store values from below loop*/   
tempname memhold
tempfile results
postfile `memhold' rep1 rep2 rep3 rep4 rep5 rep6 using `results'
*postfile `memhold' rep1 rep2 rep3 rep4 using `results'



/* STEP 3c: Loop that determines which dyads form alliances */
/* Because the TRUE DGP has a random, u, it is possible for probit to be "Off" on a given 
draw. Therefore, we must estimate the model 500 times to determine how well probit will 
estimate the true b. */

local s 1
while `s' <=(500) {
di in white `s'

*qui {

/* Errors are distributed normally (Why? because this is MY DGP, so I made it so!) */
gen p = uniform()
gen u = ln(p/(1-p))

/* The TRUE DGP */
*gen xb = cons + b1*cap_ratio + b2*SameRegion + b3*commonthreat + u
gen xb = cons + b1*cap_ratio + b2*SameRegion + u

gen y = 0
replace y = 1 if xb > 0

di in yellow "dyad stats"
tab y if triad==.

di in yellow "triad stats"
tab y if dyad==.


/* Finally, attempt to reestimate the the parameter on "cap_ratio" using 
probit model (since errors are distributed normally) */
logit y cap_ratio SameRegion commonthreat
*logit y cap_ratio SameRegion

/* Store the estimated coefficient on cap_ratio */
capture local coef`s' = _b[cap_ratio]
capture local se`s' = _se[cap_ratio]

capture local coef2`s' = _b[SameRegion]
capture local se2`s' = _se[SameRegion]

local coef3`s' = 0
local se3`s' = 0
capture local coef3`s' = _b[commonthreat]
capture local se3`s' = _se[commonthreat]
gen se = `se3`s''
sum se
if se==0 {
drop u xb y p se
di in red "We have a problem"
continue
}

gen c = `coef3`s''
sum c
if c==0 {
drop u xb y p se c
di in red "We have a problem"
continue
}

*}
post `memhold' (`coef`s'') (`coef2`s'') (`coef3`s'') (`se`s'') (`se2`s'') (`se3`s'')
*post `memhold' (`coef`s'') (`coef2`s'') (`se`s'') (`se2`s'')
drop u xb y p se c
*drop u xb y p
local s = `s' + 1
}

/* STEP 3d: Post-loop commands to create variables that will summarize results */
postclose `memhold'
use `results' , clear






/* STEP 4: Report the mean parameter estimate from the 500 simulations */

rename rep1 b1_hat
rename rep3 se1
rename rep2 b2_hat
rename rep4 se2
*rename rep3 b3_hat
*rename rep6 se3



sum b1_hat, detail
local b_hat = r(mean)
sum se1, detail
local avg_se = r(mean)

gen Squared_Error = (b1_hat - 25)^2
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


sum b2_hat, detail
local b_hat = r(mean)
sum se2, detail
local avg_se = r(mean)

drop Squared_Error
gen Squared_Error = (b2_hat - 4)^2
sum Squared_Error
local MSE = r(mean)
local SD_EST = r(sd)

local BIAS = `b_hat' - 4
local RMSE = sqrt(`MSE')
local Over_Confidence = `SD_EST'/`avg_se'

di in white "SAME REGION SIMULATION RESULTS"
di in green "BIAS: " in yellow `BIAS'
di in green "RMSE: " in yellow `RMSE'
di in green "Over Confidence: " in yellow `Over_Confidence'




/*
sum b3_hat, detail
local b_hat = r(mean)
sum se3, detail
local avg_se = r(mean)

drop Squared_Error
gen Squared_Error = (b3_hat - 9)^2
sum Squared_Error
local MSE = r(mean)
local SD_EST = r(sd)

local BIAS = `b_hat' - 9
local RMSE = sqrt(`MSE')
local Over_Confidence = `SD_EST'/`avg_se'

di in white "COMMON THREAT SIMULATION RESULTS"
di in green "BIAS: " in yellow `BIAS'
di in green "RMSE: " in yellow `RMSE'
di in green "Over Confidence: " in yellow `Over_Confidence'
*/
