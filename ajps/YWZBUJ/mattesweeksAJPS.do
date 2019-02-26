* Replication files for Mattes/Weeks "Hawks, Doves, and Peace: An Experimental Approach*
* April 2018 *
* All analyses carried out using STATA version 15.1 *

* STATA programs to install
ssc install outreg2
ssc install mediation

use mattesweeksAJPS.dta, clear

set more off

****************************************
* CLEAN UP DATA AND GENERATE VARIABLES *
****************************************

count // 1200 observations. Note: YouGov pre-screened respondents based on attention checks.
ren hawk hawk5


**************************************
* GENERATE INDICATORS FOR TREATMENTS *
**************************************

gen dem=0
replace dem=1 if party_t==2
tab dem party_t

gen hawk=0
replace hawk=1 if hawk_t==1
tab hawk hawk_t
label define hawkl 1 "Hawk" 2 "Dove"
label values hawk_t hawkl

gen rapproche=0
replace rapproche=0 if rapproche_t==2
replace rapproche=1 if rapproche_t==1
label define rapprochel 1 "Conciliatory" 0 "Status Quo"
label values rapproche rapprochel

gen success=0
replace success=1 if success_t==1
tab success success_t

* Dummies for Treatment Combinations
gen hawkrap=0
replace hawkrap=1 if hawk==1 & rapproche==1

gen hawkneut=0
replace hawkneut=1 if hawk==1 & rapproche==0

gen doverap=0
replace doverap=1 if hawk==0 & rapproche==1

gen doveneut=0
replace doveneut=1 if hawk==0 & rapproche==0


**************
* COVARIATES *
**************

* age
gen age=2017-birthyr

* party id
replace pid7 = . if pid7==8
rename pid7 pid7_f
gen pid7=(pid7_f-1)/6

* nonpartisan
gen nonpartisan=0
replace nonpartisan=1 if pid3==3 | pid3==5 // "Independent" or "not sure"

gen nonpartisan2=0 // only hard-core independents
replace nonpartisan2=1 if pid7_f==4 & pid3==3

* ideology (1 = very liberal and 5 = very conservative)
replace ideo5=. if ideo5==6

* male
gen male = cond(gender == 1,1,0) 
label define malel 1 "Male" 0 "Female"
label values male malel

* hawk		
ren hawk5 hawk5old
gen hawk5 = hawk5o
recode hawk5 1=5 2=4 3=3 4=2 5=1 // change polarity
rename hawk5 hawk5_f
gen hawk5=(hawk5_f-1)/4

* intl
rename intl intl_f
gen intl= (intl_f-1)/4
tab intl
gen intl01=0
replace intl01=1 if intl_f>=4
tab intl01 intl_f

*trust
recode trust 8=. 1=1 2=0

* educ 
rename educ educ_f
gen educ= (educ_f-1)/5

* polint
gen polint = .
replace polint=0 if newsint==4
replace polint=1 if newsint==3
replace polint=2 if newsint==2
replace polint=3 if newsint==1
tab polint
rename polint polint_f
gen polint= polint_f/3

*voted16
ren voted16 voted16old
gen voted16=0
replace voted16=1 if voted16old==4
tab voted16

* count of meetings, sign, work for campaign, donate money to campaign
foreach var of varlist polact_* {
ren `var' `var'str
gen `var' = .
replace `var' = 1 if `var'str==1
replace `var' = 0 if `var'str==2
}

egen particip = rowtotal(polact_1 polact_2 polact_3 polact_4) 
tab particip

* relig_impt
gen relig_impt = .
tab pew_religimp
replace relig_impt = 4 if pew_religimp==1
replace relig_impt = 3 if pew_religimp==2
replace relig_impt = 2 if pew_religimp==3
replace relig_impt = 1 if pew_religimp==4
tab relig_impt
rename relig_impt relig_impt_f
gen relig_impt= (relig_impt_f - 1)/3
tab relig_impt

