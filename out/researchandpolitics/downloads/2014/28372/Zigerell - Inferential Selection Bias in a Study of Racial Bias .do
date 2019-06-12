*******************************************************************************************************************************
* Documentation for Reproduction of
* Inferential Selection Bias in a Study of Racial Bias: Revisiting "Working Twice as Hard to Get Half as Far"
* L.J Zigerell
* Stata version 11
* Based on code by Christopher D. DeSante
* See here for the original article (DeSante 2013): http://onlinelibrary.wiley.com/doi/10.1111/ajps.12006/abstract
* See here for data from the original article: https://thedata.harvard.edu/dvn/dv/ajps/faces/study/StudyPage.xhtml?studyId=87407&versionNumber=1
*******************************************************************************************************************************
*******************************************************************************************************************************


use "desante_experimental_data.dta", clear
set more off


*******************************************************************************************************************************
** Racial distribution of respondents
*******************************************************************************************************************************

tab v211


*******************************************************************************************************************************
** Produce Table 1 for Zigerell manuscript
*******************************************************************************************************************************

tabstat app1 app2 app3, by(treatment) stats(mean)
tabstat app1 app2 app3, by(treatment) stats(mean) format(%9.0f)
tabstat app1 app2 app3, by(treatment) stats(n)


*******************************************************************************************************************************
** Reproduce and extend t-tests from Table 2 of DeSante (2013)
*******************************************************************************************************************************

** Test 1
ttest app1 if treatment== 1 | treatment== 2, by(treatment) // DeSante test
ttest app2 if treatment== 1 | treatment== 3, by(treatment) // Zigerell test


** Test 1 Combined
gen numb = _n
gen es  = .
gen ci1 = .
gen ci2 = .
gen ser = .

replace es  = -65.18714 if numb == 1 // Effect size from DeSante test 1
replace ci1 = -140.6805 if numb == 1 // Bottom ci end from DeSante test 1
replace ci2 =  10.30622 if numb == 1 // Top ci end from DeSante test 1
replace ser =   38.2616 if numb == 1 // Standard error from DeSante test 1

replace es  = -23.21123 if numb == 2 // Effect size from Zigerell test 1
replace ci1 = -100.7999 if numb == 2 // Bottom ci end from Zigerell test 1
replace ci2 =  54.37738 if numb == 2 // Top ci end from Zigerell test 1
replace ser =  39.31761 if numb == 2 // Standard error from Zigerell test 1

sum es // Simple mean of effect sizes
metan es ci1 ci2, fixed  nograph // Meta-analysis combination of effect sizes using cis FIXED EFFECTS
metan es ci1 ci2, random nograph // Meta-analysis combination of effect sizes using cis RANDOM EFFECTS
metan es ser, nograph // Meta-analysis combination of effect sizes using std errors
drop es ci1 ci2 ser


** Test 2
ttest app2 if treatment== 1 | treatment== 2, by(treatment) // DeSante test
ttest app1 if treatment== 1 | treatment== 3, by(treatment) // Zigerell test


** Test 2 Combined
gen es  = .
gen ci1 = .
gen ci2 = .
gen ser = .

replace es  = 178.595  if numb == 1 // Effect size from DeSante test 2
replace ci1 = 101.3857 if numb == 1 // Bottom ci end from DeSante test 2
replace ci2 = 255.8043 if numb == 1 // Top ci end from DeSante test 2
replace ser = 39.13128 if numb == 1 // Standard error from DeSante test 2

replace es  = 67.48474 if numb == 2 // Effect size from Zigerell test 2
replace ci1 = -8.82746 if numb == 2 // Bottom ci end from Zigerell test 2
replace ci2 = 143.7969 if numb == 2 // Top ci end from Zigerell test 2
replace ser = 38.67079 if numb == 2 // Standard error from Zigerell test 2

sum es // Simple mean of effect sizes
metan es ci1 ci2, fixed  nograph // Meta-analysis combination of effect sizes using cis FIXED EFFECTS
metan es ci1 ci2, random nograph // Meta-analysis combination of effect sizes using cis RANDOM EFFECTS
metan es ser, fixed nograph // Meta-analysis combination of effect sizes using std errors
drop es ci1 ci2 ser


** Test 3
ttest app1 if treatment== 7 | treatment==10, by(treatment) // DeSante test


** Test 4
ttest app2 if treatment== 4 | treatment== 7, by(treatment) // DeSante test


** Test 3 and 4 [Zigerell]
ttest app1 == app2 if treatment==7 // Zigerell test


** Tests 3 and 4 combined
gen es  = .
gen ci1 = .
gen ci2 = .
gen ser = .

