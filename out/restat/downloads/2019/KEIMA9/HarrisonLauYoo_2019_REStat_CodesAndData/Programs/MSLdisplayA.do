//==========================================================================================================
// MSLdisplay for models that only correct for endogenous attrition
// NOTE: This code assumes that the first random parameter listed in option -parameters()- 
//       is the attrition error in models with endogenous sample selection: say, sel2.
//		 The code computes variances, covariances and correlations involving sel2.
//       The code does not compute the mean and standard deviation of sel2.
//==========================================================================================================
	
program define MSLdisplayA
	syntax, parameters(namelist) [labels(namelist) normals(namelist) obshet(varlist)]
	
	//=======================================================================
	// NO ADDITIONAL INPUT IS NEEDED: THE PROGRAM RUNS ON ITS OWN HEREAFTER.	
	//=======================================================================
	
	// equate labels with parameters in case option label() hasn't been specified
	if ("`labels'" == "") local labels `parameters' 
	
	// count the number of latent preference parameters
	local neq = wordcount("`parameters'")
	
	// give simpler names to Cholesky factors to simplify syntax
	forvalues f = 1/`neq' {
		forvalues s = 1/`f' {
			local c`f'`s' [c`f'`s']_cons 
			// display "c`f'`s'"
		}
	}
	
	// normalize Cholesky factors to set Var(attrition error) = 2 
	local c11 = 1 

	// rename estimated parameters to simplify syntax (i-th parameter is called i instead of its actual name)
	local i=0
	foreach x in `parameters' {
		local i=`i'+1
		
		// check if the `i'th parameter in `parameters' is listed under `normals' 
		local flag_normal = strpos("`normals'", word("`parameters'", `i')) 
		
		// take actions depending on whether it's log-normal (flag_normal = 0) or normal (flag_normal > 0)
		if (`flag_normal' == 0) local LN`i'_cons [LN`x']_cons
		if (`flag_normal' >  0) local LV`i'_cons [`x']_cons
		
		// address observed heterogeneity if there is any
		if ("`obshet'" != "") {
			foreach v of varlist `obshet' {
				if (`flag_normal' == 0) local LN`i'_`v' [LN`x']`v'
				if (`flag_normal' >  0) local LV`i'_`v' [`x']`v'	
			}	
		}
	}
	
	// generate macros to hold labels for final parameters 
	local i = 0
	foreach x in `labels' {
		local i = `i' + 1
		local label_`i' `x'
	}	
	
	//---------------------------------------------------------------
	// Step 1. derive variance and covariances of underlying normals
	//---------------------------------------------------------------
	// variance of underlying normals (note that first two normal is the attrition error)
	global var_UN1 (2)
	forvalues f = 2/`neq' {		
		forvalues s = 1/`f' {
			if (`s' == 1) global var_UN`f' (`c`f'`s'')^2
			if (`s' >  1) global var_UN`f' ${var_UN`f'} + (`c`f'`s'')^2
		}
	}
	
	// covariances of underlying normals
	forvalues f = 1/`neq' {
		forvalues s = `=`f'+1'/`neq' {
			forvalues t = 1/`f' {
				if (`t' == 1) global cov_UN`f'_UN`s' (`c`f'`t''*`c`s'`t'')
				if (`t' >  1) global cov_UN`f'_UN`s' ${cov_UN`f'_UN`s'} + (`c`f'`t''*`c`s'`t'')
			}
			// display "cov_UN`f'_UN`s' = ${cov_UN`f'_UN`s'}"
		}
	}
	
	//-------------------------------------------------------------------------------------------------------------------------
	// Step 2. Collect means SD, covariances and correlation coefficients for underlying normal distributions into single macro
	//-------------------------------------------------------------------------------------------------------------------------
	// means of underlying normal distributions
	macro drop mean_UN
	forvalues f = 2/`neq' {
		// check if the `f'th parameter is log-normal (flag_normal = 0) or normal (flag_normal > 0)
		local flag_normal = strpos("`normals'", word("`parameters'", `f')) 
		
		if (`flag_normal' == 0) {
			global mean_UN_`label_`f''_cons (mean_UN_`label_`f''_cons:  `LN`f'_cons') 
			global mean_UN  ${mean_UN}	    (mean_UN_`label_`f''_cons:  `LN`f'_cons')
			
			// address observed heterogeneity if there is any
			if ("`obshet'" != "") {
				foreach v of varlist `obshet' {
					// check whether parameter f is indeed conditioned on variable v, and take further actions only if it is.
					capture display `LN`f'_`v''
					if (_rc == 0) {
						global mean_UN_`label_`f''_`v' (mean_UN_`label_`f''_`v':  `LN`f'_`v'') 
						global mean_UN  ${mean_UN}	   (mean_UN_`label_`f''_`v':  `LN`f'_`v'')					
					}
				}
			}
		}
		
		if (`flag_normal' >  0) {
			global mean_UN_`label_`f''_cons	(mean_UN_`label_`f''_cons:  `LV`f'_cons') 
			global mean_UN  ${mean_UN}	    (mean_UN_`label_`f''_cons:  `LV`f'_cons') 
			
			// address observed heterogeneity is there is any
			if ("`obshet'" != "") {
				foreach v of varlist `obshet' {
					// check whether parameter f is indeed conditioned on variable v, and take further actions only if it is.
					capture display `LV`f'_`v''
					if (_rc == 0) {
						global mean_UN_`label_`f''_`v' (mean_UN_`label_`f''_`v':  `LV`f'_`v'') 
						global mean_UN  ${mean_UN}	   (mean_UN_`label_`f''_`v':  `LV`f'_`v'')
					}
				}
			}
		}		
	}

	// standard deviations of underlying normal distributions
	macro drop std_UN
	forvalues f = 2/`neq' {
		global std_UN_`label_`f''	(std_UN_`label_`f'': sqrt(${var_UN`f'}))	
		global std_UN ${std_UN}		(std_UN_`label_`f'': sqrt(${var_UN`f'}))	
	}

	// covariances of underlying normal distributions
	macro drop cov_UN
	forvalues f = 1/`neq' {
		forvalues s = `=`f'+1'/`neq' {		
			global cov_UN_`label_`f''_`label_`s''	(cov_UN_`label_`f''_`label_`s'': ${cov_UN`f'_UN`s'})
			global cov_UN ${cov_UN}					(cov_UN_`label_`f''_`label_`s'': ${cov_UN`f'_UN`s'})
		}
	}

	// correlation coefficients of underlying normal distributions
	macro drop cor_UN
	forvalues f = 1/`neq' {
		forvalues s = `=`f'+1'/`neq' {
			global cor_UN_`label_`f''_`label_`s''	(cor_UN_`label_`f''_`label_`s'': (${cov_UN`f'_UN`s'}) / sqrt(${var_UN`f'}) / sqrt(${var_UN`s'})) 
			global cor_UN ${cor_UN}					(cor_UN_`label_`f''_`label_`s'': (${cov_UN`f'_UN`s'}) / sqrt(${var_UN`f'}) / sqrt(${var_UN`s'})) 
		}
	}	
	
	//-----------------------------------------------------
	// Step 3. Derive median and mean of final parameters
	//-----------------------------------------------------
	macro drop med mean
	forvalues f = 2/`neq' {
		// check if the `f'th parameter is log-normal (flag_normal = 0) or normal (flag_normal > 0)
		local flag_normal = strpos("`normals'", word("`parameters'", `f'))
		
		if (`flag_normal' == 0) {
			global med_`label_`f''_cons	 (med_`label_`f''_cons:  exp(`LN`f'_cons')) 
			global med  ${med}		     (med_`label_`f''_cons:  exp(`LN`f'_cons')) 
			global mean_`label_`f''_cons (mean_`label_`f''_cons: exp(`LN`f'_cons' + 0.5*(${var_UN`f'})))
			global mean ${mean}		     (mean_`label_`f''_cons: exp(`LN`f'_cons' + 0.5*(${var_UN`f'})))
			
			// address observed heterogeneity is there is any
			if ("`obshet'" != "") {
				foreach v of varlist `obshet' {
					// check whether parameter f is indeed conditioned on variable v, and take further actions only if it is.
					capture display `LN`f'_`v''
					if (_rc == 0) {
						global med_`label_`f''_`v'  (med_`label_`f''_`v':  exp(`LN`f'_cons' + `LN`f'_`v'') - exp(`LN`f'_cons')) 
						global med  ${med}		    (med_`label_`f''_`v':  exp(`LN`f'_cons' + `LN`f'_`v'') - exp(`LN`f'_cons')) 
						global mean_`label_`f''_`v' (mean_`label_`f''_`v': exp(`LN`f'_cons' + `LN`f'_`v'' + 0.5*(${var_UN`f'})) - exp(`LN`f'_cons' + 0.5*(${var_UN`f'})))
						global mean ${mean}		    (mean_`label_`f''_`v': exp(`LN`f'_cons' + `LN`f'_`v'' + 0.5*(${var_UN`f'})) - exp(`LN`f'_cons' + 0.5*(${var_UN`f'})))				
					}
				}
			}			
		}
		
		if (`flag_normal' >  0) {
			global med_`label_`f''_cons	 (med_`label_`f''_cons:  `LV`f'_cons') 
			global med  ${med}		     (med_`label_`f''_cons:  `LV`f'_cons') 
			global mean_`label_`f''_cons (mean_`label_`f''_cons: `LV`f'_cons')
			global mean ${mean}		     (mean_`label_`f''_cons: `LV`f'_cons')
			
			// address observed heterogeneity is there is any
			if ("`obshet'" != "") {
				foreach v of varlist `obshet' {
					// check whether parameter f is indeed conditioned on variable v, and take further actions only if it is.
					capture display `LV`f'_`v''
					if (_rc == 0) {
						global med_`label_`f''_`v'	(med_`label_`f''_`v':  `LV`f'_`v'') 
						global med  ${med}		    (med_`label_`f''_`v':  `LV`f'_`v'') 
						global mean_`label_`f''_`v' (mean_`label_`f''_`v': `LV`f'_`v'')
						global mean ${mean}		    (mean_`label_`f''_`v': `LV`f'_`v'')			
					}		
				}
			}				
		}		
	}

	//--------------------------------------------------------
	// Step 4. Derive standard deviations of final parameters
	//--------------------------------------------------------
	macro drop std
	forvalues f = 2/`neq' {
		// check if the `f'th parameter is log-normal (flag_normal = 0) or normal (flag_normal > 0)
		local flag_normal = strpos("`normals'", word("`parameters'", `f'))
		
		if (`flag_normal' == 0) {
			local ATmean 0
			
			// address observed heterogeneity is there is any: we evaluate std at the mean values of observed heterogeneity for participants
			if ("`obshet'" != "") {
				foreach v of varlist `obshet' {
					// check whether parameter f is indeed conditioned on variable v, and take further actions only if it is.
					capture display `LN`f'_`v''
					if (_rc == 0) {
						if ("`v'" == "RAhigh")  local ATmean `ATmean' + `LN`f'_`v''*0.5
						if ("`v'" == "IDRhigh") local ATmean `ATmean' + `LN`f'_`v''*0.4987893
						if ("`v'" == "RAfirst") local ATmean `ATmean' + `LN`f'_`v''*0.5544794 	
						if ("`v'" != "RAhigh" & "`v'" != "IDRhigh" & "`v'" != "RAfirst") {
							qui sum `v' if sample_1 == float(1) & repeat == float(0), meanonly
							local ATmean `ATmean' + `LN`f'_`v''*`=r(mean)'
						}
					}
				}
			} 			
			
			global var_`f' (exp(${var_UN`f'}) - 1) * exp(2*(`LN`f'_cons' + `ATmean') + ${var_UN`f'})
		}
		
		if (`flag_normal' >  0) global var_`f' ${var_UN`f'}
		
		global std_`label_`f''	(std_`label_`f'': sqrt(${var_`f'}))
		global std ${std}		(std_`label_`f'': sqrt(${var_`f'}))
	}

	//-------------------------------------------------------------
	// Step 5. Derive correlation coefficients of final parameters
	//-------------------------------------------------------------
	macro drop cor
	forvalues f = 1/`neq' {
		// check if the `f'th parameter is log-normal (flag_normal_L = 0) or normal (flag_normal_L > 0)		
		local flag_normal_L = strpos("`normals'", word("`parameters'", `f')) 		
		forvalues s = `=`f'+1'/`neq' {
			// check if the `s'th parameter is log-normal (flag_normal_R = 0) or normal (flag_normal_R > 0)	
			local flag_normal_R = strpos("`normals'", word("`parameters'", `s'))
			if (`flag_normal_L' == 0 & `flag_normal_R' == 0) global cor_`label_`f''_`label_`s''	(cor_`label_`f''_`label_`s'': (exp(${cov_UN`f'_UN`s'})-1) / sqrt(exp(${var_UN`f'})-1) / sqrt(exp(${var_UN`s'})-1)) 
			if (`flag_normal_L' == 0 & `flag_normal_R' == 0) global cor ${cor}					(cor_`label_`f''_`label_`s'': (exp(${cov_UN`f'_UN`s'})-1) / sqrt(exp(${var_UN`f'})-1) / sqrt(exp(${var_UN`s'})-1)) 

			if (`flag_normal_L' == 0 & `flag_normal_R' >  0) global cor_`label_`f''_`label_`s''	(cor_`label_`f''_`label_`s'': (${cov_UN`f'_UN`s'})          / sqrt(exp(${var_UN`f'})-1) / sqrt(${var_UN`s'}))  
			if (`flag_normal_L' == 0 & `flag_normal_R' >  0) global cor ${cor}					(cor_`label_`f''_`label_`s'': (${cov_UN`f'_UN`s'})          / sqrt(exp(${var_UN`f'})-1) / sqrt(${var_UN`s'}))  

			if (`flag_normal_L' >  0 & `flag_normal_R' == 0) global cor_`label_`f''_`label_`s''	(cor_`label_`f''_`label_`s'': (${cov_UN`f'_UN`s'})          / sqrt(${var_UN`f'})        / sqrt(exp(${var_UN`s'})-1))
			if (`flag_normal_L' >  0 & `flag_normal_R' == 0) global cor ${cor}					(cor_`label_`f''_`label_`s'': (${cov_UN`f'_UN`s'})          / sqrt(${var_UN`f'})        / sqrt(exp(${var_UN`s'})-1))

			if (`flag_normal_L' >  0 & `flag_normal_R' >  0) global cor_`label_`f''_`label_`s''	(cor_`label_`f''_`label_`s'': (${cov_UN`f'_UN`s'})          / sqrt(${var_UN`f'})        / sqrt(${var_UN`s'}))			
			if (`flag_normal_L' >  0 & `flag_normal_R' >  0) global cor ${cor}					(cor_`label_`f''_`label_`s'': (${cov_UN`f'_UN`s'})          / sqrt(${var_UN`f'})        / sqrt(${var_UN`s'}))			
		}
	}	
end

exit
