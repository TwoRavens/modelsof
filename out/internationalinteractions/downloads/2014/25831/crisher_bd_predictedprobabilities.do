// Predicted Probabilities Do File
// Brian B. Crisher
// Dept. of Politicaly Science, Florida State University
// bcrisher@fsu.edu
// "Inequality Amid Equality: Military Capabilities and Conflict Behavior in Balanced Dyads"
// International Interactions

// NOTE: Predicted Probabilities calculated in Stata 11 and 
// the results are then graphed in R - see separate R replication file
// for graphing codes

// Predicted Probabilities used in Figure 3

*****************
*
* Predicted Probabilities for Escalation
*
*****************

/* Do file for creating predicted probabilities for two stage heckman         */
/* This particular do file will create a graph of predicted probabilities     */
/* of Y* occurring in the outcome model (second stage) if the selection model */
/* (first stage) equals one.                                                  */


set more off 

// set the working directory
cd "SET YOUR DIRECTORY"

// use whatever data you want 
use "SET YOUR DIRECTORY", clear

* set initial values manually
probit mutforcerecip dyadpow jntd6 smldep allies contig150 terr if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946 & mzmid == 1, cluster(dyadid) nolog
matrix b0 = e(b)
local coln : colnames b0
foreach name of local coln {
	local colname "`colname' mutforcerecip:`name'"
}

probit mzmid dyadpow jntd6 smldep allies contig150 midpy* if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
matrix temp = e(b)
local coln : colnames temp
foreach name of local coln {
	local colname "`colname' mzmid:`name'"
}
local colname "`colname' athrho:_cons"
matrix b0 = b0, temp, atanh(.5)
matrix colname b0 = `colname'
matrix list b0

* heckprob model
set more off
heckprob mutforcerecip dyadpow jntd6 smldep allies terr contig150 if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, ///
	select(mzmid = dyadpow jntd6 smldep allies contig150 midpy*) cluster(dyadid) from(b0)

	
*     ****************************************************************  *
*       Take 10,000 draws from the estimated coefficient vector and     *
*       variance-covariance matrix.                                     *
*       Take note of the order of variables in the coefficient matrix   *
*     ****************************************************************  *

preserve
set seed 32301
drawnorm MG_b1-MG_b18, n(10000) means(e(b)) cov(e(V)) clear
gen simrho = (exp(2*MG_b18)-1)/(exp(2*MG_b18)+1) 

postutil clear
postfile mypost prob_hat lo hi ///
            using fig3escalation, replace 
            noisily display "start"
            
*     **************************************************************************  *
*       Start loop.  Let `a' be the primary variable of interest and let this     *
*       run from whatever range you decide.                                       *
*     **************************************************************************  *                                  

