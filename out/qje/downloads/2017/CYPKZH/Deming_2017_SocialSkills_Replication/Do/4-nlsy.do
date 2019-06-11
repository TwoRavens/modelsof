/*
	Project: The growing importance of social skills in the labor market (2017)
	Author: David Deming
	Date Created: April 2017
	
	Description: Cleans NLSY79 and NLSY97 data, runs the analysis and creates:
		Tables 1, 2, 3, 4, 5, A2, A3, A4
	
	Notes:
	- The replication package includes NLSY79 and NLSY97 tagsets (files with the
		suffixes ".NLSY79" and ".NLSY97") that can be used to download the data from
		the NLSY Investigator tool
	- In the do-file that is automatically created as part of the NLSY79 extract,
		uncomment the "Crosswalk for Reference number & Question name" section
		that renames the variables, and remove "#" characters from variable names
	- In the do-file that is automatically created as part of the NLSY97 extract,
		uncomment the "Crosswalk for Reference number & Question name" section
		that renames the variables, and replace "!" characters in variable names
		with "_"
*/


version 14
clear all
set more off


**** Define macros ****

global topdir "YOURFILEPATH/Deming_2017_SocialSkills_Replication"
local dodir "${topdir}/Do"

local rawdir "${topdir}/Data/census-acs/raw"
local cleandir "${topdir}/Data/census-acs/clean"
local collapdir "${topdir}/Data/census-acs/collapsed" 
local occdir "${topdir}/Data/census-acs/xwalk_occ"
local inddir "${topdir}/Data/census-acs/xwalk_ind"

local onetdir "${topdir}/Data/onet"
local txtdir "${topdir}/Data/onet/text_files"
local dotdir "${topdir}/Data/dot"

local nlsydir "${topdir}/Data/nlsy"
local import79dir "${topdir}/Data/nlsy/import/nlsy79"
local import97dir "${topdir}/Data/nlsy/import/nlsy97"
local name79 "socskills_nlsy79_final"			/* Name of NLSY79 extract */
local name97 "socskills_nlsy97_final"			/* Name of NLSY97 extract */
local afqtadj "${topdir}/Data/nlsy/altonjietal2012"

local figdir "${topdir}/Results/figures"
local tabdir "${topdir}/Results/tables"


**************************
****Non-NLSY Data Prep****
**************************

** Crosswalk for ind 2000 to ind6090

use "`cleandir'/2000.dta", clear
keep ind ind6090
duplicates drop
rename ind ind00
save "`inddir'/ind00.dta", replace

** Crosswalk between Occ70 and Occ1990dd

* To merge in ONET tasks at occ1990dd level to NLSY data in 1979-1981,
*	which uses occ70 codes, need this crosswalk

use "`occdir'/occ70-80cw.dta", clear
rename occ80 occ
merge m:1 occ using "`occdir'/occ1980_occ1990dd_update.dta", keep(match) nogen
drop occ
save "`occdir'/occ1970_occ1990dd.dta", replace

** Weight ONET 1998 by 1980 Census

* Use 1980 Census data
use "`cleandir'/1980.dta", clear

* Drop occupations with no ONET data
drop if onetmerge==1

* Collapse ONET variables by occ1990dd
collapse (rawsum) lswt (mean) require_social_onet1998-interact_onet1998, by(occ1990dd)

