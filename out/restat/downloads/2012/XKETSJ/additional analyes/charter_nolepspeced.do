

*CHARTER IMPACT REGRESSIONS

*CONSIDERS INTERACTIONS OF CHARTER INDICATORS WITH STUDENT CHARACTERISTICS
  
clear
set mem 8000m
set matsize 2000
set more off



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


*GENERATE VALUE ADDED MEASURES
  foreach var of varlist stanford_math_sd stanford_read_sd stanford_lang_sd infrac perc_attn {
	gen d`var' = d.`var'
 }


replace infrac = . if year == 1993
replace perc_attn = . if year == 1993

*DROP LEP, SPECED
drop if lep == 1 | speced == 1


# delimit ;

xi  i.grade*i.year i.grade*structural i.grade*nonstructural i.grade*outofdist;
compress;




local i 2 ;
local chartvars "startup_unzoned convert_zoned";

*LEVELS;
foreach var of varlist `ldepvarlist' {;
  xtreg `var' `chartvars' `febase' , robust cluster(schoolid) nonest fe;
};


*VA;
foreach var of varlist `vdepvarlist' {;
  xtreg `var' `chartvars' `febase' , robust cluster(schoolid) nonest fe;
};

