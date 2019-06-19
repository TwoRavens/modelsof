**RUNS REGRESSIONS OF CHARTER IMPACTS WITH SEPARATE ESTIMATORS FOR 1, 2, 3, 4+ YEARS IN CHARTER

  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_timeinchart_levels int(regid stage depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_timeinchart_levels.dta, replace;
  # delimit cr


*LEVELS MODELS

*SET LOCAL MACROS HERE
   
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*  structural_grade_* nonstructural_grade_* outofdist_grade_*"

  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0



*GENERATE INDICATORS BY GRADE & SCHOOL TO SAY WHETHER THE GRADE EXISTS IN THAT SCHOOL
use /work/s/simberman/lusd/charter1/lusd_data_b, clear

  *COLLAPSE TO A SCHOOL BY YEAR DATASET THAT IDENTIFIES THE MAXIMUM & MINIMUM GRADE IN EACH SCHOOL
  collapse (max) maxgrade=grade (min) mingrade=grade, by(schoolid year)
  rename schoolid schoolid_temp
  save /work/s/simberman/lusd/charter1/maxgrades.dta, replace


*FOR THIS PROGRAM, NEED TO USE ORIGINAL DATASET TO ADD INELIGIBLILTY VARIABLES
*THUS INSTEAD OF DEMEANING, USE XTREG
use /work/s/simberman/lusd/charter1/lusd_data_b, clear
set seed 1001


*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)

*MAKE DATASET PANEL
tsset (id) year


