

*Coding of treatment - linkage to schoolid varies by file
*SD2005_rev2 - sampleSD = schoolid, HIVtreat = sch03v1, sch04v1 if unavailable, schoolid == sch04v1
*SDcontrolcohort_rev2 - sampleSD = schoolid, HIVtreat = sch03v1 (covers all observations), schoolid = sch03v1
*homesurvey_rev3, homesurvey_rev4 = both = schoolid
*HIKAP_survey.dta = both = prischoolid, missing prischoolid are all treatment == 0 


**************************************************************************************************

*Acquiring strata and treatment vector using file provided by Pascaline Dupas
use School_level_data_withstrata.dta, clear
egen M = group(division HIVtreat Utreat)
replace kcpe2001 = 10000 if kcpe2001 == .
sum M
forvalues i = 1/32 {
	tab division if M == `i'
	tab kcpe2001 RRstrata if M == `i'
	}
*Note doesn't precisely divide by median in all cases - because of this, will have to keep HIVtreat Utreat combinations within division
*so that when rerandomize can retain M categories and divide into strata according to kcpe2001, but in upper and lower groups by numbers
*used in original experiment M groups (wasn't median in all cases, so can't divide by median in new groupings - instead, keep M groupings together, and divide as
*done in experiment

tab RRstrata if kcpe2001 == 10000
*So, kcpe2001 always coded as maximum value in distribution
gen odd = (ceil(RRstrata/2)*2 ~= RRstrata)
egen sumodd = sum(odd), by(M)

egen mdiv = group(division)
egen mdivsd = sd(mdiv), by(TT_U_strata)
tab TT_U_strata division if mdivsd > 0 & mdivsd ~= .
*Very few where go across divisions, need to randomize within substrata to keep M groupings constant (see problem described above)
*This is a conditional share of total randomization distribution, but close to full, because number of instances going across division small
egen TTstrata = group(TT_U_strata division)

rename sampleSD STREAT
rename HIVtreat HTREAT
rename schoolid SCHOOLID
rename kcpe2001 KCPE2001

keep TTstrata HTREAT M sumodd SCHOOLID STREAT KCPE2001
sort TTstrata HTREAT M sumodd SCHOOLID STREAT KCPE2001
compress
save Sample1, replace

**************************************************************************************************

*author's do file
capture mkdir datasets
use HIVnamelist_forSD.dta, clear
save datasets\HIVnamelist_forSD, replace
use School_level_data.dta, clear
save datasets\School_level_data, replace
do create_data_studycohort
save SD2005_rev2, replace
do create_data_controlcohort
save SDcontrolcohort_rev2, replace

use homesurvey,clear
	***CREATE OUTCOMES OF INTEREST
		**WANTED PREG**
			gen fert=0
			replace fert=1 if givenbirth==1|stillbirth==1|pregnantnow=="1"
			replace fert=1 if pregnantnow=="99"|index(pregnantnow, "D")
			gen wantedpreg=0 if fert==1
			replace wantedpreg=1 if  wantedpreg_22==1| wantedpreg_25==1
		***NOT CONSENSUAL**
			gen rape=0
			replace rape=1 if index(comments, "RAPE")|index(typeofhelp_43, "RAPE")
		**PAYMENTS**
			destring cashbefore, force replace
				replace cashbefore=0 if cashbefore==2|cashbefore==2
				replace cashbefore=0 if cashbefore==.&support_42==2
				replace cashbefore=0 if cashbefore==3
			destring stillsupporting, force replace
				replace stillsupporting=0 if stillsupporting==2
		*BABY'S FATHER'S AGE
			replace agefather=2005-agefather if agefather>1900&age<1991
			gen agegap=agefather-age
				replace agegap=. if agegap>39
			gen gapabove5=0 if agegap!=.|yrsolder_27a<3
				replace gapabove5=1 if agegap>5&agegap!=.
				replace gapabove5=1 if yrsolder_27a==1|yrsolder_27b==1
			gen gapabove10=0 if agegap!=.|yrsolder_27b<3
				replace gapabove10=1 if agegap>10&agegap!=.
				replace gapabove10=1 if yrsolder_27b==1
				replace gapabove5=1 if gapabove5==.&gapabove10==0
				replace gapabove10=0 if gapabove10==.&gapabove5==0
		***MARRIED***
 			gen married=0 if relationship!=.
				replace married=1 if relationship==1
			gen married_u5=married if gapabove5==0
			gen married_510=married if gapabove5==1&gapabove10==0
			gen married_a10=married if gapabove10==1
sort pupilid
save homesurvey_rev3, replace



**************************************************************************************************

*Table 3 - One coefficient missing from table row

*First, execute paper's code and compare with table

use SD2005_rev2, clear
gen date1=d04v1 if timegroup==1
replace date1=d04v2 if timegroup==2
gen gap=d05v1-date1
replace gap=d05v2-date1 if timegroup==2
global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"  
global location_controls="i.district i.division total_2km"
keep if girl==1
keep if updateR2>0.5

xi: reg fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, clust(schoolid)
foreach var of varlist fertafter12 unmarpreg marpreg {
	xi: reg `var' sampleSD HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, clust(schoolid)
	xi: probit `var' sampleSD HIVtreat ${indiv_controls} ${school_controls} ${location_controls} , asis clust(schoolid)
}
 
use SDcontrolcohort_rev2, clear
append using SD2005_rev2
gen sampleSDT=sampleSD*cohort
keep if girl==1 
keep if updateR2>0.5
replace timegroup=1 if cohort==0
gen date1=d03v1 if cohort==0
replace date1=d04v1 if cohort==1
gen date2=d04v1 if cohort==0
replace date2=d05v2 if cohort==1
gen gap=date2-date1
gen datebase=date1
replace datebase=datebase-365 if cohort==1
sort schoolid
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil d04v1 d04v2 d05v1 d05v2" 
xi: reg fertafter12 sampleSD cohort sampleSDT HIVtreat Utreat double8 age agemissing  ${school_controls}, clust(schoolid)
foreach var of varlist fertafter12 unmarpreg marpreg {
	xi: reg `var' sampleSD cohort sampleSDT HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, cluster(schoolid)
	xi: xtreg `var' sampleSD cohort sampleSDT HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, cluster(schoolid)  fe i(schoolid)
}



*Now execute my code - Simplification of code in areas, removing dropped variables, keeping only regressions used in paper
*In each case I show that I am reproducing exactly the same regression

***Part I of Table 3***

use SD2005_rev2, clear
gen date1=d04v1 if timegroup==1
replace date1=d04v2 if timegroup==2
gen gap=d05v1-date1
replace gap=d05v2-date1 if timegroup==2
global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"  
global location_controls="i.district i.division total_2km"
keep if girl==1
keep if updateR2>0.5

quietly tab district, gen(DISTRICT)
quietly tab division, gen(DIVISION)


xi: reg fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, clust(schoolid)

reg fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, clust(schoolid)

*Colinear
reg DIVISION5 ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km 


xi: probit fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, asis clust(schoolid)

probit fertafter12 sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, asis clust(schoolid)

foreach var of varlist unmarpreg marpreg {
	xi: reg `var' sampleSD HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, clust(schoolid)
}

foreach X in unmarpreg marpreg {
	reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, clust(schoolid)
	}

capture drop _m
merge using Sample1
drop _m
save DatD1, replace

******************************
******************************

***Part II of Table 3***

use SDcontrolcohort_rev2, clear
append using SD2005_rev2
gen sampleSDT=sampleSD*cohort
keep if girl==1 
keep if updateR2>0.5
replace timegroup=1 if cohort==0
gen date1=d03v1 if cohort==0
replace date1=d04v1 if cohort==1
gen date2=d04v1 if cohort==0
replace date2=d05v2 if cohort==1
gen gap=date2-date1
gen datebase=date1
replace datebase=datebase-365 if cohort==1
sort schoolid

global indiv_controls="age agemissing double8"
global location_controls="i.district i.division total_2km"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil d04v1 d04v2 d05v1 d05v2" 

tab district, gen(DISTRICT)
tab division, gen(DIVISION)

xi: reg fertafter12 sampleSD cohort sampleSDT HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, cluster(schoolid)

reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)

*Colinear
reg DIVISION7 DISTRICT2 DIVISION2-DIVISION6 DIVISION8 

xi: xtreg fertafter12 sampleSD cohort sampleSDT HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, cluster(schoolid)  fe i(schoolid)

*HIVtreat coefficient not reported
xtreg fertafter12 cohort sampleSDT HIVtreat age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe i(schoolid)

foreach X in unmarpreg marpreg {
	xi: reg `X' sampleSD cohort sampleSDT HIVtreat ${indiv_controls} ${school_controls} ${location_controls}, cluster(schoolid)
	}

foreach X in unmarpreg marpreg {
	reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

capture drop _m
merge using Sample1
drop _m
save DatD2, replace

**********************************************************************************

*Table 4 - All okay (not able to check probits as uses external programme to calculate marginal effects & doesn't match dprobit)

use homesurvey_rev3,   clear
global school_controls="sdkcpe girl8perboy8"
global location_controls="i.district  i.zone"
tab district, gen(DISTRICT)
tab zone, gen(ZONE)

xi: reg agegap sampleSD SDtreat cohort HIVtreat age ${school_controls} ${location_controls} , clust(schoolid), if class==8
xi: reg agegap sampleSD SDtreat cohort  HIVtreat age  ${school_controls} ${location_controls},clust(schoolid), if agegap!=40
xi: reg gapabove5 sampleSD SDtreat  cohort HIVtreat age  ${school_controls} ${location_controls}, clust(schoolid), if class==8
xi: probit gapabove5 sampleSD SDtreat  cohort HIVtreat age  ${school_controls} ${location_controls},  asis clust(schoolid), if class==8
xi: reg gapabove5 sampleSD SDtreat  cohort HIVtreat age  ${school_controls} ${location_controls}, clust(schoolid)
xi: reg gapabove10 sampleSD SDtreat  cohort HIVtreat age   ${school_controls} ${location_controls}, clust(schoolid), if class==8
xi: probit gapabove10 sampleSD SDtreat  cohort HIVtreat age  ${school_controls} ${location_controls},  asis clust(schoolid), if class==8
xi: reg gapabove10 sampleSD SDtreat  cohort HIVtreat age ${school_controls} ${location_controls}, clust(schoolid)

reg agegap sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, clust(schoolid)
reg agegap SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14 if agegap!=40, clust(schoolid) 
reg gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, clust(schoolid)
probit gapabove5 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis clust(schoolid)
reg gapabove5 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, clust(schoolid)
reg gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, clust(schoolid)
probit gapabove10 sampleSD HIVtreat age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, asis clust(schoolid)
reg gapabove10 SDtreat HIVtreat sampleSD cohort age ${school_controls} DISTRICT2 ZONE2-ZONE7 ZONE9-ZONE14, clust(schoolid)

capture drop _m
merge using Sample1
drop _m
save DatD3, replace

**********************************************************************************

*Table 6 & Table A4 - Prep

use HIKAP_survey.dta, clear

gen girl=0 if sex=="M"
replace girl=1 if sex=="F"
gen agemissing=0
replace agemissing=1 if age==.
sum age if girl==0
replace age=r(mean) if agemissing==1&girl==0
sum age if girl==1
replace age=r(mean) if agemissing==1&girl==1 
gen cluster=secschoolid*form
gen cohort=0 if form==2
replace cohort=1 if form==1

gen multiplepartner=0 if eversex!=.
replace multiplepartner=1 if eversex==1
gen everplayedsex=0 if eversex!=.
replace everplayedsex=1 if eversex<3
gen everusedcondom=evercondom
recode everusedcondom (2=0) (3=.)
gen condomlastsex=condomlast
recode condomlastsex (2=0) (3=.)
recode regpartner (2=0)
replace regpartner=1 if agepartner!=.
recode condomregpartner (2=0) (3=.)
replace condomregpartner=. if regpartner!=1
recode giftpartner (2=0) (3=.)
replace giftpartner=. if regpartner!=1
replace condomlastsex=condomregpartner if condomlastsex==.&condomregpartner!=.
replace agepartner=. if agepartner<13
gen agegap=agepartner-age
gen gapabove5=0 if agepartner!=.
replace gapabove5=1 if agegap>5&agegap!=.

gen everplayedsex_2=everplayedsex
replace everplayedsex_2=1 if regpartner==1
gen condomlastsex_2=condomlastsex
replace condomlastsex=. if everplayedsex!=1
replace condomlastsex_2=. if everplayedsex_2!=1
gen gapabove5_2=gapabove5
replace gapabove5=. if everplayedsex!=1
gen regpartner_2=regpartner
replace regpartner=0 if everplayedsex==0
gen everusedcondom_2=everusedcondom
replace everusedcondom=. if everplayedsex!=1
replace everusedcondom_2=. if everplayedsex_2!=1
gen activeunsafe=0 if everplayedsex!=.
replace activeunsafe=1 if everplayedsex==1&everusedcondom==0
gen activeunsafe_2=0 if everplayedsex_2!=.
replace activeunsafe_2=1 if everplayedsex_2==1&everusedcondom_2==0
gen giftpartner_2=giftpartner
replace giftpartner=. if everplayedsex!=1
sort secschoolid

save hikapall,replace

****************

*Table 6 & Table A4 - All okay

use hikapall, clear

replace giftpartner=. if giftpartner==3|regpartner==0|regpartner==.
recode giftpartner 2=0
global indiv_controls="unsampled age agemissing "
global school_controls="boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy "
global location_controls="i.realdivision"
tab realdivision, gen(REALDIVISION)

*Additional specifications for drops
global school_controlsg = "girlsonlyschool girlsperboy missinggirlsperboy"

*BOYS*

*Table A4
foreach var of varlist multiplepartner regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	xi: reg `var' sampleSD HIVtreat  ${indiv_controls} ${school_controls}  ${location_controls}, clust(cluster), if form==1&girl==0
}
*3 & 4 & 7 drop girlsonlyschool and missinggirlsperboy
*all drop girlsonly school

*Table 6
foreach var of varlist multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 {
	xi: reg `var' sampleSD HIVtreat  ${indiv_controls} ${school_controls}  ${location_controls}, clust(cluster), if form==1&girl==0
}

*3 & 4 & 7 drop girlsonlyschool and missinggirlsperboy
*all drop girlsonly school


*GIRLS*

*Table A4
foreach var of varlist multiplepartner regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	xi: reg `var' sampleSD HIVtreat  ${indiv_controls} ${school_controls}  ${location_controls}, clust(cluster), if form==1&girl==1
}
*3 & 4 drop boysonlyschool

*Table 6
foreach var of varlist multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 {
	xi: reg `var' sampleSD HIVtreat  ${indiv_controls} ${school_controls}  ${location_controls}, clust(cluster), if form==1&girl==1
}
*3 & 4 drop boysonlyschool


*For my calculations reorder girls then boys (as in tables), table 6 then A4
*First column of Table A4 girls is repeat of Table 6 column 1
*Clusters by secondary school x form, not secondary school as indicated in table

local k = 1
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	if (`k' ~= 3 & `k' ~= 4 & `k' ~= 9 & `k' ~= 10)	{
		reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, clust(cluster) 
		}
	else {
		reg `X' sampleSD HIVtreat ${indiv_controls} ${school_controlsg} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, clust(cluster) 
		}	
	local k = `k' + 1
	}

sum boysonlyschool if form == 1 & girl == 1 & gapabove5 ~= .
sum boysonlyschool if form == 1 & girl == 1 & gapabove5_2 ~= .
sum boysonlyschool if form == 1 & girl == 1 & giftpartner ~= .
sum boysonlyschool if form == 1 & girl == 1 & giftpartner_2 ~= .

local k = 1
foreach X in multiplepartner regpartner_2 gapabove5_2 giftpartner_2 everplayedsex_2 activeunsafe_2 condomlastsex_2 regpartner gapabove5 giftpartner everplayedsex activeunsafe condomlastsex {
	if (`k' ~= 3 & `k' ~= 4 & `k' ~= 7 & `k' ~= 9 & `k' ~= 10 & `k' ~= 13)	{
		reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, clust(cluster) 
		}
	else {
		reg `X' sampleSD HIVtreat ${indiv_controls} boysonlyschool girlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==0, clust(cluster) 
		}
	local k = `k' + 1
	}

sum girlsonlyschool if girl == 0
sum missinggirlsperboy if form == 1 & girl == 0 & gapabove5 ~= .
sum missinggirlsperboy if form == 1 & girl == 0 & gapabove5_2 ~= .
sum missinggirlsperboy if form == 1 & girl == 0 & giftpartner ~= .
sum missinggirlsperboy if form == 1 & girl == 0 & giftpartner_2 ~= .
sum missinggirlsperboy if form == 1 & girl == 0 & condomlastsex ~= .
sum missinggirlsperboy if form == 1 & girl == 0 & condomlastsex_2 ~= .

keep if form == 1
capture drop _m
merge using Sample1
drop _m
save DatD4, replace

*********************************************************************************

*Table A1 - Part I (sampleSD) - segment on boys got coefficients confused across rows

use SD2005_rev2,clear
gen attrit=1-update05v2
collapse sampleSD repeat8 secschool training athome attrit evdead05v2 Nobs , by(schoolid girl)

*Dropping attrit, as that is analysis of attrition not subject outcomes (separate topic)
foreach X in repeat8 secschool training athome evdead05v2 { 
	reg `X'  sampleSD if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	reg `X'  sampleSD if girl==0
	}

