*To Replicate Table 1 in HSB, starting with the naive spatial model
pr drop _all
cd C:\Users\jch61\Desktop\Summer_Work_2014\Boehmke_etal\FINAL_SUBMISSION\PA_REPLICATION_FILES\

***********************
*Likelihood Evaluator  
***********************                                                         
program define splag_ll_dur

args lnf mu rho sigma2
qui replace `lnf'= ln(ones - `rho'*EIGS1) + ln(normalden($ML_y1-`rho'*SL1-`mu', 0, sqrt(`sigma2')))
end


**********************
*Open Data For Weights
**********************
use "invdist_W_rs.dta", clear
*use "rivalry_W_rs.dta",clear
*use "alliance_W_rs.dta",clear

qui sum var1
global nobs = r(N)
mkmat var1-var$nobs, matrix(W)
matrix I_n = I($nobs)
matrix eigenvalues eig1 imaginaryv = W
matrix eig2 = eig1'
matrix ones=J($nobs,1,1)


drop _all

**************************
*Open Data for Regression
**************************
drop _all
use "WWI_entry_days.dta", clear

global Y ln_days
global X capabilities trade democracy

mkmat $Y, matrix(Y)
matrix SL = W*Y
svmat SL, n(SL)
svmat eig2, n(EIGS)
svmat ones, n(ones)


************************
*Produce starting values
************************ 

stset days
streg $X, dist(lognormal) time
matrix stregbp=e(b)
local col = colsof(stregbp)
matrix stregb=stregbp[1,1..`col'-1] 
matrix coleq stregb = mu
local stregp=exp(stregbp[1,`col'])


***************************
*Estimate spatial lag model
***************************

ml model lf splag_ll_dur (mu: $Y=$X) (rho:) (sigma2:)
ml init stregb
ml init rho:_cons=0
ml init sigma2:_cons=`stregp'
ml max

*Estimate Non-spatial Duration Model	
gen enter = 1 - censored
stset days, fail(enter)
streg $X, dist(lognormal) time
