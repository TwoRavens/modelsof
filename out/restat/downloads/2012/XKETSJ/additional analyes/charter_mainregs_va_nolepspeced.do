

*CHARTER IMPACT REGRESSIONS


*THIS FILE IS THE BASIC PROGRAM FOR RUNNING CHARTER SCHOOL REGRESSIONS AND IS MODIFIABLE IN A NUMBER OF WAYS

  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_main_va_nolepspeced int(regid stage depvarid indepvarid) str12 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /home/s/simberman/lusd/postfiles/charter_main_va_nolepspeced.dta, replace;
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


use /home/s/simberman/lusd/charter1/lusd_data_va_test.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year


*MERGE IN EXTRA VARIABLE
sort id year
merge id year using /home/s/simberman/lusd/charter1/lusd_data_b.dta, keep(lep speced gifted atrisk)
drop _merge


*IF WANT TO LOOK AT RETENTION REMOVE COMMENT HERE
/*
gen retained = f.grade <= grade if f.grade != .
local varkeep = "`varkeep' retained"
local demean = "`demean' retained"
*/


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1



*DROP LEP, SPECED
egen anylep = max(lep), by(id)
egen anyspeced = max(speced), by(id)
drop if anylep == 1 | anyspeced == 1

*COMPRESS DATASET
compress

*(C) INDIVIDUAL FE - ANY CHARTER - SWITCH CONTROLS
local i 3
local j 1
foreach var of varlist `depvarlist'{
 local k 1
 reg `var' charter `febase'  structural-outofdist_grade_10 , robust cluster(schoolid) 
 post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("chart") ("coef") (_b[charter]) (_b[charter]/_se[charter]) (e(N))
 post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("chart") ("se") (_se[charter]) (.) (e(N))
 local j = `j' + 1
}

*(B) FE - BY STARTUP OR CONVERSION - SWITCH CONTROLS
local i 4
local j 1
foreach var of varlist `depvarlist' {
  reg `var' convert_zoned startup_unzoned `febase'  structural-outofdist_grade_10 , robust cluster(schoolid) 
  local k 4
  post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}





*BASE SAMPLE


*DEPENDENT VARIABLES USED
local depvarlist "dinfrac dperc_attn"

use /home/s/simberman/lusd/charter1/lusd_data_va_base.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year


*IF WANT TO LOOK AT RETENTION REMOVE COMMENT HERE
/*
gen retained = f.grade <= grade if f.grade != .
local varkeep = "`varkeep' retained"
local demean = "`demean' retained"
*/


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*MERGE IN EXTRA VARIABLE
sort id year
merge id year using /home/s/simberman/lusd/charter1/lusd_data_b.dta, keep(lep speced gifted atrisk)
drop _merge



*DROP LEP, SPECED
egen anylep = max(lep), by(id)
egen anyspeced = max(speced), by(id)
drop if anylep == 1 | anyspeced == 1


*COMPRESS DATASET
compress

*(C) INDIVIDUAL FE - ANY CHARTER - SWITCH CONTROLS
local i 7
local j 1
foreach var of varlist `depvarlist'{
 local k 1
 reg `var' charter `febase'  structural-outofdist_grade_11 , robust cluster(schoolid) 
 post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("chart") ("coef") (_b[charter]) (_b[charter]/_se[charter]) (e(N))
 post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("chart") ("se") (_se[charter]) (.) (e(N))
 local j = `j' + 1
}

*(B) FE - BY STARTUP OR CONVERSION - SWITCH CONTROLS
local i 8
local j 1
foreach var of varlist `depvarlist' {
  reg `var' convert_zoned startup_unzoned `febase' structural-outofdist_grade_11 , robust cluster(schoolid) 
  local k 4
  post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_main_va_nolepspeced (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}

postclose charter_main_va_nolepspeced
use /home/s/simberman/lusd/postfiles/charter_main_va_nolepspeced.dta, clear
sort stage indepvarid regid depvarid statname
outsheet using /home/s/simberman/lusd/postfiles/charter_main_va_nolepspeced.dat, replace