*WILL ESTIMATE REGRESSIONS FOLLOWING TIME IN A CHARTER SPELL AND PERSISTENCE
		
	*IDENTIFY LAST CHARTER
	gen lastchart = .
	gen laststart = .
	gen lastconv = .
	forvalues lag = 11(-1)1 {
	  replace lastchart = l`lag'.schoolid if l`lag'.charter == 1
	  replace laststart = l`lag'.schoolid if l`lag'.startup_unzoned == 1
	  replace lastconv = l`lag'.schoolid if l`lag'.convert_zoned == 1
	}
	replace lastchart = schoolid if charter == 1
	replace laststart = schoolid if startup_unzoned == 1
	replace lastconv = schoolid if convert_zoned == 1

        *IDENTIFY YEARS SINCE CHARTER SPELLS BEGAN AND POST-CHARTER YEARS
	
	*CHARTER
	tsspell charter	
	gen charter_spell_length = 0
	replace charter_spell_length = _seq if charter == 1
	gen post_charter_length = 0
	replace post_charter_length = _seq if charter == 0 & lastchart != .
	drop _*
	
	*CONVERT_ZONED
	tsspell convert_zoned
	gen convert_spell_length = 0
	replace convert_spell_length = _seq if convert_zoned == 1
	gen post_convert_length = 0
	replace post_convert_length = _seq if convert_zoned == 0 & lastconv != .
	drop _*
	
	*STARTUP_UNZONED
	tsspell startup_unzoned
	gen startup_spell_length = 0
	replace startup_spell_length = _seq if startup_unzoned == 1
	gen post_startup_length = 0
	replace post_startup_length = _seq if startup_unzoned == 0 & laststart != .
	drop _*
	
	*GENERATE SET OF VARIABLES THAT ACCOUNT FOR WHETHER A SCHOOL CURRENTLY HOLDS EACH GRADE-LEVEL

	*MERGE IN MAXGRADE DATA FOR LAST CHARTER
	foreach var of varlist lastchart laststart lastconv {
	  rename `var' schoolid_temp
	  sort schoolid_temp year
	  merge schoolid_temp year using /work/s/simberman/lusd/charter1/maxgrades.dta, nokeep
	  drop _merge

	  *IF LAST CHARTER IS CLOSED THEN MAXGRADE & MINGRADE WILL BE MISSING
	  *REPLACE THESE WITH 0 SO THAT STUDENTS IN CHARTERS THAT CLOSE ARE GRADE-INELIGIBLE
	  rename maxgrade maxgrade_`var'
	  replace maxgrade_`var' = 0 if maxgrade_`var' == .

	  rename mingrade mingrade_`var'
	  replace mingrade_`var' = 0 if mingrade_`var' == .
	
	  rename schoolid_temp `var'
       }

	xtset (id) year

       *IDENTIFY A STUDENT'S PREDICTED GRADE BASED ON BIRTHDATE
       *BIRTHDAYS ONLY AVAILBLE 1996 & LATER, SO WILL DO BOTH USING PREDICTED GRADE BASED OFF BIRTH & BASED OFF PRIOR YEAR
       *AFTER 1996 DOB IS MISSING FOR APPROX 800 OBS PER YEAR
       *USE DOB_2 WHERE IF THE DOB CHANGES OVER TIME FOR A STUDENT, THE MOST RECENT ONE IS TAKEN
	tostring dob_2, replace
	replace dob_2 = "0" + dob_2 if length(dob_2) == 5
	gen yob = real(substr(dob_2,5,2))
	replace yob = yob + 1900 if yob >= 10
	replace yob = yob + 2000 if yob < 10
	gen mob = real(substr(dob_2,1,2))


	*GENERATE BIRTH COHORTS BASED ON CUTOFF OF 9/1
	gen birth_cohort = yob
	replace birth_cohort = birth_cohort + 1 if mob >= 9

	*GENERATE PREDICTED GRADE FROM DOB
	gen pred_grade_dob = year - birth_cohort - 5

	*GENERATE PREDICTED GRADE OFF OF LAST-YEAR'S GRADE
	gen pred_grade_lyear = l.grade + 1
	replace pred_grade_lyear = grade if l.grade == .

	*GENERATE PREDICTED GRADE TAKING GRADE AT FIRST YEAR IN CHARTER AS GIVEN
	*FOR THESE PURPOSES I WILL TAKE THE FIRST YEAR IN ANY CHARTER AS THE BASELINE
	*IF STUDENT ENTERS CHARTER IN KG OR LOWER GRADE THEN USE FIRST GRADE AS A BASELINE
	append using /work/s/simberman/lusd/charter1/lusd_data_kg.dta
	sort id year
	gen chart_year = year if charter == 1
	egen first_chart_year = min(chart_year), by(id)
	gen chart_grade = grade if year == first_chart_year
	egen first_chart_grade = min(chart_grade), by(id)
	gen pred_grade_first_chart = grade
	replace pred_grade_first_chart = first_chart_grade + (year - first_chart_year) if first_chart_year != . & first_chart_grade != .
	drop if grade <= 0	
	
	*GENERATE THE INSTRUMENT FOR TIME IN CHARTER
	*NUMBER OF YEARS FROM FIRST GRADE OF CHARTER'S COVERAGE TO STUDENT'S CURRENT PREDICTED GRADE (I.E. POTENTIAL CHARTER LENGTH)
	*INSTRUMENT EQALS 0 IF STUDENT IS PREDICT GRADE-INELIGIBLE FOR CHARTER
	*THE FIRST GRADE OF CHARTER COVERAGE WILL BE BASED ON CURRENT YEAR --> CHARTERS ALMOST ALWAYS START AT LOWER GRADES AND ADD UP
	*RATHER THAN START AT HIGHER GRADES AND ADD DOWN 

	foreach chartvar of varlist lastchart laststart lastconv {
	  gen elig_2_dob_`chartvar' = 0
	  gen elig_3_dob_`chartvar' = 0
	  gen elig_4_dob_`chartvar' = 0
	}

	foreach chartvar of varlist lastchart laststart lastconv {
	  replace elig_2_dob_`chartvar' = 1 if pred_grade_dob - mingrade_`chartvar' == 1 & mingrade_`chartvar' != 0 & pred_grade_dob < maxgrade_`chartvar'
	  replace elig_3_dob_`chartvar' = 1 if pred_grade_dob - mingrade_`chartvar' == 2 & mingrade_`chartvar' != 0 & pred_grade_dob < maxgrade_`chartvar'
	  replace elig_4_dob_`chartvar' = 1 if pred_grade_dob - mingrade_`chartvar' >= 3 & mingrade_`chartvar' != 0 & pred_grade_dob < maxgrade_`chartvar'
	}


	foreach chartvar of varlist lastchart laststart lastconv {
	  gen elig_2_first_chart_`chartvar' = 0
	  gen elig_3_first_chart_`chartvar' = 0
	  gen elig_4_first_chart_`chartvar' = 0
	}

	foreach chartvar of varlist lastchart laststart lastconv {
	  replace elig_2_first_chart_`chartvar' = 1 if pred_grade_first_chart - mingrade_`chartvar' == 1 & mingrade_`chartvar' != 0 & pred_grade_first_chart < maxgrade_`chartvar'
	  replace elig_3_first_chart_`chartvar' = 1 if pred_grade_first_chart - mingrade_`chartvar' == 2 & mingrade_`chartvar' != 0 & pred_grade_first_chart < maxgrade_`chartvar'
	  replace elig_4_first_chart_`chartvar' = 1 if pred_grade_first_chart - mingrade_`chartvar' >= 3 & mingrade_`chartvar' != 0 & pred_grade_first_chart < maxgrade_`chartvar'
	}


	*DROP IF THE PERSON HAS OBSERVATIONS IN 1996 OR LATER AND IS MISSING DOB
	destring dob_2, replace
	gen no_dob = dob_2 == . &  year >= 1996
	egen no_dob_2 = max(no_dob), by(id)

	***NOTE HERE - IF I DECIDE TO USE THE LAST-YEAR PREDICTED GRADE I CAN GET RID OF THIS STATEMENT, BUT TRY REGS FIRST WITHOUT THESE***
	keep if no_dob_2 == 0
	
	*INDICATORS FOR POST-CHARTER SPELLS
	foreach chartvar in "charter" "startup" "convert" {
	  gen post_`chartvar'_1 = post_`chartvar'_length == 1
	  gen post_`chartvar'_2 = post_`chartvar'_length == 2
	  gen post_`chartvar'_3 = post_`chartvar'_length == 3
	  gen post_`chartvar'_4 = post_`chartvar'_length >= 4
	}

	*INDICATORS FOR CHARTER SPELLS
	foreach chartvar in "charter" "startup" "convert" {
	  gen `chartvar'_1 = `chartvar'_spell_length == 1
	  gen `chartvar'_2 = `chartvar'_spell_length == 2
	  gen `chartvar'_3 = `chartvar'_spell_length == 3
	  gen `chartvar'_4 = `chartvar'_spell_length >= 4
	}


     *SAVE IN A TEMPORARY FILE
     save /work/s/simberman/lusd/charter1/temp_timeinchart.dta, replace


