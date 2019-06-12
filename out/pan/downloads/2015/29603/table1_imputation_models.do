
/*	*************************************************************/
/*	Date:		March 23, 2015									*/
/*  File:		spatial_em_WW01.do						        */
/*	Purpose:	Replicate application results in HSB			*/
/*	*************************************************************/

/*************************************************/
/* Program to implment the imputation algorithm */
/*************************************************/

	/************************************************/
	/* This program combine the estimates from the 	*/
	/* multiply imputed data sets.			*/
	/************************************************/

program drop _all
cd C:\Users\jch61\Desktop\Summer_Work_2014\Boehmke_etal\FINAL_SUBMISSION\PA_REPLICATION_FILES\


global obs 44
global maxiters 200
global numimp 10
global diffconv 0.0001

set seed 28
set matsize $obs
 

program define micalc, eclass

  syntax, PARameters(name) COVariance(name) imputations(integer) 

	local b `parameters'
	local C `covariance'
	local m = `imputations'
  
	local names: colnames(`b'1)

	forvalues i=1/`m' {

	  if `i'==1 {
		matrix b = b1
		matrix C = C1
		}

	  else {
  		matrix b = b + b`i'
		matrix C = C + C`i'
		}
		
	  }

	matrix b = b/`m'
	matrix C = C/`m'
	
	forvalues i=1/`m' {

	  matrix bb=b`i'-b

	  if `i'==1 {
		matrix Vb=(bb)'*bb
		}

	  else matrix Vb = Vb + (bb)'*bb

	  }

	matrix Vb=Vb/(`m'-1)				/* Covariance adjustment */

	matrix V=C+(1+1/`m')*Vb				/* Final covariance   */

	ereturn post b V
	

end


	/************************************************/
	/* This program solves for the implied error 	*/
	/* terms and then generates imputed values of Y.*/
	/************************************************/


program define imputeY

	syntax newvarname, errors(varname) yhat(varname) invcholesky(name) obs(integer) m(integer)
	
	  tempname B U_IMP ETA
	  tempvar eta u_imp uhat

	  matrix `B' = `invcholesky'
	
	  quietly generat `eta' = .
	  quietly generat `uhat' = `errors'

	  matrix bii = `B'[`obs',`obs']
	  scalar bii = trace(bii)

	  quietly replace `eta' = `uhat'[`obs']/bii in `obs'

	  mkmat `eta', matrix(`ETA')
	  
	  forvalues i=`=`obs'-1'(-1)1 {

		if cens[`i'] == 0 {
	  
		  matrix sum = `B'[`i',`i'+1..colsof(`B')]*`ETA'[`i'+1..colsof(`B'),1]
		  local sum = trace(sum)

		  matrix bii = `B'[`i',`i']
		  local bii = trace(bii)

		  quietly replace `eta' = (`uhat'[`i'] - `sum')/`bii' in `i'

		  }

		if cens[`i'] == 1 {
	  
		  matrix sum = `B'[`i',`i'+1..colsof(`B')]*`ETA'[`i'+1..colsof(`B'),1]
		  local sum = trace(sum)

		  matrix bii = `B'[`i',`i']
		  local bii = trace(bii)

		  local c = min(5,(`uhat'[`i'] - `sum')/`bii')
		  quietly replace `eta' = invnormal(normal(`c') + u_rand`m'[`i']*(1-normal(`c'))) in `i'

		  }

		mkmat `eta', matrix(`ETA')
	  
		}
	  
		/* Now create imputed spatial errors from the iid errors `eta'. */
	  
	  matrix `U_IMP' = `B'*`ETA'

	  svmat `U_IMP', name(`u_imp')

		/* Calculate implied value of Y and estimate. */
	  
	  generat `varlist' = `yhat' + `u_imp'
	  
end

	/***********************************************/
	/* Inverse Distance Weights Matrix Analysis	   */
	/***********************************************/


**********************
*Open Data For Weights
**********************


use "invdist_W_rs.dta",clear
spmat dta W v*, id(Ccode) replace
mkmat var1-var$obs, matrix(W)
matrix eigenvalues eig imaginaryv = W
matrix E = eig'

**************************
*Open Data for Regression
**************************

use "WWI_entry_days.dta", clear
sort Ccode


		/* Set the dependent and independent variables. */

