
***RUNS REGRESSIONS OF WHETHER CHARTER STUDENTS ARE MORE LIKELY TO ATTRIT THEN OBSERBABLY SIMILAR NON-CHARTER

  
clear
set mem 8000m
set matsize 2000
set more off


*SET LOCAL MACROS HERE
  
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant structural_grade_* nonstructural_grade_* outofdist_grade_* grade_* year_* gradeyear_*"

  *VARIABLES KEPT IN DATASET
  # delimit ;
  local varkeep "id campus schoolid charter convert startup charter_zoned charter_unzoned grade year stanford_math_sd stanford_read_sd stanford_lang_sd infrac perc_attn 
		freel redl othecon recent_immi migrant structural-structural* nonstructural* outofdist* gradeyear_*";
  # delimit cr

  *COUNTER
  local i 1

  *DEPENDENT VARIABLES USED
  local depvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd infrac perc_attn"

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0



use /home/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*LIMIT TO BASE SAMPLE
keep if year >= 1994
keep if perc_attn != . & infrac !=.

*GENERATE YEAR, GRADE DUMMIES
tab year, gen(year_)

*MAKE DATASET PANEL
xtset (id) year

*IDENTIFY ATTRITERS
gen attrit = 0
replace attrit = 1 if f.perc_attn ==. 

*LIMIT TO GRADES 1 - 11 & DROP 2006 SINCE THERE IS NO 2007 DATA
keep if grade >= 1 & grade <= 11
keep if year <= 2006

*GENERATE INDICATORS FOR ES, MS, HS GRADES AND INTERACT WITH CHARTER VARS
gen elem = grade >= 1 & grade <= 5
gen middle = grade >= 6 & grade <= 8
gen high = grade >= 9 & grade <= 11

foreach gradelevel of varlist elem middle high {
 gen convert_`gradelevel' = convert_zoned*`gradelevel'
 gen startup_`gradelevel' = startup_unzoned*`gradelevel'
}

*DROP MAGNET CHARTER
drop if ever_magnet_chart == 1

drop *_12

***REGRESSIONS

*BASELINE ATTRITION
xtreg attrit convert_zoned startup_unzoned `febase', robust cluster(schoolid) fe nonest

*ATTRITION BY GRADE LEVEL
xtreg attrit convert_zoned convert_middle startup_unzoned startup_middle startup_high `febase', robust cluster(schoolid) fe nonest

*ATTRITION BY TEST SCORE

*INTERACT CHARTER STATUS WITH MATH, READING SCORES
foreach test in "read" "math" {
  gen convert_`test' = convert_zoned*stanford_`test'_sd
  gen startup_`test' = startup_unzoned*stanford_`test'_sd
}

xtreg attrit convert_zoned convert_math convert_read  startup_unzoned startup_math  startup_read  stanford_math_sd stanford_read_sd `febase', robust cluster(schoolid) fe nonest


f



