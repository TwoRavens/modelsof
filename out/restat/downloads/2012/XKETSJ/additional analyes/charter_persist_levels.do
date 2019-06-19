

*CHARTER IMPACT REGRESSIONS


*THIS FILE IS THE BASIC PROGRAM FOR RUNNING CHARTER SCHOOL REGRESSIONS AND IS MODIFIABLE IN A NUMBER OF WAYS

  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_persist_levels int(regid stage depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /home/s/simberman/lusd/postfiles/charter_persist_levels.dta, replace;
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
use /home/s/simberman/lusd/charter1/lusd_data_b, clear

  *COLLAPSE TO A SCHOOL BY YEAR DATASET THAT IDENTIFIES THE MAXIMUM GRADE IN EACH SCHOOL
  collapse (max) grade, by(schoolid year)
  rename schoolid schoolid_temp
  rename grade maxgrade
  save /home/s/simberman/lusd/charter1/maxgrades.dta, replace


*FOR THIS PROGRAM, NEED TO USE ORIGINAL DATASET TO ADD INELIGIBLILTY VARIABLES
*THUS INSTEAD OF DEMEANING, USE XTREG
use /home/s/simberman/lusd/charter1/lusd_data_b, clear
set seed 1001


*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)

*MAKE DATASET PANEL
tsset (id) year


