clear
cap log close

// Set directory to parent "reproduction" folder

*==============================================================================
*==============================================================================
*=     File-Name:      "examples.do"						                  
*=     Date:           6/8/2018                         
*=     Author:         Laron Williams (williamslaro@missouri.edu)                        
*=     Purpose:        Replicate the in-text examples for PSRM Spatial 
*=					   Interpretation paper.                                            
*=     Output File:    "examples.smcl"
*==============================================================================
*==============================================================================

log using "examples/examples.smcl", replace

********************************************************************************
*** Section: The general approach to interpreting spatial econometric models
********************************************************************************

****************************** SAR MODEL ***************************************
*** Create the parameters
scalar beta = 0.5
scalar rho = 0.5

*** Create the example weights matrices:
* First, the un-row-standardized contiguous matrix
mat W = (0, 1, 0 \ /*
*/		 1, 0, 1 \ /*
*/		 0, 1, 0)

* Second, the second-order contiguity matrix
mat W_2nd = (0, 0, 1 \ /*
*/			 0, 0, 0 \ /*
*/			 1, 0, 0)

*** Create the identity matrix
scalar r = rowsof(W)
matrix I = I(r)

*** Illustrate the effects at 0 through 2nd order:
* 0-order effects (I*Beta)
mat IB = I * beta
mat list IB

* 1-order effects (p*W*Beta)
mat pWB = rho * W * beta
mat list pWB

* 2-order effects (p^2*W^2*Beta)
mat W2 = W * W 
mat p2W2B = rho^2 * W2 * beta
mat list p2W2B

*** Illustrate the second-order effects for the second-order contiguity weights matrix (p^2 * W_2nd * Beta)
mat p2W2ndB = rho^2 * W_2nd * beta
mat list p2W2ndB

*********************** COUNTERFACTUAL SHOCKS **********************************

*** Create the rho parameter (no need for anything else)
scalar rho = 0.5

*** Create the un-row-standardized contiguous weights matrix
mat W1 = (0, 1, 0, 0 \ /*
*/		 1, 0, 1, 0 \ /*
*/		 0, 1, 0, 1 \ /*
*/		 0, 0, 1, 0)

*** Two versions of counterfactual shocks:
* Scalar (assumes a 1-unit shock for all observations, produces an NxN matrix of effects, first column shows the effects of a 1-unit shock in first observation on all other observations)
scalar scenario1 = 1
mat cf1 = rho * W1 * scenario1 
mat list cf1

* Column vector (assumes 1-unit shock for the third observation, produces an Nx1 column vector of effects)
matrix scenario2 = (0 \ 0 \ 1 \ 0)
mat cf2 = rho * W1 * scenario2
mat list cf2

********************************************************************************
*** Section: Advantages of the General Approach
********************************************************************************

****************************** EXAMPLE 1 ***************************************

*** Create the parameters (no constant)
scalar beta = 0.5
scalar rho = 0.1

*** Create the W: un-row-standardized contiguous
mat W1 = (0, 1, 0, 0 \ /*
*/		 1, 0, 1, 0 \ /*
*/		 0, 1, 0, 1 \ /*
*/		 0, 0, 1, 0)

*** Create an identity matrix
scalar r = rowsof(W1)
matrix I = I(r)

*** Make all the scalars and matrices accessible in mata
mata: rho = st_numscalar("rho")
mata: I = st_matrix("I")
mata: W = st_matrix("W1")
mata: beta = st_numscalar("beta")

*** Calculate the partial derivatives matrix and the appropriate average effects 
mata: pd = luinv(I-rho*W)*beta
mata: deffect = 1/rows(W)*trace(pd)
mata: teffect = 1/rows(W)*sum(pd)
mata: ieffect = 1/rows(W)*(sum(pd)-trace(pd))

mata: rs_pd = rowsum(pd)

mata: W
mata: pd
mata: rs_pd
mata: teffect
mata: deffect
mata: ieffect


