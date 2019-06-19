**RUNS REGRESSIONS OF CHARTER IMPACTS WITH SEPARATE ESTIMATORS FOR 1, 2, 3, 4+ YEARS IN CHARTER

  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_timeinchart_va int(regid stage depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /home/s/simberman/lusd/postfiles/charter_timeinchart_va.dta, replace;
  # delimit cr


*VA MODELS

*SET LOCAL MACROS HERE


*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*  structural-outofdist_grade_10"

  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0

*TEST SAMPLE

     *OPEN TEMPORARY DATASET
     use /work/s/simberman/lusd/charter1/temp_timeinchart.dta, clear
  
	
     *IDENTIFY VARIABLES TO BE DEMEANED
     local demean "charter_* startup_* convert_* post_* elig_*"

     *LIMIT TO TEST SCORE OBS & 1998 OR LATER     
     keep id year `demean'
     drop startup_unzoned convert_zoned
     sort id year
     merge id year using /work/s/simberman/lusd/charter1/lusd_data_va_test.dta
     keep if year >= 1998
     keep if dstanford_math_sd != . & dstanford_read_sd != . & dstanford_lang_sd != .

     *FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
     *gsample 5, wor percent cluster(id)


*DEMEAN VARIABLES NOT ALREADY DEMEANED IN DATASET
foreach var of varlist `demean' {
  qui sum `var'
  local mean = r(mean)
  egen temp1 = mean(`var'), by(id)
  gen temp2 = `var' - temp1 + `mean'
  replace `var' = temp2
  drop temp1 temp2
}




*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*  structural-outofdist_grade_10"

*DEPENDENT VARIABLES USED
local depvarlist "dstanford_math_sd dstanford_read_sd dstanford_lang_sd"


*(A) IV USING FIRST_CHART BASED PREDICTED GRADE
local i 1
local j 0

*FIRST STAGE
local stage 1
foreach var of varlist  startup_2 startup_3 startup_4 convert_2 convert_3 convert_4 {
	reg `var' elig_*_first_chart_laststart elig_*_first_chart_lastconv `febase', robust cluster(schoolid)
}

# delimit ;

foreach var of varlist `depvarlist'{;
 local k 1;
 
 *OLS;
 local stage 0;
 local j = `j' + 1;
 reg `var'    startup_1  startup_2  startup_3  
	startup_4   convert_1 convert_2 convert_3 convert_4 `febase', robust cluster(schoolid) ;


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

 foreach indepvar of varlist startup_1  startup_2  startup_3  
	startup_4 convert_1 convert_2 convert_3 convert_4 {;
   post charter_timeinchart_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
   post charter_timeinchart_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
   local k = `k' + 1;
 };


 *SECOND STAGE;
 *NOTE THAT UNDER THE ASSUMPTION THAT ENTRY IS DEALT WITH BY THE PANEL METHODS, THE FIRST YEAR IN THE CHARTER DOES NOT NEED TO BE INTSTRUMENTED, ;
 *THUS I ONLY INSTRUMENT FOR FOLLOWING YEARS;

 local k 1;
 local stage 2;
 ivreg `var' startup_1 convert_1 `febase' (startup_2  startup_3  
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

 foreach indepvar of varlist     startup_1  startup_2  
	startup_3  startup_4   convert_1 convert_2 convert_3 convert_4 {;
 	post charter_timeinchart_va (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
 	post charter_timeinchart_va (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
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
     keep id year `demean'
     drop startup_unzoned convert_zoned
     sort id year
     merge id year using /work/s/simberman/lusd/charter1/lusd_data_va_base.dta
     keep if year >= 1994
     keep if dinfrac != . & dperc_attn != .

     *FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
     *gsample 5, wor percent cluster(id)


*DEMEAN VARIABLES NOT ALREADY DEMEANED IN DATASET
foreach var of varlist `demean' {
  qui sum `var'
  local mean = r(mean)
  egen temp1 = mean(`var'), by(id)
  gen temp2 = `var' - temp1 + `mean'
  replace `var' = temp2
  drop temp1 temp2
}



*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*  structural_grade_* nonstructural_grade_* outofdist_grade_*"

*DEPENDENT VARIABLES USED
local depvarlist "dinfrac dperc_attn"


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1




*(A) IV USING FIRST_CHART BASED PREDICTED GRADE
local i 1
local j 3

*FIRST STAGE
local stage 1
foreach var of varlist  startup_2 startup_3 startup_4  convert_2 convert_3 convert_4 {
	reg `var' elig_*_first_chart_laststart elig_*_first_chart_lastconv `febase', robust cluster(schoolid)
}

# delimit ;

foreach var of varlist `depvarlist'{;
 local k 1;
 
 *OLS;

 local stage 0;
 local j = `j' + 1;
 reg `var' startup_1  startup_2  startup_3 startup_4 convert_1 convert_2 convert_3 convert_4 `febase', robust cluster(schoolid) ;

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

 foreach indepvar of varlist startup_1  startup_2  startup_3 startup_4 convert_1 convert_2 convert_3 convert_4 {;
   post charter_timeinchart_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
   post charter_timeinchart_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
 local k = `k' + 1;
 };


 *SECOND STAGE;
 *NOTE THAT UNDER THE ASSUMPTION THAT ENTRY IS DEALT WITH BY THE PANEL METHODS, THE FIRST YEAR IN THE CHARTER DOES NOT NEED TO BE INTSTRUMENTED, ;
 *THUS I ONLY INSTRUMENT FOR FOLLOWING YEARS;

 local stage 2;
 local k 1;
 ivreg `var' startup_1 convert_1   `febase' ( startup_2  startup_3  
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

 foreach indepvar of varlist  startup_1  startup_2  startup_3  startup_4   convert_1 convert_2 convert_3 convert_4 {;
 	post charter_timeinchart_va (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
  	post charter_timeinchart_va (`i') (`stage') (`j') (`k') ("iv-ss") ("`var'") ("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
 local k = `k' + 1;
 };
};



# delimit cr

postclose charter_timeinchart_va
use /work/s/simberman/lusd/postfiles/charter_timeinchart_va.dta, clear
sort regid depvarid stage indepvarid statname
outsheet using /work/s/simberman/lusd/postfiles/charter_timeinchart_va.dat, replace


f