label var pid7 "Party ID"
label var hawk5 "Hawkishness"
label var intl "Internationalism"
label var trust "International Trust"
label var age "Age"
label var male "Male"
label var educ "Education"
label var relig_impt "Religiosity"
label var voted16 "Voted in 2016"
label var polint "Political Interest"


*************************************
* DEPENDENT VARIABLES AND MEDIATORS *
*************************************

* DVs
*ordinal: DV1
tab hddv1 // note, we lose one observation here
gen dv1_raw=.
replace dv1_raw=1 if hddv1==1
replace dv1_raw=2 if hddv1==2
replace dv1_raw=3 if hddv1==3
replace dv1_raw=4 if hddv1==4
replace dv1_raw=5 if hddv1==5

* reverse polarity for analysis
gen dv1r=6-dv1_raw

* recode dv1 to be on a 0-100 scale
gen dv1 = (dv1_raw-1)/4*100 // rescaled to 0-100 for ease of interpretation
tab dv1

* reverse polarity for mediation analysis
gen dv1a=100-dv1

*dummy DV1
gen disapprove1=.
replace disapprove1=0
replace disapprove1=100 if dv1_raw<3
replace disapprove1=. if dv1==.

gen dv01=disapprove1
replace dv01=1 if disapprove1==100

tab hawk_t rapproche_t, sum(dv1)
tab hawk_t rapproche_t, sum(disapprove1)


*ordinal DV2
tab hddv2
gen dv2_raw=.
replace dv2_raw=1 if hddv2==1
replace dv2_raw=2 if hddv2==2
replace dv2_raw=3 if hddv2==3
replace dv2_raw=4 if hddv2==4
replace dv2_raw=5 if hddv2==5
tab dv2_raw

* reverse polarity for analysis
gen dv2r=6-dv2_raw

* recode dv1 to be on a 0-100 scale
gen dv2 = (dv2_raw-1)/4*100 
tab dv2

*dummy DV2
gen disapprove2=.
replace disapprove2=0
replace disapprove2=100 if dv2_raw<3
replace disapprove2=. if dv2==.

gen dv02=disapprove2
replace dv02=1 if disapprove2==100

tab hawk_t rapproche_t, sum(dv2)
tab hawk_t rapproche_t, sum(disapprove2)


* GENERATE VARIABLES FOR MEDIATORS
* recode the mediators to be on a 0-100 scale, and create 0-1 versions

* (1) BEFORE OUTCOME KNOWN
rename hdmed1_strat best
rename hdmed1_pac pacifist
rename hdmed1_war warmonger

* moderation measure
gen moderateleader=0 // no missing values
replace moderateleader=100 if pacifist<=3 & warmonger<=3 // not pacifist or warmonger

* (2) AFTER OUTCOME KNOWN
rename hdmed2_strat best_p
rename hdmed2_pac pacifist_p
rename hdmed2_war warmonger_p

* moderation measure
gen moderateleader_p=0 // no missing values
replace moderateleader_p=100 if pacifist_p<=3 & warmonger_p<=3 // not pacifist or warmonger

* alternate versions of mediators
foreach var of varlist best* {
ren `var' `var'str 
gen `var' = .
replace `var' = 0 if `var'str==1
replace `var' = 0 if `var'str==2
replace `var' = 0 if `var'str==3
replace `var' = 100 if `var'str==4
replace `var' = 100 if `var'str==5
gen `var'01 = .
replace `var'01 = 0 if `var'str==1
replace `var'01 = 0 if `var'str==2
replace `var'01 = 0 if `var'str==3
replace `var'01 = 1 if `var'str==4
replace `var'01 = 1 if `var'str==5
}

gen moderateleader01=0
replace moderateleader01=1 if moderateleader==100

gen moderateleader_p01=0
replace moderateleader_p01=1 if moderateleader_p==100


foreach var of varlist best* moderateleader*   {
gen `var'hawk=`var'*hawk
}

**********************************
** CHECK FOR COVARIATE BALANCE  **
**********************************

