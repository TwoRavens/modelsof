* Date: February 8, 2019
* Description: Randomization tests for police study

clear


import excel "...\1903 JOP\police1.xlsx", sheet("Sheet1") firstrow


* Treatments

drop if treat_info==.

gen control1 = 0
replace control1 = 1 if treat_info==1

gen pattern = 0
replace pattern = 1 if treat_info==2

gen reform = 0
replace reform = 1 if treat_info==3


gen control2 = 0
replace control2 = 1 if treat_endorse==1
replace control2 = . if treat_endorse==0

gen lawendorse = 0
replace lawendorse = 1 if treat_endorse==2
replace lawendorse = . if treat_endorse==0


* Demograpic variables

gen white = 0
replace white = 1 if race==1
replace white = . if race==.

gen black = 0
replace black = 1 if race==2
replace black = . if race==.


gen college1 = 0
replace college1 = 1 if educ==4 | educ==5
replace college1 = . if educ==.

gen college2 = 0
replace college2 = 1 if educ==1 | educ==2
replace college2 = 2 if educ==3
replace college2 = 3 if educ==4 | educ==5
replace college2 = . if educ==.

gen republican = 0
replace republican = 1 if partyid==1
replace republican = . if partyid==.


gen losangeles = 0
replace losangeles = 1 if county=="los angeles"
replace losangeles = . if county==""

gen orange = 0
replace orange = 1 if county=="orange"
replace orange = . if county==""

gen riverside = 0
replace riverside = 1 if county=="riverside"
replace riverside = . if county==""

gen saccounty = 0
replace saccounty = 1 if county=="sacramento"
replace saccounty = . if county==""


* Table A11.  Randomization checks

tab treat_info

tab treat_endorse if treat_endorse!=.


* White

tab white

ttest white if (control1==1 | pattern==1), by(pattern)
ttest white if (control1==1 | reform==1), by(reform)

ttest white if (pattern==1 | reform==1), by(reform)


ttest white if treat_endorse!=., by(lawendorse)


* Black

tab black

ttest black if (control1==1 | pattern==1), by(pattern)
ttest black if (control1==1 | reform==1), by(reform)

ttest black if (pattern==1 | reform==1), by(reform)


ttest black if treat_endorse!=., by(lawendorse)


* College Degree

tab college1

ttest college1 if (control1==1 | pattern==1), by(pattern)
ttest college1 if (control1==1 | reform==1), by(reform)

ttest college1 if (pattern==1 | reform==1), by(reform)


ttest college1 if treat_endorse!=., by(lawendorse)


* Republican

tab republican

ttest republican if (control1==1 | pattern==1), by(pattern)
ttest republican if (control1==1 | reform==1), by(reform)

ttest republican if (pattern==1 | reform==1), by(reform)


ttest republican if treat_endorse!=., by(lawendorse)


* Ideological rating

tabstat ideo_rating, s(n mean sd)

ttest ideo_rating if (control1==1 | pattern==1), by(pattern)
ttest ideo_rating if (control1==1 | reform==1), by(reform)

ttest ideo_rating if (pattern==1 | reform==1), by(reform)


ttest ideo_rating if treat_endorse!=., by(lawendorse)


* Work for Law Enforcement

tab work4law

ttest work4law if (control1==1 | pattern==1), by(pattern)
ttest work4law if (control1==1 | reform==1), by(reform)

ttest work4law if (pattern==1 | reform==1), by(reform)


ttest work4law if treat_endorse!=., by(lawendorse)


* Los Angeles

tab losangeles

ttest losangeles if (control1==1 | pattern==1), by(pattern)
ttest losangeles if (control1==1 | reform==1), by(reform)

ttest losangeles if (pattern==1 | reform==1), by(reform)


ttest losangeles if treat_endorse!=., by(lawendorse)


* Orange

tab orange

ttest orange if (control1==1 | pattern==1), by(pattern)
ttest orange if (control1==1 | reform==1), by(reform)

ttest orange if (pattern==1 | reform==1), by(reform)


ttest orange if treat_endorse!=., by(lawendorse)


* Riverside

tab riverside

ttest riverside if (control1==1 | pattern==1), by(pattern)
ttest riverside if (control1==1 | reform==1), by(reform)

ttest riverside if (pattern==1 | reform==1), by(reform)


ttest riverside if treat_endorse!=., by(lawendorse)


* Sacramento

tab saccounty

ttest saccounty if (control1==1 | pattern==1), by(pattern)
ttest saccounty if (control1==1 | reform==1), by(reform)

ttest saccounty if (pattern==1 | reform==1), by(reform)


ttest saccounty if treat_endorse!=., by(lawendorse)

* End