replace es  =  9.285714 if numb == 1 // Effect size from DeSante test 3
replace ci1 =  -47.4859 if numb == 1 // Bottom ci end from DeSante test 3
replace ci2 =  66.05733 if numb == 1 // Top ci end from DeSante test 3
replace ser =  28.83285 if numb == 1 // Standard error from DeSante test 3

replace es  = -12.02021 if numb == 2 // Effect size from DeSante test 4
replace ci1 = -70.83125 if numb == 2 // Bottom ci end from DeSante test 4
replace ci2 =  46.79084 if numb == 2 // Top ci end from DeSante test 4
replace ser =  29.85674 if numb == 2 // Standard error from DeSante test 4

replace es  = -43.99248 if numb == 3 // Effect size from Zigerell test 3/4
replace ci1 = -66.75688 if numb == 3 // Bottom ci end from Zigerell test 3/4
replace ci2 = -21.22809 if numb == 3 // Top ci end from Zigerell test 3/4
replace ser =  11.50822 if numb == 3 // Standard error from Zigerell test 3/4

sum es // Simple mean of effect sizes
metan es ci1 ci2, fixed  nograph // Meta-analysis combination of effect sizes using cis FIXED EFFECTS
metan es ci1 ci2, random nograph // Meta-analysis combination of effect sizes using cis RANDOM EFFECTS
metan es ser, fixed nograph // Meta-analysis combination of effect sizes using std errors
drop es ci1 ci2 ser


** Test 5
ttest app2 if treatment== 4 | treatment== 6, by(treatment) // DeSante test


** Test 6
ttest app2 if treatment== 7 | treatment== 9, by(treatment) // DeSante test


** Test 7 [equivalent to the DeSante test]
gen excellent2 = 0
replace excellent2 = 1 if treatment == 6 | treatment == 9
gen black2 = 0
replace black2 = 1 if treatment == 7 | treatment == 9
gen black2Xexcellent2 = black2 * excellent2
reg app2 excellent2 black2 black2Xexcellent2 if treatment == 4 | treatment == 6 | treatment == 7 | treatment == 9 // DeSante test 7
drop black2


** Test 5, 6, 7 [Zigerell]
ttest app1 if treatment== 7 | treatment== 8, by(treatment) // Zigerell test 5
ttest app1 if treatment==10 | treatment==11, by(treatment) // Zigerell test 6

gen excellent1 = 0
replace excellent1 = 1 if treatment == 8 | treatment == 11
gen black1 = 0
replace black1 = 1 if treatment == 10 | treatment == 11
gen black1Xexcellent1 = black1 * excellent1
reg app1 excellent1 black1 black1Xexcellent1 if treatment == 7 | treatment == 8 | treatment ==10 | treatment ==11 // Zigerell test 7
drop black1


** Test 7 Combined
gen es  = .
gen ci1 = .
gen ci2 = .
gen ser = .

replace es  = -116.1436 if numb == 1 // Effect size from DeSante test 7
replace ci1 =   -221.9  if numb == 1 // Bottom ci end from DeSante test 7
replace ci2 =  -10.3872 if numb == 1 // Top ci end from DeSante test 7
replace ser =  53.7799  if numb == 1 // Standard error from DeSante test 7

replace es  =  16.36905 if numb == 2 // Effect size from Zigerell test 7
replace ci1 = -87.96135 if numb == 2 // Bottom ci end from Zigerell test 7
replace ci2 =  120.6994 if numb == 2 // Top ci end from Zigerell test 7
replace ser =  53.06516 if numb == 2 // Standard error from Zigerell test 7

sum es // Simple mean of effect sizes
metan es ci1 ci2, fixed  nograph // Meta-analysis combination of effect sizes using cis FIXED EFFECTS
metan es ci1 ci2, random nograph // Meta-analysis combination of effect sizes using cis RANDOM EFFECTS
metan es ser, fixed nograph // Meta-analysis combination of effect sizes using std errors
drop es ci1 ci2 ser


** Test 8
ttest app2 if treatment== 4 | treatment== 5, by(treatment) // DeSante test


** Test 9
ttest app2 if treatment== 7 | treatment== 8, by(treatment) // DeSante test


** Test 10 [equivalent to the DeSante test]
drop black2
gen poor2 = 0
replace poor2 = 1 if treatment == 5 | treatment == 8
gen black2 = 0
replace black2 = 1 if treatment == 7 | treatment == 8
gen black2Xpoor2 = black2 * poor2
reg app2 poor2 black2 black2Xpoor2 if treatment == 4 | treatment == 5 | treatment == 7 | treatment == 8 // DeSante test 10
drop black2


