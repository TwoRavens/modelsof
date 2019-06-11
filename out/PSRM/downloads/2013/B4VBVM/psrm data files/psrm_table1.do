clear
pr drop _all
set more off
set matsize 800


***********************
*Model 1 adjacency cent_compXadjacency  
*********************** 

***********************
*Likelihood Evaluator  
***********************                                                         

program define splag_llg

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


**********************
*Open Data For Weights
**********************

/*This drops cells in the weighting matrix corresponding to cases
that have missing data on any of the variables in the models*/

spatwmat using "C:\Data\spatial_loc_gov\adjacency_w_s.dta", name(W1) standardize
spatwmat using "C:\Data\spatial_loc_gov\cent_compXadjacency_row_av_w_s.dta", name(W2)


**************************
*Open Data for Regression
**************************
drop _all
use "C:\Data\spatial_loc_gov\turnover2 26 February 2009.dta", clear
keep if check6 == 1
global nobs = 734
matrix I_n = I($nobs)
global Y sp_per 
global X  counciltax conservative labour libdem rsgpercap all_gbp q1claimrate d_1-d_147
mkmat $Y, matrix(Y)
matrix SL1 = W1*Y
svmat SL1, n(SL1)
matrix SL2 = W2*Y
svmat SL2, n(SL2)


************************
*Produce starting values
************************ 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

***************************
*Estimate spatial lag model
***************************

