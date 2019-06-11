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
gen cons = -9.85
*gen cons = -26
gen b1=1
gen b2=2
gen b3=9

local coef_cap_dyad 0
local coef_cap_kad 0

save "Sampling Practice", replace

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

*use "Sampling Practice", clear

/* Errors are distributed normally (Why? because this is MY DGP, so I made it so!) */
gen p = uniform()
gen u = ln(p/(1-p))

/* The TRUE DGP */
gen xb = cons + b1*cap_ratio + b2*SameRegion + b3*commonthreat + u
*gen xb = cons + b1*cap_ratio + b2*SameRegion + u


gen y = 0
replace y = 1 if xb > 0

di in yellow "dyad stats"
tab y if triad==.

di in yellow "triad stats"
tab y if dyad==.


*** Step 1: Specify the number of zeros to sample (in terms of a multiple of the 1's) For example, if you want 5 times as many zeros as 1's, enter 5 
local Samp_0 = 2

* These Commands Tell me that I need a sample of Y=0 dyads that is size `num2' 
sum y if y==1 & nummem==2
local num_y2 = r(N)
local num2 = `num_y2'*`Samp_0'

* This command says that I will want to take a sample Y=0 dyads that is size `num2_strata' from each quartile of cap_ratio 
local num2_strata = `num2'*(0.25)

* These commands identify the values that mark the edges of cap_ratio quartiles for the Y=0 dyads
sum cap_ratio if y==0 & nummem==2, detail
local cap_mark21=r(min)
di `cap_mark21'
local cap_mark22 = r(p25)
di `cap_mark22'
local cap_mark23 = r(p50)
di `cap_mark23'
local cap_mark24 = r(p75)
di `cap_mark24'
local cap_mark25 = r(max)
di `cap_mark25'

* These Commands Tell me that I need a sample of Y=0 triads that is size `num3' 
sum y if y==1 & nummem==3
local num_y3 = r(N)
local num3 = `num_y3'*`Samp_0'

* This command splits says that I will want to take a sample Y=0 triads that is size `num3_strata' from each quartile of cap_ratio 
local num3_strata = `num3'*(0.25)

* These commands identify the values that mark the edges of cap_ratio quartiles for the Y=0 triads
sum cap_ratio if y==0 & nummem==3, detail
local cap_mark31=r(min)
di `cap_mark31'
local cap_mark32 = r(p25)
di `cap_mark32'
local cap_mark33 = r(p50)
di `cap_mark33'
local cap_mark34 = r(p75)
di `cap_mark34'
local cap_mark35 = r(max)
di `cap_mark35'

* Variables I will Need
gen SAMP = 0
gen weight=0
local MAX_KAD = 3
local i 2


while `i' <=(`MAX_KAD') {
di in white `i'
local j 1
while `j' <=(4) {
di in red `j'
local h = `j' + 1
* Assign random numbers to observations in strata cap_mark`i'`j'
gen STRATA = 0
replace STRATA = 1  if y==0 & nummem==`i' & (cap_ratio>=`cap_mark`i'`j'') & (cap_ratio<=`cap_mark`i'`h'')
sum STRATA if STRATA==1
local n = r(N)
di `n'
gen r1 = uniform() if STRATA==1

* Take a sample of observations from strata cap_mark`i'`j' that is equal to size `num`i'_strata'
sort r1
gen id_sort = 0
bysort STRATA: replace id_sort = _n
replace SAMP = 1 if STRATA==1 & id_sort>0 & (id_sort<=`num`i'_strata')


* Compute the weight that should be assigned to this sample
sum SAMP if SAMP==1 & STRATA==1
local num = r(N)
di `num'
local pi_`i'`j' = `num'*(1/`n')
di `pi_`i'`j''
replace weight = (`pi_`i'`j'') if SAMP==1 & STRATA==1

drop id_sort
drop r1
drop STRATA
local j = `j' + 1
}
local i = `i' + 1
}

replace SAMP=1 if y==1
replace weight=1 if y==1

*capture relogit y cap_ratio SameRegion commonthreat

capture relogit y cap_ratio SameRegion commonthreat  [pw=1/weight] if SAMP==1

*relogit y cap_ratio SameRegion [pw=1/weight] if SAMP==1

/* Store the estimated coefficient on cap_ratio */
capture local coef`s' = _b[cap_ratio]
capture local se`s' = _se[cap_ratio]

capture local coef2`s' = _b[SameRegion]
capture local se2`s' = _se[SameRegion]


local se3`s' = 0
capture local coef3`s' = _b[commonthreat]
capture local se3`s' = _se[commonthreat]

gen se = `se3`s''
sum se
if se==0 {
drop u xb y p se SAMP weight
di in red "We have a problem"
continue
}

gen c = `coef3`s''
sum c
if c==0 {
drop u xb y p se c SAMP weight
di in red "We have a problem"
continue
}



di "Iteration: " `s'
local coef_cap_kad = `coef_cap_kad' + `coef`s''
di "K-ad coefficient: " `coef_cap_kad'/`s'


*}
post `memhold' (`coef`s'') (`coef2`s'') (`coef3`s'') (`se`s'') (`se2`s'') (`se3`s'')
*post `memhold' (`coef`s'') (`coef2`s'') (`se`s'') (`se2`s'')
drop u xb y p se c SAMP weight
*drop u xb y p SAMP weight
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