local cklist hawk5 intl trust male age educ relig_impt  ///
   ideo5 pid7 voted16 particip
   
   foreach v of varlist `cklist' {
   di in r _n(2) "... Variable is `v' ..."
   di in r _n(2) "... Relationship between `v' and treatments ..."
   reg `v' hawk, noheader
   reg `v' dem, noheader
   reg `v' rapproche, noheader
   reg `v' success, noheader
   di in r _n(2) "... Relationship between `v' and DVs ..."
   reg disapprove1 `v', noheader
   reg disapprove2 `v', noheader
   }
 

**************
** ANALYSIS **
**************

********************
***** Table 2 ******
********************

* GENERATE FIRST 2 COLUMNS OF TABLE 2
tab hawk_t rapproche, sum(disapprove1) 
* Note: N here is 1,199

* GENERATE LAST COLUMN OF TABLE 2
reg disapprove1 hawkrap hawkneut doverap doveneut, robust noconst // estimate underlying model so we can compare using lincom command
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* Mentioned in footnote: "Why might doves be more popular than hawks at the status quo"?
tab hawk_t rapproche, sum(moderateleader) 
tab hawk_t rapproche, sum(best) 



* ROBUSTNESS MENTIONED IN PAPER TEXT:

* "The results in Table 2 are robust to controlling for the individual’s political ideology, sex, age, education, political interest, religiosity, 
* internationalism, hawkishness, international trust, and whether the president was a Democrat or a Republican."
local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16" 
reg disapprove1 hawkrap hawkneut doverap doveneut dem `controls', robust noconst // calculate underlying model
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves


* "When we subset on the president's party, which we also randomize, we find that the hawk's advantage is statistically significant for both 
* Republican and Democratic presidents but that the effect is larger in magnitude for the former."
gen rep=0 // generate indicator for Republican president
replace rep=1 if dem==0

* generate interaction between treatment combinations and whether the leader is a Democrat or Republican
foreach var of varlist hawkrap hawkneut doverap doveneut {
gen dem_`var'=`var'*dem
gen rep_`var'=`var'*rep
}

* Hawk's Advantage when leader is a Democrat
tab hawk_t rapproche if party_t==2, sum(disapprove1) // replication of Table 2
reg disapprove1 hawkrap hawkneut doverap doveneut if party_t==2, robust noconst // estimate underlying model
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* Hawk's Advantage when leader is a Democrat, w/ control vars
local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16" 
reg disapprove1 hawkrap hawkneut doverap doveneut dem `controls' if party_t==2, robust noconst
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* Hawk's Advantage when leader is a Republican
tab hawk_t rapproche if party_t==1, sum(disapprove1) 
reg disapprove1 hawkrap hawkneut doverap doveneut if party_t==1, robust noconst
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* Hawk's Advantage when leader is a Republican, w/ control vars
tab hawk_t rapproche if party_t==1, sum(disapprove1) 
local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16" 
reg disapprove1 hawkrap hawkneut doverap doveneut if party_t==1, robust noconst
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* Compare Hawk's advantage for Democratic and Republican Presidents: the Hawk's Advantage is larger in magnitude for Republican Presidents
reg disapprove1 dem_* rep_*, robust noconst
lincom (rep_hawkneut-rep_hawkrap-rep_doveneut+rep_doverap) - (dem_hawkneut-dem_hawkrap-dem_doveneut+dem_doverap)
* -19.8, p .04

* with controls
local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16"
reg disapprove1 dem_* rep_* `controls', robust noconst
lincom (rep_hawkneut-rep_hawkrap-rep_doveneut+rep_doverap) - (dem_hawkneut-dem_hawkrap-dem_doveneut+dem_doverap)

* Note: using alternate DV, the difference in Hawk's Advantage between Democratic and Republican Presidents is no longer significant
reg dv1 dem_* rep_*, robust noconst
lincom (rep_hawkneut-rep_hawkrap-rep_doveneut+rep_doverap) - (dem_hawkneut-dem_hawkrap-dem_doveneut+dem_doverap)
* -4.6, .484

