//=======================================================================================
// SOLO ANALYSIS OF RA DATA. VECTORIZED FOR STATA/MP.
// CODES BELOW ASSUME CRRA UTILITY, u(X) = X^(1-rra)/(1-rra), and one or two-parameter Prelec weighting
// rra1 :* (rra1 :>= 1.0000001 :| rra1 :<= 0.9999999) + 0.9999999 :* (rra1 :> 0.9999999 :& rra1 :< 1) + 1.0000001 :* (rra1 :< 1.0000001 :& rra1 :>= 1)
//=======================================================================================

//--- EUT MODELS ---------------------------------------------------------------
// ML_CRRA_12:      CRRA EUT MODEL; NO RANDOM COEF/EFFECT -- NO SAMPLE SELECTION -- FOR PHASE 1 AND PHASE 2
//
// MSL_CRRA_RC_12:  CRRA EUT MODEL W/ RANDOM COEF  -- NO SAMPLE SELECTION -- FOR PHASE 1 AND PHASE 2
//				 Allows for full correlation between random coefficients. 
// MSL_CRRA_RC_H12: CRRA EUT MODEL W/ RANDOM COEF + SELECTION
//				 Allows for full correlation between random coefficients and selection errors.
//
// MSL_CRRA_RC_A12: CRRA EUT MODEL W/ RANDOM COEF + SELECTION
//				 A special case of H12 that assumes no initial selection bias & only corrects for attrition bias
//------------------------------------------------------------------------------

//--- RDU MODELS ---------------------------------------------------------------
// ML_CRRA1PRE_12:      CRRA & 1-PARAMETER PRELEC; NO RANDOM COEF/EFFECT -- NO SAMPLE SELECTION -- FOR PHASE 1 AND PHASE 2
//
// MSL_CRRA1PRE_RC_12:  CRRA & 1-PARAMETER PRELEC; RANDOM COEF    -- NO SAMPLE SELECTION -- FOR PHASE 1 AND PHASE 2
// 				       Allows for full correlation between random coefficients.		
// MSL_CRRA1PRE_RC_H12: CRRA & 1-PARAMETER PRELEC; RANDOM COEF + SELECTION
//				       Allows for full correlation between random coefficients and selection errors. 
//
// MSL_CRRA1PRE_RC_A12: CRRA & 1-PARAMETER PRELEC; RANDOM COEF + SELECTION
//					    A special case of H12 that assumes no initial selection bias & only corrects for attrition bias
//
// ML_CRRA2PRE_12:      CRRA & 2-PARAMETER PRELEC; NO RANDOM COEF/EFFECT -- NO SAMPLE SELECTION -- FOR PHASE 1 AND PHASE 2
//
// MSL_CRRA2PRE_RC_12:  CRRA & 2-PARAMETER PRELEC; RANDOM COEF    -- NO SAMPLE SELECTION -- FOR PHASE 1 AND PHASE 2
// 				       Allows for full correlation between random coefficients.		
// MSL_CRRA2PRE_RC_H12: CRRA & 2-PARAMETER PRELEC; RANDOM COEF + SELECTION
//				       Allows for full correlation between random coefficients and selection errors. 
//------------------------------------------------------------------------------

mata:
void ML_CRRA_12(M, b, lnf)
{
	// load parameters to estimate
	rra1   = moptimize_util_xb(M,b,1)
	rra2   = moptimize_util_xb(M,b,2)
	LNmuRA = moptimize_util_xb(M,b,3) 

	// transform parameters
	rra1 = rra1 :* (rra1 :>= 1.0000001 :| rra1 :<= 0.9999999) + 0.9999999 :* (rra1 :> 0.9999999 :& rra1 :< 1) + 1.0000001 :* (rra1 :< 1.0000001 :& rra1 :>= 1)
	rra2 = rra2 :* (rra2 :>= 1.0000001 :| rra2 :<= 0.9999999) + 0.9999999 :* (rra2 :> 0.9999999 :& rra2 :< 1) + 1.0000001 :* (rra2 :< 1.0000001 :& rra2 :>= 1)	
	muRA = exp(LNmuRA)	
	
	// choice variable 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	repeat = 2*moptimize_util_depvar(M,7) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))

	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1 = (omega :+ mMIN):^(1 :- rra1) :/ (1 :- rra1) 
		urMAX_1 = (omega :+ mMAX):^(1 :- rra1) :/ (1 :- rra1)
		
		urMIN_2 = (omega :+ mMIN):^(1 :- rra2) :/ (1 :- rra2)
		urMAX_2 = (omega :+ mMAX):^(1 :- rra2) :/ (1 :- rra2)		
	}

	// utility of all prizes  
	yA1_1 = (omega :+ mA1):^(1 :- rra1) :/ (1 :- rra1) 
	yA2_1 = (omega :+ mA2):^(1 :- rra1) :/ (1 :- rra1) 
	yB1_1 = (omega :+ mB1):^(1 :- rra1) :/ (1 :- rra1) 
	yB2_1 = (omega :+ mB2):^(1 :- rra1) :/ (1 :- rra1) 
	
	yA1_2 = (omega :+ mA1):^(1 :- rra2) :/ (1 :- rra2)
	yA2_2 = (omega :+ mA2):^(1 :- rra2) :/ (1 :- rra2)
	yB1_2 = (omega :+ mB1):^(1 :- rra2) :/ (1 :- rra2)
	yB2_2 = (omega :+ mB2):^(1 :- rra2) :/ (1 :- rra2)
	
	// probability weighting
	wp1_1 = prob1
	wp2_1 = prob2 
	
	wp1_2 = prob1
	wp2_2 = prob2 
	
	// compute V-distance and index 
	euA_1 = wp1_1 :* yA1_1 + wp2_1 :* yA2_1
	euB_1 = wp1_1 :* yB1_1 + wp2_1 :* yB2_1
	
	euA_2 = wp1_2 :* yA1_2 + wp2_2 :* yA2_2
	euB_2 = wp1_2 :* yB1_2 + wp2_2 :* yB2_2
	
	if (st_global("contextual") == "y") {
		RAdiff1 = (euB_1 - euA_1) :/ muRA :/ abs(urMAX_1 - urMIN_1)
		RAdiff2 = (euB_2 - euA_2) :/ muRA :/ abs(urMAX_2 - urMIN_2)
	}
	else {
		RAdiff1 = (euB_1 - euA_1) :/ muRA 
		RAdiff2 = (euB_2 - euA_2) :/ muRA 	
	}
	
	// log-likelihood contribution from Phase I
	lnf_m1 = lnnormal( RAdiff1) :* (choice :==  1 :& repeat :== -1) + ///
			 lnnormal(-RAdiff1) :* (choice :== -1 :& repeat :== -1)
	
	// log-likelihood contribution from Phase II
	lnf_m2 = lnnormal( RAdiff2) :* (choice :==  1 :& repeat :==  1) + ///
			 lnnormal(-RAdiff2) :* (choice :== -1 :& repeat :==  1) 
	
	// grand log-likelihood
	lnf = quadrowsum((lnf_m1, lnf_m2),0)
	_editvalue(lnf, 0, .)	
}
end

//////

