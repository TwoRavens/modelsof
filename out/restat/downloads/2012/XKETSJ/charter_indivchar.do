

*CHARTER IMPACT REGRESSIONS

*CONSIDERS INTERACTIONS OF CHARTER INDICATORS WITH STUDENT CHARACTERISTICS
  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_indivchar int(regid va depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_indivchar.dta, replace;
  # delimit cr


*SET LOCAL MACROS HERE
  
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant _I*"

  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


*DEPENDENT VARIABLES USED
local ldepvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd infractions perc_attn"
local vdepvarlist "dstanford_math_sd dstanford_read_sd dstanford_lang_sd dinfractions dperc_attn"

use /work/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 2, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*GENERATE VALUE ADDED MEASURES
  foreach var of varlist stanford_math_sd stanford_read_sd stanford_lang_sd infrac perc_attn {
	gen d`var' = d.`var'
 }


replace infrac = . if year == 1993
replace perc_attn = . if year == 1993


# delimit ;

xi  i.grade*i.year i.grade*structural i.grade*nonstructural i.grade*outofdist;
compress;




local i 2 ;

 *GENERATE INTERACTIONS;

   *BLACK;
   gen black = ethnicity == 3;
   gen convert_black = convert_zoned*black;
   gen startup_black = startup_unzoned*black;

   *HISPANIC;
   gen hisp = ethnicity == 4;
   gen convert_hisp = convert_zoned*hisp;
   gen startup_hisp = startup_unzoned*hisp;

   *OTHER;
   gen other = ethnicity == 1 | ethnicity == 2;
   gen convert_other = convert_zoned*other;
   gen startup_other = startup_unzoned*other;

   *WHITE;
   gen white = ethnicity == 5;
   gen convert_white = convert_zoned*white;
   gen startup_white = startup_unzoned*white;

   *FEMALE;
   gen convert_female = convert_zoned*female;
   gen startup_female = startup_unzoned*female;

   *MALE;
   gen convert_male = convert_zoned*(1-female);
   gen startup_male = startup_unzoned*(1-female);

   *ECONOMIC DISADVANTAGED;
   gen convert_econ = convert_zoned*(freelunch + redlunch + othecon);
   gen startup_econ = startup_unzoned*(freelunch + redlunch + othecon);

   *IMMIGRANT;
   gen convert_immig = convert_zoned*immigrant;
   gen startup_immig = startup_unzoned*immigrant;

 
local chartvars "startup_unzoned startup_black startup_hisp startup_other startup_female startup_econ startup_immig convert_unzoned convert_black convert_hisp convert_other convert_female convert_econ convert_immig";

*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
  xtreg `var' `chartvars' `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist `chartvars' {;
	  post charter_indivchar (`i') (`va') (`j') (`k')  ("race")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_indivchar (`i') (`va') (`j') (`k') ("race") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
  xtreg `var' `chartvars' `febase' , robust cluster(schoolid) nonest fe;
  local k 1;
  foreach indepvar of varlist `chartvars'  {;
	  post charter_indivchar (`i') (`va') (`j') (`k')  ("race")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_indivchar (`i') (`va') (`j') (`k') ("race") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};



postclose charter_indivchar;
use /work/s/simberman/lusd/postfiles/charter_indivchar.dta, clear;
sort  va regid depvarid indepvarid  statname;
outsheet using /work/s/simberman/lusd/postfiles/charter_indivchar.dat, replace;

