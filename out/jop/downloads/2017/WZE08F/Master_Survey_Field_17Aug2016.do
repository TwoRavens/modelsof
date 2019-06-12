
*********************************************************************************
/*** 
Title: Replication file to accompany "External Validity in Parallel Global Field
	and Survey Experiments on Anonymous Incorporation" forthcoming in JoP.
Authors: Michael G. Findley (UT Austin), Brock Laney (U. of Chicago), Daniel L. 
	Nielson (BYU), and J.C. Sharman (Cambridge University)
Date: 17 August 2016 
Purpose: This file replicates all analyses reported in our JOP article
Contact: For any Qs/errors, contact Mike Findley at mikefindley@utexas.edu 
Version: Stata 14.1
***/
**********************************************************************************


***************************************************************************
/***
Figures 1 and 2 display the different response rates across field and survey 
experiments in the internatonal and US Samples  (Venn Diagrams)
***/
***************************************************************************

***INTERNATIONAL DATA***
capture log close
set more off
clear

*set directory here
*cd "SET DIRECTORY HERE"

use "survey_intl_data.dta"

gen surv_resp=0
replace surv_resp=1 if survey_nonresponse==0

gen exp_resp=0
replace exp_resp=1 if exp_nonresponse==0 

gen fieldonlyvenn = 0
replace fieldonlyvenn = 1 if exp_resp == 1 & surv_resp == 0

gen surveyonlyvenn = 0
replace surveyonlyvenn = 1 if surv_resp == 1 & exp_resp == 0

gen fieldsurvbothvenn = 0
replace fieldsurvbothvenn = 1 if surv_resp == 1 & exp_resp == 1

gen anythingfieldvenn=0
replace anythingfieldvenn=1 if exp_resp==1

gen anythingsurveyvenn=0
replace anythingsurveyvenn=1 if surv_resp==1

/*BEGIN DRAW INT'L VENN DIAGRAM CODE
*Uncomment this code to produce the Int'l Venn Diagram

pvenn anythingfieldvenn anythingsurveyvenn, drawtotal(1) lp("dash_dot" "dot" "solid") plabel(PopA PopB PopC) 

gr_edit plotregion1.textbox1.text = {}
gr_edit plotregion1.textbox1.text.Arrpush Field
gr_edit plotregion1.textbox2.text = {}
gr_edit plotregion1.textbox2.text.Arrpush Survey
gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush Field
gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Survey
gr_edit plotregion1.plot7.style.editstyle line(pattern(solid)) editcopy
gr_edit plotregion1.plot8.style.editstyle line(pattern(solid)) editcopy
gr_edit plotregion1.plot6.style.editstyle line(pattern(solid)) editcopy
gr_edit legend.plotregion1.key[3].view.style.editstyle line(pattern(solid)) editcopy


*to get totals for putting on plot....
tab anythingfieldvenn anythingsurveyvenn
tab fieldonlyvenn
tab surveyonlyvenn 
tab fieldsurvbothvenn

*total: 2243, field: 2085, field/survey: 188, survey: 79; 
*but note that the values 2243 and 2085 are not right (188 and 79 are)
*conditional (treatment==survey_treatment) to not count duplicates for the 
* 	survey; the same subject may have multiple experimental observations
*   but only the survey with the same treatment should count
* run additional code to get the correct numbers

keep if treatment==survey_treatment
gen overallresponse=.

*overallresponse=1 means they responded to both the survey and experiment
replace overallresponse=1 if survey_nonresponse==0 & exp_nonresponse==0 

*overallresponse=2 means they responded to the survey but not the field experiment
replace overallresponse=2 if survey_nonresponse==0 & exp_nonresponse==1 

*overallreponse=3 means they did not respond to the survey, but did respond to the experiment
replace overallresponse=3 if survey_nonresponse==1 & exp_nonresponse==0 

*overallresponse=4 means they did not respond to the survey or the experiment
replace overallresponse=4 if survey_nonresponse==1 & exp_nonresponse==1 

label define overallresponse 1 "Both" 2 "Only Survey " 3 "Only Experiment" 4 "Neither" 
label values overallresponse overallresponse

tab  treatment overallresponse, row 
*this gives the final values needed to fill out the Venn Diagram: 849/1033

*END DRAW INT'L VENN DIAGRAM CODE
*/



