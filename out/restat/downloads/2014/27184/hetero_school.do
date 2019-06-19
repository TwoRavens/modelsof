******estimates for regression with schooling variable included****

***Table 8: Schooling


use basefile.dta
run makepolynomialv5_.ado
	//calls program to construct polynomial of a list of variables
run acf_train_bootstrapped_school.do
	//calls program acf_trainingbootstrap that estimates production function

keep if typeofschemelastyear == 1 		// only large firms have to report the skill composition of in and outflows

******defining schooling variable
run defineschooling
gen schooling = totinschooledshare
set more off

*****make polynomial
makepolynomialv5_ k l m trainlshare schooling, polypower(4)			//program to construct polynomial
global polynomial k1* k2* k3* k4 l1* l2* l3* l4 m1* m2* m3* m4 trainlshare1* trainlshare2* trainlshare3* trainlshare4* schooling1* schooling2* schooling3* schooling4*	


*****create year dummies
tab year, gen(ydum)


tsset mark year
gen k_lag = l.k
gen l_lag = l.l
gen trainlshare_lag = l.trainlshare

****dropping missing observations
gen todrop = missing(k, l, m, schooling)
keep if todrop == 0


tab nace2 , gen(ndum)

set seed 123456789
bootstrap  "acf_trainingbootstrapschool, exog(k l trainlshare schooling)" r(btrain_acfGMMfix) r(bk_acfGMMfix) r(bl_acfGMMfix) /*
			*/  r(bschool_acfGMMfix) r(btrainl_olsm) r(bschool_olsm) r(bl_olsm) r(bk_olsm) /* 
			*/ r(btr_wagebase) r(bschool_wagebase) r(btr_wageaug) r(bcl_wageaug) r(btfp_wageaug) r(bschool_wageaug) /*
			*/ , reps(3) cluster(mark) dots
 
nlcom _b[_bs_1]/_b[_bs_3]
nlcom _b[_bs_5]/_b[_bs_7]
testnl _b[_bs_1]/_b[_bs_3] = _b[_bs_11]
testnl _b[_bs_5]/_b[_bs_7] = _b[_bs_9]
 
