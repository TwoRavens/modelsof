****************
*1992-1994-1996 CPS American National Election Studies (ANES) Panel Study* 
*This analysis uses panel data to investigate the potentially endogenous* 
*relationship between core values and partisanship*

*The analysis conducted in this Stata do-file produces Figure SI7 in the* 
*Supporting Information (SI) in the BJPS article titled "Values and Political* 
*Predispositions in the Age of Polarization: Examining the Relationship* 
*between Partisanship and Ideology in the U.S., 1988-2012"*

*Note: The data necessary needed to reproduce the following analysis in this*
*Stata do-file is located in this Dataverse Dataset, and it is a Stata dataset* 
*titled "1992-1994-1996 ANES Panel Data.dta"*

*This paper is co-authored with Steven M. Smallpage and Adam M. Enders*
*Adam Enders conducted the analysis appearing in this Stata do-file*
*My name is Robert N. Lupton

*Wed. 27 September 2017*
****************

*** 1992-1994-1996 ANES Panel Study ***

use "/Users/adamenders/Dropbox/Data/ANES/anes_mergedfile_1992to1997_dta/anes_mergedfile_1992to1997.dta"


*** Cleaning data and creating relevant variables ***

* Case ID
gen id92 = VID92 
gen id94 = VID94 
gen id96 = VID96

keep if id92 != . & id96 != .

* Weight
gen weight92 = V923009
gen weight94 = V940005 
gen weight96 = V960004

* Party identification
gen pid92 = V923634 - 3
replace pid92 = . if pid92 > 3
gen pid94 = V940655 - 3
replace pid94 = . if pid94 > 3
gen pid96 = V960420 - 3
replace pid96 = . if pid96 > 3

gen rep92 = 1 if pid92 > 1
replace rep92 = 0 if pid92 < -1
gen rep94 = 1 if pid94 > 1
replace rep94 = 0 if pid94 < -1
gen rep96 = 1 if pid96 > 1
replace rep96 = 0 if pid96 < -1

* Ideology
gen ideo92 = V923509 - 4
replace ideo92 = . if abs(ideo92) > 3 
gen ideo94 = V940839 - 4
replace ideo94 = . if abs(ideo94) > 3 
gen ideo96 = V960365 - 4
replace ideo96 = . if abs(ideo96) > 3 

gen conserv92 = 1 if ideo92 > 0
replace conserv92 = 0 if ideo92 < 0
gen conserv94 = 1 if ideo94 > 0
replace conserv94 = 0 if ideo94 < 0
gen conserv96 = 1 if ideo96 > 0
replace conserv96 = 0 if ideo96 < 0

* Do whatever is necessary for equal opportunity
* Note: This variable is reverse coded so that higher values indicate
* more conservative attitudes
gen equalopp92 = V926024 - 1
gen equalopp94 = V940914 - 1
gen equalopp96 = V961229 - 1

replace equalopp92 = . if equalopp92 > 4
replace equalopp94 = . if equalopp94 > 4
replace equalopp96 = . if equalopp96 > 4

label define equalopportunity 0 "0 Agree strongly" 1 "1 Agree somewhat" ///
	2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" ///
	4 "4 Disagree strongly"
label values equalopp92 equalopportunity
label values equalopp94 equalopportunity
label values equalopp96 equalopportunity

* Have gone too far pushing equal rights
* Note: This variable is reverse coded so that higher values indicate
* more conservative attitudes
gen equalrights92 = V926025
gen equalrights94 = V940915
gen equalrights96 = V961230

replace equalrights92 = . if equalrights92 > 5
recode equalrights92 (5=0) (4=1) (3=2) (2=3) (1=4)
replace equalrights94 = . if equalrights94 > 5
recode equalrights94 (5=0) (4=1) (3=2) (2=3) (1=4)
replace equalrights96 = . if equalrights96 > 5
recode equalrights96 (5=0) (4=1) (3=2) (2=3) (1=4)

label define equalrightspush 0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
	2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values equalrights92 equalrightspush
label values equalrights94 equalrightspush
label values equalrights96 equalrightspush

* Big problem is not giving everyone an equal chance*
gen equalchance92 = V926029 - 1
gen equalchance94 = V940916 - 1
gen equalchance96 = V961231 - 1

replace equalchance92 = . if equalchance92 > 4
replace equalchance94 = . if equalchance94 > 4
replace equalchance96 = . if equalchance96 > 4

label define equalchances 0 "0 Agree strongly" 1 "1 Agree somewhat" ///
	2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" ///
	4 "4 Disagree strongly"
label values equalchance92 equalchances
label values equalchance94 equalchances
label values equalchance96 equalchances

* Better off if we worried less about equality
* Note: This variable is reverse coded so that higher values indicate
* more conservative attitudes
gen lessequal92 = V926026
gen lessequal94 = V940917
gen lessequal96 = V961232

replace lessequal92 = . if lessequal92 > 5
recode lessequal92 (5=0) (4=1) (3=2) (2=3) (1=4)
replace lessequal94 = . if lessequal94 > 5
recode lessequal94 (5=0) (4=1) (3=2) (2=3) (1=4)
replace lessequal96 = . if lessequal96 > 5
recode lessequal96 (5=0) (4=1) (3=2) (2=3) (1=4)

label define lessequality 0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
	2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values lessequal92 lessequality
label values lessequal94 lessequality
label values lessequal96 lessequality

