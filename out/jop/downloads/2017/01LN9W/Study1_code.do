****************************************************************************************************
***  PROJECT:  "Language Influences Public Attitudes Toward Gender Equality," Journal of Politics
***  AUTHORS: Efren O. Perez and Margit Tavits
***  DESCRIPTION: Stata code to replicate analyses of Study 1.
***  DATE: October 22, 2017
****************************************************************************************************

clear
set more off

***Call up Study 1 data
***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME IN THE CODE BELOW
use "Study1_data.dta", clear

**********************
**********************
***PREPARE THE DATA***
**********************
**********************

********************************
***Code pre-treatment variables
********************************

***age, continuous
rename old age

***education, treated as continuous
rename edlevel educ

***gender, 1=female
gen female=0
recode female 0=1 if sex==1

***ideology, dummies for left, right, and center, with others as baseline
gen left=0
recode left 0=1 if ideo==0
recode left 0=1 if ideo==1
recode left 0=1 if ideo==2
recode left 0=1 if ideo==3
recode left 0=1 if ideo==4

gen right=0
recode right 0=1 if ideo==6
recode right 0=1 if ideo==7
recode right 0=1 if ideo==8
recode right 0=1 if ideo==9
recode right 0=1 if ideo==10

gen center=0
recode center 0=1 if ideo==5

***first language learned, 1=Russian, 0=all others
gen firstruss=0
recode firstruss 0=1 if firstl==1

***preferred interview language, 1=prefer Russian, 0=prefer Estonian
gen prefruss=0
recode prefruss 0=1 if prefl==2


************************************************************
***Code treatment variable
************************************************************
***language of interview (LOI), 1=Estonian, 0=Russian
gen eston=0
recode eston 0=1 if interviewl==1


****************************
***Code dependent variables
****************************

***Female defense minister
rename defensemin defensefem
recode defensefem (2=0)

***Emotional women: Relative rating
*Emotional men
rename ratemen men
*Emotional women
rename ratewomen women
*Relative rating
gen emotional=(women-men)

***Paternity leave
rename leave paternity
recode paternity (2=0)

***Female political recruitment
rename politicalrecruit recruitfem
recode recruitfem (1=4)(2=3)(3=2)(4=1)


***************************************
***************************************
***RESULTS REPORTED IN THE MAIN TEXT***
***************************************
***************************************

***********************************
***Main results, Table 1, main text
***********************************

reg emotional eston
probit paternity eston
probit defensefem eston
oprobit recruitfem eston

**************************************************************************
***Main results, predicted probabilities reported in the text and Figure 1
**************************************************************************

probit paternity eston
prvalue, x(eston=0) level (95) delta save
prvalue, x(eston=1) level (95) delta diff

probit defensefem eston
prvalue, x(eston=0) level (95) delta save
prvalue, x(eston=1) level (95) delta diff

oprobit recruitfem eston
prvalue, x(eston=0) level (95) delta save
prvalue, x(eston=1) level (95) delta diff


*********************************************
*********************************************
***RESULTS REPORTED IN THE ONLINE APPENDIX***
*********************************************
*********************************************


************************************************************
***Perform randomization and balance check, reported in OA.2
************************************************************

***Randomization check
probit eston educ female age left right center firstruss prefruss
test educ female age left right center firstruss prefruss

***Descriptive information for each pre-treatment variable under analysis, by interview language
summ educ if eston==0, detail
summ educ if eston==1, detail

tab female if eston==0
tab female if eston==1

summ age if eston==0, detail
summ age if eston==1, detail

tab left if eston==0
tab left if eston==1

tab right if eston==0
tab right if eston==1

tab center if eston==0
tab center if eston==1

tab firstruss if eston==0
tab firstruss if eston==1

tab prefruss if eston==0
tab prefruss if eston==1

**Balance check
ranksum educ, by(eston)
tab female eston, chi2
ranksum age, by(eston)
tab left eston, chi2
tab right eston, chi2
tab center eston, chi2
tab firstruss eston, chi2
tab prefruss eston, chi2


********************************************************************************
***Language Effects Adjusted for Preferred Interview Language, reported in OA.3
********************************************************************************

reg emotional eston prefruss
probit paternity eston prefruss
probit defensefem eston prefruss
oprobit recruitfem eston prefruss


**************************************************************
***Gender-blind vs. pro-female bias analyses, reported in OA.4
**************************************************************

***Table OA.4.1
reg women eston
reg men eston

***Prepare DV "Female candidates: men's expense"
rename femalecand femcand
recode femcand (1=4)(2=3)(3=2)(4=1)

***Table OA.4.2
oprobit recruitfem eston
oprobit femcand eston

***Predicted probabilities for Figure OA.4.1
oprobit recruitfem eston
prvalue, x(eston=0) level (95) delta save
prvalue, x(eston=1) level (95) delta diff

oprobit femcand eston
prvalue, x(eston=0) level (95) delta save
prvalue, x(eston=1) level (95) delta diff


***************************************
***Test of boundary condition, reported in OA.5
***************************************

***Prepare the social norms items

***Buy sex
rename pimping buysex
recode buysex (2=0)

***Child suffers
rename workingmom childsuff
recode childsuff (2=0)

***Hit husband
rename justified hithusb
recode hithusb (2=0)

***Men better
rename politicalleader menbetter
recode menbetter (2=0)

***Table OA.5.1
probit buysex eston
probit childsuff eston
probit hithusb eston
probit menbetter eston

***Table OA.5.2
probit buysex eston age educ female
probit childsuff eston age educ female
probit hithusb eston age educ female
probit menbetter eston age educ female