* Turn ONET variables into percentiles weighted by 1980 labor supply
foreach var of varlist require_social_onet1998-interact_onet1998 {
	xtile `var'_pct=`var' [aw=lswt], nq(100)
	replace `var'_pct=`var'_pct/10
	drop `var'
}	

* Save data
save "`onetdir'/onet98_occ1990dd_pct.dta", replace


*************************
****Clean NLSY79 Data****
*************************

** Import data and define value labels
import delimited "`import79dir'/`name79'.csv", case(preserve) clear 
do "`import79dir'/`name79'-value-labels.do"
tolower

** Code variables as missing if values are less than zero
foreach var of varlist _all {
	replace `var'=. if `var'<0
}

** Individual ID codes
rename caseid_1979 caseid

** Demographics
gen race=sample_race_78scrn
gen sex=sample_sex_1979
gen age1979=fam_1b_1979

* Age by year
forvalues y=1980(1)1994 {
	local z=`y'-1979
	gen age`y'=age1979+`z'
}
forvalues y=1996(2)2012 {
	local z=`y'-1979
	gen age`y'=age1979+`z'
}

** Urbanicity and region
forvalues y=1979(1)1994 {
	gen urban`y'=urban_rural_`y'
	gen div`y'=region_`y'
	gen metro`y'=smsares_`y'
}
forvalues y=1996(2)2012 {
	gen urban`y'=urban_rural_`y'
	gen div`y'=region_`y'
	gen metro`y'=smsares_`y'
}

** Highest grade completed
egen educ=rowmax(hgcrev*)

** Employment since date of last interview (DLI)
forvalues y=1979(1)1994 {
	rename lastint_jobs_`y'_xrnd emp`y'
	recode emp`y' (0=0) (1/20=1)
}
forvalues y=1996(2)2012 {
	rename lastint_jobs_`y'_xrnd emp`y'
	recode emp`y' (0=0) (1/20=1)
}

** Hourly rate of pay
forvalues y=1979(1)1994 {
	gen wage`y'=cpshrp_`y'/100
}
forvalues y=1996(2)2012 {
	gen wage`y'=hrp1_`y'/100
}

* Hourly wage excluding those enrolled in school
forvalues y=79(1)94 {
		gen wage_noschl19`y'= wage19`y' if enrollmtrev`y'_19`y'!=2 & enrollmtrev`y'_19`y'!=3
}
forvalues y=96(2)98 {
	gen wage_noschl19`y'=wage19`y' if enrollmtrev`y'_19`y'!=2 & enrollmtrev`y'_19`y'!=3
}
forvalues y=0(2)6 {
	gen wage_noschl200`y'=wage200`y' if enrollmtrev0`y'_200`y'!=2 & enrollmtrev0`y'_200`y'!=3
}

** Occupation: Apply occ1990dd crosswalk

* Remove extra digit for occ codes beginning in 2004
forvalues y=2004(2)2012 {
	rename occall_emp_01_`y' occall_4d
	gen occall_emp_01_`y'=substr(string(occall_4d), 1, length(string(occall_4d))-1)
	destring occall_emp_01_`y', replace
	drop occall_4d
}

* Years 1979-1981: occ70
forvalues y=1979(1)1981 {
	rename cpsocc70_`y' occ70
	merge m:1 occ70 using "`occdir'/occ1970_occ1990dd.dta", keep(master match) nogen
	display "Occupations not matched to occ1990dd: `y'"
	levelsof occ70 if occ1990dd==.
	rename occ70 occ`y'
	rename occ1990dd occ1990dd`y'
}

* Years 1982-2000: occ80
forvalues y=1982(1)1994 {
	rename cpsocc80_`y' occ
	merge m:1 occ using "`occdir'/occ1980_occ1990dd_update.dta", ///
		keep(master match) nogen
	display "Occupations not matched to occ1990dd: `y'"
	levelsof occ if occ1990dd==.
	rename occ occ`y'
	rename occ1990dd occ1990dd`y'
}
rename cpsocc80_01_2000 cpsocc80_2000
forvalues y=1996(2)2000 {
	rename cpsocc80_`y' occ
	merge m:1 occ using "`occdir'/occ1980_occ1990dd_update.dta", ///
		keep(master match) nogen
	display "Occupations not matched to occ1990dd: `y'"
	levelsof occ if occ1990dd==.
	rename occ occ`y'
	rename occ1990dd occ1990dd`y'	
}

* Years 2002-2012: occ2000
forvalues y=2002(2)2012 {
	rename occall_emp_01_`y' occ
	merge m:1 occ using "`occdir'/occ2000_occ1990dd_update.dta", ///
		keep(master match) nogen
	display "Occupations not matched to occ1990dd: `y'"
	levelsof occ if occ1990dd==.
	rename occ occ`y'
	rename occ1990dd occ1990dd`y'	
}

** Industry: Apply ind6090 crosswalk

* Years 1979-1981: ind70
forvalues y=1979(1)1981 {
	rename cpsind70_`y' ind70
	merge m:1 ind70 using "`inddir'/ind70.dta", keep(master match) nogen ///
		keepusing(ind70 ind6090)
	display "Industries not matched to ind6090: `y'"
	levelsof ind70 if ind6090==.
	rename ind70 ind`y'
	rename ind6090 ind6090`y'
}

* Years 1982-2000: ind80
forvalues y=1982(1)1994 {
	rename cpsind80_`y' ind80
	merge m:1 ind80 using "`inddir'/ind80.dta", keep(master match) nogen ///
		keepusing(ind80 ind6090)
	display "Industries not matched to ind6090: `y'"
	levelsof ind80 if ind6090==.
	rename ind80 ind`y'
	rename ind6090 ind6090`y'
}
rename cpsind80_01_2000 cpsind80_2000
forvalues y=1996(2)2000 {
	rename cpsind80_`y' ind80
	merge m:1 ind80 using "`inddir'/ind80.dta", keep(master match) nogen ///
		keepusing(ind80 ind6090)
	display "Industries not matched to ind6090: `y'"
	levelsof ind80 if ind6090==.
	rename ind80 ind`y'
	rename ind6090 ind6090`y'
}

* Years 2002-2012: ind00
forvalues y=2002(2)2012 {
	rename indall_emp_01_`y' ind00
	if `y'==2004 | `y'==2006 | `y'==2008 | `y'==2010 | `y'==2012 {
		replace ind00=floor(ind00/10)
	}
	merge m:1 ind00 using "`inddir'/ind00.dta", keep(master match) nogen
	display "Industries not matched to ind6090: `y'"
	levelsof ind00 if ind6090==.
	rename ind00 ind`y'
	rename ind6090 ind6090`y'
}

** Social skills composite

* School activity participation
gen youth_org=school_46_000001_1984
gen hobby=school_46_000002_1984
gen stugov=school_46_000003_1984
gen newsp=school_46_000004_1984
gen athletics=school_46_000005_1984
gen perfarts=school_46_000006_1984

* Sociability
gen social_age6=health_soc_1_1985
gen social_adult=health_soc_2_1985

* Number of clubs, including zero
foreach x in youth_org hobby stugov newsp athletics perfarts {
	gen `x'_cat=(`x'!=.)
}
egen num_clubs=rowtotal(youth_org_cat hobby_cat stugov_cat newsp_cat athletics_cat perfarts_cat)
replace num_clubs=. if athletics_cat==.

* Standardize
foreach var of varlist social_age6 social_adult num_clubs athletics_cat {
	egen `var'_std=std(`var'), mean(0) std(1)
}

* Composite 1: 4 elements (use in NLSY79-only analyses)
egen soc_nlsy=rowmean(social_age6_std social_adult_std athletics_cat_std num_clubs_std)
egen soc_nlsy_std=std(soc_nlsy), mean(0) std(1)

* Composite 2: 2 elements (use in analyses with NLSY79 & NLSY97)
egen soc_nlsy2=rowmean(social_age6_std social_adult_std)
egen soc_nlsy2_std=std(soc_nlsy2), mean(0) std(1)

** Non-Cognitive measures: Rotter & Rosenberg score
egen rotter_std=std(rotter_score_1979), mean(0) std(1)
replace rotter_std=-rotter_std
egen rosen_std=std(rosenberg_score_1980), mean(0) std(1)
egen noncog=rowmean(rotter_std rosen_std)
egen noncog_std=std(noncog), mean(0) std(1)

** Restrict sample to selected variables and compress
keep caseid race sex age* urban1979-urban2012 div* metro* educ emp* wage* occ* ///
	ind* soc_nlsy_std soc_nlsy2_std rotter_std rosen_std noncog_std
compress

** Reshape data long for main analysis
reshape long age urban div metro emp wage wage_noschl occ occ1990dd ///
	ind ind6090, i(caseid) j(year)

** Save data for merge
save "`nlsydir'/nlsy79_clean.dta", replace


*************************
****Clean NLSY97 Data****
*************************

** Import data
import delimited "`import97dir'/`name97'.csv", case(preserve) clear 
do "`import97dir'/`name97'-value-labels.do"
tolower

** Code variables as missing if values are less than zero
foreach var of varlist _all {
	replace `var'=. if `var'<0
}
** Individual ID codes
rename pubid_1997 pubid
** Demographics - recode to make them similar to NLSY79

** Demographics
gen race=1 if key_race_ethnicity_1997==2 /*Hispanic*/
* Code mixed as Black, following NLSY79
replace race=2 if key_race_ethnicity_1997==1 | key_race_ethnicity_1997==3 /*Black*/
replace race=3 if key_race_ethnicity_1997==4 /*White Non-Hispanic*/
gen sex=key_sex_1997
gen age1997=1997-key_bdate_y_1997

* Age by year
forvalues y=1998(1)2011 {
	local z=`y'-1997
	gen age`y'=age1997+`z'
}
gen age2013=age1997+16

** Urbanicity and region
forvalues y=1997(1)2011 {
	gen urban`y'=cv_urban_rural_`y'
	gen div`y'=cv_census_region_`y'
	gen metro`y'=cv_msa_`y'
}
gen urban2013=cv_urban_rural_2013
gen div2013=cv_census_region_2013
gen metro2013=cv_msa_2013

** Highest grade completed
gen educ=cvc_hgc_ever_xrnd
replace educ=. if educ==95

** Employment since date of last interview (DLI)
forvalues y=1997(1)2011 {
	gen emp`y'=1 if yinc_1400_`y'==1
	replace emp`y'=0 if yinc_1400_`y'==0
}
gen emp2013=1 if yinc_1400_2013==1
replace emp2013=0 if yinc_1400_2013==0

** Hourly rate of pay
forvalues y=1997(1)2011 {
	gen wage`y'=cv_hrly_pay_01_`y'/100
}
gen wage2013=cv_hrly_pay_01_2013/100

* Hourly wage excluding those enrolled in school
gen school1997=cv_enrollstat_1997>=8 & cv_enrollstat_1997!=.
forvalues y=1998(1)2004 {
	gen school`y'=cv_enrollstat_edt_`y'>=8 & cv_enrollstat_edt_`y'!=.
}
forvalues y=2005(1)2011 {
		gen school`y'=cv_enrollstat_`y'>=8 & cv_enrollstat_`y'!=.
}
gen school2013=cv_enrollstat_2013>=8 & cv_enrollstat_2013!=.
forvalues y=1997(1)2011 {
	gen wage_noschl`y'=wage`y' if school`y'==0
}
gen wage_noschl2013=wage2013 if school2013==0

** Occupation: Apply occ1990dd crosswalk (using occ80)
forvalues y=1997(1)2011 {
	rename yemp_occode_2002_01_`y' occ
	replace occ=occ/10
	merge m:1 occ using "`occdir'/occ2000_occ1990dd_update.dta", keep(master match) nogen
	replace occ1990dd=653 if occ==650
	replace occ1990dd=533 if occ==884
	replace occ1990dd=439 if occ==416
	replace occ1990dd=68 if occ==123
	replace occ1990dd=814 if occ==911 | occ==950 | occ==973 | occ==974
	replace occ1990dd=699 if occ==692 | occ==693 | occ==631
	replace occ1990dd=326 if occ==521
	replace occ1990dd=47 if occ==150
	replace occ1990dd=779 if occ==812
	replace occ1990dd=59 if occ==134
	replace occ1990dd=214 if occ==194
	replace occ1990dd=599 if occ==617 | occ==802	
	display "Occupations not matched to occ1990dd: `y'"
	levelsof occ if occ1990dd==.
	rename occ occ`y'
	rename occ1990dd occ1990dd`y'	
}
rename yemp_occode_2002_01_2013 occ
replace occ=occ/10
merge m:1 occ using "`occdir'/occ2000_occ1990dd_update.dta", keep(master match) nogen
	replace occ1990dd=653 if occ==650
	replace occ1990dd=533 if occ==884
	replace occ1990dd=439 if occ==416
	replace occ1990dd=68 if occ==123
	replace occ1990dd=814 if occ==911 | occ==950 | occ==973 | occ==974
	replace occ1990dd=699 if occ==692 | occ==693 | occ==631
	replace occ1990dd=326 if occ==521
	replace occ1990dd=47 if occ==150
	replace occ1990dd=779 if occ==812
	replace occ1990dd=59 if occ==134
	replace occ1990dd=214 if occ==194
	replace occ1990dd=599 if occ==617 | occ==802	
display "Occupations not matched to occ1990dd: 2013"
levelsof occ if occ1990dd==.
rename occ occ2013
rename occ1990dd occ1990dd2013

** Industry: Apply ind6090 crosswalk (using ind00)
forvalues y=1997(1)2011 {
	rename yemp_indcode_2002_01_`y' ind00
	replace ind00=floor(ind00/10)
	replace ind00=49 if ind00==48
	replace ind00=207 if ind00==200
	merge m:1 ind00 using "`inddir'/ind00.dta", keep(master match) nogen
	display "Industries not matched to ind6090: `y'"
	levelsof ind00 if ind6090==.
	rename ind00 ind`y'
	rename ind6090 ind6090`y'
}
rename yemp_indcode_2002_01_2013 ind00
replace ind00=floor(ind00/10)
replace ind00=49 if ind00==48
replace ind00=207 if ind00==200
merge m:1 ind00 using "`inddir'/ind00.dta", keep(master match) nogen
display "Industries not matched to ind6090: 2013"
levelsof ind00 if ind6090==.
rename ind00 ind2013
rename ind6090 ind60902013


** Social and Non-Cognitive Skill Measures

* Raw variables
rename ytel_tipia_000001_2008 extraverted
rename ytel_tipia_000006_2008 reserved

rename ysaq_282j_2002 disorganized
rename ysaq_282k_2002 conscientious
rename ysaq_282l_2002 undependable
rename ysaq_282m_2002 thorough
rename ysaq_282q_2002 trusting
rename ytel_tipia_000003_2008 disciplined
rename ytel_tipia_000008_2008 careless

* Social skills composite
foreach x in extraverted reserved {
	egen `x'_std=std(`x'), mean(0) std(1)
}
gen animated_std=-reserved_std

egen soc_nlsy2=rowmean(extraverted_std animated_std)
egen soc_nlsy2_std=std(soc_nlsy2), mean(0) std(1)

* Non-cognitive skills composite
foreach x in disorganized conscientious undependable thorough trusting disciplined careless {
	egen `x'_std=std(`x'), mean(0) std(1)
}
gen organized_std=-disorganized_std
gen dependable_std=-undependable_std
gen careful_std=-careless_std

egen noncog=rowmean(organized_std conscientious_std dependable_std thorough_std trusting_std disciplined_std careful_std)
egen noncog_std=std(noncog), mean(0) std(1)

** Restrict sample to selected variables
keep pubid race sex age* urban* div* metro* educ emp* wage* occ* ///
	ind* soc_nlsy2_std noncog_std

** Reshape data as panel
reshape long age urban div metro emp wage wage_noschl occ occ1990dd ind ind6090, ///
	i(pubid) j(year)

** Save data for merge
save "`nlsydir'/nlsy97_clean.dta", replace


************************************************
****Append NLSY Cohorts and Further Cleaning****
************************************************
	
** Append NLSY79 data and create sample indicators 
*	Note: sample=1 if sample==nlsy97
gen sample=1
append using "`nlsydir'/nlsy79_clean.dta"
replace sample=0 if sample!=1

** Person ID
replace pubid=caseid if pubid==.
egen uniqueID=group(pubid sample)

** ASVAB - Use Altonji, Bharadwaj and Lange (2009) file that gives age-adjusted 
*	comparability across NLSY surveys*
gen pid=pubid
replace pid=caseid if pid==.
rename age age_temp
merge m:1 pid sample using "`afqtadj'/afqt_adjusted_final.dta", keep(master match) ///
	keepusing(age weight pafqt afqt_std) nogen
rename age age_test
rename age_temp age
rename afqt_std afqt
egen afqt_std=std(afqt), mean(0) std(1)
drop pid

** Earnings adjustments

* Logged earnings, excluding respondents enrolled in school
gen ln_wage=ln(wage)
gen ln_wage_noschl=ln(wage_noschl)
replace ln_wage_noschl=ln_wage if year>=2008 & year<=2012 & sample==0
drop ln_wage
rename ln_wage_noschl ln_wage

* Inflate to 2013 wages
replace wage=wage*3.21 if year==1979
replace wage=wage*2.83 if year==1980
replace wage=wage*2.56 if year==1981
replace wage=wage*2.41 if year==1982
replace wage=wage*2.34 if year==1983
replace wage=wage*2.24 if year==1984
replace wage=wage*2.17 if year==1985
replace wage=wage*2.13 if year==1986
replace wage=wage*2.05 if year==1987
replace wage=wage*1.97 if year==1988
replace wage=wage*1.88 if year==1989
replace wage=wage*1.78 if year==1990
replace wage=wage*1.71 if year==1991
replace wage=wage*1.66 if year==1992
replace wage=wage*1.57 if year==1994
replace wage=wage*1.48 if year==1996
replace wage=wage*1.45 if year==1997
replace wage=wage*1.43 if year==1998
replace wage=wage*1.40 if year==1999
replace wage=wage*1.35 if year==2000
replace wage=wage*1.32 if year==2001
replace wage=wage*1.29 if year==2002
replace wage=wage*1.27 if year==2003
replace wage=wage*1.23 if year==2004
replace wage=wage*1.19 if year==2005
replace wage=wage*1.16 if year==2006
replace wage=wage*1.12 if year==2007
replace wage=wage*1.08 if year==2008
replace wage=wage*1.09 if year==2009
replace wage=wage*1.07 if year==2010
replace wage=wage*1.04 if year==2011
replace wage=wage*1.01 if year==2012

* Trim wages
replace wage=3 if wage>0 & wage<3
replace wage=200 if wage>200 & wage!=.

** Merge in ONET measures
merge m:1 occ1990dd using "`onetdir'/onet98_occ1990dd_pct.dta", keep(master match) nogen
levelsof occ1990dd if socskills_onet1998_pct==.

* Rename ONET measures
foreach x in require_social number_facility math routine socskills service ///
	reason info_use coord interact {
	rename `x'_onet1998_pct `x'
}

** Interaction measure

* Race-by-gender
gen female=(sex==2)
gen hisp_male=(race==1 & sex==1)
gen hisp_female=(race==1 & sex==2)
gen black_male=(race==2 & sex==1)
gen black_female=(race==2 & sex==2)

* NLSY skills
gen afqt_socnlsy=afqt_std*soc_nlsy_std
gen afqt_socnlsy2=afqt_std*soc_nlsy2_std
gen afqt_noncog=afqt_std*noncog_std

* NLSY skills and ONET tasks
gen afqt_math=afqt_std*math
gen socnlsy_math=soc_nlsy_std*math
gen afqt_socnlsy_math=afqt_std*soc_nlsy_std*math
gen socnlsy2_math=soc_nlsy2_std*math
gen afqt_socnlsy2_math=afqt_std*soc_nlsy2_std*math

gen afqt_routine=afqt_std*routine
gen socnlsy_routine=soc_nlsy_std*routine
gen afqt_socnlsy_routine=afqt_std*soc_nlsy_std*routine
gen socnlsy2_routine=soc_nlsy2_std*routine
gen afqt_socnlsy2_routine=afqt_std*soc_nlsy2_std*routine

gen afqt_socskills=afqt_std*socskills
gen socnlsy_socskills=soc_nlsy_std*socskills
gen afqt_socnlsy_socskills=afqt_std*soc_nlsy_std*socskills
gen socnlsy2_socskills=soc_nlsy2_std*socskills
gen afqt_socnlsy2_socskills=afqt_std*soc_nlsy2_std*socskills

* Sample & NLSY skills
gen afqt_sample=afqt_std*sample
gen soc_nlsy2_sample=soc_nlsy2_std*sample
gen afqt_socnlsy2_sample=afqt_socnlsy2*sample
gen noncog_sample=noncog_std*sample

* Samples, NLSY skills & ONET tasks
foreach x in math routine socskills service {
	gen afqt_`x'_sample=afqt_sample*`x'
	gen socnlsy2_`x'_sample=soc_nlsy2_sample*`x'
	gen afqt_socnlsy2_`x'_sample=afqt_socnlsy2_sample*`x'
}
foreach var of varlist require_social-interact {
	gen `var'_sample=`var'*sample
}

** Completeness indicators
gen complete79=(emp==1 & ind6090!=. & div!=. & metro!=. & urban!=. & math!=. & ///
	afqt_std!=. & soc_nlsy_std!=.)
gen complete97=(emp==1 & ind6090!=. & div!=. & metro!=. & urban!=. & math!=. & ///
	afqt_std!=. & soc_nlsy2_std!=.)

** Compress data
compress

** Save data
save "`nlsydir'/nlsy_merged.dta", replace

** Set working directory
cd "`tabdir'"


****************
****Analysis****
****************

set more off

****Table 1 - Labor Market Returns to Skills in the NLSY79****

local covs "female hisp_male hisp_female black_male black_female i.age i.year i.div i.metro i.urban"

xi: reg ln_wage soc_nlsy_std `covs' [w=weight] if complete79==1 & sample==0 ///
	& age>=23, vce(cluster pubid)
outreg2 using table1, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3) replace	

xi: reg ln_wage afqt_std soc_nlsy_std `covs' [w=weight] if complete79==1 ///
	& sample==0 & age>=23, vce(cluster pubid)
outreg2 using table1, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23, vce(cluster pubid)
outreg2 using table1, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23, vce(cluster pubid)
outreg2 using table1, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std i.educ `covs' ///
	[w=weight] if complete79==1 & sample==0 & age>=23, vce(cluster pubid)
outreg2 using table1, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std afqt_noncog `covs' ///
	[w=weight] if complete79==1 & sample==0 & age>=23, vce(cluster pubid)
outreg2 using table1, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std afqt_noncog i.educ ///
	`covs' [w=weight] if complete79==1 & sample==0 & age>=23, vce(cluster pubid)
outreg2 using table1, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)


****Table 2 - Occupational Sorting on Skills in the NLSY79****

local covs "female hisp_male hisp_female black_male black_female i.age i.year i.div i.metro i.urban"

xi: reg routine afqt_std soc_nlsy_std afqt_socnlsy i.educ `covs' i.ind6090 ///
	[w=weight] if complete79==1 & sample==0 & age>=23 & wage!=., vce(cluster pubid)
outreg2 using table2, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3) replace	
	