****************************** EXAMPLE 2.1 *************************************

*** Create the parameters (no constant)
scalar beta = 0.5
scalar rho = 0.1

*** Create the W: un-row-standardized inverse distance
local p1 = 0.5
local p2 = 4.5
local p3 = 5.5
local p4 = 7

matrix W2 = J(4,4,.)

foreach r of numlist 1(1)4 {
	foreach c of numlist 1(1)4 {
		local e_`r'`c' = `p`r'' - `p`c''
		matrix W2[`r',`c'] = 1/abs(`e_`r'`c'')
	}
	matrix W2[`r',`r'] = 0
}

*** Create an identity matrix
scalar r = rowsof(W2)
matrix I = I(r)

*** Make all the scalars and matrices accessible in mata
mata: rho = st_numscalar("rho")
mata: I = st_matrix("I")
mata: W = st_matrix("W2")
mata: beta = st_numscalar("beta")

*** Calculate the partial derivatives matrix and the appropriate average effects 
mata: pd = luinv(I-rho*W)*beta
mata: deffect = 1/rows(W)*trace(pd)
mata: teffect = 1/rows(W)*sum(pd)
mata: ieffect = 1/rows(W)*(sum(pd)-trace(pd))

mata: rs_pd = rowsum(pd)

mata: W
mata: pd
mata: rs_pd
mata: teffect
mata: deffect
mata: ieffect

mata: 100 * (ieffect + (deffect - beta)) / teffect

********************* EXAMPLE 2.2 (NOT SHOWN IN PAPER) *************************

*** Same parameters as Example 2.1

*** Create the W: row-standardized inverse distance
scalar r = rowsof(W2)
matrix ones = J(r,1,1)
matrix rsum = W2 * ones

matrix W2rs = J(4,4,.)

foreach r of numlist 1(1)4 {
	foreach c of numlist 1(1)4 {
		matrix W2rs[`r',`c'] = W2[`r',`c'] / rsum[`r',1]
	}
}

*** Create an identity matrix
matrix I = I(r)

*** Make all the scalars and matrices accessible in mata
mata: rho = st_numscalar("rho")
mata: I = st_matrix("I")
mata: W = st_matrix("W2rs")
mata: beta = st_numscalar("beta")

*** Calculate the partial derivatives matrix and the appropriate average effects 
mata: pd = luinv(I-rho*W)*beta
mata: deffect = 1/rows(W)*trace(pd)
mata: teffect = 1/rows(W)*sum(pd)
mata: ieffect = 1/rows(W)*(sum(pd)-trace(pd))

mata: rs_pd = rowsum(pd)

mata: W
mata: pd
mata: rs_pd

****************************** EXAMPLE 3 ***************************************

*** Create the parameters (no constant)
scalar beta = 0.5
scalar rho = 0.1

*** Create the W: un-row-standardized contiguous
mat W3 = (0, 0, 0, 0 \ /*
*/		  0, 0, 1, 0 \ /*
*/		  0, 1, 0, 1 \ /*
*/		  0, 0, 1, 0)

*** Create an identity matrix
scalar r = rowsof(W3)
matrix I = I(r)

*** Make all the scalars and matrices accessible in mata
mata: rho = st_numscalar("rho")
mata: I = st_matrix("I")
mata: W = st_matrix("W3")
mata: beta = st_numscalar("beta")

*** Calculate the partial derivatives matrix and the appropriate average effects 
mata: pd = luinv(I-rho*W)*beta
mata: deffect = 1/rows(W)*trace(pd)
mata: teffect = 1/rows(W)*sum(pd)
mata: ieffect = 1/rows(W)*(sum(pd)-trace(pd))

mata: rs_pd = rowsum(pd)

mata: W
mata: pd
mata: rs_pd
mata: teffect
mata: deffect
mata: ieffect

log close

translate "examples/examples.smcl" ///
		  "examples/examples.pdf", trans(smcl2pdf)

clear

clear
