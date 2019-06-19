*********************************************************
*Include share of white collar workers and managers
*in program

*Table 8 "Type of Contract"

use basefile.dta
run makepolynomialv5_.ado
	//calls program to construct polynomial of a list of variables
run acf_train_bootstrapped_bluewhite.do
	//defines program to do estimation
	
gen arbsh = endemplarbfte/endemplfte
	//share of blue collar workers
gen bedsh = endemplbedienfte/endemplfte
	//share of employees (white collar)
gen mansh = endemplmanfte / endemplfte
	//share of managers

drop if bedsh > 1 & bedsh ~= .
drop if mansh > 1 & mansh ~= .

*****make polynomial
makepolynomialv5_ k l m trainlshare bedsh mansh, polypower(4)			//program to construct polynomial
global polynomial k1* k2* k3* k4 l1* l2* l3* l4 m1* m2* m3* m4 trainlshare1* trainlshare2* trainlshare3* trainlshare4* bedsh1* bedsh2* bedsh3* bedsh4* mansh1* mansh2* mansh3* mansh4*	


*****create year dummies
tab year, gen(ydum)


tsset mark year
gen k_lag = l.k
gen l_lag = l.l
gen trainlshare_lag = l.trainlshare
gen bedsh_lag = l.bedsh
gen mansh_lag = l.mansh

****dropping missing observations
gen todrop = missing(k, l, m, bedsh, mansh)
keep if todrop == 0


******all sectors****
tab nace2 , gen(ndum)


set seed 123456789
bootstrap  "acf_trainingbootstrapbedien, exog(k l trainlshare bedsh mansh)" r(btr_acfGMMfix) r(bk_acfGMMfix) r(bl_acfGMMfix) /*
			*/  r(bbed_acfGMMfix) r(bman_acfGMMfix) r(btr_olsm) r(bbed_olsm) r(bman_olsm) r(bl_olsm) r(bk_olsm) /*
			*/ r(btr_wagebase) r(bbed_wagebase) r(bman_wagebase) r(btr_wageaug) r(bbed_wageaug) r(bman_wageaug) /*
			*/ r(bcl_wageaug) r(btfp_wageaug) , reps(500) cluster(mark) dots

 
nlcom _b[_bs_1]/_b[_bs_3]
nlcom _b[_bs_6]/_b[_bs_9]
testnl _b[_bs_1]/_b[_bs_3] = _b[_bs_14]
testnl _b[_bs_6]/_b[_bs_9] = _b[_bs_11]

	