***US DATA***
clear
use "survey_us_data.dta"

drop if exp_nonresponse == 0 & exp_noncompliant == 0 & exp_partcompliant == 0 & exp_compliant == 0 & exp_refusal == 0 

gen surv_resp=0
replace surv_resp=1 if survey_nonresponse==0

gen exp_resp=0
replace exp_resp=1 if exp_nonresponse==0 

gen fieldonlyvenn = 0
replace fieldonlyvenn = 1 if exp_resp == 1 & surv_resp == 0

gen surveyonlyvenn = 0
replace surveyonlyvenn = 1 if surv_resp == 1 & exp_resp == 0

gen fieldsurvbothvenn = 0
replace fieldsurvbothvenn = 1 if surv_resp == 1 & exp_resp == 1

gen anythingfieldvenn=0
replace anythingfieldvenn=1 if exp_resp==1

gen anythingsurveyvenn=0
replace anythingsurveyvenn=1 if surv_resp==1

/*BEGIN DRAW U.S. VENN DIAGRAM CODE
*Uncomment this code to produce the U.S. Venn Diagram

pvenn anythingfieldvenn anythingsurveyvenn, drawtotal(1) lp("dash_dot" "dot" "solid")

gr_edit plotregion1.textbox1.text = {}
gr_edit plotregion1.textbox1.text.Arrpush Field
gr_edit plotregion1.textbox2.text = {}
gr_edit plotregion1.textbox2.text.Arrpush Survey
gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush Field
gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Survey
gr_edit plotregion1.plot7.style.editstyle line(pattern(solid)) editcopy
gr_edit plotregion1.plot8.style.editstyle line(pattern(solid)) editcopy
gr_edit plotregion1.plot6.style.editstyle line(pattern(solid)) editcopy
gr_edit legend.plotregion1.key[3].view.style.editstyle line(pattern(solid)) editcopy

*to get totals for putting on plot....
tab anythingfieldvenn anythingsurveyvenn
*total: 2363, field: 644, field/survey: 45, survey: 30

*but note that the values 2363 and 644 are not right (45 and 30 are)
*conditional (treatment==survey_treatment) to not count duplicates for the 
* 	survey; the same subject may have multiple experimental observations
*   but only the survey with the same treatment should count
* run additional code to get the correct numbers

*for U.S. now

keep if treatment==survey_treatment
gen overallresponse=.

*overallresponse=1 means they responded to both the survey and experiment
replace overallresponse=1 if survey_nonresponse==0 & exp_nonresponse==0 

*overallresponse=2 means they responded to the survey but not the field experiment
replace overallresponse=2 if survey_nonresponse==0 & exp_nonresponse==1 

*overallreponse=3 means they did not respond to the survey, but did respond to the experiment
replace overallresponse=3 if survey_nonresponse==1 & exp_nonresponse==0 

*overallresponse=4 means they did not respond to the survey or the experiment
replace overallresponse=4 if survey_nonresponse==1 & exp_nonresponse==1 

label define overallresponse 1 "Both" 2 "Only Survey " 3 "Only Experiment" 4 "Neither" 
label values overallresponse overallresponse

tab  treatment overallresponse, row 
*this gives the final values needed to fill out the Venn Diagram: 331/1356

*END DRAW U.S. VENN DIAGRAM CODE
*/



*********************************************************************************
*** Table 1: Logistic Regression Results for Selection into Survey Response (intl)
**********************************************************************************
***INTERNATIONAL DATA***
clear
use "survey_intl_data.dta"

* Logit to check if certain types of field experiment subjects were more likely to complete the survey
logit survey_reply reply noncompliant1 compliant1 refusal1 companytype TaxHaven OECDDum if treatment==survey_treatment

