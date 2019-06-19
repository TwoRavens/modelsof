//==============================================================================
// ANALYSIS OF RA DATA, WITH AND WITHOUT SELECTION. 
// EUT MODEL: CRRA u(X) = x^(1-rra)/(1-rra)
// Fechner errors. Allow for observed heterogeneity w.r.t. treatment indicators.
//==============================================================================

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
global contextual="n"

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

//==============================================================================
// A. Models ignoring endogenous sample selection
//==============================================================================
preserve

// drop non-selectors
keep if (sample_1 == 1 & repeat == 0)| (sample_2 == 1 & repeat == 1)

//------------------------------------------------
// PA model without sample selection: no controls 
//------------------------------------------------
mat start = 0.2, 0.6, -0.15
ml model lf ML_CRRA_12() (rra1: ${LHS_RA} repeat = ) (rra2: ) (LNmuRA: ), ///
			   cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) init(start, copy) 
ml display
est save Results/ML_CRRA_12_V0.ster, replace

	//-----------------------------------------------------------
	// PA model without sample selection: control for treatments
	//-----------------------------------------------------------
	est use Results/ML_CRRA_12_V0.ster
	ml model lf ML_CRRA_12() (rra1: $LHS_RA repeat = ${treat2_RA}) (rra2: ${treat2_RA}) (LNmuRA: ${treat2_RA}), ///
				   cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) continue
	ml display
	est save Results/ML_CRRA_12_V1.ster, replace
	
//-----------------------------------------------------------
// RC model without sample selection: no controls, nrep = 50
//-----------------------------------------------------------
global nrep = 50
MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(2)

est use Results/ML_CRRA_12_V0.ster
matrix start = e(b), 0.1, 0, 0.1

ml model gf0 MSL_CRRA_RC_12() (rra1: ${LHS_RA} repeat = ) (rra2: ) (LNmuRA: ) (c11: ) (c21: ) (c22: ), ///
				cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) init(start, copy)
ml display
est save Results/nrep${nrep}_MSL_CRRA_RC_12_V0.ster

	//-----------------------------------------------------------------------
	// RC model without sample selection: control for treatments, nrep = 50
	//-----------------------------------------------------------------------
	global nrep = 50
	MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(2)

	est use Results/nrep50_MSL_CRRA_RC_12_V0.ster

	ml model gf0 MSL_CRRA_RC_12() (rra1: ${LHS_RA} repeat = ${treat2_RA}) (rra2: ${treat2_RA}) (LNmuRA: ${treat2_RA}) (c11: ) (c21: ) (c22: ), ///
					cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) continue
	ml display	
	est save Results/nrep${nrep}_MSL_CRRA_RC_12_V1.ster		

	//-----------------------------------------------------------------------
	// RC model without sample selection: control for treatments, nrep = 100
	//-----------------------------------------------------------------------
	global nrep = 100
	MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(2)

	est use Results/nrep50_MSL_CRRA_RC_12_V1.ster
	matrix start = e(b)
	
	ml model gf0 MSL_CRRA_RC_12() (rra1: ${LHS_RA} repeat = ${treat2_RA}) (rra2: ${treat2_RA}) (LNmuRA: ${treat2_RA}) (c11: ) (c21: ) (c22: ), ///
					cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) init(start)
	ml display	
	est save Results/nrep${nrep}_MSL_CRRA_RC_12_V1.ster	
	
restore

//==============================================================================
// B. Models correcting for endogenous sample selection
//==============================================================================

//-------------------------
// Sample selection probit
//-------------------------
probit sample_1 ${RHS_1} if repeat == 0 & first == 1
est save Results/probit_sample_1.ster, replace

probit sample_2 ${RHS_2A} if repeat == 1 & first == 1
est save Results/probit_sample_2.ster, replace

//-------------------------------------------------------
// RC model with sample selection: no control, nrep = 50
//-------------------------------------------------------
global nrep = 50
MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(4)

est use Results/probit_sample_1.ster
mat start_SEL = e(b)
est use Results/probit_sample_2.ster
mat start_SEL = start_SEL, e(b)

est use Results/ML_CRRA_12_V0.ster
mat start_REST = e(b), 0, 0, 0, 0.1, 0, 0, 0, 0.1

mat start = start_SEL, start_REST

ml model gf0 MSL_CRRA_RC_H12() (sel1: ${LHS_RA} sample_1 sample_2 repeat first = ${RHS_1}) ///
							   (sel2: = ${RHS_2A}) (rra1: ) (rra2: ) (LNmuRA: ) (c21: ) (c31: ) (c32: ) (c33: ) (c41: ) (c42: ) (c43: ) (c44: ), ///
							   cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) init(start, copy) 
ml display
est save Results/nrep${nrep}_MSL_CRRA_RC_H12_V0.ster

	//-------------------------------------------------------------------
	// RC model with sample selection: control for treatments, nrep = 50
	//-------------------------------------------------------------------
	global nrep = 50
	MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(4)	
	
	est use Results/nrep50_MSL_CRRA_RC_H12_V0.ster

	ml model gf0 MSL_CRRA_RC_H12() (sel1: ${LHS_RA} sample_1 sample_2 repeat first = ${RHS_1}) ///
								   (sel2: = ${RHS_2A}) (rra1: = ${treat2_RA}) (rra2: = ${treat2_RA}) (LNmuRA: ${treat2_RA}) (c21: ) (c31: ) (c32: ) (c33: ) (c41: ) (c42: ) (c43: ) (c44: ), ///
								   cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) continue
	ml display
	est save Results/nrep${nrep}_MSL_CRRA_RC_H12_V1.ster
	
	//--------------------------------------------------------------------
	// RC model with sample selection: control for treatments, nrep = 100
	//--------------------------------------------------------------------
	global nrep = 100
	MSLinit, id(${id}) burn(${burn}) nrep(${nrep}) neq(4)	
	
	est use Results/nrep50_MSL_CRRA_RC_H12_V1.ster
	matrix start = e(b)

	ml model gf0 MSL_CRRA_RC_H12() (sel1: ${LHS_RA} sample_1 sample_2 repeat first = ${RHS_1}) ///
								   (sel2: = ${RHS_2A}) (rra1: = ${treat2_RA}) (rra2: = ${treat2_RA}) (LNmuRA: ${treat2_RA}) (c21: ) (c31: ) (c32: ) (c33: ) (c41: ) (c42: ) (c43: ) (c44: ), ///
								   cluster(${id}) missing maximize diff technique(bfgs 5 nr 5) init(start)
	ml display
	est save Results/nrep${nrep}_MSL_CRRA_RC_H12_V1.ster

exit
