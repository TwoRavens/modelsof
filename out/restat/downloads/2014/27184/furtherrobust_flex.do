*************************************************************************
********** RESULTS FOR SECTORS WITH HOMOGENEOUS INPUTS  *****************
*************************************************************************
*Table 7 "Fully Flexible Materials"

****************************************************************
***estimation on subsample of homogenous inputs sectors
*****************************************************************

use basefile.dta
run makepolynomialv5_.ado
	//calls program to construct polynomial of a list of variables
run acf_train_bootstrapped.do
	//calls program acf_trainingbootstrap that estimates production function

*selecting sectors with homogeneous inputs
gen homdum = 1 if nace2 == 16
replace homdum = 1 if nace2 == 23
replace homdum = 1 if nace2 == 27
replace homdum = 1 if nace2 == 15
replace homdum = 1 if nace2 == 61
replace homdum = 1 if nace2 == 21
replace homdum = 1 if nace2 == 55
replace homdum = 1 if nace2 == 14
replace homdum = 1 if nace2 == 40
replace homdum = 1 if nace2 == 1
replace homdum = 1 if nace2 == 22
replace homdum = 1 if nace2 == 73
replace homdum = 1 if nace2 == 60
replace homdum = 1 if nace2 == 24
replace homdum = 1 if nace2 == 41
replace homdum = 0 if homdum == .

keep if homdum == 1
***************************************************

set more off

*****make polynomial
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

******all sectors****
tab nace2 , gen(ndum)


set seed 123456789
bootstrap  "acf_trainingbootstrap, exog(k l trainlshare)" r(btrain_acfGMMfix) r(bk_acfGMMfix) r(bl_acfGMMfix) /*
			*/   r(btrainl_olsm) /*
			*/ r(bl_olsm) r(bk_olsm) r(btr_wagebase) r(btr_wageaug) r(bcl_wageaug) r(btfp_wageaug) /*
			*/ , reps(500) cluster(mark) dots 

nlcom _b[_bs_1]/_b[_bs_3]
nlcom _b[_bs_4]/_b[_bs_5]
testnl _b[_bs_1]/_b[_bs_3] = _b[_bs_8]
testnl _b[_bs_4]/_b[_bs_5] = _b[_bs_7]

