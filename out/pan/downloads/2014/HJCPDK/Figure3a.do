/* Figure 3a*/
/* this is for the largest party counterfactual */

#delimit;
set mem 5m;
set more off; 

use Figure3a;

local newobs = _N + 3;
set obs `newobs';

replace mixdiff = 0.53 if _n == _N - 2;
replace mixprobm1 = 0.5 if _n == _N - 2;
replace mixprobm2 = 0.06 if _n == _N - 2;
replace sigchange = 1 if _n == _N - 2;

replace mixdiff = 0.47 if _n == _N - 1;
replace mixprobm1 = 0.25 if _n == _N - 1;
replace mixprobm2 = 0.06 if _n == _N - 1;
replace sigchange = 1 if _n == _N - 1;

replace mixdiff = 0.41 if _n == _N;
replace mixprobm1 = 0.1 if _n == _N;
replace mixprobm2 = 0.06 if _n == _N;
replace sigchange = 1 if _n == _N;


graph twoway (scatter mixdiff mixprobm2 [weight=mixprobm1] if sigchange==0, msymbol(oh) mlwidth(vthin) msize(vsmall) mcolor(gs8) 
xlabel(0 0.2 0.4 0.6 0.8) ylabel(-0.6 -0.4 -0.2 0 0.2 0.4 0.6))
(scatter mixdiff mixprobm2 [weight=mixprobm1] if sigchange==1, msymbol(oh) mlwidth(vthin) msize(vsmall) mcolor(black) 
text(0.53 0.08 "= 0.50", placement(e) size(small)) text(0.47 0.08 "= 0.25", placement(e) size(small)) 
text(0.41 0.08 "= 0.10", placement(e) size(small)) yline(0));


drop if case == .;

ta sigchange;

/* this creates some of the data for Figure 4 */

sort case;

by case: egen dompar = sum(abs(mixdiff/2));

collapse (median) dompar, by(case);

save Figure4a, replace;

