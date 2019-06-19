

*CHARTER IMPACT REGRESSIONS

*CONSIDERS ALTERNATIVE MEASURES OF TEST SCORES
  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_alt_testscore int(regid va depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /home/s/simberman/lusd/postfiles/charter_alt_testscore.dta, replace;
  # delimit cr


*SET LOCAL MACROS HERE
  
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant i.grade*i.year i.grade*structural i.grade*nonstructural i.grade*outofdist"

  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


*DEPENDENT VARIABLES USED
local ldepvarlist "stanford_math_pr stanford_read_pr stanford_lang_pr stanford_math_nce stanford_read_nce stanford_lang_nce"
local vdepvarlist "dstanford_math_pr dstanford_read_pr dstanford_lang_pr dstanford_math_nce dstanford_read_nce dstanford_lang_nce"


use /home/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 2, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1
keep if year >= 1998
keep if stanford_math_sd != . & stanford_read_sd != . & stanford_lang_sd !=.
foreach var of varlist stanford_*pr stanford_*nce {
  gen d`var' = d.`var'
}

# delimit ;


***(1)****;
local i 1 ;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_unzoned `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  startup_unzoned  convert_zoned {;
	  post charter_alt_testscore (`i') (`va') (`j') (`k')  ("pre_chart_infrac")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_alt_testscore (`i') (`va') (`j') (`k') ("pre_chart_infrac") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local i 1 ;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
 xi: xtreg `var' convert_zoned startup_unzoned `febase', robust cluster(schoolid) nonest fe;
  local k 1;
  foreach indepvar of varlist startup_unzoned convert_zoned {;
	  post charter_alt_testscore (`i') (`va') (`j') (`k')  ("pre_chart_infrac")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_alt_testscore (`i') (`va') (`j') (`k') ("pre_chart_infrac") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};

# delimit cr

postclose charter_alt_testscore
use /home/s/simberman/lusd/postfiles/charter_alt_testscore.dta, clear
sort  va regid depvarid indepvarid  statname
outsheet using /home/s/simberman/lusd/postfiles/charter_alt_testscore.dat, replace


