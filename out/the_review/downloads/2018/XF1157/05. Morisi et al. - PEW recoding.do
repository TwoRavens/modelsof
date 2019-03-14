****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
**  	"An Asymmetrical 'President-in-Power' Effect" 											              **
** 		Authors: Davide Morisi, John Jost, and Vishal Singh													  **
** 		Journal: American Political Science Review															  **
**
/*This file recodes and combines the following 9 surveys from the PEW Research Center:
1.	Pew Research Center April 2017 Political Survey
2.	Pew Research Center 2015 Governance Survey
3.	Pew Research Center 2014 Political Polarization and Typology Survey
4.	Pew Research Center For The People & The Press October 2013 Political Survey
5.	Pew Research Center For The People & The Press January 2013 Political Survey
6.	Pew Research Center For The People & The Press August 2011 Political Survey
7.	Pew Research Center For The People & The Press September 2010 Political-Independents Survey
8.	Pew Research Center For The People & The Press March 2010 Trust In Government Survey
9.	Pew Research Center For The People & The Press December 2006 Values Update Survey

The surveys are publicly available on the website of PEW (http://www.pewresearch.org/)
and have been downloaded between December 2017 and July 2018*/
****************************************************************************************************************


*************************************************
*1. RECODING OF "Pew Research Center April 2017 Political Survey"
*File name: "Apr17 public.sav"

*DEMOGRAPHICS
*gender
fre sex // 1 men, 2 women
*age
fre age
*education
gen edu17 = educ2
label values edu17 educ2
fre edu17
*race
fre racethn
*income
fre income
*religion
fre relig
*census
fre cregion

*TRUST, IDEOLOGY, PARTISANSHIP
*trust
fre q13
gen trust17=q13
label values trust17 q13
fre trust17
*ideology
lookfor ideo
fre ideo 
*partisanship
lookfor party
fre party 

*OTHER VARIABLES
*year
gen year = 2017
*month
gen month = 4
*weight
sum weight

*Keep only variables needed for analysis
keep sex age edu17 racethn income relig cregion trust17 ideo party year month weight
*save "...\STATA\pewtrust_17.dta", replace


*************************************************
*2. RECODING OF "Pew Research Center 2015 Governance Survey"
*File name: "Governance 2015.public.sav"

*DEMOGRAPHICS
*gender
fre sex
*age
fre age
*education
fre edu
gen edu15 = edu
label values edu15 educ
fre edu15
*race
fre racethn
*income
fre income
*religion
fre relig
*census
fre cregion

*TRUST, IDEOLOGY, PID
*trust
fre q15
gen trust15=q15
label values trust15 q15
fre trust15
*ideology
fre ideo
*partisanship
fre party

*OTHER
*year
gen year = 2015
*month
gen month = 8
*weight
sum weight

*Keep only variables needed for analysis
keep sex age edu15 racethn income relig cregion year month weight ideo party trust15
*save "...\pewtrust_15.dta", replace


*************************************************
*3. RECODING OF "Pew Research Center 2014 Political Polarization and Typology Survey"
*File name: "Polarization 2014 public.sav"

*DEMOGRAPHICS
*gender
fre sex
*age
fre age
*education
gen edu14 = edu
label values edu14 educ
fre edu14
*race
fre racethn 
*income
fre income
*religion
fre relig
*census
fre cregion

*TRUST, IDEO, PID
*trust
fre qb40b
gen trust14=qb40b
label values trust14 qb40b
fre trust14
*ideology
fre ideo
*partisanship
fre party

*OTHER
*year
gen year = 2014
*month
gen month = 1
*weight
sum weight 

*Keep only variables needed for analysis
keep sex age edu14 racethn income relig cregion year month weight ideo party trust14
*save "...\pewtrust_14.dta", replace


*************************************************
*4. RECODING OF "Pew Research Center For The People & The Press October 2013 Political Survey"
*File name: "Oct13 public.sav"

