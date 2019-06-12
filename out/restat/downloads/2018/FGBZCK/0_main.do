* ==============================================================================
* Date: February 2018
* 
* Master do-file to replicate 
* Sule Alan, Seda Ertac, Ipek Mumcu
* Gender Stereotypes in the classroom and effects on achievement
* 
* Data file: gstyping.dta
* Variable List:
*                                           
* Teacher variables: 
* teachername Wtgender hightbias gms extrinsic constructive
* warmth tmale ts_1 ts_2 ts_3 ts_4 ts_5 ts_6 qual ts_gender_2
* tt_train educ1 educ2 educ3 qual1 qual2 qual3 qual4 qual5 termbiasl
* 
* Student variables: 
* grade male ses highses lowses medses zstud_gender zgms_stud
* age_m_mean working_mom computer hhgender raven_std math_std
* turkish_std term_t tss_behavior conf tss_grade_math 
* tss_grade_tr pterm lterm
* 
* School control:
* proximity
*
* ==============================================================================

clear
capture log close
set more off

local path "~/Dropbox/genderbias/paper/REStats/R2/files to be submitted/Data"
cd "`path'"

use gstyping.dta

run 1_measures.do
run 2_tables.do
run 3_figures.do


