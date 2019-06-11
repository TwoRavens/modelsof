****************************************************************************************************************************
***  PROJECT:  "Language Heightens the Political Salience of Ethnic Divisions", Journal of Experimental Political Science
***  AUTHORS: Efren O. Perez and Margit Tavits
***  DESCRIPTION: Stata code to replicate results from Study 1
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

***Generate "education" and "college"
gen edu=education

gen college=0
recode college (0=1) if edu==4
recode college (0=1) if edu==5
tab college

***Generate "assigned interview language" (treatment)
gen eston=0
recode eston (0=1) if assigned_lg==1

gen russian=0
recode russian (0=1) if assigned_lg==2

***Generate "Importance of integration"
generate integration = 1
recode integration 1=4 if issue_a==3
recode integration 1=3 if issue_b==3
recode integration 1=2 if issue_c==3
summarize integration


****************************************************
**Section 2: Analyses in the main text and SI ******
****************************************************

***Table 1, main text
***Model 1
ologit integration russian

***Calculate substantive effects and p-values for main text
ologit integration i.russian
margins russian, predict(outcome(1))
margins, dydx(russian) predict(outcome(1))

***Model 2
ologit integration russian prefruss 

*************************
***Results in the SI ****
*************************

***Table SI.2.2: balance check

by eston, sort : summarize college
tab college eston, chi2

by eston, sort : summarize female
tab female eston, chi2

by eston, sort : summarize age, detail
ranksum age, by(eston)

by eston, sort : summarize russfirst
tab russfirst eston, chi2

by eston, sort : summarize prefruss
tab prefruss eston, chi2


***Table SI.2.3, randomization check

probit eston college female age russfirst prefruss
test college female age russfirst prefruss 

***Table SI.2.6, robustness to covariates

ologit integration russian prefruss age

***Table SI.2.7 Mismatched interview

gen mismatched=.
recode mismatched(.=0) if russian==1 & prefruss==1
recode mismatched(.=0) if russian==0 & prefruss==0

recode mismatched (.=1) if russian==1 & prefruss==0
recode mismatched (.=1) if russian==0 & prefruss==1

ologit integration russian mismatched

***Table SI.4.1, full results for Model 1 in the main text
ologit integration russian

***Table SI.5.1, adjusting for generational differences

gen adult91=0
recode adult91(0=1) if age<=43
tab adult91

ologit integration russian 
ologit integration russian adult91

**Table SI.7.1, exploring heterogeneous treatment effects

gen russprefruss=(russian*prefruss)

ologit integration russian
ologit integration russian prefruss russprefruss