local a=0 
while `a' <= 3.9 { 

    {

/* Set Variables at desired value - it might make it easier to give them actual names */ 

scalar h_jntd6 = 0
scalar h_smldep = 0.004
scalar h_allies = 0
scalar h_terr = 0
scalar h_contig150 = 1
scalar h_midpy = 8.09
scalar h_midpy1 = -4628.384
scalar h_midpy2 = -7791.846
scalar h_midpy3 = -9289.162
scalar h_constant = 1
/* average dyadpow is 0.22 - use for first stage constant */


	/* this is the outcome equation (stage two) - be sure to line up `a' with the proper coefficient        */
	/* this is also where you need to make sure you understand the order of coefficients in the coefficient */
	/* matrix                                                                                               */
    
	generate x_betahat2 = MG_b1*(`a') + MG_b2*h_jntd6 + MG_b3*h_smldep + MG_b4*h_allies + MG_b5*h_terr + MG_b6*h_contig150 ///
		+ MG_b7*h_constant
					
    /* this is the selection equation (stage one) */
    
	generate x_betahat1 = MG_b8*(0.22) + MG_b9*h_jntd6 + MG_b10*h_smldep + MG_b11*h_allies + MG_b12*h_contig150 ///
		+ MG_b13*h_midpy + MG_b14*h_midpy1 + MG_b15*h_midpy2 ///
		+ MG_b16*h_midpy3 + MG_b17*h_constant
					
				
    /* predicted probability using bivariate normal distribution */
    gen prob=binorm(x_betahat1, x_betahat2, simrho)

        
    egen probhat=mean(prob)
    
    
    tempname prob_hat lo hi   

    _pctile prob, p(5,95) 
    scalar `lo' = r(r1)
    scalar `hi' = r(r2)
    
    scalar `prob_hat' = probhat
        
    post mypost (`prob_hat') (`lo') (`hi') 
    }      
    drop x_betahat1 x_betahat2 prob probhat
    local a=`a'+ .1 
    display "." _c
    } 

display ""

postclose mypost

*     ****************************************************************  *                                
*       Call on posted quantities of interest                           *
*     ****************************************************************  *                                  


use fig3escalation, clear

* divide MV by 10 in this case to put it in the scale of *
* the X variable as it is not an integer                 *
gen MV = (_n-1)/10

save fig3escalation, replace


*****************
*
* Predicted Probabilities for Initiation
*
*****************

* heckprob model
set more off
probit mzmid dyadpow jntd6 smldep allies contig150 midpy* if parity575 == 1 & pol_rel == 1 & mzongo == 0 & year >= 1946, cluster(dyadid) nolog
		
*     ****************************************************************  *
*       Take 10,000 draws from the estimated coefficient vector and     *
*       variance-covariance matrix.                                     *
*       Take note of the order of variables in the coefficient matrix   *
*     ****************************************************************  *

preserve
set seed 32301
drawnorm MG_b1-MG_b10, n(10000) means(e(b)) cov(e(V)) clear



*     ****************************************************************  *
*       To calculate the desired quantities of interest we need to set  *
*       up a loop.  This is what we do here.                            *
*     ****************************************************************  *
*       First, specify what you quantities should be saved and what     *
*       these quantities should be called.                              *
*     ****************************************************************  *

postutil clear
postfile mypost prob_hat lo hi ///
            using fig3initiation, replace 
            noisily display "start"
            
*     **************************************************************************  *
*       Start loop.  Let `a' be the primary variable of interest and let this     *
*       run from whatever range you decide.                                       *
*     **************************************************************************  *                                  

local a=0 
while `a' <= 3.00 { 

    {

/* Set Variables at desired value - it might make it easier to give them actual names */ 

scalar h_jntd6 = 0
scalar h_smldep = 0.008
scalar h_allies = 0
scalar h_contig150 = 1
scalar h_midpy = 22.432
scalar h_midpy1 = -15878.03
scalar h_midpy2 = -27172.38
scalar h_midpy3 = -32834.75
scalar h_constant = 1



	/* be sure to line up `a' with the proper coefficient                                                   */
	/* this is also where you need to make sure you understand the order of coefficients in the coefficient */
	/* matrix                                                                                               */
    
	generate x_betahat = MG_b1*(`a') + MG_b2*h_jntd6 + MG_b3*h_smldep + MG_b4*h_allies + MG_b5*h_contig150 ///
		+ MG_b6*h_midpy + MG_b7*h_midpy1 + MG_b8*h_midpy2 + MG_b9*h_midpy3 + MG_b10*h_constant

										
				
    /* predicted probability using bivariate normal distribution */
    gen prob=normal(x_betahat)

        
    egen probhat=mean(prob)
    
    
    tempname prob_hat lo hi   

    _pctile prob, p(2.5,97.5) 
    scalar `lo' = r(r1)
    scalar `hi' = r(r2)
    
    scalar `prob_hat' = probhat
        
    post mypost (`prob_hat') (`lo') (`hi') 
    }      
    drop x_betahat prob probhat
    local a=`a'+ .1 
    display "." _c
    } 

display ""

postclose mypost

*     ****************************************************************  *                                
*       Call on posted quantities of interest                           *
*     ****************************************************************  *                                  


use fig3initiation, clear

* divide MV by 10 in this case to put it in the scale of *
* the X variable as it is not an integer                 *

gen MV = (_n-1)/10

save fig3initiation, replace

// To replicate the graphics in Figure 3, see R replication files
// Note where you saved the simulations data sets (fig3initiation and fig3escalation)
// these will be needed in the R code