* Rotate the base categories to see if results for the four response-type dummies shift as expected
logit survey_reply reply partcompliant1 compliant1 refusal1 companytype TaxHaven OECDDum if treatment==survey_treatment
logit survey_reply reply noncompliant1 partcompliant1 refusal1 companytype TaxHaven OECDDum if treatment==survey_treatment
logit survey_reply reply noncompliant1 partcompliant1 compliant1 companytype TaxHaven OECDDum if treatment==survey_treatment

* Compare to response in the experiment
logit reply companytype TaxHaven OECDDum


***US DATA***
clear
use "survey_us_data.dta"
drop if exp_nonresponse == 0 & exp_noncompliant == 0 & exp_partcompliant == 0 & exp_compliant == 0 & exp_refusal == 0 

* Logit to check if certain types of field experiment subjects were more likely to complete the survey
logit survey_reply reply noncompliant1 compliant1 refusal1 companytype if treatment==survey_treatment

* Rotate the base categories to see if results for the four response-type dummies shift as expected
logit survey_reply reply partcompliant1 compliant1 refusal1 companytype if treatment==survey_treatment
logit survey_reply reply noncompliant1 partcompliant1 refusal1 companytype if treatment==survey_treatment
logit survey_reply reply noncompliant1 partcompliant1 compliant1 companytype if treatment==survey_treatment

* Compare with the Experimental reply
logit reply companytype


*************************************************************************************
**** Table 2: Cross-Tabulation of Subjects
*************************************************************************************

***INTERNATIONAL DATA***
clear
use "survey_intl_data.dta"

*first simply have a cross-tabulation of how much they align; if experiment and 
* 	survey were identical then all values would be on principal diagonal
tab response survey_response if treatment == survey_treatment, ro


***US DATA***
clear
use "survey_us_data.dta"
drop if exp_nonresponse == 0 & exp_noncompliant == 0 & exp_partcompliant == 0 & exp_compliant == 0 & exp_refusal == 0 

*first simply have a cross-tabulation of how much they align; if experiment and 
* 	survey were identical then all values would be on principal diagonal
drop if response == 901
tab response survey_response if treatment == survey_treatment, ro


*******************************************************************************
*** Table 3: Cross Tabulations by Proportion of Respondents 
*** across Outcomes in the Field and Survey Experiments
*******************************************************************************
***INTERNATIONAL DATA***
clear
use "survey_intl_data.dta"

*now tabulate but remove the nonresponders to consider percentages differently
tab response survey_response if treatment == survey_treatment & survey_response ~=500, ro

***US DATA***
clear
use "survey_us_data.dta"
drop if exp_nonresponse == 0 & exp_noncompliant == 0 & exp_partcompliant == 0 & exp_compliant == 0 & exp_refusal == 0 

*now tabulate but remove the nonresponders to consider percentages differently
tab response survey_response if treatment == survey_treatment & survey_response ~=500, ro


**************************************************************************************
*** Table 4 Comparative Treatment Effects for Field and Survey Experiments (Intl CSPs)
**************************************************************************************

***INTERNATIONAL DATA***
clear
use "survey_intl_data.dta"

*consider treatment effects within the experiment
*terrorism treatment
ttest exp_nonresponse, by(terrorcompare)
tab   exp_nonresponse terrorcompare

ttest exp_noncompliant, by(terrorcompare)
tab   exp_noncompliant terrorcompare

ttest exp_partcompliant, by(terrorcompare)
tab   exp_partcompliant terrorcompare

ttest exp_compliant, by(terrorcompare)
tab  exp_compliant terrorcompare

ttest exp_refusal, by(terrorcompare)
tab   exp_refusal terrorcompare

*corruption treatment
ttest exp_nonresponse, by(corruptioncompare)
tab exp_nonresponse corruptioncompare

ttest exp_noncompliant, by(corruptioncompare)
tab exp_noncompliant corruptioncompare

