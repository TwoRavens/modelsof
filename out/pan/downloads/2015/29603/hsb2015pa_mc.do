clear
program drop _all
set more off
  quietly log
  local logon = r(status)
  if "`logon'" == "on" { 
	log close 
	}
log using hsb2015pa_mc.log, text replace


/*	************************************************************/
/*	Date:		March 23, 2015								   */
/*  File:		hsb2015pa_mc.do        						   */
/*	Purpose:	Monte Carlo simulations of the HSB estimator   */
/*				for right censoring in spatial duration 	   */
/*				models and create graphs					   */
/*	************************************************************/


program drop _all

global obs 100
global maxiters 200
global numimp 15
global diffconv 0.0001
set seed 23
set matsize $obs



	/************************************************/
	/* This program generates the outcome 		*/
	/* variable given observed exogenous data.	*/
	/************************************************/

	
program define mc_strat
	
    syntax, indvars(string) cens(real) obs(integer)
	
	use `indvars', clear
	
	generate e = invnorm(uniform())
	
	mkmat e, matrix(E)
	
	matrix G_XB = G*(XB)

	matrix G_E = G*E

	svmat G_E, names(u)
	
	  rename u1 u
	
	matrix y = (G_XB) + (G_E)
	
	svmat y, names(Y)
	
	  rename Y1 Y_uncens
	
	generat Y = min(Y_uncens,`cens')
	
	generat cens = (Y==`cens')
	
end


	/************************************************/
	/* This program combine the estimates from the 	*/
	/* multiply imputed data sets.			*/
	/************************************************/


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
	ereturn display, plus neq(3)
	

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


	/************************************************/
	/* This program runs the EM algorithm and the  	*/
	/* imputation process.				*/
	/************************************************/

	
program define spatdur, eclass

  syntax, numimp(integer) diffconv(real) maxiters(integer) obs(integer) start_b(name) start_cov(name)


		/* Generate random uniform from which to generate censored errors. */
		/* Generate random normal from which to impute the parameter vector. */
	
	capture drop u_rand* 
	capture drop Yhat 
	capture drop uhat 
	capture drop y_imp
	
		/* Load the most recent estimates. */
	
	matrix b_hat = `start_b'
	matrix C = `start_cov'
	
	mata: b_hat = st_matrix("b_hat")
	
	forvalues i=1/`numimp' {
	
	  generat u_rand`i'= uniform()
	  mata: n_rand`i' = rnormal(rows(b_hat), cols(b_hat), 0 , 1)
	  mata: st_matrix("n_rand`i'", n_rand`i')
	  
	  }
	
		/* Set up the matrix of the independent variables and the constant. */
	
	mkmat x1 ones, matrix(Xones)
		
			/* Initialize matrix for convergence. */

	local iters = 0
	global diff = 100
	
	matrix b_iter0 = J(rowsof(b_hat),colsof(b_hat),-99)
	
	/* Start while loop here. This keeps cycling until the parameter vector converges. */

	while $diff > `diffconv' & `iters' < `maxiters' {

		/* Take the Cholesky of the covariance matrix to add parameter uncertainty. */
	
	matrix SD = cholesky(C)
	
		/* Create the resampled values of the parameter vector. */
		
	forvalues i=1/`numimp' {

		/* Take log before adding it then exponentiate to keep positive. */
	
	  matrix b_rescale = b_hat
	  
	  matrix b_rescale[1,4] = ln(b_hat[1,4])
	
	  matrix b_samp`i' = (b_rescale' + SD*(n_rand`i')')
	  
	  matrix b_samp`i'[4,1] = exp(b_samp`i'[4,1])
	
	  scalar lambda_hat`i' = b_samp`i'[rowsof(b_samp`i')-1,colsof(b_samp`i')]
	  scalar sigma2_hat`i' = b_samp`i'[rowsof(b_samp`i'),colsof(b_samp`i')]

	  }
	  
	forvalues j = 1/`numimp' {

		/* Generate the predicted value of Y to get predicted errors. */
	
		matrix Ghat = inv(I(`obs')- lambda_hat`j'*W)
	
		matrix b_sub`j' = (b_samp`j'[1..rowsof(b_samp`j')-2,1])

		matrix Yhat = Ghat*(Xones*b_sub`j')
		svmat Yhat, names(Yhat)
		rename Yhat1 Yhat

		generat uhat = Y - Yhat
	    
		/* Use predicted errors to get covariance matrix and then do Cholesky decomposition. */
	    
		matrix M = inv(I(`obs')-lambda_hat`j'*W)
		matrix Sigma`j'=(sigma2_hat`j')*M*M'

		matrix Apr = cholesky(inv(Sigma`j'))
		matrix A = Apr'
		matrix B = inv(Apr')

		/* Now generate draws of the iid eta. This routine goes through one observation at a 	*/
		/* time and calculates the estimated value or censoring point and then takes a draw 	*/
		/* greater than the censoring point for censored observations.				*/

		matrix lambda`j' = lambda_hat`j'

		imputeY y_imp, errors(uhat) yhat(Yhat) invcholesky(B) obs(`obs') m(`j')

		quietly spreg ml y_imp x1, id(ID) dlmat(W) from(lambda`j', copy)

		matrix b`j' = e(b)
		matrix C`j' = e(V)

		scalar ll`j' = e(ll)

		drop Yhat y_imp uhat

		}

		/* This calculates the MI estimates. */

	micalc, parameters(b) covariance(C) imputations(`numimp')

	  matrix b_hat = e(b)
	  matrix C = e(V)
	  
	local iters = `iters' + 1
	
	matrix b_iter`iters' = e(b)
	
		/* This Mata program calculates the sum of the absolute difference in the parameter vector. */ 	
	
	  mata: bcur=st_matrix("b_iter`iters'")
	  mata: blag=st_matrix("b_iter`=`iters'-1'")
	
	  mata: diff = sum(abs(bcur-blag))
	
	  mata: st_matrix("diff", diff)
	
	global diff = trace(diff)
	
	}
	
	ereturn scalar iters = `iters'
 
end
 
	/************************************************/
	/* This program estimates the model via the EM 	*/
	/* process described by Wei and Tanner.		*/
	/************************************************/


program define hsb2015pa_mc_MC, eclass

  syntax, indvars(string) cens(real) obs(integer)

	mc_strat, indvars(`indvars') cens(`cens') obs(`obs')

	  summarize cens
	  
	  local cens_pct = r(mean)
	
		/* Estimate the correct duration model on the uncensored data. */

	spreg ml Y_uncens x1, id(ID) dlmat(W)
			
		local unc_cons 		= [Y_uncens]_b[_cons]
		local unc_x1 		= [Y_uncens]_b[x1]
		local unc_lambda 	= [lambda]_b[_cons]
		local unc_sigma2 	= [sigma2]_b[_cons]

		local se_unc_cons 	= [Y_uncens]_se[_cons]
		local se_unc_x1 	= [Y_uncens]_se[x1]
		local se_unc_lambda 	= [lambda]_se[_cons]
		local se_unc_sigma2 	= [sigma2]_se[_cons]

		/* Estimate nonspatial duration model with right censoring. */

	generat Y_dur = exp(Y)
	stset Y_dur, fail(cens=0)
	
	streg x1, dist(lognormal) time
			
		local d_cons 		= [_t]_b[_cons]
		local d_x1 		= [_t]_b[x1]
		local d_ln_p 		= [ln_sig]_b[_cons]

		local se_d_cons 	= [_t]_se[_cons]
		local se_d_x1 		= [_t]_se[x1]
		local se_d_ln_p 	= [ln_sig]_se[_cons]

		/* Estimate spatial lag model to get starting values and naive estimates. */

	spreg ml Y x1, id(ID) dlmat(W)
			
		local g_cons 		= [Y]_b[_cons]
		local g_x1 		= [Y]_b[x1]
		local g_lambda 		= [lambda]_b[_cons]
		local g_sigma2 		= [sigma2]_b[_cons]

		local se_g_cons 	= [Y]_se[_cons]
		local se_g_x1 		= [Y]_se[x1]
		local se_g_lambda 	= [lambda]_se[_cons]
		local se_g_sigma2 	= [sigma2]_se[_cons]
		
			/* Create a matrix with the coefficient estimates. */
	
	matrix b_hat0 = e(b)
	matrix C0 = e(V)
	
	capture spatdur, numimp($numimp) diffconv($diffconv) maxiters($maxiters) obs($obs) start_b(b_hat0) start_cov(C0)
	
	  if _rc == 0 {
	  
		ereturn display
	  
		local b_cons 		= [y_imp]_b[_cons]
		local b_x1 		= [y_imp]_b[x1]
		local b_lambda 		= [lambda]_b[_cons]
		local b_sigma2 		= [sigma2]_b[_cons]

		local se_b_cons 	= [y_imp]_se[_cons]
		local se_b_x1 		= [y_imp]_se[x1]
		local se_b_lambda 	= [lambda]_se[_cons]
		local se_b_sigma2 	= [sigma2]_se[_cons]
		
		}
		
	  else {
	  
		local b_cons 		= .
		local b_x1 		= .
		local b_lambda 		= .
		local b_sigma2 		= .

		local se_b_cons 	= .
		local se_b_x1 		= .
		local se_b_lambda 	= .
		local se_b_sigma2 	= .
		
		}
		
		ereturn scalar iters = e(iters)
		ereturn scalar cens_pct = `cens_pct'

		ereturn scalar unc_cons 	= `unc_cons'
		ereturn scalar unc_x1 		= `unc_x1' 
		ereturn scalar unc_lambda 	= `unc_lambda'
		ereturn scalar unc_sigma2 	= `unc_sigma2'

		ereturn scalar se_unc_cons 	= `se_unc_cons'
		ereturn scalar se_unc_x1 	= `se_unc_x1'
		ereturn scalar se_unc_lambda 	= `se_unc_lambda'
		ereturn scalar se_unc_sigma2 	= `se_unc_sigma2'

		ereturn scalar g_cons 		= `g_cons'
		ereturn scalar g_x1 		= `g_x1' 
		ereturn scalar g_lambda 	= `g_lambda'
		ereturn scalar g_sigma2 	= `g_sigma2'

		ereturn scalar se_g_cons 	= `se_g_cons'
		ereturn scalar se_g_x1 		= `se_g_x1'
		ereturn scalar se_g_lambda 	= `se_g_lambda'
		ereturn scalar se_g_sigma2 	= `se_g_sigma2'
		
		ereturn scalar d_cons 		= `d_cons'
		ereturn scalar d_x1 		= `d_x1' 
		ereturn scalar d_ln_p 		= `d_ln_p'

		ereturn scalar se_d_cons 	= `se_d_cons'
		ereturn scalar se_d_x1 		= `se_d_x1'
		ereturn scalar se_d_ln_p 	= `se_d_ln_p'

		ereturn scalar b_cons 		= `b_cons'
		ereturn scalar b_x1 		= `b_x1' 
		ereturn scalar b_lambda 	= `b_lambda'
		ereturn scalar b_sigma2 	= `b_sigma2'

		ereturn scalar se_b_cons 	= `se_b_cons'
		ereturn scalar se_b_x1 		= `se_b_x1'
		ereturn scalar se_b_lambda 	= `se_b_lambda'
		ereturn scalar se_b_sigma2 	= `se_b_sigma2'
		

end

clear
save hsb2015pa_mc, replace emptyok
	

forvalues rho = 0.25(0.25)0.75 { 

  clear 
  set obs $obs

		/* Set up hypothetical weights matrix. */

  generat id1 = _n

  egen coord1_x = seq(), from(1) to(`=sqrt($obs)') block(`=sqrt($obs)')

  bysort coord1_x: generat coord1_y = _n
  
  save hsb2015pa_mc_indvars, replace
  
  rename id1 id2
  rename coord1_x coord2_x
  rename coord1_y coord2_y
  
  cross using hsb2015pa_mc_indvars

	sort id1 id2
  
	generat w = 0
	replace w = 1 if (abs(coord1_x - coord2_x) <= 1 & abs(coord1_y - coord2_y) <= 1)
  
	replace w = 0 if id1==id2
	
	keep w id1 id2
 
	reshape wide w, i(id1) j(id2)
  
	rename id1 ID

  spmat dta W w*, id(ID) normalize(row) replace

  preserve

	spmat export W using hsb2015pa_mc.txt, replace

	insheet ID w1-w$obs using hsb2015pa_mc.txt, clear delimit(" ")
  
	rename id ID
	
	drop ID
	drop in 1

	mkmat w1-w$obs, matrix(W)
	drop w1-w$obs

  restore

		/* Generate exogenous variables. */

	generate x1 = invnorm(uniform())

	gen ones = 1

	mkmat ones x1, matrix(X)

	matrix gamma = I($obs)- `rho'*W

	matrix G = inv(gamma)

	matrix B = (-1\-1)

	matrix XB = X*B
	
	drop w1-w$obs
	
	save hsb2015pa_mc_indvars, replace
		
	forvalues cens = -1(0.5)0.5 { 
	
	  simulate b_cons=e(b_cons) b_x1=e(b_x1) b_lambda=e(b_lambda) b_sigma2=e(b_sigma2) ///
		se_b_cons=e(se_b_cons) se_b_x1=e(se_b_x1) se_b_lambda=e(se_b_lambda) se_b_sigma2=e(se_b_sigma2) ///
		unc_cons=e(unc_cons) unc_x1=e(unc_x1) unc_lambda=e(unc_lambda) unc_sigma2=e(unc_sigma2) ///
		se_unc_cons=e(se_unc_cons) se_unc_x1=e(se_unc_x1) se_unc_lambda=e(se_unc_lambda) se_unc_sigma2=e(se_unc_sigma2) ///
		d_cons=e(d_cons) d_x1=e(d_x1) d_ln_p=e(d_ln_p) ///
		se_d_cons=e(se_d_cons) se_d_x1=e(se_d_x1) se_d_ln_p=e(se_d_ln_p) ///
		g_cons=e(g_cons) g_x1=e(g_x1) g_lambda=e(g_lambda) g_sigma2=e(g_sigma2) ///
		se_g_cons=e(se_g_cons) se_g_x1=e(se_g_x1) se_g_lambda=e(se_g_lambda) se_g_sigma2=e(se_g_sigma2) ///
		cens=(`cens') rho =(`rho') iterations=e(iters) cens_pct=e(cens_pct), ///
		reps(500) saving(hsb2015pa_mc-temp, replace every(25)): hsb2015pa_mc_MC, indvars(hsb2015pa_mc_indvars) cens(`cens') obs($obs)
	 
		append using hsb2015pa_mc
		save hsb2015pa_mc, replace

	  }

  
  }

generat d_p = exp(d_ln_p)
  
summarize
summarize if iterations < $maxiters

table cens rho, c(mean unc_x1 sd unc_x1)
table cens rho, c(mean unc_cons sd unc_cons)
table cens rho, c(mean unc_lambda sd unc_lambda)

table cens rho, c(mean d_x1 sd d_x1)
table cens rho, c(mean d_cons sd d_cons)
table cens rho, c(mean d_ln_p sd d_ln_p)

table cens rho, c(mean g_x1 sd g_x1)
table cens rho, c(mean g_cons sd g_cons)
table cens rho, c(mean g_lambda sd g_lambda)

table cens rho, c(mean b_x1 sd b_x1)
table cens rho, c(mean b_cons sd b_cons)
table cens rho, c(mean b_lambda sd b_lambda)

table cens rho if iterations < $maxiters, c(mean b_x1 sd b_x1)
table cens rho if iterations < $maxiters, c(mean b_cons sd b_cons)
table cens rho if iterations < $maxiters, c(mean b_lambda sd b_lambda)
  
table cens rho if iterations == $maxiters, row col
table cens rho if iterations == $maxiters, c(mean cens_pct) row col
table cens rho if iterations  < $maxiters, c(mean cens_pct) row col
  
label variable d_cons 		"Naive Duration Intercept"
label variable d_x1 		"Naive Duration Coefficient on X1"
label variable d_ln_p 		"Naive Duration Variance (log scale)"
label variable d_p 		"Naive Duration Variance"
label variable g_cons 		"Naive Spatial Intercept"
label variable g_x1 		"Naive Spatial Coefficient on X1"
label variable g_lambda 	"Naive Spatial Correlation"
label variable g_sigma2 	"Naive Error Variance"
label variable b_cons 		"Intercept"
label variable b_x1 		"Coefficient on X1"
label variable b_lambda 	"Spatial Correlation"
label variable g_sigma2 	"Error Variance"
label variable rho 		"True Spatial Correlation"
label variable cens 		"Censoring Point"

compress

save hsb2015pa_mc, replace

twoway scatter b_cons b_lambda if iterations<$maxiters, by(rho cens, rows(4)) ///
	msize(vsmall) ///
	xsize(18) ysize(9) ///
	saving(graphs/hsb2015pa_mc_b0_lambda, replace)

		/* Only keep cases that converged, but keep track of how many did. */
	
generate converged = (iterations < $maxiters)
	
egen pct_cnvg = mean(converged), by(rho cens)

keep if iterations < $maxiters

collapse (mean) b_* g_* d_* unc_* se_* cens_pct iterations pct_cnvg ///
	(sd) sd_b_x1 = b_x1 sd_b_cons = b_cons sd_b_lambda = b_lambda sd_b_sigma2 = b_sigma2 ///
	sd_unc_x1 = unc_x1 sd_unc_cons = unc_cons sd_unc_lambda = unc_lambda sd_unc_sigma2 = unc_sigma2 ///
	sd_d_x1 = d_x1 sd_d_cons = d_cons sd_d_ln_p = d_ln_p sd_d_p = d_p ///
	sd_g_x1 = g_x1 sd_g_cons = g_cons sd_g_lambda = g_lambda sd_g_sigma2 = g_sigma2, by(rho cens) 

generat rmse_b_x1 = sqrt((b_x1 - (-1))^2 + sd_b_x1^2)
generat rmse_b_cons = sqrt((b_cons - (-1))^2 + sd_b_cons^2)
generat rmse_b_lambda = sqrt((b_lambda - rho)^2 + sd_b_lambda^2)

generat rmse_g_x1 = sqrt((g_x1 - (-1))^2 + sd_g_x1^2)
generat rmse_g_cons = sqrt((g_cons - (-1))^2 + sd_g_cons^2)
generat rmse_g_lambda = sqrt((g_lambda - rho)^2 + sd_g_lambda^2)

generat rmse_d_x1 = sqrt((d_x1 - (-1))^2 + sd_d_x1^2)
generat rmse_d_cons = sqrt((d_cons - (-1))^2 + sd_d_cons^2)
generat rmse_d_p = sqrt((d_p - 1)^2 + sd_d_p^2)

generat rmse_unc_x1 = sqrt((unc_x1 - (-1))^2 + sd_unc_x1^2)
generat rmse_unc_cons = sqrt((unc_cons - (-1))^2 + sd_unc_cons^2)
generat rmse_unc_lambda = sqrt((unc_lambda - rho)^2 + sd_unc_lambda^2)

generat bias_b_x1 = b_x1 - (-1)
generat bias_b_cons = b_cons - (-1)
generat bias_b_lambda = b_lambda - rho

generat bias_g_x1 = g_x1 - (-1)
generat bias_g_cons = g_cons - (-1)
generat bias_g_lambda = g_lambda - rho

generat bias_d_x1 = d_x1 - (-1)
generat bias_d_cons = d_cons - (-1)
generat bias_d_p = d_p - 1

generat bias_unc_x1 = unc_x1 - (-1)
generat bias_unc_cons = unc_cons - (-1)
generat bias_unc_lambda = unc_lambda - rho

  save hsb2015pa_mc-collapsed, replace

		/* Do some average estimates graphs. */

graph bar bias_b_x1 bias_g_x1 bias_d_x1 bias_unc_x1, over(cens, label(labsize(small))) over(rho) scheme(s1mono) ///
	bar(1, color(gs0)) bar(2, color(gs5) lcolor(gs0)) bar(3, color(gs10) lcolor(gs0)) bar(4, color(gs15) lcolor(gs0))  ///
	title(Coefficient on X1) ///
	legend(rows(1) label(1 Both) label(2 Spatial) label(3 Censoring) label(4 Benchmark) order(1 2 3 4) size(small)) ///
	fxsize(100) fysize(50) ///
	name(bias_x1, replace) ///
	saving(graphs/hsb2015pa_mc-avg-x1, replace)
	
	graph export graphs/hsb2015pa_mc-avg-x1.eps, replace
  
graph bar bias_b_cons bias_g_cons bias_d_cons bias_unc_cons, over(cens, label(labsize(small))) over(rho) scheme(s1mono) ///
	bar(1, color(gs0)) bar(2, color(gs5) lcolor(gs0)) bar(3, color(gs10) lcolor(gs0)) bar(4, color(gs15) lcolor(gs0))  ///
	title(Intercept) ///
	legend(off) ///
	fxsize(100) fysize(50) ///
	name(bias_cons, replace) ///
	saving(graphs/hsb2015pa_mc-avg-cons, replace)
	
	graph export graphs/hsb2015pa_mc-avg-cons.eps, replace
	
graph bar bias_b_lambda bias_g_lambda bias_unc_lambda, over(cens, label(labsize(small))) over(rho) scheme(s1mono) ///
	bar(1, color(gs0)) bar(2, color(gs10) lcolor(gs0)) bar(3, color(gs15) lcolor(gs0))  ///
	title(Spatial Lag Parameter) ///
	legend(off) ///
	fxsize(100) fysize(50) ///
	name(bias_lambda, replace) ///
	saving(graphs/hsb2015pa_mc-avg-lambda, replace)
	
	graph export graphs/hsb2015pa_mc-avg-lambda.eps, replace
  
  
graph combine bias_lambda bias_cons bias_x1, scheme(s1mono) ///
	imargin(tiny) ///
	rows(3) ///
	xsize(5) ysize(8)  ///
	saving(graphs/hsb2015pa_mc-bias-combined, replace)
	
	graph export graphs/hsb2015pa_mc-bias-combined.eps, replace
  
		/* Clean them up for slides. */

graph bar bias_b_x1 bias_g_x1 bias_d_x1 bias_unc_x1, over(cens, label(labsize(small))) over(rho) scheme(s1color) ///
	bar(1, color(navy)) bar(2, color(brown)) bar(3, color(dkgreen)) bar(4, color(purple)) ///
	legend(rows(1) label(1 Both) label(2 Spatial) label(3 Censoring) label(4 Benchmark) order(1 2 3 4) size(medsmall)) ///
	xsize(5) ysize(3) ///
	saving(graphs/hsb2015pa_mc-avg-x1-color, replace)
	
	graph export graphs/hsb2015pa_mc-avg-x1-color.eps, replace
  
graph bar bias_b_cons bias_g_cons bias_d_cons bias_unc_cons, over(cens, label(labsize(small))) over(rho) scheme(s1mono) ///
	bar(1, color(navy)) bar(2, color(brown)) bar(3, color(dkgreen)) bar(4, color(purple)) ///
	legend(rows(1) label(1 Both) label(2 Spatial) label(3 Censoring) label(4 Benchmark) order(1 2 3 4) size(medsmall)) ///
	xsize(5) ysize(3) ///
	saving(graphs/hsb2015pa_mc-avg-cons-color, replace)
	
	graph export graphs/hsb2015pa_mc-avg-cons-color.eps, replace
	
graph bar bias_b_lambda bias_g_lambda bias_unc_lambda, over(cens, label(labsize(small))) over(rho) scheme(s1mono) ///
	bar(1, color(navy)) bar(2, color(brown)) bar(3, color(purple)) ///
	legend(rows(1) label(1 Both) label(2 Spatial) label(3 Benchmark) order(1 2 3 4) size(medsmall)) ///
	xsize(5) ysize(3) ///
	saving(graphs/hsb2015pa_mc-avg-lambda-color, replace)
	
	graph export graphs/hsb2015pa_mc-avg-lambda-color.eps, replace
  
		/* Do some RMSE graphs. */

graph bar rmse_b_x1 rmse_g_x1 rmse_d_x1 rmse_unc_x1, over(cens, label(labsize(small))) over(rho) scheme(s1color) ///
	bar(1, color(navy)) bar(2, color(brown)) bar(3, color(dkgreen)) bar(4, color(cranberry)) ///
	legend(rows(1) label(1 Both) label(2 Spatial) label(3 Censoring) label(4 Benchmark) order(1 2 3 4)) ///
	xsize(5) ysize(3) ///
	saving(graphs/hsb2015pa_mc-rmse-x1, replace)
	
	graph export graphs/hsb2015pa_mc-rmse-x1.eps, replace
  
graph bar rmse_b_cons rmse_g_cons rmse_unc_cons rmse_d_cons, over(cens, label(labsize(small))) over(rho) scheme(s1color) ///
	bar(1, color(navy)) bar(2, color(brown)) bar(3, color(dkgreen)) bar(4, color(cranberry)) ///
	legend(rows(1) label(1 Both) label(2 Spatial) label(3 Benchmark) label(4 Censoring) order(1 2 4 3)) ///
	xsize(5) ysize(3) ///
	saving(graphs/hsb2015pa_mc-rmse-cons, replace)
	
	graph export graphs/hsb2015pa_mc-rmse-cons.eps, replace
  
graph bar rmse_b_lambda rmse_g_lambda rmse_unc_lambda, over(cens, label(labsize(small))) over(rho) scheme(s1color) ///
	bar(1, color(navy)) bar(2, color(brown)) bar(3, color(dkgreen)) ///
	legend(rows(1) label(1 Both) label(2 Spatial) label(3 Benchmark) order(1 2 3)) ///
	xsize(5) ysize(3) ///
	saving(graphs/hsb2015pa_mc-rmse-lambda, replace)
	
	graph export graphs/hsb2015pa_mc-rmse-lambda.eps, replace
 
		/* Redo these just to make combine easier. */
 
graph bar rmse_b_x1 rmse_g_x1 rmse_d_x1 rmse_unc_x1, over(cens, label(labsize(small))) over(rho) scheme(s1mono) ///
	bar(1, color(gs0)) bar(2, color(gs5) lcolor(gs0)) bar(3, color(gs10) lcolor(gs0)) bar(4, color(gs15) lcolor(gs0))  ///
	title(Coefficient on X1) ///
	fxsize(100) fysize(57) ///
	legend(rows(1) label(1 Both) label(2 Spatial) label(3 Censoring) label(4 Benchmark) order(1 2 3 4) size(small)) ///
	name(rmse_bx1, replace)
	
graph bar rmse_b_cons rmse_g_cons rmse_d_cons rmse_unc_cons, over(cens, label(labsize(small))) over(rho) scheme(s1mono) ///
	bar(1, color(gs0)) bar(2, color(gs5) lcolor(gs0)) bar(3, color(gs10) lcolor(gs0)) bar(4, color(gs15) lcolor(gs0))  ///
	title(Intercept) ///
	legend(off) ///
	fxsize(100) fysize(50) ///
	name(rmse_cons, replace)
	
graph bar rmse_b_lambda rmse_g_lambda rmse_unc_lambda, over(cens, label(labsize(small))) over(rho) scheme(s1mono) ///
	bar(1, color(gs0)) bar(2, color(gs10) lcolor(gs0)) bar(3, color(gs15) lcolor(gs0)) ///
	title(Spatial Lag Parameter) ///
	fxsize(100) fysize(50) ///
	legend(off) ///
	name(rmse_lambda, replace)
 
graph combine rmse_lambda rmse_cons rmse_bx1, scheme(s1mono) ///
	imargin(tiny) ///
	rows(3) ///
	xsize(5) ysize(8)  ///
	saving(graphs/hsb2015pa_mc-rmse-combined, replace)
	
	graph export graphs/hsb2015pa_mc-rmse-combined.eps, replace
  
		/* Output summary tables for the MC. */

preserve
		
format %9.3f *b_* *g_* *d_* *unc_*
		
listtab cens rho b_x1 g_x1 d_x1 unc_x1 bias_b_x1 bias_g_x1 bias_d_x1 bias_unc_x1 ///
	se_b_x1 se_g_x1 se_d_x1 se_unc_x1 sd_b_x1 sd_g_x1 sd_d_x1 sd_unc_x1  ///
	rmse_b_x1 rmse_g_x1 rmse_d_x1 rmse_unc_x1 using tables/hsb2015pa_mc-b.tex, replace ///
	rstyle(tabular) nolabel
  
listtab cens rho b_cons g_cons d_cons unc_cons bias_b_cons bias_g_cons bias_d_cons bias_unc_cons ///
	se_b_cons se_g_cons se_d_cons se_unc_cons sd_b_cons sd_g_cons sd_d_cons sd_unc_cons ///
	rmse_b_cons rmse_g_cons rmse_d_cons rmse_unc_cons using tables/hsb2015pa_mc-cons.tex, replace ///
	rstyle(tabular) nolabel
  
listtab cens rho b_lambda g_lambda unc_lambda bias_b_lambda bias_g_lambda bias_unc_lambda ///
	se_b_lambda se_g_lambda se_unc_lambda sd_b_lambda sd_g_lambda sd_unc_lambda ///
	rmse_b_lambda rmse_g_lambda rmse_unc_lambda using tables/hsb2015pa_mc-lambda.tex, replace ///
	rstyle(tabular) nolabel

restore
  
		/* Set up string variable of rho to reshape by. */

generat rho_str = string(rho,"%9.2f")

  replace rho_str = subinstr(rho_str, ".", "_", .)
  replace rho_str = "_" + rho_str
  drop rho iterations

reshape wide b_* g_* d_* unc_* se* sd* rmse* bias* cens_pct pct_cnvg, i(cens) j(rho_str) string

  order cens b* se* sd* rmse* bias*

  foreach var of varlist *_0_00 {
  
	label variable `var' 	"rho=0"

	}
	  
  foreach var of varlist *_0_25 {
  
	label variable `var' 	"rho=0.25"

	}
	  
  foreach var of varlist *_0_50 {
  
	label variable `var' 	"rho=0.5"

	}
  
  foreach var of varlist *_0_75 {
  
	label variable `var' 	"rho=0.75"

	}
  
		/* Graphs of the the estimation and data features. */
  
graph bar pct_cnvg_0_00 pct_cnvg_0_25 pct_cnvg_0_50 pct_cnvg_0_75, scheme(s1mono) over(cens) ///
	ytitle(Proportion of Cases Converging)  ///
	legend(rows(1) label(1 "rho=0") label(2 "rho=0.25") label(3 "rho=0.5") label(4 "rho=0.75")) ///
	saving(graphs/hsb2015pa_mc_pct_cnvg, replace)
	
	graph export graphs/hsb2015pa_mc_pct_cnvg.eps, replace

graph bar cens_pct_0_00 cens_pct_0_25 cens_pct_0_50 cens_pct_0_75, scheme(s1mono) over(cens) ///
	ytitle(Proportion of Cases Censored)  ///
	legend(rows(1) label(1 "rho=0") label(2 "rho=0.25") label(3 "rho=0.5") label(4 "rho=0.75")) ///
	saving(graphs/hsb2015pa_mc_censpct, replace)
	
	graph export graphs/hsb2015pa_mc_censpct.eps, replace

		/* Graphs of the average estimates. */
  
twoway connected b_x1_0_00 b_x1_0_25 b_x1_0_50 b_x1_0_75 cens, scheme(s1color) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(-1, lcolor(gs10) lpattern(dash)) ///
	legend(rows(1)) ///
	saving(graphs/hsb2015pa_mc_bx1, replace)
	
	graph export graphs/hsb2015pa_mc_bx1.eps, replace

twoway connected b_x1_0_00 b_x1_0_25 b_x1_0_50 b_x1_0_75 unc_x1_0_00 unc_x1_0_25 unc_x1_0_50 unc_x1_0_75 cens, scheme(s1color) ///
	lpattern(solid solid solid solid dash dash dash dash) ///
	lcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	mcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	msymbol(O O O O S S S S) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(-1, lcolor(gs10) lpattern(dash)) ///
	legend(rows(2) order(- "Both: " 1 2 3 4 - "Benchmark: " 5 6 7 8)) ///
	saving(graphs/hsb2015pa_mc_bx1_uncx1, replace)
	
	graph export graphs/hsb2015pa_mc_bx1_gx1.eps, replace

twoway connected b_x1_0_00 b_x1_0_25 b_x1_0_50 b_x1_0_75 g_x1_0_00 g_x1_0_25 g_x1_0_50 g_x1_0_75 cens, scheme(s1color) ///
	lpattern(solid solid solid solid dash dash dash dash) ///
	lcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	mcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	msymbol(O O O O S S S S) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(-1, lcolor(gs10) lpattern(dash)) ///
	legend(rows(2) order(- "Both: " 1 2 3 4 - "Spatial: " 5 6 7 8) size(small)) ///
	saving(graphs/hsb2015pa_mc_bx1_gx1, replace)
	
	graph export graphs/hsb2015pa_mc_bx1_gx1.eps, replace

twoway connected b_x1_0_00 b_x1_0_25 b_x1_0_50 b_x1_0_75 g_x1_0_00 g_x1_0_25 g_x1_0_50 g_x1_0_75  ///
	unc_x1_0_00 unc_x1_0_25 unc_x1_0_50 unc_x1_0_75 d_x1_0_00 d_x1_0_25 d_x1_0_50 d_x1_0_75 cens, scheme(s1color) ///
	lpattern(solid solid solid solid dash dash dash dash dot dot dot dot dash_dot dash_dot dash_dot dash_dot) ///
	lcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	mcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	msymbol(O O O O S S S S T T T T D D D D) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(-1, lcolor(gs10) lpattern(dash)) ///
	legend(rows(4) order(- "Both: " 1 2 3 4 - "Spatial: " 5 6 7 8 - "Benchmark: " 9 10 11 12 - "Censoring: " 13 14 15 16) ///
	  size(small)) ///
	name(bx1, replace) ///
	saving(graphs/hsb2015pa_mc_bx1_gx1_uncx1, replace)
	
	graph export graphs/hsb2015pa_mc_bx1_gx1_uncx1.eps, replace

twoway connected b_cons_0_00 b_cons_0_25 b_cons_0_50 b_cons_0_75 cens, scheme(s1color) ///
	lcolor(dkgreen orange_red navy purple) ///
	mcolor(dkgreen orange_red navy purple) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(-1, lcolor(gs10) lpattern(dash)) ///
	legend(rows(1)) ///
	saving(graphs/hsb2015pa_mc_bcons, replace)
	
	graph export graphs/hsb2015pa_mc_bcons.eps, replace

twoway connected b_cons_0_00 b_cons_0_25 b_cons_0_50 b_cons_0_75 g_cons_0_00 g_cons_0_25 g_cons_0_50 g_cons_0_75 ///
	unc_cons_0_00 unc_cons_0_25 unc_cons_0_50 unc_cons_0_75 d_cons_0_00 d_cons_0_25 d_cons_0_50 d_cons_0_75 cens, scheme(s1color) ///
	lpattern(solid solid solid solid dash dash dash dot dot dot dot dash_dot dash_dot dash_dot dash_dot) ///
	lcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	mcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	msymbol(O O O O S S S S T T T T D D D D) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(-1, lcolor(gs10) lpattern(dash)) ///
	legend(rows(4) order(- "Both: " 1 2 3 4 - "Spatial: " 5 6 7 8 - "Benchmark: " 9 10 11 12 - "Censoring: " 13 14 15 16) ///
	  size(small)) ///
	name(cons, replace) ///
	saving(graphs/hsb2015pa_mc_cons, replace)
	
	graph export graphs/hsb2015pa_mc_cons.eps, replace

twoway connected b_lambda_0_00 b_lambda_0_25 b_lambda_0_50 b_lambda_0_75 cens, scheme(s1color) ///
	lcolor(dkgreen orange_red navy purple) ///
	mcolor(dkgreen orange_red navy purple) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(0, lcolor(gs10) lpattern(dash)) ///
	yline(0.25, lcolor(gs10) lpattern(dash)) ///
	yline(0.5, lcolor(gs10) lpattern(dash)) ///
	yline(0.75, lcolor(gs10) lpattern(dash)) ///
	legend(rows(1) order(1 2 3 4)) ///
	saving(graphs/hsb2015pa_mc_b_lambda, replace)
	
	graph export graphs/hsb2015pa_mc_b_lambda.eps, replace
	
twoway connected b_lambda_0_00 b_lambda_0_25 b_lambda_0_50 b_lambda_0_75 unc_lambda_0_00 unc_lambda_0_25 unc_lambda_0_50 unc_lambda_0_75 cens, scheme(s1color) ///
	lpattern(solid solid solid solid dash dash dash dash) ///
	lcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	mcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	msymbol(O O O S S S) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(0, lcolor(gs10) lpattern(dash)) ///
	yline(0.25, lcolor(gs10) lpattern(dash)) ///
	yline(0.5, lcolor(gs10) lpattern(dash)) ///
	legend(rows(2) order(- "Both: " 1 2 3 4 - "Spatial: " 5 6 7 8) size(small)) ///
	saving(graphs/hsb2015pa_mc_b_lambda_unc_lambda, replace)
	
	graph export graphs/hsb2015pa_mc_b_lambda_unc_lambda.eps, replace
	
twoway connected b_lambda_0_00 b_lambda_0_25 b_lambda_0_50 b_lambda_0_75 g_lambda_0_00 g_lambda_0_25 g_lambda_0_50 g_lambda_0_75 ///
	unc_lambda_0_00 unc_lambda_0_25 unc_lambda_0_50 unc_lambda_0_75 cens, scheme(s1color) ///
	lpattern(solid solid solid solid dash dash dash dash dot dot dot dot) ///
	lcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	mcolor(dkgreen orange_red navy purple dkgreen orange_red navy purple dkgreen orange_red navy purple) ///
	msymbol(O O O O S S S S T T T T) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(0, lcolor(gs10) lpattern(dash)) ///
	yline(0.25, lcolor(gs10) lpattern(dash)) ///
	yline(0.5, lcolor(gs10) lpattern(dash)) ///
	yline(0.75, lcolor(gs10) lpattern(dash)) ///
	legend(rows(3) order(- "Both: " 1 2 3 4 - "Spatial: " 5 6 7 8 - "Benchmark: " 9 10 11 12) size(small)) ///
	name(lambda, replace) ///
	saving(graphs/hsb2015pa_mc_lambda, replace)
	
	graph export graphs/hsb2015pa_mc_lambda.eps, replace
		
twoway connected b_sigma2_0_00 b_sigma2_0_25 b_sigma2_0_50 b_sigma2_0_75 cens, scheme(s1color) ///
	lcolor(dkgreen orange_red navy purple) ///
	mcolor(dkgreen orange_red navy purple) ///
	xtitle(Censoring Point) ///
	xlabel(-1(0.5)0.5) ///
	ylabel(#5, grid) ///
	yline(1, lcolor(gs10) lpattern(dash)) ///
	legend(rows(1) order(1 2 3 4)) ///
	saving(graphs/hsb2015pa_mc_b_sigma2, replace)
	
	graph export graphs/hsb2015pa_mc_b_sigma2.eps, replace

	/* Do SE/SD comparisons. */
	
graph bar se_unc_x1_0_00 sd_unc_x1_0_00 se_unc_x1_0_25 sd_unc_x1_0_25 se_unc_x1_0_50 sd_unc_x1_0_50 se_unc_x1_0_75 sd_unc_x1_0_75, over(cens) scheme(s1color) ///
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50)) ///
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50)) ///
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50)) ///
	bar(7, color(purple) fintensity(inten100)) bar(8, color(purple) fintensity(inten50)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-uncx1, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-uncx1.eps, replace
	
graph bar se_b_x1_0_00 sd_b_x1_0_00 se_b_x1_0_25 sd_b_x1_0_25 se_b_x1_0_50 sd_b_x1_0_50 se_b_x1_0_75 sd_b_x1_0_75, over(cens) scheme(s1color) ///
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50)) ///
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50)) ///
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50)) ///
	bar(7, color(purple) fintensity(inten100)) bar(8, color(purple) fintensity(inten50)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-bx1, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-bx1.eps, replace
	
graph bar se_b_x1_0_00 sd_b_x1_0_00 se_b_x1_0_25 sd_b_x1_0_25 se_b_x1_0_50 sd_b_x1_0_50 se_b_x1_0_75 sd_b_x1_0_75, over(cens) scheme(s1mono) ///
	bar(1, color(gs0) lcolor(gs0)) bar(2, color(gs2) lcolor(gs0)) ///
	bar(3, color(gs4) lcolor(gs0)) bar(4, color(gs6) lcolor(gs0)) ///
	bar(5, color(gs8) lcolor(gs0)) bar(6, color(gs10) lcolor(gs0)) ///
	bar(7, color(gs12) lcolor(gs0)) bar(8, color(gs14) lcolor(gs0)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-bx1-bw, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-bx1-bw.eps, replace
	
		/* Repeat this one in black and white. */
	
graph bar se_b_cons_0_00 sd_b_cons_0_00 se_b_cons_0_25 sd_b_cons_0_25 se_b_cons_0_50 sd_b_cons_0_50 se_b_cons_0_75 sd_b_cons_0_75, over(cens) scheme(s1color) ///
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50)) ///
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50)) ///
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50)) ///
	bar(7, color(purple) fintensity(inten100)) bar(8, color(purple) fintensity(inten50)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-cons, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-cons.eps, replace
	
graph bar se_b_lambda_0_00 sd_b_lambda_0_00 se_b_lambda_0_25 sd_b_lambda_0_25 se_b_lambda_0_50 sd_b_lambda_0_50 se_b_lambda_0_75 sd_b_lambda_0_75, over(cens) scheme(s1color) ///
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50)) ///
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50)) ///
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50)) ///
	bar(7, color(purple) fintensity(inten100)) bar(8, color(purple) fintensity(inten50)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-lambda, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-lambda.eps, replace

graph bar se_g_x1_0_00 sd_g_x1_0_00 se_g_x1_0_25 sd_g_x1_0_25 se_g_x1_0_50 sd_g_x1_0_50 se_g_x1_0_75 sd_g_x1_0_75, over(cens) scheme(s1color) ///
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50)) ///
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50)) ///
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50)) ///
	bar(7, color(purple) fintensity(inten100)) bar(8, color(purple) fintensity(inten50)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-gx1, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-gx1.eps, replace
	
graph bar se_g_cons_0_00 sd_g_cons_0_00 se_g_cons_0_25 sd_g_cons_0_25 se_g_cons_0_50 sd_g_cons_0_50 se_g_cons_0_75 sd_g_cons_0_75, over(cens) scheme(s1color) ///
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50)) ///
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50)) ///
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50)) ///
	bar(7, color(purple) fintensity(inten100)) bar(8, color(purple) fintensity(inten50)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-g_cons, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-g_cons.eps, replace
	
graph bar se_g_lambda_0_00 sd_g_lambda_0_00 se_g_lambda_0_25 sd_g_lambda_0_25 se_g_lambda_0_50 sd_g_lambda_0_50 se_g_lambda_0_75 sd_g_lambda_0_75, over(cens) scheme(s1color) ///
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50)) ///
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50)) ///
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50)) ///
	bar(7, color(purple) fintensity(inten100)) bar(8, color(purple) fintensity(inten50)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-g_lambda, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-g_lambda.eps, replace

graph bar se_d_x1_0_00 sd_d_x1_0_00 se_d_x1_0_25 sd_d_x1_0_25 se_d_x1_0_50 sd_d_x1_0_50 se_d_x1_0_75 sd_d_x1_0_75, over(cens) scheme(s1color) ///
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50)) ///
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50)) ///
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50)) ///
	bar(7, color(purple) fintensity(inten100)) bar(8, color(purple) fintensity(inten50)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-dx1, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-dx1.eps, replace
	
graph bar se_d_cons_0_00 sd_d_cons_0_00 se_d_cons_0_25 sd_d_cons_0_25 se_d_cons_0_50 sd_d_cons_0_50 se_d_cons_0_75 sd_d_cons_0_75, over(cens) scheme(s1color) ///
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50)) ///
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50)) ///
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50)) ///
	bar(7, color(purple) fintensity(inten100)) bar(8, color(purple) fintensity(inten50)) ///
	legend(label(1 SE (rho=0)) label(2 SD (rho=0)) label(3 SE (rho=0.25)) label(4 SD (rho=0.25)) ///
	   label(5 SE (rho=0.5)) label(6 SD (rho=0.5))  label(7 SE (rho=0.75)) label(8 SD (rho=0.75))) ///
	saving(graphs/hsb2015pa_mc-se-sd-d_cons, replace)
	
	graph export graphs/hsb2015pa_mc-se-sd-d_cons.eps, replace
	

grc1leg bx1 cons lambda, scheme(s1color) ///
	imargin(tiny) ///
	rows(3) ///
	xsize(8) ysize(4) 
	
log close
