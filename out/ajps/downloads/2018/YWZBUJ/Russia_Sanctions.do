**************************
** RUSSIA AND SANCTIONS **
**************************

***April 2018
***This file reproduces the results for the generalizability analysis reported in the manuscript and the web appendix.
***We draw on data collected in an MTURK online survey.
***Stata/IC 14.2 for Mac (64-bit Intel) was used for data analysis.

use "Russia_Sanctions.dta", clear

set more off

**************************************
* GENERATE INDICATORS FOR TREATMENTS *
**************************************

gen dem=0
replace dem=1 if party_t=="Democratic Party"

gen hawk=0
replace hawk=1 if hawk_t=="hawk"

gen rapproche=0
replace rapproche=1 if rapproche_t=="cooperate"

gen success=0
replace success=1 if success_t=="success"


* Combinations of treatments
gen hawkrap=0
replace hawkrap=1 if hawk==1 & rapproche==1

gen hawkconf=0
replace hawkconf=1 if hawk==1 & rapproche==0

gen doverap=0
replace doverap=1 if hawk==0 & rapproche==1

gen doveconf=0
replace doveconf=1 if hawk==0 & rapproche==0


************************
* MANIPULATION CHECKS **
************************

* US hawk/dove
tab hawk_t mck_hawk //
gen mck_hawk_pass=0
replace mck_hawk_pass=1 if (hawk_t=="dove" & mck_hawk==1) | (hawk_t=="hawk" & mck_hawk==2)
tab mck_hawk_pass 

* rapproche
tab rapproche mck_sanx // 
gen mck_sanx_pass=0
replace mck_sanx_pass=1 if (rapproche==0 & mck_sanx==1) | (rapproche==1 & mck_sanx==2)
tab mck_sanx_pass 

* US party
tab party mck_par // 
gen mck_par_pass=0
replace mck_par_pass=1 if (dem==1 & mck_party==2) | (dem==0 & mck_party==1)
tab mck_par_pass

* success
tab success_t mck_succ // 
gen mck_succ_pass=0
replace mck_succ_pass=1 if (success_t=="failure" & mck_succes==2) | (success_t=="success" & mck_succes==1)
tab mck_succ_pass

* analyze manip checks
drop mck_hawk mck_sanx mck_party mck_succes
gen mck_sum_pass = mck_hawk + mck_sanx + mck_par + mck_succ
tab mck_sum_pass

tab mck_sum_pass
drop if mck_sum_pass<3 // drop if they did not get more than half of the manipulation checks right
count // 


**************
* COVARIATES *
**************

*** AGE
gen age=.
foreach i of numlist 1/82 {
 replace age=`i'+17 if age_`i'==1
 }

drop age_*
sum age, d
rename age age_f
gen age= (age_f-18)/65

*** PARTY
gen pid7 = .
replace pid7 = 1 if pid_1 == 2 & pid_2 == 1  // strong democrat
replace pid7 = 2 if pid_1 == 2 & pid_2 == 2  // weak democrat
replace pid7 = 3 if pid_3 == 2  // lean democrat
replace pid7 = 4 if pid_3 == 3  // doesn't lean
replace pid7 = 5 if pid_3 == 1  // lean republican
replace pid7 = 6 if pid_1 == 1 & pid_2 == 2  // weak republican
replace pid7 = 7 if pid_1 == 1 & pid_2 == 1  // strong republican
label define pid7l 1 "Strong Democrat" 2 "Weak Democrat" 3 "Lean Democrat" 4 "Don't Lean" 5 "Lean Republican" 6 "Weak Republican" 7 "Strong Republican"
label values pid7 pid7l
rename pid7 pid7_f
gen pid7=(pid7_f-1)/6

gen pid5 = .
replace pid5=pid_1
label define pid5l 1 "Republican" 2 "Democrat" 3 "Independent" 4 "Another party" 5 "No preference"
label values pid5 pid5l
tab pid5

drop pid_*

* nonpartisan
gen nonpartisan=0
replace nonpartisan=1 if pid5==3 | pid5==5

*** SEX
* male
gen male = cond(gender == 1,1,0) 
label define malel 1 "Male" 0 "Female"
label values male malel

*** PARTICIPANT HAWKISHNESS
* rescale to with min 0 max 1
rename hawk5 hawk5_f
gen hawk5=(hawk5_f-1)/4
tab hawk5


*** PARTICIPANT INTERNATIONALISM
recode intl 1=5 2=4 3=3 4=2 5=1 // now higher values now mean more internationalist
* rescale to with min 0 max 1
rename intl intl_f
gen intl= (intl_f-1)/4


