/* This program takes Census, etc., data from Lochner & Moretti (AER 2004)
and creates data set for studying black incarceration */



clear
clear matrix
capture log close
set memory 700m
set matsize 5000
set more off

cd "E:\Dropbox\Data\NONLINEARITY_PAPER\Lochner_Moretti"

use data7.dta

drop if ca==.
keep if black==1

**************
* Label Vars *
**************

label variable age	"Age"
label variable black	"Black"
label variable year	"Census Year"
label variable ca8	"Compulsory attendance <= 8"
label variable ca10	"Compulsory attendance = 10" 
label variable ca9	"Compulsory attendance = 9"
label variable ca11	"Compulsory attendance >= 11"
label variable gqtype	"Group Quarter Type"
label variable hisp	"Hispanic"
label variable drop	"HS Drop out"
label variable prison	"In Prison"
label variable birthpl	"State of Birth"
label variable state	"State of Residence"
label variable yearat14	"Year at Age 14"
label variable educ	"Years of Schooling"


******************************************
* Generate Variables: For OLS Regression *
******************************************

* Age Dummy *

g       rage =20 if age >=20 & age <= 22
replace rage =23 if age >=23 & age <= 25
replace rage =26 if age >=26 & age <= 28
replace rage =29 if age >=29 & age <= 31
replace rage =32 if age >=32 & age <= 34
replace rage =35 if age >=35 & age <= 37
replace rage =38 if age >=38 & age <= 40
replace rage =41 if age >=41 & age <= 43
replace rage =44 if age >=44 & age <= 46
replace rage =47 if age >=47 & age <= 49
replace rage =50 if age >=50 & age <= 52
replace rage =53 if age >=53 & age <= 55
replace rage =56 if age >=56 & age <= 58
replace rage =59 if age >=59 & age <= 60


* Born in the South *

generate south =0
quietly replace south =1 if birthpl ==10
quietly replace south =1 if birthpl ==11
quietly replace south =1 if birthpl ==12
quietly replace south =1 if birthpl ==13
quietly replace south =1 if birthpl ==24
quietly replace south =1 if birthpl ==37
quietly replace south =1 if birthpl ==45
quietly replace south =1 if birthpl ==51
quietly replace south =1 if birthpl ==1
quietly replace south =1 if birthpl ==54
quietly replace south =1 if birthpl ==21
quietly replace south =1 if birthpl ==28
quietly replace south =1 if birthpl ==47
quietly replace south =1 if birthpl ==5
quietly replace south =1 if birthpl ==22
quietly replace south =1 if birthpl ==40
quietly replace south =1 if birthpl ==48
quietly label variable south "Born in the South"

* Brown v. Board of Education *

generate BBeduc = (yearat14>1958 & south==1)
label var BBeduc "Brown v. Board of Education"

* Cohort Dummy *

g       cohort = 1914 if yearat14 >=1914 & yearat14 <= 1923
replace cohort = 1924 if yearat14 >=1924 & yearat14 <= 1933
replace cohort = 1934 if yearat14 >=1934 & yearat14 <= 1943
replace cohort = 1944 if yearat14 >=1944 & yearat14 <= 1953
replace cohort = 1954 if yearat14 >=1954 & yearat14 <= 1963
replace cohort = 1964 if yearat14 >=1964 & yearat14 <= 1974

** Save some Memory **
compress

* Cluster Variable *

generate stat_yea = yearat14*1000 + birthpl

*** Keep only Variables for Regressions ***

keep prison educ rage year state birthpl cohort BBeduc stat_yea ca9 ca10 ca11 yearat14

save BLACKS, replace



log using Rep_LM_BLACK, replace text

**************************
* OLS Estimates *
**************************

xi: reg prison educ i.rage i.year i.state i.birthpl i.birthpl*i.BBeduc, vce(cluster stat_yea)

xi: reg prison educ i.rage i.year i.state i.birthpl i.birthpl*i.BBeduc

***************************
* First Stage Estimates   *
***************************

xi: reg educ ca9 ca10 ca11 i.rage i.year i.state i.birthpl i.birthpl*i.BBeduc

test (ca9=0) (ca10=0) (ca11=0)

*************************
* IV Estimates *
*************************

/** NOTE: We simply run 2SLS here without clustering **/



xi: ivregress 2sls prison (educ = ca9 ca10 ca11) i.rage i.year i.state i.birthpl i.birthpl*i.BBeduc, first 

log close