* alternate DV with control variables: difference in Hawk's Advantage between Democratic and Republican Presidents is no longer significant
local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16"
reg dv1 dem_* rep_* `controls', robust noconst
lincom (rep_hawkneut-rep_hawkrap-rep_doveneut+rep_doverap) - (dem_hawkneut-dem_hawkrap-dem_doveneut+dem_doverap)


* ".....we found that party ID by itself does not produce a hawk’s advantage: subjects did not respond differently to rapprochement efforts by Democrats and Republicans."

* generate indicator variables so we can compare using lincom
gen demrap=0
replace demrap=1 if dem==1 & rapproche==1 // Democratic leaders who engaged in conciliation
gen demneut=0
replace demneut=1 if dem==1 & rapproche==0 // Democratic leaders who stood firm
gen reprap=0
replace reprap=1 if dem==0 & rapproche==1 // Republican leaders who engaged in conciliation
gen repneut=0
replace repneut=1 if dem==0 & rapproche==0 // Republican leaders who stood firm

tab party_t rapproche, sum(disapprove1) // display data with party as the signal, rather than hawk/dove
reg disapprove1 reprap repneut demrap demneut, robust noconst // estimate underlying model
lincom demrap-demneut // Calculate effect of conciliation for Democratic presidents
lincom reprap-repneut // Calculate effect of conciliation for Republican presidents
lincom repneut-reprap-demneut+demrap // Calculate difference in effect of conciliation between Democratic and Republican presidents --> "subjects did not respond differently to rapprochement efforts by Democrats and Republicans"


* "We detect the same patterns... when we instead carry out our analyses using the raw 5-point scale" (see also Table F-3)
* dv1 = ordinal 5pt scale
foreach v of varlist dv1 {
	local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16" 
   di in r _n(2) "... Variable is `v' ..."
   di in r _n(2) "... Without controls ..."
   reg `v' hawkrap hawkneut doverap doveneut, robust noconst // underlying model
	lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
	lincom doverap-doveneut // Calculate effect of conciliation for doves
	lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves
   di in r _n(2) "... With controls ..."
	reg `v' hawkrap hawkneut doverap doveneut dem `controls', robust noconst // underlying model, with controls
	lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
	lincom doverap-doveneut // Calculate effect of conciliation for doves
	lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves
   }
   

************************************************
************************************************
****         APPENDIX FOR TABLE 2	          **
************************************************
************************************************

* POLITICALLY ACTIVE (APPENDIX TABLE C-1)
* generate indicator for politically active
egen polact=rsum(voted16 particip) // ranges from 0 to 5, median is 1.
gen polacthi=0
replace polacthi=1 if polact>=2 // 432 obs, 35% of sample
tab polacthi, miss

* APPENDIX TABLE C-1 (politically active)
tab hawk_t rapproche if polacthi==1, sum(disapprove1) // averages and cell sizes for table C-1
reg disapprove1 hawkrap hawkneut doverap doveneut if polacthi==1, robust noconst // estimate underlying model
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* NONPARTISAN (APPENDIX TABLE C-2)
* define as those who identify either as independents, not sure, or other on pid3 (includes leaners)
tab hawk_t rapproche if nonpartisan==1, sum(disapprove1) // averages and cell sizes for table C-2
reg disapprove1 hawkrap hawkneut doverap doveneut if nonpartisan==1, robust noconst // estimate underlying model
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* APPENDIX TABLE C-2 ROBUSTNESS (narrow independents only, mentioned in appendix text but not shown in table)
tab hawk_t rapproche if nonpartisan2==1, sum(disapprove1) // averages and cell sizes 
reg disapprove1 hawkrap hawkneut doverap doveneut if nonpartisan2==1, robust noconst // esimate underlying model
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* LOGIT ANALYSIS WITH AND WITHOUT CONTROLS (APPENDIX TABLE F-1)
* without controls (Column 1)
logit dv01 hawkrap hawkneut doverap doveneut, robust noconst // estimate model
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* with controls (Column 2)
local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16" // estimate model
logit dv01 hawkrap hawkneut doverap doveneut dem `controls', robust noconst
lincom doverap-doveneut 
lincom hawkrap-hawkneut 
lincom hawkrap-hawkneut-doverap+doveneut 





********************************************************************************
********************************************************************************
**                    MECHANISMS / MEDIATION ANALYSIS                         **
********************************************************************************
********************************************************************************

* TABLE 3
foreach v of varlist best moderateleader { // 
   di in r _n(2) "... Variable is `v' ..."
   tab hawk_t rapproche_t, sum(`v') // averages and cell sizes
   reg `v' hawkrap hawkneut doverap doveneut , robust noconst // underlying model
	lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
	lincom doverap-doveneut // Calculate effect of conciliation for doves
	lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves
   }
   

