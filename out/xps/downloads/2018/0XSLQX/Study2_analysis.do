****************************************************************************************************************************
***  PROJECT:  "Language Heightens the Political Salience of Ethnic Divisions", Journal of Experimental Political Science
***  AUTHORS: Efren O. Perez and Margit Tavits
***  DESCRIPTION: Stata code to replicate results from Study 2
***  DATE: June 6, 2018
****************************************************************************************************************************


********************************************************
**Section 1: setting up the data for the analysis ******
********************************************************

set more off

*** Generate "age"
gen age=how_old 

***Generate "Russian as first language"
gen russfirst=0
recode russfirst (0=1) if first_lg==1
tab russfirst

***Generate "female"
gen female=0
recode female (0=1) if gender==1
tab female

***Generate "Prefer russian interview"
gen prefruss=0
recode prefruss (0=1) if preferred_lg==2
tab prefruss

***Generate "education"
gen edu=education

***Generate "ideology"
generate ideology = ideol
replace ideology = . if ideol==11
replace ideology = . if ideol==12
replace ideology = . if ideol==13

***Generate ideology dummies for "left," "right," and "center," with others as baseline
gen left=0
recode left 0=1 if ideol==0
recode left 0=1 if ideol==1
recode left 0=1 if ideol==2
recode left 0=1 if ideol==3
recode left 0=1 if ideol==4

gen right=0
recode right 0=1 if ideol==6
recode right 0=1 if ideol==7
recode right 0=1 if ideol==8
recode right 0=1 if ideol==9
recode right 0=1 if ideol==10

gen center=0
recode center 0=1 if ideol==5

***Generate "assigned interview language" (treatment)
gen eston=0
recode eston (0=1) if assigned_lg==1

gen russian=0
recode russian (0=1) if assigned_lg==2

***Generate "nationalist"
generate nationalist=parties
recode nationalist (1 2 4 = 0)(3=1)


****************************************************
**Section 2: Analyses in the main text and SI ******
****************************************************

***Table 1, main text
***Model 3
logit nationalist russian

**Calculate substantive effects and p-values for main text
logit nationalist i.russian
margins russian
margins, dydx(russian)

***Model 4
logit nationalist russian prefruss

*************************
***Results in the SI ****
*************************

***Table SI.2.4: balance check
by eston, sort : summarize edu, detail
ranksum educ, by(eston)

by eston, sort : summarize female
tab female eston, chi2

by eston, sort : summarize age, detail
ranksum age, by(eston)

by eston, sort : summarize left
tab left eston, chi2

by eston, sort : summarize right
tab right eston, chi2

by eston, sort : summarize center
tab center eston, chi2

by eston, sort : summarize russfirst
tab russfirst eston, chi2

by eston, sort : summarize prefruss
tab prefruss eston, chi2

**Table SI.2.5: randomization check
summ eston age educ female left right center russfirst prefruss
probit eston educ female age left right center russfirst prefruss
test educ female age left right center russfirst prefruss

***Table SI.2.6: robustness to covariates
logit nationalist russian prefruss age


***Table SI.2.7 Mismatched interview

gen mismatched=.
recode mismatched(.=0) if russian==1 & prefruss==1
recode mismatched(.=0) if russian==0 & prefruss==0

recode mismatched (.=1) if russian==1 & prefruss==0
recode mismatched (.=1) if russian==0 & prefruss==1

logit nationalist russian mismatched


***Table SI.5.1, adjusting for generational differences
gen adult91=0
recode adult91(0=1) if age<=41
tab adult91

logit nationalist russian 
logit nationalist russian adult91

**Table SI.7.1, exploring heterogeneous treatment effects

gen russprefruss=(russian*prefruss)
logit nationalist russian prefruss russprefruss

