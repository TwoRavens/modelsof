
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in'
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatA, clear

*Table 3
global i = 0
mycmd (private negotiation)  reg selfoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
*mycmd (private negotiation)  reg spouseoverselforown private negotiation if female==0 & dailywage1000 ~= .
*mycmd (private negotiation)  reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==1 & dailywage1000 ~= .
*mycmd (private negotiation)  reg spouseoverselforown private negotiation if female==1 & dailywage1000 ~= .
*mycmd (private negotiation)  reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

*Table 4
global i = 0
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
*mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseoverselforown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
*mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)   reg spouseoverselforown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings dailywage h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
*mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseoverselforown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
*mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg spouseoverselforown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)
matrix B4 = B[1,1..$j]

*Table A3
global i = 0
mycmd (private negotiation)  reg cashoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg cashoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveovercashorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
*mycmd (private negotiation)  reg spouseovercashorown private negotiation if female==0 & dailywage1000 ~= .
*mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseovercashorown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg cashoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)   reg cashoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveovercashorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
*mycmd (private negotiation)  reg spouseovercashorown private negotiation if female==1 & dailywage1000 ~= .
*mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg spouseovercashorown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 103)
matrix B103 = B[1,1..$j]

*Table A4
global i = 0
mycmd (private negotiation)  reg foodoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg foodoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverfoodorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
*mycmd (private negotiation)  reg spouseoverfoodorown private negotiation if female==0 & dailywage1000 ~= .
*mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseoverfoodorown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg foodoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg foodoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverfoodorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
*mycmd (private negotiation)  reg spouseoverfoodorown private negotiation if female==1 & dailywage1000 ~= .
*mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg spouseoverfoodorown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 104)
matrix B104 = B[1,1..$j]

egen T = group(private nonprivate negotiation), label
egen Unit = group(T w_hgc h_hgc w_age h_age), missing
gen Order = _n
sort Unit Order
gen N = 1
gen Dif = (Unit ~= Unit[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

*Table 3
global i = 0
mycmd (private negotiation)  reg selfoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==1 & dailywage1000 ~= .

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 4
global i = 0
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings dailywage h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

*Table A3
global i = 0
mycmd (private negotiation)  reg cashoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg cashoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveovercashorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg cashoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)   reg cashoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveovercashorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B103)*invsym(V)*(B[1,1..$j]-B103)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 103)
		}
	}

*Table A4
global i = 0
mycmd (private negotiation)  reg foodoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg foodoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverfoodorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg foodoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg foodoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverfoodorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B104)*invsym(V)*(B[1,1..$j]-B104)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 104)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/20 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestA, replace

erase aa.dta
erase aaa.dta
