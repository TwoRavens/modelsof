

*CHARTER IMPACT REGRESSIONS

*CONSIDERS VARIATION BY PRE-CHARTER CHARACTERISTICS
  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_prechart int(regid va depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_prechart.dta, replace;
  # delimit cr


*SET LOCAL MACROS HERE
  
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant _I*"

  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


*DEPENDENT VARIABLES USED
local ldepvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd infractions perc_attn"
local vdepvarlist "dstanford_math_sd dstanford_read_sd dstanford_lang_sd dinfractions dperc_attn"

use /work/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 2, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*IDENTIFY NUMBER OF  DISCIPLINARY INFRACTION IN YEAR PRIOR TO FIRST CHARTER ENTRY
	
	*IDENTIFY FIRST YEAR IN A CHARTER OF ANY TYPE
	egen temp = min(year) if charter == 1, by(id)
	egen minchartyear = min(temp), by(id)

	*CALCULATE THE NUMBER OF INFRACTIONS IN THE YEAR PRIOR TO CHARTER ENTRY
	gen temp2 = infrac if year == minchartyear -1
	egen prechart_infrac = min(temp2), by(id)

	*MAKE PRECHART_INFRAC = 0 IF STUDENT HAD NO INFRACTIONS, NEVER ATTENDED A CHARTER, OR WAS NOT IN SAMPLE YEAR PRIOR TO ENTRY
	replace prechart_infrac = 0 if prechart_infrac == .

	*GENERATE INDICATOR FOR STUDENT NOT BEING IN SAMPLE IN YEAR PRIOR TO CHARTER ENTRY
	gen temp3 = l.charter == . & year == minchartyear
	egen prechart_noobs = max(temp3), by(id)	

	*GENERATE INTERACTIONS OF PRE-CHART INFRACTIONS WITH CHARTER STATUS
	gen convert_prechart_infrac_0 = convert_zoned == 1 & prechart_infrac == 0
	gen startup_prechart_infrac_0 = startup_unzoned == 1 & prechart_infrac == 0

	gen convert_prechart_infrac_1 = convert_zoned == 1 & prechart_infrac > 0 & prechart_infrac != .
	gen startup_prechart_infrac_1 = startup_unzoned == 1 & prechart_infrac > 0 & prechart_infrac != .

	gen convert_prechart_noobs = convert_zoned*prechart_noobs
	gen startup_prechart_noobs = startup_unzoned*prechart_noobs

	*GENERATE INTERACTIONS OF PRE-CHART AVG OF MATH, READ, LANG STANDARDIZED TEST SCORES
	gen stanford_avg = (stanford_math_sd + stanford_read_sd + stanford_lang_sd)/3
	gen temp4 = stanford_avg if year == minchartyear - 1
	egen prechart_stanford_avg = min(temp4), by(id)


	gen prechart_stanford_below = prechart_stanford_avg < -.5 & prechart_stanford_avg != .
	gen prechart_stanford_mid = prechart_stanford_avg >= -.5 & prechart_stanford_avg < .5
	gen prechart_stanford_above = prechart_stanford_avg >= .5 & prechart_stanford_avg != .
	gen prechart_notest = temp4 == .
	
	gen convert_below = convert_zoned*prechart_stanford_below
	gen convert_mid = convert_zoned*prechart_stanford_mid
	gen convert_above = convert_zoned*prechart_stanford_above
	gen convert_notest = convert_zoned*prechart_notest

	gen startup_below = startup_unzoned*prechart_stanford_below
	gen startup_mid = startup_unzoned*prechart_stanford_mid
	gen startup_above = startup_unzoned*prechart_stanford_above
	gen startup_notest = startup_unzoned*prechart_notest

	tab year, gen(year_)

f


*GENERATE VALUE ADDED MEASURES
  foreach var of varlist stanford_math_sd stanford_read_sd stanford_lang_sd infrac perc_attn {
	gen d`var' = d.`var'
}


replace infrac = . if year == 1993
replace perc_attn = . if year == 1993


# delimit ;

xi  i.grade*i.year i.grade*structural i.grade*nonstructural i.grade*outofdist;
compress;


***(2)****;
***INTERACTION WITH PRE-CHARTER TEST SCORES****;
local i 2;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
  xtreg `var' startup_unzoned startup_mid startup_above startup_notest  convert_zoned  convert_mid convert_above convert_notest `febase' 
		, robust cluster(schoolid) nonest fe;

test startup_unzoned + startup_mid = 0;
test startup_unzoned + startup_above = 0;
test convert_unzoned + convert_mid = 0;
test convert_unzoned + convert_above = 0;

 foreach indepvar of varlist startup_unzoned  startup_mid startup_above startup_notest  convert_zoned  convert_mid convert_above convert_notest {;
	  post charter_prechart (`i') (`va') (`j') (`k')  ("pre_chart_infrac")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_prechart (`i') (`va') (`j') (`k') ("pre_chart_infrac") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local i 1 ;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
  xtreg `var'  startup_unzoned startup_mid startup_above startup_notest  convert_zoned  convert_mid convert_above convert_notest `febase'
	, robust cluster(schoolid) nonest fe;

  test startup_unzoned + startup_mid = 0;
  test startup_unzoned + startup_above = 0;
  test convert_unzoned + convert_mid = 0;
  test convert_unzoned + convert_above = 0;


  local k 1;
  foreach indepvar of varlist startup_unzoned  startup_mid startup_above startup_notest  convert_zoned  convert_mid convert_above convert_notest {;
	  post charter_prechart (`i') (`va') (`j') (`k')  ("pre_chart_infrac")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_prechart (`i') (`va') (`j') (`k') ("pre_chart_infrac") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
  local j = `j' + 1;
};


***(1)****;
***INTERACTION WITH PRE-CHARTER INFRACTIONS****;
local i 1 ;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
  xtreg `var' convert_zoned  convert_prechart_infrac_1 convert_prechart_noobs startup_unzoned 
	startup_prechart_infrac_1 startup_prechart_noobs `febase' , robust cluster(schoolid) nonest fe;

test startup_unzoned + startup_prechart_infrac_1 = 0;
test convert_zoned + convert_prechart_infrac_1 = 0;


  foreach indepvar of varlist  convert_zoned  convert_prechart_infrac_1 convert_prechart_noobs startup_unzoned 
	startup_prechart_infrac_1 startup_prechart_noobs {;
	  post charter_prechart (`i') (`va') (`j') (`k')  ("pre_chart_infrac")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_prechart (`i') (`va') (`j') (`k') ("pre_chart_infrac") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local i 1 ;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
  xtreg `var'  convert_zoned convert_prechart_infrac_1 convert_prechart_noobs startup_unzoned startup_prechart_infrac_1 startup_prechart_noobs `febase', robust cluster(schoolid) nonest fe;
  local k 1;


test startup_unzoned + startup_prechart_infrac_1 = 0;
test convert_zoned + convert_prechart_infrac_1 = 0;


  foreach indepvar of varlist   convert_zoned  convert_prechart_infrac_1 convert_prechart_noobs 
				startup_unzoned  startup_prechart_infrac_1 startup_prechart_noobs{;

	  post charter_prechart (`i') (`va') (`j') (`k')  ("pre_chart_infrac")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_prechart (`i') (`va') (`j') (`k') ("pre_chart_infrac") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};




# delimit cr


postclose charter_prechart
use /work/s/simberman/lusd/postfiles/charter_prechart.dta, clear
sort  va regid depvarid indepvarid  statname
outsheet using /work/s/simberman/lusd/postfiles/charter_prechart.dat, replace


