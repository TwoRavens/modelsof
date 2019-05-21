***************************************************
*                                                 * 
* Does Immigration Induce Terrorism?              *
*                                                 * 
* Replication Instructions: October 29, 2015      *
*                                                 * 
* Vincenzo Bove and Tobias Boehmelt               *
*                                                 * 
* Address correspondence to: tbohmelt@essex.ac.uk *
*                                                 * 
***************************************************

set matsize 8000

***** Change to Working Directory *****

cd  "C:\Users\tbohmelt\Desktop\" 
use "Data Set I.dta", clear 

*****************************
* Data Setup - Spatial Lags *
*****************************

spatwmat using "Contiguity Matrix.dta", name(W)standardize
spatgsa LDV1, w(W) m twotail
splagvar LDV1, wname(W) wfrom(Stata)
rename wy_LDV1 wy_contiguity

spatwmat using  "Inv_Distance Matrix.dta", name(W)standardize
spatgsa LDV1, w(W) m twotail
splagvar LDV1, wname(W) wfrom(Stata)
rename wy_LDV1 wy_invdistance

spatwmat using "Matrix.dta", name(W)standardize
spatgsa LDV1, w(W) m twotail
splagvar LDV1, wname(W) wfrom(Stata)
rename wy_LDV1 wy_migrants

**********************************
* Descriptive Overview - Table 1 *
**********************************

kdensity ln_FGTD
sum ln_FGTD geddes1-geddes5 logGNI logpop logarea GINI Durable AggSF ColdWar ucdp_type2 ucdp_type3 log_iMigrantsBA LDV1
sum wy_contiguity wy_invdistance wy_migrants

*********************************************
* Model Estimation 1 - Contiguity - Table 2 *
*********************************************

sort year ccode

clear
pr drop _all
set matsize 8000
set more off
version 9

*  Likelihood Evaluator *                                                          

program define splag_ll

args lnf mu rho sigma
tempvar A rSL
gen `A'= ones - `rho'*EIGS1
gen `rSL'=`rho'*SL1
qui replace `lnf'= ln(`A') + ln(normden($ML_y1-`rSL'-`mu', 0, `sigma'))
end

global nobs = 3919

* Open Data For Weights *

clear
spatwmat using "Contiguity Matrix.dta", name(W) standardize
matrix eigenvalues eig1 imaginaryv = W
matrix eig2 = eig1'
matrix ones=J($nobs,1,1)

* Open Data for Regression *

drop _all

use "Data Set I.dta", clear

global Y ln_FGTD
global X geddes1-geddes5 logGNI logpop logarea GINI Durable AggSF ColdWar ucdp_type2 ucdp_type3 log_iMigrantsBA LDV1 country_fe2-country_fe145 year_fe2-year_fe31
global Z LDV1
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL = W*Z
svmat SL, n(SL)
svmat eig2, n(EIGS)
svmat ones, n(ones)

* Produce Starting Values * 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model *

ml model lf splag_ll (mu: $Y=$X) (rho:) (sigma:), technique(dfp) vce(oim)
ml init OLSb, skip
ml init rho:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max, difficult ltolerance(1e-8) tolerance(1e-8)

*******************************************
* Model Estimation 2 - Distance - Table 2 *
*******************************************

sort year ccode

clear
pr drop _all
set matsize 8000
set more off
version 9

*  Likelihood Evaluator *                                                          

program define splag_ll

args lnf mu rho sigma
tempvar A rSL
gen `A'= ones - `rho'*EIGS1
gen `rSL'=`rho'*SL1
qui replace `lnf'= ln(`A') + ln(normden($ML_y1-`rSL'-`mu', 0, `sigma'))
end

global nobs = 3919

* Open Data For Weights *

clear
spatwmat using "Inv_Distance Matrix.dta", name(W) standardize
matrix eigenvalues eig1 imaginaryv = W
matrix eig2 = eig1'
matrix ones=J($nobs,1,1)

* Open Data for Regression *

drop _all

use "Data Set I.dta", clear

global Y ln_FGTD
global X geddes1-geddes5 logGNI logpop logarea GINI Durable AggSF ColdWar ucdp_type2 ucdp_type3 log_iMigrantsBA LDV1 country_fe2-country_fe145 year_fe2-year_fe31
global Z LDV1
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL = W*Z
svmat SL, n(SL)
svmat eig2, n(EIGS)
svmat ones, n(ones)

* Produce Starting Values * 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model *

