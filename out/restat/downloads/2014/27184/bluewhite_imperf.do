****************** program to estimate returns to training when labor is seperated ******
********** 	      		into blue collar and white collar workers 	  ************

use basefile.dta
run makepolynomialv5_.ado
	//calls program to construct polynomial of a list of variables
run acf_train_bootstrapped_blue.do
	//calls program acf_trainingbootstrap that estimates production function making a distinction between
	//blue and white collar workers

drop bedienshare manshare othshare	test

gen bedshare = endemplbedienfte / endemplfte
gen arbshare = endemplarbfte / endemplfte
gen othshare = endemplothfte / endemplfte
gen manshare = endemplmanfte / endemplfte


*****create year dummies
tab year, gen(ydum)

drop if bedshare == .

gen blueL = endemplarbfte
	//number of blue collar workers
gen whiteL = endemplbedienfte + endemplmanfte
	//number of white collar workers
gen lb = ln(blueL)
count if lb == .
gen lw = ln(whiteL)
count if lw == .

****dropping missing observations
gen todrop = missing(k, l, m, lw, lb)
keep if todrop == 0


gen test = arbshare + bedshare + othshare + manshare 
	//should be equal to 1
drop if test > 1.1
drop if test < .9

tsset mark year
gen k_lag = l.k
gen lb_lag = l.lb
gen lw_lag = l.lw
gen trainlshare_lag = l.trainlshare


*****make polynomial
makepolynomialv5_ k m lw lb trainlshare, polypower(4)			//program to construct polynomial
global polynomial k1* k2* k3* k4 lw1* lw2* lw3* lw4 lb1* lb2* lb3* lb4 m1* m2* m3* m4 trainlshare1* trainlshare2* trainlshare3* trainlshare4*	


tsset mark year

*some extra cleaning
	gen dlb =d.lb
	drop if dlb < -.5
	drop if dlb > .5 & dlb ~= .

tab nace2 , gen(ndum)

*estimation
set seed 10
bootstrap "acf_trainingbootstrapblue, exog(lb_lag lw k k_lag trainlshare)" r(btr_acfGMMfix) /*
			*/ r(blb_acfGMMfix) r(blw_acfGMMfix) r(bk_acfGMMfix) r(btr_olsm) r(blb_olsm) r(blw_olsm) r(bk_olsm) /*
			*/ r(btr_wagebase) r(bbed_wagebase) r(bman_wagebase) r(btr_wageaug) r(bcl_wageaug) r(btfp_wageaug) /*
			*/ r(bbed_wageaug) r(bman_wageaug) r(iter), reps(500) cluster(mark) dots 

nlcom _b[_bs_1]/(_b[_bs_2]+_b[_bs_3])
		// beta_T (ACF)
nlcom _b[_bs_5]/(_b[_bs_6]+_b[_bs_7])
		// beta_T (OLS)
		
testnl _b[_bs_1]/(_b[_bs_2]+_b[_bs_3]) = _b[_bs_12]
		// test beta_T = alpha_T (ACF)
testnl _b[_bs_5]/(_b[_bs_6]+_b[_bs_7]) = _b[_bs_9]
		//test beta_T = alpha_T (OLS)