ttest exp_partcompliant, by(corruptioncompare)
tab exp_partcompliant corruptioncompare

ttest exp_compliant, by(corruptioncompare)
tab exp_compliant corruptioncompare

ttest exp_refusal, by(corruptioncompare)
tab exp_refusal corruptioncompare

*premium treatment
ttest exp_nonresponse, by(premiumcompare)
tab exp_nonresponse premiumcompare

ttest exp_noncompliant, by(premiumcompare)
tab exp_noncompliant premiumcompare

ttest exp_partcompliant, by(premiumcompare)
tab exp_partcompliant premiumcompare

ttest exp_compliant, by(premiumcompare)
tab exp_compliant premiumcompare

ttest exp_refusal, by(premiumcompare)
tab exp_refusal premiumcompare

*fatf treatment
ttest exp_nonresponse, by(fatfcompare)
tab exp_nonresponse fatfcompare

ttest exp_noncompliant, by(fatfcompare)
tab exp_noncompliant fatfcompare

ttest exp_partcompliant, by(fatfcompare)
tab exp_partcompliant fatfcompare

ttest exp_compliant, by(fatfcompare)
tab exp_compliant fatfcompare

ttest exp_refusal, by(fatfcompare)
tab exp_refusal fatfcompare

*a combination of premium, corruption, terror
ttest exp_nonresponse, by(premcorrterr)
tab exp_nonresponse premcorrterr

ttest exp_noncompliant, by(premcorrterr)
tab exp_noncompliant premcorrterr

ttest exp_partcompliant, by(premcorrterr)
tab exp_partcompliant premcorrterr

ttest exp_compliant, by(premcorrterr)
tab exp_compliant premcorrterr

ttest exp_refusal, by(premcorrterr)
tab exp_refusal premcorrterr


*now consider treatment effects within the survey
keep if treatment==survey_treatment

*terrorism treatment
ttest survey_nonresponse, by(terrorcompare)
tab survey_nonresponse terrorcompare

ttest survey_noncompliant, by(terrorcompare)
tab survey_noncompliant terrorcompare

ttest survey_partcompliant, by(terrorcompare)
tab survey_partcompliant terrorcompare

ttest survey_compliant, by(terrorcompare)
tab survey_compliant terrorcompare

ttest survey_refusal, by(terrorcompare)
tab survey_refusal terrorcompare

*corruption treatment
ttest survey_nonresponse, by(corruptioncompare) 
tab survey_nonresponse corruptioncompare

ttest survey_noncompliant, by(corruptioncompare)
tab survey_noncompliant corruptioncompare

ttest survey_partcompliant, by(corruptioncompare)
tab survey_partcompliant corruptioncompare

ttest survey_compliant, by(corruptioncompare)
tab survey_compliant corruptioncompare

ttest survey_refusal, by(corruptioncompare)
tab survey_refusal corruptioncompare

*premium treatment
ttest survey_nonresponse, by(premiumcompare)
tab survey_nonresponse premiumcompare
 
ttest survey_noncompliant, by(premiumcompare)
tab survey_noncompliant premiumcompare

ttest survey_partcompliant, by(premiumcompare)
tab survey_partcompliant premiumcompare

ttest survey_compliant, by(premiumcompare)
tab survey_compliant premiumcompare

ttest survey_refusal, by(premiumcompare)
tab survey_refusal premiumcompare

*fatf treatment
ttest survey_nonresponse, by(fatfcompare) 
tab survey_nonresponse fatfcompare

ttest survey_noncompliant, by(fatfcompare)
tab survey_noncompliant fatfcompare

ttest survey_partcompliant, by(fatfcompare)
tab survey_partcompliant fatfcompare

ttest survey_compliant, by(fatfcompare)
tab survey_compliant fatfcompare

ttest survey_refusal, by(fatfcompare)
tab survey_refusal fatfcompare

*comb. of premium, corruption, terror (since few observations for each on own)
ttest survey_nonresponse, by(premcorrterr)
tab survey_nonresponse premcorrterr

