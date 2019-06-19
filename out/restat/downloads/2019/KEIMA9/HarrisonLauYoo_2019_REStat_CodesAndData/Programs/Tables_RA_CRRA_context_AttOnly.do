//-----------------------------------------------------------------------------------------------------
// Post-estimation results for EUT model with attrition + contextual utility
//-----------------------------------------------------------------------------------------------------

	// set globals for latent preference parameters
	global parameters	"sel2 rra1 rra2"
	global labels		"sel2 rra1 rra2"
	
	// set global to indicate which of the above parameters are normal (instead of log-normal)
	global normals		"sel2 rra1 rra2"
	
	// set global to indicate variables capturing observed heterogeneity in the above parameters
	global obshet 		"RAfirst RAhigh"

	// set global for tests of temporal stability
	global test_labels	"rra"

log using Tables\Context\TableC7_EUT_AttOnly.log, replace text 
//-------------------------------------------
// EUT with CRRA utility and contextual utility
//-------------------------------------------
	//------------------------------------------
	// Correction for endogenous attrition only
	//------------------------------------------
	est use  Results/nrep100_MSL_CRRA_RC_A12_CA1.ster
	qui est store RAW
	ereturn list
	estimates replay	
	
	MSLdisplayA, parameters($parameters) labels($labels) normals($normals) obshet($obshet)

	//==========================
	// Mean of final parameters 
	//==========================
	nlcom ${mean}, post
	qui est store mean
	qui est restore RAW
	
	//========================
	// SD of final parameters 
	//========================
	nlcom ${std}, post
	qui est store std
	qui est restore RAW

	//==============================================
	// Correlation coefficients of final parameters 
	//==============================================
	nlcom ${cor}, post
	qui est store cor
	qui est restore RAW

	//==========================================
	// Standard Deviations of Fechnerian errors 
	//==========================================
	local muRA  (muRA_cons:  exp([LNmuRA]_cons))
	foreach v of varlist $obshet {
		capture display [LNmuRA]`v'
		if (_rc == 0) local muRA `muRA' (muRA_`v':  exp([LNmuRA]_cons + [LNmuRA]`v') - exp([LNmuRA]_cons))
	}
	nlcom `muRA', post
	qui est store mu
	est restore RAW
	
	//===============================================================================================
	// Test of temporal stability for means and standard deviations for random coefficienrs
	//===============================================================================================
	foreach stat in mean {
		est restore `stat' 
		macro drop _T_`stat'
		foreach param in ${test_labels} {
			local T_`stat' `T_`stat'' (T_`stat'_`param'_cons: _b[`stat'_`param'2_cons] - _b[`stat'_`param'1_cons])
			foreach v of varlist $obshet {
				capture display _b[`stat'_`param'2_`v'] _b[`stat'_`param'1_`v'] 
				if (_rc == 0) local T_`stat' `T_`stat'' (T_`stat'_`param'_`v': (_b[`stat'_`param'2_cons] + _b[`stat'_`param'2_`v']) - (_b[`stat'_`param'1_cons] + _b[`stat'_`param'1_`v'])) 
			}
		}
		nlcom `T_`stat''
	}
	foreach stat in std {
		est restore `stat' 
		macro drop _T_`stat'
		foreach param in ${test_labels} {
			local T_`stat' `T_`stat'' (T_`stat'_`param': _b[`stat'_`param'2] - _b[`stat'_`param'1])
		}
		nlcom `T_`stat''
	}	
	
	//==========================================================================
	// Joint hypothesis tests of temporal stability in population distributions
	//==========================================================================
	est restore RAW
	nlcom ${mean_UN} ${std_UN}, post
	foreach param in $test_labels {
		local T_mean_`param' (_b[mean_UN_`param'1_cons] = _b[mean_UN_`param'2_cons]) 
		foreach v of varlist $obshet {
			capture display _b[mean_UN_`param'2_`v'] _b[mean_UN_`param'1_`v'] 
			if (_rc == 0) local T_mean_`param' `T_mean_`param'' (_b[mean_UN_`param'1_`v'] = _b[mean_UN_`param'2_`v'])  
		}
		local T_meanNstd_`param' `T_mean_`param'' (_b[std_UN_`param'1] = _b[std_UN_`param'2]) 
	}
	
	// H0: temporal stability in the mean of rra
	test `T_mean_rra'
	
	// H0: temporal stability in the distribution (i.e. mean and SD) of rra
	test `T_meanNstd_rra'		

	//========================================================
	// Joint hypothesis tests of attrition bias
	//========================================================
	est restore RAW
	nlcom ${cor_UN}, post	

	// H0: no attrition bias
	test (_b[cor_UN_sel2_rra1] = 0) (_b[cor_UN_sel2_rra2] = 0)  
			
// close log file
log close 	
