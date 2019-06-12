
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	bootstrap, reps(300) seed(1): `anything' `if' `in', 
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatA, clear

rename husbandcontrolsavingneg husbandcontrolsavingnegotiation
rename wifecontrolsavingneg wifecontrolsavingnegotiation

matrix F = J(132,4,.)
matrix B = J(228,2,.)

global i = 1
global j = 1

mycmd (private negotiation)  reg selfoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg selfoversavings private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg selfoversavings private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg ownsaveoverselforspouse private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg ownsaveoverselforspouse private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverselforown private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg spouseoverselforown private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)   reg spouseoverselforown private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg selfoversavings private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings dailywage h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg selfoversavings private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==1 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg ownsaveoverselforspouse private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg ownsaveoverselforspouse private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverselforown private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg spouseoverselforown private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg spouseoverselforown private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

*Table A3
mycmd (private negotiation)  reg cashoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg cashoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg ownsaveovercashorspouse private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseovercashorown private negotiation if female==0 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg spouseovercashorown private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg cashoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)   reg cashoversavings private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg ownsaveovercashorspouse private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseovercashorown private negotiation if female==1 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg spouseovercashorown private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

*Table A4
mycmd (private negotiation)  reg foodoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg foodoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg ownsaveoverfoodorspouse private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverfoodorown private negotiation if female==0 & dailywage1000 ~= .
mycmd (private wifecontrolsavingprivate negotiation wifecontrolsavingneg)  reg spouseoverfoodorown private wifecontrolsavingprivate negotiation wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg foodoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg foodoversavings private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg ownsaveoverfoodorspouse private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverfoodorown private negotiation if female==1 & dailywage1000 ~= .
mycmd (private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg)  reg spouseoverfoodorown private husbandcontrolsavingprivate negotiation husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

global i = 0
foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg selfoversavings private negotiation if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/8 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg ownsaveoverselforspouse private negotiation if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/8 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg spouseoverselforown private negotiation if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/8 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg selfoversavings private negotiation if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/8 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg ownsaveoverselforspouse private negotiation if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/8 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg spouseoverselforown private negotiation if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (nonprivate == 1 | `var' == 1)
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/8 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}


*Table A3

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 0 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg cashoversavings private negotiation if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 0 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg ownsaveovercashorspouse private negotiation if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 0 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg spouseovercashorown private negotiation if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 1 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg cashoversavings private negotiation if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 1 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg ownsaveovercashorspouse private negotiation if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 1 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg spouseovercashorown private negotiation if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

*Table A4

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 0 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg foodoversavings private negotiation if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 0 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg ownsaveoverfoodorspouse private negotiation if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 0 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg spouseoverfoodorown private negotiation if female==0 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 1 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg foodoversavings private negotiation if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 1 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg ownsaveoverfoodorspouse private negotiation if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}

foreach var in private negotiation {
	global i = $i + 1
	capture drop Strata
	gen Strata = (female == 1 & (nonprivate == 1 | `var' == 1))
	randcmdc ((`var') bootstrap, reps(300) seed(1): reg spouseoverfoodorown private negotiation if female==1 & dailywage1000 ~= .), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}


matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondA, replace


