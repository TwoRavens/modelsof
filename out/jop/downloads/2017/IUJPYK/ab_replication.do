***OPEN ARAB BAROMETER DATA (ALSO AVAILABLE AT: http://www.arabbarometer.org/instruments-and-data-files)
use "..\adbii_merged_data_file_english_final_0.dta", clear
//Keep only Tunisian Respondents
keep if country==21 

//Protest participation measure
recode t902 (1=1) (2=0) (*=.), gen(protest)
label var protest "Participated in Revolutionary Protests (1=yes)"

//Demographics Recoding
gen age=q1001
label var age "Age (in years)"
recode t1003 (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (*=.), gen(educ)

recode q1002 q1004 q301 (1=1) (2=0) (*=.), gen(male employed voted)
recode q13 (1=0) (2=1) (*=.), gen(rural)
label var rural "Rural (1=yes)"

label var employed "Employed (1=yes)"

label var male "Male (1=yes)"
tab q1005, gen(Dwhynemp)
rename Dwhynemp1 emp_retired
rename Dwhynemp2 emp_housewife
rename Dwhynemp3 emp_student
replace emp_student=emp_student+Dwhynemp5
gen emp_outofforce=emp_retired+emp_housewife
foreach i in outofforce student{
replace emp_`i'=0 if emp_`i'!=1
}
label var emp_outofforce "Retired/Housewife (1=yes)"
label var emp_student "Student (1=yes)"

recode q404 (1=3) (2=2) (3=1) (4 8=0) (*=.), gen(polinterest)
label var polinterest "Interest in Politics (0-3)"
gen VERYpolinterest=polinterest==3
label var VERYpolinterest "Very Interested in Politics (1=yes)"


gen income =q1015
gen income_ln=ln(q1015)
gen income_mis=0
replace income_mis=1 if (q1015>9500000)
label var income_ln "Family Monthly Income (logged; missing=mean)"
label var income_mis "Family Income (missing)"
qui sum income_ln if income_mis==0 & country==21 [aw=wt]
replace income_ln=r(mean) if (q1015>9500000) 

label var educ "Education"
tab educ, gen(Dedu_)
gen EDnone=Dedu_1+Dedu_2
gen EDcoll=Dedu_6+Dedu_5
label var EDnone "Education: Preparatory/basic or less"
label var EDcoll "Education: 4-year College +"

**Relative Deprivation Interactions/Variables
foreach i in income_ln income_mis employed emp_student emp_outofforce{
gen educX`i'=educ*`i'
}
label var educXincome_ln "Income x Education"
label var educXincome_mis "Income (missing) x Education"
label var educXemployed "Employed x Education"
label var educXemp_student "Student x Education"
label var educXemp_outofforce "Retired/Housewife x Education"

****Religiosity
recode q609 (1=3) (2=2) (3=1) (*=.),gen(relig)
recode t6101 t6105 t6106 (1=5) (2=4) (3=3) (4=2) (5=1) (*=.), gen(pray coll_relig quran)
label var coll_relig "Frequency of Mosque Attendance"

alpha quran relig pray, std gen(indiv_relig)
label var indiv_relig "Individual Religiosity (M=0; SD=1)"
label var pray "Frequency of Prayer"
label var quran "Frequency of Reading Quran"
label var relig "Self-described Religiosity"

//GOVERNORATE INDICATORS
tab q1, gen(govT_)
label var govT_19 "Gafsa (1=yes)"
label var govT_12 "Kairouan (1=yes)"
label var govT_13 "Kasserine (1=yes)"
label var govT_18 "Sfax (1=yes)"
label var govT_14 "Sidi Bouzid (1=yes)"
label var govT_15 "Sousse (1=yes)"
//Indicator for governorates surveyed in 2012 Survey
recode q1 (8018 8019 8020 8021 8024 8025=1) (*=0),gen(samp_gov)

**social FORCES
recode t905 (1=1) (*=0), gen(friends_part)
label var friends_part "Any friends/acquaintances protest? (1=yes)"

**Civil org?
recode q5012 q5013 q5014 q5016 (1=1) (*=0), gen(civil_char civil_trade civil_youth civil_local)
egen civil_any=rowmax(civil_char civil_trade civil_youth civil_local)
label var civil_any "Member of Civil Society Org.? (1=yes)"

*support for democracy
recode q5162 q5167 (1=0) (2=1) (3=3) (4=4) (*=2), gen(dem_supp2 dem_supp7)
recode q5164 (1=4) (2=3) (3=1) (4=0) (*=2), gen(dem_supp4)
egen hoffman_dem=rmean(dem_supp2 dem_supp4 dem_supp7)
label var hoffman_dem "Commitment to Democracy (mean index, 0-4)"

recode q5151 (1 2 5 2001 2004 10003=1) (*=0), gen(elite_def_dem)
label var elite_def_dem "Elite Definition of Democracy (1=yes)"


***SET SAMPLE
gen insample=0
logit protest income_ln income_mis educ employed emp_student age male indiv_relig coll_relig polinterest civil_any rural hoffman_dem govT_* [pw=wt], r
keep if e(sample)

*religiosity index (restandardized within restricted sample)
drop indiv_relig
alpha quran relig pray, std gen(indiv_relig)
qui sum indiv_relig [aw=wt]
replace indiv_relig=(indiv_relig-r(mean))/r(sd)
label var indiv_relig "Religiosity (M=0; SD=1)"

***SUMMARY STATS (APPENDIX TABLE A1)
outsum protest income_mis employed emp_outofforce emp_student EDnone EDcoll age male coll_relig polinterest rural VERYpolinterest govT_19 govT_12 govT_13 govT_18 govT_14 govT_15 if country==21 [aw=wt] using "sum_stats", append bracket
outsum income_ln  if income_mis!=1 [aw=wt] using "sum_stats_inc", append bracket

outsum protest income_mis employed emp_outofforce emp_student EDnone EDcoll age male coll_relig polinterest rural VERYpolinterest govT_19 govT_12 govT_13 govT_18 govT_14 govT_15 if samp_gov==1 [aw=wt] using "sum_stats", append bracket
outsum income_ln  if income_mis!=1 & samp_gov [aw=wt] using "sum_stats_inc", append bracket



***APPENDIX TABLE A2
logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural govT_* [pw=wt], r
outreg hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural using "core_models", se bracket tdec(3) append label ctitle(Arab Barometer)
outreg hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural using "core_models", se bracket tdec(3) append label ctitle(Arab Barometer) eform
logit protest hoffman_dem educXincome_ln educXincome_mis income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural govT_* [pw=wt], r
outreg hoffman_dem educXincome_ln educXincome_mis income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural using "core_models", se bracket tdec(3) append label
logit protest hoffman_dem educXemployed educXemp_student educXemp_outofforce income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural govT_* [pw=wt], r
outreg hoffman_dem educXemployed educXemp_student educXemp_outofforce income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural using "core_models", se bracket tdec(3) append label


***APPENDIX TABLE A3
*DEMOCRACY interactions
foreach i in income_ln income_mis educ elite_def_dem{
gen `i'Xhoffman_dem=hoffman_dem*`i'
local label : variable label `i'
label var `i'Xhoffman_dem "Commitment to Democracy x `label'"
}

foreach d in hoffman_dem {
logit protest `d' income_ln income_mis income_lnX`d' income_misX`d'  govT_* [pw=wt], r
outreg `d' income_ln income_mis income_lnX`d' income_misX`d' using "democracy_interactions_`d'", se bracket tdec(3) replace label 
logit protest `d' income_ln income_mis income_lnX`d' income_misX`d' educ age male employed emp_outofforce emp_student indiv_relig rural govT_* [pw=wt], r
outreg `d' income_ln income_mis income_lnX`d' income_misX`d' educ age male employed emp_outofforce emp_student indiv_relig rural  using "democracy_interactions_`d'", se bracket tdec(3) append label 

logit protest `d' educ educX`d'  govT_* [pw=wt], r
outreg `d' educ educX`d' using "democracy_interactions_`d'", se bracket tdec(3) append label 
logit protest `d' income_ln income_mis educ educX`d' age male employed emp_outofforce emp_student indiv_relig rural govT_* [pw=wt], r
outreg `d' income_ln income_mis educ educX`d' age male employed emp_outofforce emp_student indiv_relig rural using "democracy_interactions_`d'", se bracket tdec(3) append label 

logit protest `d' elite_def_dem elite_def_demX`d'  govT_* [pw=wt], r
outreg `d' elite_def_dem elite_def_demX`d' using "democracy_interactions_`d'", se bracket tdec(3) append label 
logit protest `d' income_ln income_mis educ age male employed elite_def_dem elite_def_demX`d' emp_outofforce emp_student indiv_relig rural govT_* [pw=wt], r
outreg `d' income_ln income_mis educ age male employed elite_def_dem elite_def_demX`d' emp_outofforce emp_student indiv_relig rural using "democracy_interactions_`d'", se bracket tdec(3) append label 
}

***TABLE 1
tab friends_part [aw=wt]
tab protest friends_part [aw=wt], col
logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural polinterest friends_part govT_* [pw=wt], r
outreg hoffman_dem friends_part income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig polinterest rural using "social_factors_ab", se bracket tdec(3) replace label ctitle(Arab Barometer)
logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig rural polinterest friends_part civil_any govT_* [pw=wt], r
outreg hoffman_dem friends_part income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest rural civil_any  using "social_factors_ab", se bracket tdec(3) append label ctitle(Arab Barometer)
outreg hoffman_dem friends_part income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig polinterest rural civil_any  using "social_factors_ab", se bracket tdec(3) append label ctitle(Arab Barometer) eform

** MFX for FIGURE 1A
set seed 1023
qui estsimp logit protest friends_part govT_1-govT_22 [aw=wt], r
setx mean 
simqi, fd(prval(1)) changex(friends_part 0 1)
drop b1-b24

qui estsimp logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig rural polinterest friends_part govT_1-govT_22 [aw=wt], r
setx mean 
simqi, fd(prval(1)) changex(friends_part 0 1)
drop b1-b36

qui estsimp logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student indiv_relig coll_relig rural polinterest friends_part civil_any govT_1-govT_22 [aw=wt], r
setx mean 
foreach r in hoffman_dem income_ln educ age male employed polinterest rural friends_part {
qui sum `r' [aw=wt]
if "`r'"=="income_ln"{
qui sum `r' if income_mis==0 [aw=wt]
}
local lb=r(mean)-r(sd)
local ub=r(mean)+r(sd)
if "`r'"=="friends_part"  |"`r'"=="male" | "`r'"=="employed" |"`r'"=="rural"{
simqi, fd(prval(1)) changex(`r' 0 1)
}
else{
simqi, fd(prval(1)) changex(`r' `lb' `ub')
}
}
drop b1-b38


***APPENDIX TABLE A5
*Religion inconsistency question
qui logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural indiv_relig govT_* [pw=wt], r
outreg hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural indiv_relig using "religion", se bracket tdec(3) append label 
qui logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural quran pray relig govT_* [pw=wt], r
outreg hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural quran pray relig using "religion", se bracket tdec(3) append label 
qui logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural quran govT_* [pw=wt], r
outreg hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural quran using "religion", se bracket tdec(3) append label 
qui logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural pray govT_* [pw=wt], r
outreg hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural pray using "religion", se bracket tdec(3) append label 
qui logit protest hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural relig govT_* [pw=wt], r
outreg hoffman_dem income_ln income_mis educ age male employed emp_outofforce emp_student rural relig using "religion", se bracket tdec(3) append label 