global Y ln_days
global X capabilities trade democracy


	/************************************************/
	/* This program estimates the model via the EM 	*/
	/* process described by Wei and Tanner.		*/
	/************************************************/
	

	spreg ml $Y $X, id(Ccode) dlmat(W)
			
		
			/* Create a matrix with the coefficient estimates. */
	
	matrix b_hat = e(b)
	matrix C = e(V)
	
	mata: b_hat = st_matrix("b_hat")

		/* Generate random uniform from which to generate censored errors. */
		/* Generate random normal from which to impute the parameter vector. */
	
	forvalues i=1/$numimp {
	
	  generat u_rand`i'= uniform()
	  mata: n_rand`i' = rnormal(rows(b_hat), cols(b_hat), 0 , 1)
	  mata: st_matrix("n_rand`i'", n_rand`i')
	  
	  }
	
		/* Set up the matrix of the independent variables and the constant. */
	
	matrix ones=J($obs,1,1)
	svmat ones, n(ones)
	mkmat $X ones, matrix(Xones)
	
		/* Initialize the likelihood to get the while loop started. */
	
	global diff = 100
	local iters = 0
	
			/* Initialize matrix for convergence. */
	
	matrix b_iter0 = J(rowsof(b_hat),colsof(b_hat),-99)
	
	/* Start while loop here. This keeps cycling until the parameter vector converges. */

	while $diff > 0.0001 & `iters' < $maxiters {

		/* Load the most recent estimates. */
	
	matrix b_hat = e(b)
	matrix C = e(V)
	matrix C = cholesky(C)
	
		/* Create the resampled values of the parameter vector. */
		
	forvalues i=1/$numimp {
	
	  matrix b_samp`i' = (b_hat' + C*(n_rand`i')')
	
	  scalar lambda_hat`i' = b_samp`i'[rowsof(b_samp`i')-1,colsof(b_samp`i')]
	  scalar sigma2_hat`i' = b_samp`i'[rowsof(b_samp`i'),colsof(b_samp`i')]

	  }
	  
	forvalues j = 1/$numimp {

		/* Generate the predicted value of Y to get predicted errors. */
	
		matrix Ghat = inv(I($obs)- lambda_hat`j'*W)
	
		matrix b_sub`j' = (b_samp`j'[1..rowsof(b_samp`j')-2,1])

		matrix Yhat = Ghat*(Xones*b_sub`j')
		svmat Yhat, names(Yhat)
		rename Yhat1 Yhat

		generat uhat = $Y - Yhat
	    
		/* Use predicted errors to get covariance matrix and then do Cholesky decomposition. */
	    
		matrix M = inv(I($obs)-lambda_hat`j'*W)
		matrix Sigma`j'=(sigma2_hat`j')*M*M'

		matrix Apr = cholesky(inv(Sigma`j'))
		matrix A = Apr'
		matrix B = inv(Apr')

		/* Now generate draws of the iid eta. This routine goes through one observation at a 	*/
		/* time and calculates the estimated value or censoring point and then takes a draw 	*/
		/* greater than the censoring point for censored observations.				*/

		matrix lambda`j' = lambda_hat`j'

		imputeY y_imp, errors(uhat) yhat(Yhat) invcholesky(B) obs($obs) m(`j')

		quietly spreg ml y_imp $X, id(Ccode) dlmat(W) from(lambda`j', copy)

		matrix b`j' = e(b)
		matrix C`j' = e(V)

		scalar ll`j' = e(ll)

		drop Yhat y_imp uhat

		}

		/* This calculates the MI estimates. */

	micalc, parameters(b) covariance(C) imputations($numimp)

	local iters = `iters' + 1
	
	matrix b_iter`iters' = e(b)
	
		/* This Mata program calculates the sum of the absolute difference in the parameter vector. */ 	
	
	  mata: bcur=st_matrix("b_iter`iters'")
	  mata: blag=st_matrix("b_iter`=`iters'-1'")
	
	  mata: diff = sum(abs(bcur-blag))
	
	  mata: st_matrix("diff", diff)
	
	global diff = trace(diff)
	  
	}
	
ereturn display, plus neq(3)

	/***********************************************/
	/* Rivalry Weights Matrix Analysis	   		   */
	/***********************************************/


**********************
*Open Data For Weights
**********************

use "rivalry_W_rs.dta",clear
spmat dta W v*, id(Ccode) replace
mkmat var1-var$obs, matrix(W)
matrix eigenvalues eig imaginaryv = W
matrix E = eig'

**************************
*Open Data for Regression
**************************

use "WWI_entry_days.dta", clear
sort Ccode


		/* Set the dependent and independent variables. */

global Y ln_daysglobal X capabilities trade democracy


	/************************************************/
	/* This program estimates the model via the EM 	*/
	/* process described by Wei and Tanner.		*/
	/************************************************/
	

	spreg ml $Y $X, id(Ccode) dlmat(W)
			
		
			/* Create a matrix with the coefficient estimates. */
	
	matrix b_hat = e(b)
	matrix C = e(V)
	
	mata: b_hat = st_matrix("b_hat")

		/* Generate random uniform from which to generate censored errors. */
		/* Generate random normal from which to impute the parameter vector. */
	
	forvalues i=1/$numimp {
	
	  generat u_rand`i'= uniform()
	  mata: n_rand`i' = rnormal(rows(b_hat), cols(b_hat), 0 , 1)
	  mata: st_matrix("n_rand`i'", n_rand`i')
	  
	  }
	
		/* Set up the matrix of the independent variables and the constant. */
	
	matrix ones=J($obs,1,1)
	svmat ones, n(ones)
	mkmat $X ones, matrix(Xones)
	
		/* Initialize the likelihood to get the while loop started. */
	
	global diff = 100
	local iters = 0
	
			/* Initialize matrix for convergence. */
	
	matrix b_iter0 = J(rowsof(b_hat),colsof(b_hat),-99)
	
	/* Start while loop here. This keeps cycling until the parameter vector converges. */

	while $diff > 0.0001 & `iters' < $maxiters {

		/* Load the most recent estimates. */
	
	matrix b_hat = e(b)
	matrix C = e(V)
	matrix C = cholesky(C)

	
		/* Create the resampled values of the parameter vector. */
		
	forvalues i=1/$numimp {
	
	  matrix b_samp`i' = (b_hat' + C*(n_rand`i')')
	
	  scalar lambda_hat`i' = b_samp`i'[rowsof(b_samp`i')-1,colsof(b_samp`i')]
	  scalar sigma2_hat`i' = b_samp`i'[rowsof(b_samp`i'),colsof(b_samp`i')]

	  }
	  
	forvalues j = 1/$numimp {

		/* Generate the predicted value of Y to get predicted errors. */
	
		matrix Ghat = inv(I($obs)- lambda_hat`j'*W)
	
		matrix b_sub`j' = (b_samp`j'[1..rowsof(b_samp`j')-2,1])

		matrix Yhat = Ghat*(Xones*b_sub`j')
		svmat Yhat, names(Yhat)
		rename Yhat1 Yhat

		generat uhat = $Y - Yhat
	    
		/* Use predicted errors to get covariance matrix and then do Cholesky decomposition. */
	    
		matrix M = inv(I($obs)-lambda_hat`j'*W)
		matrix Sigma`j'=(sigma2_hat`j')*M*M'

		matrix Apr = cholesky(inv(Sigma`j'))
		matrix A = Apr'
		matrix B = inv(Apr')

		/* Now generate draws of the iid eta. This routine goes through one observation at a 	*/
		/* time and calculates the estimated value or censoring point and then takes a draw 	*/
		/* greater than the censoring point for censored observations.				*/

		matrix lambda`j' = lambda_hat`j'

		imputeY y_imp, errors(uhat) yhat(Yhat) invcholesky(B) obs($obs) m(`j')

		quietly spreg ml y_imp $X, id(Ccode) dlmat(W) from(lambda`j', copy)

		matrix b`j' = e(b)
		matrix C`j' = e(V)

		scalar ll`j' = e(ll)

		drop Yhat y_imp uhat

		}

		/* This calculates the MI estimates. */

	micalc, parameters(b) covariance(C) imputations($numimp)

	local iters = `iters' + 1
	
	matrix b_iter`iters' = e(b)
	
		/* This Mata program calculates the sum of the absolute difference in the parameter vector. */ 	
	
	  mata: bcur=st_matrix("b_iter`iters'")
	  mata: blag=st_matrix("b_iter`=`iters'-1'")
	
	  mata: diff = sum(abs(bcur-blag))
	
	  mata: st_matrix("diff", diff)
	
	global diff = trace(diff)
	  
	}
	
ereturn display, plus neq(3) 

set seed 28

	/***********************************************/
	/* Alliance Weights Matrix Analysis	   		   */
	/***********************************************/


**********************
*Open Data For Weights
**********************

use "alliance_W_rs.dta",clear
spmat dta W v*, id(Ccode) replace
mkmat var1-var$obs, matrix(W)
matrix eigenvalues eig imaginaryv = W
matrix E = eig'

**************************
*Open Data for Regression
**************************

use "WWI_entry_days.dta", clear
sort Ccode


		/* Set the dependent and independent variables. */

global Y ln_daysglobal X capabilities trade democracy


	/************************************************/
	/* This program estimates the model via the EM 	*/
	/* process described by Wei and Tanner.		*/
	/************************************************/
	

	spreg ml $Y $X, id(Ccode) dlmat(W)
			
		
			/* Create a matrix with the coefficient estimates. */
	
	matrix b_hat = e(b)
	matrix C = e(V)
	
	mata: b_hat = st_matrix("b_hat")

		/* Generate random uniform from which to generate censored errors. */
		/* Generate random normal from which to impute the parameter vector. */
	
	forvalues i=1/$numimp {
	
	  generat u_rand`i'= uniform()
	  mata: n_rand`i' = rnormal(rows(b_hat), cols(b_hat), 0 , 1)
	  mata: st_matrix("n_rand`i'", n_rand`i')
	  
	  }
	
		/* Set up the matrix of the independent variables and the constant. */
	
	matrix ones=J($obs,1,1)
	svmat ones, n(ones)
	mkmat $X ones, matrix(Xones)
	
		/* Initialize the likelihood to get the while loop started. */
	
	global diff = 100
	local iters = 0
	
			/* Initialize matrix for convergence. */
	
	matrix b_iter0 = J(rowsof(b_hat),colsof(b_hat),-99)
	
	/* Start while loop here. This keeps cycling until the parameter vector converges. */

	while $diff > 0.0001 & `iters' < $maxiters {

		/* Load the most recent estimates. */
	
	matrix b_hat = e(b)
	matrix C = e(V)
	matrix C = cholesky(C)

	
		/* Create the resampled values of the parameter vector. */
		
	forvalues i=1/$numimp {
	
	  matrix b_samp`i' = (b_hat' + C*(n_rand`i')')
	
	  scalar lambda_hat`i' = b_samp`i'[rowsof(b_samp`i')-1,colsof(b_samp`i')]
	  scalar sigma2_hat`i' = b_samp`i'[rowsof(b_samp`i'),colsof(b_samp`i')]

	  }
	  
	forvalues j = 1/$numimp {

		/* Generate the predicted value of Y to get predicted errors. */
	
		matrix Ghat = inv(I($obs)- lambda_hat`j'*W)
	
		matrix b_sub`j' = (b_samp`j'[1..rowsof(b_samp`j')-2,1])

		matrix Yhat = Ghat*(Xones*b_sub`j')
		svmat Yhat, names(Yhat)
		rename Yhat1 Yhat

		generat uhat = $Y - Yhat
	    
		/* Use predicted errors to get covariance matrix and then do Cholesky decomposition. */
	    
		matrix M = inv(I($obs)-lambda_hat`j'*W)
		matrix Sigma`j'=(sigma2_hat`j')*M*M'

		matrix Apr = cholesky(inv(Sigma`j'))
		matrix A = Apr'
		matrix B = inv(Apr')

		/* Now generate draws of the iid eta. This routine goes through one observation at a 	*/
		/* time and calculates the estimated value or censoring point and then takes a draw 	*/
		/* greater than the censoring point for censored observations.				*/

		matrix lambda`j' = lambda_hat`j'

		imputeY y_imp, errors(uhat) yhat(Yhat) invcholesky(B) obs($obs) m(`j')

		quietly spreg ml y_imp $X, id(Ccode) dlmat(W) from(lambda`j', copy)

		matrix b`j' = e(b)
		matrix C`j' = e(V)

		scalar ll`j' = e(ll)

		drop Yhat y_imp uhat

		}

		/* This calculates the MI estimates. */

	micalc, parameters(b) covariance(C) imputations($numimp)

	local iters = `iters' + 1
	
	matrix b_iter`iters' = e(b)
	
		/* This Mata program calculates the sum of the absolute difference in the parameter vector. */ 	
	
	  mata: bcur=st_matrix("b_iter`iters'")
	  mata: blag=st_matrix("b_iter`=`iters'-1'")
	
	  mata: diff = sum(abs(bcur-blag))
	
	  mata: st_matrix("diff", diff)
	
	global diff = trace(diff)
	  
	}
	
ereturn display, plus neq(3) 