capture drop _m
merge using Sample1
drop _m
save DatD5, replace

*****************************************

*Table A1 - Part II (HIVtreat) - segment on boys got coefficients confused across rows, rounding error in girls
*As before, drop extra code on attrition

use SD2005_rev2,clear
collapse HIVtreat repeat8 secschool training athome Nobs married  fertafter12 evdead05v2, by(schoolid girl)
replace HIVtreat=0 if HIVtreat<0.5
replace HIVtreat=1 if HIVtreat>=0.5

foreach X in repeat8 secschool training athome evdead05v2 {
	reg `X' HIVtreat if girl==1
	}
foreach X in repeat8 secschool training athome evdead05v2 {
	reg `X' HIVtreat if girl==0
	}

save DatD6, replace
*Because of rounding of HIVtreat by school (students were in different schools at different times) 
*will have to implement randomization by calling the file repeatedly

use SD2005_rev2,clear
keep HIVtreat repeat8 secschool training athome evdead05v2 sch03v1 sch04v1 schoolid girl
generate a = .
generate U = .

capture drop _m
merge using Sample1
drop _m
save DatDD6, replace

******************************************************************************

*Table A2 - Paper's code incorrect
*This, paper's code, doesn't work - samples wrong, comes from variable name confusion - correct further below
global school_controls="sdkcpe girl8perboy8"
global location_controls="i.district i.zone"