*TEST SAMPLE

     *OPEN TEMPORARY DATASET
     use /work/s/simberman/lusd/charter1/temp_timeinchart.dta, clear
  
	
     *IDENTIFY VARIABLES TO BE DEMEANED
     local demean "charter_* startup_* convert_* post_* elig_*"


     *LIMIT TO TEST SCORE OBS & 1998 OR LATER
     keep if year >= 1998
     keep if stanford_math_sd != . & stanford_read_sd !=. & stanford_lang_sd != .

     *FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
     *gsample 5, wor percent cluster(id)


*DEMEAN VARIABLES NOT ALREADY DEMEANED IN DATASET
keep id year `demean'
drop startup_unzoned convert_zoned
foreach var of varlist `demean' {
  qui sum `var'
  local mean = r(mean)
  egen temp1 = mean(`var'), by(id)
  gen temp2 = `var' - temp1 + `mean'
  replace `var' = temp2
  drop temp1 temp2
}
sort id year
merge id year using /work/s/simberman/lusd/charter1/lusd_data_levels_test.dta



*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*  structural-outofdist_grade_11"

*DEPENDENT VARIABLES USED
local depvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd"



*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1



*(A) IV USING DOB BASED PREDICTED GRADE
local i 1
local j 0

*FIRST STAGE
local stage 1
foreach var of varlist  startup_1 startup_2 startup_3 startup_4  convert_1 convert_2 convert_3 convert_4 {
	reg `var' elig_*_first_chart_laststart elig_*_first_chart_lastconv `febase', robust cluster(schoolid)
}

# delimit ;