xi: reg routine afqt_std soc_nlsy_std afqt_socnlsy math number_facility reason info_use ///
	i.educ `covs' [w=weight] if complete79==1 & sample==0 & age>=23 & wage!=., vce(cluster pubid)
outreg2 using table2, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg socskills afqt_std soc_nlsy_std afqt_socnlsy i.educ `covs' i.ind6090 ///
	[w=weight] if complete79==1 & sample==0 & age>=23 & wage!=., vce(cluster pubid)
outreg2 using table2, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)
	
xi: reg socskills afqt_std soc_nlsy_std afqt_socnlsy math number_facility reason info_use ///
	i.educ `covs' [w=weight] if complete79==1 & sample==0 & age>=23 & wage!=., vce(cluster pubid)
outreg2 using table2, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)


****Table 3 - Returns to Skills by Occupation Task Intensity in the NLSY79****

xtset uniqueID
local covs "i.age i.year i.div i.metro i.urban"

xi: xtreg ln_wage routine afqt_routine socnlsy_routine afqt_socnlsy_routine ///
	`covs' [w=weight] if complete79==1 & age>=23 & sample==0, fe vce(cluster uniqueID)
outreg2 using table3, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(4) replace	

xi: xtreg ln_wage socskills afqt_socskills socnlsy_socskills afqt_socnlsy_socskills ///
	`covs' [w=weight] if complete79==1 & age>=23 & sample==0, fe vce(cluster uniqueID)
outreg2 using table3, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(4)

xi: xtreg ln_wage routine afqt_routine socnlsy_routine afqt_socnlsy_routine ///
	socskills afqt_socskills socnlsy_socskills afqt_socnlsy_socskills ///
	`covs' [w=weight] if complete79==1 & age>=23 & sample==0, fe vce(cluster uniqueID)