use homesurvey_rev3,clear
gen age_survey=age
gen HIVtreat_survey=HIVtreat
gen sampleSD_survey=sampleSD
sort schoolid
merge schoolid using School_level_data
sort pupilid
gen missingageinfo=0 if gapabove5!=.
replace missingageinfo=1 if fert==1&gapabove5==.
gen selfinterview=1 if strpos(findpupil, "1")
replace selfinterview=0 if selfinterview==.
*My added code for randomization - will use later (schoolid_survey is different on one observation, but treatment measures are based on survey, so use schoolid_survey)
generate schoolid_survey = schoolid
save homesurvey_rev4, replace

use SD2005_rev2, clear
sort pupilid 
merge pupilid using homesurvey_rev4, _merge(merge_home)

gen traced=0 if merge_home==1
replace traced=1 if merge_home==3
replace traced=0 if merge_home==3&givenbirth_13==.&gapabove5==.
replace selfinterview=0 if traced==0

xi: reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} ${location_controls}, clust(schoolid), if class==8
xi: reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} ${location_controls}, clust(schoolid),if class==8&selfinterview==1
xi: reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} ${location_controls}, clust(schoolid),if class==8&selfinterview==0

*Now, adjust variable names - the dataset paper merged with had girl8perboy8 and that messed up regression with girl8perboy8_2004 (taken from school_level_data earlier)