ml model lf splag_ll (mu: $Y=$X) (rho:) (sigma:), technique(dfp) vce(oim)
ml init OLSb, skip
ml init rho:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max, difficult ltolerance(1e-8) tolerance(1e-8)

****************************************************
* Model Estimation 3 - Migration Inflows - Table 2 *
****************************************************

sort year ccode

clear
pr drop _all
set matsize 8000
set more off
version 9

*  Likelihood Evaluator *                                                          

program define splag_ll

args lnf mu rho sigma
tempvar A rSL
gen `A'= ones - `rho'*EIGS1
gen `rSL'=`rho'*SL1
qui replace `lnf'= ln(`A') + ln(normden($ML_y1-`rSL'-`mu', 0, `sigma'))
end

global nobs = 3919

* Open Data For Weights *

clear
spatwmat using "Matrix.dta", name(W) standardize
matrix eigenvalues eig1 imaginaryv = W
matrix eig2 = eig1'
matrix ones=J($nobs,1,1)

* Open Data for Regression *

drop _all

use "Data Set I.dta", clear

global Y ln_FGTD
global X geddes1-geddes5 logGNI logpop logarea GINI Durable AggSF ColdWar ucdp_type2 ucdp_type3 log_iMigrantsBA LDV1 country_fe2-country_fe145 year_fe2-year_fe31
global Z LDV1
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL = W*Z
svmat SL, n(SL)
svmat eig2, n(EIGS)
svmat ones, n(ones)

* Produce Starting Values * 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model *

ml model lf splag_ll (mu: $Y=$X) (rho:) (sigma:), technique(dfp) vce(oim)
ml init OLSb, skip
ml init rho:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max, difficult ltolerance(1e-8) tolerance(1e-8)

**************************************************************
* m-STAR Model 1 - Migrant Inflows and Contiguity  - Table 3 *
**************************************************************

clear
pr drop _all
set more off
set matsize 8000

*  Likelihood Evaluator *                                                          

program define splag_ll

args lnf mu rho1 rho2 sigma
tempvar A rSL1 rSL2 
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
scalar p1 = `rho1'
scalar p2 = `rho2'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix IpW = I_n - p1W1 - p2W2
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`mu', 0, `sigma'))
end

* Open Data For Weights *

spatwmat using "Matrix.dta", name(W1) standardize 

spatwmat using "Contiguity Matrix.dta", name(W2) standardize 

* Open Data for Regression *

drop _all
use "Data Set I.dta", clear
global nobs = 3919
matrix I_n = I($nobs)
global Y ln_FGTD
global X geddes1-geddes5 logGNI logpop logarea GINI Durable AggSF ColdWar ucdp_type2 ucdp_type3 log_iMigrantsBA LDV1 country_fe2-country_fe145 year_fe2-year_fe31
global Z LDV1
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)

* Produce Starting Values * 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model *

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (sigma:)
ml init OLSb, skip
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

***********************************************************
* m-STAR Model 2 - Migrant Inflows and Distance - Table 3 *
***********************************************************

clear
pr drop _all
set more off
set matsize 8000

*  Likelihood Evaluator *                                                          

program define splag_ll

args lnf mu rho1 rho2 sigma
tempvar A rSL1 rSL2 
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
scalar p1 = `rho1'
scalar p2 = `rho2'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix IpW = I_n - p1W1 - p2W2
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`mu', 0, `sigma'))
end

* Open Data For Weights *

spatwmat using "Matrix.dta", name(W1) standardize 

spatwmat using "Inv_Distance Matrix.dta", name(W2) standardize 

* Open Data for Regression *

drop _all
use "Data Set I.dta", clear
global nobs = 3919
matrix I_n = I($nobs)
global Y ln_FGTD
global X geddes1-geddes5 logGNI logpop logarea GINI Durable AggSF ColdWar ucdp_type2 ucdp_type3 log_iMigrantsBA LDV1 country_fe2-country_fe145 year_fe2-year_fe31
global Z LDV1
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)

* Produce Starting Values * 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model *

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (sigma:)
ml init OLSb, skip
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

************
* Figure 1 *
************

use "Graph 1.dta", clear

twoway (scatter var5 estimate if LDV==0) (rcap lb ub var5 if LDV==0, horizontal msize(zero)) (scatter var5 estimate if LDV!=0) (rcap lb ub var5 if LDV!=0, horizontal msize(zero)), scheme(lean1) aspectratio(1) 
