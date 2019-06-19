
use basefile.dta
gen w = ln(wage)

tab year , gen(ydum)
tab nace2, gen(ndum)

**********************************************
*defining program that will be bootstrapped
**********************************************

	capture program drop ols 
	program define ols, rclass

		reg av l k trainlshare ndum* ydum* 
		return scalar bl = _b[l]
		return scalar bk = _b[k]
		return scalar btr = _b[trainlshare]

		reg w trainlshare ndum* ydum*
		return scalar atr = _b[trainlshare]

	end

***********************************************


*********************************************
*BOOTSTRAP
********************************************


*All sectors	
	set seed 123456789
	bootstrap  "ols" r(bl) r(bk) r(btr) /*
				*/   r(atr)   /*
				*/ , reps(500) cluster(mark) dots 

	nlcom _b[_bs_3]/_b[_bs_1]
		//Beta_T
	testnl _b[_bs_3]/_b[_bs_1] = _b[_bs_4]			
		//Test beta_T = alpha_T
	
	
*Manufacturing

	use basefile.dta
	keep if nace2 > 14 & nace2 < 37

	gen w = ln(wage)
	tab year , gen(ydum)
	tab nace2, gen(ndum)

	set seed 123456789
	bootstrap  "ols" r(bl) r(bk) r(btr) /*
				*/   r(atr)   /*
				*/ , reps(500) cluster(mark) dots 

	nlcom _b[_bs_3]/_b[_bs_1]
		//beta_T
	testnl _b[_bs_3]/_b[_bs_1] = _b[_bs_4]		
		//Test beta_T = alpha_T

		
*Services

	use basefile.dta

	keep if nace2 < 15 | nace2 > 36

	gen w = ln(wage)
	tab year , gen(ydum)
	tab nace2, gen(ndum)

	set seed 123456789
	bootstrap  "ols" r(bl) r(bk) r(btr) /*
				*/   r(atr)   /*
				*/ , reps(500) cluster(mark) dots 

	nlcom _b[_bs_3]/_b[_bs_1]
		// beta_T
	testnl _b[_bs_3]/_b[_bs_1] = _b[_bs_4]		
		// Test beta_T = alpha_T
	