outreg2 using table3, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(4)


****Table 4 - Labor Market Returns to Skills in the NLSY79 vs. the NLSY97****

local covs "female hisp_male hisp_female black_male black_female i.age i.year i.div i.metro i.urban"

xi: reg emp afqt_std afqt_sample soc_nlsy2_std soc_nlsy2_sample afqt_socnlsy2 ///
	afqt_socnlsy2_sample sample `covs' if age>=25 & age<=33, ///
	vce(cluster pubid)
outreg2 using table4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3) replace

xi: reg emp afqt_std afqt_sample soc_nlsy2_std soc_nlsy2_sample afqt_socnlsy2 ///
	afqt_socnlsy2_sample sample i.educ `covs' if age>=25 & age<=33, ///
	vce(cluster pubid)
outreg2 using table4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg emp afqt_std afqt_sample soc_nlsy2_std soc_nlsy2_sample afqt_socnlsy2 ///
	afqt_socnlsy2_sample  noncog_std noncog_sample sample i.educ `covs' ///
	if age>=25 & age<=33, vce(cluster pubid)
outreg2 using table4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std afqt_sample soc_nlsy2_std soc_nlsy2_sample afqt_socnlsy2 ///
	afqt_socnlsy2_sample sample `covs' if age>=25 & age<=33 & complete97==1, ///
	vce(cluster pubid)
