clear all
set mem 400m
set more off
set seed 1111111
set mat 800

cd "C:\Users\Paul\Desktop\DISSERTATION MAIN FOLDER\Alliance Data Folder\Simulation Datasets\"

use "prc2.dta", clear
gen nummem=2 if triad==.
replace nummem=3 if dyad==.

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

save "prc2_test.dta", replace

/* STEP 3b: Files to store values from below loop*/   
tempname memhold
tempfile results
postfile `memhold' rep1 rep2 rep3 rep4 using `results'

local coef_cap_kad = 0

/* STEP 3c: Loop that determines which dyads form alliances */
/* Because the TRUE DGP has a random, u, it is possible for probit to be "Off" on a given 
draw. Therefore, we must estimate the model 500 times to determine how well probit will 
estimate the true b. */

local s 1
while `s' <=(500) {
di in white `s'

*qui {

use "prc2_test.dta", clear

/* Errors are distributed normally (Why? because this is MY DGP, so I made it so!) */
gen p = uniform()
gen u = ln(p/(1-p))

/* The TRUE DGP */
gen xb = cons +b1*cap_ratio*bilat+b2*cap_ratio*trilat+ u

gen y = 0
replace y = 1 if xb > 0

qui {
di in yellow "dyad stats"
tab y if triad==.

di in yellow "triad stats"
tab y if dyad==.
*}

*** Step 1: Specify the number of zeros to sample (in terms of a multiple of the 1's) For example, if you want 5 times as many zeros as 1's, enter 5 
local Samp_0 = 10
sum y if y==1 & nummem==2
local num_y2 = r(N)
local num2 = `num_y2'*`Samp_0'

sum y if y==1 & nummem==3
local num_y3 = r(N)
local num3 = `num_y3'*`Samp_0'

* Variables I will Need
gen weight=0
local MAX_KAD = 3
local i 2
while `i' <=(`MAX_KAD') {
*di in white `i'
local j 1
sum y if y==0 & nummem==`i'
local n = r(N)
*di `n'
sample `num`i''  if y==0 & nummem==`i', count
sum y  if y==0 & nummem==`i'
local num = r(N)
*di `num'
local pi_`i' = `num'*(1/`n')
*di `pi_`i''
replace weight = (`pi_`i'')  if y==0 & nummem==`i'
local i = `i' + 1
}
replace weight=1 if y==1

capture relogit y bi_cap_ratio tri_cap_ratio [pw=1/weight]



/* Store the estimated coefficient on cap_ratio */
local coef`s'=0
local se`s' = 0
capture local coef`s' = _b[bi_cap_ratio]
capture local se`s' = _se[bi_cap_ratio]

gen c1 = `coef`s''
qui sum c1
if c1==0 {
drop u xb y p c1 weight
di in red "We have a problem with b1"
continue
}

gen se1 = `se`s''
*qui sum se2
if se1==0 {
drop u xb y p c1 weight se1
di in red "We have a problem with se1"
continue
}


local coef2`s' = 0
local se2`s' = 0
capture local coef2`s' = _b[tri_cap_ratio]
*capture scalar c2 = _b[tri_cap_ratio]
capture local se2`s' = _se[tri_cap_ratio]


gen c = `coef2`s''
qui sum c
if c==0 {
drop u xb y p c1 c weight se1
di in red "We have a problem with b2"
continue
}

gen se2 = `se2`s''
*qui sum se2
if se2==0 {
drop u xb y p c1 weight se2 se1
di in red "We have a problem with se2"
continue
}


** Brace to "Quiet"
}

di "Iteration: " `s'
local coef_cap_kad = `coef_cap_kad' + `coef`s''
di in white "K-ad coefficient on bi_lat is " in yellow `coef_cap_kad'/`s'

post `memhold' (`coef`s'') (`coef2`s'') (`se`s'') (`se2`s'')

drop u xb y p c1 c weight se2 se1
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