global school_controls="sdkcpe girl8perboy8_2004"
use SD2005_rev2, clear
sort pupilid 
merge pupilid using homesurvey_rev4, _merge(merge_home)

gen traced=0 if merge_home==1
replace traced=1 if merge_home==3
replace traced=0 if merge_home==3&givenbirth_13==.&gapabove5==.
replace selfinterview=0 if traced==0
quietly tab district, gen(DISTRICT)
quietly tab zone, gen(ZONE)

*Some rounding errors, but sample sizes correct and coefficients very close

*From point of view of clustering, schoolid_survey vs schoolid makes no difference (only differ on one, singleton, observation in these samples)
xi: reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} ${location_controls}, clust(schoolid_survey), if class==8
reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, clust(schoolid_survey)

xi: reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} ${location_controls}, clust(schoolid_survey),if class==8&selfinterview==1
reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2-ZONE4 ZONE6-ZONE14 if class == 8 & selfinterview == 1, clust(schoolid_survey)

xi: reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} ${location_controls}, clust(schoolid_survey),if class==8&selfinterview==0
reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE12 ZONE14 if class == 8 & selfinterview == 0, clust(schoolid_survey)

*eliminate extraneous observations
xi: reg gapabove5 sampleSD_survey HIVtreat_survey age_survey ${school_controls} ${location_controls}, clust(schoolid_survey), if class==8
keep if e(sample) == 1

