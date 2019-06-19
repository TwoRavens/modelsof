*******************************************************************************************
******************************** BASE RESULTS PER SECTOR***********************************

*Programs for Table 3 and 4 where labor is assumed to be homogeneous
*Generates stata file acf_train_bootstrapREStat.dta with the results per sector


set obs 1
gen nace2 = .
save acf_train_bootstrapREStat

use basefile.dta
run makepolynomialv5_.ado
	//calls program to construct polynomial of a list of variables
run acf_train_bootstrapped
	//calls program acf_trainingbootstrap that estimates production function

*Preparing Data	
	*Make polynomial of order 4 in capital, labor, materials and training
	makepolynomialv5_ k l m trainlshare, polypower(4)			//program to construct polynomial
	global polynomial k1* k2* k3* k4 l1* l2* l3* l4 m1* m2* m3* m4 trainlshare1* trainlshare2* trainlshare3* trainlshare4*	


	*****create year dummies
	tab year, gen(ydum)

	tsset mark year
	gen k_lag = l.k
	gen l_lag = l.l
	gen trainlshare_lag = l.trainlshare

	****dropping missing observations
	gen todrop = missing(k, l, m)
	keep if todrop == 0
	save temp_loopall, replace


	levelsof nace2, local(sectors)

	foreach i of local sectors {
		use temp_loopall, clear
		keep if nace2 == `i'
		quietly: sum m
		if r(N) > 300 {
			*****create sector dummies
			tab nace4, gen(ndum)
			set seed 123456789
			bootstrap  "acf_trainingbootstrap, exog(k l trainlshare)" r(btrain_acfGMMfix) r(bk_acfGMMfix) r(bl_acfGMMfix) /*
				*/    r(btrainl_olsm) /*
				*/ r(bl_olsm) r(bk_olsm) r(btr_wagebase) r(btr_wageaug) r(bcl_wageaug) r(btfp_wageaug) /*
				*/ , reps(500) cluster(mark) dots
				
			keep if _n == 1
			local temp "b se"					//keeping standard errors and point estimates
			foreach n of local temp {
				gen `n'train_acfGMMfix = _`n'[_bs_1]
				gen `n'k_acfGMMfix = _`n'[_bs_2]
				gen `n'l_acfGMMfix = _`n'[_bs_3]
				gen `n'train_ols = _`n'[_bs_4]
				gen `n'l_ols = _`n'[_bs_5]
				gen `n'k_ols = _`n'[_bs_6]
				gen `n'tr_wagebase = _`n'[_bs_7]
				gen `n'tr_wageaug = _`n'[_bs_8]
				gen `n'cl_wageaug = _`n'[_bs_9]
				gen `n'tfp_wageaug = _`n'[_bs_10]
			}
			
			/*
			This results in the following estimates
			Production function:
				bl_olsm is the labor coefficient for OLS
				bk_olsm is the capital coefficient for OLS
				btrainl_olsm is the training coefficient for OLS, used to compute beta_T
				bl_acfGMMfix is the labor coefficient for ACF
				bk_acfGMMfix is the capital coefficient for ACF
				btrain_acfGMMfix is the training coefficient for ACF, used to compute beta_T
			Wage equation:
				btr_wagebase is the training coefficient for OLS
				btr_wageaug is the training coefficient for ACF
				bcl_wageaug is the coefficient on the capital/labor ratio for ACF
				btfp_wageaug is the coefficient on total factor productivity for ACF
			and likewise for the standard errors (but then called se* instead of b*)
			*/
	

			gen nrobs = e(N)
			gen nrclust = e(N_clust)
			
			nlcom _b[_bs_1]/_b[_bs_3]
			matrix bACF = r(b)
			matrix VACF = r(V)
			scalar betaT_ACF = bACF[1,1]
			scalar sebetaT_ACF = sqrt(VACF[1,1])
			gen betaT_ACF = betaT_ACF
			gen sebetaT_ACF = sebetaT_ACF
			nlcom _b[_bs_4]/_b[_bs_5]
			matrix bOLS = r(b)
			matrix VOLS = r(V)
			scalar betaT_OLS = bOLS[1,1]
			scalar sebetaT_OLS = sqrt(VOLS[1,1])
			gen betaT_OLS = betaT_OLS
			gen sebetaT_OLS = sebetaT_OLS
			
		keep nace2 *_ols *acf* *_wage* nrobs nrclust betaT* sebetaT*
		append using acf_train_bootstrapREStat
		save acf_train_bootstrapREStat, replace
		}
		else if _N < 300 {
		di in red "Not enough observations for sector `i'"
		}
	}

	
	erase temp_loopall.dta
