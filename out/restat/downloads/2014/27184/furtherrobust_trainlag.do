*Do-file for further robustness check "Lagged Training" in Table 7


use basefile.dta
run makepolynomialv5_.ado
	//calls program to construct polynomial of a list of variables
run acf_train_bootstrapped.do
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

	******creating sector dummies****
	tab nace2 , gen(ndum)

*Executing Program
	*All sectors pooled
		set seed 123456789
		bootstrap  "acf_trainingbootstrap, exog(k l trainlshare_lag)" r(btrain_acfGMMfix) r(bk_acfGMMfix) r(bl_acfGMMfix) /*
					*/   r(btrainl_olsm) /*
					*/ r(bl_olsm) r(bk_olsm) r(btr_wagebase) r(btr_wageaug) r(bcl_wageaug) r(btfp_wageaug) /*
					*/ , reps(500) cluster(mark) dots 

		/*
		This results in the following estimates used in Table 2 ("Total" columns):
		Production function:
			bl_olsm is the labor coefficient for OLS2
			bk_olsm is the capital coefficient for OLS2
			btrainl_olsm is the training coefficient for OLS2, used to compute beta_T
			bl_acfGMMfix is the labor coefficient for ACF
			bk_acfGMMfix is the capital coefficient for ACF
			btrain_acfGMMfix is the training coefficient for ACF, used to compute beta_T
		Wage equation:
			btr_wagebase is the training coefficient for OLS2
			btr_wageaug is the training coefficient for ACF
			bcl_wageaug is the coefficient on the capital/labor ratio for ACF
			btfp_wageaug is the coefficient on total factor productivity for ACF
		*/
		
		*Obtaining standard errors for beta_T and testing for equality of alpha_T and beta_T			
			nlcom _b[_bs_1]/_b[_bs_3]
				//beta_T and its standard error for ACF
			nlcom _b[_bs_4]/_b[_bs_5]
				//beta_T and its standard error for OLS2
			testnl _b[_bs_1]/_b[_bs_3] = _b[_bs_8]
				//test for equality of beta_T and alpha_T for ACF
			testnl _b[_bs_4]/_b[_bs_5] = _b[_bs_7]
				//test for equality of beta_T and alpha_T for OLS2