outreg2 using table4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std afqt_sample soc_nlsy2_std soc_nlsy2_sample afqt_socnlsy2 ///
	afqt_socnlsy2_sample sample i.educ `covs' if age>=25 & age<=33 & complete97==1, ///
	vce(cluster pubid)
outreg2 using table4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std afqt_sample soc_nlsy2_std soc_nlsy2_sample afqt_socnlsy2 ///
	afqt_socnlsy2_sample sample i.educ `covs' noncog_std noncog_sample ///
	if age>=25 & age<=33 & complete97==1, vce(cluster pubid)
outreg2 using table4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)


****Table 5 - Returns to Skills by Occupation Task Intensity in the NLSY79 vs. the NLSY97****

local covs "i.age i.year i.div i.metro i.urban"

* Col 1
xtreg ln_wage socskills socskills_sample `covs' ///
	if age>=25 & age<=33 & complete97==1, fe vce(cluster uniqueID)
outreg2 using table5, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(4) replace

* Col 2
xtreg ln_wage socskills socskills_sample math math_sample `covs' ///
	if age>=25 & age<=33 & complete97==1, fe vce(cluster uniqueID)
outreg2 using table5, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(4)

* Col 3
xtreg ln_wage socskills socskills_sample math math_sample afqt_socskills ///
	afqt_socskills_sample socnlsy2_socskills socnlsy2_socskills_sample	`covs' ///
	if age>=25 & age<=33 & complete97==1, fe vce(cluster uniqueID)
outreg2 using table5, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(4)

* Col 3 Coefficient Tests
file open table5tests using "`tabdir'/table5tests.txt", write replace

