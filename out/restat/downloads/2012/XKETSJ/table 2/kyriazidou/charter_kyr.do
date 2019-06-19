*THIS FILE CONDUCTS KYRIAZIDOU (1997) SELECTION CORRECTED PANEL ESTIMATES
*USING GRADE INELIGIBILITY FOR LAST SCHOOL AS AN EXCLUSION RESTRICTION

clear
set mem 5g
set more off

use /home/s/simberman/lusd/charter1/lusd_data_b.dta
*gsample 1, percent wor cluster(id)
xtset id year


  # delimit ;
  postfile outkyr2  int(regid depvarid indepvarid) str12 (regtype depvar indepvar statname)
	float (constant bw_fast bw_slow stat tstat obs) using /home/s/simberman/lusd/postfiles/outkyr2.dta, replace;
  # delimit cr

  # delimit ;

*BASE SAMPLE - LEVELS;

merge id year using /home/s/simberman/lusd/charter1/bandwidth_b.dta, keep(pred) _merge(_mergebw) nokeep;
keep if infrac != . & perc_attn != .;
keep if pred != .;
drop grade_* gradeyear_*;
xi i.grade*i.year  i.grade*structural  i.grade*nonstructural  i.grade*outofdist;
local depvarlist "infractions perc_attn";

*(A) LEVEL VARS;
local i 1;
foreach bwcons of numlist 11.25 22.5 45 90 {;
local j 1;
 foreach var of varlist `depvarlist'{;
  kyrselect `var' startup_unzoned convert_zoned freelunch redlunch othecon recent_immi migrant _I*,
	 nomse i(id) t(year) bwcons(`bwcons') robust cluster(schoolid) fspred(pred);
  drop _w_gamma _kd*;
  matrix b = e(b);
  matrix se = e(se_second);
  matrix b_uw = e(b_uw);
  matrix se_uw = e(se_uw);
  local k 1;
  post outkyr2 (`i') (`j') (`k') ("uw") ("`var'") ("startup") ("coef") (.) (.) (.)
	 (b_uw[1,1]) (b_uw[1,1]/se_uw[1,1]) (e(N));
  post outkyr2 (`i') (`j') (`k') ("uw") ("`var'") ("startup") ("se")  (.) (.) (.)
	 (se_uw[1,1]) (.) (e(N));

  local k 2;
  post outkyr2 (`i') (`j') (`k') ("uw") ("`var'") ("convert") ("coef") (.) (.) (.)
	 (b_uw[1,2]) (b_uw[1,2]/se_uw[1,2]) (e(N));
  post outkyr2 (`i') (`j') (`k') ("uw") ("`var'") ("convert") ("se")  (.) (.) (.)
	 (se_uw[1,2]) (.) (e(N));

  local i = `i' + 1;

  local k 1;
  post outkyr2 (`i') (`j') (`k') ("ss") ("`var'") ("startup") ("coef") (`bwcons') (e(bw_fast_1)) (e(bw_slow_1))
	 (b[1,1]) (b[1,1]/se[1,1]) (e(N));
  post outkyr2 (`i') (`j') (`k') ("ss") ("`var'") ("startup") ("se") (`bwcons') (e(bw_fast_1)) (e(bw_slow_1))
	 (se[1,1]) (.) (e(N));

  local k 2;
  post outkyr2 (`i') (`j') (`k') ("ss") ("`var'") ("convert") ("coef") (`bwcons') (e(bw_fast_1)) (e(bw_slow_1))
	 (b[1,2]) (b[1,2]/se[1,2]) (e(N));
  post outkyr2 (`i') (`j') (`k') ("ss") ("`var'") ("convert") ("se") (`bwcons') (e(bw_fast_1)) (e(bw_slow_1))
	 (se[1,2]) (.) (e(N));

  local i = `i' + 1;
  local j = `j' + 1;
 };
};


*TEST SAMPLE - LEVELS;


use /home/s/simberman/lusd/charter1/lusd_data_b.dta, clear;
*gsample 1, percent wor cluster(id);
xtset id year;


merge id year using /home/s/simberman/lusd/charter1/bandwidth_b_test.dta, keep(pred) _merge(_mergebw) nokeep;

keep if stanford_math_sd != . & stanford_read_sd != . & stanford_lang_sd != .;

keep if pred != .;

drop grade_* gradeyear_*;

xi i.grade*i.year  i.grade*structural  i.grade*nonstructural  i.grade*outofdist;

local depvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd";


*(A) LEVEL VARS;
local i 1;
foreach bwcons of numlist 10.25 20.5  41 82 {;
local j 3;
 foreach var of varlist `depvarlist'{;
  kyrselect `var' startup_unzoned convert_zoned freelunch redlunch othecon recent_immi migrant _I*,
	 nomse i(id) t(year) bwcons(`bwcons') robust cluster(schoolid) fspred(pred);
  drop _w_gamma _kd*;
  matrix b = e(b);
  matrix se = e(se_second);
  matrix b_uw = e(b_uw);
  matrix se_uw = e(se_uw);
  local k 1;
  post outkyr2 (`i') (`j') (`k') ("uw") ("`var'") ("startup") ("coef") (.) (.) (.)
	 (b_uw[1,1]) (b_uw[1,1]/se_uw[1,1]) (e(N));
  post outkyr2 (`i') (`j') (`k') ("uw") ("`var'") ("startup") ("se")  (.) (.) (.)
	 (se_uw[1,1]) (.) (e(N));

  local k 2;
  post outkyr2 (`i') (`j') (`k') ("uw") ("`var'") ("convert") ("coef") (.) (.) (.)
	 (b_uw[1,2]) (b_uw[1,2]/se_uw[1,2]) (e(N));
  post outkyr2 (`i') (`j') (`k') ("uw") ("`var'") ("convert") ("se")  (.) (.) (.)
	 (se_uw[1,2]) (.) (e(N));

  local i = `i' + 1;

  local k 1;
  post outkyr2 (`i') (`j') (`k') ("ss") ("`var'") ("startup") ("coef") (`bwcons') (e(bw_fast_1)) (e(bw_slow_1))
	 (b[1,1]) (b[1,1]/se[1,1]) (e(N));
  post outkyr2 (`i') (`j') (`k') ("ss") ("`var'") ("startup") ("se") (`bwcons') (e(bw_fast_1)) (e(bw_slow_1))
	 (se[1,1]) (.) (e(N));

  local k 2;
  post outkyr2 (`i') (`j') (`k') ("ss") ("`var'") ("convert") ("coef") (`bwcons') (e(bw_fast_1)) (e(bw_slow_1))
	 (b[1,2]) (b[1,2]/se[1,2]) (e(N));
  post outkyr2 (`i') (`j') (`k') ("ss") ("`var'") ("convert") ("se") (`bwcons') (e(bw_fast_1)) (e(bw_slow_1))
	 (se[1,2]) (.) (e(N));

  local i = `i' + 1;
  local j = `j' + 1;
 };
};


postclose outkyr2;
use /home/s/simberman/lusd/postfiles/outkyr2.dta, clear;
sort regtype constant indepvarid depvarid regid statname;
outsheet using /home/s/simberman/lusd/postfiles/outkyr2.dat, replace;