foreach var of varlist `depvarlist'{;
 local k 1;
 
 *OLS;
 local stage 0;
 local j = `j' + 1;
 reg `var' startup_1  startup_2  startup_3 startup_4  convert_1 convert_2 convert_3 convert_4 `febase', robust cluster(schoolid) ;

  test convert_1 = convert_2;
  test convert_1 = convert_3;
  test convert_1 = convert_4;
  test convert_2 = convert_3;
  test convert_2 = convert_4;
  test convert_3 = convert_4;

  test startup_1 = startup_2;
  test startup_1 = startup_3;
  test startup_1 = startup_4;
  test startup_2 = startup_3;
  test startup_2 = startup_4;
  test startup_3 = startup_4;

 foreach indepvar of varlist      startup_1  startup_2  startup_3  
	startup_4   convert_1 convert_2 convert_3 convert_4 {;
   post charter_timeinchart_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
   post charter_timeinchart_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
   local k = `k' + 1;
 };


 *SECOND STAGE;
 *NOTE THAT UNDER THE ASSUMPTION THAT ENTRY IS DEALT WITH BY THE PANEL METHODS, THE FIRST YEAR IN THE CHARTER DOES NOT NEED TO BE INTSTRUMENTED, ;
 *THUS I ONLY INSTRUMENT FOR FOLLOWING YEARS;

 local k 1;
 local stage 2;
 ivreg `var'  startup_1  convert_1 `febase' (startup_2  startup_3  
	startup_4  convert_2 convert_3 convert_4 = elig_*_first_chart_laststart elig_*_first_chart_lastconv), robust cluster(schoolid) ;


  test convert_1 = convert_2;
  test convert_1 = convert_3;
  test convert_1 = convert_4;
  test convert_2 = convert_3;
  test convert_2 = convert_4;
  test convert_3 = convert_4;

  test startup_1 = startup_2;
  test startup_1 = startup_3;
  test startup_1 = startup_4;
  test startup_2 = startup_3;
  test startup_2 = startup_4;
  test startup_3 = startup_4;

 foreach indepvar of varlist   startup_1  startup_2  
	startup_3  startup_4   convert_1 convert_2 convert_3 convert_4 {;
 	post charter_timeinchart_levels (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
 	post charter_timeinchart_levels (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
	local k = `k' + 1;
 };
};

# delimit cr

*BASE SAMPLE

     *OPEN TEMPORARY DATASET
     use /work/s/simberman/lusd/charter1/temp_timeinchart.dta, clear

	
     *IDENTIFY VARIABLES TO BE DEMEANED
     local demean "charter_* startup_* convert_* post_* elig_*"


     *LIMIT TO DISCIP & ATTEND OBS & 1994 OR LATER
     keep if year >= 1994
     keep if infrac != . & perc_attn != .


     *FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
     *gsample 5, wor percent cluster(id)


*DEMEAN VARIABLES NOT ALREADY DEMEANED IN DATASET
keep id year `demean'
drop  startup_unzoned convert_zoned
foreach var of varlist `demean' {
  qui sum `var'
  local mean = r(mean)
  egen temp1 = mean(`var'), by(id)
  gen temp2 = `var' - temp1 + `mean'
  replace `var' = temp2
  drop temp1 temp2
}
sort id year
merge id year using /work/s/simberman/lusd/charter1/lusd_data_levels_base.dta



*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*  structural-outofdist_grade_11"

*DEPENDENT VARIABLES USED
local depvarlist "infrac perc_attn"


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1




*(A) IV USING FIRST_CHART BASED PREDICTED GRADE
local i 1
local j 3

*FIRST STAGE
local stage 1
foreach var of varlist  startup_1 startup_2 startup_3 startup_4 convert_1 convert_2 convert_3 convert_4 {
	reg `var' elig_*_first_chart_laststart elig_*_first_chart_lastconv `febase', robust cluster(schoolid)
}

# delimit ;

foreach var of varlist `depvarlist'{;
 local k 1;
 
 *OLS;
 local stage 0;
 local j = `j' + 1;
 reg `var' startup_1 startup_2  startup_3  startup_4  convert_1 convert_2 convert_3 convert_4 `febase', robust cluster(schoolid) ;


  test convert_1 = convert_2;
  test convert_1 = convert_3;
  test convert_1 = convert_4;
  test convert_2 = convert_3;
  test convert_2 = convert_4;
  test convert_3 = convert_4;

  test startup_1 = startup_2;
  test startup_1 = startup_3;
  test startup_1 = startup_4;
  test startup_2 = startup_3;
  test startup_2 = startup_4;
  test startup_3 = startup_4;

 foreach indepvar of varlist startup_1  startup_2  startup_3  startup_4   convert_1 convert_2 convert_3 convert_4 {;
   post charter_timeinchart_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
   post charter_timeinchart_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
 local k = `k' + 1;
 };


 *SECOND STAGE;
 *NOTE THAT UNDER THE ASSUMPTION THAT ENTRY IS DEALT WITH BY THE PANEL METHODS, THE FIRST YEAR IN THE CHARTER DOES NOT NEED TO BE INTSTRUMENTED, ;
 *THUS I ONLY INSTRUMENT FOR FOLLOWING YEARS;

 local stage 2;
 local k 1;
 ivreg `var' startup_1  convert_1  `febase' (  startup_2  startup_3  
	startup_4 convert_2 convert_3 convert_4 = elig_*_first_chart_laststart elig_*_first_chart_lastconv), robust cluster(schoolid) ;


  test convert_1 = convert_2;
  test convert_1 = convert_3;
  test convert_1 = convert_4;
  test convert_2 = convert_3;
  test convert_2 = convert_4;
  test convert_3 = convert_4;

  test startup_1 = startup_2;
  test startup_1 = startup_3;
  test startup_1 = startup_4;
  test startup_2 = startup_3;
  test startup_2 = startup_4;
  test startup_3 = startup_4;

 foreach indepvar of varlist startup_1  startup_2  startup_3  startup_4   convert_1 convert_2 convert_3 convert_4 {;
 	post charter_timeinchart_levels (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
  	post charter_timeinchart_levels (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
 local k = `k' + 1;
 };
};



# delimit cr

postclose charter_timeinchart_levels
use /work/s/simberman/lusd/postfiles/charter_timeinchart_levels.dta, clear
sort regid depvarid stage indepvarid statname
outsheet using /work/s/simberman/lusd/postfiles/charter_timeinchart_levels.dat, replace


f
