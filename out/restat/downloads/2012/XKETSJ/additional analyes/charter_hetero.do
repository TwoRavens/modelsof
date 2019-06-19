`

*CHARTER IMPACT REGRESSIONS

*CONSIDERS VARIOUS INTERACTIONS OF CHARTER IMPACTS
  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_hetero int(regid va depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_hetero.dta, replace;
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


*IDENTIFY NUMBER OF  DISCIPLINARY INFRACTION IN YEAR PRIOR TO FIRST CHARTER ENTRY
	
	*IDENTIFY FIRST YEAR IN A CHARTER OF ANY TYPE
	egen temp = min(year) if charter == 1, by(id)
	egen minchartyear = min(temp), by(id)

	*CALCULATE THE NUMBER OF INFRACTIONS IN THE YEAR PRIOR TO CHARTER ENTRY
	gen temp2 = infrac if year == minchartyear -1
	egen prechart_infrac = min(temp2), by(id)

	*MAKE PRECHART_INFRAC = 0 IF STUDENT HAD NO INFRACTIONS, NEVER ATTENDED A CHARTER, OR WAS NOT IN SAMPLE YEAR PRIOR TO ENTRY
	replace prechart_infrac = 0 if prechart_infrac == .

	*GENERATE INDICATOR FOR STUDENT NOT BEING IN SAMPLE IN YEAR PRIOR TO CHARTER ENTRY
	gen temp3 = l.charter == . & year == minchartyear
	egen prechart_noobs = max(temp3), by(id)	

	*GENERATE INTERACTIONS WITH CHARTER STATUS
	gen convert_prechart_infrac = convert_zoned*prechart_infrac
	gen startup_prechart_infrac = startup_unzoned*prechart_infrac
	gen convert_prechart_noobs = convert_zoned*prechart_noobs
	gen startup_prechart_noobs = startup_unzoned*prechart_noobs

	tab year, gen(year_)

	*GENERATE VALUE ADDED MEASURES
  	foreach var of varlist stanford_math_sd stanford_read_sd stanford_lang_sd infrac perc_attn {
		gen d`var' = d.`var'
	}


replace infrac = . if year == 1993
replace perc_attn = . if year == 1993


*REDUCE NUMBER OF VARIABLES IN DATA TO MAKE PROGRAM RUN BETTER
keep id year freel redl othecon recent_immi migrant grade year outofdist structural nonstructural ethnicity female startup* convert* schoolid stanford_*sd infrac perc_attn dstanford* dinfrac dperc_attn *prechart* minchartyear

# delimit ;

xi  i.grade*i.year i.grade*structural i.grade*nonstructural i.grade*outofdist;
compress


/*;
***(1)****;
***INTERACTION WITH PRE-CHARTER INFRACTIONS****;
local i 1 ;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned convert_prechart_infrac convert_prechart_noobs startup_unzoned startup_prechart_infrac startup_prechart_noobs `febase' 
	, robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  startup_unzoned startup_prechart_infrac startup_prechart_noobs  convert_zoned convert_prechart_infrac convert_prechart_noobs{;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("pre_chart_infrac")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("pre_chart_infrac") ("`var'") 
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
 xi: xtreg `var' convert_zoned convert_prechart_infrac convert_prechart_noobs startup_unzoned startup_prechart_infrac startup_prechart_noobs `febase' 
	, robust cluster(schoolid) nonest fe;
  local k 1;
  foreach indepvar of varlist   startup_unzoned startup_prechart_infrac startup_prechart_noobs convert_zoned convert_prechart_infrac convert_prechart_noobs {;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("pre_chart_infrac")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("pre_chart_infrac") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};




***(2)****;
***INTERACTION WITH RACE****;
local i 2 ;

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

*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_white convert_black convert_hisp convert_other startup_white startup_black startup_hisp startup_other `febase' 
	, robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_white startup_black startup_hisp startup_other convert_white convert_black convert_hisp convert_other {;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("race")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("race") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
 xi: xtreg `var' convert_white convert_black convert_hisp convert_other startup_white startup_black startup_hisp startup_other `febase'
	, robust cluster(schoolid) nonest fe;
  local k 1;
  foreach indepvar of varlist  startup_white startup_black startup_hisp startup_other convert_white convert_black convert_hisp convert_other  {;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("race")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("race") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};
*/;


