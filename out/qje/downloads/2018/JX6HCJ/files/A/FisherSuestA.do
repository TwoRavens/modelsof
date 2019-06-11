
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		estimates clear
		}
	global i = $i + 1

	quietly `anything' `if' `in'
	estimates store M$i

	global M = "$M" + " " + "M$i"

end

****************************************
****************************************

*Dropping colinear equations

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
test private negotiation
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

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
test private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg wifecontrolsavingprivate wifecontrolsavingneg
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

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
test private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg wifecontrolsavingprivate wifecontrolsavingneg
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 103)

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
test private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg wifecontrolsavingprivate wifecontrolsavingneg
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 104)

egen T = group(private nonprivate negotiation), label
egen Group = group(T w_hgc h_hgc w_age h_age), missing
bysort Group: gen N = _n
sort N Group
global N = 146
mata Y = st_data((1,$N),("private","nonprivate","negotiation","private_nonprivate","private_negotiation"))
generate double U = .
generate Order = _n

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("private","nonprivate","negotiation","private_nonprivate","private_negotiation"),Y)
	sort Group N
	foreach j in private nonprivate negotiation private_nonprivate private_negotiation {
		quietly replace `j' = `j'[_n-1] if N > 1 & Group == Group[_n-1]
		}
	quietly replace husbandcontrolsavingprivate = husbandcontrolsavings*private
	quietly replace wifecontrolsavingprivate = wifecontrolsavings*private
	quietly replace husbandcontrolsavingneg = husbandcontrolsavings*negotiation
	quietly replace wifecontrolsavingneg = wifecontrolsavings*negotiation
	sort Order

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
	capture test private negotiation
	if (_rc == 0) { 
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
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
	capture test private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg wifecontrolsavingprivate wifecontrolsavingneg
	if (_rc == 0) { 
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
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
	capture test private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg wifecontrolsavingprivate wifecontrolsavingneg
	if (_rc == 0) { 
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 103)
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
	capture test private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg wifecontrolsavingprivate wifecontrolsavingneg
	if (_rc == 0) { 
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 104)
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
sort N
save results\FisherSuestA, replace


	