*WILL ESTIMATE REGRESSIONS FOLLOWING TIME IN A CHARTER SPELL AND PERSISTENCE

        *IDENTIFY YEARS SINCE CHARTER SPELLS BEGAN AND POST-CHARTER YEARS
	
	*CHARTER
	tsspell charter	
	gen charter_spell_length = 0
	replace charter_spell_length = _seq if charter == 1
	gen post_charter_length = 0
	replace post_charter_length = _seq if charter == 0 & _spell > 1
	drop _*
	
	*CONVERT_ZONED
	tsspell convert_zoned
	gen convert_spell_length = 0
	replace convert_spell_length = _seq if convert_zoned == 1
	gen post_convert_length = 0
	replace post_convert_length = _seq if convert_zoned == 0 & _spell > 1
	drop _*
	
	*STARTUP_UNZONED
	tsspell startup_unzoned
	gen startup_spell_length = 0
	replace startup_spell_length = _seq if startup_unzoned == 1
	gen post_startup_length = 0
	replace post_startup_length = _seq if startup_unzoned == 0 & _spell > 1
	drop _*
	
	*GENERATE SET OF VARIABLES THAT ACCOUNT FOR WHETHER A SCHOOL CURRENTLY HOLDS EACH GRADE-LEVEL
		
	*IDENTIFY LAST CHARTER
	gen lastchart = .
	gen laststart = .
	gen lastconv = .
	forvalues lag = 11(-1)1 {
	  replace lastchart = l`lag'.schoolid if l`lag'.charter == 1
	  replace laststart = l`lag'.schoolid if l`lag'.startup_unzoned == 1
	  replace lastconv = l`lag'.schoolid if l`lag'.convert_zoned == 1
	}

	*MERGE IN MAXGRADE DATA FOR LAST CHARTER
	foreach var of varlist lastchart laststart lastconv {
	  rename `var' schoolid_temp
	  sort schoolid_temp year
	  merge schoolid_temp year using /home/s/simberman/lusd/charter1/maxgrades.dta, nokeep
	  drop _merge

	  *IF LAST CHARTER IS CLOSED THEN MAXGRADE WILL BE MISSING
	  *REPLACE THIS WITH 0 SO THAT STUDENTS IN CHARTERS THAT CLOSE ARE GRADE-INELIGIBLE
	  rename maxgrade maxgrade_`var'
	  replace maxgrade_`var' = 0 if maxgrade_`var' == .
	  rename schoolid_temp `var'
       }

	xtset (id) year

f
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

	*GENERATE PREDICTED GRADE
	gen pred_grade_dob = year - birth_cohort - 5

	*GENERATE PREDICTED GRADE OFF OF LAST-YEAR'S GRADE
	gen pred_grade_lyear = l.grade + 1
	replace pred_grade_lyear = grade if l.grade == .

	*GENERATE PREDICTED GRADE TAKING GRADE AT FIRST YEAR IN CHARTER AS GIVEN
	*FOR THESE PURPOSES I WILL TAKE THE FIRST YEAR IN ANY CHARTER AS THE BASELINE
	append using /home/s/simberman/lusd/charter1/lusd_data_kg.dta
	sort id year
	gen chart_year = year if charter == 1
	egen first_chart_year = min(chart_year), by(id)
	gen chart_grade = grade if year == first_chart_year
	egen first_chart_grade = min(chart_grade), by(id)
	gen pred_grade_first_chart = grade
	replace pred_grade_first_chart = first_chart_grade + (year - first_chart_year) if first_chart_year != . & first_chart_grade != .
	drop if grade <= 0	

	*GENERATE THE INSTRUMENT FOR POST-CHARTER- IDENTIFY WHETHER STUDENT IS 1, 2+ GRADES ABOVE MAX GRADE FOR LAST CHARTER
	*LET THE VARIABLE = 0 IF STUDENT NEVER ATTENDED A CHARTER

	foreach chartvar of varlist lastchart laststart lastconv {

	  *PRED GRADE BY DOB
	  gen inelig_1_dob_`chartvar' = pred_grade_dob == maxgrade_`chartvar' + 1
	  gen inelig_2_dob_`chartvar' = pred_grade_dob == maxgrade_`chartvar' + 2
	  gen inelig_3_dob_`chartvar' = pred_grade_dob == maxgrade_`chartvar' + 3
	  gen inelig_4_dob_`chartvar' = pred_grade_dob >= maxgrade_`chartvar' + 4

	  replace inelig_1_dob_`chartvar' = 0 if maxgrade_`chartvar' == 0
	  replace inelig_2_dob_`chartvar' = 0 if maxgrade_`chartvar' == 0
	  replace inelig_3_dob_`chartvar' = 0 if maxgrade_`chartvar' == 0
	  replace inelig_4_dob_`chartvar' = 0 if maxgrade_`chartvar' == 0


	  *PRED GRADE BY GRADE IN FIRST CHART YEAR
	  gen inelig_1_first_chart_`chartvar' = pred_grade_first_chart == maxgrade_`chartvar' + 1
	  gen inelig_2_first_chart_`chartvar' = pred_grade_first_chart == maxgrade_`chartvar' + 2
	  gen inelig_3_first_chart_`chartvar' = pred_grade_first_chart == maxgrade_`chartvar' + 3
	  gen inelig_4_first_chart_`chartvar' = pred_grade_first_chart >= maxgrade_`chartvar' + 4

	  replace inelig_1_first_chart_`chartvar' = 0 if maxgrade_`chartvar' == 0
	  replace inelig_2_first_chart_`chartvar' = 0 if maxgrade_`chartvar' == 0
	  replace inelig_3_first_chart_`chartvar' = 0 if maxgrade_`chartvar' == 0
	  replace inelig_4_first_chart_`chartvar' = 0 if maxgrade_`chartvar' == 0

	}

	*REPLACE ALL INELIG VARIABLES = 0 IF YEAR < 1996
	*THIS WILL ALLOW ME TO KEEP PRE-1996 YEARS AS THE BIRTHDAY IS MISSING
	*SINCE PRE-1996 THERE WERE NO CHARTERS THESE VARIABLES SHOULD ALL BE 0 FOR THESE YEARS
	foreach chartvar of varlist lastchart laststart lastconv {
	  replace inelig_1_first_chart_`chartvar' = 0 if year < 1996
	  replace inelig_2_first_chart_`chartvar' = 0 if  year < 1996
	  replace inelig_3_first_chart_`chartvar' = 0 if year < 1996
	  replace inelig_4_first_chart_`chartvar' = 0 if  year < 1996

	  replace inelig_1_dob_`chartvar' = 0 if  year < 1996
	  replace inelig_2_dob_`chartvar' = 0 if  year < 1996
	  replace inelig_3_dob_`chartvar' = 0 if  year < 1996
	  replace inelig_4_dob_`chartvar' = 0 if  year < 1996
	}


	*REPLACE ALL INELIG VARIABLES = 0 IF YEAR < 1996
	*THIS WILL ALLOW ME TO KEEP PRE-1996 YEARS AS THE BIRTHDAY IS MISSING
	*SINCE PRE-1996 THERE WERE NO CHARTERS THESE VARIABLES SHOULD ALL BE 0 FOR THESE YEARS
	*HOWEVER, KEEP THIS AS MISSING IF THE PERSON HAS OBSERVATIONS IN 1996 OR LATER AND IS MISSING DOB
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
     drop if year == 0
     save /home/s/simberman/lusd/charter1/temp_persist.dta, replace