*** EDUCATION
label define educl 1 "No High School" 2 "High School Grad" 3 "Some college" 4 "2-Year College Degree" 5 "4-Year College Degree" 6 "Postgraduate Degree"
label values educ educl
* rescale to with min 0 max 1
rename educ educ_f
gen educ= (educ_f-1)/5


*** POLITICAL INTEREST
rename newsint polint
recode polint 4=0 3=1 2=2 1=3 5=. *=. // higher values mean more interested
* rescale to with min 0 max 1
rename polint polint_f
gen polint= polint_f/3

recode voted12 4=1 1/3=0 *=. // yes or not yes
* count of meetings, sign, work for campaign, donate money to campaign
egen particip = rowtotal(particip_1 particip_2 particip_3 particip_4) // ignore donate bloode
drop particip_*

* dummy
egen polact=rsum(voted12 particip)
gen polacthi=0
replace polacthi=1 if polact>=2


*** RELIGION
recode relig_impt 4=1 3=2 2=3 1=4 *=. // higher values means more important
* rescale to with min 0 max 1
rename relig_impt relig_impt_f
gen relig_impt= (relig_impt_f - 1)/3

label var pid7 "Party ID"
label var hawk5 "Hawkishness"
label var intl "Internationalism"
label var age "Age"
label var male "Male"
label var educ "Education"
label var relig_impt "Religiosity"
label var voted12 "Voted in 2012"
label var polint "Political Interest"

*********
** DVs **
*********

* DV1
gen disapprove1=.
replace disapprove1=0
replace disapprove1=100 if dv1<3

*DV2
gen disapprove2=.
replace disapprove2=0
replace disapprove2=100 if dv2<3


***************
** MEDIATORS **
***************

* pacifist and warmonger varnames got switched in Qualtrics
ren pacifist pacif_wrong
gen pacifist = warmonger
replace warmonger = pacif_wrong
drop pacif_wr

* moderation measure
gen moderateleader=0 // no missing values
replace moderateleader=100 if pacifist<=3 & warmonger<=3 // not pacifist or warmonger

* recode best for ease of interpretation
foreach var of varlist best* {
ren `var' `var'str 
gen `var' = .
replace `var' = 0 if `var'str==1
replace `var' = 0 if `var'str==2
replace `var' = 0 if `var'str==3
replace `var' = 100 if `var'str==4
replace `var' = 100 if `var'str==5
}

**************************************************************************
** CHECK FOR COVARIATE BALANCE AND CORR BETWEEN COVARIATES AND APPROVAL **
**************************************************************************

local cklist hawk5 intl male age educ relig_impt pid7 polint voted12
   
   foreach v of varlist `cklist' {
   di in r _n(2) "... Variable is `v' ..."
   reg `v' hawk, noheader
   reg `v' dem, noheader
   reg `v' rapproche, noheader
   reg `v' success, noheader
   reg disapprove1 `v', noheader
   reg disapprove2 `v', noheader
   }
 
 

**************
** ANALYSIS **
**************


tab hawk_t rapproche_t, sum(disapprove1) // table analagous to Table 2 in main paper

* Table E-1, Column 3

* Main finding (Hawk's Advantage)
reg disapprove1 hawkrap hawkconf doverap doveconf, robust noconst
lincom hawkrap-hawkconf-doverap+doveconf // Calculate difference in effect of conciliation between hawks and doves: Row 1

* Credibility Mechanism
reg best hawkrap hawkconf doverap doveconf, robust noconst
lincom hawkrap-hawkconf-doverap+doveconf // Calculate difference in effect of conciliation between hawks and doves: Row 2

* Extremism/moderation Mechanism
reg moderateleader hawkrap hawkconf doverap doveconf, robust noconst
lincom hawkrap-hawkconf-doverap+doveconf // Calculate difference in effect of conciliation between hawks and doves: Row 3
  
* After Outcome
* 1. Failure
* Hawk's advantage
tab hawk_t rapproche_t if success==0, sum(disapprove2)
reg disapprove2 hawkrap hawkconf doverap doveconf if success==0, robust noconst 
lincom hawkrap-hawkconf-doverap+doveconf // Calculate difference in effect of conciliation between hawks and doves: Row 4

* 2. Success
* Hawk's advantage
tab hawk_t rapproche_t if success==1, sum(disapprove2)
reg disapprove2 hawkrap hawkconf doverap doveconf if success==1, robust noconst 
lincom hawkrap-hawkconf-doverap+doveconf // Calculate difference in effect of conciliation between hawks and doves: Row 7


   
   
   
   
