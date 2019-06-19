****do-file to perform robustness check "Wage as Control" in Table 7

*executed on Stata 11.2

use basefile.dta

gen w = ln(wage)

*******ALL SECTORS******
*****restricted sample
gen sample = missing(k,l,m)
replace sample = 1-sample
keep if sample == 1

*******************************

****************************************
*****program***************************
capture program drop ols_wage 
program define ols_wage, rclass
tempvar tfp
reg av l k trainlshare w ndum* ydum* 
return scalar bl = _b[l]
return scalar bk = _b[k]
return scalar btr = _b[trainlshare]
gen `tfp' = av - _b[l]*l - _b[k]*k - _b[trainlshare]*trainlshare
reg w trainlshare cl `tfp' ndum* ydum*
return scalar acl = _b[cl]
return scalar atr = _b[trainlshare]
return scalar atfp = _b[`tfp']

end
********************************************



*Bootstrapping the program

tab year, gen(ydum)
tab nace2, gen(ndum)
gen cl = ln((tangibleassetstheur/capitaldefl)/avemplfte)


set seed 123456789
bootstrap  "ols_wage" r(bl) r(bk) r(btr) /*
			*/   r(atr) r(acl) r(atfp)   /*
			*/ , reps(500) cluster(mark) dots

nlcom _b[_bs_3]/_b[_bs_1]
testnl _b[_bs_3]/_b[_bs_1] = _b[_bs_4]


