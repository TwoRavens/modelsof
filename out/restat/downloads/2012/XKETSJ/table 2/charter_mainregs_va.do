

*CHARTER IMPACT REGRESSIONS


*THIS FILE IS THE BASIC PROGRAM FOR RUNNING CHARTER SCHOOL REGRESSIONS AND IS MODIFIABLE IN A NUMBER OF WAYS

  
clear
set mem 4000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_main_va int(regid stage depvarid indepvarid) str12 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_main_va.dta, replace;
  # delimit cr


*VA MODELS

*SET LOCAL MACROS HERE
  
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*"

  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


*TEST SAMPLE


*DEPENDENT VARIABLES USED
local depvarlist "dstanford_math_sd dstanford_read_sd dstanford_lang_sd"


use /work/s/simberman/lusd/charter1/lusd_data_va_test.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*COMPRESS DATASET
compress


*(A) FE - POOLED
local i 1
local j 1
foreach var of varlist `depvarlist' {
  reg `var' convert_zoned startup_unzoned `febase'  structural-outofdist_grade_10 , robust cluster(schoolid) 

  local k 1
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
  local k 2
  post charter_main_va (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
 local j = `j' + 1
}



*(B) FE - HS VS. NON
local i 2
local j 1
foreach var of varlist `depvarlist' {
  reg `var' convert_zoned startup_unzoned startup_high `febase'  structural-outofdist_grade_10 , robust cluster(schoolid) 

   test startup_unzoned + startup_high = 0

  local k 3
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
  local k 4
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_high") ("coef") (_b[startup_high]) (_b[startup_high]/_se[startup_high]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_high") ("se") (_se[startup_high]) (.) (e(N))
  local k 5
  post charter_main_va (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))

 local j = `j' + 1
}



*(C)  ALL GRADE VA
local i 3
local j 1
foreach var of varlist `depvarlist' {
  reg `var' convert_zoned startup_unzoned startup_middle startup_high `febase'  structural-outofdist_grade_10 , robust cluster(schoolid) 

  test startup_unzoned + startup_middle  = 0
  test startup_unzoned + startup_high = 0

  local k 6
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
  local k 7
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_middle") ("coef") (_b[startup_middle]) (_b[startup_middle]/_se[startup_middle]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_middle") ("se") (_se[startup_middle]) (.) (e(N))
  local k 8
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_high") ("coef") (_b[startup_high]) (_b[startup_high]/_se[startup_high]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_high") ("se") (_se[startup_high]) (.) (e(N))
  local k 9
  post charter_main_va (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
 local j = `j' + 1
}





*BASE SAMPLE


*DEPENDENT VARIABLES USED
local depvarlist "dinfrac dperc_attn"

use /work/s/simberman/lusd/charter1/lusd_data_va_base.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1

*COMPRESS DATASET
compress


*(A) FE - POOLED
local i 1
local j 4
foreach var of varlist `depvarlist' {
  reg `var' convert_zoned startup_unzoned `febase'  structural-outofdist_grade_10 , robust cluster(schoolid) 
  local k 1
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
  local k 2
  post charter_main_va (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
 local j = `j' + 1
}



*(B) FE - HS VS. NON
local i 2
local j 4
foreach var of varlist `depvarlist' {
  reg `var' convert_zoned startup_unzoned startup_high `febase'  structural-outofdist_grade_10 , robust cluster(schoolid) 

  test startup_unzoned + startup_high = 0

  local k 3
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
  local k 4
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_high") ("coef") (_b[startup_high]) (_b[startup_high]/_se[startup_high]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_high") ("se") (_se[startup_high]) (.) (e(N))
  local k 5
  post charter_main_va (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))

 local j = `j' + 1
}



*(C)  ALL GRADE VA
local i 3
local j 4
foreach var of varlist `depvarlist' {
  reg `var' convert_zoned startup_unzoned startup_middle startup_high `febase'  structural-outofdist_grade_10 , robust cluster(schoolid) 

  test startup_unzoned + startup_middle = 0
  test startup_unzoned + startup_high = 0

  local k 6
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
  local k 7
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_middle") ("coef") (_b[startup_middle]) (_b[startup_middle]/_se[startup_middle]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_middle") ("se") (_se[startup_middle]) (.) (e(N))
  local k 8
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_high") ("coef") (_b[startup_high]) (_b[startup_high]/_se[startup_high]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_high") ("se") (_se[startup_high]) (.) (e(N))
  local k 9
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_main_va (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
 local j = `j' + 1
}

postclose charter_main_va
use /work/s/simberman/lusd/postfiles/charter_main_va.dta, clear
sort stage indepvarid regid depvarid statname
outsheet using /work/s/simberman/lusd/postfiles/charter_main_va.dat, replace

