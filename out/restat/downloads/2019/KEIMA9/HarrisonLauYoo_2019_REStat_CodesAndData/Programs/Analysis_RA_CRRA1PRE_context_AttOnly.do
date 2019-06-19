//===========================================================================================
// ANALYSIS OF RA DATA, WITH CORRECTION FOR ATTRITION 
// RDU MODEL with 1-parameter Prelec: CRRA u(X) = x^(1-rra)/(1-rra), w(P) = exp{-(-lnP)^phi)}
// Allow for observed heterogeneity w.r.t. treatment indicators.
// Contextual utility.
//===========================================================================================

// globals for LHS variables of RA models
global LHS_RA choices rowproba vprizea1 vprizea2 vprizeb1 vprizeb2

// globals for RHS variables in selection (RHS_1) and attrition (RHS_2A) equations
global RHS_1  "female young middle old high_fee dist distsq"
global RHS_2A "female young middle old IncLow IncHigh earnings"

// globals for order & stake treatment indicators in RA models
global treat2_RA "RAfirst RAhigh"

// global for background consumption
global omega=0

// global for contextual utility
global contextual="y"

// globals for initial MSL estimation settings
global id id
global nrep = 50
global burn = 20

// load data
use DK2009_SS.dta, clear

// For non-participants, recode rowproba and RAfirst as 0s: doesn't affect non-missing log-likelihood values
replace rowproba = 0 if missing(rowproba)
replace RAfirst  = 0 if missing(RAfirst)

// Replace non-selector's missing earnings with 0s: doesn't affect non-missing log-likelihood values
replace earnings = 0 if missing(earnings)

// To avoid division by zero problem, replace a zero prize with a small positive prize (0.04): doesn't affect non-missing log-likelihood values 
sum vprize* if rowproba == 0
foreach vprize of varlist vprize* {
	sum rowproba if `vprize' == 0
}

foreach vprize of varlist vprizea1 vprizeb1 {
	replace `vprize' = 0.04 if `vprize' == 0
}

foreach vprize of varlist vprizea2 vprizeb2 {
	replace `vprize' = 0.03 if `vprize' == 0
}

// To keep Mata code simple, generate numeric ID (instead of current string)
destring id, replace

// Identify first observation on a particular subject within each wave
sort id repeat, stable
by id repeat: gen byte first = [_n == 1]

// Only keep people who participated in the first experiment
keep if sample_1 == 1

//==============================================================================
// B. Models correcting for attrition
//==============================================================================

//-------------------------
// Sample selection probit
//-------------------------
probit sample_2 ${RHS_2A} if repeat == 1 & first == 1
est save Results/probit_sample_2.ster, replace

//-------------------------------------------------------
// RC model with sample selection: no control, nrep = 50
//-------------------------------------------------------
global nrep = 50
MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(5)

est use Results/probit_sample_2.ster
mat start_SEL = e(b)

est use Results/ML_CRRA1PRE_12_C0.ster
mat start = start_SEL, e(b), 0, 0.1, 0, 0, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0, 0.1

ml model gf0 MSL_CRRA1PRE_RC_A12() (sel2: ${LHS_RA} sample_2 repeat first = ${RHS_2A}) ///
								   (rra1: ) (rra2: ) /// 
								   (LNphi1: ) (LNphi2: ) (LNmuRA: ) /// 
								   (c21: ) (c22: ) (c31: ) (c32: ) (c33: ) (c41: ) (c42: ) (c43: ) (c44: ) ///
								   (c51: ) (c52: ) (c53: ) (c54: ) (c55: ), ///	
								   cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) init(start, copy) 
ml display
est save Results/nrep${nrep}_MSL_CRRA1PRE_RC_A12_CA0.ster

	//-------------------------------------------------------------------
	// RC model with sample selection: control for treatments, nrep = 50
	//-------------------------------------------------------------------
	global nrep = 50
	MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(5)	
	
	est use Results/nrep50_MSL_CRRA1PRE_RC_A12_CA0.ster

	ml model gf0 MSL_CRRA1PRE_RC_A12() (sel2: ${LHS_RA} sample_2 repeat first = ${RHS_2A}) ///
									   (rra1: = ${treat2_RA}) (rra2: = ${treat2_RA}) /// 
									   (LNphi1: ${treat2_RA}) (LNphi2: ${treat2_RA}) (LNmuRA: ${treat2_RA}) /// 
									   (c21: ) (c22: ) (c31: ) (c32: ) (c33: ) (c41: ) (c42: ) (c43: ) (c44: ) ///
									   (c51: ) (c52: ) (c53: ) (c54: ) (c55: ), ///					
									   cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) continue
	ml display
	est save Results/nrep${nrep}_MSL_CRRA1PRE_RC_A12_CA1.ster

	//--------------------------------------------------------------------
	// RC model with sample selection: control for treatments, nrep = 75
	//--------------------------------------------------------------------
	global nrep = 75
	MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(5)	
	
	est use Results/nrep50_MSL_CRRA1PRE_RC_A12_CA1.ster
	matrix start = e(b)

	ml model gf0 MSL_CRRA1PRE_RC_A12() (sel2: ${LHS_RA} sample_2 repeat first = ${RHS_2A}) ///
									   (rra1: = ${treat2_RA}) (rra2: = ${treat2_RA}) /// 
									   (LNphi1: ${treat2_RA}) (LNphi2: ${treat2_RA}) (LNmuRA: ${treat2_RA}) /// 
									   (c21: ) (c22: ) (c31: ) (c32: ) (c33: ) (c41: ) (c42: ) (c43: ) (c44: ) ///
									   (c51: ) (c52: ) (c53: ) (c54: ) (c55: ), ///					
									   cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) init(start)
	ml display
	est save Results/nrep${nrep}_MSL_CRRA1PRE_RC_A12_CA1.ster
	
	//--------------------------------------------------------------------
	// RC model with sample selection: control for treatments, nrep = 100
	//--------------------------------------------------------------------
	global nrep = 100
	MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(5)	
	
	est use Results/nrep75_MSL_CRRA1PRE_RC_A12_CA1.ster
	matrix start = e(b)

	ml model gf0 MSL_CRRA1PRE_RC_A12() (sel2: ${LHS_RA} sample_2 repeat first = ${RHS_2A}) ///
									   (rra1: = ${treat2_RA}) (rra2: = ${treat2_RA}) /// 
									   (LNphi1: ${treat2_RA}) (LNphi2: ${treat2_RA}) (LNmuRA: ${treat2_RA}) /// 
									   (c21: ) (c22: ) (c31: ) (c32: ) (c33: ) (c41: ) (c42: ) (c43: ) (c44: ) ///
									   (c51: ) (c52: ) (c53: ) (c54: ) (c55: ), ///					
									   cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) init(start)
	ml display
	est save Results/nrep${nrep}_MSL_CRRA1PRE_RC_A12_CA1.ster

exit