*********************************************************************************************************************************************
* MEDIATION ANALYSIS
*********************************************************************************************************************************************

set seed 12345

**************
**************
* Mediation
**************
**************

set more off

* APPENDIX TABLE D-1
foreach var of varlist best01 moderateleader01 {
   di in r _n(2) "... Variable is `var' ..."
   di in r _n(2) "... Is effect of T on M different for hawks and doves? ..."
   local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16" 
logit `var' hawkrap hawkneut doverap doveneut dem `controls', robust noconst
   lincom hawkrap-hawkneut // Hawk shift from status quo to conciliatory policy (H)
   lincom doverap-doveneut // Dove shift from status quo to conciliatory policy (D)
   lincom hawkrap-hawkneut-doverap+doveneut // Hawk’s Advantage (H-D)
}

* APPENDIX TABLES D-2, D-3, D-4, D-5
foreach var of varlist best01 moderateleader01  {
   local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16" 
   di in r _n(2) "... Mediation effects of `var' for HAWKS ..."
medeff (logit `var' rapproche `controls') (logit dv01 `var' rapproche `controls') if hawk==1, mediate(`var') treat(rapproche) sims(2000) seed(12345)
   di in r _n(2) "... Mediation effects of `var' for DOVES ..."
medeff (logit `var' rapproche `controls') (logit dv01 `var' rapproche `controls') if hawk==0, mediate(`var') treat(rapproche) sims(2000) seed(12345)
}

* FOR REFERENCE: EFFECTS OF M ON Y
set more off
foreach var of varlist best01 moderateleader01 {
local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16" 
   di in r _n(2) "... Is effect of M on Y different for hawks and doves? ..."
   logit dv01 `var' `var'hawk hawkrap hawkneut doverap `controls' // 
 }

****************************************
****************************************
**       POST-OUTCOME ANALYSES        **
****************************************
****************************************

* TABLE 4, TOP PANEL (FAILURE)
tab hawk_t rapproche if success==0, sum(disapprove2)
reg disapprove2 hawkrap hawkneut doverap doveneut if success==0, robust noconst 
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves

* TABLE 4, BOTTOM PANEL (SUCCESS)
tab hawk_t rapproche if success==1, sum(disapprove2)
reg disapprove2 hawkrap hawkneut doverap doveneut if success==1, robust noconst 
lincom hawkrap-hawkneut // Calculate effect of conciliation for hawks
lincom doverap-doveneut // Calculate effect of conciliation for doves
lincom hawkrap-hawkneut-doverap+doveneut // Calculate difference in effect of conciliation between hawks and doves


* LOGIT MODELS WITH SUCCESS/FAILURE (APPENDIX TABLE F-2)
* Column1 1: success without controls
logit dv02 hawkrap hawkneut doverap doveneut if success==1, robust noconst
lincom hawkrap-hawkneut // Hawk shift from status quo to conciliatory policy (H)
lincom doverap-doveneut // Dove shift from status quo to conciliatory policy (D)
lincom hawkrap-hawkneut-doverap+doveneut // Hawk’s Advantage (H-D)

* Column 2: success with controls
local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16"
logit dv02 hawkrap hawkneut doverap doveneut dem `controls' if success==1, robust noconst
lincom hawkrap-hawkneut // Hawk shift from status quo to conciliatory policy (H)
lincom doverap-doveneut // Dove shift from status quo to conciliatory policy (D)
lincom hawkrap-hawkneut-doverap+doveneut // Hawk’s Advantage (H-D)

* Column1 1: failure without controls
logit dv02 hawkrap hawkneut doverap doveneut if success==0, robust noconst
lincom hawkrap-hawkneut // Hawk shift from status quo to conciliatory policy (H)
lincom doverap-doveneut // Dove shift from status quo to conciliatory policy (D)
lincom hawkrap-hawkneut-doverap+doveneut // Hawk’s Advantage (H-D)

* Column 2: failure with controls
local controls "pid7 hawk5 intl trust age male educ relig_impt polint voted16"
logit dv02 hawkrap hawkneut doverap doveneut dem `controls' if success==0, robust noconst
lincom hawkrap-hawkneut // Hawk shift from status quo to conciliatory policy (H)
lincom doverap-doveneut // Dove shift from status quo to conciliatory policy (D)
lincom hawkrap-hawkneut-doverap+doveneut // Hawk’s Advantage (H-D)



*****************************************
**** POST OUTCOME MECHANISMS ************
*****************************************


* Appendix E-1 Column 1, lower panel (and mentioned in the main text of the paper)
* multiply findings by 100 to get percentage point change
* For remaining columns of E-1, see the replication files for "Russia_Sanctions", "Russia_TroopWithdrawal", and "China_DemilitarizationAgreement" 

   * 1. failure
   * Credibility mechanism
   reg best_p01 hawkrap hawkneut  doverap doveneut if success==0, robust noconst
   lincom hawkrap-hawkneut-doverap+doveneut // 11.7
   
   * Moderation mechanism
   reg moderateleader_p01 hawkrap hawkneut  doverap doveneut if success==0, robust noconst
   lincom hawkrap-hawkneut-doverap+doveneut // 45.7***

   
	* 2. success
   * Credibility mechanism
   reg best_p01 hawkrap hawkneut  doverap doveneut if success==1, robust noconst
   lincom hawkrap-hawkneut-doverap+doveneut // 28.4***
   
   * Moderation mechanism
   reg moderateleader_p01 hawkrap hawkneut  doverap doveneut if success==1, robust noconst
   lincom hawkrap-hawkneut-doverap+doveneut // 43.9***
   



**************************************************
**** ADDITIONAL ROBUSTNESS - APPENDIX ************
**************************************************

* Table F-3
* Column 1 "Main Results"
reg dv1r hawkrap hawkneut doverap doveneut, robust noconst
lincom hawkrap-hawkneut // Hawk shift from status quo to conciliatory policy (H)
lincom doverap-doveneut // Dove shift from status quo to conciliatory policy (D)
lincom hawkrap-hawkneut-doverap+doveneut // Hawk’s Advantage (H-D)

* Column 2 "Post-Outcome Success Model"
reg dv2r hawkrap hawkneut doverap doveneut if success==1, robust noconst
lincom hawkrap-hawkneut // Hawk shift from status quo to conciliatory policy (H)
lincom doverap-doveneut // Dove shift from status quo to conciliatory policy (D)
lincom hawkrap-hawkneut-doverap+doveneut // Hawk’s Advantage (H-D)

* Column 3 "Post-Outcome Failure Model"
reg dv2r hawkrap hawkneut doverap doveneut if success==0, robust noconst
lincom hawkrap-hawkneut // Hawk shift from status quo to conciliatory policy (H)
lincom doverap-doveneut // Dove shift from status quo to conciliatory policy (D)
lincom hawkrap-hawkneut-doverap+doveneut // Hawk’s Advantage (H-D)


