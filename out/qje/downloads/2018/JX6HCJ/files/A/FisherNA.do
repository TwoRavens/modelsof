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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture bootstrap, reps(300) seed(1): `anything' `if' `in', 
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatA, clear

matrix F = J(48,4,.)
matrix B = J(144,2,.)

global i = 1
global j = 1

mycmd (private negotiation)  reg selfoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverselforown private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseoverselforown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)   reg spouseoverselforown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings dailywage h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==1 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverselforown private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseoverselforown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg spouseoverselforown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

*Table A3
mycmd (private negotiation)  reg cashoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg cashoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveovercashorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseovercashorown private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseovercashorown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg cashoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)   reg cashoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveovercashorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseovercashorown private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg spouseovercashorown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

*Table A4
mycmd (private negotiation)  reg foodoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg foodoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverfoodorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverfoodorown private negotiation if female==0 & dailywage1000 ~= .
mycmd (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseoverfoodorown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd (private negotiation)  reg foodoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg foodoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverfoodorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd (private negotiation)  reg spouseoverfoodorown private negotiation if female==1 & dailywage1000 ~= .
mycmd (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg spouseoverfoodorown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

egen T = group(private nonprivate negotiation), label
egen Group = group(T w_hgc h_hgc w_age h_age), missing
bysort Group: gen N = _n
sort N Group
global N = 146
mata Y = st_data((1,$N),("private","nonprivate","negotiation","private_nonprivate","private_negotiation"))
generate double U = .
generate Order = _n

mata ResF = J($reps,48,.); ResD = J($reps,48,.); ResDF = J($reps,48,.); ResB = J($reps,144,.); ResSE = J($reps,144,.)
forvalues c = 1/$reps {
	matrix FF = J(48,3,.)
	matrix BB = J(144,2,.)
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

global i = 1
global j = 1

mycmd1 (private negotiation)  reg selfoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg spouseoverselforown private negotiation if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseoverselforown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)   reg spouseoverselforown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg selfoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings dailywage h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg ownsaveoverselforspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg spouseoverselforown private negotiation if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseoverselforown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg spouseoverselforown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

*Table A3
mycmd1 (private negotiation)  reg cashoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg cashoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveovercashorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg spouseovercashorown private negotiation if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseovercashorown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg cashoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)   reg cashoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg ownsaveovercashorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveovercashorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg spouseovercashorown private negotiation if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg spouseovercashorown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

*Table A4
mycmd1 (private negotiation)  reg foodoversavings private negotiation if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg foodoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg ownsaveoverfoodorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg spouseoverfoodorown private negotiation if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation wifecontrolsavingprivate wifecontrolsavingneg)  reg spouseoverfoodorown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg foodoversavings private negotiation if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg foodoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg ownsaveoverfoodorspouse private negotiation if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg ownsaveoverfoodorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation)  reg spouseoverfoodorown private negotiation if female==1 & dailywage1000 ~= .
mycmd1 (private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg)  reg spouseoverfoodorown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..48] = FF[.,1]'; ResD[`c',1..48] = FF[.,2]'; ResDF[`c',1..48] = FF[.,3]'
mata ResB[`c',1..144] = BB[.,1]'; ResSE[`c',1..144] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/48 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/144 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherA, replace


	

