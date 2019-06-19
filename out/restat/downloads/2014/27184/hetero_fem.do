******estimates for regression with share of females included****
*Table 8 "Female/Male Employees"


use basefile.dta
run makepolynomialv5_.ado
	//calls program to construct polynomial of a list of variables
run acf_train_bootstrapped_female.do
	//calls program acf_trainingbootstrap that estimates production function


drop femshare
gen femsh = endemplffte/(endemplmfte + endemplffte)

*****make polynomial
makepolynomialv5_ k l m trainlshare femsh, polypower(4)			//program to construct polynomial
global polynomial k1* k2* k3* k4 l1* l2* l3* l4 m1* m2* m3* m4 trainlshare1* trainlshare2* trainlshare3* trainlshare4* femsh1* femsh2* femsh3* femsh4*


*****create year dummies
tab year, gen(ydum)


tsset mark year
gen k_lag = l.k
gen l_lag = l.l
gen trainlshare_lag = l.trainlshare
gen femsh_lag = l.femsh

****dropping missing observations
gen todrop = missing(k, l, m, femsh)
keep if todrop == 0

******all sectors****
tab nace2 , gen(ndum)


set seed 10
bootstrap  "acf_trainingbootstrapfem, exog(k l trainlshare femsh)" r(btr_acfGMMfix) r(bk_acfGMMfix) r(bl_acfGMMfix) /*
			*/  r(bfem_acfGMMfix) r(btr_olsm) r(bfem_olsm) r(bl_olsm) r(bk_olsm) /*
			*/ r(btr_wagebase) r(bfem_wagebase) r(btr_wageaug) r(bfem_wageaug)  /*
			*/ r(bcl_wageaug) r(btfp_wageaug) , reps(500) cluster(mark) dots

 nlcom _b[_bs_1]/_b[_bs_3]
 nlcom _b[_bs_5]/_b[_bs_7]
 testnl _b[_bs_1]/_b[_bs_3] = _b[_bs_11]
 testnl _b[_bs_5]/_b[_bs_7] = _b[_bs_9]