*DEMOGRAPHICS
*gender
fre sex
*age
fre age
*education
fre edu 
gen edu13oct = edu
label values edu13oct educ
fre edu13oct
*race
fre racethn
*income
fre income
*religion
fre relig 
*census
fre cregion

*TRUST, IDEO, PID
*trust
fre q19
gen trust13oct=q19
label values trust13oct q19
fre trust13oct
*ideology
fre ideo
*partisanship
fre party 

*OTHER
*year
gen year = 2013
*month
gen month = 10
*weight
sum weight

*Keep only variables needed for analysis
keep sex age edu13oct racethn income relig cregion year month weight ideo party trust13oct
*save "...\pewtrust_13oct.dta", replace


*************************************************
*5. RECODING OF "Pew Research Center For The People & The Press January 2013 Political Survey"
*File name: "Jan13 public.sav"

*DEMOGRAPHICS
*gender
fre sex
*age
fre age
*education
fre educ2
gen edu13jan = educ2
label values edu13jan educ2
fre edu13jan
*race
fre racethn
*income
fre income
*religion
fre relig
*census
fre cregion

*TRUST, IDEO, PID
*trust
fre q32
gen trust13jan=q32
label values trust13jan q32
fre trust13jan
*ideology
fre ideo
*partisanship
fre party

*OTHER
*year
gen year = 2013
*month
gen month=1
*weight
sum weight

*Keep only variables needed for analysis
keep sex age edu13jan racethn income relig cregion year month weight ideo party trust13jan
*save "...\pewtrust_13jan.dta", replace


*************************************************
*6. RECODING OF "Pew Research Center For The People & The Press August 2011 Political Survey"
*File name: "Aug11 political public.sav"

*DEMOGRAPHICS
*gender
fre sex
*age
fre age
*education
fre edu
gen edu11 = edu
label values edu11 educ
fre edu11
*race
fre racethn 
*income
fre income
*religion
fre relig
*census
fre cregion

*TRUST, IDEO, PID
*trust
fre q18
gen trust11=q18
label values trust11 q18
fre trust11
*ideology
fre ideo 
*partisanship
fre party

*OTHER
*year
gen year = 2011
*month
gen month = 11
*weight
sum weight

*Keep only variables needed for analysis
keep sex age edu11 racethn income relig cregion year month weight ideo party trust11
*save "...\pewtrust_11.dta", replace


*************************************************
*7. RECODING OF "Pew Research Center For The People & The Press September 2010 Political-Independents Survey"
*File name: "Sept10 public.sav"

*DEMOGRAPHICS
*gender
fre sex
*age
fre age
*education
gen edu10 = edu // 7 cat + 9 dk
label values edu10 educ
fre edu10
*race
fre racethn
*income
fre income
*religion
fre relig 
*census
fre cregion

*TRUST, IDEO, PID
*trust
fre q29 
gen trust10sept=q29
label values trust10sept q29
fre trust10sept
*ideology
fre ideo
*partisanship
fre party

*OTHER
*year
gen year = 2010
*month
gen month = 9
*weight
sum weight

*Keep only variables needed for analysis
keep sex age edu10 racethn income relig cregion year month weight ideo party trust10sept
*save "...\pewtrust_10sept.dta", replace


*************************************************
*8. RECODING OF "Pew Research Center For The People & The Press March 2010 Trust In Government Survey"
*File name: "Mar10 Trust public.sav"

*DEMOGRAPHICS
*gender
fre sex 
*age
fre age 
*education
fre edu
gen edu10 = edu 
*race
fre racethn
*income
fre income
*religion
fre relig 
*census
fre cregion

*TRUST, IDEO, PID
*trust
fre q21
gen trust10mar=q21
label values trust10mar q21
fre trust10mar
*ideology
fre ideo 
*partisanship
fre party 

*OTHER
*year
gen year = 2010
*month
gen month = 3
*weight
sum weight