*TEST SAMPLE

     *OPEN TEMPORARY DATASET
     use /home/s/simberman/lusd/charter1/temp_persist.dta, clear
  
	
     *IDENTIFY VARIABLES TO BE DEMEANED
     local demean "charter_* startup_* convert_* post_* inelig_*"

     *LIMIT TO TEST SCORE OBS & 1998 OR LATER
     keep if year >= 1998
     keep if stanford_math_sd != . & stanford_read_sd !=. & stanford_lang_sd != .

     *FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
     *gsample 5, wor percent cluster(id)


*DEMEAN VARIABLES NOT ALREADY DEMEANED IN DATASET
keep id year `demean'
foreach var of varlist `demean' {
  qui sum `var'
  local mean = r(mean)
  egen temp1 = mean(`var'), by(id)
  gen temp2 = `var' - temp1 + `mean'
  replace `var' = temp2
  drop temp1 temp2
}
sort id year
merge id year using /home/s/simberman/lusd/charter1/lusd_data_levels_test.dta


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*  structural-outofdist_grade_10"

*DEPENDENT VARIABLES USED
local depvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd"


*(A) IV USING DOB BASED PREDICTED GRADE
local i 1
local j 0

*FIRST STAGE
local stage 1
foreach var of varlist post_startup_1 post_startup_2 post_startup_3 post_startup_4 post_convert_1 post_convert_2 post_convert_3 post_convert_4 {
	reg `var' inelig_*_dob_laststart inelig_*_dob_lastconv `febase', robust cluster(schoolid)
}

# delimit ;

