set more off

use recodeddata\data_for_analysis.dta

*Exclude those who didn't do 10 profiles
egen numobs=count(profilenumber), by(userid)
drop if numobs~=10
drop numobs

sort userid
count if userid~=userid[_n-1]

*Exclude people who don't report an ideology
drop if ideology==.
sort userid
count if userid~=userid[_n-1]

*Exclude people who didn't give a YOB
drop if preYearOfBirth==.
sort userid
count if userid~=userid[_n-1]

gen age = 2014-preYearOfBirth

sort userid
count if userid~=userid[_n-1]
tab age if userid~=userid[_n-1]

drop if age>35
sort userid
count if userid~=userid[_n-1]

egen scaledoutcome=rowmean(O_*)
label var scaledoutcome "Scale (Avg. all 6 measures)"

* Deal with missing data; Assign to mean value for respondent
foreach var of varlist O_* {
 gen im_`var' = `var'
 local templabel : var label `var'
 di "`templabel'"
 label var im_`var' "`templabel' No Miss"
 tab im_`var'
 bysort userid: egen temp=mean(`var')
 replace `var'=temp if `var'==.
 drop temp
 }

tab ideology
 
***********************************************************************************
* ANALYSIS
***********************************************************************************
// Set up treatment-respondent combinations for ideology

* Match on ideology

gen match_ideology=0
replace match_ideology=1 if ideology==0 & ideoid==1
replace match_ideology=1 if ideology==1 & ideoid==3
replace match_ideology=1 if ideology==2 & ideoid==2
label var match_ideology "Ideology matches"

gen match_ideo_alt1=0
replace match_ideo_alt1=1 if ideology==0 & ideoid==1
replace match_ideo_alt1=1 if ideology==1 & ideoid==3
replace match_ideo_alt1=1 if ideology==2 & ideoid==2
replace match_ideo_alt1=1 if ideoid==5
label var match_ideo_alt1 "Ideology matches alt. (No ideo.=match)"

gen match_ideo_alt2=0
replace match_ideo_alt2=1 if ideology==0 & ideoid==1
replace match_ideo_alt2=1 if ideology==1 & ideoid==3
replace match_ideo_alt2=1 if ideology==2 & ideoid==2
replace match_ideo_alt2=1 if ideoid==4 | ideoid==5
label var match_ideo_alt2 "Ideology matches alt. (No ideo. and Not int.=match)"

gen profile_nopol=ideoid==5
label var profile_nopol "Profile doesn't include politics"

gen profile_notint=ideoid==4
label var profile_notint "Profile not interested in politics"

gen profile_liberal=ideoid==1
label var profile_liberal "Profile liberal"

gen profile_conserv=ideoid==2
label var profile_conserv "Profile conservative"

* This is a robustness coding that is all pairwise combinations of own ideo and ideo of profile
gen R_melib_themlib=ideology==0 & profile_liberal==1
gen R_melib_themconsv=ideology==0 & profile_conserv==1
gen R_melib_themnotint=ideology==0 & profile_notint==1
gen R_melib_themnopol=ideology==0 & profile_nopol==1

gen R_memod_themlib=ideology==1 & profile_liberal==1
gen R_memod_themconsv=ideology==1 & profile_conserv==1
gen R_memod_themnotint=ideology==1 & profile_notint==1
gen R_memod_themnopol=ideology==1 & profile_nopol==1

gen R_meconsv_themlib=ideology==2 & profile_liberal==1
gen R_meconsv_themconsv=ideology==2 & profile_conserv==1
gen R_meconsv_themnotint=ideology==2 & profile_notint==1
gen R_meconsv_themnopol=ideology==2 & profile_nopol==1

* Match interest

tab poliinterest
tab activity_Politics

gen match_notinterest=0
replace match_notinterest=1 if (poliinterest==0 | poliinterest==1) & profile_notint==1
*replace match_notinterest=1 if (activity_Politics==0) & profile_notint==1
label var match_notinterest "Match not interest (Explicit not interested in profile)" 

// Set up treatment-respondent combinations for ideology for other variables

