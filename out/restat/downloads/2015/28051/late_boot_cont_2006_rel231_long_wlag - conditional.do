
clear all
set more off
cd "set here the path folder where the data are stored and output should be saved"

local maxiter=400
set obs `maxiter'
gen numbM=.
gen denombM=.
gen lateb=.



save bst_results_cont_2006_rel231_long_wlag.dta, replace

/*BOOTSTRAP - LOOP*/

**We compute the empirical distribution of the estimators whose standard deviation gives us the SEs for each estimate
local j1 = 1

while (`j1'<=`maxiter'){
	use cont_w1w2_2006_w2rel231_w1rel231_long, replace
	bsample
biprobit (worker1=ivphealth age1 educ sisters lworker1) (daily=ivphealth age1 educ sisters lworker1), rob
predict xbhat, xb1
predict xghat, xb2
matrix coef=e(b)
svmat coef, name(b)
replace b1=b1[_n-1] in 2/l
replace b7=b7[_n-1] in 2/l
replace b9=b9[_n-1] in 2/l
replace b8=b8[_n-1] in 2/l
replace b6=b6[_n-1] in 2/l
gen x1b=xbhat-b1*ivphealth+b1 
gen x2b=xbhat-b1*ivphealth 
gen x1g=xghat-b7*ivphealth+b7
gen x2g=xghat-b7*ivphealth 


gen df1b=normal(x1b) 
gen df2b=normal(x2b) 
gen df1g=normal(x1g) 
gen df2g=normal(x2g) 
gen num=df1b-df2b 
gen denom=df1g-df2g 


  egen numibM =mean(num)
 egen denibM =mean(denom)

 gen lateb=numibM/denibM
	local M4= numibM[1]
	local M5= denibM[1]
	local M6= lateb[1]


use bst_results_cont_2006_rel231_long_wlag.dta, clear


replace numbM=`M4' if _n==`j1' 
replace denombM=`M5' if _n==`j1' 
replace lateb=`M6' if _n==`j1' 


save bst_results_cont_2006_rel231_long_wlag.dta, replace
local j1=`j1'+1
disp "Number of Iterations"
disp `j1'
}


sum

 
sum numbM
local numbMst=r(sd)
sum denombM
local denombMst=r(sd)
sum lateb
local latebMst=r(sd)
_pctile lateb, p(0.5, 2.5, 5, 95, 97.5, 99.5)
local plateb1=r(r1)
local plateb2=r(r2)
local plateb3=r(r3)
local plateb4=r(r4)
local plateb5=r(r5)
local plateb6=r(r6)


use cont_w1w2_2006_w2rel231_w1rel231_long, replace
	**We compute the estimators from the real sample

biprobit (worker1=ivphealth age1 educ sisters lworker1) (daily=ivphealth age1 educ sisters lworker1), rob
predict xbhat, xb1
predict xghat, xb2
matrix coef=e(b)
svmat coef, name(b)
replace b1=b1[_n-1] in 2/l
replace b7=b7[_n-1] in 2/l
replace b9=b9[_n-1] in 2/l
replace b8=b8[_n-1] in 2/l
replace b6=b6[_n-1] in 2/l

gen x1b=xbhat-b1*ivphealth+b1 
gen x2b=xbhat-b1*ivphealth 
gen x1g=xghat-b7*ivphealth+b7
gen x2g=xghat-b7*ivphealth


gen df1b=normal(x1b) 
gen df2b=normal(x2b) 
gen df1g=normal(x1g) 
gen df2g=normal(x2g) 
gen num=df1b-df2b 
gen denom=df1g-df2g 




      egen numibM =mean(num)
      egen denibM =mean(denom)
      gen lateb=numibM/denibM


 **These are the results for the estimates
sum numibM denibM lateb



gen numbMt=numibM/`numbMst'
gen numbMpv=2*(1-normal(abs(numbMt)))
gen denombMt=denibM/`denombMst'
gen denombMpv=2*(1-normal(abs(denombMt)))

gen latebMt=lateb/`latebMst'
gen latebMpv=2*(1-normal(abs(latebMt)))


gen sd4=`numbMst'
gen sd5=`denombMst'
gen sd6=`latebMst'
egen plateb05=mean(`plateb1')
egen plateb25=mean(`plateb2')
egen plateb5=mean(`plateb3')
egen plateb95=mean(`plateb4')
egen plateb975=mean(`plateb5')
egen plateb995=mean(`plateb6')


**RESULTS
**For the SEs of the numerator and the denominator you need to look at sd4 and sd5 respectively
**For the 95 percent CI of the estimator of LATE you need to look into plate25 and plate975
sum numbMt numbMpv numibM sd4
sum denombMt denombMpv denibM sd5
sum lateb plateb05 plateb25 plateb5 plateb95 plateb975 plateb995 
sum latebMt latebMpv lateb sd6





