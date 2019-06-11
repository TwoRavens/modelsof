/* Figure 3b*/
/* this is for the pre-election coalition counterfactual */

#delimit;
set mem 5m;
set more off; 

use Figure3b;

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

drop if case ==.;

ta sigchange;

ta sigchange if case==15 | case==16 | case==17 | case==18 | case==32 | case==37 | case==56 | case==210 | case==211 | case==212 | 
case==216 | case==217 | case==218 | case==221 | case== 222 | case== 223 | case==  224 | case==225 | case==226 | case==   227 | 
case==  228 | case==  229 | case==244 | case==245 | case==246 | case== 247 | case==   248 | case==  249 | case==   251 | case==   252 ;      

/* this creates some of the data for Figure 4 */

sort case;

by case: egen pro = sum(abs(mixdiff/2));

collapse (median) pro, by(case);

save Figure4b, replace;