***(3)****;
***INTERACTION WITH GENDER****;
local i 3 ;
gen convert_female = convert_zoned*female;
gen convert_male = convert_zoned*(1 - female);
gen startup_female = startup_unzoned*female;
gen startup_male = startup_unzoned*(1 - female);

*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned convert_female startup_unzoned startup_female `febase' 
	, robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  startup_unzoned startup_female convert_zoned convert_female  {;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("gender")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("gender") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
 xi: xtreg `var' convert_zoned convert_female  startup_unzoned startup_female `febase' 
	, robust cluster(schoolid) nonest fe;
  local k 1;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned convert_female  startup_unzoned startup_female `febase' 
	, robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  startup_unzoned startup_female convert_zoned convert_female  {;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("gender")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("gender") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};



***(4)****;
***BY AGE OF CHARTER - OMIT 1ST YEAR****;
local i 4 ;

  *IDENTIFY CHARTER AGE;
  drop minchartyear;
  egen minchartyear = min(year) if charter == 1, by (schoolid);
  gen chart_age = year - minchartyear + 1;
  gen chart_age_1 = chart_age == 1;
  gen chart_age_2 = chart_age == 2;
  gen chart_age_3 = chart_age == 3;
  gen chart_age_4 = chart_age == 4;
  gen chart_age_5_plus = chart_age >= 5 & chart_age != .;
  
  foreach var in "age_1" "age_2" "age_3" "age_4" "age_5_plus" {;
     gen convert_`var' = convert_zoned*chart_`var';
     gen startup_`var' = startup_unzoned*chart_`var';
  };


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned convert_age_2 convert_age_3 convert_age_4 convert_age_5_plus 
		 startup_unzoned startup_age_2 startup_age_3 startup_age_4 startup_age_5_plus `febase', robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist startup_unzoned startup_age_2 startup_age_3 startup_age_4 startup_age_5_plus 
			      convert_zoned convert_age_2 convert_age_3 convert_age_4 convert_age_5_plus {;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("chart_age")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("chart_age") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
 xi: xtreg `var'  startup_unzoned  convert_zoned convert_age_2 convert_age_3 convert_age_4 convert_age_5_plus 
		 startup_unzoned startup_age_2 startup_age_3 startup_age_4 startup_age_5_plus `febase', robust cluster(schoolid) nonest fe;
  local k 1;
  foreach indepvar of varlist convert_zoned convert_age_2 convert_age_3 convert_age_4 convert_age_5_plus 
			      startup_unzoned startup_age_2 startup_age_3 startup_age_4 startup_age_5_plus {;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("chart_age")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("chart_age") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};



***(5)****;
***BY GRADE LEVEL****;
local i 5 ;

*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_unzoned startup_middle startup_high `febase' 
	, robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  startup_unzoned startup_middle startup_high  convert_zoned {;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("grade_level")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("grade_level") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
 xi: xtreg `var'  convert_zoned startup_unzoned startup_middle startup_high  `febase'
	, robust cluster(schoolid) nonest fe;
  local k 1;
  foreach indepvar of varlist  startup_unzoned startup_middle startup_high  convert_zoned {;
	  post charter_hetero (`i') (`va') (`j') (`k')  ("grade_level")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_hetero (`i') (`va') (`j') (`k') ("grade_level") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


# delimit cr


postclose charter_hetero
use /work/s/simberman/lusd/postfiles/charter_hetero.dta, clear
sort  va regid depvarid indepvarid  statname
outsheet using /work/s/simberman/lusd/postfiles/charter_hetero.dat, replace