*Keep only variables needed for analysis
keep sex age edu10 racethn income relig cregion year month weight ideo party trust10mar
save "C:\Users\davidem83\Dropbox\01.PAPERS\00. Under review\2015 - President in power\Data\PEW\TRUST\STATA\pewtrust_10mar.dta", replace


*************************************************
*9. RECODING OF "Pew Research Center For The People & The Press December 2006 Values Update Survey"
*File name: "Values07c.sav"

*DEMOGRAPHICS
*gender
fre sex
*age
fre age
*education
fre edu
gen edu10 = edu
*race
fre racethn 
*income
fre income
*religion
fre relig
gen relig06 = relig
label de relig06 1"protestant" 2"catholic" 3"jewish"
label values relig06 relig06
fre relig06
*census
fre cregion

*TRUST, IDEO, PID
*trust
fre q15 
gen trust06=q15
label values trust06 q15
fre trust06
*ideology
fre ideo 
*partisanship
fre party 

*OTHER
*year
gen year = 2006
*month
gen month = 12
*weight
sum weight

*Keep only variables needed for analysis
keep sex age edu10 racethn income relig06 cregion year month weight ideo party trust06
*save "...\pewtrust_07.dta", replace


*****************************************************
*****************************************************
*CREATE COMBINED DATASET

/*use "pewtrust_17.dta", clear
append using "pewtrust_15.dta"
append using "pewtrust_14.dta"
append using "pewtrust_13oct.dta"
append using "pewtrust_13jan.dta"
append using "pewtrust_11.dta"
append using "pewtrust_10sept.dta"
append using "pewtrust_10mar.dta"
append using "pewtrust_07.dta"

save "pew_combined_2006-2017.dta", replace*/


*****************************************************
*****************************************************
*RECODE COMBINED DATASET

*use "pew_combined_2006-2017.dta", clear

*************
*DEMOGRAPHICS

*gender
fre sex

*age
fre age
recode age 99=., gen(age_r) // 511 observations deleted

*education
fre edu17 edu15 edu14 edu13oct edu13jan edu11 edu10
gen edu = edu17 if edu17!=.
replace edu = edu15 if edu15!=.
replace edu = edu14 if edu14!=.
replace edu = edu13oct if edu13oct!=.
replace edu = edu13jan if edu13jan!=.
replace edu = edu11 if edu11!=.
replace edu = edu10 if edu10!=.
recode edu  (1 2=1 "Grade 12 (high school) no diploma or below") (3=2 "High school graduate") (4 5=3 "Some college") (6/8=4 "College, advanced") (9=.), gen(edu4)
fre edu4

*ethnicity - afro-american
fre racethn
recode racethn (2=1 "black") (else=0 "other"), gen(black)
ta black

*income - quintiles
fre income
xtile income5 = income if income<10, nq(5)
replace income5 = 6 if income>9
ta income5
label de income5 1"1st quintile" 2"2nd quintile" 3"3rd quintile" 4"4th quintile" 5"5th quintile" 6"DK/refused"
label values income5 income5
ta income5

*religion
fre relig relig06
gen relig4 = 4
replace relig4 = 1 if (relig==1 | relig06==1)
replace relig4 = 2 if (relig==2 | relig06==2)
replace relig4 = 3 if (relig==5 | relig06==3)
label de relig4 1"protestant" 2"catholic" 3"jewish"  4"other/dk/none"
label values relig4 relig4
fre relig4

*census area
fre cregion

***********
*TRUST
fre trust*
gen trust_all = trust17 if trust17!=.
replace trust_all = trust15 if trust15!=.
replace trust_all = trust14 if trust14!=.
replace trust_all = trust13oct if trust13oct!=.
replace trust_all = trust13jan if trust13jan!=.
replace trust_all = trust11 if trust11!=.
replace trust_all = trust10sept if trust10sept!=.
replace trust_all = trust10mar if trust10mar!=.
replace trust_all = trust06 if trust06!=.
label var trust_all "How much of the time R trust govt to do what is right"
label de trust 1 "Just about always" 2 "Most of the time" 3 "Some of the time" 4 "Never" 9 "DK/Refused"
label values trust_all trust
fre trust_all
*recoded from 0 to 1
gen trust01 = ((-trust_all)+4)/3 if trust_all<9
label var trust01 "How much of the time R trust govt to do what is right"
label de trust01 0 "Never" 1"Just about always"
label values trust01 trust01
ta trust01

