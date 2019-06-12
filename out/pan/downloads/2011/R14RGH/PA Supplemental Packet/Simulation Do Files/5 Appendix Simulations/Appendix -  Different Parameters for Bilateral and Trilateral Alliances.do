clear all
set mem 400m
set more off
set seed 1111111
set mat 800

cd "C:\Users\Paul\Desktop\DISSERTATION MAIN FOLDER\Alliance Data Folder\Simulation Datasets\"

use "prc2.dta", clear
/* STEP 3: Determine which Dyads will form alliances */ 
/* STEP 3a: Specify the parameters of the true DGP */ 
gen bilat=0
gen trilat=0
replace bilat=1 if dyad~=.
replace trilat=1 if triad~=.
gen bi_cap_ratio = bilat*cap_ratio
gen tri_cap_ratio = trilat*cap_ratio
gen cons = -12
gen b1=10
gen b2=5

*b1=7
*b2=.1

/* STEP 3b: Files to store values from below loop*/   
tempname memhold
tempfile results
postfile `memhold' rep1 rep2 rep3 rep4 using `results'



/* STEP 3c: Loop that determines which dyads form alliances */
/* Because the TRUE DGP has a random, u, it is possible for probit to be "Off" on a given 
draw. Therefore, we must estimate the model 500 times to determine how well probit will 
estimate the true b. */

local s 1
while `s' <=(500) {
di in white `s'


/* Errors are distributed logistically (Why? because this is MY DGP, so I made it so!) */
gen p = uniform()
gen u = ln(p/(1-p))

/* The TRUE DGP */
gen xb = cons +b1*cap_ratio*bilat+b2*cap_ratio*trilat+ u



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

/* Finally, attempt to reestimate the the parameter on "cap_ratio" using 
logit model (since errors have a logistic distribution) */
capture logit y bi_cap_ratio tri_cap_ratio

/* Store the estimated coefficient on cap_ratio */
local coef`s'=0
capture local coef`s' = _b[bi_cap_ratio]
capture local se`s' = _se[bi_cap_ratio]

gen c1 = `coef`s''
qui sum c1
if c1==0 {
drop u prob xb y p c1
di in red "We have a problem with b1"
continue
}

local coef2`s' = 0
capture local coef2`s' = _b[tri_cap_ratio]
*capture scalar c2 = _b[tri_cap_ratio]
capture local se2`s' = _se[tri_cap_ratio]


gen c = `coef2`s''
qui sum c
if c==0 {
drop u prob xb y p c1 c
di in red "We have a problem with b2"
continue
}

post `memhold' (`coef`s'') (`coef2`s'') (`se`s'') (`se2`s'')

drop u prob xb y p c1 c
*scalar drop c2
local s = `s' + 1
}

/* STEP 3d: Post-loop commands to create variables that will summarize results */
postclose `memhold'
use `results' , clear






/* STEP 4: Report the mean parameter estimate from the 500 simulations */
rename rep1 b_hat
rename rep3 se

sum b_hat, detail
local b_hat = r(mean)
sum se, detail
local avg_se = r(mean)

gen Squared_Error = (b_hat - 10)^2
sum Squared_Error
local MSE = r(mean)
local SD_EST = r(sd)

local BIAS = `b_hat' - 10
local RMSE = sqrt(`MSE')
local Over_Confidence = `SD_EST'/`avg_se'

di "BIAS: " `BIAS'
di "RMSE: " `RMSE'
di "Over Confidence: " `Over_Confidence'


rename rep2 b2_hat
rename rep4 se2

sum b2_hat, detail
local b_hat = r(mean)
sum se2, detail
local avg_se = r(mean)

drop Squared_Error
gen Squared_Error = (b_hat - 5)^2
sum Squared_Error
local MSE = r(mean)
local SD_EST = r(sd)

local BIAS = `b_hat' - 5
local RMSE = sqrt(`MSE')
local Over_Confidence = `SD_EST'/`avg_se'

di "BIAS: " `BIAS'
di "RMSE: " `RMSE'
di "Over Confidence: " `Over_Confidence'
