

*CHARTER IMPACT REGRESSIONS


*THIS FILE IS THE BASIC PROGRAM FOR RUNNING CHARTER SCHOOL REGRESSIONS AND IS MODIFIABLE IN A NUMBER OF WAYS

  
clear
set mem 4000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_interpanel_levels int(regid stage depvarid indepvarid) str12 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_interpanel_levels.dta, replace;
  # delimit cr


*LEVELS MODELS

*SET LOCAL MACROS HERE
  
  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


*TEST SAMPLE


*DEPENDENT VARIABLES USED
local depvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd"


use /work/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id


*MAKE DATASET PANEL
xtset (id) year


*LIMIT TO TESTING SAMPLE
keep if year >= 1998
keep if stanford_math_sd != . & stanford_read_sd != . & stanford_lang_sd !=.


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*GENERATE YEAR DUMMIES
tab year, gen(year_)

*COMPRESS DATASET
compress

  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*   structural* nonstructural* outofdist*"

drop *_11 *_12

keep id year `depvarlist'  convert* startup* `febase' schoolid 
compress


foreach var of varlist `depvarlist' {
  di " "
  di "`var'"
  foreach school of numlist 325 341 345 378 385 1002 1003 1004 {
    di " "
    di "schoolid = `school'"
    di " "
    di " "
    xtreg `var' convert_zoned startup_elem startup_middle startup_high `febase'  if schoolid != `school', robust cluster(schoolid) nonest fe
  }
}




f