foreach var of varlist `depvarlist'{;
 local k 1;
 
 *OLS;
 local stage 0;
 local j = `j' + 1;
 reg `var' startup_unzoned convert_zoned  post_startup_1  post_startup_2  post_startup_3  
	post_startup_4  post_convert_1 post_convert_2 post_convert_3 post_convert_4 `febase', robust cluster(schoolid) ;
 test post_convert_1 post_convert_2 post_convert_3 post_convert_4;
 test post_startup_1 post_startup_2 post_startup_3 post_startup_4;

 foreach indepvar of varlist  startup_unzoned convert_zoned  post_startup_1  post_startup_2  post_startup_3  
	post_startup_4  post_convert_1 post_convert_2 post_convert_3 post_convert_4 {;
   post charter_persist_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
   post charter_persist_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
   local k = `k' + 1;
 };


 *SECOND STAGE;
 local k 1;
 local stage 2;
 ivreg `var' startup_unzoned convert_zoned `febase' (post_startup_1  post_startup_2  post_startup_3  
	post_startup_4  post_convert_1 post_convert_2 post_convert_3 post_convert_4 = inelig_*_first_chart_laststart inelig_*_first_chart_lastconv), robust cluster(schoolid) ;
 test post_convert_1 post_convert_2 post_convert_3 post_convert_4;
 test post_startup_1 post_startup_2 post_startup_3 post_startup_4;

 foreach indepvar of varlist  startup_unzoned convert_zoned  post_startup_1  post_startup_2  
	post_startup_3  post_startup_4  post_convert_1 post_convert_2 post_convert_3 post_convert_4 {;
 	post charter_persist_levels (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
 	post charter_persist_levels (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
	local k = `k' + 1;
 };
};

# delimit cr

# delimit cr

*BASE SAMPLE

     *OPEN TEMPORARY DATASET
     use /home/s/simberman/lusd/charter1/temp_persist.dta, clear

	
     *IDENTIFY VARIABLES TO BE DEMEANED
     local demean "charter_* startup_* convert_* post_* inelig_*"


     *LIMIT TO DISCIP & ATTEND OBS & 1994 OR LATER
     keep if year >= 1994
     keep if infrac != . & perc_attn != .


     *FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
     *gsample 5, wor percent cluster(id)


*DEMEAN VARIABLES NOT ALREADY DEMEANED IN DATASET
keep id year `demean'
foreach var of varlist `demean' {
  qui sum `var'
  local mean = r(mean)
  egen temp1 = mean(`var'), by(id)
  gen temp2 = `var' - temp1 + `mean'
  replace `var' = temp2
  drop temp1 temp2
}
sort id year
merge id year using /home/s/simberman/lusd/charter1/lusd_data_levels_base.dta



*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*  structural-outofdist_grade_11"

*DEPENDENT VARIABLES USED
local depvarlist "infrac perc_attn"


*(A) IV USING FIRST_CHART BASED PREDICTED GRADE
local i 1
local j 3

*FIRST STAGE
local stage 1
foreach var of varlist post_startup_1 post_startup_2 post_startup_3 post_startup_4 post_convert_1 post_convert_2 post_convert_3 post_convert_4 {
	reg `var' inelig_*_first_chart_laststart inelig_*_first_chart_lastconv `febase', robust cluster(schoolid)
}

# delimit ;

foreach var of varlist `depvarlist'{;
 local k 1;
 
 *OLS;
 local stage 0;
 local j = `j' + 1;
 reg `var' startup_unzoned convert_zoned  post_startup_1  post_startup_2  post_startup_3  
	post_startup_4  post_convert_1 post_convert_2 post_convert_3 post_convert_4 `febase', robust cluster(schoolid) ;

   test post_convert_1 post_convert_2 post_convert_3 post_convert_4;
   test post_startup_1 post_startup_2 post_startup_3 post_startup_4;

 foreach indepvar of varlist  startup_unzoned convert_zoned  post_startup_1  post_startup_2  post_startup_3  
	post_startup_4  post_convert_1 post_convert_2 post_convert_3 post_convert_4 {;
   post charter_persist_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
   post charter_persist_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
 local k = `k' + 1;
 };


 *SECOND STAGE;
 local stage 2;
 local k 1;
 ivreg `var' startup_unzoned convert_zoned `febase' (post_startup_1  post_startup_2  post_startup_3  
	post_startup_4  post_convert_1 post_convert_2 post_convert_3 post_convert_4 = inelig_*_first_chart_laststart inelig_*_first_chart_lastconv), robust cluster(schoolid) ;
 test post_convert_1 post_convert_2 post_convert_3 post_convert_4;
 test post_startup_1 post_startup_2 post_startup_3 post_startup_4;

 foreach indepvar of varlist  startup_unzoned convert_zoned  post_startup_1  post_startup_2  
	post_startup_3  post_startup_4  post_convert_1 post_convert_2 post_convert_3 post_convert_4 {;
 	post charter_persist_levels (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
  	post charter_persist_levels (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
 local k = `k' + 1;
 };
};


# delimit cr

postclose charter_persist_levels
use /home/s/simberman/lusd/postfiles/charter_persist_levels.dta, clear
sort regid depvarid stage indepvarid statname
outsheet using /home/s/simberman/lusd/postfiles/charter_persist_levels.dat, replace


f

