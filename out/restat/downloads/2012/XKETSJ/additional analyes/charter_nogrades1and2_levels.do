


*CHARTER IMPACT REGRESSIONS

*ESTIMATES TEST SCORE RESULTS LIMITING TO STUDENTS IN GRADES 3 OR HIGHER TO COMPARE TO OTHER PAPERS	
  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_nogrades1and2_levels int(regid stage depvarid indepvarid) str12 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_nogrades1and2_levels.dta, replace;
  # delimit cr


*LEVELS MODELS

*SET LOCAL MACROS HERE
  
  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


*TEST SAMPLE


*DEPENDENT VARIABLES USED
local ldepvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd"
local vdepvarlist "dstanford_math_sd dstanford_read_sd dstanford_lang_sd"

use /work/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)


*MAKE DATASET PANEL
xtset (id) year


*LIMIT TO TESTING SAMPLE
keep if year >= 1998
keep if stanford_math_sd != . & stanford_read_sd != . & stanford_lang_sd !=.
foreach test in "stanford_math_sd" "stanford_read_sd" "stanford_lang_sd" {
  gen d`test' = d.`test'
}


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1

*COMPRESS DATASET
compress


*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant _I*"

xi i.year*i.grade i.grade*structural i.grade*nonstructural i.grade*outofdist
gen drop = 0


***LEVELS***
local stage 1


*KEEP GRADES 3 & HIGHER
replace drop = 1 if grade < 3

*(B) FE - BY STARTUP OR CONVERSION - NO SWITCH CONTROLS
local i 2
local j 1
foreach var of varlist `ldepvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase'   if drop == 0, robust cluster(schoolid) nonest fe
  local k 4
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}


*KEEP GRADES 3 - 8
replace drop = 1 if grade < 3 | grade >= 8

*(B) FE - BY STARTUP OR CONVERSION - NO SWITCH CONTROLS
local i 4
local j 1
foreach var of varlist `ldepvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase'   if drop == 0, robust cluster(schoolid) nonest fe
  local k 4
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}



*KEEP GRADES 4 - 8
replace drop = 1 if grade < 4 | grade >= 8

*(B) FE - BY STARTUP OR CONVERSION - NO SWITCH CONTROLS
local i 6
local j 1
foreach var of varlist `ldepvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase'   if drop == 0, robust cluster(schoolid) nonest fe
  local k 4
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}




***VA***
local stage 2
replace drop = 0

*KEEP GRADES 3 & HIGHER
replace drop = 1 if grade < 3

*(B) FE - BY STARTUP OR CONVERSION - NO SWITCH CONTROLS
local i 2
local j 1
foreach var of varlist `vdepvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase'   if drop == 0, robust cluster(schoolid) nonest fe
  local k 4
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}


*KEEP GRADES 3 - 8
replace drop = 1 if grade < 3 | grade >= 8

*(B) FE - BY STARTUP OR CONVERSION - NO SWITCH CONTROLS
local i 4
local j 1
foreach var of varlist `vdepvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase'   if drop == 0, robust cluster(schoolid) nonest fe
  local k 4
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}



*KEEP GRADES 4 - 8
replace drop = 1 if grade < 4 | grade >= 8

*(B) FE - BY STARTUP OR CONVERSION - NO SWITCH CONTROLS
local i 6
local j 1
foreach var of varlist `vdepvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase'   if drop == 0, robust cluster(schoolid) nonest fe
  local k 4
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_nogrades1and2_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}




postclose charter_nogrades1and2_levels
use /work/s/simberman/lusd/postfiles/charter_nogrades1and2_levels.dta, clear
sort stage indepvarid regid depvarid statname
outsheet using /work/s/simberman/lusd/postfiles/charter_nogrades1and2_levels.dat, replace


f



