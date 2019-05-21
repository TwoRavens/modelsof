****************************************************************************************************
***  PROJECT:  "Language Influences Public Attitudes Toward Gender Equality," Journal of Politics
***  AUTHORS: Efren O. Perez and Margit Tavits
***  DESCRIPTION: Stata code to replicate analyses of Study 2.
***  DATE: October 22, 2017
****************************************************************************************************

clear
set more off

***Call up Study 2 data
***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME IN THE CODE BELOW
use "Study2_data.dta", clear


**********************
**********************
***PREPARE THE DATA***
**********************
**********************

********************************
***Code pre-treatment variables
********************************

***Age, continuous
gen age=old

***Gender, 1=female
gen female=0
recode female (0=1) if sex==1

***Education, dichotomous, 1=some college
gen college=0
recode college (0=1) if edlevel==4
recode college (0=1) if edlevel==5

***First language learned, 1=Russian, 0=all others
gen firstruss=0
recode firstruss (0=1) if firstl==1

***preferred interview language, 1=prefer Russian, 0=prefer Estonian
gen prefruss=0
recode prefruss (0=1) if prefl==2


************************************************************
***Code treatment variable
************************************************************
***language of interview (LOI), 1=Estonian, 0=Russian
gen eston=0
recode eston (0=1) if interviewl==1

****************************
***Code dependent variables
****************************

***Female defense minister
rename defensemin defensefem
recode defensefem (2=0)

***Paternity leave
rename leave paternity
recode paternity (2=0)

***Female political recruitment
rename politicalrecruit recruitfem

***************************************
***************************************
***RESULTS REPORTED IN THE MAIN TEXT***
***************************************
***************************************

***********************************
***Table 2, replication
***********************************

probit defensefem eston
probit paternity eston
oprobit recruitfem eston 

***Dichotomize 'recruitfem'
gen recruitfem2=.
recode recruitfem2 (.=0) if recruitfem==1
recode recruitfem2 (.=0) if recruitfem==2
recode recruitfem2 (.=1) if recruitfem==3
recode recruitfem2 (.=1) if recruitfem==4

***Combine all DVs
gen femscale1=(defensefem+paternity+recruitfem2)
gen femscale=(femscale1/3)

**Compute average tetrachoric correlation for items in 'femscale'
tetrachoric defensefem paternity recruitfem2

***Run the analysis with the scale, reported in the main text
oprobit femscale eston

***********************************
***Table 2, placebo
***********************************
gen suicide=justifiedsuicide
reg suicide eston

***********************************
***Table 2, social norms experiment
***********************************

gen ptyldrs=partyleaders
gen ptyldrs80=partyleadersnorm

oprobit ptyldrs eston
oprobit ptyldrs80 eston


*********************************************
*********************************************
***RESULTS REPORTED IN THE ONLINE APPENDIX***
*********************************************
*********************************************

*****************************************************
***Randomization and balance check, reported in OA.6
*****************************************************

***Randomization check
probit eston college female age firstruss prefruss
test college female age firstruss prefruss

***Descriptive information for each pre-treatment variable under analysis, by interview language
tab college if eston==0
tab college if eston==1

tab female if eston==0
tab female if eston==1

summ age if eston==0, detail
summ age if eston==1, detail

tab firstruss if eston==0
tab firstruss if eston==1

tab prefruss if eston==0
tab prefruss if eston==1

**Balance check
tab college eston, chi2
tab female eston, chi2
ranksum age, by(eston)
tab firstruss eston, chi2
tab prefruss eston, chi2

********************************************************************************
***Language Effects Adjusted for Preferred Interview Language, reported in OA.6
********************************************************************************

probit paternity eston prefruss
probit defensefem eston prefruss
oprobit recruitfem eston prefruss
