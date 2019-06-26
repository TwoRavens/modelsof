#delimit ;

* This code reproduces the results reported in Table II and Appendix 1;

clear;
set mem 250m;
set more off;

tempfile sample temp1 temp2 temp3; 
cap log close;
cap log using MulVarAnalysis.log, replace;

use BasedauLay, clear;

*** Different control sets;

* 1 Preferred controls;
global controls_1 "gdp growth_fl lnpop lmtnest peace ncontig ethfrac etdo4590 sxp sxp2";

* 2 Collier-Hoeffler controls;
global controls_2 "secm gy1 peace geogia lnpop frac etdo4590 sxp sxp2";

* Oil variables;
global oilvars "oilsxp oilsxp2 pc_oilprodv pc_oilprodv2";

keep country_ch year ideyear onset* $controls_1 $controls_2 
     $oilvars;

drop if year == 1960;

save `sample', replace;

*** Program that drops influential outliers with DFBETA (Pregibon, 1981) "cook" > 1; 

cap prog drop drop_outlier;
prog def drop_outlier;
local i 1;
local k -1;
while `i' == 1 {;
  qui logit `1', robust;
  qui keep if e(sample) == 1;
  qui predict cook, dbeta;
  sort cook;
  qui gen n = _n;
  qui gen d1 = 1 if n == _N & cook > 1;
  list country year if n == _N & cook > 1;
  qui egen d2 = sum(d1);
  qui sum cook;
  scalar def j = d2;
  qui drop if d1 == 1;
  local i j;
  local k = `k' + 1;
  cap drop n d1 d2 cook;
  };
di ""; di `k' " outliers dropped";
end;


*** Preferred controls;

use `sample', clear;
drop_outlier "onset_prio_all $controls_1 $oilvars";
logit onset_prio_all $controls_1 $oilvars, robust;
outreg2 using results1.xls, bd(3) less(0) replace;
sum onset_prio_all $controls_1 $oilvars;

use `sample', clear;
drop_outlier "onset_prio_war $controls_1 $oilvars";
logit onset_prio_war $controls_1 $oilvars, robust;
outreg2 using results1.xls, bd(3) less(0) append;
sum onset_prio_war $controls_1 $oilvars;

use `sample', clear;
drop_outlier "onset_ch $controls_1 $oilvars";
logit onset_ch $controls_1 $oilvars, robust;
outreg2 using results1.xls, bd(3) less(0)  append;
sum onset_ch $controls_1 $oilvars;


*** Collier-Hoeffler controls;

use `sample', clear;
drop_outlier "onset_prio_all $controls_2 $oilvars";
logit onset_prio_all $controls_2 $oilvars, robust;
outreg2 using results2.xls, bd(3) less(0) replace;
sum onset_prio_all $controls_2 $oilvars;

use `sample', clear;
drop_outlier "onset_prio_war $controls_2 $oilvars";
logit onset_prio_war $controls_2 $oilvars, robust;
outreg2 using results2.xls, bd(3) less(0) append;
sum onset_prio_war $controls_2 $oilvars;

use `sample', clear;
drop_outlier "onset_ch $controls_2 $oilvars";
logit onset_ch $controls_2 $oilvars, robust;
outreg2 using results2.xls, bd(3) less(0) append;
sum onset_ch $controls_2 $oilvars;

cap log close;


*References

*Pregibon, Daryl, 1981. ‘Logistic Regression Diagnostics’, Annals of Statistics 9(4): 705-724.





