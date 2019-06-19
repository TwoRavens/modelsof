******estimates for regression with type of contract and schooling variable included****

*Table 8 "Type of Contract and Schooling"

use basefile.dta
run makepolynomialv5_.ado
	//calls program to construct polynomial of a list of variables
run acf_train_bootstrapped_blueschool.do
	//calls program acf_trainingbootstrap that estimates production function

gen arbsh = endemplarbfte/endemplfte
gen bedsh = endemplbedienfte/endemplfte
gen mansh = endemplmanfte / endemplfte

keep if typeofschemelastyear == 1 		// only large firms have to report the skill composition of in and outflows

******defining schooling variable
run defineschooling
gen schooling = totinschooledshare
set more off

drop if bedsh > 1 & bedsh ~= .
drop if mansh > 1 & mansh ~= .

replace bedsh = bedsh + mansh
drop mansh
drop if bedsh > 1


drop  infte- outself



*****make polynomial
makepolynomialv5_ k l m trainlshare bedsh schooling, polypower(4)			//program to construct polynomial
global polynomial k1* k2* k3* k4 l1* l2* l3* l4 m1* m2* m3* m4 trainlshare1* trainlshare2* trainlshare3* trainlshare4* bedsh1* bedsh2* bedsh3* bedsh4* schooling1* schooling2* schooling3* schooling4*	


*****create year dummies
tab year, gen(ydum)


tsset mark year
gen k_lag = l.k
gen l_lag = l.l
gen trainlshare_lag = l.trainlshare
gen bedsh_lag = l.bedsh


****dropping missing observations
gen todrop = missing(k, l, m, bedsh, schooling)
keep if todrop == 0

******all sectors****
tab nace2 , gen(ndum)


set seed 123456789
bootstrap  "acf_trainingbootstrapbediensch, exog(k l trainlshare bedsh schooling)" r(btr_acfGMMfix) r(bk_acfGMMfix) r(bl_acfGMMfix) /*
			*/  r(bbed_acfGMMfix) r(bschool_acfGMMfix) r(btr_olsm) r(bbed_olsm) r(bschool_olsm) r(bl_olsm) r(bk_olsm) /*
			*/ r(btr_wagebase) r(bbed_wagebase) r(bschool_wagebase) r(btr_wageaug) r(bbed_wageaug) r(bschool_wageaug) /*
			*/ r(bcl_wageaug) r(btfp_wageaug) , reps(500) cluster(mark) dots

nlcom _b[_bs_1]/_b[_bs_3]
nlcom _b[_bs_6]/_b[_bs_9]
testnl _b[_bs_1]/_b[_bs_3] = _b[_bs_14]
testnl _b[_bs_6]/_b[_bs_9]=_b[_bs_11]
 
