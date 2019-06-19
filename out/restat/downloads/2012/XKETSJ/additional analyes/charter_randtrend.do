

*CHARTER IMPACT REGRESSIONS


**CONDUCTS A RANDOM-TREND MODEL OF IMPACT ESTIMATES

  
clear
set mem 10000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_randtrend int(regid stage depvarid indepvarid) str12 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_randtrend.dta, replace;
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


foreach var of varlist `depvarlist' convert_zoned startup_unzoned `febase' {
  gen temp = d.`var'
  replace `var' = temp
  drop temp
}


*(B) FE - BY STARTUP OR CONVERSIONx
local i 2
local j 1
foreach var of varlist `depvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase'   , fe cluster(schoolid) nonest
  local k 4
  post charter_randtrend (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_randtrend (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_randtrend (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_randtrend (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}



*BASE SAMPLE


*DEPENDENT VARIABLES USED
local depvarlist "infractions perc_attn"

use /work/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)


*MAKE DATASET PANEL
xtset (id) year


*LIMIT TO BASE SAMPLE
keep if year >= 1994
keep if infractions != . & perc_attn != .


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1

*GENERATE YEAR DUMMIES
tab year, gen(year_)


foreach var of varlist `depvarlist' convert startup `febase' {
  gen temp = d.`var'
  replace `var' = temp
  drop temp
}

*COMPRESS DATASET
compress


  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*   structural* nonstructural* outofdist*"

drop *_12


foreach var of varlist `depvarlist' convert_zoned startup_unzoned `febase' {
  gen temp = d.`var'
  replace `var' = temp
  drop temp
}


*(B) FE - BY STARTUP OR CONVERSION
local i 2
local j 4
foreach var of varlist `depvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase' , fe cluster(schoolid) nonest 
  local k 4
  post charter_randtrend (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_randtrend (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_randtrend (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_randtrend (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}



postclose charter_randtrend
use /work/s/simberman/lusd/postfiles/charter_randtrend.dta, clear
sort stage indepvarid regid depvarid statname
outsheet using /work/s/simberman/lusd/postfiles/charter_randtrend.dat, replace


f