ttest survey_noncompliant, by(premcorrterr)
tab survey_noncompliant premcorrterr

ttest survey_partcompliant, by(premcorrterr)
tab survey_partcompliant premcorrterr

ttest survey_compliant, by(premcorrterr)
tab survey_compliant premcorrterr

ttest survey_refusal, by(premcorrterr)
tab survey_refusal premcorrterr


***************************************************************************************
**** Table 5: Comparative Treatment Effects for Field and Survey Experiments (US CSPs)
***************************************************************************************

***US DATA***
clear
use "survey_us_data.dta"
drop if exp_nonresponse == 0 & exp_noncompliant == 0 & exp_partcompliant == 0 & exp_compliant == 0 & exp_refusal == 0 

*consider treatment effects within the experiment
*terrorism treatment
ttest exp_nonresponse, by(terrorcompare)
tab   exp_nonresponse terrorcompare

ttest exp_noncompliant, by(terrorcompare)
tab   exp_noncompliant terrorcompare

ttest exp_partcompliant, by(terrorcompare)
tab   exp_partcompliant terrorcompare

ttest exp_compliant, by(terrorcompare)
tab  exp_compliant terrorcompare

ttest exp_refusal, by(terrorcompare)
tab   exp_refusal terrorcompare

*corruption treatment
ttest exp_nonresponse, by(corruptioncompare)
tab exp_nonresponse corruptioncompare

ttest exp_noncompliant, by(corruptioncompare)
tab exp_noncompliant corruptioncompare

ttest exp_partcompliant, by(corruptioncompare)
tab exp_partcompliant corruptioncompare

ttest exp_compliant, by(corruptioncompare)
tab exp_compliant corruptioncompare

ttest exp_refusal, by(corruptioncompare)
tab exp_refusal corruptioncompare

*irs treatment
ttest exp_nonresponse, by(irscompare)
tab exp_nonresponse irscompare

ttest exp_noncompliant, by(irscompare)
tab exp_noncompliant irscompare

ttest exp_partcompliant, by(irscompare)
tab exp_partcompliant irscompare

ttest exp_compliant, by(irscompare)
tab exp_compliant irscompare

ttest exp_refusal, by(irscompare)
tab exp_refusal irscompare

*fatf treatment
ttest exp_nonresponse, by(fatfcompare)
tab exp_nonresponse fatfcompare

ttest exp_noncompliant, by(fatfcompare)
tab exp_noncompliant fatfcompare

ttest exp_partcompliant, by(fatfcompare)
tab exp_partcompliant fatfcompare

ttest exp_compliant, by(fatfcompare)
tab exp_compliant fatfcompare

ttest exp_refusal, by(fatfcompare)
tab exp_refusal fatfcompare

*a combination of irs, corruption, terror
ttest exp_nonresponse, by(irscorrterr)
tab exp_nonresponse irscorrterr

ttest exp_noncompliant, by(irscorrterr)
tab exp_noncompliant irscorrterr

ttest exp_partcompliant, by(irscorrterr)
tab exp_partcompliant irscorrterr

ttest exp_compliant, by(irscorrterr)
tab exp_compliant irscorrterr

ttest exp_refusal, by(irscorrterr)
tab exp_refusal irscorrterr


*now consider treatment effects within the survey
keep if treatment==survey_treatment
*terrorism treatment

ttest survey_nonresponse, by(terrorcompare)
tab survey_nonresponse terrorcompare

ttest survey_noncompliant, by(terrorcompare)
tab survey_noncompliant terrorcompare

ttest survey_partcompliant, by(terrorcompare)
tab survey_partcompliant terrorcompare

ttest survey_compliant, by(terrorcompare)
tab survey_compliant terrorcompare

ttest survey_refusal, by(terrorcompare)
tab survey_refusal terrorcompare

*corruption treatment
ttest survey_nonresponse, by(corruptioncompare) 
tab survey_nonresponse corruptioncompare

