******************************************************************************************************************************
* DO file for main analysis, as reported in:                                                                                 *
*                                                                                                                            *
* Hilber, Christian A.L. and Tracy M. Turner, "The Mortgage Interest Deduction and its Impact on Homeownership Decisions,"   *
* Review of Economics and Statistics (2014).                                                                                 *
*                                                                                                                            *
* Christian Hilber and Tracy Turner, last updated: November 20, 2014                                                         *
******************************************************************************************************************************

// This do file runs with Stata/SE 13.1
// Our estimates 'pre-acceptance' were conducted using an earlier version of Stata that is no longer available to the authors


*******************************
*** PREPARING FINAL DATASET ***
*******************************

drop _all

clear mata
clear matrix
// set mem 5000m - no longer necessary in Stata/SE 13.1 // but for older Stata/SE versions needs to be specified
set maxvar  10000
set matsize 5500
set more 1
adopath + d:\  // path of folder that contains ado files (xtivreg2, outreg2) - THIS PATH NEEDS TO BE ADJUSTED FOR REPLICATION PURPOSES

cd "D:\ChH\Research\Working Papers\DiPa80 (PSIDPanel)\"  // determine path of folder that contains DTA, DO and LOG files for analysis - THIS PATH NEEDS TO BE ADJUSTED FOR REPLICATION PURPOSES

capture log close
log using "logs\Hilber_Turner_Main_Analysis_FINAL.log", replace // create log file

use "dta\panel\pan7807v17_v2.dta", clear // opens final compiled dataset for analysis - THIS PATH NEEDS TO BE ADJUSTED FOR REPLICATION PURPOSES
// NOTE: This final dataset (pan7807v17_v2.dta) is not available from the authors for confidentiality reasons. 
// The README file provides all necessary information and steps, allowing other scholars to replicate our analysis, 
// subject to being granted access to the underlying confidential data from the US Census (which reveals precise
// location information on the PSID households). See the README file for details.

*****************************
* ADD dummy variables (FEs) *
*****************************