mata:
void MSL_CRRA_RC_12(M, todo, b, lnfj, S, H)
{
	// choice variable as [N x 1] vector 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs as [N x 1] vectors	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	
	// wave identifier as [N x 1] vector
	repeat = 2*moptimize_util_depvar(M,7) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))
	
	// load each non-Choleksy parameter as [N x 1] vector
	rra1   = moptimize_util_xb(M,b,1) :* J(rows(choice),1,1) 
	rra2   = moptimize_util_xb(M,b,2) :* J(rows(choice),1,1) 
	LNmuRA = moptimize_util_xb(M,b,3) :* J(rows(choice),1,1) 
	
	// load each Choleksy factor as scalar
	c11 = moptimize_util_xb(M,b,4)
	c21 = moptimize_util_xb(M,b,5)
	c22 = moptimize_util_xb(M,b,6)

	// load number of simulated draws
	external nrep

	// load [N x 1] vector of subject id
	external id
	
	// load [N x N_panel] matrix of subject dummies
	external idDV
	
	// load [N x nrep] matrices of N(0,1) draws from Halton sequences
	external ERR1, ERR2
	
	// tell Stata that we intend to specify log-likelihood for each subject
	moptimize_init_by(M,id)		

	// convert [N x 1] mean parameter vectors into [N x nrep] matrices and generate draws of random parameters
	COPY = J(rows(choice),nrep,1)	
	rra1_draw   = rra1 :* COPY :+ c11 * ERR1
	rra2_draw   = rra2 :* COPY :+ c21 * ERR1 :+ c22 * ERR2
	LNmuRA_draw = LNmuRA :* COPY	

	// transform parameters, [N x nrep] matrices
	rra1_draw = rra1_draw :* (rra1_draw :>= 1.0000001 :| rra1_draw :<= 0.9999999) + 0.9999999 :* (rra1_draw :> 0.9999999 :& rra1_draw :< 1) + 1.0000001 :* (rra1_draw :< 1.0000001 :& rra1_draw :>= 1)
	rra2_draw = rra2_draw :* (rra2_draw :>= 1.0000001 :| rra2_draw :<= 0.9999999) + 0.9999999 :* (rra2_draw :> 0.9999999 :& rra2_draw :< 1) + 1.0000001 :* (rra2_draw :< 1.0000001 :& rra2_draw :>= 1)	
	muRA_draw =	exp(LNmuRA_draw)
	
	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1_draw = (omega :+ mMIN):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		urMAX_1_draw = (omega :+ mMAX):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		
		urMIN_2_draw = (omega :+ mMIN):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
		urMAX_2_draw = (omega :+ mMAX):^(1 :- rra2_draw) :/ (1 :- rra2_draw)		
	}

	// utility of all prizes  
	yA1_1_draw = (omega :+ mA1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yA2_1_draw = (omega :+ mA2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB1_1_draw = (omega :+ mB1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB2_1_draw = (omega :+ mB2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)	
	
	yA1_2_draw = (omega :+ mA1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yA2_2_draw = (omega :+ mA2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB1_2_draw = (omega :+ mB1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB2_2_draw = (omega :+ mB2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)	
	
	// probability weighting
	wp1_1_draw = prob1 :* COPY 
	wp2_1_draw = prob2 :* COPY
	
	wp1_2_draw = prob1 :* COPY
	wp2_2_draw = prob2 :* COPY
	
	// compute V-distance and index 
	euA_1_draw = wp1_1_draw :* yA1_1_draw + wp2_1_draw :* yA2_1_draw
	euB_1_draw = wp1_1_draw :* yB1_1_draw + wp2_1_draw :* yB2_1_draw
	
	euA_2_draw = wp1_2_draw :* yA1_2_draw + wp2_2_draw :* yA2_2_draw
	euB_2_draw = wp1_2_draw :* yB1_2_draw + wp2_2_draw :* yB2_2_draw
	
	if (st_global("contextual") == "y") {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw :/ abs(urMAX_1_draw - urMIN_1_draw) 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw :/ abs(urMAX_2_draw - urMIN_2_draw) 
	}
	else {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw 	
	}
	
	// generate [N x nrep] matrix of observation-level log-likelihood values given each draw
	lnProb_RA = lnnormal( RAdiff1_draw) :* (repeat :== -1 :& choice :==  1) + ///
			    lnnormal(-RAdiff1_draw) :* (repeat :== -1 :& choice :== -1) + ///
			    lnnormal( RAdiff2_draw) :* (repeat :==  1 :& choice :==  1) + ///
			    lnnormal(-RAdiff2_draw) :* (repeat :==  1 :& choice :== -1)	
		
	// generate [N_panel x nrep] matrix of subject-level likelihood values given each draw
	ProbSeq_RA = exp(idDV' * lnProb_RA)

	// generate [N_panel x 1] vector of subject-level log-simulated likelihood value (log of mean of ProbSeq)
	lnfj = ln(quadrowsum(ProbSeq_RA,1)) :- ln(nrep)
}	
end

//////

mata:
void MSL_CRRA_RC_H12(M, todo, b, lnfj, S, H)
{
	// choice variable as [N x 1] vector 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs as [N x 1] vectors	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	
	// selection variables as [N x 1] vectors
	select1 = 2*moptimize_util_depvar(M,7) :- 1
	select2 = 2*moptimize_util_depvar(M,8) :- 1
	
	// wave identifier and within-wave first obs identifier as [N x 1] vectors
	repeat = 2*moptimize_util_depvar(M,9)  :- 1
	first  = 2*moptimize_util_depvar(M,10) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))
	
	// load each non-Choleksy parameter as [N x 1] vector
	sel1   = moptimize_util_xb(M,b,1) :* J(rows(choice),1,1) 
	sel2   = moptimize_util_xb(M,b,2) :* J(rows(choice),1,1) 
	rra1   = moptimize_util_xb(M,b,3) :* J(rows(choice),1,1) 
	rra2   = moptimize_util_xb(M,b,4) :* J(rows(choice),1,1) 
	LNmuRA = moptimize_util_xb(M,b,5) :* J(rows(choice),1,1) 
	
	// load each Choleksy factor as scalar
	c21 = moptimize_util_xb(M,b,6)
	c31 = moptimize_util_xb(M,b,7)
	c32 = moptimize_util_xb(M,b,8)
	c33 = moptimize_util_xb(M,b,9)
	c41 = moptimize_util_xb(M,b,10)
	c42 = moptimize_util_xb(M,b,11)
	c43 = moptimize_util_xb(M,b,12)
	c44 = moptimize_util_xb(M,b,13)
	
	// normalize scale of selection coefficients to that of standard normal probit  
	sel1 = sel1 * sqrt(2)
	sel2 = sel2 * sqrt(2 + c21^2)

	// load number of simulated draws
	external nrep

	// load [N x 1] vector of subject id
	external id
	
	// load [N x N_panel] matrix of subject dummies
	external idDV
	
	// load [N x nrep] matrices of N(0,1) draws from Halton sequences
	external ERR1, ERR2, ERR3, ERR4	
	
	// tell Stata that we intend to specify log-likelihood for each subject
	moptimize_init_by(M,id)			

	// convert [N x 1] mean parameter vectors into [N x nrep] matrices and generate draws of random parameters
	COPY = J(rows(choice),nrep,1)	
	sel1_draw	= sel1 :* COPY :+       ERR1 
	sel2_draw   = sel2 :* COPY :+ c21 * ERR1 :+       ERR2
	rra1_draw   = rra1 :* COPY :+ c31 * ERR1 :+ c32 * ERR2 :+ c33 * ERR3 
	rra2_draw   = rra2 :* COPY :+ c41 * ERR1 :+ c42 * ERR2 :+ c43 * ERR3 :+ c44 * ERR4
	LNmuRA_draw = LNmuRA :* COPY
	
	// transform parameters, [N x nrep] matrices
	rra1_draw = rra1_draw :* (rra1_draw :>= 1.0000001 :| rra1_draw :<= 0.9999999) + 0.9999999 :* (rra1_draw :> 0.9999999 :& rra1_draw :< 1) + 1.0000001 :* (rra1_draw :< 1.0000001 :& rra1_draw :>= 1)
	rra2_draw = rra2_draw :* (rra2_draw :>= 1.0000001 :| rra2_draw :<= 0.9999999) + 0.9999999 :* (rra2_draw :> 0.9999999 :& rra2_draw :< 1) + 1.0000001 :* (rra2_draw :< 1.0000001 :& rra2_draw :>= 1)				
	muRA_draw =	exp(LNmuRA_draw)
	
	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1_draw = (omega :+ mMIN):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		urMAX_1_draw = (omega :+ mMAX):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		
		urMIN_2_draw = (omega :+ mMIN):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
		urMAX_2_draw = (omega :+ mMAX):^(1 :- rra2_draw) :/ (1 :- rra2_draw)		
	}
	
	// utility of all prizes  
	yA1_1_draw = (omega :+ mA1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yA2_1_draw = (omega :+ mA2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB1_1_draw = (omega :+ mB1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB2_1_draw = (omega :+ mB2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)	
	
	yA1_2_draw = (omega :+ mA1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yA2_2_draw = (omega :+ mA2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB1_2_draw = (omega :+ mB1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB2_2_draw = (omega :+ mB2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)	
	
	// probability weighting
	wp1_1_draw = prob1 :* COPY 
	wp2_1_draw = prob2 :* COPY
	
	wp1_2_draw = prob1 :* COPY
	wp2_2_draw = prob2 :* COPY
	
	// compute V-distance and index 
	euA_1_draw = wp1_1_draw :* yA1_1_draw + wp2_1_draw :* yA2_1_draw
	euB_1_draw = wp1_1_draw :* yB1_1_draw + wp2_1_draw :* yB2_1_draw
	
	euA_2_draw = wp1_2_draw :* yA1_2_draw + wp2_2_draw :* yA2_2_draw
	euB_2_draw = wp1_2_draw :* yB1_2_draw + wp2_2_draw :* yB2_2_draw
	
	if (st_global("contextual") == "y") {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw :/ abs(urMAX_1_draw - urMIN_1_draw) 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw :/ abs(urMAX_2_draw - urMIN_2_draw) 
	}
	else {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw 
	}

	// generate [N x nrep] matrix of observation-level log-likelihood values given each draw
	lnProb_SEL = lnnormal( sel1_draw) :* (select1 :==  1 :& repeat :== -1  :& first :== 1) + ///
			     lnnormal(-sel1_draw) :* (select1 :== -1 :& repeat :== -1  :& first :== 1) + ///
			     lnnormal( sel2_draw) :* (select1 :==  1 :& select2 :==  1 :& repeat :== 1 :& first :== 1) + ///
			     lnnormal(-sel2_draw) :* (select1 :==  1 :& select2 :== -1 :& repeat :== 1 :& first :== 1)
	
	lnProb_RA = lnnormal( RAdiff1_draw) :* (select1 :== 1 :& repeat :== -1 :& choice :==  1) + ///
			    lnnormal(-RAdiff1_draw) :* (select1 :== 1 :& repeat :== -1 :& choice :== -1) + ///
			    lnnormal( RAdiff2_draw) :* (select1 :== 1 :& select2 :== 1 :& repeat :== 1 :& choice :==  1) + ///
			    lnnormal(-RAdiff2_draw) :* (select1 :== 1 :& select2 :== 1 :& repeat :== 1 :& choice :== -1)	

	// generate [N_panel x nrep] matrix of subject-level likelihood values given each draw
	ProbSeq_ALL = exp(idDV' * lnProb_SEL + idDV' * lnProb_RA)

	// generate [N_panel x 1] vector of subject-level log-simulated likelihood value (log of mean of ProbSeq)
	lnfj = ln(quadrowsum(ProbSeq_ALL,1)) :- ln(nrep)							
}	
end

//////

mata:
void MSL_CRRA_RC_A12(M, todo, b, lnfj, S, H)
{
	// choice variable as [N x 1] vector 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs as [N x 1] vectors	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	
	// selection variables as [N x 1] vectors
	select2 = 2*moptimize_util_depvar(M,7) :- 1
	
	// wave identifier and within-wave first obs identifier as [N x 1] vectors
	repeat = 2*moptimize_util_depvar(M,8)  :- 1
	first  = 2*moptimize_util_depvar(M,9) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))
	
	// load each non-Choleksy parameter as [N x 1] vector
	sel2   = moptimize_util_xb(M,b,1) :* J(rows(choice),1,1) 
	rra1   = moptimize_util_xb(M,b,2) :* J(rows(choice),1,1) 
	rra2   = moptimize_util_xb(M,b,3) :* J(rows(choice),1,1) 
	LNmuRA = moptimize_util_xb(M,b,4) :* J(rows(choice),1,1) 
	
	// load each Choleksy factor as scalar
	c21 = moptimize_util_xb(M,b,5)
	c22 = moptimize_util_xb(M,b,6)
	c31 = moptimize_util_xb(M,b,7)
	c32 = moptimize_util_xb(M,b,8)
	c33 = moptimize_util_xb(M,b,9)
	
	// normalize scale of selection coefficients to that of standard normal probit  
	sel2 = sel2 * sqrt(2)

	// load number of simulated draws
	external nrep

	// load [N x 1] vector of subject id
	external id
	
	// load [N x N_panel] matrix of subject dummies
	external idDV
	
	// load [N x nrep] matrices of N(0,1) draws from Halton sequences
	external ERR1, ERR2, ERR3
	
	// tell Stata that we intend to specify log-likelihood for each subject
	moptimize_init_by(M,id)			

	// convert [N x 1] mean parameter vectors into [N x nrep] matrices and generate draws of random parameters
	COPY = J(rows(choice),nrep,1)	
	sel2_draw	= sel2 :* COPY :+       ERR1 
	rra1_draw   = rra1 :* COPY :+ c21 * ERR1 :+ c22 * ERR2 
	rra2_draw   = rra2 :* COPY :+ c31 * ERR1 :+ c32 * ERR2 :+ c33 * ERR3
	LNmuRA_draw = LNmuRA :* COPY
	
	// transform parameters, [N x nrep] matrices
	rra1_draw = rra1_draw :* (rra1_draw :>= 1.0000001 :| rra1_draw :<= 0.9999999) + 0.9999999 :* (rra1_draw :> 0.9999999 :& rra1_draw :< 1) + 1.0000001 :* (rra1_draw :< 1.0000001 :& rra1_draw :>= 1)
	rra2_draw = rra2_draw :* (rra2_draw :>= 1.0000001 :| rra2_draw :<= 0.9999999) + 0.9999999 :* (rra2_draw :> 0.9999999 :& rra2_draw :< 1) + 1.0000001 :* (rra2_draw :< 1.0000001 :& rra2_draw :>= 1)				
	muRA_draw =	exp(LNmuRA_draw)
	
	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1_draw = (omega :+ mMIN):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		urMAX_1_draw = (omega :+ mMAX):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		
		urMIN_2_draw = (omega :+ mMIN):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
		urMAX_2_draw = (omega :+ mMAX):^(1 :- rra2_draw) :/ (1 :- rra2_draw)		
	}
	
	// utility of all prizes  
	yA1_1_draw = (omega :+ mA1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yA2_1_draw = (omega :+ mA2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB1_1_draw = (omega :+ mB1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB2_1_draw = (omega :+ mB2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)	
	
	yA1_2_draw = (omega :+ mA1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yA2_2_draw = (omega :+ mA2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB1_2_draw = (omega :+ mB1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB2_2_draw = (omega :+ mB2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)	
	
	// probability weighting
	wp1_1_draw = prob1 :* COPY 
	wp2_1_draw = prob2 :* COPY
	
	wp1_2_draw = prob1 :* COPY
	wp2_2_draw = prob2 :* COPY
	
	// compute V-distance and index 
	euA_1_draw = wp1_1_draw :* yA1_1_draw + wp2_1_draw :* yA2_1_draw
	euB_1_draw = wp1_1_draw :* yB1_1_draw + wp2_1_draw :* yB2_1_draw
	
	euA_2_draw = wp1_2_draw :* yA1_2_draw + wp2_2_draw :* yA2_2_draw
	euB_2_draw = wp1_2_draw :* yB1_2_draw + wp2_2_draw :* yB2_2_draw
	
	if (st_global("contextual") == "y") {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw :/ abs(urMAX_1_draw - urMIN_1_draw) 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw :/ abs(urMAX_2_draw - urMIN_2_draw) 
	}
	else {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw 
	}

	// generate [N x nrep] matrix of observation-level log-likelihood values given each draw
	lnProb_SEL = lnnormal( sel2_draw) :* (select2 :==  1 :& repeat :== 1 :& first :== 1) + ///
			     lnnormal(-sel2_draw) :* (select2 :== -1 :& repeat :== 1 :& first :== 1)
	
	lnProb_RA = lnnormal( RAdiff1_draw) :* (repeat :== -1 :& choice :==  1) + ///
			    lnnormal(-RAdiff1_draw) :* (repeat :== -1 :& choice :== -1) + ///
			    lnnormal( RAdiff2_draw) :* (select2 :== 1 :& repeat :== 1 :& choice :==  1) + ///
			    lnnormal(-RAdiff2_draw) :* (select2 :== 1 :& repeat :== 1 :& choice :== -1)	

	// generate [N_panel x nrep] matrix of subject-level likelihood values given each draw
	ProbSeq_ALL = exp(idDV' * lnProb_SEL + idDV' * lnProb_RA)

	// generate [N_panel x 1] vector of subject-level log-simulated likelihood value (log of mean of ProbSeq)
	lnfj = ln(quadrowsum(ProbSeq_ALL,1)) :- ln(nrep)							
}	
end


//////

mata:
void ML_CRRA1PRE_12(M, b, lnf)
{
	// load parameters to estimate
	rra1   = moptimize_util_xb(M,b,1)
	rra2   = moptimize_util_xb(M,b,2)
	LNphi1 = moptimize_util_xb(M,b,3)
	LNphi2 = moptimize_util_xb(M,b,4)	
	LNmuRA = moptimize_util_xb(M,b,5) 

	// transform parameters
	rra1 = rra1 :* (rra1 :>= 1.0000001 :| rra1 :<= 0.9999999) + 0.9999999 :* (rra1 :> 0.9999999 :& rra1 :< 1) + 1.0000001 :* (rra1 :< 1.0000001 :& rra1 :>= 1)
	rra2 = rra2 :* (rra2 :>= 1.0000001 :| rra2 :<= 0.9999999) + 0.9999999 :* (rra2 :> 0.9999999 :& rra2 :< 1) + 1.0000001 :* (rra2 :< 1.0000001 :& rra2 :>= 1)	
	phi1 = exp(LNphi1)
	phi2 = exp(LNphi2)
	muRA = exp(LNmuRA)	
	
	// choice variable 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	repeat = 2*moptimize_util_depvar(M,7) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))

	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1 = (omega :+ mMIN):^(1 :- rra1) :/ (1 :- rra1) 
		urMAX_1 = (omega :+ mMAX):^(1 :- rra1) :/ (1 :- rra1) 
		
		urMIN_2 = (omega :+ mMIN):^(1 :- rra2) :/ (1 :- rra2) 
		urMAX_2 = (omega :+ mMAX):^(1 :- rra2) :/ (1 :- rra2) 		
	}

	// utility of all prizes  
	yA1_1 = (omega :+ mA1):^(1 :- rra1) :/ (1 :- rra1) 
	yA2_1 = (omega :+ mA2):^(1 :- rra1) :/ (1 :- rra1) 
	yB1_1 = (omega :+ mB1):^(1 :- rra1) :/ (1 :- rra1) 
	yB2_1 = (omega :+ mB2):^(1 :- rra1) :/ (1 :- rra1) 	
	
	yA1_2 = (omega :+ mA1):^(1 :- rra2) :/ (1 :- rra2) 
	yA2_2 = (omega :+ mA2):^(1 :- rra2) :/ (1 :- rra2) 
	yB1_2 = (omega :+ mB1):^(1 :- rra2) :/ (1 :- rra2) 
	yB2_2 = (omega :+ mB2):^(1 :- rra2) :/ (1 :- rra2) 	
	
	// probability weighting
	wp1_1 = exp(-1 :* (-ln(prob1)):^phi1)
	wp2_1 = 1 :- wp1_1
	
	wp1_2 = exp(-1 :* (-ln(prob1)):^phi2)
	wp2_2 = 1 :- wp1_2 
	
	// compute V-distance and index 
	euA_1 = wp1_1 :* yA1_1 + wp2_1 :* yA2_1
	euB_1 = wp1_1 :* yB1_1 + wp2_1 :* yB2_1
	
	euA_2 = wp1_2 :* yA1_2 + wp2_2 :* yA2_2
	euB_2 = wp1_2 :* yB1_2 + wp2_2 :* yB2_2
	
	if (st_global("contextual") == "y") {
		RAdiff1 = (euB_1 - euA_1) :/ muRA :/ abs(urMAX_1 - urMIN_1)
		RAdiff2 = (euB_2 - euA_2) :/ muRA :/ abs(urMAX_2 - urMIN_2)
	}
	else {
		RAdiff1 = (euB_1 - euA_1) :/ muRA 
		RAdiff2 = (euB_2 - euA_2) :/ muRA 	
	}
	
	// log-likelihood contribution from Phase I
	lnf_m1 = lnnormal( RAdiff1) :* (choice :==  1 :& repeat :== -1) + ///
			 lnnormal(-RAdiff1) :* (choice :== -1 :& repeat :== -1)
	
	// log-likelihood contribution from Phase II
	lnf_m2 = lnnormal( RAdiff2) :* (choice :==  1 :& repeat :==  1) + ///
			 lnnormal(-RAdiff2) :* (choice :== -1 :& repeat :==  1) 
	
	// grand log-likelihood
	lnf = quadrowsum((lnf_m1, lnf_m2),0)
	_editvalue(lnf, 0, .)	
}
end

//////

mata:
void ML_CRRA2PRE_12(M, b, lnf)
{
	// load parameters to estimate
	rra1   = moptimize_util_xb(M,b,1)
	rra2   = moptimize_util_xb(M,b,2)
	LNphi1 = moptimize_util_xb(M,b,3)
	LNphi2 = moptimize_util_xb(M,b,4)	
	LNeta1 = moptimize_util_xb(M,b,5)
	LNeta2 = moptimize_util_xb(M,b,6)	
	LNmuRA = moptimize_util_xb(M,b,7) 

	// transform parameters
	rra1 = rra1 :* (rra1 :>= 1.0000001 :| rra1 :<= 0.9999999) + 0.9999999 :* (rra1 :> 0.9999999 :& rra1 :< 1) + 1.0000001 :* (rra1 :< 1.0000001 :& rra1 :>= 1)
	rra2 = rra2 :* (rra2 :>= 1.0000001 :| rra2 :<= 0.9999999) + 0.9999999 :* (rra2 :> 0.9999999 :& rra2 :< 1) + 1.0000001 :* (rra2 :< 1.0000001 :& rra2 :>= 1)	
	eta1 = exp(LNeta1)
	eta2 = exp(LNeta2)
	phi1 = exp(LNphi1)
	phi2 = exp(LNphi2)
	muRA = exp(LNmuRA)	
	
	// choice variable 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	repeat = 2*moptimize_util_depvar(M,7) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))

	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1 = (omega :+ mMIN):^(1 :- rra1) :/ (1 :- rra1) 
		urMAX_1 = (omega :+ mMAX):^(1 :- rra1) :/ (1 :- rra1) 
		
		urMIN_2 = (omega :+ mMIN):^(1 :- rra2) :/ (1 :- rra2) 
		urMAX_2 = (omega :+ mMAX):^(1 :- rra2) :/ (1 :- rra2) 		
	}

	// utility of all prizes  
	yA1_1 = (omega :+ mA1):^(1 :- rra1) :/ (1 :- rra1) 
	yA2_1 = (omega :+ mA2):^(1 :- rra1) :/ (1 :- rra1) 
	yB1_1 = (omega :+ mB1):^(1 :- rra1) :/ (1 :- rra1) 
	yB2_1 = (omega :+ mB2):^(1 :- rra1) :/ (1 :- rra1) 	
	
	yA1_2 = (omega :+ mA1):^(1 :- rra2) :/ (1 :- rra2) 
	yA2_2 = (omega :+ mA2):^(1 :- rra2) :/ (1 :- rra2) 
	yB1_2 = (omega :+ mB1):^(1 :- rra2) :/ (1 :- rra2) 
	yB2_2 = (omega :+ mB2):^(1 :- rra2) :/ (1 :- rra2) 	
	
	// probability weighting
	wp1_1 = exp(-eta1 :* (-ln(prob1)):^phi1)
	wp2_1 = 1 :- wp1_1
	
	wp1_2 = exp(-eta2 :* (-ln(prob1)):^phi2)
	wp2_2 = 1 :- wp1_2 
	
	// compute V-distance and index 
	euA_1 = wp1_1 :* yA1_1 + wp2_1 :* yA2_1
	euB_1 = wp1_1 :* yB1_1 + wp2_1 :* yB2_1
	
	euA_2 = wp1_2 :* yA1_2 + wp2_2 :* yA2_2
	euB_2 = wp1_2 :* yB1_2 + wp2_2 :* yB2_2
	
	if (st_global("contextual") == "y") {
		RAdiff1 = (euB_1 - euA_1) :/ muRA :/ abs(urMAX_1 - urMIN_1)
		RAdiff2 = (euB_2 - euA_2) :/ muRA :/ abs(urMAX_2 - urMIN_2)
	}
	else {
		RAdiff1 = (euB_1 - euA_1) :/ muRA 
		RAdiff2 = (euB_2 - euA_2) :/ muRA 	
	}
	
	// log-likelihood contribution from Phase I
	lnf_m1 = lnnormal( RAdiff1) :* (choice :==  1 :& repeat :== -1) + ///
			 lnnormal(-RAdiff1) :* (choice :== -1 :& repeat :== -1)
	
	// log-likelihood contribution from Phase II
	lnf_m2 = lnnormal( RAdiff2) :* (choice :==  1 :& repeat :==  1) + ///
			 lnnormal(-RAdiff2) :* (choice :== -1 :& repeat :==  1) 
	
	// grand log-likelihood
	lnf = quadrowsum((lnf_m1, lnf_m2),0)
	_editvalue(lnf, 0, .)	
}
end

//////

mata:
void MSL_CRRA1PRE_RC_12(M, todo, b, lnfj, S, H)
{
	// choice variable as [N x 1] vector 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs as [N x 1] vectors	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	
	// wave identifier as [N x 1] vector
	repeat = 2*moptimize_util_depvar(M,7) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))
	
	// load each non-Choleksy parameter as [N x 1] vector
	rra1   = moptimize_util_xb(M,b,1) :* J(rows(choice),1,1) 
	rra2   = moptimize_util_xb(M,b,2) :* J(rows(choice),1,1)	
	LNphi1 = moptimize_util_xb(M,b,3) :* J(rows(choice),1,1) 
	LNphi2 = moptimize_util_xb(M,b,4) :* J(rows(choice),1,1)		
	LNmuRA = moptimize_util_xb(M,b,5) :* J(rows(choice),1,1) 
	
	// load each Choleksy factor as scalar
	c11 = moptimize_util_xb(M,b,6)
	c21 = moptimize_util_xb(M,b,7)
	c22 = moptimize_util_xb(M,b,8)
	c31 = moptimize_util_xb(M,b,9)	
	c32 = moptimize_util_xb(M,b,10)	
	c33 = moptimize_util_xb(M,b,11)
	c41 = moptimize_util_xb(M,b,12)
	c42 = moptimize_util_xb(M,b,13)	
	c43 = moptimize_util_xb(M,b,14)	
	c44 = moptimize_util_xb(M,b,15)
	
	// load number of simulated draws
	external nrep

	// load [N x 1] vector of subject id
	external id
	
	// load [N x N_panel] matrix of subject dummies
	external idDV
	
	// load [N x nrep] matrices of N(0,1) draws from Halton sequences
	external ERR1, ERR2, ERR3, ERR4	
	
	// tell Stata that we intend to specify log-likelihood for each subject
	moptimize_init_by(M,id)		

	// convert [N x 1] mean parameter vectors into [N x nrep] matrices and generate draws of random parameters
	COPY = J(rows(choice),nrep,1)	
	rra1_draw     = rra1   :* COPY :+ c11 * ERR1
	rra2_draw     = rra2   :* COPY :+ c21 * ERR1 :+ c22 * ERR2
	LNphi1_draw   = LNphi1 :* COPY :+ c31 * ERR1 :+ c32 * ERR2 :+ c33 * ERR3 
	LNphi2_draw   = LNphi2 :* COPY :+ c41 * ERR1 :+ c42 * ERR2 :+ c43 * ERR3 :+ c44 * ERR4 		
	LNmuRA_draw   = LNmuRA :* COPY
	
	// transform parameters, [N x nrep] matrices
	rra1_draw = rra1_draw :* (rra1_draw :>= 1.0000001 :| rra1_draw :<= 0.9999999) + 0.9999999 :* (rra1_draw :> 0.9999999 :& rra1_draw :< 1) + 1.0000001 :* (rra1_draw :< 1.0000001 :& rra1_draw :>= 1)
	rra2_draw = rra2_draw :* (rra2_draw :>= 1.0000001 :| rra2_draw :<= 0.9999999) + 0.9999999 :* (rra2_draw :> 0.9999999 :& rra2_draw :< 1) + 1.0000001 :* (rra2_draw :< 1.0000001 :& rra2_draw :>= 1)				
	phi1_draw   = exp(LNphi1_draw)
	phi2_draw   = exp(LNphi2_draw)			
	muRA_draw   = exp(LNmuRA_draw)
	
	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1_draw = (omega :+ mMIN):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		urMAX_1_draw = (omega :+ mMAX):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		
		urMIN_2_draw = (omega :+ mMIN):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
		urMAX_2_draw = (omega :+ mMAX):^(1 :- rra2_draw) :/ (1 :- rra2_draw)		
	}

	// utility of all prizes  
	yA1_1_draw = (omega :+ mA1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yA2_1_draw = (omega :+ mA2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB1_1_draw = (omega :+ mB1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB2_1_draw = (omega :+ mB2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)	
	
	yA1_2_draw = (omega :+ mA1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yA2_2_draw = (omega :+ mA2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB1_2_draw = (omega :+ mB1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB2_2_draw = (omega :+ mB2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)	
	
	// probability weighting
	wp1_1_draw = exp(-1 :* (-ln(prob1 :* COPY)):^phi1_draw)
	wp2_1_draw = 1 :- wp1_1_draw
	
	wp1_2_draw = exp(-1 :* (-ln(prob1 :* COPY)):^phi2_draw)
	wp2_2_draw = 1 :- wp1_2_draw 	
	
	// compute V-distance and index 
	euA_1_draw = wp1_1_draw :* yA1_1_draw + wp2_1_draw :* yA2_1_draw
	euB_1_draw = wp1_1_draw :* yB1_1_draw + wp2_1_draw :* yB2_1_draw
	
	euA_2_draw = wp1_2_draw :* yA1_2_draw + wp2_2_draw :* yA2_2_draw
	euB_2_draw = wp1_2_draw :* yB1_2_draw + wp2_2_draw :* yB2_2_draw
	
	if (st_global("contextual") == "y") {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw :/ abs(urMAX_1_draw - urMIN_1_draw) 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw :/ abs(urMAX_2_draw - urMIN_2_draw) 
	}
	else {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw 	
	}	
	
	// generate [N x nrep] matrix of observation-level log-likelihood values given each draw
	lnProb_RA = lnnormal( RAdiff1_draw) :* (repeat :== -1 :& choice :==  1) + ///
			    lnnormal(-RAdiff1_draw) :* (repeat :== -1 :& choice :== -1) + ///
			    lnnormal( RAdiff2_draw) :* (repeat :==  1 :& choice :==  1) + ///
			    lnnormal(-RAdiff2_draw) :* (repeat :==  1 :& choice :== -1)	
		
	// generate [N_panel x nrep] matrix of subject-level likelihood values given each draw
	ProbSeq_RA = exp(idDV' * lnProb_RA)

	// generate [N_panel x 1] vector of subject-level log-simulated likelihood value (log of mean of ProbSeq)
	lnfj = ln(quadrowsum(ProbSeq_RA,1)) :- ln(nrep)
}	
end

//////

mata:
void MSL_CRRA2PRE_RC_12(M, todo, b, lnfj, S, H)
{
	// choice variable as [N x 1] vector 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs as [N x 1] vectors	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2    = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	
	// wave identifier as [N x 1] vector
	repeat = 2*moptimize_util_depvar(M,7) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))
	
	// load each non-Choleksy parameter as [N x 1] vector
	rra1   = moptimize_util_xb(M,b,1) :* J(rows(choice),1,1) 
	rra2   = moptimize_util_xb(M,b,2) :* J(rows(choice),1,1)
	LNphi1 = moptimize_util_xb(M,b,3) :* J(rows(choice),1,1) 
	LNphi2 = moptimize_util_xb(M,b,4) :* J(rows(choice),1,1)	
	LNeta1 = moptimize_util_xb(M,b,5) :* J(rows(choice),1,1) 
	LNeta2 = moptimize_util_xb(M,b,6) :* J(rows(choice),1,1)		
	LNmuRA = moptimize_util_xb(M,b,7) :* J(rows(choice),1,1) 
	
	// load each Choleksy factor as scalar
	c11 = moptimize_util_xb(M,b,8)
	c21 = moptimize_util_xb(M,b,9)
	c22 = moptimize_util_xb(M,b,10)
	c31 = moptimize_util_xb(M,b,11)	
	c32 = moptimize_util_xb(M,b,12)	
	c33 = moptimize_util_xb(M,b,13)
	c41 = moptimize_util_xb(M,b,14)
	c42 = moptimize_util_xb(M,b,15)	
	c43 = moptimize_util_xb(M,b,16)	
	c44 = moptimize_util_xb(M,b,17)
	c51 = moptimize_util_xb(M,b,18)
	c52 = moptimize_util_xb(M,b,19)	
	c53 = moptimize_util_xb(M,b,20)	
	c54 = moptimize_util_xb(M,b,21)	
	c55 = moptimize_util_xb(M,b,22)	
	c61 = moptimize_util_xb(M,b,23)
	c62 = moptimize_util_xb(M,b,24)	
	c63 = moptimize_util_xb(M,b,25)	
	c64 = moptimize_util_xb(M,b,26)	
	c65 = moptimize_util_xb(M,b,27)	
	c66 = moptimize_util_xb(M,b,28)
	
	// load number of simulated draws
	external nrep

	// load [N x 1] vector of subject id
	external id
	
	// load [N x N_panel] matrix of subject dummies
	external idDV
	
	// load [N x nrep] matrices of N(0,1) draws from Halton sequences
	external ERR1, ERR2, ERR3, ERR4, ERR5, ERR6	
	
	// tell Stata that we intend to specify log-likelihood for each subject
	moptimize_init_by(M,id)		
	
	// convert [N x 1] mean parameter vectors into [N x nrep] matrices and generate draws of random parameters
	COPY = J(rows(choice),nrep,1)	
	rra1_draw     = rra1   :* COPY :+ c11 * ERR1
	rra2_draw     = rra2   :* COPY :+ c21 * ERR1 :+ c22 * ERR2
	LNphi1_draw   = LNphi1 :* COPY :+ c31 * ERR1 :+ c32 * ERR2 :+ c33 * ERR3 
	LNphi2_draw   = LNphi2 :* COPY :+ c41 * ERR1 :+ c42 * ERR2 :+ c43 * ERR3 :+ c44 * ERR4
	LNeta1_draw   = LNeta1 :* COPY :+ c51 * ERR1 :+ c52 * ERR2 :+ c53 * ERR3 :+ c54 * ERR4 :+ c55 * ERR5
	LNeta2_draw   = LNeta2 :* COPY :+ c61 * ERR1 :+ c62 * ERR2 :+ c63 * ERR3 :+ c64 * ERR4 :+ c65 * ERR5 :+ c66 * ERR6		
	LNmuRA_draw   = LNmuRA :* COPY
	
	// transform parameters, [N x nrep] matrices
	rra1_draw = rra1_draw :* (rra1_draw :>= 1.0000001 :| rra1_draw :<= 0.9999999) + 0.9999999 :* (rra1_draw :> 0.9999999 :& rra1_draw :< 1) + 1.0000001 :* (rra1_draw :< 1.0000001 :& rra1_draw :>= 1)
	rra2_draw = rra2_draw :* (rra2_draw :>= 1.0000001 :| rra2_draw :<= 0.9999999) + 0.9999999 :* (rra2_draw :> 0.9999999 :& rra2_draw :< 1) + 1.0000001 :* (rra2_draw :< 1.0000001 :& rra2_draw :>= 1)				
	eta1_draw   = exp(LNeta1_draw)
	eta2_draw   = exp(LNeta2_draw)	
	phi1_draw   = exp(LNphi1_draw)
	phi2_draw   = exp(LNphi2_draw)			
	muRA_draw   = exp(LNmuRA_draw)
	
	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1_draw = (omega :+ mMIN):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		urMAX_1_draw = (omega :+ mMAX):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		
		urMIN_2_draw = (omega :+ mMIN):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
		urMAX_2_draw = (omega :+ mMAX):^(1 :- rra2_draw) :/ (1 :- rra2_draw)		
	}

	// utility of all prizes  
	yA1_1_draw = (omega :+ mA1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yA2_1_draw = (omega :+ mA2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB1_1_draw = (omega :+ mB1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB2_1_draw = (omega :+ mB2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)	
	
	yA1_2_draw = (omega :+ mA1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yA2_2_draw = (omega :+ mA2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB1_2_draw = (omega :+ mB1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB2_2_draw = (omega :+ mB2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)	
	
	// probability weighting
	wp1_1_draw = exp(-eta1_draw :* (-ln(prob1 :* COPY)):^phi1_draw)
	wp2_1_draw = 1 :- wp1_1_draw
	
	wp1_2_draw = exp(-eta2_draw :* (-ln(prob1 :* COPY)):^phi2_draw)
	wp2_2_draw = 1 :- wp1_2_draw 	
	
	// compute V-distance and index 
	euA_1_draw = wp1_1_draw :* yA1_1_draw + wp2_1_draw :* yA2_1_draw
	euB_1_draw = wp1_1_draw :* yB1_1_draw + wp2_1_draw :* yB2_1_draw
	
	euA_2_draw = wp1_2_draw :* yA1_2_draw + wp2_2_draw :* yA2_2_draw
	euB_2_draw = wp1_2_draw :* yB1_2_draw + wp2_2_draw :* yB2_2_draw
	
	if (st_global("contextual") == "y") {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw :/ abs(urMAX_1_draw - urMIN_1_draw) 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw :/ abs(urMAX_2_draw - urMIN_2_draw) 
	}
	else {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw 	
	}	
	
	// generate [N x nrep] matrix of observation-level log-likelihood values given each draw
	lnProb_RA = lnnormal( RAdiff1_draw) :* (repeat :== -1 :& choice :==  1) + ///
			    lnnormal(-RAdiff1_draw) :* (repeat :== -1 :& choice :== -1) + ///
			    lnnormal( RAdiff2_draw) :* (repeat :==  1 :& choice :==  1) + ///
			    lnnormal(-RAdiff2_draw) :* (repeat :==  1 :& choice :== -1)	
		
	// generate [N_panel x nrep] matrix of subject-level likelihood values given each draw
	ProbSeq_RA = exp(idDV' * lnProb_RA)

	// generate [N_panel x 1] vector of subject-level log-simulated likelihood value (log of mean of ProbSeq)
	lnfj = ln(quadrowsum(ProbSeq_RA,1)) :- ln(nrep)
}	
end

//////

mata:
void MSL_CRRA1PRE_RC_H12(M, todo, b, lnfj, S, H)
{
	// choice variable as [N x 1] vector 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs as [N x 1] vectors	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	
	// selection variables as [N x 1] vectors
	select1 = 2*moptimize_util_depvar(M,7) :- 1
	select2 = 2*moptimize_util_depvar(M,8) :- 1
	
	// wave identifier and within-wave first obs identifier as [N x 1] vectors
	repeat = 2*moptimize_util_depvar(M,9)  :- 1
	first  = 2*moptimize_util_depvar(M,10) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))
	
	// load each non-Choleksy parameter as [N x 1] vector
	sel1   = moptimize_util_xb(M,b,1) :* J(rows(choice),1,1) 
	sel2   = moptimize_util_xb(M,b,2) :* J(rows(choice),1,1) 
	rra1   = moptimize_util_xb(M,b,3) :* J(rows(choice),1,1) 
	rra2   = moptimize_util_xb(M,b,4) :* J(rows(choice),1,1) 	
	LNphi1 = moptimize_util_xb(M,b,5) :* J(rows(choice),1,1) 
	LNphi2 = moptimize_util_xb(M,b,6) :* J(rows(choice),1,1)	
	LNmuRA = moptimize_util_xb(M,b,7) :* J(rows(choice),1,1) 
	
	// load each Choleksy factor as scalar
	c21 = moptimize_util_xb(M,b,8)
	c31 = moptimize_util_xb(M,b,9)
	c32 = moptimize_util_xb(M,b,10)
	c33 = moptimize_util_xb(M,b,11)
	c41 = moptimize_util_xb(M,b,12)
	c42 = moptimize_util_xb(M,b,13)
	c43 = moptimize_util_xb(M,b,14)
	c44 = moptimize_util_xb(M,b,15)
	c51 = moptimize_util_xb(M,b,16)
	c52 = moptimize_util_xb(M,b,17)
	c53 = moptimize_util_xb(M,b,18)
	c54 = moptimize_util_xb(M,b,19)	
	c55 = moptimize_util_xb(M,b,20)
	c61 = moptimize_util_xb(M,b,21)
	c62 = moptimize_util_xb(M,b,22)
	c63 = moptimize_util_xb(M,b,23)
	c64 = moptimize_util_xb(M,b,24)	
	c65 = moptimize_util_xb(M,b,25)	
	c66 = moptimize_util_xb(M,b,26)
	
	// normalize scale of selection coefficients to that of standard normal probit  
	sel1 = sel1 * sqrt(2)
	sel2 = sel2 * sqrt(2 + c21^2)

	// load number of simulated draws
	external nrep

	// load [N x 1] vector of subject id
	external id
	
	// load [N x N_panel] matrix of subject dummies
	external idDV
	
	// load [N x nrep] matrices of N(0,1) draws from Halton sequences
	external ERR1, ERR2, ERR3, ERR4, ERR5, ERR6	
	
	// tell Stata that we intend to specify log-likelihood for each subject
	moptimize_init_by(M,id)			

	// convert [N x 1] mean parameter vectors into [N x nrep] matrices and generate draws of random parameters
	COPY = J(rows(choice),nrep,1)	
	sel1_draw	  = sel1 :* COPY   :+       ERR1 
	sel2_draw     = sel2 :* COPY   :+ c21 * ERR1 :+       ERR2
	rra1_draw     = rra1 :* COPY   :+ c31 * ERR1 :+ c32 * ERR2 :+ c33 * ERR3 
	rra2_draw     = rra2 :* COPY   :+ c41 * ERR1 :+ c42 * ERR2 :+ c43 * ERR3 :+ c44 * ERR4
	LNphi1_draw   = LNphi1 :* COPY :+ c51 * ERR1 :+ c52 * ERR2 :+ c53 * ERR3 :+ c54 * ERR4 :+ c55 * ERR5 
	LNphi2_draw   = LNphi2 :* COPY :+ c61 * ERR1 :+ c62 * ERR2 :+ c63 * ERR3 :+ c64 * ERR4 :+ c65 * ERR5 :+ c66 * ERR6 				
	LNmuRA_draw = LNmuRA :* COPY
	
	// transform parameters, [N x nrep] matrices
	rra1_draw = rra1_draw :* (rra1_draw :>= 1.0000001 :| rra1_draw :<= 0.9999999) + 0.9999999 :* (rra1_draw :> 0.9999999 :& rra1_draw :< 1) + 1.0000001 :* (rra1_draw :< 1.0000001 :& rra1_draw :>= 1)
	rra2_draw = rra2_draw :* (rra2_draw :>= 1.0000001 :| rra2_draw :<= 0.9999999) + 0.9999999 :* (rra2_draw :> 0.9999999 :& rra2_draw :< 1) + 1.0000001 :* (rra2_draw :< 1.0000001 :& rra2_draw :>= 1)				
	phi1_draw = exp(LNphi1_draw)
	phi2_draw = exp(LNphi2_draw)		
	muRA_draw =	exp(LNmuRA_draw)
	
	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1_draw = (omega :+ mMIN):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		urMAX_1_draw = (omega :+ mMAX):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		
		urMIN_2_draw = (omega :+ mMIN):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
		urMAX_2_draw = (omega :+ mMAX):^(1 :- rra2_draw) :/ (1 :- rra2_draw)		
	}
	
	// utility of all prizes  
	yA1_1_draw = (omega :+ mA1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yA2_1_draw = (omega :+ mA2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB1_1_draw = (omega :+ mB1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB2_1_draw = (omega :+ mB2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)	
	
	yA1_2_draw = (omega :+ mA1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yA2_2_draw = (omega :+ mA2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB1_2_draw = (omega :+ mB1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB2_2_draw = (omega :+ mB2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)	
	
	// probability weighting (prob1 = 0 for non-selectors and >= 0.1 for selectors. to avoid log-of-zero problem, replace 0s with 0.01s). 
	_editvalue(prob1, 0, 0.01)
	wp1_1_draw = exp(-1 :* (-ln(prob1 :* COPY)):^phi1_draw)
	wp2_1_draw = 1 :- wp1_1_draw
	
	wp1_2_draw = exp(-1 :* (-ln(prob1 :* COPY)):^phi2_draw)
	wp2_2_draw = 1 :- wp1_2_draw 
	
	// compute V-distance and index 
	euA_1_draw = wp1_1_draw :* yA1_1_draw + wp2_1_draw :* yA2_1_draw
	euB_1_draw = wp1_1_draw :* yB1_1_draw + wp2_1_draw :* yB2_1_draw
	
	euA_2_draw = wp1_2_draw :* yA1_2_draw + wp2_2_draw :* yA2_2_draw
	euB_2_draw = wp1_2_draw :* yB1_2_draw + wp2_2_draw :* yB2_2_draw
	
	if (st_global("contextual") == "y") {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw :/ abs(urMAX_1_draw - urMIN_1_draw) 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw :/ abs(urMAX_2_draw - urMIN_2_draw) 
	}
	else {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw 
	}	
	
	// generate [N x nrep] matrix of observation-level log-likelihood values given each draw
	lnProb_SEL = lnnormal( sel1_draw) :* (select1 :==  1 :& repeat  :== -1 :& first :== 1) + ///
			     lnnormal(-sel1_draw) :* (select1 :== -1 :& repeat  :== -1 :& first :== 1) + ///
			     lnnormal( sel2_draw) :* (select1 :==  1 :& select2 :==  1 :& repeat :== 1 :& first :== 1) + ///
			     lnnormal(-sel2_draw) :* (select1 :==  1 :& select2 :== -1 :& repeat :== 1 :& first :== 1)
	
	lnProb_RA = lnnormal( RAdiff1_draw) :* (select1 :== 1 :& repeat  :== -1 :& choice :==  1) + ///
			    lnnormal(-RAdiff1_draw) :* (select1 :== 1 :& repeat  :== -1 :& choice :== -1) + ///
			    lnnormal( RAdiff2_draw) :* (select1 :== 1 :& select2 :== 1  :& repeat :== 1 :& choice :==  1) + ///
			    lnnormal(-RAdiff2_draw) :* (select1 :== 1 :& select2 :== 1  :& repeat :== 1 :& choice :== -1)	

	// generate [N_panel x nrep] matrix of subject-level likelihood values given each draw
	ProbSeq_ALL = exp(idDV' * lnProb_SEL + idDV' * lnProb_RA)

	// generate [N_panel x 1] vector of subject-level log-simulated likelihood value (log of mean of ProbSeq)
	lnfj = ln(quadrowsum(ProbSeq_ALL,1)) :- ln(nrep)
}	
end

//////

mata:
void MSL_CRRA2PRE_RC_H12(M, todo, b, lnfj, S, H)
{
	// choice variable as [N x 1] vector 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs as [N x 1] vectors	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	
	// selection variables as [N x 1] vectors
	select1 = 2*moptimize_util_depvar(M,7) :- 1
	select2 = 2*moptimize_util_depvar(M,8) :- 1
	
	// wave identifier and within-wave first obs identifier as [N x 1] vectors
	repeat = 2*moptimize_util_depvar(M,9)  :- 1
	first  = 2*moptimize_util_depvar(M,10) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))
	
	// load each non-Choleksy parameter as [N x 1] vector
	sel1   = moptimize_util_xb(M,b,1) :* J(rows(choice),1,1) 
	sel2   = moptimize_util_xb(M,b,2) :* J(rows(choice),1,1) 
	rra1   = moptimize_util_xb(M,b,3) :* J(rows(choice),1,1) 
	rra2   = moptimize_util_xb(M,b,4) :* J(rows(choice),1,1) 
	LNphi1 = moptimize_util_xb(M,b,5) :* J(rows(choice),1,1) 
	LNphi2 = moptimize_util_xb(M,b,6) :* J(rows(choice),1,1)	
	LNeta1 = moptimize_util_xb(M,b,7) :* J(rows(choice),1,1) 
	LNeta2 = moptimize_util_xb(M,b,8) :* J(rows(choice),1,1)	
	LNmuRA = moptimize_util_xb(M,b,9) :* J(rows(choice),1,1) 
	
	// load each Choleksy factor as scalar
	c21 = moptimize_util_xb(M,b,10)
	c31 = moptimize_util_xb(M,b,11)
	c32 = moptimize_util_xb(M,b,12)
	c33 = moptimize_util_xb(M,b,13)
	c41 = moptimize_util_xb(M,b,14)
	c42 = moptimize_util_xb(M,b,15)
	c43 = moptimize_util_xb(M,b,16)
	c44 = moptimize_util_xb(M,b,17)
	c51 = moptimize_util_xb(M,b,18)
	c52 = moptimize_util_xb(M,b,19)
	c53 = moptimize_util_xb(M,b,20)
	c54 = moptimize_util_xb(M,b,21)	
	c55 = moptimize_util_xb(M,b,22)
	c61 = moptimize_util_xb(M,b,23)
	c62 = moptimize_util_xb(M,b,24)
	c63 = moptimize_util_xb(M,b,25)
	c64 = moptimize_util_xb(M,b,26)	
	c65 = moptimize_util_xb(M,b,27)	
	c66 = moptimize_util_xb(M,b,28)
	c71 = moptimize_util_xb(M,b,29)
	c72 = moptimize_util_xb(M,b,30)
	c73 = moptimize_util_xb(M,b,31)
	c74 = moptimize_util_xb(M,b,32)	
	c75 = moptimize_util_xb(M,b,33)	
	c76 = moptimize_util_xb(M,b,34)	
	c77 = moptimize_util_xb(M,b,35)
	c81 = moptimize_util_xb(M,b,36)
	c82 = moptimize_util_xb(M,b,37)
	c83 = moptimize_util_xb(M,b,38)
	c84 = moptimize_util_xb(M,b,39)	
	c85 = moptimize_util_xb(M,b,40)	
	c86 = moptimize_util_xb(M,b,41)	
	c87 = moptimize_util_xb(M,b,42)
	c88 = moptimize_util_xb(M,b,43)
	
	// normalize scale of selection coefficients to that of standard normal probit  
	sel1 = sel1 * sqrt(2)
	sel2 = sel2 * sqrt(2 + c21^2)

	// load number of simulated draws
	external nrep

	// load [N x 1] vector of subject id
	external id
	
	// load [N x N_panel] matrix of subject dummies
	external idDV
	
	// load [N x nrep] matrices of N(0,1) draws from Halton sequences
	external ERR1, ERR2, ERR3, ERR4, ERR5, ERR6, ERR7, ERR8		
	
	// tell Stata that we intend to specify log-likelihood for each subject
	moptimize_init_by(M,id)			

	// convert [N x 1] mean parameter vectors into [N x nrep] matrices and generate draws of random parameters
	COPY = J(rows(choice),nrep,1)	
	sel1_draw	  = sel1 :* COPY   :+       ERR1 
	sel2_draw     = sel2 :* COPY   :+ c21 * ERR1 :+       ERR2
	rra1_draw     = rra1 :* COPY   :+ c31 * ERR1 :+ c32 * ERR2 :+ c33 * ERR3 
	rra2_draw     = rra2 :* COPY   :+ c41 * ERR1 :+ c42 * ERR2 :+ c43 * ERR3 :+ c44 * ERR4
	LNphi1_draw   = LNphi1 :* COPY :+ c51 * ERR1 :+ c52 * ERR2 :+ c53 * ERR3 :+ c54 * ERR4 :+ c55 * ERR5
	LNphi2_draw   = LNphi2 :* COPY :+ c61 * ERR1 :+ c62 * ERR2 :+ c63 * ERR3 :+ c64 * ERR4 :+ c65 * ERR5 :+ c66 * ERR6 
	LNeta1_draw   = LNeta1 :* COPY :+ c71 * ERR1 :+ c72 * ERR2 :+ c73 * ERR3 :+ c74 * ERR4 :+ c75 * ERR5 :+ c76 * ERR6 :+ c77 * ERR7
	LNeta2_draw   = LNeta2 :* COPY :+ c81 * ERR1 :+ c82 * ERR2 :+ c83 * ERR3 :+ c84 * ERR4 :+ c85 * ERR5 :+ c86 * ERR6 :+ c87 * ERR7 :+ c88 * ERR8				
	LNmuRA_draw = LNmuRA :* COPY
	
	// transform parameters, [N x nrep] matrices
	rra1_draw = rra1_draw :* (rra1_draw :>= 1.0000001 :| rra1_draw :<= 0.9999999) + 0.9999999 :* (rra1_draw :> 0.9999999 :& rra1_draw :< 1) + 1.0000001 :* (rra1_draw :< 1.0000001 :& rra1_draw :>= 1)
	rra2_draw = rra2_draw :* (rra2_draw :>= 1.0000001 :| rra2_draw :<= 0.9999999) + 0.9999999 :* (rra2_draw :> 0.9999999 :& rra2_draw :< 1) + 1.0000001 :* (rra2_draw :< 1.0000001 :& rra2_draw :>= 1)				
	eta1_draw = exp(LNeta1_draw)
	eta2_draw = exp(LNeta2_draw)	
	phi1_draw = exp(LNphi1_draw)
	phi2_draw = exp(LNphi2_draw)		
	muRA_draw =	exp(LNmuRA_draw)
	
	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1_draw = (omega :+ mMIN):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		urMAX_1_draw = (omega :+ mMAX):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		
		urMIN_2_draw = (omega :+ mMIN):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
		urMAX_2_draw = (omega :+ mMAX):^(1 :- rra2_draw) :/ (1 :- rra2_draw)		
	}
	
	// utility of all prizes  
	yA1_1_draw = (omega :+ mA1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yA2_1_draw = (omega :+ mA2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB1_1_draw = (omega :+ mB1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB2_1_draw = (omega :+ mB2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)	
	
	yA1_2_draw = (omega :+ mA1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yA2_2_draw = (omega :+ mA2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB1_2_draw = (omega :+ mB1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB2_2_draw = (omega :+ mB2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)	
	
	// probability weighting (prob1 = 0 for non-selectors and >= 0.1 for selectors. to avoid log-of-zero problem, replace 0s with 0.01s). 
	_editvalue(prob1, 0, 0.01)
	wp1_1_draw = exp(-eta1_draw :* (-ln(prob1 :* COPY)):^phi1_draw)
	wp2_1_draw = 1 :- wp1_1_draw
	
	wp1_2_draw = exp(-eta2_draw :* (-ln(prob1 :* COPY)):^phi2_draw)
	wp2_2_draw = 1 :- wp1_2_draw 
	
	// compute V-distance and index 
	euA_1_draw = wp1_1_draw :* yA1_1_draw + wp2_1_draw :* yA2_1_draw
	euB_1_draw = wp1_1_draw :* yB1_1_draw + wp2_1_draw :* yB2_1_draw
	
	euA_2_draw = wp1_2_draw :* yA1_2_draw + wp2_2_draw :* yA2_2_draw
	euB_2_draw = wp1_2_draw :* yB1_2_draw + wp2_2_draw :* yB2_2_draw
	
	if (st_global("contextual") == "y") {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw :/ abs(urMAX_1_draw - urMIN_1_draw) 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw :/ abs(urMAX_2_draw - urMIN_2_draw) 
	}
	else {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw 
	}	
	
	// generate [N x nrep] matrix of observation-level log-likelihood values given each draw
	lnProb_SEL = lnnormal( sel1_draw) :* (select1 :==  1 :& repeat  :== -1 :& first :== 1) + ///
			     lnnormal(-sel1_draw) :* (select1 :== -1 :& repeat  :== -1 :& first :== 1) + ///
			     lnnormal( sel2_draw) :* (select1 :==  1 :& select2 :==  1 :& repeat :== 1 :& first :== 1) + ///
			     lnnormal(-sel2_draw) :* (select1 :==  1 :& select2 :== -1 :& repeat :== 1 :& first :== 1)
	
	lnProb_RA = lnnormal( RAdiff1_draw) :* (select1 :== 1 :& repeat  :== -1 :& choice :==  1) + ///
			    lnnormal(-RAdiff1_draw) :* (select1 :== 1 :& repeat  :== -1 :& choice :== -1) + ///
			    lnnormal( RAdiff2_draw) :* (select1 :== 1 :& select2 :== 1  :& repeat :== 1 :& choice :==  1) + ///
			    lnnormal(-RAdiff2_draw) :* (select1 :== 1 :& select2 :== 1  :& repeat :== 1 :& choice :== -1)	

	// generate [N_panel x nrep] matrix of subject-level likelihood values given each draw
	ProbSeq_ALL = exp(idDV' * lnProb_SEL + idDV' * lnProb_RA)

	// generate [N_panel x 1] vector of subject-level log-simulated likelihood value (log of mean of ProbSeq)
	lnfj = ln(quadrowsum(ProbSeq_ALL,1)) :- ln(nrep)
}	
end

//////

mata:
void MSL_CRRA1PRE_RC_A12(M, todo, b, lnfj, S, H)
{
	// choice variable as [N x 1] vector 
	choice = 2*moptimize_util_depvar(M,1) :- 1
	
	// initialize probabilities and payoffs as [N x 1] vectors	
	prob1  = moptimize_util_depvar(M,2)
	prob2  = 1 :- prob1
	mA1	   = moptimize_util_depvar(M,3)
	mA2	   = moptimize_util_depvar(M,4)
	mB1    = moptimize_util_depvar(M,5)
	mB2    = moptimize_util_depvar(M,6)
	
	// selection variables as [N x 1] vectors
	select2 = 2*moptimize_util_depvar(M,7) :- 1
	
	// wave identifier and within-wave first obs identifier as [N x 1] vectors
	repeat = 2*moptimize_util_depvar(M,8)  :- 1
	first  = 2*moptimize_util_depvar(M,9) :- 1
	
	// load background consumption
	omega = strtoreal(st_global("omega"))
	
	// load each non-Choleksy parameter as [N x 1] vector
	sel2   = moptimize_util_xb(M,b,1) :* J(rows(choice),1,1) 
	rra1   = moptimize_util_xb(M,b,2) :* J(rows(choice),1,1) 
	rra2   = moptimize_util_xb(M,b,3) :* J(rows(choice),1,1) 	
	LNphi1 = moptimize_util_xb(M,b,4) :* J(rows(choice),1,1) 
	LNphi2 = moptimize_util_xb(M,b,5) :* J(rows(choice),1,1)	
	LNmuRA = moptimize_util_xb(M,b,6) :* J(rows(choice),1,1) 
	
	// load each Choleksy factor as scalar
	c21 = moptimize_util_xb(M,b,7)
	c22 = moptimize_util_xb(M,b,8)
	c31 = moptimize_util_xb(M,b,9)
	c32 = moptimize_util_xb(M,b,10)
	c33 = moptimize_util_xb(M,b,11)
	c41 = moptimize_util_xb(M,b,12)
	c42 = moptimize_util_xb(M,b,13)
	c43 = moptimize_util_xb(M,b,14)
	c44 = moptimize_util_xb(M,b,15)
	c51 = moptimize_util_xb(M,b,16)
	c52 = moptimize_util_xb(M,b,17)
	c53 = moptimize_util_xb(M,b,18)
	c54 = moptimize_util_xb(M,b,19)	
	c55 = moptimize_util_xb(M,b,20)
	
	// normalize scale of selection coefficients to that of standard normal probit  
	sel2 = sel2 * sqrt(2)

	// load number of simulated draws
	external nrep

	// load [N x 1] vector of subject id
	external id
	
	// load [N x N_panel] matrix of subject dummies
	external idDV
	
	// load [N x nrep] matrices of N(0,1) draws from Halton sequences
	external ERR1, ERR2, ERR3, ERR4, ERR5
	
	// tell Stata that we intend to specify log-likelihood for each subject
	moptimize_init_by(M,id)			

	// convert [N x 1] mean parameter vectors into [N x nrep] matrices and generate draws of random parameters
	COPY = J(rows(choice),nrep,1)	
	sel2_draw	  = sel2 :* COPY   :+       ERR1 
	rra1_draw     = rra1 :* COPY   :+ c21 * ERR1 :+ c22 * ERR2  
	rra2_draw     = rra2 :* COPY   :+ c31 * ERR1 :+ c32 * ERR2 :+ c33 * ERR3
	LNphi1_draw   = LNphi1 :* COPY :+ c41 * ERR1 :+ c42 * ERR2 :+ c43 * ERR3 :+ c44 * ERR4 
	LNphi2_draw   = LNphi2 :* COPY :+ c51 * ERR1 :+ c52 * ERR2 :+ c53 * ERR3 :+ c54 * ERR4 :+ c55 * ERR5			
	LNmuRA_draw = LNmuRA :* COPY
	
	// transform parameters, [N x nrep] matrices
	rra1_draw = rra1_draw :* (rra1_draw :>= 1.0000001 :| rra1_draw :<= 0.9999999) + 0.9999999 :* (rra1_draw :> 0.9999999 :& rra1_draw :< 1) + 1.0000001 :* (rra1_draw :< 1.0000001 :& rra1_draw :>= 1)
	rra2_draw = rra2_draw :* (rra2_draw :>= 1.0000001 :| rra2_draw :<= 0.9999999) + 0.9999999 :* (rra2_draw :> 0.9999999 :& rra2_draw :< 1) + 1.0000001 :* (rra2_draw :< 1.0000001 :& rra2_draw :>= 1)				
	phi1_draw = exp(LNphi1_draw)
	phi2_draw = exp(LNphi2_draw)		
	muRA_draw =	exp(LNmuRA_draw)
	
	if (st_global("contextual") == "y") {
		// identify minimum and maximum prizes
		mMIN = rowmin((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmin((mA1,mB1)) :* (prob2 :== 0)	
		mMAX = rowmax((mA1,mA2,mB1,mB2)) :* (prob2 :> 0) + rowmax((mA1,mB1)) :* (prob2 :== 0) 
		
		// utility of minimum and maximum prizes
		urMIN_1_draw = (omega :+ mMIN):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		urMAX_1_draw = (omega :+ mMAX):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
		
		urMIN_2_draw = (omega :+ mMIN):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
		urMAX_2_draw = (omega :+ mMAX):^(1 :- rra2_draw) :/ (1 :- rra2_draw)		
	}
	
	// utility of all prizes  
	yA1_1_draw = (omega :+ mA1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yA2_1_draw = (omega :+ mA2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB1_1_draw = (omega :+ mB1):^(1 :- rra1_draw) :/ (1 :- rra1_draw)
	yB2_1_draw = (omega :+ mB2):^(1 :- rra1_draw) :/ (1 :- rra1_draw)	
	
	yA1_2_draw = (omega :+ mA1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yA2_2_draw = (omega :+ mA2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB1_2_draw = (omega :+ mB1):^(1 :- rra2_draw) :/ (1 :- rra2_draw)
	yB2_2_draw = (omega :+ mB2):^(1 :- rra2_draw) :/ (1 :- rra2_draw)	
	
	// probability weighting (prob1 = 0 for non-selectors and >= 0.1 for selectors. to avoid log-of-zero problem, replace 0s with 0.01s). 
	_editvalue(prob1, 0, 0.01)
	wp1_1_draw = exp(-1 :* (-ln(prob1 :* COPY)):^phi1_draw)
	wp2_1_draw = 1 :- wp1_1_draw
	
	wp1_2_draw = exp(-1 :* (-ln(prob1 :* COPY)):^phi2_draw)
	wp2_2_draw = 1 :- wp1_2_draw 
	
	// compute V-distance and index 
	euA_1_draw = wp1_1_draw :* yA1_1_draw + wp2_1_draw :* yA2_1_draw
	euB_1_draw = wp1_1_draw :* yB1_1_draw + wp2_1_draw :* yB2_1_draw
	
	euA_2_draw = wp1_2_draw :* yA1_2_draw + wp2_2_draw :* yA2_2_draw
	euB_2_draw = wp1_2_draw :* yB1_2_draw + wp2_2_draw :* yB2_2_draw
	
	if (st_global("contextual") == "y") {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw :/ abs(urMAX_1_draw - urMIN_1_draw) 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw :/ abs(urMAX_2_draw - urMIN_2_draw) 
	}
	else {
		RAdiff1_draw = (euB_1_draw - euA_1_draw) :/ muRA_draw 
		RAdiff2_draw = (euB_2_draw - euA_2_draw) :/ muRA_draw 
	}	
	
	// generate [N x nrep] matrix of observation-level log-likelihood values given each draw
	lnProb_SEL = lnnormal( sel2_draw) :* (select2 :==  1 :& repeat :== 1 :& first :== 1) + ///
			     lnnormal(-sel2_draw) :* (select2 :== -1 :& repeat :== 1 :& first :== 1)
	
	lnProb_RA = lnnormal( RAdiff1_draw) :* (repeat  :== -1 :& choice :==  1) + ///
			    lnnormal(-RAdiff1_draw) :* (repeat  :== -1 :& choice :== -1) + ///
			    lnnormal( RAdiff2_draw) :* (select2 :== 1  :& repeat :== 1 :& choice :==  1) + ///
			    lnnormal(-RAdiff2_draw) :* (select2 :== 1  :& repeat :== 1 :& choice :== -1)	

	// generate [N_panel x nrep] matrix of subject-level likelihood values given each draw
	ProbSeq_ALL = exp(idDV' * lnProb_SEL + idDV' * lnProb_RA)

	// generate [N_panel x 1] vector of subject-level log-simulated likelihood value (log of mean of ProbSeq)
	lnfj = ln(quadrowsum(ProbSeq_ALL,1)) :- ln(nrep)
}	
end

exit
