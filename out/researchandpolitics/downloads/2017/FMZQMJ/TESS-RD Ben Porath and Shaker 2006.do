*******************************************************************************************************************************
*******************************************************************************************************************************
* Documentation for Reproduction of
* Ben Porath and Shaker 2006 TESS Survey Experiment
* TESS Race Discrimination Meta-Analysis
* Stata version 15
* Data available here: http://www.tessexperiments.org/data/ben-porath475.html
*******************************************************************************************************************************
*******************************************************************************************************************************

* use "TESS_79_Client.dta", clear
set more off

*******************************************************************************************************************************
*** Racial groups
*******************************************************************************************************************************

tab PPETHM
gen whiteR = PPETHM
gen blackR = PPETHM
tab PPETHM, nol
recode whiteR (2=0)
recode blackR (1=0) (2=1)
tab PPETHM whiteR
tab PPETHM blackR

*******************************************************************************************************************************
*** Treatments
*******************************************************************************************************************************

tab PICTURE
tab PICTURE, gen(cond)
rename cond1 blackindivT
rename cond2 blackgroupT
rename cond3 whiteindivT
rename cond4 whitegroupT
rename cond5 controlT
tab PICTURE blackindivT
tab PICTURE blackgroupT
tab PICTURE whiteindivT
tab PICTURE whitegroupT
tab PICTURE controlT

gen individualT=0
gen groupT = 0
gen whiteT = 0
gen blackT = 0
replace individualT = 1 if blackindivT==1 | whiteindivT==1
replace groupT = 1 if blackgroupT==1 | whitegroupT==1
replace whiteT = 1 if whiteindivT==1 | whitegroupT==1
replace blackT = 1 if blackindivT==1 | blackgroupT==1

*******************************************************************************************************************************
*** Outcome variables
*******************************************************************************************************************************

tab1 Q2-Q15
tab1 Q2-Q15, nol
recode Q2-Q15 (-1=.)
tab Q16_3_1
recode Q16_3_1 (-1=.)
alpha Q2-Q15 Q16_3_1, item
pwcorr Q16_3_1 Q2-Q15
alpha Q2-Q15 Q16_3_1, item std min(8) gen(ALPHA)
tab Q3
pwcorr ALPHA Q3

sum ALPHA if whiteR==1
di r(sd)
gen ov_white_std = ALPHA/r(sd) if whiteR==1

sum ALPHA if blackR==1
di r(sd)
gen ov_black_std = ALPHA/r(sd) if blackR==1

*******************************************************************************************************************************
*** Racial manipulation check
*******************************************************************************************************************************

// No racial manipulation check

*******************************************************************************************************************************
*** Main regressions [Unweighted]
*******************************************************************************************************************************

reg ov_white_std whiteT individualT if controlT==0 & whiteR==1
reg ov_black_std whiteT individualT if controlT==0 & blackR==1
