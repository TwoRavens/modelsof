*****************************************************************************************************************
* Data for the replication of RADIO PUBLIC SERVICE ANNOUNCEMENTS AND VOTER PARTICIPATION AMONG NATIVE AMERICANS: 
*	EVIDENCE FROM TWO FIELD EXPERIMENTS
* Eline A. de Rooij and Donald P. Green
* Political Behavior (POBE)
* Date: July 8, 2016
*****************************************************************************************************************

* The following analyses were carried out using Stata/SE 14.1 for Windows (64-bit x86-64) 

* CPS Nov 2012 data
* downloaded from http://www.nber.org/data/current-population-survey-data.html on Monday July 13 2015

* download .dta file into new personal folder and specify it as the working directory:
cd " " 
** NOTE: insert correct link to folder between " " 

* open data (from folder set as working directory):
use "CPSnov2012.dta"

drop if prpertyp==-1
* only keep those of 18 and older and who are citizens
recode prcitshp (1/4 =1 "citizen") (5=0 "not a citizen"), gen(citizen)
keep if citizen==1
keep if prtage>17

*** RECODES

* race/ethnicity
recode ptdtrace (-1=-1 "missing") (3=1 "American Indian, Alaskan Native only") (1=2 "White only") (2=3 "Black only") (4=4 "Asian only") (5=5 "Hawaiian, Pacific Islander only") (7 10 13 14 = 6 "2 race combi with AI") (6 8 9 11 12 15 16/26 = 7 "other combination"), gen(racetemp)
gen rac=.
replace rac=1 if racetemp==1
replace rac=2 if racetemp==2 & pehspnon==2
replace rac=3 if racetemp==3 & pehspnon==2
replace rac=4 if racetemp==2 & pehspnon==1
replace rac=4 if racetemp==3 & pehspnon==1
replace rac=5 if racetemp==4
replace rac=6 if racetemp==5
replace rac=7 if racetemp==6
replace rac=7 if racetemp==7
recode rac (1=1 "American Indian, Alaskan Native") (2=2 "White non-Hisp.") (3=3 "Black non-Hisp") (4=4 "White or Black Hisp.") (5=5 "Asian") (6 7 = 6 "Other"), gen(race)
label var race "Race, 6 categories"
drop racetemp rac
* note: "other" includes Hawaiian, Pacific Islander only and those of mixed race

** vote 2012
recode pes1 (-9/-1=.) (1=1 "voted") (2=0 "did not vote"), gen(vote2012)
label var vote2012 "vote GE2012 exl. missing"

* voter registration 2012: only asked of those who did not vote
gen votreg=.
replace votreg=-1 if pes2==-2
replace votreg=-1 if pes2==-3
replace votreg=-1 if pes2==-9
replace votreg=-1 if pes2==-1
replace votreg=1 if pes2==1
replace votreg=0 if pes2==2
replace votreg=1 if pes1==1
recode votreg (-1=.) (1=1 "registered to vote") (0=0 "not registered to vote"), gen(votreg2012)
label var votreg2012 "registered to vote GE2012 exl. missing"

* sex
recode pesex (2=0 "female") (1=1 "male"), gen(male)

* age: prtage - no recode

* education
recode peeduca (31/38 = 0 "Less than High School") (39/46=1 "High School or more"), gen(highschool) 

* household income: hefaminc - no recode

* nonmetropolitan area (<100,000)
recode gtmetsta (1 3=0 "metropolitan or not identified") (2=1 "nonmetropolitan"), gen(nonmetro)


**********************************************************************************
** TABLE A.1 IN APPENDIX: Socio-demographic characteristics, voter registration 
*	and voting, by race and ethnicity (citizens 18 and older only)
**********************************************************************************

svyset [pw=pwsswgt]

* % Men:
svy: tab race male, row

* Median age:
_pctile prtage [pw=pwsswgt] if race==1, p(25 50 75) 
return list
_pctile prtage [pw=pwsswgt] if race==2, p(25 50 75) 
return list
_pctile prtage [pw=pwsswgt] if race==3, p(25 50 75) 
return list
_pctile prtage [pw=pwsswgt] if race==4, p(25 50 75) 
return list
_pctile prtage [pw=pwsswgt] if race==5, p(25 50 75) 
return list
_pctile prtage [pw=pwsswgt] if race==6, p(25 50 75) 
return list

* % Highschool graduates:
svy: tab race highschool, row

* Median household income:
tab hefaminc
_pctile hefaminc [pw=pwsswgt] if race==1, p(25 50 75) 
return list
_pctile hefaminc [pw=pwsswgt] if race==2, p(25 50 75) 
return list
_pctile hefaminc [pw=pwsswgt] if race==3, p(25 50 75) 
return list
_pctile hefaminc [pw=pwsswgt] if race==4, p(25 50 75) 
return list
_pctile hefaminc [pw=pwsswgt] if race==5, p(25 50 75) 
return list
_pctile hefaminc [pw=pwsswgt] if race==6, p(25 50 75) 
return list

* % Nonmetropolitan:
svy: tab race nonmetro, row

* % Registered to vote:
svy: tab race votreg2012, row

* % Voted in 2012:
svy: tab race vote2012, row

svyset, clear

* UNWEIGHTED N:
tab race
tab race votreg2012
tab race vote2012


**********************************************************************************
** TABLE A.2 IN APPENDIX: Logistic regression predicting voter registration in 2012
*	with race/ethnicity and socio-demographic characteristics (citizens 18 and older only)
**********************************************************************************

*** UNWEIGHTED REGRESSION (incl. state dummies: gestcen)

* Model 1A:
logit votreg2012 i.race i.gestcen
logit, or
* Model 2A:
logit votreg2012 i.race male prtage nonmetro peeduca hefaminc i.gestcen
logit, or

*** WEIGHTED REGRESSION (incl. state dummies: gestcen)
svyset [pw=pwsswgt]

* Model 1B:
svy: logit votreg2012 i.race i.gestcen
svy: logit, or
* Model 2B:
svy: logit votreg2012 i.race male prtage nonmetro peeduca hefaminc i.gestcen
svy: logit, or

svyset, clear


**********************************************************************************
** TABLE A.3 IN APPENDIX: Logistic regression predicting voter turnout in 2012 
*	with race/ethnicity and socio-demographic characteristics (citizens 18 and older only)
**********************************************************************************

*** UNWEIGHTED REGRESSION (incl. state dummies: gestcen)

* Model 1A: 
logit vote2012 i.race i.gestcen
logit, or
* Model 2A:
logit vote2012 i.race male prtage nonmetro peeduca hefaminc i.gestcen
logit, or

*** WEIGHTED REGRESSION (incl. state dummies: gestcen)
svyset [pw=pwsswgt]

* Model 1B:
svy: logit vote2012 i.race i.gestcen
svy: logit, or
* Model 2B:
svy: logit vote2012 i.race male prtage nonmetro peeduca hefaminc i.gestcen
svy: logit, or

svyset, clear
