global cluster = ""

use DatA, clear

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