capture drop _m
merge using Sample1
drop _m

capture drop schoolid
rename schoolid_survey schoolid
save DatD7, replace

*************************************************


*Table A3 - Part 1 -  All okay

use SD2005_rev2, clear
gen date1=d04v1 if timegroup==1
replace date1=d04v2 if timegroup==2
gen gap=d05v1-date1
replace gap=d05v2-date1 if timegroup==2
global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"
global location_controls="i.district i.division total_2km"
keep if girl==1
keep if updateR2>0.5
gen SDonly=sampleSD
replace SDonly=0 if HIVtreat==1
gen HIVonly=HIVtreat
replace HIVonly=0 if sampleSD==1
gen interac=sampleSD*HIVtreat

tab district, gen(DISTRICT)
tab division, gen(DIVISION)

xi: reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} ${location_controls}, clust(schoolid)
reg fertafter12 SDonly HIVonly interac ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km, clust(schoolid)

*Colinear
reg DIVISION5 ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km
reg DIVISION7 ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION4 DIVISION6 DIVISION8 total_2km

capture drop _m
merge using Sample1
drop _m
save DatD8, replace

******************

*Table A3 - Part 2 - All okay

use homesurvey_rev3, clear
global school_controls="sdkcpe girl8perboy8"
global location_controls="i.district  i.zone"
label var age ""
gen SDonly=sampleSD
replace SDonly=0 if HIVtreat==1
gen HIVonly=HIVtreat
replace HIVonly=0 if sampleSD==1
gen interac=sampleSD*HIVtreat

