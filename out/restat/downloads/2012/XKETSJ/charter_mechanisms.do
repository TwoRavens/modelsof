

*CHARTER IMPACT REGRESSIONS


*THIS FILE IS THE BASIC PROGRAM FOR RUNNING CHARTER SCHOOL REGRESSIONS AND IS MODIFIABLE IN A NUMBER OF WAYS

  
clear
set mem 4000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_mechanisms int(regid stage depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_mechanisms.dta, replace;
  # delimit cr


*LEVELS MODELS

*SET LOCAL MACROS HERE
  
  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


use /work/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 0.5, percent wor cluster(id)

*MAKE DATASET PANEL
xtset (id) year


*DEPENDENT VARIABLES USED
local ldepvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd infractions perc_attn"
local vdepvarlist "dstanford_math_sd dstanford_read_sd dstanford_lang_sd dinfractions dperc_attn"

foreach var of varlist stanford_math_sd stanford_read_sd stanford_lang_sd infractions perc_attn {
   gen d`var' = d.`var'
}
replace dstanford_math_sd = . if year == 1998
replace dstanford_read_sd = . if year == 1998
replace dstanford_lang_sd = . if year == 1998



*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1

*GENERATE YEAR DUMMIES
tab year, gen(year_)

*COMPRESS DATASET
compress



*MERGE IN SCHOOL CHARACTERISTICS
sort campus year
# delimit ;
merge campus year using /work/s/simberman/lusd/charter1/lusd_resources.dta, keep(exp_func_pupil* enroll enroll_white_perc
	enroll_hisp_perc enroll_black_perc enroll_lep_perc enroll_spec_perc enroll_gif_perc enroll_econ_perc ) nokeep;
# delimit cr
foreach var of varlist exp* {
  replace `var' = `var'/1000
}
replace enroll = enroll/1000
gen enroll2 = enroll^2
replace exp_func_pupil_instr_instrld = exp_func_pupil_instr + exp_func_pupil_instrlead if exp_func_pupil_instr_instrld == .
replace exp_func_pupil_other = exp_func_pupil_totoper - exp_func_pupil_schlead - exp_func_pupil_instr_instrld
foreach var of varlist exp* {
  gen `var'2 = `var'^2
}


*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*   structural* nonstructural* outofdist*"

drop *_11 *_12

# delimit ;

***(1)****;
*CONTROL FOR INSTRUCTION EXPENDITURES QUADRATIC WITH NO INTERACTION ****;
local i 1 ;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high exp_func_pupil_instr_instrld exp_func_pupil_instr_instrld2 `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("instrld")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("instrld") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
  local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high exp_func_pupil_instr_instrld exp_func_pupil_instr_instrld2 `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("instrld")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("instrld") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


***(2)****;
*CONTROL FOR SCHOOL LEADERSHIP EXPENDITURES QUADRATIC WITH NO INTERACTION ****;
local i 2 ;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high exp_func_pupil_schlead exp_func_pupil_schlead2 `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("schlead")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("schlead") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
  local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high exp_func_pupil_schlead exp_func_pupil_schlead2 `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("schlead")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("schlead") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


***(3)****;
*CONTROL FOR OTHER EXPENDITURES QUADRATIC WITH NO INTERACTION ****;
local i 3 ;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high exp_func_pupil_other exp_func_pupil_other2 `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("other")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("other") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
  local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high exp_func_pupil_other exp_func_pupil_other2 `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("other")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("other") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


***(4)****;
*CONTROL FOR INSTRUCTION, SCHOOL LEADERSHIP, OTHER EXPENDITURES QUADRATIC WITH NO INTERACTION ****;
local i 4 ;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high  exp_func_pupil_instr_instrld exp_func_pupil_instr_instrld2 exp_func_pupil_schlead exp_func_pupil_schlead2 exp_func_pupil_other exp_func_pupil_other2 `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("all exp")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("all exp") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
  local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high exp_func_pupil_instr_instrld exp_func_pupil_instr_instrld2  exp_func_pupil_schlead exp_func_pupil_schlead2 exp_func_pupil_other exp_func_pupil_other2 `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("all exp")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("all exp") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};




***(5)****;
***CONTROL FOR STUDENT BODY COMPOSITION****;
local i 5 ;

*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high enroll_*  `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high  convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("student comp")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("student comp") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
  local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high enroll_* `febase', robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  startup_elem_middle startup_high  convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("student comp")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("student comp") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};



***(6)****;
***CONTROL FOR ENROLLMENT QUADRATIC****;
local i 6 ;

*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high enroll enroll2  `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_elem_middle startup_high  convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("enroll")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("enroll") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
  local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high enroll enroll2 `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  startup_elem_middle startup_high  convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("enroll")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("enroll") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};




***(7)****;
*** CONTROL FOR ALL***;
local i 7 ;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high exp_func_pupil_instr_instrld exp_func_pupil_instr_instrld2 exp_func_pupil_schlead exp_func_pupil_schlead2 exp_func_pupil_other exp_func_pupil_other2 enroll enroll2 enroll_*  `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist   startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("all")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("all") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
 xi: xtreg `var' convert_zoned startup_elem_middle startup_high  exp_func_pupil_instr_instrld exp_func_pupil_instr_instrld2 exp_func_pupil_schlead exp_func_pupil_schlead2 exp_func_pupil_other exp_func_pupil_other2 enroll enroll2 enroll_* `febase' , robust cluster(schoolid) nonest fe;
  local k 1;
  foreach indepvar of varlist   startup_elem_middle startup_high convert_zoned {;
	  post charter_mechanisms (`i') (`va') (`j') (`k')  ("all")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_mechanisms (`i') (`va') (`j') (`k') ("all") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};



postclose charter_mechanisms;
use /work/s/simberman/lusd/postfiles/charter_mechanisms.dta, clear;
sort stage regid depvarid indepvarid statname;
outsheet using /work/s/simberman/lusd/postfiles/charter_mechanisms.dat, replace;


f


