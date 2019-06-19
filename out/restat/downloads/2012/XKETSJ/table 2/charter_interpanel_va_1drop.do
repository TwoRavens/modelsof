

*CHARTER IMPACT REGRESSIONS


*THIS FILE IS THE BASIC PROGRAM FOR RUNNING CHARTER SCHOOL REGRESSIONS AND IS MODIFIABLE IN A NUMBER OF WAYS

  
clear
set mem 4000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_interpanel_va_1drop int(regid stage depvarid indepvarid) str12 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_interpanel_va_1drop.dta, replace;
  # delimit cr


*VA MODELS

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

*COMPRESS DATASET
compress

*GENERATE VALUE-ADDED MEASURES
foreach var of varlist stanford_math_sd stanford_read_sd stanford_lang_sd {
  gen d`var' = d.`var'
}


*REMOVE COMMENTS FROM THE FOLLOWING TO UTILIZE INTERRUPTED PANEL ESTIMATES
  gen drop = 0
  
  *DROP PERIOD PRIOR TO CHARTER ENTRY 
  replace drop = 1 if (f1.charter == 1) & charter == 0 
  
  *DROP 2 PERIODS PRIOR TO CHARTER ENTRY 
  *replace drop = 1 if (f2.charter == 1) & charter == 0 

  *DROP PERIOD ONE YEAR PRIOR TO CHARTER ENTRY OR NON-STRUCTURAL SWITCH 
  *replace drop = 1 if (f1.nonstructural == 1 | f1.charter == 1) & charter == 0
 
  *DROP PERIOD TWO YEARS PRIOR TO CHARTER ENTRY OR NON-STRUCTURAL SWITCH 
  *replace drop = 1 if (f2.nonstructural == 1 | f2.charter == 1) & charter == 0

  *DROP PERIOD PRIOR TO CHARTER EXIT
  *replace drop = 1 if  (charter == 1 & l.charter == 0) 

  *DROP PERIOD PRIOR TO CHARTER EXIT OR NON-STRUCTURAL SWITCH
  *replace drop = 1 if (charter == 1 & f.charter == 0) | (f.nonstructural == 1 & charter == 0)

  *DROP PERIOD AFTER CHARTER EXIT OR NONSTRUCTURAL SWITCH
  *replace drop = 1 if (charter == 0 & l.charter == 1) | nonstructural == 1



  *CHANGE DEP VAR TO VALUE ADDED OVER 2 YEARS DIVIDED BY 2 IF DROPPING 1 YEAR PRIOR TO CHARTER
  *CHANGE TO VALUE ADDED OVER 3 YEARS DIVIDED BY 3 IF DROPPING 2 YEARS PRIOR TO CHARTER


	 /*
	  foreach var of varlist `depvarlist' {
		replace d`var' = (`var' - l2.`var')/2 if l.drop == 1
	  }
	 */

	 /*  
	  foreach var of varlist `depvarlist' {
		replace d`var' = (`var' - l3.`var')/3 if l.drop == 1
	  }
	  */



*LIMIT TO TESTING SAMPLE
keep if year >= 1999
keep if dstanford_math_sd != . & dstanford_read_sd != . & dstanford_lang_sd !=.



*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1

*GENERATE YEAR DUMMIES
tab year, gen(year_)



*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_*   structural* nonstructural*"

drop *_11 *_12

keep id year drop  `depvarlist'  convert* startup* `febase' schoolid 
compress

local i 1
local j 1
foreach var of varlist `depvarlist' {
  xtreg `var' convert_zoned startup_unzoned `febase'   if drop == 0, robust cluster(schoolid) nonest fe
  local k 1
  post charter_interpanel_va_1drop (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_interpanel_va_1drop (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))

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
foreach var of varlist perc_attn  infractions{
 gen d`var' = d.`var'
}


*GENERATE YEAR DUMMIES
tab year, gen(year_)


*COMPRESS DATASET
compress


*REMOVE COMMENTS FROM THE FOLLOWING TO UTILIZE INTERRUPTED PANEL ESTIMATES
  gen drop = 0
  
  *DROP PERIOD PRIOR TO CHARTER ENTRY 
  replace drop = 1 if (f1.charter == 1) & charter == 0 
  
  *DROP 2 PERIODS PRIOR TO CHARTER ENTRY 
  *replace drop = 1 if (f2.charter == 1) & charter == 0 

  *DROP PERIOD ONE YEAR PRIOR TO CHARTER ENTRY OR NON-STRUCTURAL SWITCH 
  *replace drop = 1 if (f1.nonstructural == 1 | f1.charter == 1) & charter == 0
 
  *DROP PERIOD TWO YEARS PRIOR TO CHARTER ENTRY OR NON-STRUCTURAL SWITCH 
  *replace drop = 1 if (f2.nonstructural == 1 | f2.charter == 1) & charter == 0

  *DROP PERIOD PRIOR TO CHARTER EXIT
  *replace drop = 1 if  (charter == 1 & l.charter == 0) 

  *DROP PERIOD PRIOR TO CHARTER EXIT OR NON-STRUCTURAL SWITCH
  *replace drop = 1 if (charter == 1 & f.charter == 0) | (f.nonstructural == 1 & charter == 0)

  *DROP PERIOD AFTER CHARTER EXIT OR NONSTRUCTURAL SWITCH
  *replace drop = 1 if (charter == 0 & l.charter == 1) | nonstructural == 1




  *CHANGE DEP VAR TO VALUE ADDED OVER 2 YEARS DIVIDED BY 2 IF DROPPING 1 YEAR PRIOR TO CHARTER
  *CHANGE TO VALUE ADDED OVER 3 YEARS DIVIDED BY 3 IF DROPPING 2 YEARS PRIOR TO CHARTER

	  /*
	  foreach var of varlist `depvarlist' {
		replace d`var' = (`var' - l2.`var')/2 if l.drop == 1
	  }
	  */
	  
	  /*
	  foreach var of varlist `depvarlist' {
		replace d`var' = (`var' - l3.`var')/3 if l.drop == 1 
	  }
	  */


*LIMIT TO BASE SAMPLE
keep if year >= 1994
keep if dinfractions != . & dperc_attn != .


*TIME VARIANT VARIABLES USED IN REGRESSIONS
local febase "freel redl othecon recent_immi migrant grade_* year_* gradeyear_* structural* nonstructural*"
drop *_12


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1

keep id year drop `depvarlist' convert* startup* `febase' schoolid 
compress

local i 1
local j 1
foreach var of varlist `depvarlist' {
  xtreg `var' convert_zoned startup_unzoned  `febase'   if drop == 0, robust cluster(schoolid) nonest fe
  local k 1
  post charter_interpanel_va_1drop (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("coef") (_b[startup_unzoned]) (_b[startup_unzoned]/_se[startup_unzoned]) (e(N))
  post charter_interpanel_va_1drop (`i') (`stage') (`j') (`k') ("fe") ("`var'") ("startup_unzoned") ("se") (_se[startup_unzoned]) (.) (e(N))
  local j = `j' + 1
}


postclose charter_interpanel_va_1drop
use /work/s/simberman/lusd/postfiles/charter_interpanel_va_1drop.dta, clear
sort stage indepvarid regid depvarid statname
outsheet using /work/s/simberman/lusd/postfiles/charter_interpanel_va_1drop.dat, replace


f


