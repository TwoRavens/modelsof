

*CHARTER IMPACT REGRESSIONS

*RUNS REGRESSIONS FOR SAMPLE THAT DROPS ANY STUDENT WHO IS EVER EXPELLED OR REFERRED TO DAEP, JJAEP

  
clear
set mem 8000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_noaep int(regid va depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /home/s/simberman/lusd/postfiles/charter_noaep.dta, replace;
  # delimit cr


*SET LOCAL MACROS HERE
  
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant i.grade*i.year i.grade*structural i.grade*nonstructural i.grade*outofdist"

  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


*DEPENDENT VARIABLES USED
local ldepvarlist "stanford_math_sd stanford_read_sd stanford_lang_sd infractions perc_attn"
local vdepvarlist "dstanford_math_sd dstanford_read_sd dstanford_lang_sd dinfractions dperc_attn"

use /home/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 2, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year

*LIMIT TO 1997 & LATER
keep if year >= 1997

*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1

*GENERATE AND SET FOR DROP ANY STUDENT WHO EVER GETS AEP OR EXPULSION
egen anyexpul = max(expulsion), by(id)
egen anyaep = max(aep), by(id)
gen drop = anyexpul == 1 | anyaep == 1

# delimit ;

*ALL STUDENTS;
local i 1;

*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' startup_unzoned convert_zoned `febase' , robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  startup_unzoned convert_zoned {;
	  post charter_noaep (`i') (`va') (`j') (`k')  ("full sample")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_noaep (`i') (`va') (`j') (`k') ("full sample") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
 xi: xtreg `var' startup_unzoned convert_zoned `febase' , robust cluster(schoolid) nonest fe;
  local k 1;
  foreach indepvar of varlist   startup_unzoned convert-zoned {;
	  post charter_noaep (`i') (`va') (`j') (`k')  ("full sample")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_noaep (`i') (`va') (`j') (`k') ("full sample") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};



*NO AEP, EXPUL;
local i 2;

*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' startup_unzoned convert_zoned `febase' if drop == 0, robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  startup_unzoned convert_zoned {;
	  post charter_noaep (`i') (`va') (`j') (`k')  ("full sample")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_noaep (`i') (`va') (`j') (`k') ("full sample") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


*VA;
local va 1;
local j 1 ;
foreach var of varlist `vdepvarlist' {;
 xi: xtreg `var' startup_unzoned convert_zoned `febase' if drop == 0, robust cluster(schoolid) nonest fe;
  local k 1;
  foreach indepvar of varlist startup_unzoned convert-zoned {;
	  post charter_noaep (`i') (`va') (`j') (`k')  ("full sample")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_noaep (`i') (`va') (`j') (`k') ("full sample") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};



postclose charter_noaep
use /home/s/simberman/lusd/postfiles/charter_noaep.dta, clear
sort  va regid depvarid indepvarid  statname
outsheet using /home/s/simberman/lusd/postfiles/charter_noaep.dat, replace