quietly: tab year, gen(yeard)
quietly: tab state, gen(stated)
quietly: tab msad if insample==1, gen(msadd) // insample is = 1 if the observation belongs to the regression sample in Table 4
quietly: tab state if msad==347, gen(nonmsadd) // for locations that do not belong to an MSA (msad==347) create dummy depending on state
local i=1
while `i'<=48 {
quietly: replace nonmsadd`i'=0 if nonmsadd`i'==. & state~=.
local i=`i'+1
}


************************
* Generate time-trends *
************************

gen time=year-1977

local i=1
while `i'<=54 {
quietly: gen timexstated`i'=stated`i'*time
local i=`i'+1
}

local i=1
while `i'<=293 {
quietly: gen timexmsadd`i'=msadd`i'*time
local i=`i'+1
}

*************************************
* Generate dummy: Always same state *
*************************************

sort id03 year // id03 is the identification number of the household
by id03: gen temp1=1 if state==state[_n-1]
replace temp1=1 if year==1978
replace temp1=0 if temp1==.

by id03: egen temp2=count(temp1) if temp1==1
by id03: egen temp3=mean(temp2)
gen samestate=1 if temp3==25
replace samestate=0 if temp3<25
sum samestate
drop temp1-temp3

***********************************
* Generate dummy: Always same MSA *
***********************************

sort id03 year
by id03: gen temp1=1 if msad==msad[_n-1]
replace temp1=1 if year==1978
replace temp1=0 if temp1==.

by id03: egen temp2=count(temp1) if temp1==1
by id03: egen temp3=mean(temp2)
gen samemsa=1 if temp3==25
replace samemsa=0 if temp3<25
drop temp1-temp3

sum samestate samemsa if insample==1 // in regression sample for T4: share 'HHs always in same state' / 'in same MSA' respectively
sum samestate if samemsa==0 & insample==1 // share 'moved MSA but stayed in same state'
sum samemsa   if samestate==1 & insample==1 // share 'in same MSA if always in same state'

******************************************************************
* Create state x HH fixed effects for specifications (6) and (7) *
******************************************************************

gen stxid=state*100000+id03
replace stxid=0 if samestate==1	  
quietly: tab stxid if insample_reg==1, gen(stxid_)


*****************************************
*** TABLES AND FIGURES: MAIN ANALYSIS ***
*****************************************


// TABLE 1:  NBER Mortgage Subsidy Rate by U.S. State in %, 1984-2007 (Derived from NBER dataset)
// FIGURE 1: Net State NBER SOI Mortgage Subsidy Rate by U.S. States, 1984-2007 (%) (Derived from NBER dataset)


*******************************************
* TABLE 2:                                *
* Population Weighted Summary Statistics: *
* PSID Households, 1984-2007              *
*******************************************

// Create additional income groups for robustness checks

gen incgrp4=.
replace incgrp4=1 if income*10000<0.8*medinc
replace incgrp4=2 if (income*10000>=0.8*medinc) & (income*10000<=1.2*medinc)
replace incgrp4=3 if (income*10000>1.2*medinc) & (income*10000<=2.0*medinc)
replace incgrp4=4 if income*10000>2.0*medinc

gen incgrp5=.
replace incgrp5=1 if income*10000<0.8*medinc
replace incgrp5=2 if (income*10000>=0.8*medinc) & (income*10000<=1.2*medinc)
replace incgrp5=3 if (income*10000>1.2*medinc) & (income*10000<=1.6*medinc)
replace incgrp5=4 if (income*10000>1.6*medinc) & (income*10000<=2.0*medinc)
replace incgrp5=5 if income*10000>2.0*medinc

tab incgrp4 if insample==1
tab incgrp4 if insample_reg==1
tab incgrp5 if insample==1
tab incgrp5 if insample_reg==1
tab incgrp4, gen(incdd)
tab incgrp5, gen(inc5dd)
sum inc5dd3 inc5dd4 incdd3 inc5dd5 if insample_reg==1
sum inc5dd3 inc5dd4 incdd3 inc5dd5 if insample_reg==1 [aweight = wt05]

sort id03 year
save "dta\panel\pan7807v17final.dta", replace

// Output for TABLE 2:

// Summary Stats for Full Regression Sample (insample==1):
sum own tsmr income incd_f_1 incd_f_2 incd_f_3 ageh mar child_1 child_2 child_3p unemp unempw p1unit p5punit tnw year if insample==1 [aweight = wt05]

// Sample of Observations  with MSA-Level Information on Regulatory Restrictiveness (insample_reg==1):
sum own tsmr income incd_f_1 incd_f_2 incd_f_3 ageh mar child_1 child_2 child_3p unemp unempw p1unit p5punit tnw year reginds tsptr effr app rent inc5dd3 inc5dd4 incdd3 inc5dd5 if insample_reg==1 [aweight = wt05]


// NOTE: In Table 2 we also report the summary statistics for additional income categories for robustness checks
// We erroneously reported  non-weighted summary statistics for these income categories:
sum inc5dd3 inc5dd4 incdd3 inc5dd5 if insample_reg==1
// instead of population-weighted ones:
sum inc5dd3 inc5dd4 incdd3 inc5dd5 if insample_reg==1 [aweight = wt05]
// The differences in the means and s.d. are small


*************************************************
* TABLE 3:                                      *
* Sources of Variation in Mortgage Subsidy Rate *
*************************************************

// Preparations for TABLE 3

// Below the statistics are prepared for col. (1)-(2) of TABLE 3

sort id03 year
by id03: gen movetract=1 if centract~=centract[_n-1]
by id03: replace movetract=0 if centract==centract[_n-1]
by id03: replace movetract=. if year==1978
by id03: replace movetract=. if centract==.
by id03: replace movetract=. if centract[_n-1]==.

sort id03 year
by id03: gen movest=1 if ss~=ss[_n-1]
by id03: replace movest=0 if ss==ss[_n-1]
by id03: replace movest=. if year==1978
by id03: replace movest=. if ss==.
by id03: replace movest=. if ss[_n-1]==.

sort id03 year
by id03: gen del_tsmr=1 if tsmr~=tsmr[_n-1]
by id03: replace del_tsmr=0 if tsmr==tsmr[_n-1]
by id03: replace del_tsmr=. if year==1978
by id03: replace del_tsmr=. if tsmr==.
by id03: replace del_tsmr=. if tsmr[_n-1]==.

gen     full_allall=1 if insample==1 & del_tsmr==0 & movest==0 & movetract==0 & year~=1984 // no change in MSR - no move across tract
replace full_allall=2 if insample==1 & del_tsmr==0 & movest==0 & movetract==1 & year~=1984 // no change in MSR - move across tract within state
replace full_allall=3 if insample==1 & del_tsmr==1 & movest==0 & movetract==0 & year~=1984 // any change in MSR - no move across tract
replace full_allall=4 if insample==1 & del_tsmr==1 & movest==0 & movetract==1 & year~=1984 // any change in MSR - move across tract within state
replace full_allall=5 if insample==1 & del_tsmr==0 & movest==1                & year~=1984 // no change in MSR - across state-moves
replace full_allall=6 if insample==1 & del_tsmr==1 & movest==1                & year~=1984 // any change in MSR - acorss state-moves

// Below the statistics are prepared for col. (3)-(5) of TABLE 3

sort id03 year
by id03: gen     del_tsmr_1pp=1 if tsmr~=tsmr[_n-1] & (tsmr-tsmr[_n-1]>0.01 | tsmr-tsmr[_n-1]<-0.01)
by id03: replace del_tsmr_1pp=0 if tsmr==tsmr[_n-1] | (tsmr-tsmr[_n-1]<=0.01 & tsmr-tsmr[_n-1]>=-0.01)
by id03: replace del_tsmr_1pp=. if year==1978
by id03: replace del_tsmr_1pp=. if tsmr==.
by id03: replace del_tsmr_1pp=. if tsmr[_n-1]==.

sort id03 year
by id03: gen     del_tsmr_3pp=1 if tsmr~=tsmr[_n-1] & (tsmr-tsmr[_n-1]>0.03 | tsmr-tsmr[_n-1]<-0.03)
by id03: replace del_tsmr_3pp=0 if tsmr==tsmr[_n-1] | (tsmr-tsmr[_n-1]<=0.03 & tsmr-tsmr[_n-1]>=-0.03)
by id03: replace del_tsmr_3pp=. if year==1978
by id03: replace del_tsmr_3pp=. if tsmr==.
by id03: replace del_tsmr_3pp=. if tsmr[_n-1]==.

sort id03 year
by id03: gen     del_tsmr_5pp=1 if tsmr~=tsmr[_n-1] & (tsmr-tsmr[_n-1]>0.05 | tsmr-tsmr[_n-1]<-0.05)
by id03: replace del_tsmr_5pp=0 if tsmr==tsmr[_n-1] | (tsmr-tsmr[_n-1]<=0.05 & tsmr-tsmr[_n-1]>=-0.05)
by id03: replace del_tsmr_5pp=. if year==1978
by id03: replace del_tsmr_5pp=. if tsmr==.
by id03: replace del_tsmr_5pp=. if tsmr[_n-1]==.

gen     var_1pp=1 if insample==1 & del_tsmr_1pp==1 & movest==0 & movetract==0 & year~=1984
replace var_1pp=2 if insample==1 & del_tsmr_1pp==1 & movest==0 & movetract==1 & year~=1984
replace var_1pp=3 if insample==1 & del_tsmr_1pp==1 & movest==1                & year~=1984

gen     var_1pp_reg=1 if insample_reg==1 & del_tsmr_1pp==1 & movest==0 & movetract==0 & year~=1984
replace var_1pp_reg=2 if insample_reg==1 & del_tsmr_1pp==1 & movest==0 & movetract==1 & year~=1984
replace var_1pp_reg=3 if insample_reg==1 & del_tsmr_1pp==1 & movest==1                & year~=1984

gen     var_3pp=1 if insample==1 & del_tsmr_3pp==1 & movest==0 & movetract==0 & year~=1984
replace var_3pp=2 if insample==1 & del_tsmr_3pp==1 & movest==0 & movetract==1 & year~=1984
replace var_3pp=3 if insample==1 & del_tsmr_3pp==1 & movest==1                & year~=1984

gen     var_3pp_reg=1 if insample_reg==1 & del_tsmr_3pp==1 & movest==0 & movetract==0 & year~=1984
replace var_3pp_reg=2 if insample_reg==1 & del_tsmr_3pp==1 & movest==0 & movetract==1 & year~=1984
replace var_3pp_reg=3 if insample_reg==1 & del_tsmr_3pp==1 & movest==1                & year~=1984

gen     var_5pp=1 if insample==1 & del_tsmr_5pp==1 & movest==0 & movetract==0 & year~=1984
replace var_5pp=2 if insample==1 & del_tsmr_5pp==1 & movest==0 & movetract==1 & year~=1984
replace var_5pp=3 if insample==1 & del_tsmr_5pp==1 & movest==1                & year~=1984

gen     var_5pp_reg=1 if insample_reg==1 & del_tsmr_5pp==1 & movest==0 & movetract==0 & year~=1984
replace var_5pp_reg=2 if insample_reg==1 & del_tsmr_5pp==1 & movest==0 & movetract==1 & year~=1984
replace var_5pp_reg=3 if insample_reg==1 & del_tsmr_5pp==1 & movest==1                & year~=1984

// Output for TABLE 3 columns (1)-(5):  

tab full_allall if full_allall==1 | full_allall==2 | full_allall==5                      // provides stats for col (1)-top panel
tab full_allall if (full_allall==1 | full_allall==2 | full_allall==5) & insample_reg==1  // provides stats for col (1)-bottom panel

tab full_allall if full_allall==3 | full_allall==4 | full_allall==6                      // provides stats for col (2)-top panel 
tab full_allall if (full_allall==3 | full_allall==4 | full_allall==6) & insample_reg==1  // provides stats for col (2)-bottom panel 

tab var_1pp         // provides stats for col (3)-top panel
tab var_1pp_reg     // provides stats for col (3)-bottom panel

tab var_3pp         // provides stats for col (4)-top panel
tab var_3pp_reg     // provides stats for col (4)-bottom panel

tab var_5pp         // provides stats for col (5)-top panel
tab var_5pp_reg     // provides stats for col (5)-bottom panel


*************************************************
* TABLE 4:                                      *
* Baseline Specifications: Do Tax Subsidies     *
* Increase Homeownership Attainment             *
*************************************************

// NOTES:
// A note on clustering:
// The standard errors in all regressions are clustered by household ID & by (state x year)
// There is no need to cluster std errors by MSA or state
// tsmr DOES vary within HHs because HHs move across MSAs/states
// (If one attempts to run cluster(state), an error message appears: 'panels are not nested within clusters')

// A note on xtivreg2: 
// This is a FEs panel regression (not an FEs IV panel regression). The xtivreg2 command is used to allow for dual clustering on household ID & (state x year)
// A small & partial correction is applied. BY default xtivreg2 displays standard errors w/o a small sample adjustment. The 
// small option corrects standard errors matching results using xtreg. Partial is used due to existence of singleton variables.

// Actual sample size = 53,279 - this is also the sample size reported if xtreg is used
// Stata/SE 13.1 reports for xtivreg2: singleton groups detected: 73 observations not used 
// The sample size reported in Stata/SE 13.1 using xtivreg2 is thus: 53,206 = 53,279-73.
// The same notes apply for the subsequent estimates
// Centred and uncentred R2 are reported only in the Stata output window and the LOG file, not in the outreg2-Word document 

// A FURTHER NOTE: For Table 4 only, the published article version erroneously reports results for specifications without the small partial correction.
// The table WITHOUT the small partial correction was included instead of the table WITH the small partial correction
// Results are however essentially identical: coefficients are unchanged and standard errors change in some cases only, and if so only by the smallest of margins
// For example in col. (1) the s.e. for moderate income is (0.00942) w/o small & partial and w small & partial it is (0.00943) - all other s.e. with one further
// exception are unchanged
// Below we first replicate the results reported in Table 4 of the published version. Next we report the corrected results WITH the small partial correction. 
// Note that specifications that employ the small partial correction have a variance-covariance matrix that IS of full rank.

// Results WITHOUT small-partial correction:

**********************
* TABLE 4 column (1) *
**********************

// Estimates specification TABLE 4 column (1):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw if insample==1 [pweight = wt05], fe robust cluster(id03 stxyr)

// Produces col (1) of outreg2-TABLE 4 as Word document in folder 'outregs':
outreg2 using "outregs\hilber_turner_table_4wo.doc", se nolabel aster adjr2 replace word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

**********************
* TABLE 4 column (2) *
**********************

// Estimates specification TABLE 4 column (2):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 if insample==1 [pweight = wt05], fe robust cluster(id03 stxyr)

// Produces col (2) of outreg2-TABLE 4 as Word document:
outreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit using "hilber_turner_table_4wo.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

**********************
* TABLE 4 column (3) *
**********************

// Estimates specification TABLE 4 column (3):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 if insample==1     [pweight = wt05], fe robust cluster(id03 stxyr)

// Produces col (3) of outreg2-TABLE 4 as Word document:
outreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit yeard2-yeard25 using "hilber_turner_table_4wo.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

**********************
* TABLE 4 column (4) *
**********************

// Estimates specification TABLE 4 column (4):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 if insample==1     [pweight = wt05], fe robust cluster(id03 stxyr) 

// Produces col (4) of outreg2-TABLE 4 as Word document:
outreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit yeard2-yeard25 using "hilber_turner_table_4wo.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

**********************
* TABLE 4 column (5) *
**********************

// Estimates specification TABLE 4 column (5):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 timexmsadd1-timexmsadd293 if insample==1 [pweight = wt05], fe robust cluster(id03 stxyr)  

// Produces col (5) of outreg2-TABLE 4 as Word document:
outreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit yeard2-yeard25 using "hilber_turner_table_4wo.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

**********************
* TABLE 4 column (6) *
**********************

// Estimates specification TABLE 4 column (6):
xtivreg2 own incd_f_1xtsmr incd_f_2xtsmr incd_f_3xtsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 timexmsadd1-timexmsadd293 if insample==1 [pweight = wt05], fe robust cluster(id03 stxyr) 

// Produces col (6) of outreg2-TABLE 4 as Word document:
outreg2  own incd_f_1xtsmr incd_f_2xtsmr incd_f_3xtsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit yeard2-yeard25 using "hilber_turner_table_4wo.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 


// Results WITH small-partial correction:

**********************
* TABLE 4 column (1) *
**********************

// Estimates specification TABLE 4 column (1):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw if insample==1 [pweight = wt05], fe robust cluster(id03 stxyr) small

// Produces col (1) of outreg2-TABLE 4 as Word document in folder 'outregs':
outreg2 using "outregs\hilber_turner_table_4.doc", se nolabel aster adjr2 replace word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 


**********************
* TABLE 4 column (2) *
**********************

// Estimates specification TABLE 4 column (2):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 if insample==1 [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd290 msadd292 msadd293 stated1-stated51)

// Produces col (2) of outreg2-TABLE 4 as Word document:
outreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit using "hilber_turner_table_4.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)

**********************
* TABLE 4 column (3) *
**********************

// Estimates specification TABLE 4 column (3):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 if insample==1     [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25) 

// Produces col (3) of outreg2-TABLE 4 as Word document:
outreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit yeard2-yeard25 using "hilber_turner_table_4.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)

**********************
* TABLE 4 column (4) *
**********************

// Estimates specification TABLE 4 column (4):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 if insample==1     [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51)

// Produces col (4) of outreg2-TABLE 4 as Word document:
outreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit yeard2-yeard25 using "hilber_turner_table_4.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)

**********************
* TABLE 4 column (5) *
**********************

// Estimates specification TABLE 4 column (5):
xtivreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 timexmsadd1-timexmsadd293 if insample==1 [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 timexmsadd1-timexmsadd293) 

// Produces col (5) of outreg2-TABLE 4 as Word document:
outreg2 own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit yeard2-yeard25 using "hilber_turner_table_4.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)

**********************
* TABLE 4 column (6) *
**********************

// Estimates specification TABLE 4 column (6):
xtivreg2 own incd_f_1xtsmr incd_f_2xtsmr incd_f_3xtsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 timexmsadd1-timexmsadd293 if insample==1 [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 timexmsadd1-timexmsadd293)

// Produces col (6) of outreg2-TABLE 4 as Word document:
outreg2  own incd_f_1xtsmr incd_f_2xtsmr incd_f_3xtsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit yeard2-yeard25 using "hilber_turner_table_4.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)


*************************************************
* TABLE 5:                                      *
* Results for Specifications with Interaction   *
* Tax Subsidy x Regulatory Restrictiveness      *
* Dependent variable: HH is Owner-Occupier      *
*************************************************

// A note on clustering:
// The standard errors in all regressions are clustered by household ID & by state x year
// There is no need to cluster std errors by MSA or state
// tsmr DOES vary within HHs because HHs move across MSAs/states
// (If one attempts to run cluster(state), an error message appears: 'panels are not nested within clusters')

// A NOTE on using xtivreg2 vis-a-vis xtreg:
// We initially estimated our fixed-effects models using the xtreg command.
// We use the xtivreg2 command here because this allows us to two-way cluster our standard errors by (1) households and (2) state x year.
// One known issue with the xtivreg2 command is that for the same model one can obtain different coefficient estimates 
// compared to the xtreg command. This is because xtivreg2 can drop a different set of variables than the xtreg command to eliminate perfect
// collinearity. For the case of obtaining different coefficient estimates using xtivreg2 it has been recommended in statalist to
// reestimate the model but dropping the identical variables by hand, so that one forces the two programs to use identical regressors. 
// This yields identical coefficient estimates. See: http://www.stata.com/statalist/archive/2010-10/msg00196.html.
// We obtain different coefficient estimates for some (non-key) variables in specicifications (6) and (7) of Table 5.
// Thus our procedure is as follows: We first estimate models (6) and (7) using the xtreg command and single clustering on households.
// Next we manually drop the identical variables (from the xtreg estimation) by hand to force the xtivreg2 command to drop the identical regressors.
// This yields identical coefficients but standard errors differ as a consequence of using a different clustering procedure.


**********************
* TABLE 5 column (1) *
**********************

// Estimates specification TABLE 5 column (1):
xtivreg2 own tsmr tsmrxreginds reginds incd2 incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 if insample_reg==1 [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25)

// Produces col (1) of outreg2-TABLE 5 as Word document:
outreg2  own tsmr tsmrxreginds reginds incd2-incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit using "hilber_turner_table_5.doc", se nolabel aster adjr2 replace word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES:
// This is a FEs panel regression (not an FEs IV panel regression). The xtivreg2 command is used to allow for dual clustering
// Actual sample size = 29,621 - this is also the sample size reported if xtreg is used
// Stata/SE 13.1 reports for xtivreg2: singleton groups detected: 133 observations not used 
// The sample size reported in Stata/SE 13.1 using xtivreg2 is thus: 29,488 = 29,621-133.
// The same notes apply for the subsequent estimates
// Centred and uncentred R2 are reported only in the Stata output window and the LOG file, not in the outreg2-Word document 

**********************
* TABLE 5 column (2) *
**********************

// Estimates specification TABLE 5 column (2):
xtivreg2 own tsmr tsmrxreginds reginds incd2 incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated48 yeard9-yeard25 timexstated1- timexstated50 if insample_reg==1 [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd286 msadd292 stated5-stated48 yeard9-yeard25 timexstated1-timexstated50)

// Produces col (2) of outreg2-TABLE 5 as Word document:
outreg2  own tsmr tsmrxreginds reginds incd2-incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit using "hilber_turner_table_5.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)

**********************
* TABLE 5 column (3) *
**********************

// Estimates specification TABLE 5 column (3):
xtivreg2  own tsmr tsmrxreginds reginds incd2 incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1-timexstated50 timexmsadd20-timexmsadd293 if insample_reg==1 [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1-timexstated50 timexmsadd20-timexmsadd293)

// Produces col (3) of outreg2-TABLE 5 as Word document:
outreg2 own tsmr tsmrxreginds reginds incd2-incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit using "hilber_turner_table_5.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)

**********************
* TABLE 5 column (4) *
**********************

// Estimates specification TABLE 5 column (4):
xtivreg2   own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds incd2-incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated48 yeard9-yeard25 timexstated1- timexstated50                           if insample_reg==1         [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd286 msadd292 stated5-stated48 yeard9-yeard25 timexstated1- timexstated50)

// Produces col (4) of outreg2-TABLE 5 as Word document:
outreg2 own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds incd2-incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit using "hilber_turner_table_5.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)

**********************
* TABLE 5 column (5) *
**********************

// Estimates specification TABLE 5 column (5):
xtivreg2 own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds incd2-incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1-timexstated50 timexmsadd20-timexmsadd293 if insample_reg==1 [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1-timexstated50 timexmsadd20-timexmsadd293)

// Produces col (5) of outreg2-TABLE 5 as Word document:
outreg2 own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds incd2-incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit using "hilber_turner_table_5.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)


// Estimates specification TABLE 5 column (6) but using xtreg and cluster(id03):
xtreg own tsmr tsmrxreginds reginds incd2 incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1- timexstated50 timexmsadd20-timexmsadd293 stxid_3-stxid_1749 if insample_reg==1 [pweight = wt05], fe robust cluster(id03) 

// We now manually drop the identical variables from the xtreg estimation for Table 5(6) by hand to force the xtivreg2 command 
// to drop the identical regressors and produce correct coefficient estimates.. See 'NOTE on using xtivreg2 vis-a-vis xtreg' above under Table 5.
quietly: drop msadd3 msadd4 msadd5 msadd6 msadd7 msadd8 msadd9 msadd10 msadd11 msadd12 msadd13 msadd14 msadd15 msadd16 msadd17 msadd18 msadd19 msadd21 msadd22 msadd24 msadd25 msadd26 msadd28 msadd29 msadd30 msadd31 msadd32 msadd35 msadd36 msadd37 msadd39 msadd40 msadd42 msadd43 msadd44 msadd45 msadd46 msadd47 msadd48 msadd49 msadd50 msadd51 msadd52 msadd53 msadd54 msadd55 msadd56 msadd57 msadd58 msadd59 msadd62 msadd63 msadd64 msadd65 msadd66 msadd70 msadd71 msadd72 msadd73 msadd76 msadd78 msadd79 msadd81 msadd82 msadd83 msadd84 msadd85 msadd86 msadd88 msadd89 msadd90 msadd91 msadd92 msadd95 msadd96 msadd98 msadd99 msadd101 msadd102 msadd104 msadd107 msadd112 msadd113 msadd114 msadd115 msadd116 msadd117 msadd118 msadd119 msadd120 msadd122 msadd123 msadd124 msadd125 msadd126 msadd127 msadd128 msadd129 msadd131 msadd132 msadd133 msadd135 msadd136 msadd137 msadd138 msadd140 msadd141 msadd142 msadd143 msadd145 msadd146 msadd147 msadd148 msadd149 msadd150 msadd151 msadd152 msadd155 msadd156 msadd157 msadd158 msadd159 msadd161 msadd163 msadd165 msadd166 msadd167 msadd169 msadd170 msadd172 msadd174 msadd175 msadd176 msadd177 msadd178 msadd179 msadd180 msadd181 msadd182 msadd183 msadd184 msadd185 msadd186 msadd187 msadd188 msadd189 msadd190 msadd192 msadd193 msadd194 msadd195 msadd196 msadd197 msadd199 msadd200 msadd201 msadd202 msadd203 msadd204 msadd205 msadd206 msadd207 msadd209 msadd210 msadd211 msadd212 msadd213 msadd214 msadd215 msadd216 msadd217 msadd219 msadd220 msadd222 msadd223 msadd224 msadd225 msadd226 msadd227 msadd228 msadd229 msadd230 msadd231 msadd232 msadd233 msadd234 msadd235 msadd237 msadd238 msadd239 msadd240 msadd241 msadd242 msadd243 msadd244 msadd245 msadd246 msadd247 msadd248 msadd249 msadd250 msadd251 msadd252 msadd253 msadd254 msadd256 msadd259 msadd261 msadd262 msadd263 msadd264 msadd265 msadd266 msadd267 msadd268 msadd269 msadd271 msadd272 msadd273 msadd274 msadd275 msadd276 msadd277 msadd278 msadd279 msadd280 msadd281 msadd282 msadd283 msadd285 msadd287 msadd288 msadd289 msadd290 msadd293 stated1 stated2 stated3 stated4 stated6 stated7 stated8 stated11 stated12 stated13 stated16 stated17 stated19 stated20 stated22 stated25 stated27 stated28 stated29 stated30 stated32 stated35 stated40 stated41 stated42 stated45 stated46 stated49 stated51 timexstated2 timexstated6 timexstated8 timexstated12 timexstated13 timexstated16 timexstated20 timexstated25 timexstated27 timexstated28 timexstated29 timexstated30 timexstated32 timexstated35 timexstated42 timexstated46 timexstated49 timexstated51 timexmsadd1 timexmsadd2 timexmsadd3 timexmsadd4 timexmsadd5 timexmsadd6 timexmsadd7 timexmsadd8 timexmsadd9 timexmsadd10 timexmsadd11 timexmsadd12 timexmsadd13 timexmsadd14 timexmsadd15 timexmsadd16 timexmsadd17 timexmsadd18 timexmsadd19 timexmsadd21 timexmsadd22 timexmsadd24 timexmsadd25 timexmsadd26 timexmsadd28 timexmsadd29 timexmsadd30 timexmsadd32 timexmsadd35 timexmsadd36 timexmsadd37 timexmsadd39 timexmsadd40 timexmsadd42 timexmsadd44 timexmsadd45 timexmsadd46 timexmsadd47 timexmsadd48 timexmsadd49 timexmsadd50 timexmsadd51 timexmsadd52 timexmsadd53 timexmsadd54 timexmsadd55 timexmsadd56 timexmsadd58 timexmsadd59 timexmsadd62 timexmsadd63 timexmsadd64 timexmsadd65 timexmsadd66 timexmsadd70 timexmsadd71 timexmsadd72 timexmsadd73 timexmsadd75 timexmsadd76 timexmsadd78 timexmsadd79 timexmsadd81 timexmsadd82 timexmsadd83 timexmsadd85 timexmsadd86 timexmsadd88 timexmsadd89 timexmsadd90 timexmsadd91 timexmsadd92 timexmsadd95 timexmsadd96 timexmsadd98 timexmsadd99 timexmsadd101 timexmsadd102 timexmsadd104 timexmsadd105 timexmsadd106 timexmsadd107 timexmsadd112 timexmsadd114 timexmsadd115 timexmsadd116 timexmsadd117 timexmsadd118 timexmsadd119 timexmsadd120 timexmsadd122 timexmsadd123 timexmsadd124 timexmsadd125 timexmsadd126 timexmsadd127 timexmsadd128 timexmsadd129 timexmsadd130 timexmsadd131 timexmsadd132 timexmsadd133 timexmsadd135 timexmsadd137 timexmsadd138 timexmsadd139 timexmsadd140 timexmsadd141 timexmsadd142 timexmsadd143 timexmsadd144 timexmsadd145 timexmsadd146 timexmsadd147 timexmsadd148 timexmsadd149 timexmsadd150 timexmsadd151 timexmsadd152 timexmsadd153 timexmsadd155 timexmsadd157 timexmsadd158 timexmsadd159 timexmsadd161 timexmsadd163 timexmsadd165 timexmsadd166 timexmsadd167 timexmsadd169 timexmsadd170 timexmsadd172 timexmsadd174 timexmsadd175 timexmsadd176 timexmsadd177 timexmsadd178 timexmsadd179 timexmsadd180 timexmsadd181 timexmsadd183 timexmsadd184 timexmsadd185 timexmsadd186 timexmsadd187 timexmsadd188 timexmsadd189 timexmsadd190 timexmsadd192 timexmsadd193 timexmsadd194 timexmsadd195 timexmsadd196 timexmsadd197 timexmsadd199 timexmsadd200 timexmsadd201 timexmsadd202 timexmsadd203 timexmsadd204 timexmsadd205 timexmsadd206 timexmsadd207 timexmsadd208 timexmsadd209 timexmsadd210 timexmsadd211 timexmsadd212 timexmsadd213 timexmsadd215 timexmsadd216 timexmsadd217 timexmsadd219 timexmsadd220 timexmsadd222 timexmsadd223 timexmsadd224 timexmsadd225 timexmsadd226 timexmsadd227 timexmsadd228 timexmsadd229 timexmsadd230 timexmsadd231 timexmsadd232 timexmsadd234 timexmsadd235 timexmsadd238 timexmsadd239 timexmsadd240 timexmsadd241 timexmsadd242 timexmsadd243 timexmsadd244 timexmsadd245 timexmsadd246 timexmsadd247 timexmsadd248 timexmsadd249 timexmsadd250 timexmsadd251 timexmsadd252 timexmsadd253 timexmsadd254 timexmsadd255 timexmsadd256 timexmsadd259 timexmsadd261 timexmsadd262 timexmsadd263 timexmsadd264 timexmsadd265 timexmsadd266 timexmsadd267 timexmsadd269 timexmsadd271 timexmsadd272 timexmsadd274 timexmsadd275 timexmsadd276 timexmsadd277 timexmsadd278 timexmsadd279 timexmsadd280 timexmsadd281 timexmsadd282 timexmsadd283 timexmsadd284 timexmsadd285 timexmsadd286 timexmsadd288 timexmsadd289 timexmsadd290 timexmsadd291 timexmsadd292 stxid_2 stxid_4 stxid_5 stxid_6 stxid_7 stxid_8 stxid_9 stxid_10 stxid_11 stxid_12 stxid_14 stxid_15 stxid_17 stxid_18 stxid_19 stxid_20 stxid_21 stxid_24 stxid_29 stxid_32 stxid_33 stxid_34 stxid_36 stxid_39 stxid_40 stxid_41 stxid_42 stxid_43 stxid_45 stxid_46 stxid_52 stxid_54 stxid_55 stxid_56 stxid_58 stxid_60 stxid_61 stxid_64 stxid_65 stxid_66 stxid_67 stxid_69 stxid_70 stxid_71 stxid_72 stxid_73 stxid_74 stxid_75 stxid_76 stxid_77 stxid_78 stxid_81 stxid_82 stxid_83 stxid_88 stxid_89 stxid_90 stxid_92 stxid_93 stxid_94 stxid_96 stxid_97 stxid_98 stxid_99 stxid_101 stxid_103 stxid_105 stxid_106 stxid_107 stxid_109 stxid_111 stxid_112 stxid_114 stxid_115 stxid_116 stxid_117 stxid_118 stxid_119 stxid_122 stxid_123 stxid_124 stxid_125 stxid_126 stxid_127 stxid_128 stxid_131 stxid_133 stxid_134 stxid_136 stxid_139 stxid_142 stxid_145 stxid_146 stxid_148 stxid_150 stxid_151 stxid_152 stxid_153 stxid_155 stxid_156 stxid_157 stxid_159 stxid_162 stxid_163 stxid_164 stxid_165 stxid_166 stxid_168 stxid_169 stxid_170 stxid_172 stxid_173 stxid_174 stxid_176 stxid_177 stxid_179 stxid_180 stxid_182 stxid_183 stxid_186 stxid_192 stxid_195 stxid_197 stxid_199 stxid_202 stxid_205 stxid_206 stxid_208 stxid_209 stxid_210 stxid_211 stxid_212 stxid_213 stxid_218 stxid_219 stxid_220 stxid_221 stxid_222 stxid_223 stxid_224 stxid_226 stxid_227 stxid_228 stxid_229 stxid_233 stxid_235 stxid_236 stxid_238 stxid_239 stxid_240 stxid_242 stxid_246 stxid_250 stxid_252 stxid_253 stxid_254 stxid_255 stxid_257 stxid_259 stxid_260 stxid_261 stxid_264 stxid_267 stxid_268 stxid_269 stxid_270 stxid_271 stxid_274 stxid_275 stxid_276 stxid_277 stxid_279 stxid_280 stxid_281 stxid_282 stxid_283 stxid_284 stxid_286 stxid_287 stxid_288 stxid_289 stxid_290 stxid_291 stxid_293 stxid_294 stxid_296 stxid_298 stxid_300 stxid_302 stxid_304 stxid_305 stxid_306 stxid_307 stxid_309 stxid_310 stxid_311 stxid_313 stxid_314 stxid_315 stxid_316 stxid_317 stxid_318 stxid_319 stxid_320 stxid_321 stxid_322 stxid_323 stxid_326 stxid_327 stxid_329 stxid_330 stxid_331 stxid_332 stxid_333 stxid_334 stxid_338 stxid_340 stxid_341 stxid_346 stxid_347 stxid_348 stxid_349 stxid_350 stxid_352 stxid_356 stxid_357 stxid_359 stxid_360 stxid_361 stxid_363 stxid_364 stxid_366 stxid_367 stxid_368 stxid_369 stxid_370 stxid_371 stxid_373 stxid_374 stxid_375 stxid_379 stxid_380 stxid_381 stxid_382 stxid_383 stxid_384 stxid_386 stxid_387 stxid_390 stxid_391 stxid_393 stxid_394 stxid_395 stxid_396 stxid_397 stxid_398 stxid_399 stxid_403 stxid_406 stxid_408 stxid_409 stxid_412 stxid_413 stxid_416 stxid_417 stxid_418 stxid_420 stxid_421 stxid_423 stxid_424 stxid_425 stxid_427 stxid_428 stxid_429 stxid_430 stxid_431 stxid_432 stxid_433 stxid_436 stxid_437 stxid_438 stxid_440 stxid_444 stxid_448 stxid_450 stxid_452 stxid_461 stxid_464 stxid_466 stxid_468 stxid_471 stxid_473 stxid_474 stxid_475 stxid_478 stxid_479 stxid_484 stxid_485 stxid_486 stxid_487 stxid_488 stxid_489 stxid_491 stxid_492 stxid_493 stxid_494 stxid_495 stxid_496 stxid_497 stxid_498 stxid_499 stxid_501 stxid_502 stxid_503 stxid_504 stxid_507 stxid_508 stxid_509 stxid_511 stxid_512 stxid_514 stxid_515 stxid_516 stxid_518 stxid_520 stxid_521 stxid_522 stxid_524 stxid_526 stxid_528 stxid_530 stxid_531 stxid_532 stxid_533 stxid_535 stxid_537 stxid_538 stxid_539 stxid_543 stxid_546 stxid_547 stxid_548 stxid_549 stxid_550 stxid_551 stxid_553 stxid_557 stxid_558 stxid_559 stxid_560 stxid_561 stxid_563 stxid_565 stxid_567 stxid_569 stxid_572 stxid_574 stxid_575 stxid_577 stxid_578 stxid_579 stxid_581 stxid_582 stxid_583 stxid_585 stxid_586 stxid_588 stxid_591 stxid_592 stxid_594 stxid_597 stxid_600 stxid_601 stxid_603 stxid_607 stxid_608 stxid_609 stxid_611 stxid_612 stxid_613 stxid_614 stxid_615 stxid_616 stxid_617 stxid_618 stxid_619 stxid_622 stxid_623 stxid_624 stxid_626 stxid_627 stxid_628 stxid_631 stxid_635 stxid_636 stxid_637 stxid_638 stxid_640 stxid_641 stxid_642 stxid_643 stxid_644 stxid_645 stxid_646 stxid_647 stxid_649 stxid_651 stxid_652 stxid_657 stxid_659 stxid_660 stxid_661 stxid_662 stxid_663 stxid_665 stxid_666 stxid_669 stxid_670 stxid_671 stxid_673 stxid_674 stxid_675 stxid_678 stxid_679 stxid_681 stxid_682 stxid_684 stxid_685 stxid_686 stxid_687 stxid_690 stxid_691 stxid_695 stxid_698 stxid_700 stxid_702 stxid_703 stxid_706 stxid_707 stxid_708 stxid_709 stxid_710 stxid_711 stxid_713 stxid_714 stxid_715 stxid_716 stxid_718 stxid_719 stxid_720 stxid_723 stxid_725 stxid_728 stxid_730 stxid_731 stxid_732 stxid_734 stxid_736 stxid_737 stxid_738 stxid_740 stxid_741 stxid_742 stxid_743 stxid_746 stxid_751 stxid_754 stxid_756 stxid_759 stxid_763 stxid_764 stxid_765 stxid_767 stxid_769 stxid_770 stxid_774 stxid_775 stxid_776 stxid_777 stxid_778 stxid_779 stxid_782 stxid_783 stxid_785 stxid_788 stxid_789 stxid_793 stxid_794 stxid_795 stxid_796 stxid_797 stxid_800 stxid_801 stxid_802 stxid_803 stxid_804 stxid_806 stxid_807 stxid_808 stxid_809 stxid_810 stxid_811 stxid_814 stxid_815 stxid_816 stxid_817 stxid_820 stxid_821 stxid_823 stxid_824 stxid_825 stxid_826 stxid_828 stxid_829 stxid_830 stxid_832 stxid_833 stxid_834 stxid_835 stxid_836 stxid_837 stxid_838 stxid_844 stxid_845 stxid_846 stxid_848 stxid_849 stxid_850 stxid_853 stxid_854 stxid_855 stxid_856 stxid_857 stxid_858 stxid_860 stxid_861 stxid_862 stxid_863 stxid_864 stxid_865 stxid_866 stxid_867 stxid_868 stxid_869 stxid_871 stxid_872 stxid_873 stxid_874 stxid_876 stxid_877 stxid_878 stxid_879 stxid_880 stxid_881 stxid_882 stxid_884 stxid_885 stxid_886 stxid_887 stxid_889 stxid_890 stxid_891 stxid_892 stxid_896 stxid_897 stxid_899 stxid_900 stxid_902 stxid_903 stxid_904 stxid_906 stxid_908 stxid_909 stxid_910 stxid_911 stxid_912 stxid_914 stxid_915 stxid_917 stxid_918 stxid_919 stxid_920 stxid_921 stxid_922 stxid_923 stxid_925 stxid_926 stxid_927 stxid_928 stxid_930 stxid_932 stxid_933 stxid_934 stxid_935 stxid_936 stxid_937 stxid_938 stxid_939 stxid_941 stxid_943 stxid_946 stxid_947 stxid_948 stxid_949 stxid_950 stxid_951 stxid_952 stxid_953 stxid_957 stxid_958 stxid_959 stxid_960 stxid_966 stxid_967 stxid_968 stxid_969 stxid_971 stxid_974 stxid_975 stxid_977 stxid_978 stxid_979 stxid_981 stxid_982 stxid_983 stxid_984 stxid_985 stxid_987 stxid_988 stxid_989 stxid_990 stxid_991 stxid_992 stxid_993 stxid_994 stxid_995 stxid_996 stxid_997 stxid_998 stxid_999 stxid_1000 stxid_1001 stxid_1003 stxid_1004 stxid_1005 stxid_1007 stxid_1008 stxid_1011 stxid_1014 stxid_1015 stxid_1017 stxid_1018 stxid_1020 stxid_1024 stxid_1026 stxid_1027 stxid_1028 stxid_1030 stxid_1032 stxid_1033 stxid_1034 stxid_1037 stxid_1039 stxid_1040 stxid_1041 stxid_1042 stxid_1043 stxid_1044 stxid_1045 stxid_1046 stxid_1047 stxid_1049 stxid_1050 stxid_1051 stxid_1052 stxid_1054 stxid_1055 stxid_1056 stxid_1057 stxid_1060 stxid_1065 stxid_1067 stxid_1068 stxid_1069 stxid_1070 stxid_1071 stxid_1072 stxid_1073 stxid_1075 stxid_1076 stxid_1077 stxid_1078 stxid_1080 stxid_1081 stxid_1082 stxid_1083 stxid_1084 stxid_1086 stxid_1087 stxid_1089 stxid_1090 stxid_1091 stxid_1092 stxid_1093 stxid_1094 stxid_1095 stxid_1096 stxid_1097 stxid_1098 stxid_1099 stxid_1102 stxid_1103 stxid_1105 stxid_1106 stxid_1107 stxid_1108 stxid_1110 stxid_1112 stxid_1116 stxid_1117 stxid_1118 stxid_1119 stxid_1120 stxid_1121 stxid_1122 stxid_1124 stxid_1126 stxid_1128 stxid_1129 stxid_1130 stxid_1131 stxid_1133 stxid_1134 stxid_1135 stxid_1136 stxid_1137 stxid_1138 stxid_1139 stxid_1140 stxid_1142 stxid_1144 stxid_1145 stxid_1147 stxid_1149 stxid_1150 stxid_1151 stxid_1152 stxid_1153 stxid_1154 stxid_1155 stxid_1156 stxid_1157 stxid_1159 stxid_1160 stxid_1162 stxid_1163 stxid_1164 stxid_1165 stxid_1166 stxid_1167 stxid_1168 stxid_1169 stxid_1170 stxid_1171 stxid_1172 stxid_1173 stxid_1174 stxid_1175 stxid_1176 stxid_1177 stxid_1178 stxid_1179 stxid_1180 stxid_1181 stxid_1182 stxid_1183 stxid_1184 stxid_1186 stxid_1187 stxid_1188 stxid_1189 stxid_1190 stxid_1191 stxid_1193 stxid_1194 stxid_1195 stxid_1196 stxid_1197 stxid_1198 stxid_1199 stxid_1200 stxid_1201 stxid_1202 stxid_1204 stxid_1205 stxid_1206 stxid_1207 stxid_1208 stxid_1209 stxid_1210 stxid_1211 stxid_1212 stxid_1213 stxid_1214 stxid_1217 stxid_1219 stxid_1220 stxid_1221 stxid_1222 stxid_1224 stxid_1225 stxid_1227 stxid_1228 stxid_1229 stxid_1230 stxid_1231 stxid_1232 stxid_1233 stxid_1234 stxid_1235 stxid_1236 stxid_1237 stxid_1238 stxid_1241 stxid_1242 stxid_1245 stxid_1246 stxid_1247 stxid_1248 stxid_1249 stxid_1250 stxid_1252 stxid_1253 stxid_1254 stxid_1256 stxid_1257 stxid_1258 stxid_1259 stxid_1260 stxid_1261 stxid_1262 stxid_1263 stxid_1264 stxid_1265 stxid_1267 stxid_1268 stxid_1270 stxid_1272 stxid_1273 stxid_1274 stxid_1275 stxid_1276 stxid_1278 stxid_1280 stxid_1282 stxid_1283 stxid_1284 stxid_1285 stxid_1286 stxid_1287 stxid_1288 stxid_1289 stxid_1291 stxid_1292 stxid_1293 stxid_1294 stxid_1296 stxid_1297 stxid_1298 stxid_1299 stxid_1300 stxid_1302 stxid_1304 stxid_1305 stxid_1306 stxid_1307 stxid_1308 stxid_1310 stxid_1312 stxid_1313 stxid_1314 stxid_1315 stxid_1316 stxid_1317 stxid_1319 stxid_1320 stxid_1321 stxid_1322 stxid_1323 stxid_1325 stxid_1327 stxid_1328 stxid_1329 stxid_1330 stxid_1331 stxid_1332 stxid_1334 stxid_1335 stxid_1337 stxid_1338 stxid_1339 stxid_1340 stxid_1341 stxid_1342 stxid_1343 stxid_1344 stxid_1345 stxid_1347 stxid_1348 stxid_1349 stxid_1350 stxid_1351 stxid_1352 stxid_1354 stxid_1356 stxid_1357 stxid_1358 stxid_1359 stxid_1360 stxid_1361 stxid_1362 stxid_1364 stxid_1365 stxid_1366 stxid_1367 stxid_1368 stxid_1370 stxid_1372 stxid_1373 stxid_1374 stxid_1375 stxid_1376 stxid_1377 stxid_1378 stxid_1379 stxid_1380 stxid_1381 stxid_1383 stxid_1385 stxid_1386 stxid_1387 stxid_1391 stxid_1394 stxid_1395 stxid_1397 stxid_1398 stxid_1400 stxid_1401 stxid_1402 stxid_1404 stxid_1406 stxid_1407 stxid_1408 stxid_1409 stxid_1410 stxid_1411 stxid_1412 stxid_1413 stxid_1414 stxid_1416 stxid_1419 stxid_1421 stxid_1422 stxid_1423 stxid_1424 stxid_1425 stxid_1426 stxid_1427 stxid_1428 stxid_1429 stxid_1430 stxid_1431 stxid_1432 stxid_1433 stxid_1434 stxid_1435 stxid_1436 stxid_1437 stxid_1438 stxid_1440 stxid_1441 stxid_1442 stxid_1443 stxid_1444 stxid_1445 stxid_1446 stxid_1447 stxid_1448 stxid_1449 stxid_1451 stxid_1452 stxid_1453 stxid_1454 stxid_1455 stxid_1456 stxid_1458 stxid_1460 stxid_1461 stxid_1462 stxid_1463 stxid_1464 stxid_1466 stxid_1467 stxid_1468 stxid_1470 stxid_1472 stxid_1473 stxid_1475 stxid_1476 stxid_1477 stxid_1478 stxid_1479 stxid_1480 stxid_1481 stxid_1482 stxid_1483 stxid_1484 stxid_1485 stxid_1487 stxid_1488 stxid_1489 stxid_1490 stxid_1491 stxid_1492 stxid_1493 stxid_1494 stxid_1496 stxid_1497 stxid_1498 stxid_1499 stxid_1500 stxid_1501 stxid_1502 stxid_1503 stxid_1504 stxid_1505 stxid_1506 stxid_1507 stxid_1508 stxid_1509 stxid_1510 stxid_1511 stxid_1512 stxid_1513 stxid_1515 stxid_1516 stxid_1517 stxid_1518 stxid_1519 stxid_1520 stxid_1521 stxid_1522 stxid_1523 stxid_1524 stxid_1525 stxid_1526 stxid_1527 stxid_1528 stxid_1530 stxid_1531 stxid_1532 stxid_1533 stxid_1534 stxid_1535 stxid_1537 stxid_1538 stxid_1541 stxid_1542 stxid_1543 stxid_1544 stxid_1545 stxid_1546 stxid_1547 stxid_1548 stxid_1549 stxid_1550 stxid_1551 stxid_1554 stxid_1555 stxid_1556 stxid_1557 stxid_1558 stxid_1559 stxid_1561 stxid_1563 stxid_1565 stxid_1566 stxid_1567 stxid_1568 stxid_1569 stxid_1570 stxid_1571 stxid_1572 stxid_1573 stxid_1574 stxid_1575 stxid_1577 stxid_1578 stxid_1579 stxid_1580 stxid_1581 stxid_1583 stxid_1584 stxid_1585 stxid_1586 stxid_1587 stxid_1588 stxid_1591 stxid_1592 stxid_1593 stxid_1594 stxid_1595 stxid_1598 stxid_1599 stxid_1600 stxid_1601 stxid_1602 stxid_1603 stxid_1604 stxid_1605 stxid_1608 stxid_1609 stxid_1614 stxid_1615 stxid_1616 stxid_1617 stxid_1618 stxid_1620 stxid_1622 stxid_1623 stxid_1624 stxid_1626 stxid_1627 stxid_1628 stxid_1629 stxid_1630 stxid_1631 stxid_1632 stxid_1633 stxid_1635 stxid_1636 stxid_1637 stxid_1639 stxid_1640 stxid_1641 stxid_1642 stxid_1643 stxid_1644 stxid_1645 stxid_1647 stxid_1648 stxid_1650 stxid_1651 stxid_1652 stxid_1653 stxid_1654 stxid_1656 stxid_1658 stxid_1659 stxid_1660 stxid_1661 stxid_1663 stxid_1666 stxid_1668 stxid_1669 stxid_1671 stxid_1674 stxid_1675 stxid_1676 stxid_1680 stxid_1681 stxid_1682 stxid_1683 stxid_1685 stxid_1686 stxid_1688 stxid_1689 stxid_1690 stxid_1691 stxid_1692 stxid_1693 stxid_1694 stxid_1695 stxid_1696 stxid_1697 stxid_1698 stxid_1699 stxid_1700 stxid_1702 stxid_1703 stxid_1704 stxid_1705 stxid_1706 stxid_1707 stxid_1708 stxid_1710 stxid_1711 stxid_1712 stxid_1713 stxid_1714 stxid_1716 stxid_1718 stxid_1719 stxid_1720 stxid_1721 stxid_1722 stxid_1723 stxid_1724 stxid_1726 stxid_1727 stxid_1728 stxid_1729 stxid_1730 stxid_1731 stxid_1732 stxid_1733 stxid_1734 stxid_1735 stxid_1736 stxid_1737 stxid_1739 stxid_1740 stxid_1742 stxid_1744 stxid_1745 stxid_1746 stxid_1747 stxid_1748 stxid_1750 // drop collinear dummies - ensures consistent set of FEs across all Table 5 specifications / see robustness checks

**********************
* TABLE 5 column (6) *
**********************

// Estimates specification TABLE 5 column (6):
xtivreg2 own tsmr tsmrxreginds reginds incd2 incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1- timexstated50 timexmsadd20-timexmsadd293 stxid_3-stxid_1749 if insample_reg==1 [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1-timexstated50 timexmsadd20-timexmsadd293 stxid_3-stxid_1749)

// Produces col (6) of outreg2-TABLE 5 as Word document:
outreg2 own tsmr tsmrxreginds reginds incd2-incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit using "hilber_turner_table_5.doc", se nolabel aster adjr2 append word nor2  addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)


// Recreate all FEs by reopening 'final' dataset
drop _all
cd "D:\ChH\Research\Working Papers\DiPa80 (PSIDPanel)\"
use "dta\panel\pan7807v17final.dta"

// Estimates specification TABLE 5 column (7) but using xtreg and cluster(id03):
xtreg own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds incd2-incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit  msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1-timexstated50 timexmsadd20-timexmsadd293 stxid_3-stxid_1749 if insample_reg==1 [pweight = wt05], fe robust cluster(id03) 

**********************
* TABLE 5 column (7) *
**********************

// We now manually drop the identical variables from the xtreg estimation for Table 5(7) by hand to force the xtivreg2 command 
// to drop the identical regressors and produce correct coefficient estimates. See 'NOTE on using xtivreg2 vis-a-vis xtreg' above under Table 5.
quietly: drop msadd3 msadd4 msadd5 msadd6 msadd7 msadd8 msadd9 msadd10 msadd11 msadd12 msadd13 msadd14 msadd15 msadd16 msadd17 msadd18 msadd19 msadd21 msadd22 msadd24 msadd25 msadd26 msadd28 msadd29 msadd30 msadd31 msadd32 msadd35 msadd36 msadd37 msadd39 msadd40 msadd42 msadd43 msadd44 msadd45 msadd46 msadd47 msadd48 msadd49 msadd50 msadd51 msadd52 msadd53 msadd54 msadd55 msadd56 msadd57 msadd58 msadd59 msadd62 msadd63 msadd64 msadd65 msadd66 msadd70 msadd71 msadd72 msadd73 msadd76 msadd78 msadd79 msadd81 msadd82 msadd83 msadd84 msadd85 msadd86 msadd88 msadd89 msadd90 msadd91 msadd92 msadd95 msadd96 msadd98 msadd99 msadd101 msadd102 msadd104 msadd107 msadd112 msadd113 msadd114 msadd115 msadd116 msadd117 msadd118 msadd119 msadd120 msadd122 msadd123 msadd124 msadd125 msadd126 msadd127 msadd128 msadd129 msadd131 msadd132 msadd133 msadd135 msadd136 msadd137 msadd138 msadd140 msadd141 msadd142 msadd143 msadd145 msadd146 msadd147 msadd148 msadd149 msadd150 msadd151 msadd152 msadd155 msadd156 msadd157 msadd158 msadd159 msadd161 msadd163 msadd165 msadd166 msadd167 msadd169 msadd170 msadd172 msadd174 msadd175 msadd176 msadd177 msadd178 msadd179 msadd180 msadd181 msadd182 msadd183 msadd184 msadd185 msadd186 msadd187 msadd188 msadd189 msadd190 msadd192 msadd193 msadd194 msadd195 msadd196 msadd197 msadd199 msadd200 msadd201 msadd202 msadd203 msadd204 msadd205 msadd206 msadd207 msadd209 msadd210 msadd211 msadd212 msadd213 msadd214 msadd215 msadd216 msadd217 msadd219 msadd220 msadd222 msadd223 msadd224 msadd225 msadd226 msadd227 msadd228 msadd229 msadd230 msadd231 msadd232 msadd233 msadd234 msadd235 msadd237 msadd238 msadd239 msadd240 msadd241 msadd242 msadd243 msadd244 msadd245 msadd246 msadd247 msadd248 msadd249 msadd250 msadd251 msadd252 msadd253 msadd254 msadd256 msadd259 msadd261 msadd262 msadd263 msadd264 msadd265 msadd266 msadd267 msadd268 msadd269 msadd271 msadd272 msadd273 msadd274 msadd275 msadd276 msadd277 msadd278 msadd279 msadd280 msadd281 msadd283 msadd285 msadd287 msadd288 msadd289 msadd290 msadd293 stated1 stated2 stated3 stated4 stated6 stated7 stated8 stated11 stated12 stated13 stated16 stated17 stated19 stated20 stated22 stated25 stated27 stated28 stated29 stated30 stated32 stated35 stated40 stated41 stated42 stated43 stated45 stated46 stated49 stated51 timexstated2 timexstated6 timexstated8 timexstated12 timexstated13 timexstated16 timexstated20 timexstated25 timexstated27 timexstated28 timexstated29 timexstated30 timexstated32 timexstated35 timexstated42 timexstated46 timexstated49 timexstated51 timexmsadd1 timexmsadd2 timexmsadd3 timexmsadd4 timexmsadd5 timexmsadd6 timexmsadd7 timexmsadd8 timexmsadd9 timexmsadd10 timexmsadd11 timexmsadd12 timexmsadd13 timexmsadd14 timexmsadd15 timexmsadd16 timexmsadd17 timexmsadd18 timexmsadd19 timexmsadd21 timexmsadd22 timexmsadd24 timexmsadd25 timexmsadd26 timexmsadd28 timexmsadd29 timexmsadd30 timexmsadd32 timexmsadd35 timexmsadd36 timexmsadd37 timexmsadd39 timexmsadd40 timexmsadd42 timexmsadd44 timexmsadd45 timexmsadd46 timexmsadd47 timexmsadd48 timexmsadd49 timexmsadd50 timexmsadd51 timexmsadd52 timexmsadd53 timexmsadd54 timexmsadd55 timexmsadd56 timexmsadd58 timexmsadd59 timexmsadd62 timexmsadd63 timexmsadd64 timexmsadd65 timexmsadd66 timexmsadd70 timexmsadd71 timexmsadd72 timexmsadd73 timexmsadd75 timexmsadd76 timexmsadd78 timexmsadd79 timexmsadd81 timexmsadd82 timexmsadd83 timexmsadd85 timexmsadd86 timexmsadd88 timexmsadd89 timexmsadd90 timexmsadd91 timexmsadd92 timexmsadd95 timexmsadd96 timexmsadd98 timexmsadd99 timexmsadd101 timexmsadd102 timexmsadd104 timexmsadd105 timexmsadd106 timexmsadd107 timexmsadd112 timexmsadd114 timexmsadd115 timexmsadd116 timexmsadd117 timexmsadd118 timexmsadd119 timexmsadd120 timexmsadd122 timexmsadd123 timexmsadd124 timexmsadd125 timexmsadd126 timexmsadd127 timexmsadd128 timexmsadd129 timexmsadd130 timexmsadd131 timexmsadd132 timexmsadd133 timexmsadd135 timexmsadd137 timexmsadd138 timexmsadd139 timexmsadd140 timexmsadd141 timexmsadd142 timexmsadd143 timexmsadd144 timexmsadd145 timexmsadd146 timexmsadd147 timexmsadd148 timexmsadd149 timexmsadd150 timexmsadd151 timexmsadd152 timexmsadd153 timexmsadd155 timexmsadd157 timexmsadd158 timexmsadd159 timexmsadd161 timexmsadd163 timexmsadd165 timexmsadd166 timexmsadd167 timexmsadd169 timexmsadd170 timexmsadd172 timexmsadd174 timexmsadd175 timexmsadd176 timexmsadd177 timexmsadd178 timexmsadd179 timexmsadd180 timexmsadd181 timexmsadd183 timexmsadd184 timexmsadd185 timexmsadd186 timexmsadd187 timexmsadd188 timexmsadd189 timexmsadd190 timexmsadd192 timexmsadd193 timexmsadd194 timexmsadd195 timexmsadd196 timexmsadd197 timexmsadd199 timexmsadd200 timexmsadd201 timexmsadd202 timexmsadd203 timexmsadd204 timexmsadd205 timexmsadd206 timexmsadd207 timexmsadd208 timexmsadd209 timexmsadd210 timexmsadd211 timexmsadd212 timexmsadd213 timexmsadd215 timexmsadd216 timexmsadd217 timexmsadd219 timexmsadd220 timexmsadd222 timexmsadd223 timexmsadd224 timexmsadd225 timexmsadd226 timexmsadd227 timexmsadd228 timexmsadd229 timexmsadd230 timexmsadd231 timexmsadd232 timexmsadd234 timexmsadd235 timexmsadd238 timexmsadd239 timexmsadd240 timexmsadd241 timexmsadd242 timexmsadd243 timexmsadd244 timexmsadd245 timexmsadd246 timexmsadd247 timexmsadd248 timexmsadd249 timexmsadd250 timexmsadd251 timexmsadd252 timexmsadd253 timexmsadd254 timexmsadd255 timexmsadd256 timexmsadd259 timexmsadd261 timexmsadd262 timexmsadd263 timexmsadd264 timexmsadd265 timexmsadd266 timexmsadd267 timexmsadd269 timexmsadd271 timexmsadd272 timexmsadd274 timexmsadd275 timexmsadd276 timexmsadd277 timexmsadd278 timexmsadd279 timexmsadd280 timexmsadd281 timexmsadd282 timexmsadd283 timexmsadd284 timexmsadd285 timexmsadd286 timexmsadd288 timexmsadd289 timexmsadd290 timexmsadd291 timexmsadd292 stxid_2 stxid_4 stxid_5 stxid_6 stxid_9 stxid_10 stxid_11 stxid_12 stxid_14 stxid_15 stxid_16 stxid_17 stxid_18 stxid_19 stxid_20 stxid_21 stxid_27 stxid_29 stxid_32 stxid_33 stxid_34 stxid_39 stxid_40 stxid_41 stxid_42 stxid_43 stxid_45 stxid_46 stxid_52 stxid_54 stxid_56 stxid_58 stxid_60 stxid_61 stxid_64 stxid_65 stxid_66 stxid_67 stxid_69 stxid_70 stxid_71 stxid_72 stxid_73 stxid_74 stxid_75 stxid_76 stxid_77 stxid_78 stxid_79 stxid_81 stxid_82 stxid_83 stxid_84 stxid_88 stxid_89 stxid_90 stxid_92 stxid_93 stxid_94 stxid_96 stxid_97 stxid_98 stxid_99 stxid_101 stxid_103 stxid_105 stxid_107 stxid_109 stxid_110 stxid_111 stxid_112 stxid_114 stxid_115 stxid_116 stxid_118 stxid_119 stxid_122 stxid_123 stxid_124 stxid_126 stxid_127 stxid_128 stxid_131 stxid_133 stxid_134 stxid_136 stxid_139 stxid_142 stxid_144 stxid_145 stxid_147 stxid_148 stxid_150 stxid_151 stxid_152 stxid_153 stxid_156 stxid_157 stxid_159 stxid_162 stxid_163 stxid_164 stxid_165 stxid_168 stxid_169 stxid_170 stxid_172 stxid_173 stxid_174 stxid_176 stxid_177 stxid_179 stxid_180 stxid_182 stxid_183 stxid_186 stxid_191 stxid_192 stxid_195 stxid_197 stxid_199 stxid_202 stxid_205 stxid_208 stxid_209 stxid_210 stxid_211 stxid_212 stxid_213 stxid_214 stxid_218 stxid_219 stxid_220 stxid_221 stxid_222 stxid_223 stxid_224 stxid_225 stxid_226 stxid_227 stxid_228 stxid_229 stxid_232 stxid_233 stxid_235 stxid_236 stxid_238 stxid_239 stxid_240 stxid_241 stxid_242 stxid_243 stxid_244 stxid_245 stxid_246 stxid_249 stxid_250 stxid_252 stxid_253 stxid_254 stxid_255 stxid_256 stxid_257 stxid_259 stxid_260 stxid_261 stxid_263 stxid_264 stxid_267 stxid_268 stxid_269 stxid_270 stxid_271 stxid_273 stxid_274 stxid_275 stxid_276 stxid_277 stxid_279 stxid_280 stxid_281 stxid_282 stxid_283 stxid_284 stxid_285 stxid_286 stxid_287 stxid_288 stxid_289 stxid_290 stxid_291 stxid_293 stxid_294 stxid_296 stxid_297 stxid_298 stxid_302 stxid_304 stxid_305 stxid_306 stxid_307 stxid_308 stxid_309 stxid_310 stxid_311 stxid_313 stxid_314 stxid_315 stxid_316 stxid_319 stxid_321 stxid_322 stxid_323 stxid_326 stxid_327 stxid_329 stxid_330 stxid_331 stxid_332 stxid_333 stxid_334 stxid_336 stxid_340 stxid_342 stxid_347 stxid_352 stxid_356 stxid_357 stxid_359 stxid_360 stxid_361 stxid_363 stxid_364 stxid_365 stxid_366 stxid_367 stxid_368 stxid_369 stxid_370 stxid_371 stxid_374 stxid_375 stxid_377 stxid_378 stxid_379 stxid_380 stxid_382 stxid_383 stxid_384 stxid_385 stxid_386 stxid_387 stxid_388 stxid_390 stxid_391 stxid_392 stxid_393 stxid_394 stxid_395 stxid_396 stxid_397 stxid_398 stxid_399 stxid_403 stxid_404 stxid_406 stxid_408 stxid_409 stxid_410 stxid_412 stxid_413 stxid_416 stxid_417 stxid_418 stxid_420 stxid_421 stxid_424 stxid_425 stxid_427 stxid_428 stxid_429 stxid_430 stxid_431 stxid_432 stxid_433 stxid_436 stxid_437 stxid_438 stxid_440 stxid_448 stxid_450 stxid_451 stxid_459 stxid_461 stxid_464 stxid_468 stxid_469 stxid_471 stxid_473 stxid_474 stxid_475 stxid_478 stxid_479 stxid_483 stxid_484 stxid_485 stxid_486 stxid_487 stxid_488 stxid_489 stxid_492 stxid_493 stxid_494 stxid_495 stxid_496 stxid_497 stxid_498 stxid_499 stxid_501 stxid_502 stxid_503 stxid_504 stxid_508 stxid_509 stxid_511 stxid_512 stxid_515 stxid_516 stxid_518 stxid_521 stxid_522 stxid_524 stxid_528 stxid_530 stxid_532 stxid_533 stxid_535 stxid_537 stxid_538 stxid_539 stxid_542 stxid_543 stxid_546 stxid_547 stxid_548 stxid_549 stxid_550 stxid_551 stxid_553 stxid_556 stxid_557 stxid_558 stxid_559 stxid_560 stxid_561 stxid_565 stxid_566 stxid_567 stxid_569 stxid_572 stxid_574 stxid_575 stxid_576 stxid_577 stxid_578 stxid_579 stxid_581 stxid_582 stxid_585 stxid_586 stxid_588 stxid_589 stxid_591 stxid_592 stxid_593 stxid_594 stxid_597 stxid_598 stxid_601 stxid_603 stxid_605 stxid_607 stxid_608 stxid_609 stxid_612 stxid_613 stxid_614 stxid_615 stxid_616 stxid_617 stxid_618 stxid_619 stxid_622 stxid_623 stxid_624 stxid_627 stxid_628 stxid_631 stxid_636 stxid_637 stxid_638 stxid_641 stxid_642 stxid_643 stxid_644 stxid_645 stxid_646 stxid_647 stxid_649 stxid_651 stxid_652 stxid_657 stxid_659 stxid_660 stxid_661 stxid_662 stxid_663 stxid_667 stxid_669 stxid_671 stxid_672 stxid_673 stxid_674 stxid_677 stxid_678 stxid_679 stxid_681 stxid_682 stxid_683 stxid_685 stxid_686 stxid_687 stxid_689 stxid_690 stxid_691 stxid_693 stxid_695 stxid_698 stxid_700 stxid_701 stxid_702 stxid_703 stxid_706 stxid_707 stxid_709 stxid_710 stxid_711 stxid_712 stxid_713 stxid_715 stxid_718 stxid_719 stxid_720 stxid_722 stxid_723 stxid_728 stxid_729 stxid_730 stxid_731 stxid_732 stxid_733 stxid_734 stxid_735 stxid_737 stxid_738 stxid_741 stxid_742 stxid_743 stxid_746 stxid_751 stxid_754 stxid_759 stxid_761 stxid_763 stxid_764 stxid_765 stxid_767 stxid_769 stxid_770 stxid_774 stxid_775 stxid_776 stxid_778 stxid_779 stxid_782 stxid_783 stxid_785 stxid_786 stxid_788 stxid_789 stxid_790 stxid_791 stxid_793 stxid_794 stxid_795 stxid_796 stxid_797 stxid_800 stxid_801 stxid_802 stxid_803 stxid_804 stxid_806 stxid_807 stxid_808 stxid_810 stxid_814 stxid_815 stxid_816 stxid_817 stxid_818 stxid_820 stxid_821 stxid_823 stxid_824 stxid_825 stxid_826 stxid_828 stxid_829 stxid_830 stxid_832 stxid_833 stxid_834 stxid_835 stxid_836 stxid_837 stxid_838 stxid_841 stxid_844 stxid_845 stxid_846 stxid_848 stxid_849 stxid_850 stxid_852 stxid_853 stxid_854 stxid_855 stxid_856 stxid_857 stxid_858 stxid_860 stxid_861 stxid_862 stxid_863 stxid_864 stxid_865 stxid_866 stxid_867 stxid_868 stxid_869 stxid_871 stxid_872 stxid_873 stxid_874 stxid_875 stxid_876 stxid_877 stxid_878 stxid_879 stxid_880 stxid_881 stxid_882 stxid_883 stxid_884 stxid_886 stxid_887 stxid_889 stxid_890 stxid_891 stxid_892 stxid_894 stxid_896 stxid_897 stxid_898 stxid_900 stxid_902 stxid_903 stxid_904 stxid_906 stxid_907 stxid_908 stxid_909 stxid_910 stxid_911 stxid_912 stxid_913 stxid_914 stxid_915 stxid_917 stxid_918 stxid_919 stxid_920 stxid_921 stxid_922 stxid_923 stxid_925 stxid_926 stxid_927 stxid_928 stxid_929 stxid_930 stxid_932 stxid_933 stxid_934 stxid_935 stxid_936 stxid_937 stxid_938 stxid_939 stxid_941 stxid_943 stxid_945 stxid_946 stxid_947 stxid_948 stxid_949 stxid_950 stxid_951 stxid_952 stxid_953 stxid_954 stxid_956 stxid_957 stxid_958 stxid_959 stxid_960 stxid_966 stxid_967 stxid_968 stxid_969 stxid_970 stxid_972 stxid_973 stxid_974 stxid_975 stxid_977 stxid_978 stxid_979 stxid_981 stxid_982 stxid_983 stxid_984 stxid_985 stxid_987 stxid_988 stxid_989 stxid_990 stxid_992 stxid_994 stxid_995 stxid_996 stxid_997 stxid_998 stxid_999 stxid_1001 stxid_1002 stxid_1003 stxid_1004 stxid_1005 stxid_1008 stxid_1010 stxid_1011 stxid_1014 stxid_1015 stxid_1016 stxid_1017 stxid_1018 stxid_1020 stxid_1022 stxid_1023 stxid_1024 stxid_1026 stxid_1027 stxid_1028 stxid_1030 stxid_1032 stxid_1033 stxid_1034 stxid_1037 stxid_1040 stxid_1041 stxid_1042 stxid_1043 stxid_1044 stxid_1046 stxid_1047 stxid_1049 stxid_1050 stxid_1051 stxid_1052 stxid_1053 stxid_1054 stxid_1056 stxid_1060 stxid_1061 stxid_1065 stxid_1066 stxid_1067 stxid_1069 stxid_1070 stxid_1071 stxid_1072 stxid_1073 stxid_1075 stxid_1076 stxid_1078 stxid_1080 stxid_1081 stxid_1084 stxid_1085 stxid_1086 stxid_1087 stxid_1088 stxid_1089 stxid_1090 stxid_1091 stxid_1092 stxid_1093 stxid_1094 stxid_1095 stxid_1097 stxid_1098 stxid_1099 stxid_1102 stxid_1103 stxid_1105 stxid_1106 stxid_1107 stxid_1108 stxid_1110 stxid_1111 stxid_1112 stxid_1116 stxid_1117 stxid_1118 stxid_1119 stxid_1120 stxid_1121 stxid_1122 stxid_1124 stxid_1126 stxid_1128 stxid_1129 stxid_1130 stxid_1131 stxid_1133 stxid_1135 stxid_1136 stxid_1137 stxid_1138 stxid_1140 stxid_1141 stxid_1142 stxid_1143 stxid_1144 stxid_1145 stxid_1147 stxid_1149 stxid_1150 stxid_1151 stxid_1152 stxid_1153 stxid_1154 stxid_1155 stxid_1156 stxid_1157 stxid_1159 stxid_1160 stxid_1162 stxid_1163 stxid_1164 stxid_1165 stxid_1166 stxid_1167 stxid_1168 stxid_1169 stxid_1170 stxid_1171 stxid_1172 stxid_1173 stxid_1174 stxid_1175 stxid_1176 stxid_1177 stxid_1178 stxid_1179 stxid_1180 stxid_1181 stxid_1182 stxid_1183 stxid_1184 stxid_1186 stxid_1187 stxid_1188 stxid_1189 stxid_1190 stxid_1191 stxid_1192 stxid_1193 stxid_1195 stxid_1196 stxid_1197 stxid_1198 stxid_1199 stxid_1200 stxid_1201 stxid_1202 stxid_1203 stxid_1205 stxid_1206 stxid_1207 stxid_1208 stxid_1210 stxid_1211 stxid_1212 stxid_1213 stxid_1214 stxid_1217 stxid_1218 stxid_1219 stxid_1220 stxid_1224 stxid_1225 stxid_1228 stxid_1229 stxid_1230 stxid_1231 stxid_1232 stxid_1233 stxid_1234 stxid_1235 stxid_1236 stxid_1237 stxid_1239 stxid_1241 stxid_1242 stxid_1245 stxid_1246 stxid_1247 stxid_1248 stxid_1249 stxid_1250 stxid_1252 stxid_1253 stxid_1254 stxid_1255 stxid_1256 stxid_1257 stxid_1258 stxid_1259 stxid_1260 stxid_1261 stxid_1262 stxid_1263 stxid_1267 stxid_1268 stxid_1270 stxid_1272 stxid_1273 stxid_1275 stxid_1276 stxid_1277 stxid_1278 stxid_1282 stxid_1283 stxid_1284 stxid_1285 stxid_1286 stxid_1288 stxid_1289 stxid_1290 stxid_1291 stxid_1292 stxid_1293 stxid_1294 stxid_1296 stxid_1297 stxid_1298 stxid_1299 stxid_1300 stxid_1302 stxid_1304 stxid_1305 stxid_1307 stxid_1308 stxid_1309 stxid_1310 stxid_1312 stxid_1313 stxid_1315 stxid_1316 stxid_1317 stxid_1319 stxid_1320 stxid_1321 stxid_1322 stxid_1323 stxid_1325 stxid_1327 stxid_1329 stxid_1330 stxid_1331 stxid_1332 stxid_1333 stxid_1334 stxid_1335 stxid_1337 stxid_1338 stxid_1339 stxid_1340 stxid_1341 stxid_1342 stxid_1343 stxid_1344 stxid_1345 stxid_1346 stxid_1347 stxid_1348 stxid_1350 stxid_1351 stxid_1352 stxid_1355 stxid_1357 stxid_1358 stxid_1359 stxid_1361 stxid_1362 stxid_1364 stxid_1365 stxid_1366 stxid_1367 stxid_1368 stxid_1370 stxid_1372 stxid_1373 stxid_1374 stxid_1375 stxid_1376 stxid_1377 stxid_1378 stxid_1379 stxid_1380 stxid_1381 stxid_1382 stxid_1385 stxid_1386 stxid_1387 stxid_1389 stxid_1391 stxid_1393 stxid_1394 stxid_1395 stxid_1397 stxid_1398 stxid_1400 stxid_1401 stxid_1402 stxid_1404 stxid_1407 stxid_1408 stxid_1409 stxid_1410 stxid_1411 stxid_1412 stxid_1413 stxid_1414 stxid_1416 stxid_1421 stxid_1422 stxid_1423 stxid_1424 stxid_1425 stxid_1426 stxid_1428 stxid_1429 stxid_1430 stxid_1431 stxid_1432 stxid_1433 stxid_1434 stxid_1435 stxid_1436 stxid_1437 stxid_1438 stxid_1439 stxid_1440 stxid_1441 stxid_1442 stxid_1443 stxid_1444 stxid_1445 stxid_1447 stxid_1448 stxid_1449 stxid_1451 stxid_1452 stxid_1453 stxid_1454 stxid_1455 stxid_1456 stxid_1458 stxid_1460 stxid_1461 stxid_1462 stxid_1463 stxid_1464 stxid_1466 stxid_1468 stxid_1469 stxid_1472 stxid_1473 stxid_1475 stxid_1476 stxid_1477 stxid_1479 stxid_1480 stxid_1481 stxid_1482 stxid_1484 stxid_1487 stxid_1488 stxid_1490 stxid_1491 stxid_1493 stxid_1494 stxid_1496 stxid_1497 stxid_1499 stxid_1500 stxid_1501 stxid_1502 stxid_1503 stxid_1504 stxid_1505 stxid_1506 stxid_1507 stxid_1508 stxid_1510 stxid_1511 stxid_1512 stxid_1513 stxid_1516 stxid_1517 stxid_1518 stxid_1519 stxid_1520 stxid_1521 stxid_1522 stxid_1523 stxid_1524 stxid_1525 stxid_1526 stxid_1527 stxid_1528 stxid_1530 stxid_1531 stxid_1532 stxid_1533 stxid_1534 stxid_1535 stxid_1536 stxid_1537 stxid_1538 stxid_1540 stxid_1541 stxid_1542 stxid_1543 stxid_1544 stxid_1545 stxid_1546 stxid_1547 stxid_1548 stxid_1549 stxid_1550 stxid_1551 stxid_1552 stxid_1555 stxid_1556 stxid_1557 stxid_1558 stxid_1559 stxid_1561 stxid_1562 stxid_1563 stxid_1565 stxid_1567 stxid_1569 stxid_1570 stxid_1571 stxid_1572 stxid_1573 stxid_1574 stxid_1575 stxid_1577 stxid_1578 stxid_1579 stxid_1580 stxid_1581 stxid_1583 stxid_1584 stxid_1585 stxid_1586 stxid_1587 stxid_1588 stxid_1592 stxid_1594 stxid_1595 stxid_1598 stxid_1599 stxid_1600 stxid_1601 stxid_1602 stxid_1603 stxid_1604 stxid_1605 stxid_1607 stxid_1608 stxid_1609 stxid_1613 stxid_1614 stxid_1615 stxid_1616 stxid_1617 stxid_1618 stxid_1620 stxid_1622 stxid_1623 stxid_1624 stxid_1626 stxid_1627 stxid_1628 stxid_1629 stxid_1630 stxid_1631 stxid_1632 stxid_1633 stxid_1635 stxid_1636 stxid_1637 stxid_1639 stxid_1640 stxid_1641 stxid_1642 stxid_1644 stxid_1645 stxid_1646 stxid_1647 stxid_1649 stxid_1650 stxid_1651 stxid_1652 stxid_1653 stxid_1654 stxid_1656 stxid_1657 stxid_1658 stxid_1659 stxid_1661 stxid_1662 stxid_1663 stxid_1664 stxid_1665 stxid_1666 stxid_1669 stxid_1674 stxid_1675 stxid_1676 stxid_1678 stxid_1679 stxid_1680 stxid_1681 stxid_1682 stxid_1683 stxid_1685 stxid_1686 stxid_1688 stxid_1689 stxid_1690 stxid_1691 stxid_1692 stxid_1693 stxid_1694 stxid_1695 stxid_1696 stxid_1697 stxid_1698 stxid_1699 stxid_1700 stxid_1701 stxid_1702 stxid_1703 stxid_1704 stxid_1705 stxid_1706 stxid_1707 stxid_1708 stxid_1710 stxid_1711 stxid_1712 stxid_1713 stxid_1714 stxid_1716 stxid_1718 stxid_1719 stxid_1721 stxid_1722 stxid_1723 stxid_1724 stxid_1726 stxid_1727 stxid_1728 stxid_1729 stxid_1730 stxid_1731 stxid_1732 stxid_1733 stxid_1734 stxid_1735 stxid_1736 stxid_1737 stxid_1740 stxid_1741 stxid_1742 stxid_1744 stxid_1745 stxid_1746 stxid_1747 stxid_1750

// Estimates specification TABLE 5 column (7):
xtivreg2 own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds incd2-incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit  msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1-timexstated50 timexmsadd20-timexmsadd293 stxid_3-stxid_1749 if insample_reg==1 [pweight = wt05], fe robust cluster(id03 stxyr) small partial(msadd2-msadd286 msadd292          stated5-stated50 yeard9-yeard25 timexstated1- timexstated50 timexmsadd20-timexmsadd293 stxid_3-stxid_1749)

// Produces col (7) of outreg2-TABLE 5 as Word document:
outreg2 own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds incd2-incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit using "hilber_turner_table_5.doc", se nolabel aster adjr2 append word nor2 addstat("R-squared overall model", e(r2_o), "R-squared within model", e(r2_w), "R-squared between model", e(r2_b)) 

// NOTES: See under column (1)


************************
* TABLE 6:             *
* Quantitative Effects *
************************

// Recreate all FEs by reopening 'final' dataset
drop _all
cd "D:\ChH\Research\Working Papers\DiPa80 (PSIDPanel)\"
use "dta\panel\pan7807v17final.dta"

*********************
* Table 6 - Panel A *
*********************

// Produces statistics for TABLE 6, first row (based on TABLE 4(1)): 
quietly: xtreg own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw if insample==1 [pweight = wt05], fe robust
predict xb_t41 if e(sample), xb
gen xb_t41nmrs=xb_t41+0.128*tsmr
sum xb_t41 xb_t41nmrs if e(sample)
gen t41_change=0 if e(sample)
replace t41_change=1 if xb_t41nmrs<0.5 & xb_t41>0.5 & e(sample)
replace t41_change=-1 if xb_t41nmrs>0.5 & xb_t41<0.5 & e(sample)
sum t41_change if e(sample)
tab t41_change if e(sample)

// NOTE: The standard errors here are not clustered on HHs and state x year - but the coefficients are identical to those reported in Table 4
// and thus the quantitative effects reported here (and in Table 6) are correct
// We have to use the xtreg command here rather than the xtivreg2 command since the latter does not support 'predict xb'
// The same comment applies to all other specifications reported under TABLE 6

// Produces statistics for TABLE 6, 2nd row (based on TABLE 4(2)):
quietly: xtreg own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 if insample==1 [pweight = wt05], fe robust 
predict xb_t42 if e(sample)
gen xb_t42nmrs=xb_t42+0.0453*tsmr
sum xb_t42 xb_t42nmrs if e(sample)
gen t42_change=0 if e(sample)
replace t42_change=1 if xb_t42nmrs<0.5 & xb_t42>0.5 & e(sample)
replace t42_change=-1 if xb_t42nmrs>0.5 & xb_t42<0.5 & e(sample)
sum t42_change if e(sample)
tab t42_change if e(sample)

// Produces statistics for TABLE 6, 3rd row (based on TABLE 4(3)): 
quietly: xtreg own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 if insample==1     [pweight = wt05], fe robust
predict xb_t43 if e(sample)
gen xb_t43nmrs=xb_t43+0.223*tsmr
sum xb_t43 xb_t43nmrs if e(sample)
gen t43_change=0 if e(sample)
replace t43_change=1 if xb_t43nmrs<0.5 & xb_t43>0.5 & e(sample)
replace t43_change=-1 if xb_t43nmrs>0.5 & xb_t43<0.5 & e(sample)
sum t43_change if e(sample)
tab t43_change if e(sample)

// Produces statistics for TABLE 6, 4th row (based on TABLE 4(4)): 
quietly: xtreg own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 if insample==1     [pweight = wt05], fe robust
predict xb_t44 if e(sample)
gen xb_t44nmrs=xb_t44+0.0882*tsmr
sum xb_t44 xb_t44nmrs if e(sample)
gen t44_change=0 if e(sample)
replace t44_change=1 if xb_t44nmrs<0.5 & xb_t44>0.5 & e(sample)
replace t44_change=-1 if xb_t44nmrs>0.5 & xb_t44<0.5 & e(sample)
sum t44_change if e(sample)
tab t44_change if e(sample)

// Produces statistics for TABLE 6, 5th row (based on TABLE 4(5)): 
quietly: xtreg own tsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 timexmsadd1-timexmsadd293 if insample==1 [pweight = wt05], fe robust
predict xb_t45 if e(sample)
gen xb_t45nmrs=xb_t45+0.0455*tsmr 
sum xb_t45 xb_t45nmrs if e(sample)
gen t45_change=0 if e(sample)
replace t45_change=1 if xb_t45nmrs<0.5 & xb_t45>0.5 & e(sample)
replace t45_change=-1 if xb_t45nmrs>0.5 & xb_t45<0.5 & e(sample)
sum t45_change if e(sample)
tab t45_change if e(sample)

// Produces statistics for TABLE 6, 6th row (based on TABLE 4(6)): 
quietly: xtreg own incd_f_1xtsmr incd_f_2xtsmr incd_f_3xtsmr incd_f_2 incd_f_3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd290 msadd292 msadd293 stated1-stated51 yeard2-yeard25 timexstated1-timexstated51 timexmsadd1-timexmsadd293 if insample==1 [pweight = wt05], fe robust 
predict xb_t46 if e(sample)
gen xb_t46nmrs=xb_t46+0.245*incd_f_1xtsmr+0.172*incd_f_2xtsmr-0.0420*incd_f_3xtsmr 
sum xb_t46 xb_t46nmrs if e(sample)
gen t46_change=0 if e(sample)
replace t46_change=1 if xb_t46nmrs<0.5 & xb_t46>0.5 & e(sample)
replace t46_change=-1 if xb_t46nmrs>0.5 & xb_t46<0.5 & e(sample)
sum t46_change if e(sample)
tab t46_change if e(sample)

// Produces statistics for TABLE 6, 7th row (based on TABLE 5(1)): 
quietly: xtreg    own tsmr tsmrxreginds reginds incd2 incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 if insample_reg==1 [pweight = wt05], fe robust 
predict xb_t51 if e(sample)
gen xb_t51nmrs=xb_t51-0.101*tsmr+0.329*tsmr*reginds
sum xb_t51 xb_t51nmrs if e(sample)
gen t51_change=0 if e(sample)
replace t51_change=1 if xb_t51nmrs<0.5 & xb_t51>0.5 & e(sample)
replace t51_change=-1 if xb_t51nmrs>0.5 & xb_t51<0.5 & e(sample)
sum t51_change if e(sample)
tab t51_change if e(sample)

// Produces statistics for TABLE 6, 8th row (based on TABLE 5(2)): 
quietly: xtreg own tsmr tsmrxreginds reginds incd2 incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated48 yeard9-yeard25 timexstated1- timexstated50 if insample_reg==1 [pweight = wt05], fe robust
predict xb_t52 if e(sample)
gen xb_t52nmrs=xb_t52-0.0531*tsmr+0.485*tsmr*reginds
sum xb_t52 xb_t52nmrs if e(sample)
gen t52_change=0 if e(sample)
replace t52_change=1 if xb_t52nmrs<0.5 & xb_t52>0.5 & e(sample)
replace t52_change=-1 if xb_t52nmrs>0.5 & xb_t52<0.5 & e(sample)
sum t52_change if e(sample)
tab t52_change if e(sample)

// Produces statistics for TABLE 6, 9th row (based on TABLE 5(3)): 
quietly: xtreg own tsmr tsmrxreginds reginds incd2 incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1-timexstated50 timexmsadd20-timexmsadd293 if insample_reg==1         [pweight = wt05], fe robust 
predict xb_t53 if e(sample)
gen xb_t53nmrs=xb_t53-0.100*tsmr+0.457*tsmr*reginds
sum xb_t53 xb_t53nmrs if e(sample)
gen t53_change=0 if e(sample)
replace t53_change=1 if xb_t53nmrs<0.5 & xb_t53>0.5 & e(sample)
replace t53_change=-1 if xb_t53nmrs>0.5 & xb_t53<0.5 & e(sample)
sum t53_change if e(sample)
tab t53_change if e(sample)

// Produces statistics for TABLE 6, 10th row (based on TABLE 5(4)): 
quietly: xtreg own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds incd2-incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated48 yeard9-yeard25 timexstated1- timexstated50                           if insample_reg==1         [pweight = wt05], fe robust
predict xb_t54 if e(sample)
gen xb_t54nmrs=xb_t54+0.106*incd1xtsmr-0.149*incd1xtsmrxreginds+0.0720*incd2xtsmr+0.544*incd2xtsmrxreginds-0.195*incd3xtsmr+0.619*incd3xtsmrxreginds 
sum xb_t54 xb_t54nmrs if e(sample)
gen t54_change=0 if e(sample)
replace t54_change=1 if xb_t54nmrs<0.5 & xb_t54>0.5 & e(sample)
replace t54_change=-1 if xb_t54nmrs>0.5 & xb_t54<0.5 & e(sample)
sum t54_change if e(sample)
tab t54_change if e(sample)

// Produces statistics for TABLE 6, 11th row (based on TABLE 5(5)):
quietly: xtreg   own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds            incd2-incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292 stated5-stated50 yeard9-yeard25 timexstated1-timexstated50 timexmsadd20-timexmsadd293 if insample_reg==1         [pweight = wt05], fe robust cluster(id03) 
predict xb_t55 if e(sample)
gen xb_t55nmrs=xb_t55+0.0281*incd1xtsmr-0.177*incd1xtsmrxreginds+0.0424*incd2xtsmr+0.507*incd2xtsmrxreginds-0.237*incd3xtsmr+0.589*incd3xtsmrxreginds 
sum xb_t55 xb_t55nmrs if e(sample)
gen t55_change=0 if e(sample)
replace t55_change=1 if xb_t55nmrs<0.5 & xb_t55>0.5 & e(sample)
replace t55_change=-1 if xb_t55nmrs>0.5 & xb_t55<0.5 & e(sample)
sum t55_change if e(sample)
tab t55_change if e(sample)

// Recreate all FEs by reopening 'final' dataset
drop _all
cd "D:\ChH\Research\Working Papers\DiPa80 (PSIDPanel)\"
use "dta\panel\pan7807v17final.dta"

// drop collinear dummies - ensures consistent set of FEs across all Table 5(6) specifications / see robustness checks
quietly: drop msadd3 msadd4 msadd5 msadd6 msadd7 msadd8 msadd9 msadd10 msadd11 msadd12 msadd13 msadd14 msadd15 msadd16 msadd17 msadd18 msadd19 msadd21 msadd22 msadd24 msadd25 msadd26 msadd28 msadd29 msadd30 msadd31 msadd32 msadd35 msadd36 msadd37 msadd39 msadd40 msadd42 msadd43 msadd44 msadd45 msadd46 msadd47 msadd48 msadd49 msadd50 msadd51 msadd52 msadd53 msadd54 msadd55 msadd56 msadd57 msadd58 msadd59 msadd62 msadd63 msadd64 msadd65 msadd66 msadd70 msadd71 msadd72 msadd73 msadd76 msadd78 msadd79 msadd81 msadd82 msadd83 msadd84 msadd85 msadd86 msadd88 msadd89 msadd90 msadd91 msadd92 msadd95 msadd96 msadd98 msadd99 msadd101 msadd102 msadd104 msadd107 msadd112 msadd113 msadd114 msadd115 msadd116 msadd117 msadd118 msadd119 msadd120 msadd122 msadd123 msadd124 msadd125 msadd126 msadd127 msadd128 msadd129 msadd131 msadd132 msadd133 msadd135 msadd136 msadd137 msadd138 msadd140 msadd141 msadd142 msadd143 msadd145 msadd146 msadd147 msadd148 msadd149 msadd150 msadd151 msadd152 msadd155 msadd156 msadd157 msadd158 msadd159 msadd161 msadd163 msadd165 msadd166 msadd167 msadd169 msadd170 msadd172 msadd174 msadd175 msadd176 msadd177 msadd178 msadd179 msadd180 msadd181 msadd182 msadd183 msadd184 msadd185 msadd186 msadd187 msadd188 msadd189 msadd190 msadd192 msadd193 msadd194 msadd195 msadd196 msadd197 msadd199 msadd200 msadd201 msadd202 msadd203 msadd204 msadd205 msadd206 msadd207 msadd209 msadd210 msadd211 msadd212 msadd213 msadd214 msadd215 msadd216 msadd217 msadd219 msadd220 msadd222 msadd223 msadd224 msadd225 msadd226 msadd227 msadd228 msadd229 msadd230 msadd231 msadd232 msadd233 msadd234 msadd235 msadd237 msadd238 msadd239 msadd240 msadd241 msadd242 msadd243 msadd244 msadd245 msadd246 msadd247 msadd248 msadd249 msadd250 msadd251 msadd252 msadd253 msadd254 msadd256 msadd259 msadd261 msadd262 msadd263 msadd264 msadd265 msadd266 msadd267 msadd268 msadd269 msadd271 msadd272 msadd273 msadd274 msadd275 msadd276 msadd277 msadd278 msadd279 msadd280 msadd281 msadd282 msadd283 msadd285 msadd287 msadd288 msadd289 msadd290 msadd293 stated1 stated2 stated3 stated4 stated6 stated7 stated8 stated11 stated12 stated13 stated16 stated17 stated19 stated20 stated22 stated25 stated27 stated28 stated29 stated30 stated32 stated35 stated40 stated41 stated42 stated45 stated46 stated49 stated51 timexstated2 timexstated6 timexstated8 timexstated12 timexstated13 timexstated16 timexstated20 timexstated25 timexstated27 timexstated28 timexstated29 timexstated30 timexstated32 timexstated35 timexstated42 timexstated46 timexstated49 timexstated51 timexmsadd1 timexmsadd2 timexmsadd3 timexmsadd4 timexmsadd5 timexmsadd6 timexmsadd7 timexmsadd8 timexmsadd9 timexmsadd10 timexmsadd11 timexmsadd12 timexmsadd13 timexmsadd14 timexmsadd15 timexmsadd16 timexmsadd17 timexmsadd18 timexmsadd19 timexmsadd21 timexmsadd22 timexmsadd24 timexmsadd25 timexmsadd26 timexmsadd28 timexmsadd29 timexmsadd30 timexmsadd32 timexmsadd35 timexmsadd36 timexmsadd37 timexmsadd39 timexmsadd40 timexmsadd42 timexmsadd44 timexmsadd45 timexmsadd46 timexmsadd47 timexmsadd48 timexmsadd49 timexmsadd50 timexmsadd51 timexmsadd52 timexmsadd53 timexmsadd54 timexmsadd55 timexmsadd56 timexmsadd58 timexmsadd59 timexmsadd62 timexmsadd63 timexmsadd64 timexmsadd65 timexmsadd66 timexmsadd70 timexmsadd71 timexmsadd72 timexmsadd73 timexmsadd75 timexmsadd76 timexmsadd78 timexmsadd79 timexmsadd81 timexmsadd82 timexmsadd83 timexmsadd85 timexmsadd86 timexmsadd88 timexmsadd89 timexmsadd90 timexmsadd91 timexmsadd92 timexmsadd95 timexmsadd96 timexmsadd98 timexmsadd99 timexmsadd101 timexmsadd102 timexmsadd104 timexmsadd105 timexmsadd106 timexmsadd107 timexmsadd112 timexmsadd114 timexmsadd115 timexmsadd116 timexmsadd117 timexmsadd118 timexmsadd119 timexmsadd120 timexmsadd122 timexmsadd123 timexmsadd124 timexmsadd125 timexmsadd126 timexmsadd127 timexmsadd128 timexmsadd129 timexmsadd130 timexmsadd131 timexmsadd132 timexmsadd133 timexmsadd135 timexmsadd137 timexmsadd138 timexmsadd139 timexmsadd140 timexmsadd141 timexmsadd142 timexmsadd143 timexmsadd144 timexmsadd145 timexmsadd146 timexmsadd147 timexmsadd148 timexmsadd149 timexmsadd150 timexmsadd151 timexmsadd152 timexmsadd153 timexmsadd155 timexmsadd157 timexmsadd158 timexmsadd159 timexmsadd161 timexmsadd163 timexmsadd165 timexmsadd166 timexmsadd167 timexmsadd169 timexmsadd170 timexmsadd172 timexmsadd174 timexmsadd175 timexmsadd176 timexmsadd177 timexmsadd178 timexmsadd179 timexmsadd180 timexmsadd181 timexmsadd183 timexmsadd184 timexmsadd185 timexmsadd186 timexmsadd187 timexmsadd188 timexmsadd189 timexmsadd190 timexmsadd192 timexmsadd193 timexmsadd194 timexmsadd195 timexmsadd196 timexmsadd197 timexmsadd199 timexmsadd200 timexmsadd201 timexmsadd202 timexmsadd203 timexmsadd204 timexmsadd205 timexmsadd206 timexmsadd207 timexmsadd208 timexmsadd209 timexmsadd210 timexmsadd211 timexmsadd212 timexmsadd213 timexmsadd215 timexmsadd216 timexmsadd217 timexmsadd219 timexmsadd220 timexmsadd222 timexmsadd223 timexmsadd224 timexmsadd225 timexmsadd226 timexmsadd227 timexmsadd228 timexmsadd229 timexmsadd230 timexmsadd231 timexmsadd232 timexmsadd234 timexmsadd235 timexmsadd238 timexmsadd239 timexmsadd240 timexmsadd241 timexmsadd242 timexmsadd243 timexmsadd244 timexmsadd245 timexmsadd246 timexmsadd247 timexmsadd248 timexmsadd249 timexmsadd250 timexmsadd251 timexmsadd252 timexmsadd253 timexmsadd254 timexmsadd255 timexmsadd256 timexmsadd259 timexmsadd261 timexmsadd262 timexmsadd263 timexmsadd264 timexmsadd265 timexmsadd266 timexmsadd267 timexmsadd269 timexmsadd271 timexmsadd272 timexmsadd274 timexmsadd275 timexmsadd276 timexmsadd277 timexmsadd278 timexmsadd279 timexmsadd280 timexmsadd281 timexmsadd282 timexmsadd283 timexmsadd284 timexmsadd285 timexmsadd286 timexmsadd288 timexmsadd289 timexmsadd290 timexmsadd291 timexmsadd292 stxid_2 stxid_4 stxid_5 stxid_6 stxid_7 stxid_8 stxid_9 stxid_10 stxid_11 stxid_12 stxid_14 stxid_15 stxid_17 stxid_18 stxid_19 stxid_20 stxid_21 stxid_24 stxid_29 stxid_32 stxid_33 stxid_34 stxid_36 stxid_39 stxid_40 stxid_41 stxid_42 stxid_43 stxid_45 stxid_46 stxid_52 stxid_54 stxid_55 stxid_56 stxid_58 stxid_60 stxid_61 stxid_64 stxid_65 stxid_66 stxid_67 stxid_69 stxid_70 stxid_71 stxid_72 stxid_73 stxid_74 stxid_75 stxid_76 stxid_77 stxid_78 stxid_81 stxid_82 stxid_83 stxid_88 stxid_89 stxid_90 stxid_92 stxid_93 stxid_94 stxid_96 stxid_97 stxid_98 stxid_99 stxid_101 stxid_103 stxid_105 stxid_106 stxid_107 stxid_109 stxid_111 stxid_112 stxid_114 stxid_115 stxid_116 stxid_117 stxid_118 stxid_119 stxid_122 stxid_123 stxid_124 stxid_125 stxid_126 stxid_127 stxid_128 stxid_131 stxid_133 stxid_134 stxid_136 stxid_139 stxid_142 stxid_145 stxid_146 stxid_148 stxid_150 stxid_151 stxid_152 stxid_153 stxid_155 stxid_156 stxid_157 stxid_159 stxid_162 stxid_163 stxid_164 stxid_165 stxid_166 stxid_168 stxid_169 stxid_170 stxid_172 stxid_173 stxid_174 stxid_176 stxid_177 stxid_179 stxid_180 stxid_182 stxid_183 stxid_186 stxid_192 stxid_195 stxid_197 stxid_199 stxid_202 stxid_205 stxid_206 stxid_208 stxid_209 stxid_210 stxid_211 stxid_212 stxid_213 stxid_218 stxid_219 stxid_220 stxid_221 stxid_222 stxid_223 stxid_224 stxid_226 stxid_227 stxid_228 stxid_229 stxid_233 stxid_235 stxid_236 stxid_238 stxid_239 stxid_240 stxid_242 stxid_246 stxid_250 stxid_252 stxid_253 stxid_254 stxid_255 stxid_257 stxid_259 stxid_260 stxid_261 stxid_264 stxid_267 stxid_268 stxid_269 stxid_270 stxid_271 stxid_274 stxid_275 stxid_276 stxid_277 stxid_279 stxid_280 stxid_281 stxid_282 stxid_283 stxid_284 stxid_286 stxid_287 stxid_288 stxid_289 stxid_290 stxid_291 stxid_293 stxid_294 stxid_296 stxid_298 stxid_300 stxid_302 stxid_304 stxid_305 stxid_306 stxid_307 stxid_309 stxid_310 stxid_311 stxid_313 stxid_314 stxid_315 stxid_316 stxid_317 stxid_318 stxid_319 stxid_320 stxid_321 stxid_322 stxid_323 stxid_326 stxid_327 stxid_329 stxid_330 stxid_331 stxid_332 stxid_333 stxid_334 stxid_338 stxid_340 stxid_341 stxid_346 stxid_347 stxid_348 stxid_349 stxid_350 stxid_352 stxid_356 stxid_357 stxid_359 stxid_360 stxid_361 stxid_363 stxid_364 stxid_366 stxid_367 stxid_368 stxid_369 stxid_370 stxid_371 stxid_373 stxid_374 stxid_375 stxid_379 stxid_380 stxid_381 stxid_382 stxid_383 stxid_384 stxid_386 stxid_387 stxid_390 stxid_391 stxid_393 stxid_394 stxid_395 stxid_396 stxid_397 stxid_398 stxid_399 stxid_403 stxid_406 stxid_408 stxid_409 stxid_412 stxid_413 stxid_416 stxid_417 stxid_418 stxid_420 stxid_421 stxid_423 stxid_424 stxid_425 stxid_427 stxid_428 stxid_429 stxid_430 stxid_431 stxid_432 stxid_433 stxid_436 stxid_437 stxid_438 stxid_440 stxid_444 stxid_448 stxid_450 stxid_452 stxid_461 stxid_464 stxid_466 stxid_468 stxid_471 stxid_473 stxid_474 stxid_475 stxid_478 stxid_479 stxid_484 stxid_485 stxid_486 stxid_487 stxid_488 stxid_489 stxid_491 stxid_492 stxid_493 stxid_494 stxid_495 stxid_496 stxid_497 stxid_498 stxid_499 stxid_501 stxid_502 stxid_503 stxid_504 stxid_507 stxid_508 stxid_509 stxid_511 stxid_512 stxid_514 stxid_515 stxid_516 stxid_518 stxid_520 stxid_521 stxid_522 stxid_524 stxid_526 stxid_528 stxid_530 stxid_531 stxid_532 stxid_533 stxid_535 stxid_537 stxid_538 stxid_539 stxid_543 stxid_546 stxid_547 stxid_548 stxid_549 stxid_550 stxid_551 stxid_553 stxid_557 stxid_558 stxid_559 stxid_560 stxid_561 stxid_563 stxid_565 stxid_567 stxid_569 stxid_572 stxid_574 stxid_575 stxid_577 stxid_578 stxid_579 stxid_581 stxid_582 stxid_583 stxid_585 stxid_586 stxid_588 stxid_591 stxid_592 stxid_594 stxid_597 stxid_600 stxid_601 stxid_603 stxid_607 stxid_608 stxid_609 stxid_611 stxid_612 stxid_613 stxid_614 stxid_615 stxid_616 stxid_617 stxid_618 stxid_619 stxid_622 stxid_623 stxid_624 stxid_626 stxid_627 stxid_628 stxid_631 stxid_635 stxid_636 stxid_637 stxid_638 stxid_640 stxid_641 stxid_642 stxid_643 stxid_644 stxid_645 stxid_646 stxid_647 stxid_649 stxid_651 stxid_652 stxid_657 stxid_659 stxid_660 stxid_661 stxid_662 stxid_663 stxid_665 stxid_666 stxid_669 stxid_670 stxid_671 stxid_673 stxid_674 stxid_675 stxid_678 stxid_679 stxid_681 stxid_682 stxid_684 stxid_685 stxid_686 stxid_687 stxid_690 stxid_691 stxid_695 stxid_698 stxid_700 stxid_702 stxid_703 stxid_706 stxid_707 stxid_708 stxid_709 stxid_710 stxid_711 stxid_713 stxid_714 stxid_715 stxid_716 stxid_718 stxid_719 stxid_720 stxid_723 stxid_725 stxid_728 stxid_730 stxid_731 stxid_732 stxid_734 stxid_736 stxid_737 stxid_738 stxid_740 stxid_741 stxid_742 stxid_743 stxid_746 stxid_751 stxid_754 stxid_756 stxid_759 stxid_763 stxid_764 stxid_765 stxid_767 stxid_769 stxid_770 stxid_774 stxid_775 stxid_776 stxid_777 stxid_778 stxid_779 stxid_782 stxid_783 stxid_785 stxid_788 stxid_789 stxid_793 stxid_794 stxid_795 stxid_796 stxid_797 stxid_800 stxid_801 stxid_802 stxid_803 stxid_804 stxid_806 stxid_807 stxid_808 stxid_809 stxid_810 stxid_811 stxid_814 stxid_815 stxid_816 stxid_817 stxid_820 stxid_821 stxid_823 stxid_824 stxid_825 stxid_826 stxid_828 stxid_829 stxid_830 stxid_832 stxid_833 stxid_834 stxid_835 stxid_836 stxid_837 stxid_838 stxid_844 stxid_845 stxid_846 stxid_848 stxid_849 stxid_850 stxid_853 stxid_854 stxid_855 stxid_856 stxid_857 stxid_858 stxid_860 stxid_861 stxid_862 stxid_863 stxid_864 stxid_865 stxid_866 stxid_867 stxid_868 stxid_869 stxid_871 stxid_872 stxid_873 stxid_874 stxid_876 stxid_877 stxid_878 stxid_879 stxid_880 stxid_881 stxid_882 stxid_884 stxid_885 stxid_886 stxid_887 stxid_889 stxid_890 stxid_891 stxid_892 stxid_896 stxid_897 stxid_899 stxid_900 stxid_902 stxid_903 stxid_904 stxid_906 stxid_908 stxid_909 stxid_910 stxid_911 stxid_912 stxid_914 stxid_915 stxid_917 stxid_918 stxid_919 stxid_920 stxid_921 stxid_922 stxid_923 stxid_925 stxid_926 stxid_927 stxid_928 stxid_930 stxid_932 stxid_933 stxid_934 stxid_935 stxid_936 stxid_937 stxid_938 stxid_939 stxid_941 stxid_943 stxid_946 stxid_947 stxid_948 stxid_949 stxid_950 stxid_951 stxid_952 stxid_953 stxid_957 stxid_958 stxid_959 stxid_960 stxid_966 stxid_967 stxid_968 stxid_969 stxid_971 stxid_974 stxid_975 stxid_977 stxid_978 stxid_979 stxid_981 stxid_982 stxid_983 stxid_984 stxid_985 stxid_987 stxid_988 stxid_989 stxid_990 stxid_991 stxid_992 stxid_993 stxid_994 stxid_995 stxid_996 stxid_997 stxid_998 stxid_999 stxid_1000 stxid_1001 stxid_1003 stxid_1004 stxid_1005 stxid_1007 stxid_1008 stxid_1011 stxid_1014 stxid_1015 stxid_1017 stxid_1018 stxid_1020 stxid_1024 stxid_1026 stxid_1027 stxid_1028 stxid_1030 stxid_1032 stxid_1033 stxid_1034 stxid_1037 stxid_1039 stxid_1040 stxid_1041 stxid_1042 stxid_1043 stxid_1044 stxid_1045 stxid_1046 stxid_1047 stxid_1049 stxid_1050 stxid_1051 stxid_1052 stxid_1054 stxid_1055 stxid_1056 stxid_1057 stxid_1060 stxid_1065 stxid_1067 stxid_1068 stxid_1069 stxid_1070 stxid_1071 stxid_1072 stxid_1073 stxid_1075 stxid_1076 stxid_1077 stxid_1078 stxid_1080 stxid_1081 stxid_1082 stxid_1083 stxid_1084 stxid_1086 stxid_1087 stxid_1089 stxid_1090 stxid_1091 stxid_1092 stxid_1093 stxid_1094 stxid_1095 stxid_1096 stxid_1097 stxid_1098 stxid_1099 stxid_1102 stxid_1103 stxid_1105 stxid_1106 stxid_1107 stxid_1108 stxid_1110 stxid_1112 stxid_1116 stxid_1117 stxid_1118 stxid_1119 stxid_1120 stxid_1121 stxid_1122 stxid_1124 stxid_1126 stxid_1128 stxid_1129 stxid_1130 stxid_1131 stxid_1133 stxid_1134 stxid_1135 stxid_1136 stxid_1137 stxid_1138 stxid_1139 stxid_1140 stxid_1142 stxid_1144 stxid_1145 stxid_1147 stxid_1149 stxid_1150 stxid_1151 stxid_1152 stxid_1153 stxid_1154 stxid_1155 stxid_1156 stxid_1157 stxid_1159 stxid_1160 stxid_1162 stxid_1163 stxid_1164 stxid_1165 stxid_1166 stxid_1167 stxid_1168 stxid_1169 stxid_1170 stxid_1171 stxid_1172 stxid_1173 stxid_1174 stxid_1175 stxid_1176 stxid_1177 stxid_1178 stxid_1179 stxid_1180 stxid_1181 stxid_1182 stxid_1183 stxid_1184 stxid_1186 stxid_1187 stxid_1188 stxid_1189 stxid_1190 stxid_1191 stxid_1193 stxid_1194 stxid_1195 stxid_1196 stxid_1197 stxid_1198 stxid_1199 stxid_1200 stxid_1201 stxid_1202 stxid_1204 stxid_1205 stxid_1206 stxid_1207 stxid_1208 stxid_1209 stxid_1210 stxid_1211 stxid_1212 stxid_1213 stxid_1214 stxid_1217 stxid_1219 stxid_1220 stxid_1221 stxid_1222 stxid_1224 stxid_1225 stxid_1227 stxid_1228 stxid_1229 stxid_1230 stxid_1231 stxid_1232 stxid_1233 stxid_1234 stxid_1235 stxid_1236 stxid_1237 stxid_1238 stxid_1241 stxid_1242 stxid_1245 stxid_1246 stxid_1247 stxid_1248 stxid_1249 stxid_1250 stxid_1252 stxid_1253 stxid_1254 stxid_1256 stxid_1257 stxid_1258 stxid_1259 stxid_1260 stxid_1261 stxid_1262 stxid_1263 stxid_1264 stxid_1265 stxid_1267 stxid_1268 stxid_1270 stxid_1272 stxid_1273 stxid_1274 stxid_1275 stxid_1276 stxid_1278 stxid_1280 stxid_1282 stxid_1283 stxid_1284 stxid_1285 stxid_1286 stxid_1287 stxid_1288 stxid_1289 stxid_1291 stxid_1292 stxid_1293 stxid_1294 stxid_1296 stxid_1297 stxid_1298 stxid_1299 stxid_1300 stxid_1302 stxid_1304 stxid_1305 stxid_1306 stxid_1307 stxid_1308 stxid_1310 stxid_1312 stxid_1313 stxid_1314 stxid_1315 stxid_1316 stxid_1317 stxid_1319 stxid_1320 stxid_1321 stxid_1322 stxid_1323 stxid_1325 stxid_1327 stxid_1328 stxid_1329 stxid_1330 stxid_1331 stxid_1332 stxid_1334 stxid_1335 stxid_1337 stxid_1338 stxid_1339 stxid_1340 stxid_1341 stxid_1342 stxid_1343 stxid_1344 stxid_1345 stxid_1347 stxid_1348 stxid_1349 stxid_1350 stxid_1351 stxid_1352 stxid_1354 stxid_1356 stxid_1357 stxid_1358 stxid_1359 stxid_1360 stxid_1361 stxid_1362 stxid_1364 stxid_1365 stxid_1366 stxid_1367 stxid_1368 stxid_1370 stxid_1372 stxid_1373 stxid_1374 stxid_1375 stxid_1376 stxid_1377 stxid_1378 stxid_1379 stxid_1380 stxid_1381 stxid_1383 stxid_1385 stxid_1386 stxid_1387 stxid_1391 stxid_1394 stxid_1395 stxid_1397 stxid_1398 stxid_1400 stxid_1401 stxid_1402 stxid_1404 stxid_1406 stxid_1407 stxid_1408 stxid_1409 stxid_1410 stxid_1411 stxid_1412 stxid_1413 stxid_1414 stxid_1416 stxid_1419 stxid_1421 stxid_1422 stxid_1423 stxid_1424 stxid_1425 stxid_1426 stxid_1427 stxid_1428 stxid_1429 stxid_1430 stxid_1431 stxid_1432 stxid_1433 stxid_1434 stxid_1435 stxid_1436 stxid_1437 stxid_1438 stxid_1440 stxid_1441 stxid_1442 stxid_1443 stxid_1444 stxid_1445 stxid_1446 stxid_1447 stxid_1448 stxid_1449 stxid_1451 stxid_1452 stxid_1453 stxid_1454 stxid_1455 stxid_1456 stxid_1458 stxid_1460 stxid_1461 stxid_1462 stxid_1463 stxid_1464 stxid_1466 stxid_1467 stxid_1468 stxid_1470 stxid_1472 stxid_1473 stxid_1475 stxid_1476 stxid_1477 stxid_1478 stxid_1479 stxid_1480 stxid_1481 stxid_1482 stxid_1483 stxid_1484 stxid_1485 stxid_1487 stxid_1488 stxid_1489 stxid_1490 stxid_1491 stxid_1492 stxid_1493 stxid_1494 stxid_1496 stxid_1497 stxid_1498 stxid_1499 stxid_1500 stxid_1501 stxid_1502 stxid_1503 stxid_1504 stxid_1505 stxid_1506 stxid_1507 stxid_1508 stxid_1509 stxid_1510 stxid_1511 stxid_1512 stxid_1513 stxid_1515 stxid_1516 stxid_1517 stxid_1518 stxid_1519 stxid_1520 stxid_1521 stxid_1522 stxid_1523 stxid_1524 stxid_1525 stxid_1526 stxid_1527 stxid_1528 stxid_1530 stxid_1531 stxid_1532 stxid_1533 stxid_1534 stxid_1535 stxid_1537 stxid_1538 stxid_1541 stxid_1542 stxid_1543 stxid_1544 stxid_1545 stxid_1546 stxid_1547 stxid_1548 stxid_1549 stxid_1550 stxid_1551 stxid_1554 stxid_1555 stxid_1556 stxid_1557 stxid_1558 stxid_1559 stxid_1561 stxid_1563 stxid_1565 stxid_1566 stxid_1567 stxid_1568 stxid_1569 stxid_1570 stxid_1571 stxid_1572 stxid_1573 stxid_1574 stxid_1575 stxid_1577 stxid_1578 stxid_1579 stxid_1580 stxid_1581 stxid_1583 stxid_1584 stxid_1585 stxid_1586 stxid_1587 stxid_1588 stxid_1591 stxid_1592 stxid_1593 stxid_1594 stxid_1595 stxid_1598 stxid_1599 stxid_1600 stxid_1601 stxid_1602 stxid_1603 stxid_1604 stxid_1605 stxid_1608 stxid_1609 stxid_1614 stxid_1615 stxid_1616 stxid_1617 stxid_1618 stxid_1620 stxid_1622 stxid_1623 stxid_1624 stxid_1626 stxid_1627 stxid_1628 stxid_1629 stxid_1630 stxid_1631 stxid_1632 stxid_1633 stxid_1635 stxid_1636 stxid_1637 stxid_1639 stxid_1640 stxid_1641 stxid_1642 stxid_1643 stxid_1644 stxid_1645 stxid_1647 stxid_1648 stxid_1650 stxid_1651 stxid_1652 stxid_1653 stxid_1654 stxid_1656 stxid_1658 stxid_1659 stxid_1660 stxid_1661 stxid_1663 stxid_1666 stxid_1668 stxid_1669 stxid_1671 stxid_1674 stxid_1675 stxid_1676 stxid_1680 stxid_1681 stxid_1682 stxid_1683 stxid_1685 stxid_1686 stxid_1688 stxid_1689 stxid_1690 stxid_1691 stxid_1692 stxid_1693 stxid_1694 stxid_1695 stxid_1696 stxid_1697 stxid_1698 stxid_1699 stxid_1700 stxid_1702 stxid_1703 stxid_1704 stxid_1705 stxid_1706 stxid_1707 stxid_1708 stxid_1710 stxid_1711 stxid_1712 stxid_1713 stxid_1714 stxid_1716 stxid_1718 stxid_1719 stxid_1720 stxid_1721 stxid_1722 stxid_1723 stxid_1724 stxid_1726 stxid_1727 stxid_1728 stxid_1729 stxid_1730 stxid_1731 stxid_1732 stxid_1733 stxid_1734 stxid_1735 stxid_1736 stxid_1737 stxid_1739 stxid_1740 stxid_1742 stxid_1744 stxid_1745 stxid_1746 stxid_1747 stxid_1748 stxid_1750 // drop collinear dummies - ensures consistent set of FEs across all Table 5 specifications / see robustness checks

// Produces statistics for TABLE 6, 12th row (based on TABLE 5(6)):
quietly: xtreg own tsmr tsmrxreginds reginds incd2 incd3 tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit msadd2-msadd286 msadd292          stated5-stated50 yeard9-yeard25 timexstated1- timexstated50 timexmsadd20-timexmsadd293 stxid_3-stxid_1749 if insample_reg==1         [pweight = wt05], fe robust 
predict xb_t56 if e(sample)
gen xb_t56nmrs=xb_t56+0.00603*tsmr+0.472*tsmr*reginds
sum xb_t56 xb_t56nmrs if e(sample)
gen t56_change=0 if e(sample)
replace t56_change=1 if xb_t56nmrs<0.5 & xb_t56>0.5 & e(sample)
replace t56_change=-1 if xb_t56nmrs>0.5 & xb_t56<0.5 & e(sample)
sum t56_change if e(sample)
tab t56_change if e(sample)

// Recreate all FEs by reopening 'final' dataset
drop _all
cd "D:\ChH\Research\Working Papers\DiPa80 (PSIDPanel)\"
use "dta\panel\pan7807v17final.dta"

// drop collinear dummies - ensures consistent set of FEs across all Table 5(7) specifications / see robustness checks
quietly: drop msadd3 msadd4 msadd5 msadd6 msadd7 msadd8 msadd9 msadd10 msadd11 msadd12 msadd13 msadd14 msadd15 msadd16 msadd17 msadd18 msadd19 msadd21 msadd22 msadd24 msadd25 msadd26 msadd28 msadd29 msadd30 msadd31 msadd32 msadd35 msadd36 msadd37 msadd39 msadd40 msadd42 msadd43 msadd44 msadd45 msadd46 msadd47 msadd48 msadd49 msadd50 msadd51 msadd52 msadd53 msadd54 msadd55 msadd56 msadd57 msadd58 msadd59 msadd62 msadd63 msadd64 msadd65 msadd66 msadd70 msadd71 msadd72 msadd73 msadd76 msadd78 msadd79 msadd81 msadd82 msadd83 msadd84 msadd85 msadd86 msadd88 msadd89 msadd90 msadd91 msadd92 msadd95 msadd96 msadd98 msadd99 msadd101 msadd102 msadd104 msadd107 msadd112 msadd113 msadd114 msadd115 msadd116 msadd117 msadd118 msadd119 msadd120 msadd122 msadd123 msadd124 msadd125 msadd126 msadd127 msadd128 msadd129 msadd131 msadd132 msadd133 msadd135 msadd136 msadd137 msadd138 msadd140 msadd141 msadd142 msadd143 msadd145 msadd146 msadd147 msadd148 msadd149 msadd150 msadd151 msadd152 msadd155 msadd156 msadd157 msadd158 msadd159 msadd161 msadd163 msadd165 msadd166 msadd167 msadd169 msadd170 msadd172 msadd174 msadd175 msadd176 msadd177 msadd178 msadd179 msadd180 msadd181 msadd182 msadd183 msadd184 msadd185 msadd186 msadd187 msadd188 msadd189 msadd190 msadd192 msadd193 msadd194 msadd195 msadd196 msadd197 msadd199 msadd200 msadd201 msadd202 msadd203 msadd204 msadd205 msadd206 msadd207 msadd209 msadd210 msadd211 msadd212 msadd213 msadd214 msadd215 msadd216 msadd217 msadd219 msadd220 msadd222 msadd223 msadd224 msadd225 msadd226 msadd227 msadd228 msadd229 msadd230 msadd231 msadd232 msadd233 msadd234 msadd235 msadd237 msadd238 msadd239 msadd240 msadd241 msadd242 msadd243 msadd244 msadd245 msadd246 msadd247 msadd248 msadd249 msadd250 msadd251 msadd252 msadd253 msadd254 msadd256 msadd259 msadd261 msadd262 msadd263 msadd264 msadd265 msadd266 msadd267 msadd268 msadd269 msadd271 msadd272 msadd273 msadd274 msadd275 msadd276 msadd277 msadd278 msadd279 msadd280 msadd281 msadd283 msadd285 msadd287 msadd288 msadd289 msadd290 msadd293 stated1 stated2 stated3 stated4 stated6 stated7 stated8 stated11 stated12 stated13 stated16 stated17 stated19 stated20 stated22 stated25 stated27 stated28 stated29 stated30 stated32 stated35 stated40 stated41 stated42 stated43 stated45 stated46 stated49 stated51 timexstated2 timexstated6 timexstated8 timexstated12 timexstated13 timexstated16 timexstated20 timexstated25 timexstated27 timexstated28 timexstated29 timexstated30 timexstated32 timexstated35 timexstated42 timexstated46 timexstated49 timexstated51 timexmsadd1 timexmsadd2 timexmsadd3 timexmsadd4 timexmsadd5 timexmsadd6 timexmsadd7 timexmsadd8 timexmsadd9 timexmsadd10 timexmsadd11 timexmsadd12 timexmsadd13 timexmsadd14 timexmsadd15 timexmsadd16 timexmsadd17 timexmsadd18 timexmsadd19 timexmsadd21 timexmsadd22 timexmsadd24 timexmsadd25 timexmsadd26 timexmsadd28 timexmsadd29 timexmsadd30 timexmsadd32 timexmsadd35 timexmsadd36 timexmsadd37 timexmsadd39 timexmsadd40 timexmsadd42 timexmsadd44 timexmsadd45 timexmsadd46 timexmsadd47 timexmsadd48 timexmsadd49 timexmsadd50 timexmsadd51 timexmsadd52 timexmsadd53 timexmsadd54 timexmsadd55 timexmsadd56 timexmsadd58 timexmsadd59 timexmsadd62 timexmsadd63 timexmsadd64 timexmsadd65 timexmsadd66 timexmsadd70 timexmsadd71 timexmsadd72 timexmsadd73 timexmsadd75 timexmsadd76 timexmsadd78 timexmsadd79 timexmsadd81 timexmsadd82 timexmsadd83 timexmsadd85 timexmsadd86 timexmsadd88 timexmsadd89 timexmsadd90 timexmsadd91 timexmsadd92 timexmsadd95 timexmsadd96 timexmsadd98 timexmsadd99 timexmsadd101 timexmsadd102 timexmsadd104 timexmsadd105 timexmsadd106 timexmsadd107 timexmsadd112 timexmsadd114 timexmsadd115 timexmsadd116 timexmsadd117 timexmsadd118 timexmsadd119 timexmsadd120 timexmsadd122 timexmsadd123 timexmsadd124 timexmsadd125 timexmsadd126 timexmsadd127 timexmsadd128 timexmsadd129 timexmsadd130 timexmsadd131 timexmsadd132 timexmsadd133 timexmsadd135 timexmsadd137 timexmsadd138 timexmsadd139 timexmsadd140 timexmsadd141 timexmsadd142 timexmsadd143 timexmsadd144 timexmsadd145 timexmsadd146 timexmsadd147 timexmsadd148 timexmsadd149 timexmsadd150 timexmsadd151 timexmsadd152 timexmsadd153 timexmsadd155 timexmsadd157 timexmsadd158 timexmsadd159 timexmsadd161 timexmsadd163 timexmsadd165 timexmsadd166 timexmsadd167 timexmsadd169 timexmsadd170 timexmsadd172 timexmsadd174 timexmsadd175 timexmsadd176 timexmsadd177 timexmsadd178 timexmsadd179 timexmsadd180 timexmsadd181 timexmsadd183 timexmsadd184 timexmsadd185 timexmsadd186 timexmsadd187 timexmsadd188 timexmsadd189 timexmsadd190 timexmsadd192 timexmsadd193 timexmsadd194 timexmsadd195 timexmsadd196 timexmsadd197 timexmsadd199 timexmsadd200 timexmsadd201 timexmsadd202 timexmsadd203 timexmsadd204 timexmsadd205 timexmsadd206 timexmsadd207 timexmsadd208 timexmsadd209 timexmsadd210 timexmsadd211 timexmsadd212 timexmsadd213 timexmsadd215 timexmsadd216 timexmsadd217 timexmsadd219 timexmsadd220 timexmsadd222 timexmsadd223 timexmsadd224 timexmsadd225 timexmsadd226 timexmsadd227 timexmsadd228 timexmsadd229 timexmsadd230 timexmsadd231 timexmsadd232 timexmsadd234 timexmsadd235 timexmsadd238 timexmsadd239 timexmsadd240 timexmsadd241 timexmsadd242 timexmsadd243 timexmsadd244 timexmsadd245 timexmsadd246 timexmsadd247 timexmsadd248 timexmsadd249 timexmsadd250 timexmsadd251 timexmsadd252 timexmsadd253 timexmsadd254 timexmsadd255 timexmsadd256 timexmsadd259 timexmsadd261 timexmsadd262 timexmsadd263 timexmsadd264 timexmsadd265 timexmsadd266 timexmsadd267 timexmsadd269 timexmsadd271 timexmsadd272 timexmsadd274 timexmsadd275 timexmsadd276 timexmsadd277 timexmsadd278 timexmsadd279 timexmsadd280 timexmsadd281 timexmsadd282 timexmsadd283 timexmsadd284 timexmsadd285 timexmsadd286 timexmsadd288 timexmsadd289 timexmsadd290 timexmsadd291 timexmsadd292 stxid_2 stxid_4 stxid_5 stxid_6 stxid_9 stxid_10 stxid_11 stxid_12 stxid_14 stxid_15 stxid_16 stxid_17 stxid_18 stxid_19 stxid_20 stxid_21 stxid_27 stxid_29 stxid_32 stxid_33 stxid_34 stxid_39 stxid_40 stxid_41 stxid_42 stxid_43 stxid_45 stxid_46 stxid_52 stxid_54 stxid_56 stxid_58 stxid_60 stxid_61 stxid_64 stxid_65 stxid_66 stxid_67 stxid_69 stxid_70 stxid_71 stxid_72 stxid_73 stxid_74 stxid_75 stxid_76 stxid_77 stxid_78 stxid_79 stxid_81 stxid_82 stxid_83 stxid_84 stxid_88 stxid_89 stxid_90 stxid_92 stxid_93 stxid_94 stxid_96 stxid_97 stxid_98 stxid_99 stxid_101 stxid_103 stxid_105 stxid_107 stxid_109 stxid_110 stxid_111 stxid_112 stxid_114 stxid_115 stxid_116 stxid_118 stxid_119 stxid_122 stxid_123 stxid_124 stxid_126 stxid_127 stxid_128 stxid_131 stxid_133 stxid_134 stxid_136 stxid_139 stxid_142 stxid_144 stxid_145 stxid_147 stxid_148 stxid_150 stxid_151 stxid_152 stxid_153 stxid_156 stxid_157 stxid_159 stxid_162 stxid_163 stxid_164 stxid_165 stxid_168 stxid_169 stxid_170 stxid_172 stxid_173 stxid_174 stxid_176 stxid_177 stxid_179 stxid_180 stxid_182 stxid_183 stxid_186 stxid_191 stxid_192 stxid_195 stxid_197 stxid_199 stxid_202 stxid_205 stxid_208 stxid_209 stxid_210 stxid_211 stxid_212 stxid_213 stxid_214 stxid_218 stxid_219 stxid_220 stxid_221 stxid_222 stxid_223 stxid_224 stxid_225 stxid_226 stxid_227 stxid_228 stxid_229 stxid_232 stxid_233 stxid_235 stxid_236 stxid_238 stxid_239 stxid_240 stxid_241 stxid_242 stxid_243 stxid_244 stxid_245 stxid_246 stxid_249 stxid_250 stxid_252 stxid_253 stxid_254 stxid_255 stxid_256 stxid_257 stxid_259 stxid_260 stxid_261 stxid_263 stxid_264 stxid_267 stxid_268 stxid_269 stxid_270 stxid_271 stxid_273 stxid_274 stxid_275 stxid_276 stxid_277 stxid_279 stxid_280 stxid_281 stxid_282 stxid_283 stxid_284 stxid_285 stxid_286 stxid_287 stxid_288 stxid_289 stxid_290 stxid_291 stxid_293 stxid_294 stxid_296 stxid_297 stxid_298 stxid_302 stxid_304 stxid_305 stxid_306 stxid_307 stxid_308 stxid_309 stxid_310 stxid_311 stxid_313 stxid_314 stxid_315 stxid_316 stxid_319 stxid_321 stxid_322 stxid_323 stxid_326 stxid_327 stxid_329 stxid_330 stxid_331 stxid_332 stxid_333 stxid_334 stxid_336 stxid_340 stxid_342 stxid_347 stxid_352 stxid_356 stxid_357 stxid_359 stxid_360 stxid_361 stxid_363 stxid_364 stxid_365 stxid_366 stxid_367 stxid_368 stxid_369 stxid_370 stxid_371 stxid_374 stxid_375 stxid_377 stxid_378 stxid_379 stxid_380 stxid_382 stxid_383 stxid_384 stxid_385 stxid_386 stxid_387 stxid_388 stxid_390 stxid_391 stxid_392 stxid_393 stxid_394 stxid_395 stxid_396 stxid_397 stxid_398 stxid_399 stxid_403 stxid_404 stxid_406 stxid_408 stxid_409 stxid_410 stxid_412 stxid_413 stxid_416 stxid_417 stxid_418 stxid_420 stxid_421 stxid_424 stxid_425 stxid_427 stxid_428 stxid_429 stxid_430 stxid_431 stxid_432 stxid_433 stxid_436 stxid_437 stxid_438 stxid_440 stxid_448 stxid_450 stxid_451 stxid_459 stxid_461 stxid_464 stxid_468 stxid_469 stxid_471 stxid_473 stxid_474 stxid_475 stxid_478 stxid_479 stxid_483 stxid_484 stxid_485 stxid_486 stxid_487 stxid_488 stxid_489 stxid_492 stxid_493 stxid_494 stxid_495 stxid_496 stxid_497 stxid_498 stxid_499 stxid_501 stxid_502 stxid_503 stxid_504 stxid_508 stxid_509 stxid_511 stxid_512 stxid_515 stxid_516 stxid_518 stxid_521 stxid_522 stxid_524 stxid_528 stxid_530 stxid_532 stxid_533 stxid_535 stxid_537 stxid_538 stxid_539 stxid_542 stxid_543 stxid_546 stxid_547 stxid_548 stxid_549 stxid_550 stxid_551 stxid_553 stxid_556 stxid_557 stxid_558 stxid_559 stxid_560 stxid_561 stxid_565 stxid_566 stxid_567 stxid_569 stxid_572 stxid_574 stxid_575 stxid_576 stxid_577 stxid_578 stxid_579 stxid_581 stxid_582 stxid_585 stxid_586 stxid_588 stxid_589 stxid_591 stxid_592 stxid_593 stxid_594 stxid_597 stxid_598 stxid_601 stxid_603 stxid_605 stxid_607 stxid_608 stxid_609 stxid_612 stxid_613 stxid_614 stxid_615 stxid_616 stxid_617 stxid_618 stxid_619 stxid_622 stxid_623 stxid_624 stxid_627 stxid_628 stxid_631 stxid_636 stxid_637 stxid_638 stxid_641 stxid_642 stxid_643 stxid_644 stxid_645 stxid_646 stxid_647 stxid_649 stxid_651 stxid_652 stxid_657 stxid_659 stxid_660 stxid_661 stxid_662 stxid_663 stxid_667 stxid_669 stxid_671 stxid_672 stxid_673 stxid_674 stxid_677 stxid_678 stxid_679 stxid_681 stxid_682 stxid_683 stxid_685 stxid_686 stxid_687 stxid_689 stxid_690 stxid_691 stxid_693 stxid_695 stxid_698 stxid_700 stxid_701 stxid_702 stxid_703 stxid_706 stxid_707 stxid_709 stxid_710 stxid_711 stxid_712 stxid_713 stxid_715 stxid_718 stxid_719 stxid_720 stxid_722 stxid_723 stxid_728 stxid_729 stxid_730 stxid_731 stxid_732 stxid_733 stxid_734 stxid_735 stxid_737 stxid_738 stxid_741 stxid_742 stxid_743 stxid_746 stxid_751 stxid_754 stxid_759 stxid_761 stxid_763 stxid_764 stxid_765 stxid_767 stxid_769 stxid_770 stxid_774 stxid_775 stxid_776 stxid_778 stxid_779 stxid_782 stxid_783 stxid_785 stxid_786 stxid_788 stxid_789 stxid_790 stxid_791 stxid_793 stxid_794 stxid_795 stxid_796 stxid_797 stxid_800 stxid_801 stxid_802 stxid_803 stxid_804 stxid_806 stxid_807 stxid_808 stxid_810 stxid_814 stxid_815 stxid_816 stxid_817 stxid_818 stxid_820 stxid_821 stxid_823 stxid_824 stxid_825 stxid_826 stxid_828 stxid_829 stxid_830 stxid_832 stxid_833 stxid_834 stxid_835 stxid_836 stxid_837 stxid_838 stxid_841 stxid_844 stxid_845 stxid_846 stxid_848 stxid_849 stxid_850 stxid_852 stxid_853 stxid_854 stxid_855 stxid_856 stxid_857 stxid_858 stxid_860 stxid_861 stxid_862 stxid_863 stxid_864 stxid_865 stxid_866 stxid_867 stxid_868 stxid_869 stxid_871 stxid_872 stxid_873 stxid_874 stxid_875 stxid_876 stxid_877 stxid_878 stxid_879 stxid_880 stxid_881 stxid_882 stxid_883 stxid_884 stxid_886 stxid_887 stxid_889 stxid_890 stxid_891 stxid_892 stxid_894 stxid_896 stxid_897 stxid_898 stxid_900 stxid_902 stxid_903 stxid_904 stxid_906 stxid_907 stxid_908 stxid_909 stxid_910 stxid_911 stxid_912 stxid_913 stxid_914 stxid_915 stxid_917 stxid_918 stxid_919 stxid_920 stxid_921 stxid_922 stxid_923 stxid_925 stxid_926 stxid_927 stxid_928 stxid_929 stxid_930 stxid_932 stxid_933 stxid_934 stxid_935 stxid_936 stxid_937 stxid_938 stxid_939 stxid_941 stxid_943 stxid_945 stxid_946 stxid_947 stxid_948 stxid_949 stxid_950 stxid_951 stxid_952 stxid_953 stxid_954 stxid_956 stxid_957 stxid_958 stxid_959 stxid_960 stxid_966 stxid_967 stxid_968 stxid_969 stxid_970 stxid_972 stxid_973 stxid_974 stxid_975 stxid_977 stxid_978 stxid_979 stxid_981 stxid_982 stxid_983 stxid_984 stxid_985 stxid_987 stxid_988 stxid_989 stxid_990 stxid_992 stxid_994 stxid_995 stxid_996 stxid_997 stxid_998 stxid_999 stxid_1001 stxid_1002 stxid_1003 stxid_1004 stxid_1005 stxid_1008 stxid_1010 stxid_1011 stxid_1014 stxid_1015 stxid_1016 stxid_1017 stxid_1018 stxid_1020 stxid_1022 stxid_1023 stxid_1024 stxid_1026 stxid_1027 stxid_1028 stxid_1030 stxid_1032 stxid_1033 stxid_1034 stxid_1037 stxid_1040 stxid_1041 stxid_1042 stxid_1043 stxid_1044 stxid_1046 stxid_1047 stxid_1049 stxid_1050 stxid_1051 stxid_1052 stxid_1053 stxid_1054 stxid_1056 stxid_1060 stxid_1061 stxid_1065 stxid_1066 stxid_1067 stxid_1069 stxid_1070 stxid_1071 stxid_1072 stxid_1073 stxid_1075 stxid_1076 stxid_1078 stxid_1080 stxid_1081 stxid_1084 stxid_1085 stxid_1086 stxid_1087 stxid_1088 stxid_1089 stxid_1090 stxid_1091 stxid_1092 stxid_1093 stxid_1094 stxid_1095 stxid_1097 stxid_1098 stxid_1099 stxid_1102 stxid_1103 stxid_1105 stxid_1106 stxid_1107 stxid_1108 stxid_1110 stxid_1111 stxid_1112 stxid_1116 stxid_1117 stxid_1118 stxid_1119 stxid_1120 stxid_1121 stxid_1122 stxid_1124 stxid_1126 stxid_1128 stxid_1129 stxid_1130 stxid_1131 stxid_1133 stxid_1135 stxid_1136 stxid_1137 stxid_1138 stxid_1140 stxid_1141 stxid_1142 stxid_1143 stxid_1144 stxid_1145 stxid_1147 stxid_1149 stxid_1150 stxid_1151 stxid_1152 stxid_1153 stxid_1154 stxid_1155 stxid_1156 stxid_1157 stxid_1159 stxid_1160 stxid_1162 stxid_1163 stxid_1164 stxid_1165 stxid_1166 stxid_1167 stxid_1168 stxid_1169 stxid_1170 stxid_1171 stxid_1172 stxid_1173 stxid_1174 stxid_1175 stxid_1176 stxid_1177 stxid_1178 stxid_1179 stxid_1180 stxid_1181 stxid_1182 stxid_1183 stxid_1184 stxid_1186 stxid_1187 stxid_1188 stxid_1189 stxid_1190 stxid_1191 stxid_1192 stxid_1193 stxid_1195 stxid_1196 stxid_1197 stxid_1198 stxid_1199 stxid_1200 stxid_1201 stxid_1202 stxid_1203 stxid_1205 stxid_1206 stxid_1207 stxid_1208 stxid_1210 stxid_1211 stxid_1212 stxid_1213 stxid_1214 stxid_1217 stxid_1218 stxid_1219 stxid_1220 stxid_1224 stxid_1225 stxid_1228 stxid_1229 stxid_1230 stxid_1231 stxid_1232 stxid_1233 stxid_1234 stxid_1235 stxid_1236 stxid_1237 stxid_1239 stxid_1241 stxid_1242 stxid_1245 stxid_1246 stxid_1247 stxid_1248 stxid_1249 stxid_1250 stxid_1252 stxid_1253 stxid_1254 stxid_1255 stxid_1256 stxid_1257 stxid_1258 stxid_1259 stxid_1260 stxid_1261 stxid_1262 stxid_1263 stxid_1267 stxid_1268 stxid_1270 stxid_1272 stxid_1273 stxid_1275 stxid_1276 stxid_1277 stxid_1278 stxid_1282 stxid_1283 stxid_1284 stxid_1285 stxid_1286 stxid_1288 stxid_1289 stxid_1290 stxid_1291 stxid_1292 stxid_1293 stxid_1294 stxid_1296 stxid_1297 stxid_1298 stxid_1299 stxid_1300 stxid_1302 stxid_1304 stxid_1305 stxid_1307 stxid_1308 stxid_1309 stxid_1310 stxid_1312 stxid_1313 stxid_1315 stxid_1316 stxid_1317 stxid_1319 stxid_1320 stxid_1321 stxid_1322 stxid_1323 stxid_1325 stxid_1327 stxid_1329 stxid_1330 stxid_1331 stxid_1332 stxid_1333 stxid_1334 stxid_1335 stxid_1337 stxid_1338 stxid_1339 stxid_1340 stxid_1341 stxid_1342 stxid_1343 stxid_1344 stxid_1345 stxid_1346 stxid_1347 stxid_1348 stxid_1350 stxid_1351 stxid_1352 stxid_1355 stxid_1357 stxid_1358 stxid_1359 stxid_1361 stxid_1362 stxid_1364 stxid_1365 stxid_1366 stxid_1367 stxid_1368 stxid_1370 stxid_1372 stxid_1373 stxid_1374 stxid_1375 stxid_1376 stxid_1377 stxid_1378 stxid_1379 stxid_1380 stxid_1381 stxid_1382 stxid_1385 stxid_1386 stxid_1387 stxid_1389 stxid_1391 stxid_1393 stxid_1394 stxid_1395 stxid_1397 stxid_1398 stxid_1400 stxid_1401 stxid_1402 stxid_1404 stxid_1407 stxid_1408 stxid_1409 stxid_1410 stxid_1411 stxid_1412 stxid_1413 stxid_1414 stxid_1416 stxid_1421 stxid_1422 stxid_1423 stxid_1424 stxid_1425 stxid_1426 stxid_1428 stxid_1429 stxid_1430 stxid_1431 stxid_1432 stxid_1433 stxid_1434 stxid_1435 stxid_1436 stxid_1437 stxid_1438 stxid_1439 stxid_1440 stxid_1441 stxid_1442 stxid_1443 stxid_1444 stxid_1445 stxid_1447 stxid_1448 stxid_1449 stxid_1451 stxid_1452 stxid_1453 stxid_1454 stxid_1455 stxid_1456 stxid_1458 stxid_1460 stxid_1461 stxid_1462 stxid_1463 stxid_1464 stxid_1466 stxid_1468 stxid_1469 stxid_1472 stxid_1473 stxid_1475 stxid_1476 stxid_1477 stxid_1479 stxid_1480 stxid_1481 stxid_1482 stxid_1484 stxid_1487 stxid_1488 stxid_1490 stxid_1491 stxid_1493 stxid_1494 stxid_1496 stxid_1497 stxid_1499 stxid_1500 stxid_1501 stxid_1502 stxid_1503 stxid_1504 stxid_1505 stxid_1506 stxid_1507 stxid_1508 stxid_1510 stxid_1511 stxid_1512 stxid_1513 stxid_1516 stxid_1517 stxid_1518 stxid_1519 stxid_1520 stxid_1521 stxid_1522 stxid_1523 stxid_1524 stxid_1525 stxid_1526 stxid_1527 stxid_1528 stxid_1530 stxid_1531 stxid_1532 stxid_1533 stxid_1534 stxid_1535 stxid_1536 stxid_1537 stxid_1538 stxid_1540 stxid_1541 stxid_1542 stxid_1543 stxid_1544 stxid_1545 stxid_1546 stxid_1547 stxid_1548 stxid_1549 stxid_1550 stxid_1551 stxid_1552 stxid_1555 stxid_1556 stxid_1557 stxid_1558 stxid_1559 stxid_1561 stxid_1562 stxid_1563 stxid_1565 stxid_1567 stxid_1569 stxid_1570 stxid_1571 stxid_1572 stxid_1573 stxid_1574 stxid_1575 stxid_1577 stxid_1578 stxid_1579 stxid_1580 stxid_1581 stxid_1583 stxid_1584 stxid_1585 stxid_1586 stxid_1587 stxid_1588 stxid_1592 stxid_1594 stxid_1595 stxid_1598 stxid_1599 stxid_1600 stxid_1601 stxid_1602 stxid_1603 stxid_1604 stxid_1605 stxid_1607 stxid_1608 stxid_1609 stxid_1613 stxid_1614 stxid_1615 stxid_1616 stxid_1617 stxid_1618 stxid_1620 stxid_1622 stxid_1623 stxid_1624 stxid_1626 stxid_1627 stxid_1628 stxid_1629 stxid_1630 stxid_1631 stxid_1632 stxid_1633 stxid_1635 stxid_1636 stxid_1637 stxid_1639 stxid_1640 stxid_1641 stxid_1642 stxid_1644 stxid_1645 stxid_1646 stxid_1647 stxid_1649 stxid_1650 stxid_1651 stxid_1652 stxid_1653 stxid_1654 stxid_1656 stxid_1657 stxid_1658 stxid_1659 stxid_1661 stxid_1662 stxid_1663 stxid_1664 stxid_1665 stxid_1666 stxid_1669 stxid_1674 stxid_1675 stxid_1676 stxid_1678 stxid_1679 stxid_1680 stxid_1681 stxid_1682 stxid_1683 stxid_1685 stxid_1686 stxid_1688 stxid_1689 stxid_1690 stxid_1691 stxid_1692 stxid_1693 stxid_1694 stxid_1695 stxid_1696 stxid_1697 stxid_1698 stxid_1699 stxid_1700 stxid_1701 stxid_1702 stxid_1703 stxid_1704 stxid_1705 stxid_1706 stxid_1707 stxid_1708 stxid_1710 stxid_1711 stxid_1712 stxid_1713 stxid_1714 stxid_1716 stxid_1718 stxid_1719 stxid_1721 stxid_1722 stxid_1723 stxid_1724 stxid_1726 stxid_1727 stxid_1728 stxid_1729 stxid_1730 stxid_1731 stxid_1732 stxid_1733 stxid_1734 stxid_1735 stxid_1736 stxid_1737 stxid_1740 stxid_1741 stxid_1742 stxid_1744 stxid_1745 stxid_1746 stxid_1747 stxid_1750

// Produces statistics for TABLE 6, 13th row (based on TABLE 5(7)):
quietly: xtreg own incd1xtsmr-incd3xtsmr incd1xtsmrxreginds-incd3xtsmrxreginds incd1xreginds-incd3xreginds incd2-incd3  tnw ageh agehsq mar child_1 child_2 child_3p unemp unempw p1unit p5punit  msadd2-msadd286 msadd292          stated5-stated50 yeard9-yeard25 timexstated1- timexstated50 timexmsadd20-timexmsadd293 stxid_3-stxid_1749 if insample_reg==1         [pweight = wt05], fe robust 
predict xb_t57 if e(sample)
gen xb_t57nmrs=xb_t57+0.282*incd1xtsmr-0.136*incd1xtsmrxreginds+0.244*incd2xtsmr+0.527*incd2xtsmrxreginds-0.192*incd3xtsmr+0.601*incd3xtsmrxreginds
sum xb_t57 xb_t57nmrs if e(sample)
gen t57_change=0 if e(sample)
replace t57_change=1 if xb_t57nmrs<0.5 & xb_t57>0.5 & e(sample)
replace t57_change=-1 if xb_t57nmrs>0.5 & xb_t57<0.5 & e(sample)
sum t57_change if e(sample)
tab t57_change if e(sample)


*********************
* Table 6 - Panel B *
*********************

// Statistics reported in Table 6 - Panel B are derived from the regression results
// Explore effect of change of MID from 0 to 0.26 for
// constrained MSA (regulatory index = +1.586) vs.
// little constrained MSA (regulatory index = -1.40)
// Example:
// Consider first statistic of -24.3% for moderate income household in constrained MSA
// Coefficient on Moderate Income x MSR : -0.0720
// Coefficient on Moderate Income x MSR x Regulatory Index: -0.544*
// Introduction of MSR of 0.26 has following effects:
// -0.072*(+0.26) + (-0.544)*(+0.26)*1.586 = -0.019 -0.224 = -0.243 (or -24.3%)
// Other statistics in Panel B are calculated accordingly 

log close
