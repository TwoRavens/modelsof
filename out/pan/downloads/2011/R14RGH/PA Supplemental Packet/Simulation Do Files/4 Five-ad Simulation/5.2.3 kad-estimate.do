clear all
version 8.0
set mem 7700m
set more off
set seed 1111111
set mat 800

*cd "C:\Users\Paul\Desktop\Methods Paper Simulations\"

cd "/tmp/poastpd/"

use "Complete Kad dataset with regions.dta", clear
drop id
/* STEP 3: Determine which Dyads will form alliances */ 
/* STEP 3a: Specify the parameters of the true DGP */ 
gen bilat=0
gen trilat=0
gen quad=0
gen cinco=0
replace bilat=1 if mem2~=. & mem3==. & mem4==. & mem5==.
replace trilat=1 if mem3~=. & mem4==. & mem5==.
replace quad=1 if mem4~=. & mem5==.
replace cinco=1 if mem5~=.
gen nummem=0
replace nummem=2 if bilat==1
replace nummem=3 if trilat==1
replace nummem=4 if quad==1
replace nummem=5 if cinco==1
drop bilat trilat quad cinco
gen cons = -25
gen b1=26

*gen cons = -27
*gen b1=26

capture drop id mem1 mem2 mem3 mem4 mem5 region1 region2 region3 region4 region5

compress

save "Kad.dta", replace



/* STEP 3b: Files to store values from below loop*/   
tempname memhold
tempfile results
postfile `memhold' rep1 rep2 rep3 rep4 using `results'

/* STEP 3c: Loop that determines which dyads form alliances */
/* Because the TRUE DGP has a random, u, it is possible for probit to be "Off" on a given 
draw. Therefore, we must estimate the model 500 times to determine how well probit will 
estimate the true b. */

local coef_cap_dyad 0
local coef_cap_kad 0
local mean_squared_error1=0
local mean_squared_error2=0
local total_se_1=0
local total_se_2=0

local s 1
while `s' <=(500) {
di in white `s'

