//SET DIRECTORY AND OPEN 2012 SURVEY
cd "SET TO TABLES FOLDER AS DESCRIBED IN README.TXT"
cd "C:\Users\ddoherty\Dropbox\My Work Documents\Tunisia Participation\JOP FINAL FILES\replication archive\tables"

use "..\2012_survey.dta", clear

**Relative Deprivation Interactions/Variables
foreach i in income_ln income_mis employed emp_student emp_outofforce{
gen educX`i'=educ*`i'
}
label var educXincome_ln "Income x Education"
label var educXincome_mis "Income (missing) x Education"
label var educXemployed "Employed x Education"
label var educXemp_student "Student x Education"
label var educXemp_outofforce "Retired/Housewife x Education"


***REGRESSION ANALYSIS 
***APPENDIX TABLE A2
logit demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural gov_* [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural using "core_models", se bracket tdec(3) replace label ctitle(2012 Survey)
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural using "core_models", se not bracket tdec(3) append label ctitle(2012 Survey) eform
logit demonstrate_pre commit_dem educXincome_ln educXincome_mis income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural gov_* [pw=weight], cluster(district)
outreg commit_dem educXincome_ln educXincome_mis income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural using "core_models", se bracket tdec(3) append label
logit demonstrate_pre commit_dem educXemployed educXemp_student educXemp_outofforce income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural gov_* [pw=weight], cluster(district)
outreg commit_dem educXemployed educXemp_student educXemp_outofforce income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural using "core_models", se bracket tdec(3) append label


***APPENDIX TABLE A4
foreach i in income_ln income_mis educ elite_def_dem{
gen `i'Xcommit_dem=commit_dem*`i'
local label : variable label `i'
label var `i'Xcommit_dem "Prefer Democracy x `label'"
}

foreach i in income_ln income_mis educ elite_def_dem{
logit demonstrate_pre commit_dem `i' `i'Xcommit_dem  [pw=weight], cluster(district)
}

logit demonstrate_pre commit_dem income_ln income_mis income_lnXcommit_dem income_misXcommit_dem gov_*  [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis income_lnXcommit_dem income_misXcommit_dem  using "democracy_interactions", se bracket tdec(3) replace label ctitle(Elite Definition of Democracy: Bivariate)
logit demonstrate_pre commit_dem income_ln income_mis income_lnXcommit_dem income_misXcommit_dem educ age male employed emp_outofforce emp_student indiv_relig rural gov_*  [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis income_lnXcommit_dem income_misXcommit_dem educ age male employed emp_outofforce emp_student indiv_relig rural using "democracy_interactions", se bracket tdec(3) append label ctitle(Elite Definition of Democracy: Bivariate)

logit demonstrate_pre commit_dem educ educXcommit_dem gov_*  [pw=weight], cluster(district)
outreg commit_dem educ educXcommit_dem using "democracy_interactions", se bracket tdec(3) append label ctitle(Elite Definition of Democracy: Bivariate)
logit demonstrate_pre commit_dem income_ln income_mis educ educXcommit_dem age male employed emp_outofforce emp_student indiv_relig rural gov_*  [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis educ educXcommit_dem age male employed emp_outofforce emp_student indiv_relig rural using "democracy_interactions", se bracket tdec(3) append label ctitle(Elite Definition of Democracy: Bivariate)

logit demonstrate_pre commit_dem elite_def_dem elite_def_demXcommit_dem gov_*  [pw=weight], cluster(district)
outreg commit_dem elite_def_dem elite_def_demXcommit_dem using "democracy_interactions", se bracket tdec(3) append label ctitle(Elite Definition of Democracy: Bivariate)
logit demonstrate_pre commit_dem income_ln income_mis educ age male employed elite_def_dem elite_def_demXcommit_dem emp_outofforce emp_student indiv_relig rural gov_*  [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis educ age male employed elite_def_dem elite_def_demXcommit_dem emp_outofforce emp_student indiv_relig rural using "democracy_interactions", se bracket tdec(3) append label ctitle(Elite Definition of Democracy: Bivariate)


***TABLE 2
qui logit demonstrate_pre map_demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig polinterest rural gov_* [pw=weight], cluster(district)
outreg map_demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig polinterest rural using "social_factors", se bracket tdec(3) replace label

qui logit demonstrate_pre map_demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest rural gov_* [pw=weight], cluster(district)
outreg map_demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest rural using "social_factors", se bracket tdec(3) append label

qui logit demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest map_demonstrate_pre map_voted map_demonstrate_post map_employed map_emp_outofforce map_emp_student map_income_ln map_income_mis map_educ map_male map_age map_polinterest map_indiv_relig map_coll_relig rural gov_* [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis educ age male employed emp_student emp_outofforce indiv_relig coll_relig polinterest map_demonstrate_pre map_voted map_demonstrate_post rural using "social_factors", se bracket tdec(3) append label
//(Output coefficients on all district level measures; APPENDIX TABLE A6)
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest map_demonstrate_pre map_voted map_demonstrate_post map_employed map_emp_outofforce map_emp_student map_income_ln map_income_mis map_educ map_male map_age map_polinterest map_indiv_relig map_coll_relig rural using "social_factors_full", se bracket tdec(3) replace label

qui logit demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest demonstrate_pre_was_* voted_was_* demonstrate_post_was_* map_demonstrate_pre map_voted map_demonstrate_post map_employed map_emp_outofforce map_emp_student map_income_ln map_income_mis map_educ map_male map_age map_polinterest map_indiv_relig map_coll_relig rural gov_* [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest map_demonstrate_pre map_voted map_demonstrate_post demonstrate_pre_was_* voted_was_* demonstrate_post_was_*  rural using "social_factors", se bracket tdec(3) append label
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest map_demonstrate_pre map_voted map_demonstrate_post demonstrate_pre_was_* voted_was_* demonstrate_post_was_*  rural using "social_factors", se bracket tdec(3) append label eform
//(Output coefficients on all district level measures; APPENDIX TABLE A6)
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest demonstrate_pre_was_* voted_was_* demonstrate_post_was_* map_demonstrate_pre map_voted map_demonstrate_post map_employed map_emp_outofforce map_emp_student map_income_ln map_income_mis map_educ map_male map_age map_polinterest map_indiv_relig map_coll_relig rural using "social_factors_full", se bracket tdec(3) append label


** MFX for FIGURE 1B
set seed 1023
qui estsimp logit demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest demonstrate_pre_was_* voted_was_* demonstrate_post_was_* map_demonstrate_pre map_voted map_demonstrate_post map_employed map_emp_outofforce map_emp_student map_income_ln map_income_mis map_educ map_male map_age map_polinterest map_indiv_relig map_coll_relig rural gov_* [aw=weight], cluster(district)
setx mean
foreach r in commit_dem income_ln educ age male employed  polinterest rural map_demonstrate_pre demonstrate_pre_was_{
qui sum `r' [aw=weight]
if "`r'"=="income_ln"{
qui sum `r' if income_mis==0 [aw=weight]
}
local lb=r(mean)-r(sd)
local ub=r(mean)+r(sd)
if "`r'"=="commit_dem" |"`r'"=="demonstrate_pre_was_"  |"`r'"=="male" | "`r'"=="employed" |"`r'"=="rural" {
simqi, fd(prval(1)) changex(`r' 0 1)
}
else{
simqi, fd(prval(1)) changex(`r' `lb' `ub')
}
}
qui sum map_demonstrate_pre [aw=weight]
setx map_demonstrate_pre (r(mean)-r(sd))
simqi
qui sum map_demonstrate_pre [aw=weight]
setx map_demonstrate_pre (r(mean)+r(sd))
simqi


drop b1-b36


***APPENDIX TABLE A5
*Religion inconsistency question
qui logit demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural indiv_relig gov_* [pw=weight], cluster(district) 
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural indiv_relig using "religion", se bracket tdec(3) replace label 
qui logit demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural quran pray relig gov_* [pw=weight], cluster(district) 
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural quran pray relig using "religion", se bracket tdec(3) append label
qui logit demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural quran gov_* [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural quran using "religion", se bracket tdec(3) append label 
qui logit demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural pray gov_* [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural pray using "religion", se bracket tdec(3) append label 
qui logit demonstrate_pre commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural relig gov_* [pw=weight], cluster(district)
outreg commit_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural relig using "religion", se bracket tdec(3) append label

include "..\ab_replication.do"