***********
*IDEOLOGY, PARTY ID

*Ideology - 5 categories
fre ideo
*Ideology - 3 categories
recode ideo (1 2=3 "Conservative") (3=2 "moderate") (3 9=.) (4 5=1 "Liberal"), gen(ideo3)
fre ideo3
*Ideology - 2 categories
recode ideo (1 2=2 "Conservative") (3 9=.) (4 5=1 "Liberal"), gen(ideo2)
fre ideo2

*party ID
fre party
*3 categories
recode party (2=1 "Democrat") (3=2 "independent") (1=3 "Republican") (else=.), gen(party3)
fre party3
*2 categories
recode party (2=1 "Democrat") (1=2 "Republican") (else=.), gen(party2)
fre party2

***********
*PRESIDENT IN POWER

*DEMOCRATIC/REPUBLICAN PRES
fre year
gen prespower = 1 if (year>2006 & year<2017)
replace prespower = 2 if year==2006 | year==2017
label var prespower "President in power at time of survey"
label de prespower 1"Democrat (Obama)" 2"Republican (Bush/Trump)"
label values prespower prespower
fre prespower // 1 dem, 2 rep
ta year prespower

*PRESIDENT WITH SAME IDEOLOGY AS RESPONDENT
fre prespower ideo2
*Liberals
gen ownpresL = prespower if ideo2==1
ta ownpresL
recode ownpresL 2=0 .=0
*Conservatives
gen ownpresC = prespower if ideo2==2
ta ownpresC
recode ownpresC 2=1 1=0 .=0
*Combined
gen ownpresLC = ownpresL + ownpresC if (ideo2==1 | ideo2==2) & (prespower==1 | prespower==2)
label variable ownpresLC "President with same ideology as R"
label define ownpresLC 0"Other ideology" 1"Same ideology"
label values ownpresLC ownpresLC
fre ownpresLC
ta ideo2 prespower
ta ideo2 ownpresLC

*PRESIDENT FROM SAME PARTY AS RESPONDENT
fre prespower party2
*Democrats
gen ownpresD = prespower if party2==1
ta ownpresD
recode ownpresD 2=0 .=0
*Republicans
gen ownpresR = prespower if party2==2
ta ownpresR
recode ownpresR 2=1 1=0 .=0
*combined
gen ownpresDR = ownpresD + ownpresR if (party2==1 | party2==2) & (prespower==1 | prespower==2)
label variable ownpresDR "President from party same party as R"
label define ownpresDR 0"Other party" 1"Same party"
label values ownpresDR ownpresDR
fre ownpresDR
ta party2 prespower
ta party2 ownpresDR

**********
*OTHER

*Time (months)
/*0	dec	2006	December 2006 Values Update Survey
39	mar	2010	March 2010 Trust In Government Survey
45	sep	2010	September 2010 Political-Independents Survey
56	aug	2011	August 2011 Political Survey
73	jan	2013	January 2013 Political Survey
82	oct	2013	October 2013 Political Survey
85	jan	2014	2014 Political Polarization and Typology Survey
104	aug	2015	2015 Governance Survey
124	apr	2017	April 2017 Political Survey*/
gen time = 0 if year==2006
replace time=39 if year==2010 & month==3
replace time=45 if year==2010 & month==9
replace time=56 if year==2011
replace time=73 if year==2013 & month==1
replace time=82 if year==2013 & month==10
replace time=85 if year==2014
replace time=104 if year==2015
replace time=124 if year==2017
label var time "Progressive n. of months(dec 2016=0)
ta time

*weight
sum weight

**************
*Save recoded dataset
*save "pew_combined_2006-2017_recoded.dta"


