tab religion
recode religion (0=6) (2=6) (4=6)
tab religion

/*
Catholic	2,220	22.79	22.79
Jewish	230	2.36	25.15
None	2,980	30.60	55.75
Other	2,800	28.75	84.50
Protestant	1,510	15.50	100.00
*/

/*
religionid
Catholic	1	25.31
Protestant	2	24.61
Jewish	3	25.66
Not Religious	4	24.43
*/

levelsof religion, local(rlgnlist)
foreach relctr of local rlgnlist {
 local templabel : label (religion) `relctr'
 forvalues pctr = 1(1)3 {
  gen match_rel_R`relctr'_P`pctr'=religion==`relctr' & religionid==`pctr'
  local templabel2 : label (religionid) `pctr'
  label var match_rel_R`relctr'_P`pctr' "Religion Resp=`templabel' Prof=`templabel2'"
 }
}

gen age_dif1 = 25-age  if gender==0&man25==1
gen age_dif2 = 28-age  if gender==0&man28==1
gen age_dif3 = 31-age  if gender==0&man31==1

gen age_dif4 = 22-age  if gender==1&woman22==1
gen age_dif5 = 25-age  if gender==1&woman25==1
gen age_dif6 = 28-age  if gender==1&woman28==1

egen age_dif = rowtotal(age_dif1 age_dif2 age_dif3 age_dif4 age_dif5 age_dif6), missing
gen abs_age_dif = abs(age_dif)
label var abs_age_dif "Absolute value of age difference"

gen profile_younger=man25 | woman22
label var profile_younger "Youngest of profile ages"
gen profile_middle=man28 | woman25
label var profile_middle "Middle of profile ages"

* Collapse respondent education
tab education
recode education (1=2) (3=4)
tab education

levelsof education, local(educlist)
foreach eductr of local educlist {
 local templabel : label (education) `eductr'
 forvalues pctr = 1(1)2 {
  gen match_educ_R`eductr'_P`pctr'=education==`eductr' & educid==`pctr'
  local templabel2 : label (educid) `pctr'
  label var match_educ_R`eductr'_P`pctr' "Education Resp=`templabel' Prof=`templabel2'"
 }
}

gen prof_col=educid==2
label var prof_col "Profile education=college"
gen prof_gs=educid==3
label var prof_gs "Profile education=grad school"

// Recoded DV, 0 to 1
qui foreach var of varlist O_Attractive O_Interested O_Respond O_LongTerm O_Values O_Friends im_O_Attractive im_O_Interested im_O_Respond im_O_LongTerm im_O_Values im_O_Friends {
 qui summ `var'
 gen R`var'=(`var'- r(min))/(r(max)- r(min))
 local templabel : var label `var'
 label var R`var' "`templabel' (0-1)"
}