** Test 8, 9, 10 [Zigerell]
ttest app1 if treatment== 7 | treatment== 9, by(treatment) // Zigerell test
ttest app1 if treatment==10 | treatment==12, by(treatment) // Zigerell test

drop black1
gen poor1 = 0
replace poor1 = 1 if treatment == 9 | treatment == 12
gen black1 = 0
replace black1 = 1 if treatment == 10 | treatment == 12
gen black1Xpoor1 = black1 * poor1
reg app1 poor1 black1 black1Xpoor1 if treatment == 7 | treatment == 9 | treatment ==10 | treatment ==12 // Zigerell test 7
drop black1


** Test 10 Combined
gen es  = .
gen ci1 = .
gen ci2 = .
gen ser = .

replace es  = -92.06282 if numb == 1 // Effect size from DeSante test 10
replace ci1 = -199.0021 if numb == 1 // Bottom ci end from DeSante test 10
replace ci2 =  14.87648 if numb == 1 // Top ci end from DeSante test 10
replace ser = 54.37844  if numb == 1 // Standard error from DeSante test 10

replace es  = -56.00121 if numb == 2 // Effect size from Zigerell test 10
replace ci1 = -163.8136 if numb == 2 // Bottom ci end from Zigerell test 10
replace ci2 =  51.81122 if numb == 2 // Top ci end from Zigerell test 10
replace ser =  54.83708 if numb == 2 // Standard error from Zigerell test 10

sum es // Simple mean of effect sizes
metan es ci1 ci2, fixed  nograph // Meta-analysis combination of effect sizes using cis FIXED EFFECTS
metan es ci1 ci2, random nograph // Meta-analysis combination of effect sizes using cis RANDOM EFFECTS
metan es ser, fixed nograph // Meta-analysis combination of effect sizes using std errors
drop es ci1 ci2 ser


** Test 11
gen white2black2 = .
replace white2black2 = 1 if treatment== 4 | treatment== 5 | treatment== 6
replace white2black2 = 0 if treatment==10 | treatment==11 | treatment==12
ttest app3, by(white2black2) // DeSante 

sum app3 if treatment==  1 | treatment==  2 | treatment==  3
sum app3 if treatment==  4 | treatment==  5 | treatment==  6
sum app3 if treatment==  7 | treatment==  8 | treatment==  9
sum app3 if treatment== 10 | treatment== 11 | treatment== 12

gen white2whiteblack = .
replace white2whiteblack = 1 if treatment== 4 | treatment== 5 | treatment== 6
replace white2whiteblack = 0 if treatment== 7 | treatment== 8 | treatment== 9
ttest app3, by(white2whiteblack) // Zigerell test

gen black2whiteblack = .
replace black2whiteblack = 1 if treatment== 10 | treatment== 11 | treatment== 12
replace black2whiteblack = 0 if treatment==  7 | treatment==  8 | treatment==  9
ttest app3, by(black2whiteblack) // Zigerell test


*******************************************************************************************************************************
** Reproduce and extend racial resentment analysis from Table 3 of DeSante (2013)
*******************************************************************************************************************************

** Conservative
tab v243
tab v243, nol
gen consv = v243-1
tab consv
recode consv (5=.)
tab consv


** Republican
tab V212d
tab V212d, nol
gen gop = V212d - 1
tab gop
recode gop (7=.)
tab gop


** Income
tab v246
tab v246, nol
gen hhincome = v246-1
tab hhincome
recode hhincome (14=.)
tab hhincome


** Education
tab v213
tab v213, nol
gen educ = v213-1
tab educ


** Age
tab v207
tab v207, nol
gen age = 2010 - v207
tab age


** Sex
tab v208
tab v208, nol
gen female = v208-1
tab v208


** Racial resentment
tab dkd321
tab dkd321, nol
gen resent1 = (5 - dkd321) / 4
tab resent1

tab dkd322
tab dkd322, nol
gen resent2 = (dkd322 - 1) / 4
tab resent2

tab dkd323
tab dkd323, nol
gen resent3 = (5 - dkd323) / 4
tab resent3

tab dkd324
tab dkd324
gen resent4 =(dkd324 - 1) / 4
tab resent4

gen rresent = .
replace rresent=(resent1 + resent2 + resent3 + resent4) / 4
tab rresent


pwcorr resent1 resent2 resent3 resent4 // this is to check whether the coding direction is correct


** Conditions
gen NN = 0 // conditions in which applicants were not given a name
replace NN=1 if treatment== 1 | treatment== 2 | treatment== 3

gen WW = 0 // conditions in which both applicants were given a white name
replace WW=1 if treatment== 4 | treatment== 5 | treatment== 6