test (socnlsy2_socskills+socnlsy2_socskills_sample=0)
local pval: di r(p)
file write table5tests "Col 3, Test 1: `pval'" _n

test (socnlsy2_socskills+socnlsy2_socskills_sample=0) (afqt_socskills+afqt_socskills_sample=0)
local pval: di r(p)
file write table5tests "Col 3, Test 2: `pval'" _n

* Col 4
xtreg ln_wage socskills socskills_sample math math_sample afqt_socskills ///
	afqt_socskills_sample socnlsy2_socskills socnlsy2_socskills_sample ///
	afqt_math afqt_math_sample socnlsy2_math socnlsy2_math_sample `covs' ///
	if age>=25 & age<=33 & complete97==1, fe vce(cluster uniqueID)
outreg2 using table5, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(4)

* Col 4 Coefficient Tests
test (socnlsy2_socskills+socnlsy2_socskills_sample=0)
local pval: di r(p)
file write table5tests "Col 4, Test 1: `pval'" _n

test (socnlsy2_socskills+socnlsy2_socskills_sample=0) (afqt_socskills+afqt_socskills_sample=0)
local pval: di r(p)
file write table5tests "Col 4, Test 2: `pval'" _n

test (socnlsy2_socskills_sample=0) (afqt_socskills_sample=0) (socnlsy2_math_sample=0) ///
	(afqt_math_sample=0)
