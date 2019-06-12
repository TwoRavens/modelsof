*******************

*Creating pairs
use TotalData, clear
egen T = group(private nonprivate negotiation), label
egen Group = group(T w_hgc h_hgc w_age h_age), missing
egen t = count(T), by(Group)
tab t
*all good - can also do *list Group female or *tab Group female

****************************

*Note:  estat bootstrap is not in original paper do file (calls for bca confidence intervals), I've added it
*Examination of output shows that this changes significance of some coefficients
*Moreover, stata only reports 95% confidence intervals for this command, so user could not have reported 1% or 10% significance
*In sum, user specifies bca, but does not call or use estat in any way - in effect, using Stata's standard bootstrap to determine significance

use TotalData.dta, clear

*Paper's code and regressions (xi's don't make any difference, so remove them)
*drop if dailywage1000==. 
*2 women were dropped, leaving a sample of 144 women*
*1 man was dropped, leaving a sample of 145 men*
*Don't drop so can rereandomize treatment across experimental sample, impose as a condition below

*Table 2 is exact Fisherian inference of mean differences

*Tables 3 and 4

*This is the seed paper sets just before running these bootstraps in the do file, but doesn't reproduce the s.e.s
*Order of the data might have been changed since originally calculated the s.e. using bootstrap
set seed 123123

bootstrap _b, reps(300) bca: reg selfoversavings private negotiation if female==0 & dailywage1000 ~= .
*I add these (not in original paper) to show that did not actually use bca by invoking this command (as results differ)
estat bootstrap, all

bootstrap _b, reps(300) bca: reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverselforspouse private negotiation if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverselforown private negotiation if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverselforown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverselforown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg selfoversavings private negotiation if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg selfoversavings private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg selfoversavings private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings dailywage h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg selfoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverselforspouse private negotiation if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverselforspouse private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount  if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverselforspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverselforspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverselforown private negotiation if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverselforown private negotiation h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverselforown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverselforown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

*coefficients off, signs reversed, rounding errors, missing from table (even though variable in table), and standard errors all do not match - following paper's code exactly
*Generally, however, overall match (so seems to be the correct regressions), then some major or minor reporting error on a single coefficient 
*Same applies to tables below

*Table A3

*Again, this is the seed paper sets just before running these bootstraps in the do file, but doesn't reproduce the s.e.s, data must have been reordered
set seed 123123
bootstrap _b, reps(300) bca: reg cashoversavings private negotiation if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg cashoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveovercashorspouse private negotiation if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveovercashorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseovercashorown private negotiation if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseovercashorown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg cashoversavings private negotiation if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg cashoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveovercashorspouse private negotiation if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveovercashorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseovercashorown private negotiation if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseovercashorown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

*Table A4

*Again, this is the seed paper sets just before running these bootstraps in the do file, but doesn't reproduce the reported s.e.s
set seed 123123
bootstrap _b, reps(300) bca: reg foodoversavings private negotiation if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg foodoversavings private negotiation  wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverfoodorspouse private negotiation if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverfoodorspouse private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings  h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverfoodorown private negotiation if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverfoodorown private negotiation wifecontrolsavingprivate wifecontrolsavingneg wifecontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==0 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg foodoversavings private negotiation if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg foodoversavings private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverfoodorspouse private negotiation if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg ownsaveoverfoodorspouse private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverfoodorown private negotiation if female==1 & dailywage1000 ~= .
estat bootstrap, all

bootstrap _b, reps(300) bca: reg spouseoverfoodorown private negotiation husbandcontrolsavingprivate husbandcontrolsavingneg husbandcontrolsavings h_age w_age h_hgc w_hgc hdailywage wdailywage gbankaccount spousegbankaccount jointaccount if female==1 & dailywage1000 ~= .
estat bootstrap, all

*Column comparisons - Tables 5 (bottom half) & A5
*Paired t-tests (across treatment regimes) in do file, based upon reported significance levels for 
*the significance of paired tests of private vs non-private and private vs negotiation
*In these comparisons paper did not restrict to dailywage1000 ~= .
*Don't test these, no coef. & se.

save DatA, replace