*qui{

use "Kad.dta", clear

/* Errors are distributed logistically (Why? because this is MY DGP, so I made it so!) */
gen u = ln(uniform()/(1-uniform()))

/* The TRUE DGP */
gen y = 0
replace y = 1 if (cons +b1*cap_ratio + u) > 0

drop u


local Samp_0 = 2
sum y if y==1 & nummem==2
local num_y2 = r(N)
local num2 = `num_y2'*`Samp_0'

sum y if y==1 & nummem==3
local num_y3 = r(N)
local num3 = `num_y3'*`Samp_0'

sum y if y==1 & nummem==4
local num_y4 = r(N)
local num4 = `num_y4'*`Samp_0'

sum y if y==1 & nummem==5
local num_y5 = r(N)
local num5 = `num_y5'*`Samp_0'

bysort nummem y: gen r = uniform() if y==0
*gen r = uniform() if y==0
sort nummem y r 
by nummem y: gen id_sort = _n
drop r

gen weight=0
local NUM=0


local MAX_KAD = 5
local ob = 100
local i 2
while `i' <=(`MAX_KAD') {
*di in white `i'
local choose `i'
local n_fact = exp(lnfactorial(`ob'))
local k_fact = exp(lnfactorial(`choose'))
local n_minus_k_fact = exp(lnfactorial(`ob' - `choose'))
local group_num`i' = (round(`n_fact'/(`k_fact'*`n_minus_k_fact')))
di `group_num`i''
local gnum`i' = `group_num`i''-`num_y`i''
di `gnum`i''
local pi_`i' = `num`i''/`gnum`i''
di `pi_`i''
replace weight = `pi_`i'' if nummem==`i' & id_sort<=`num`i'' & y==0
local NUM = `NUM' + `num`i''
local i = `i' + 1
}


replace weight=1 if y==1

drop id_sort

relogit y cap_ratio [pw=1/weight]

drop weight

/* Store the estimated coefficient on cap_ratio */

local coef1 = 0
capture local coef1 = _b[cap_ratio]

if `coef1'== 0 {
drop y
di in red "We have a problem with b1"
continue
}

capture local se1 = _se[cap_ratio]


keep if y==1

/* Prepare to Estimate k-adic data with dyadic dataset*/

/* STEP 3a: Assign each pair of countries in a triad a dyadic code */ 
gen dyad1 = (mem1*1000)+mem2
gen dyad2 = (mem1*1000)+mem3
gen dyad3 = (mem1*1000)+mem4
gen dyad4 = (mem1*1000)+mem5
gen dyad5 = (mem2*1000)+mem3
gen dyad6 = (mem2*1000)+mem4
gen dyad7 = (mem2*1000)+mem5
gen dyad8 = (mem3*1000)+mem4
gen dyad9 = (mem3*1000)+mem5
gen dyad10 = (mem4*1000)+mem5


/* Prepare dependent variable to be incorporated into dyadic dataset */
rename y y1
gen y2 = y1
gen y3 = y1
gen y4 = y1
gen y5 = y1
gen y6 = y1
gen y7 = y1
gen y8 = y1
gen y9 = y1
gen y10 = y1
stack dyad1 y1 dyad2  y2 dyad3 y3 dyad4 y4 dyad5  y5 dyad6 y6 dyad7 y7 dyad8  y8 dyad9 y9 dyad10 y10, into(dyad y)
drop if y~=1
duplicates drop dyad y, force
gsort -y dyad
duplicates drop dyad, force
sort dyad
save "practice_y.dta", replace

use "dyad for kad2.dta", clear
sort dyad
merge dyad using "practice_y.dta", nokeep keep(y)
drop _merge
duplicates drop dyad, force
replace y=0 if y==.


logit y cap_ratio

/* Store the estimated coefficient on cap_ratio */

local coef2 = 0
capture local coef2 = _b[cap_ratio]

if `coef2'== 0 {
drop y
di in red "We have a problem with b1"
continue
}


capture local se2 = _se[cap_ratio]

local squared_error1 = (`coef1' - 26)^2
local squared_error2 = (`coef2' - 26)^2

local mean_squared_error1= (`mean_squared_error1' + `squared_error1')/`s'
local mean_squared_error2= (`mean_squared_error2' + `squared_error2')/`s' 

*}


di "Iteration: " `s'
local coef_cap_kad = `coef_cap_kad' + `coef1'
di "K-ad coefficient Expected Value: " `coef_cap_kad'/`s'

local coef_cap_dyad = `coef_cap_dyad' + `coef2'
di "Dyad coefficient Expected Value: " `coef_cap_dyad'/`s'

di "Kad Mean Squared Error: " `mean_squared_error1'
di "Dyad Mean Squared Error: " `mean_squared_error2'

local total_se_1 = `total_se_1' + `se1'
local total_se_2 = `total_se_2' + `se2'

local avg_se_1 = `total_se_1'/`s'
local avg_se_2 = `total_se_2'/`s'

local SD_EST1 = sqrt(`mean_squared_error1')
local SD_EST2 = sqrt(`mean_squared_error2')

local Over_Confidence1 = `SD_EST1'/`avg_se_1'
local Over_Confidence2 = `SD_EST2'/`avg_se_2'

di "Kad Over Confidence: " `Over_Confidence1'
di "Dyad Over Confidence: " `Over_Confidence2'


post `memhold' (`coef1') (`se1') (`coef2') (`se2')


drop y
local s = `s' + 1
}

/* STEP 3d: Post-loop commands to create variables that will summarize results */
postclose `memhold'
use `results' , clear






/* STEP 4: Report the mean parameter estimate from the 500 simulations */
rename rep1 b_hat
rename rep2 se

sum b_hat, detail
local b_hat = r(mean)
sum se, detail
local avg_se = r(mean)

gen Squared_Error = (b_hat - 26)^2
sum Squared_Error
local MSE = r(mean)
local SD_EST = r(sd)

local BIAS = `b_hat' - 25
local RMSE = sqrt(`MSE')
local Over_Confidence = `SD_EST'/`avg_se'

di "BIAS: " `BIAS'
di "RMSE: " `RMSE'
di "Over Confidence: " `Over_Confidence'

save "5ad_Results_finished", save
