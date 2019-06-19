***Do-file to obtain results for the stock of training
**First the do-file construct_stock.do needs to be run to generate 
**data file trainingstock_tomerge.dta

use basefile.dta
run makepolynomialv5_.ado
	//calls program to construct polynomial of a list of variables
run acf_train_bootstrapped_stock.do
	//calls program acf_trainingbootstrap that estimates production function

	
	
sort idnumber year
merge 1:1 idnumber year using trainingstock_tomerge.dta /* 
	*/ , keepusing(stockl25pimshare stockl25pim2share stockl50pimshare stockl50pim2share stockh25pimperl /*
	*/ stockh25pim2perl stockh50pimperl stockh50pim2perl flagl flagh)
	//file was created in do-file construct_stock.do
drop if _merge == 2
drop _merge


*****make polynomial
makepolynomialv5_ k l m stockl25pimshare, polypower(4)			//program to construct polynomial
global polynomial k1* k2* k3* k4 l1* l2* l3* l4 m1* m2* m3* m4 stockl25pimshare1* stockl25pimshare2* stockl25pimshare3* stockl25pimshare4*	


*****create year dummies
tab year, gen(ydum)

drop if flagl == 1
	//outliers training stock

tsset mark year
gen k_lag = l.k
gen l_lag = l.l
gen stockl25pimshare_lag = l.stockl25pimshare

****dropping missing observations
gen todrop = missing(k, l, m)
keep if todrop == 0
save temp_loopall, replace

******all sectors****
tab nace2 , gen(ndum)


set seed 123456789
bootstrap  "acf_trainingbootstrap, exog(k l stockl25pimshare)" r(btrain_acfGMMfix) r(bk_acfGMMfix) r(bl_acfGMMfix) /*
			*/   r(btrainl_olsm) /*
			*/ r(bl_olsm) r(bk_olsm) r(btr_wagebase) r(btr_wageaug) r(bcl_wageaug) r(btfp_wageaug) /*
			*/ , reps(500) cluster(mark) dots saving(bootstrapiterations_all2)

nlcom _b[_bs_1]/_b[_bs_3]
nlcom _b[_bs_4]/_b[_bs_5]
testnl _b[_bs_1]/_b[_bs_3] = _b[_bs_8]
testnl _b[_bs_4]/_b[_bs_5] = _b[_bs_7]

***************************************************************************************************************			