* Not that big of a problem if people have more of a chance
* Note: This variable is reverse coded so that higher values indicate
* more conservative attitudes 
gen unequal92 = V926027
gen unequal94 = V940918
gen unequal96 = V961233

replace unequal92 = . if unequal92 > 5
recode unequal92 (5=0) (4=1) (3=2) (2=3) (1=4)
replace unequal94 = . if unequal94 > 5
recode unequal94 (5=0) (4=1) (3=2) (2=3) (1=4)
replace unequal96 = . if unequal96 > 5
recode unequal96 (5=0) (4=1) (3=2) (2=3) (1=4)

label define unequalchance 0 "0 Disagree strongly" 1 "1 Disagree somewhat" ///
	2 "2 Neither agree nor disagree" 3 "3 Agree somewhat" 4 "4 Agree strongly"
label values unequal92 unequalchance
label values unequal94 unequalchance
label values unequal96 unequalchance

* Many fewer problems if people were treated equally
gen fewer92 = V926028 - 1
gen fewer94 = V940919 - 1
gen fewer96 = V961234 - 1

replace fewer92 = . if fewer92 > 4
replace fewer94 = . if fewer94 > 4
replace fewer96 = . if fewer96 > 4

label define fewerproblems04 0 "0 Agree strongly" 1 "1 Agree somewhat" ///
	2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" ///
	4 "4 Disagree strongly"
label values fewer92 fewerproblems04
label values fewer94 fewerproblems04
label values fewer96 fewerproblems04

* Adjusting views of moral behavior
gen changing92 = V926115 - 1
gen changing94 = V941030 - 1
gen changing96 = V961248 - 1

replace changing92 = . if changing92 > 4
replace changing94 = . if changing94 > 4
replace changing96 = . if changing96 > 4

label define changingmorals 0 "Agree strongly" 1 "Agree somewhat" ///
	2 "Neither agree nor disagree" 3 "Disagree somewhat" 4 "Disagree strongly"
label values changing92 changingmorals
label values changing94 changingmorals
label values changing96 changingmorals
 
* Newer lifestyles contributing to a breakdown in society
* Note: This variable is reverse coded so that higher values indicate*
* more conservative attitudes
gen lifestyles92 = V926118
gen lifestyles94 = V941029
gen lifestyles96 = V961247

replace lifestyles92 = . if lifestyles92 > 5
recode lifestyles92 (5=0) (4=1) (3=2) (2=3) (1=4)
replace lifestyles94 = . if lifestyles94 > 5
recode lifestyles94 (5=0) (4=1) (3=2) (2=3) (1=4)
replace lifestyles96 = . if lifestyles96 > 5
recode lifestyles96 (5=0) (4=1) (3=2) (2=3) (1=4)

label define lifestylesnew 0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
	2 "2 Neither agree nor disagree"  3 "3 Agree somewhat" 4 "4 Agree strongly"
label values lifestyles92 lifestylesnew
label values lifestyles94 lifestylesnew
label values lifestyles96 lifestylesnew

* Tolerant of people who choose to live according to their own moral standards
gen standards92 = V926116 - 1
gen standards94 = V941032 - 1
gen standards96 = V961250 - 1

replace standards92 = . if standards92 > 4
replace standards94 = . if standards94 > 4
replace standards96 = . if standards96 > 4

label define standardsown 0 "0 Agree strongly" 1 "1 Agree somewhat" ///
	2 "2 Neither agree nor disagree" 3 "3 Disagree somewhat" ///
	4 "4 Disagree strongly"
label values standards92 standardsown
label values standards94 standardsown
label values standards96 standardsown
 
* More emphasis on traditional family ties*
* Note: This variable is reverse coded so that higher values indicate
* more conservative attitudes
gen family92 = V926117
gen family94 = V941031
gen family96 = V961249

replace family92 = . if family92 > 5
recode family92 (5=0) (4=1) (3=2) (2=3) (1=4)
replace family94 = . if family94 > 5
recode family94 (5=0) (4=1) (3=2) (2=3) (1=4)
replace family96 = . if family96 > 5
recode family96 (5=0) (4=1) (3=2) (2=3) (1=4)

label define familyties 0 "0 Disagree strongly" 1 "1 Disagree somewhat" /// 
	2 "2 Neither agree nor disagree"  3 "3 Agree somewhat" 4 "4 Agree strongly"
label values family92 familyties
label values family94 familyties
label values family96 familyties

* Creating values scales
alpha equalopp92 equalrights92 equalchance92 lessequal92 unequal92 fewer92 ///
	changing92 lifestyles92 standards92 family92, detail item ///
	generate(valuescale92) 

alpha equalopp94 equalrights94 equalchance94 lessequal94 unequal94 fewer94 ///
	changing94 lifestyles94 standards94 family94, detail item ///
	generate(valuescale94) 

alpha equalopp96 equalrights96 equalchance96 lessequal96 unequal96 fewer96 ///
	changing96 lifestyles96 standards96 family96, detail item ///
	generate(valuescale96) 
		
sum valuescale94, meanonly 
replace valuescale94 = (valuescale94 - r(min))/(r(max) - r(min)) 

sum valuescale94, detail

gen valuescale94dum = 1 if valuescale94 >= .6052632
replace valuescale94dum = 0 if valuescale94 <= .368421

sem (pid96 <- ideo94 pid94) (ideo96 <- ideo94 pid94), group(valuescale94dum) ///
	method(mlmv)