local pval: di r(p)
file write table5tests "Col 4, Test 3: `pval'" _n

file close table5tests


****Table A2 - Labor Market Returns to Skills in the NLSY79 with Unlogged Wages****

local covs "female hisp_male hisp_female black_male black_female i.age i.year i.div i.metro i.urban"

xi: reg wage soc_nlsy_std `covs' [w=weight] if complete79==1 & sample==0 & age>=23, ///
	vce(cluster pubid)
outreg2 using tableA2, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3) replace	

xi: reg wage afqt_std soc_nlsy_std `covs' [w=weight] if complete79==1 & sample==0 ///
	& age>=23, vce(cluster pubid)
outreg2 using tableA2, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2)

xi: reg wage afqt_std soc_nlsy_std afqt_socnlsy `covs' [w=weight] if complete79==1 ///
	& sample==0 & age>=23, vce(cluster pubid)
outreg2 using tableA2, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3)

xi: reg wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ////
	if complete79==1 & sample==0 & age>=23, vce(cluster pubid)
outreg2 using tableA2, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3)

xi: reg wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std i.educ `covs' [w=weight] ////
	if complete79==1 & sample==0 & age>=23, vce(cluster pubid)
outreg2 using tableA2, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3)


****Table A3 - Heterogeneity in Returns to Skills (NLSY79)****

