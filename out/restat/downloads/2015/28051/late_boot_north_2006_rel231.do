
clear all
set more off

cd "set here the path folder where the data are stored and output should be saved"

local maxiter=400
set obs `maxiter'
gen numM=.
gen denomM=.
gen late=.

save bst_results_north_2006_rel231.dta, replace

/*BOOTSTRAP - LOOP*/

**We compute the empirical distribution of the estimators whose standard deviation gives us the SEs for each estimate
local j1 = 1

while (`j1'<=`maxiter'){
	use north_w1w2_2006_w2rel231_w1rel231, replace
	bsample
      **propensity scores for the instrument z
      probit ivphealth age1 educ sisters,rob
     

      predict prs1_2
      sum prs1_2 
      gen numi1_2=((worker1*ivphealth)/prs1_2)-((worker1*(1-ivphealth))/(1-prs1_2)) 
      sum numi1_2
      gen denomi1_2=((daily*ivphealth)/prs1_2)-((daily*(1-ivphealth))/(1-prs1_2)) 
      sum denomi1_2
      egen numi1_2M =mean(numi1_2)
      egen denomi1_1M =mean(denomi1_2)
      gen late=numi1_2M/denomi1_1M



	local M1= numi1_2M[1]
	local M2= denomi1_1M[1]
	local M3= late[1]



use bst_results_north_2006_rel231.dta, clear
replace numM=`M1' if _n==`j1' 
replace denomM=`M2' if _n==`j1' 
replace late=`M3' if _n==`j1' 



save bst_results_north_2006_rel231.dta, replace
local j1=`j1'+1
disp "Number of Iterations"
disp `j1'
}
sum
sum numM
local numMst=r(sd)
sum denomM
local denomMst=r(sd) 
sum late
_pctile late, p(0.5, 2.5, 5, 95, 97.5, 99.5)
local plate1=r(r1)
local plate2=r(r2)
local plate3=r(r3)
local plate4=r(r4)
local plate5=r(r5)
local plate6=r(r6)
 

use north_w1w2_2006_w2rel231_w1rel231, replace
	**We compute the estimators from the real sample
      **propensity scores for the instrument z
       probit ivphealth age1 educ sisters ,rob

predict prs1_2
      sum prs1_2 
      gen numi1_2=((worker1*ivphealth)/prs1_2)-((worker1*(1-ivphealth))/(1-prs1_2)) 
      sum numi1_2
      gen denomi1_2=((daily*ivphealth)/prs1_2)-((daily*(1-ivphealth))/(1-prs1_2)) 
      sum denomi1_2
      egen numi1_2M =mean(numi1_2)
      egen denomi1_1M =mean(denomi1_2)
      gen late=numi1_2M/denomi1_1M


sum numi1_2M denomi1_1M late


gen numMt=numi1_2M/`numMst'
gen numMpv=2*(1-normal(abs(numMt)))
gen denomMt=denomi1_1M/`denomMst'
gen denomMpv=2*(1-normal(abs(denomMt)))



gen sd1=`numMst'
gen sd2=`denomMst'
egen plate05=mean(`plate1')
egen plate25=mean(`plate2')
egen plate5=mean(`plate3')
egen plate95=mean(`plate4')
egen plate975=mean(`plate5')
egen plate995=mean(`plate6')


**RESULTS
**For the SEs of the numerator and the denominator you need to look at sd1 and sd2 respectively
**For the 95 percent CI of the estimator of LATE you need to look into plate25 and plate975
sum numMt numMpv numi1_2M  sd1
sum denomMt denomMpv denomi1_1M sd2
sum late plate05 plate25 plate5 plate95 plate975 plate995