gen WB = 0 // conditions in which one applicant was given a white name and the other applicant was given a black name
replace WB=1 if treatment== 7 | treatment== 8 | treatment== 9

gen BB = 0 // conditions in which both applicants were given a black name
replace BB=1 if treatment==10 | treatment==11 | treatment==12


** Interactions
gen rresentXNN = rresent * NN
gen rresentXWW = rresent * WW
gen rresentXWB = rresent * WB
gen rresentXBB = rresent * BB


** Race categories and number of observations
tab v211
tab v211, nol


** Sum variables
sum cons gop hhincome educ age female rresent NN WW WB BB


** Model 1 [DeSante]
reg app3 consv gop hhincome educ age female rresent if v211==1


** Model 2 [DeSante]
reg app3 consv gop hhincome educ age female rresent WW WB BB if v211==1


** Model 3 [DeSante]
reg app3 consv gop hhincome educ age female rresent WW WB BB rresentXWW rresentXWB rresentXBB if v211==1


** Model 4 (with BB omitted) [Zigerell]
reg app3 consv gop hhincome educ age female rresent WW WB NN rresentXWW rresentXWB rresentXNN if v211==1


** Model 5 (with all respondents) [Zigerell]
reg app3 consv gop hhincome educ age female rresent WW WB BB rresentXWW rresentXWB rresentXBB // This model was not reported in final version of manuscript.


*******************************************************************************************************************************
** Model 3 graphs
*******************************************************************************************************************************

reg app3 consv gop hhincome educ age female rresent WW WB BB rresentXWW rresentXWB rresentXBB if v211==1 // Model 3
sum app3 consv gop hhincome educ age female rresent WW WB BB rresentXWW rresentXWB rresentXBB if v211==1 // Model 3

di 58.08607*2.391608 + 3.608301*3.271739 + 9.544912*7.485757 + 7.977722*2.816245 + 2.604809*55.36618 + -7.452648*.4727031 + 551.4223*0 + 158.6181*1 + -11.82848*0 + 170.3414*0 + -337.9207*0 + -17.46587*0 + -196.4261*0 + -364.89 // two white applicants, no racial resentment
di 58.08607*2.391608 + 3.608301*3.271739 + 9.544912*7.485757 + 7.977722*2.816245 + 2.604809*55.36618 + -7.452648*.4727031 + 551.4223*1 + 158.6181*1 + -11.82848*0 + 170.3414*0 + -337.9207*1 + -17.46587*0 + -196.4261*0 + -364.89 // two white applicants, full racial resentment
di 392.6-179.1 // effect of RR for two white applicants = 213.5

di 58.08607*2.391608 + 3.608301*3.271739 + 9.544912*7.485757 + 7.977722*2.816245 + 2.604809*55.36618 + -7.452648*.4727031 + 551.4223*0 + 158.6181*0 + -11.82848*0 + 170.3414*1 + -337.9207*0 + -17.46587*0 + -196.4261*0 + -364.89 // two black applicants, no racial resentment
di 58.08607*2.391608 + 3.608301*3.271739 + 9.544912*7.485757 + 7.977722*2.816245 + 2.604809*55.36618 + -7.452648*.4727031 + 551.4223*1 + 158.6181*0 + -11.82848*0 + 170.3414*1 + -337.9207*0 + -17.46587*0 + -196.4261*1 + -364.89 // two black applicants, full racial resentment
di 545.8-190.8 // effect of RR for two black applicants = 355.0

di 58.08607*2.391608 + 3.608301*3.271739 + 9.544912*7.485757 + 7.977722*2.816245 + 2.604809*55.36618 + -7.452648*.4727031 + 551.4223*0 + 158.6181*0 + -11.82848*0 + 170.3414*0 + -337.9207*0 + -17.46587*0 + -196.4261*0 + -364.89 // two noname applicants, no racial resentment
di 58.08607*2.391608 + 3.608301*3.271739 + 9.544912*7.485757 + 7.977722*2.816245 + 2.604809*55.36618 + -7.452648*.4727031 + 551.4223*1 + 158.6181*0 + -11.82848*0 + 170.3414*0 + -337.9207*0 + -17.46587*0 + -196.4261*0 + -364.89 // two noname applicants, full racial resentment
di 571.9-20.4 // effect of RR for two noname applicants = 551.5

di 551.5-213.5 // difference in effect of RR (comparing two white applicants to two noname applicants) = $338 (same as RRxWW coefficient in model 3)
di 355.0-213.5 // difference in effect of RR (comparing two white applicants to two black applicants) = $141.5 (same as RRxWW coefficient in model 4)