* Summary stats about sample
log using Tables\TableS03_Study1SubjectDemographics.txt, text replace
foreach var of varlist age education poliinterest race gender relstatus ideology poliinterest religion {
 di "`var' --->"
 sort userid
 tab `var' if userid ~=userid[_n-1]
 }
log close

// Regressions 

xtset userid

// Everyone
local coreiv="match_ideology match_notinterest profile_nopol profile_notint profile_liberal profile_cons man28 man31 woman25 woman28 abs_age_dif match_educ_R* prof_col prof_gs match_rel_R* prof_catholic prof_christian prof_jewish tall"
local coreiv2="match_ideo_alt1 match_notinterest profile_nopol profile_notint profile_liberal profile_cons man28 man31 woman25 woman28 abs_age_dif match_educ_R* prof_col prof_gs match_rel_R* prof_catholic prof_christian prof_jewish tall"
local corefe="picind* profileind*"

* Table 1/Table S4 Main Result
foreach var of varlist RO_Interested RO_Respond RO_LongTerm RO_Values RO_Attractive RO_Friends {
	
	xtreg `var' `coreiv' `corefe', cluster(userid) fe
	qui egen temp=sd(`var') if e(sample), by(userid)
	qui summ temp
	qui local sdwithinperson=r(mean)
	qui drop temp
		
	if "`var'"=="RO_Interested" {
     outreg match_ideology match_notinterest using "Tables\Table01_Study1CoreModels.out", se bracket tdec(6) 10pct addnote("Fixed effects for profile text and picture not shown.") addstat("Avg. SD of DV within respondent", `sdwithinperson') replace
	 outreg using "tables\TableS04_Study1CoreModelsFullRegression.out", se bracket tdec(6) 10pct addnote("Fixed effects for profile text and picture not shown.") addstat("Avg. SD of DV within respondent", `sdwithinperson') replace
	}
	else {
	 outreg match_ideology match_notinterest using "tables\Table01_Study1CoreModels.out", se bracket tdec(6) 10pct addstat("Avg. SD of DV within respondent", `sdwithinperson') append
	 outreg using "tables\TableS04_Study1CoreModelsFullRegression.out", se bracket tdec(6) 10pct addstat("Avg. SD of DV within respondent", `sdwithinperson') append
	}
}

* Robustness appears in Table S05

****************************************************
*
* Robustness
*
* Excluding people who mention politics as purpose of study
*
****************************************************

foreach var of varlist RO_Interested RO_Respond RO_LongTerm RO_Values RO_Attractive RO_Friends {
	
	xtreg `var' `coreiv' `corefe'  if  mention_pol_purpose_study~=1, cluster(userid) fe
	
	if "`var'"=="RO_Interested" {
     outreg match_ideology match_notinterest using "tables\TableS05_A_Study1Robustness_DontUsePoliticsinDescribingPurpose.out", se bracket tdec(6) noaster addnote("Fixed effects for profile text and picture not shown.") replace
	}
	else {
	 outreg match_ideology match_notinterest using "tables\TableS05_A_Study1Robustness_DontUsePoliticsinDescribingPurpose.out", se bracket tdec(6) noaster append
	}
}

****************************************************
*
* Robustness
*
* Listwise deletion*
*
****************************************************

foreach var of varlist Rim_O_Interested Rim_O_Respond Rim_O_LongTerm Rim_O_Values Rim_O_Attractive Rim_O_Friends {
	
	xtreg `var' `coreiv' `corefe', cluster(userid) fe
	
	if "`var'"=="Rim_O_Interested" {
     outreg match_ideology match_notinterest using "tables\TableS05_B_Study1Robustness_Listwiseddelete.out", se bracket tdec(6) noaster  addnote("Fixed effects for profile text and picture not shown.") replace
	}
	else {
	 outreg match_ideology match_notinterest using "tables\TableS05_B_Study1Robustness_Listwiseddelete.out", se bracket tdec(6) noaster  append
	}
}

****************************************************
*
* Robustness
*
* Unclustered standard errors
*
****************************************************

foreach var of varlist RO_Interested RO_Respond RO_LongTerm RO_Values RO_Attractive RO_Friends {
	
	xtreg `var' `coreiv' `corefe', fe
	
	if "`var'"=="RO_Interested" {
     outreg match_ideology match_notinterest using "tables\TableS05_C_Study1Robustness_NoCluster.out", se bracket tdec(6) noaster  addnote("Fixed effects for profile text and picture not shown.") replace
	}
	else {
	 outreg match_ideology match_notinterest using "tables\TableS05_C_Study1Robustness_NoCluster.out", se bracket tdec(6) noaster  append
	}
}

****************************************************
*
* Robustness
*
* Excluding moderate profiles
*
****************************************************

foreach var of varlist RO_Interested RO_Respond RO_LongTerm RO_Values RO_Attractive RO_Friends {
	
	xtreg `var' `coreiv' `corefe'  if  ideoid~=3, cluster(userid) fe
	
	if "`var'"=="RO_Interested" {
     outreg match_ideology match_notinterest using "tables\TableS05_D_Study1Robustness_NoModerateProfiles.out", se bracket tdec(6) noaster  addnote("Fixed effects for profile text and picture not shown.") replace
	}
	else {
	 outreg match_ideology match_notinterest using "tables\TableS05_D_Study1Robustness_NoModerateProfiles.out", se bracket tdec(6) noaster   append
	}
}

****************************************************
*
* Robustness
*
* Testing for heterogenous gender effects
*
****************************************************

gen match_ideo_woman=(gender==0)*match_ideology
gen match_notint_woman=(gender==0)*match_notinterest
label var match_ideo_woman "Ideology matches x Female"
label var match_notint_woman "Match not interest x Female" 

foreach var of varlist RO_Interested RO_Respond RO_LongTerm RO_Values RO_Attractive RO_Friends {
	
	local templabel : var label `var'
	xtreg `var' match_ideo_woman match_notint_woman `coreiv' `corefe', cluster(userid) fe

	if "`var'"=="RO_Interested" {
     outreg match_ideology match_ideo_woman match_notinterest match_notint_woman using "tables\TableS05_E_Study1Robustness_GenderInteractions.out", se bracket tdec(6) noaster  addnote("Fixed effects for profile text and picture not shown.") addstat("Avg. SD of DV within respondent", `sdwithinperson') replace
	}
	else {
	 outreg match_ideology match_ideo_woman match_notinterest match_notint_woman using "tables\TableS05_E_Study1Robustness_GenderInteractions.out", se bracket tdec(6) noaster  addstat("Avg. SD of DV within respondent", `sdwithinperson') append
	}
}	
	
****************************************************
*
* Robustness
*
* More flexible version of coding match on politics
*
****************************************************

foreach var of varlist RO_Interested RO_Respond RO_LongTerm RO_Values RO_Attractive RO_Friends {
	
	xtreg `var' R_* man28 man31 woman25 woman28 abs_age_dif match_educ_R* prof_col prof_gs match_rel_R* prof_catholic prof_christian prof_jewish tall `corefe', cluster(userid) fe
	lincom ((R_melib_themlib-R_melib_themconsv)+(R_meconsv_themconsv-R_meconsv_themlib))/2
	if "`var'"=="RO_Interested" {
     outreg using "tables\TableS05_F_Study1Robustness_FlexibleMatchCode.out", se bracket tdec(6) adec(3) noaster  addstat("Lincom Coeffient",r(estimate),"Lincom SE",r(se)) addnote("Fixed effects for profile text and picture not shown.") replace
	}
	else {
	 outreg using "tables\TableS05_F_Study1Robustness_FlexibleMatchCode.out", se bracket tdec(6) adec(3) noaster  addstat("Lincom Coeffient",r(estimate),"Lincom SE",r(se)) append
	}
}

****************************************************
*
* Robustness
*
* Heterogenous Effects by Interest. Does sophistication affect sorting on politics? In lieu of sophistication, using interest
*
****************************************************

recode poliinterest (0=1) (1=1) (2=0) (3=0) (*=.), gen(low_int)
gen match_ideology_low=low_int*match_ideology
label var match_ideology_low "Match Ideology * Low Interest"

foreach var of varlist RO_Interested RO_Respond RO_LongTerm RO_Values RO_Attractive RO_Friends {

    xtreg `var' match_ideology match_ideology_low profile_liberal profile_cons man28 man31 woman25 woman28 abs_age_dif match_educ_R* prof_col prof_gs match_rel_R* prof_catholic prof_christian prof_jewish tall picind* profileind* if ideoid<=3 & profile_nopol~=1 & profile_notint~=1, cluster(userid) fe
	qui egen temp=sd(`var') if e(sample), by(userid)
	qui summ temp
	qui local sdwithinperson=r(mean)
	qui drop temp
		
	lincom match_ideology + match_ideology_low 
		
	if "`var'"=="RO_Interested" {
     outreg match_ideology match_ideology_low using "tables\TableS05_G_Study1Robustness_InteractMatchInterest.out", se bracket tdec(6) noaster   addnote("Fixed effects for profile text and picture not shown.") addstat("Avg. SD of DV within respondent", `sdwithinperson') replace
	}
	else {
	 outreg match_ideology match_ideology_low using "tables\TableS05_G_Study1Robustness_InteractMatchInterest.out", se bracket tdec(6) noaster  addstat("Avg. SD of DV within respondent", `sdwithinperson') append
	}
}

