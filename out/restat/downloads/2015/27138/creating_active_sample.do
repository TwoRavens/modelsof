* This script contains the code to obtain the Active sample used to replicate TableA8 of the on-line appendix in Ductor, L., Fafchamps, M., Goyal S. and M. van der Leij. Social Networks and Research Output. The Review of Economics and Statistics. 

use prodndnp_fullsample 

/******************SELECTION CRITERIA: EXCLUDING OBSERVATIONS WHERE THE CUMULATIVE PROD. FROM T-4 TO T IS ZERO*******************/

drop if cprod5==0

/*Dropping authors with less than five observations*/
bys auth: egen mt=max(t)
drop if mt<5

/*Dropping quantiles per author*/

drop qnt /*Dropping the quantile variable defined using the whole sample*/


*histogram lcprod5, fraction

_pctile cprod5 if cprod5!=., p(50, 80, 90, 95, 99)

return list 

gen qnt = 1 if (cprod5>=r(r5)) & cprod5!=. 
replace qnt = 2 if (cprod5<r(r5) & cprod5>=r(r4)) & cprod5!=.
replace qnt = 3 if (cprod5<r(r4) & cprod5>=r(r3)) & cprod5!=.
replace qnt = 4 if (cprod5<r(r3) & cprod5>=r(r2)) & cprod5!=.
replace qnt = 5 if (cprod5<r(r2) & cprod5>=r(r1)) & cprod5!=.
replace qnt = 6 if cprod5<r(r1) & cprod5!=.

/*Notice that the quantiles are not defined for the first four academic years*/
/*Defining the quantiles for the first four years depending on the productivity of the first academic year*/
tab qnt
bys qnt: sum qnt group prodf3 cprod5 t 
gen prodfa=prod if t==1
_pctile prodfa, p(50, 80, 90, 95, 99)
gen qnty = 1 if (prodfa>=r(r5)) & prodfa!=. 
replace qnty = 2 if (prodfa<r(r5) & prodfa>=r(r4)) & prodfa!=.
replace qnty = 3 if (prodfa<r(r4) & prodfa>=r(r3)) & prodfa!=.
replace qnty = 4 if (prodfa<r(r3) & prodfa>=r(r2)) & prodfa!=.
replace qnty = 5 if (prodfa<r(r2) & prodfa>=r(r1)) & prodfa!=.
replace qnty = 6 if prodfa<r(r1) & prodfa!=.


bys auth: egen mqnty=max(qnty)
drop qnty
replace qnt=mqnty if qnt==.
drop mqnty prodfa
compress
drop neiq1fsfs1y neiq1fsfs2y neiq1fsfs3y neiq1fsfs4y neiq1fsfs5y neiq1fsfs6y neiq1fsfs7y neiq1fsfs8y neiq1fsfs9y neiq1fsfs10y neiq1fsfs11y neiq1fsfs12y neiq1fsfs13y neiq1fsfs14y neiq1fsfs15y
save prodndnp_qnt, replace