ml model lf splag_llg (mu: $Y=$X) (rho1:) (rho2:)(sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init sigma:_cons=`OLSsigma'
*ml trace on
ml max



***********************
*Model 2 samemet cent_compXsamemet
*********************** 

***********************
*Likelihood Evaluator  
***********************                                                         

program define splag_llh

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


**********************
*Open Data For Weights
**********************

/*This drops cells in the weighting matrix corresponding to cases
that have missing data on any of the variables in the models*/

spatwmat using "C:\Data\spatial_loc_gov\samemet_w_s.dta", name(W1) standardize
spatwmat using "C:\Data\spatial_loc_gov\cent_compXsamemet_row_av_w_s.dta", name(W2)


**************************
*Open Data for Regression
**************************
drop _all
use "C:\Data\spatial_loc_gov\turnover2 26 February 2009.dta", clear
keep if check6 == 1
global nobs = 734
matrix I_n = I($nobs)
global Y sp_per 
global X  counciltax conservative labour libdem rsgpercap all_gbp q1claimrate d_1-d_147
mkmat $Y, matrix(Y)
matrix SL1 = W1*Y
svmat SL1, n(SL1)
matrix SL2 = W2*Y
svmat SL2, n(SL2)


************************
*Produce starting values
************************ 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

***************************
*Estimate spatial lag model
***************************

ml model lf splag_llh (mu: $Y=$X) (rho1:) (rho2:)(sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init sigma:_cons=`OLSsigma'
*ml trace on
ml max


***********************
*Model 3 sameregion cent_compXsameregion
*********************** 

***********************
*Likelihood Evaluator  
***********************                                                         

program define splag_lli

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


**********************
*Open Data For Weights
**********************

/*This drops cells in the weighting matrix corresponding to cases
that have missing data on any of the variables in the models*/

spatwmat using "C:\Data\spatial_loc_gov\sameregion_w_s.dta", name(W1) standardize
spatwmat using "C:\Data\spatial_loc_gov\cent_compXsameregion_row_av_w_s.dta", name(W2) 


**************************
*Open Data for Regression
**************************
drop _all
use "C:\Data\spatial_loc_gov\turnover2 26 February 2009.dta", clear
keep if check6 == 1
global nobs = 734
matrix I_n = I($nobs)
global Y sp_per 
global X  counciltax conservative labour libdem rsgpercap all_gbp q1claimrate d_1-d_147
mkmat $Y, matrix(Y)
matrix SL1 = W1*Y
svmat SL1, n(SL1)
matrix SL2 = W2*Y
svmat SL2, n(SL2)


************************
*Produce starting values
************************ 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

***************************
*Estimate spatial lag model
***************************

ml model lf splag_lli (mu: $Y=$X) (rho1:) (rho2:)(sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init sigma:_cons=`OLSsigma'
*ml trace on
ml max




***********************
*Model 4 rec_p_dist cent_compXrec_p_dist
*********************** 

***********************
*Likelihood Evaluator  
***********************                                                         

program define splag_llj

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


**********************
*Open Data For Weights
**********************

/*This drops cells in the weighting matrix corresponding to cases
that have missing data on any of the variables in the models*/

spatwmat using "C:\Data\spatial_loc_gov\rec_p_dist_w_s.dta", name(W1) standardize
spatwmat using "C:\Data\spatial_loc_gov\cent_compXrec_p_dist_row_av_w_s.dta", name(W2)


**************************
*Open Data for Regression
**************************
drop _all
use "C:\Data\spatial_loc_gov\turnover2 26 February 2009.dta", clear
keep if check6 == 1
global nobs = 734
matrix I_n = I($nobs)
global Y sp_per 
global X  counciltax conservative labour libdem rsgpercap all_gbp q1claimrate d_1-d_147
mkmat $Y, matrix(Y)
matrix SL1 = W1*Y
svmat SL1, n(SL1)
matrix SL2 = W2*Y
svmat SL2, n(SL2)


************************
*Produce starting values
************************ 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

***************************
*Estimate spatial lag model
***************************

ml model lf splag_llj (mu: $Y=$X) (rho1:) (rho2:)(sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init sigma:_cons=`OLSsigma'
*ml trace on
ml max



***********************
*Model 5 popgreat cent_compXpopgreat
*********************** 

***********************
*Likelihood Evaluator  
***********************                                                         

program define splag_llk

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


**********************
*Open Data For Weights
**********************

/*This drops cells in the weighting matrix corresponding to cases
that have missing data on any of the variables in the models*/

spatwmat using "C:\Data\spatial_loc_gov\popgreat_ji_w_s.dta", name(W1) standardize
spatwmat using "C:\Data\spatial_loc_gov\cent_compXpopgreat_row_av_w_s.dta", name(W2)

**************************
*Open Data for Regression
**************************
drop _all
use "C:\Data\spatial_loc_gov\turnover2 26 February 2009.dta", clear
keep if check6 == 1
global nobs = 734
matrix I_n = I($nobs)
global Y sp_per 
global X  counciltax conservative labour libdem rsgpercap all_gbp q1claimrate d_1-d_147
mkmat $Y, matrix(Y)
matrix SL1 = W1*Y
svmat SL1, n(SL1)
matrix SL2 = W2*Y
svmat SL2, n(SL2)


************************
*Produce starting values
************************ 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

***************************
*Estimate spatial lag model
***************************

ml model lf splag_llk (mu: $Y=$X) (rho1:) (rho2:)(sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init sigma:_cons=`OLSsigma'
*ml trace on
ml max



***********************
*Model 6 simcontrol cent_compXsimcontrol
*********************** 

***********************
*Likelihood Evaluator  
***********************                                                         

program define splag_lll

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


**********************
*Open Data For Weights
**********************

/*This drops cells in the weighting matrix corresponding to cases
that have missing data on any of the variables in the models*/

spatwmat using "C:\Data\spatial_loc_gov\simcontrol_w_s.dta", name(W1) standardize
spatwmat using "C:\Data\spatial_loc_gov\cent_compXsimcontrol_row_av_w_s.dta", name(W2)

**************************
*Open Data for Regression
**************************
drop _all
use "C:\Data\spatial_loc_gov\turnover2 26 February 2009.dta", clear
keep if check6 == 1
global nobs = 734
matrix I_n = I($nobs)
global Y sp_per 
global X  counciltax conservative labour libdem rsgpercap all_gbp q1claimrate d_1-d_147
mkmat $Y, matrix(Y)
matrix SL1 = W1*Y
svmat SL1, n(SL1)
matrix SL2 = W2*Y
svmat SL2, n(SL2)


************************
*Produce starting values
************************ 

qui regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

***************************
*Estimate spatial lag model
***************************

ml model lf splag_lll (mu: $Y=$X) (rho1:) (rho2:)(sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init sigma:_cons=`OLSsigma'
*ml trace on
ml max



clear


