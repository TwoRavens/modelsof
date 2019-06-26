#delimit ;

* This code reproduces Figure 1 and the figure in Appendix 2;

clear;
set mem 250m;
set more off;

cd C:\Arbeit\ResourceCurse\BasedauLay\stata\;

tempfile sample; 
cap log close;
cap log using  C:\Arbeit\ResourceCurse\BasedauLay\stata\Sim_prob.log, replace;

use BasedauLay, clear;

*** Different control sets;


* Preferred controls;
global controls_1 "gdp growth_fl lnpop lmtnest peace ncontig instab ethfrac etdo4590 sxp sxp2";

* Oil variables;
global oilvars "oilsxp oilsxp2 pc_oilprodv pc_oilprodv2";

keep country_ch year ideyear onset* $controls_1 $controls_2 
     $oilvars $oilvars_2;

drop if year == 1960;

save `sample', replace;

*Program that drops influential outliers with DFBETA (Pregibon, 1981) "cook" > 1; 
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

*** Controls 1;

use `sample', clear;
drop_outlier "onset_prio123 $controls_1 $oilvars";
logit onset_prio123 $controls_1 $oilvars, robust;

/*drop_outlier "onset_ch $controls_1 $oilvars";
logit onset_ch $controls_1 $oilvars, robust;
sum onset_ch $controls_1 $oilvars if e(sample) == 1;*/

*keep if ssafrica == 1;

collapse (mean) $controls_1 $oilvars;

expand 100;


*shape of wealth effects with different degrees of oil dependence;
rename sxp m_sxp; drop sxp2;
rename oilsxp m_oilsxp; drop oilsxp2;
rename pc_oilprodv m_pc_oilprodv; drop pc_oilprodv2;

gen sxp = _n/100;
gen sxp2 = sxp*sxp;

gen oilsxp = sxp;
gen oilsxp2 = sxp2;

* oilprodv for saudi-arabia: >= 40 and <= 200;

gen pc_oilprodv = _n;
gen pc_oilprodv2 = pc_oilprodv*pc_oilprodv;

replace sxp = 0;
replace sxp2 = 0;
replace oilsxp = 0;
replace oilsxp2 = 0;
predict phat_onset_0_dep;

replace sxp = 0.3;
replace sxp2 = 0.09;
replace oilsxp = 0.3;
replace oilsxp2 = 0.09;
predict phat_onset_30_dep;

replace sxp = 0.6;
replace sxp2 = 0.36;
replace oilsxp = 0.6;
replace oilsxp2 = 0.36;
predict phat_onset_60_dep;

replace sxp = 0.9;
replace sxp2 = 0.81;
replace oilsxp = 0.9;
replace oilsxp2 = 0.81;
predict phat_onset_90_dep;

lab var phat_onset_0_dep "no dependence";
lab var phat_onset_30_dep "oilsxp = 30%";
lab var phat_onset_60_dep "oilsxp = 60%";
lab var phat_onset_90_dep "oilsxp = 90%";

lab var pc_oilprodv "oil production value per capita";

scatter phat_onset_0_dep phat_onset_30_dep phat_onset_60_dep phat_onset_90_dep pc_oilprodv
      , scheme(s2mono) saving(prob_wealth, replace);


*shape of dependence effects with different degrees of oil wealth;

cap drop sxp sxp2; 
gen sxp = _n/100;
gen sxp2 = sxp*sxp;
replace oilsxp = sxp;
replace oilsxp2 = sxp2;

replace pc_oilprodv = 5;
replace pc_oilprodv2 = pc_oilprodv*pc_oilprodv;
predict phat_onset_5_w;

replace pc_oilprodv = 20;
replace pc_oilprodv2 = pc_oilprodv*pc_oilprodv;
predict phat_onset_20_w;

replace pc_oilprodv = 50;
replace pc_oilprodv2 = pc_oilprodv*pc_oilprodv;
predict phat_onset_50_w;

lab var phat_onset_5_w "low wealth";
lab var phat_onset_20_w "medium wealth";
lab var phat_onset_50_w "high wealth";

lab var oilsxp "oilsxp";

scatter phat_onset_5_w phat_onset_20_w phat_onset_50_w oilsxp, scheme(s2mono) saving(prob_dep, replace);

cap log close;