local covs "female hisp_male hisp_female black_male black_female i.age i.year i.div i.metro i.urban"

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & female==0, vce(cluster pubid)
outreg2 using tableA3, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3) replace	

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & female==1, vce(cluster pubid)
outreg2 using tableA3, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & (race==1 | race==2), vce(cluster pubid)
outreg2 using tableA3, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & race==3, vce(cluster pubid)
outreg2 using tableA3, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & educ<=12, vce(cluster pubid)
outreg2 using tableA3, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)

xi: reg ln_wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & educ>12, vce(cluster pubid)
outreg2 using tableA3, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(3)


****Table A4 - Heterogeneity in Returns to Skills (NLSY79)****

local covs "female hisp_male hisp_female black_male black_female i.age i.year i.div i.metro i.urban"

xi: reg wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & female==0, vce(cluster pubid)
outreg2 using tableA4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3) replace	

xi: reg wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & female==1, vce(cluster pubid)
outreg2 using tableA4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3)

xi: reg wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & (race==1 | race==2), vce(cluster pubid)
outreg2 using tableA4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3)

xi: reg wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & race==3, vce(cluster pubid)
outreg2 using tableA4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3)

xi: reg wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & educ<=12, vce(cluster pubid)
outreg2 using tableA4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3)

xi: reg wage afqt_std soc_nlsy_std afqt_socnlsy noncog_std `covs' [w=weight] ///
	if complete79==1 & sample==0 & age>=23 & educ>12, vce(cluster pubid)
outreg2 using tableA4, alpha(0.01, 0.05, 0.10) bracket nocons excel dec(2) rdec(3)

