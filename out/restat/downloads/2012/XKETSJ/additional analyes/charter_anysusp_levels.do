


*CHARTER IMPACT REGRESSIONS

* RUNS REGRESSIONS LIMITING TO STUDENTS WHO EVER HAVE A DISCIPLINARY INFRACTION
* NOTE THAT THIS IS ONLY A CHECK ON HOW MISBEHAVING STUDENTS MAY HAVE TEST SCORE IMPROEVEMENTS TO COINCIDE WITH DISCIPLINE
* SINCE THERE IS SELECTION ON THE DEPENDENT VARIABLE HERE, ESTIMATES NEED TO BE INTERPRETED WITH EXTREME CAUTION

  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_anysusp_levels int(regid stage depvarid indepvarid) str12 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /home/s/simberman/lusd/postfiles/charter_anysusp_levels.dta, replace;
  # delimit cr


*LEVELS MODELS

*SET LOCAL MACROS HERE
  
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*"

  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


*TEST SAMPLE


*DEPENDENT VARIABLES USED
local depvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd"


use /home/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year

*IDENTIFY STUDENTS WHO HAVE A DISCIPLINARY INFRACTION AT ANY TIME IN ACADEMIC CAREER
egen anyinfrac = max(infrac), by(id)

*LIMIT TO TEST SAMPLE
keep if year >= 1998
keep if stanford_math_sd != . & stanford_read_sd != . & stanford_lang_sd != .

tab year, gen(year_)
drop *_11 *_12


*(B) FE - BY STARTUP OR CONVERSION - BAD STUDENTS
local i 1
local j 1
foreach var of varlist `depvarlist' {
 xtreg `var' convert_zoned startup_unzoned `febase'  structural* nonstructural* outofdist* if anyinfrac == 1, robust cluster(schoolid) nonest fe
  local k 4
  post charter_anysusp_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}


*(B) FE - BY STARTUP OR CONVERSION - GOOD STUDENTS
local i 2
local j 1
foreach var of varlist `depvarlist' {
 xtreg `var' convert_zoned startup_unzoned `febase'  structural* nonstructural* outofdist* if anyinfrac == 0, robust cluster(schoolid) nonest fe
  local k 4
  post charter_anysusp_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}


*BASE SAMPLE


*DEPENDENT VARIABLES USED
local depvarlist "infrac perc_attn"



use /home/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 5, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year

*IDENTIFY STUDENTS WHO HAVE A DISCIPLINARY INFRACTION AT ANY TIME IN ACADEMIC CAREER
egen anyinfrac = max(infrac), by(id)

*LIMIT TO TEST SAMPLE
keep if year >= 1994
keep if infrac != . & perc_attn != .

tab year, gen(year_)
drop *_12

*(B) FE - BY STARTUP OR CONVERSION - BAD STUDENTS
local i 1
local j 3
foreach var of varlist `depvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase'  structural* nonstructural* outofdist* if anyinfrac == 1, robust cluster(schoolid) nonest fe 
  local k 4
  post charter_anysusp_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}



*(B) FE - BY STARTUP OR CONVERSION - GOOD STUDENTS (ATTENDANCE ONLY)
local i 2
local j 4
foreach var of varlist perc_attn {
  xtreg `var' convert_zoned startup_unzoned `febase'  structural* nonstructural* outofdist* if anyinfrac == 0, robust cluster(schoolid) nonest fe 
  local k 4
  post charter_anysusp_levels (`i') (`stage') (`j') (`k')  ("fe")  ("`var'") ("convert_zoned") ("coef") (_b[convert_zoned]) (_b[convert_zoned]/_se[convert_zoned]) (e(N))
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("convert_zoned") ("se") (_se[convert_zoned]) (.) (e(N))
  local k 5
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_anysusp_levels (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
 local j = `j' + 1
}

postclose charter_anysusp_levels
use /home/s/simberman/lusd/postfiles/charter_anysusp_levels.dta, clear
sort stage indepvarid regid depvarid statname
outsheet using /home/s/simberman/lusd/postfiles/charter_anysusp_levels.dat, replace

