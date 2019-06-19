

*CHARTER IMPACT REGRESSIONS

*CONSIDERS ADDITIONAL OUTCOMES NOT LOOKED AT IN MAIN ANALYSIS
  
clear
set mem 4000m
set matsize 2000
set more off


  # delimit ;
  postfile charter_additional int(regid va depvarid indepvarid) str40 (regtype depvar indepvar statname) float (stat tstat obs) 
	using /work/s/simberman/lusd/postfiles/charter_additional.dta, replace;
  # delimit cr


*SET LOCAL MACROS HERE
  
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant i.grade*i.year i.grade*structural i.grade*nonstructural i.grade*outofdist"

  *COUNTER
  local i 1

  *STAGE FOR 2SLS REGRESSIONS
  local stage 0


*DEPENDENT VARIABLES USED
local ldepvarlist "retention anyinf expulsion aep lep atrisk"


use /work/s/simberman/lusd/charter1/lusd_data_b.dta, clear
set seed 1001

*FOR TESTING REGRESSIONS ON A SMALLER SAMPLE
*gsample 2, wor percent cluster(id)

*MAKE DATASET PANEL
xtset (id) year


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1

*LIMIT TO BASE SAMPLE
keep if infrac != . & perc_attn != .

*GENERATE OTHER OUTCOMES


        *RETENTION
	gen retention = l.grade <= grade
	replace retention = . if l.grade == .

	*ANY INFRACTION
	gen anyinf = infrac >= 1
	replace anyinf = . if infrac == .

	*MAKE EXPULSION 0/1 & LIMIT TO 1997 & LATER
	replace expulsion = expulsion > 0 if expulsion != .
	replace expulsion = . if year < 1997

	*MAKE AEP 0/1 & LIMIT TO 1997 & LATER
	replace aep = aep > 0 if aep != .
	replace aep = . if year < 1997

	*GENERATE VALUE ADDED MEASURES
  	foreach var of varlist retention anyinf expulsion aep lep atrisk {
		gen d`var' = d.`var'
	}


***NOTE - SINCE THESE ARE ALL LIMITED DEPENDENT VARIABLES, A VALUE ADDED SPECIFICATION IS INAPPROPRIATE, SO ONLY DO LEVELS***

drop if year == 1993



# delimit ;

***(1)****;
local i 1 ;


*LEVELS;
local va 0;
local j 1 ;
foreach var of varlist `ldepvarlist' {;
 local k 1;
 xi: xtreg `var' convert_zoned startup_unzoned `febase' 
	, robust cluster(schoolid) nonest fe;
  foreach indepvar of varlist  convert_zoned  startup_unzoned {;
	  post charter_additional (`i') (`va') (`j') (`k')  ("pre_chart_infrac")  ("`var'") 
		("`indepvar'") ("coef") (_b[`indepvar']) (_b[`indepvar']/_se[`indepvar']) (e(N));
	  post charter_additional (`i') (`va') (`j') (`k') ("pre_chart_infrac") ("`var'") 
		("`indepvar'") ("se") (_se[`indepvar']) (.) (e(N));
  local k = `k' + 1;
  };
 local j = `j' + 1;
};


# delimit cr

postclose charter_additional
use /work/s/simberman/lusd/postfiles/charter_additional.dta, clear
sort  va regid depvarid indepvarid  statname
outsheet using /work/s/simberman/lusd/postfiles/charter_additional.dat, replace

