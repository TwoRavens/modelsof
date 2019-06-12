ssc install ivreg2
ssc install ranktest

use "survey.dta"
tab Raion, gen(raion)
gen zint = language*quality
gen xint = language*tvru

ivreg2 r14pres_ind (tvru xint = X1 X2 zint) language income travel education raion*
ivreg2 r14parl_ind (tvru xint = X1 X2 zint) language income travel education raion*
ivreg2 q106 (tvru xint = X1 X2 zint) language income travel education raion*
ivreg2 q94 (tvru xint = X1 X2 zint) language income travel education raion*