tab district, gen(DISTRICT)
tab zone, gen(ZONE)

xi: reg agegap SDonly HIVonly interac  age ${school_controls} ${location_controls} , clust(schoolid), if class==8
reg agegap SDonly HIVonly interac age ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, clust(schoolid)

xi: reg gapabove5 SDonly HIVonly interac age  ${school_controls} ${location_controls}, clust(schoolid), if class==8
reg gapabove5 SDonly HIVonly interac age  ${school_controls} DISTRICT2 ZONE2 ZONE4-ZONE14 if class == 8, clust(schoolid)

*Colinear
reg ZONE3 DISTRICT2 ZONE2 ZONE4-ZONE14

capture drop _m
merge using Sample1
drop _m
save DatD9, replace

************************

*Table A3 - Part 3 - All okay

use hikapall, clear
gen SDonly=sampleSD
replace SDonly=0 if HIVtreat==1
gen HIVonly=HIVtreat
replace HIVonly=0 if sampleSD==1
gen interac=sampleSD*HIVtreat
global indiv_controls="unsampled age agemissing "
global school_controls="boysonlyschool girlsonlyschool girlsperboy missinggirlsperboy "
global location_controls="i.realdivision"

tab realdivision, gen(REALDIVISION)

xi: reg gapabove5_2 SDonly HIVonly interac ${indiv_controls} ${school_controls}  ${location_controls}, clust(cluster), if form==1&girl==1
reg gapabove5_2 SDonly HIVonly interac ${indiv_controls} girlsonlyschool girlsperboy missinggirlsperboy REALDIVISION2-REALDIVISION8 if form==1 & girl==1, clust(cluster)

xi: reg everplayedsex_2 SDonly HIVonly interac ${indiv_controls} ${school_controls}  ${location_controls}, clust(cluster), if form==1&girl==1
reg everplayedsex_2 SDonly HIVonly interac ${indiv_controls} ${school_controls} REALDIVISION2-REALDIVISION8 if form==1 & girl==1, clust(cluster)

sum boysonlyschool if form == 1 & girl == 1 & gapabove5_2 ~= .

keep if form == 1 & girl == 1
capture drop _m
merge using Sample1
drop _m
save DatD10, replace

use Sample1, clear
keep SCHOOLID
rename SCHOOLID schoolid
sort schoolid
gen N = _n
save Sample2, replace