ttest survey_noncompliant, by(corruptioncompare)
tab survey_noncompliant corruptioncompare

ttest survey_partcompliant, by(corruptioncompare)
tab survey_partcompliant corruptioncompare

ttest survey_compliant, by(corruptioncompare)
tab survey_compliant corruptioncompare

ttest survey_refusal, by(corruptioncompare)
tab survey_refusal corruptioncompare

*irs treatment
ttest survey_nonresponse, by(irscompare)
tab survey_nonresponse irscompare
 
ttest survey_noncompliant, by(irscompare)
tab survey_noncompliant irscompare

ttest survey_partcompliant, by(irscompare)
tab survey_partcompliant irscompare

ttest survey_compliant, by(irscompare)
tab survey_compliant irscompare

ttest survey_refusal, by(irscompare)
tab survey_refusal irscompare

*fatf treatment
ttest survey_nonresponse, by(fatfcompare) 
tab survey_nonresponse fatfcompare

ttest survey_noncompliant, by(fatfcompare)
tab survey_noncompliant fatfcompare

ttest survey_partcompliant, by(fatfcompare)
tab survey_partcompliant fatfcompare

ttest survey_compliant, by(fatfcompare)
tab survey_compliant fatfcompare

ttest survey_refusal, by(fatfcompare)
tab survey_refusal fatfcompare

*combination of irs, corruption, terror (since few observations for each on own)
ttest survey_nonresponse, by(irscorrterr)
tab survey_nonresponse irscorrterr

ttest survey_noncompliant, by(irscorrterr)
tab survey_noncompliant irscorrterr

ttest survey_partcompliant, by(irscorrterr)
tab survey_partcompliant irscorrterr

ttest survey_compliant, by(irscorrterr)
tab survey_compliant irscorrterr

ttest survey_refusal, by(irscorrterr)
tab survey_refusal irscorrterr



********************************************************************************
********************************************************************************
/*** RESULTS FROM APPENDIX ***/
********************************************************************************
********************************************************************************

********************************************************************************
**** Tables A1 and A2: Tables A1 and A2 in the Appendix are derived directly  
*	 from the qualitative results in Tables 4 and 5 of the manuscript
********************************************************************************


******************************************************************************************
**** Tables A3 and A4: Spearman's Rho for Response Correspondence between 
* 	 Survey adn Field Experiment (Intl)
******************************************************************************************

***INTERNATIONAL DATA***
clear
use "survey_intl_data.dta"
*note: conditional (treatment==survey_treatment) to not count duplicates for the 
* 	survey; the same subject may have multiple experimental observations
*   but only the survey with the same treatment should count
keep if treatment == survey_treatment

collapse (mean)  exp_noncompliant exp_partcompliant exp_compliant exp_refusal survey_noncompliant survey_partcompliant survey_compliant survey_refusal, by(treatment)

spearman exp_noncompliant survey_noncompliant
spearman exp_partcompliant survey_partcompliant
spearman exp_compliant  survey_compliant
spearman exp_refusal survey_refusal


******************************************************************************************
*** Spearman's Rho for Response Correspondence between Survey adn Field Experiment (US)
******************************************************************************************

***U.S. DATA***
clear
use "survey_us_data.dta"
drop if exp_nonresponse == 0 & exp_noncompliant == 0 & exp_partcompliant == 0 & exp_compliant == 0 & exp_refusal == 0 
*note: conditional (treatment==survey_treatment) to not count duplicates for the 
* 	survey; the same subject may have multiple experimental observations
*   but only the survey with the same treatment should count
keep if treatment == survey_treatment

collapse (mean)  exp_noncompliant exp_partcompliant exp_compliant exp_refusal survey_noncompliant survey_partcompliant survey_compliant survey_refusal, by(treatment)

spearman exp_noncompliant survey_noncompliant
spearman exp_partcompliant survey_partcompliant
spearman exp_compliant  survey_compliant
spearman exp_refusal survey_refusal
