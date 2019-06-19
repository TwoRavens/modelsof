
#delim cr
set more off
version 11
pause off

capture log close
set linesize 240
set logtype text
log using examinercharacteristics_output.log, replace

use lemleysampat_replicationfile, clear

capture log close 

/* --------------------------------------

AUTHOR: Bhaven N. Sampat

PURPOSE: Replication file for Lemley and Sampat
"Examiner Characteristics and Patent Office Outcomes"
Review of Economics and Statistics, August 2012, 94(3):
817-827

DATE CREATED: August 2012

--------------------------------------- */


************************************************************
**   Table 1: Descriptive Statistics
************************************************************

summ expbasecat expcat234 expcat567 expcat89 patented norejection us_ex np_ex us_ap np_ap



************************************************************
**   Table 2: Summary Information from OLS Regressions 
** 	 Relating the Nubmer of Examiner Citation In a Patent to 
**   Art Unit and Examiner Effects
************************************************************


qui egen examiner_id=group(examiner)
qui tab art_unit, gen(audums)
qui tab examiner, gen(exdums)

qui reg us_ex audums*

display "R-squared=" %9.3f e(r2) _newline "Adjusted R-squared=" %9.3f e(r2_a) _newline "N=" e(N)

qui areg us_ex audums*, absorb(examiner)
display "R-squared=" %9.3f e(r2) _newline "Adjusted R-squared=" %9.3f e(r2_a) _newline "N=" e(N) _newline "F-Statistic for Examiner Effect " %9.2f e(F_absorb)

qui reg np_ex audums*
display "R-squared=" %9.3f e(r2) _newline "Adjusted R-squared=" %9.3f e(r2_a) _newline "N=" e(N) 
qui areg np_ex audums*, absorb(examiner)
display "R-squared=" %9.3f e(r2) _newline "Adjusted R-squared=" %9.3f e(r2_a) _newline "N=" e(N) _newline "F-Statistic for Examiner Effect " %9.2f e(F_absorb) 


************************************************************
**   Table 3: OLS Regressions Relating the Number of Examiner
**   Citations to Examiner Experience and Applicant Citations
************************************************************


areg us_ex expcat234 expcat567 expcat89, absorb(art_unit) cluster(examiner) robust
areg np_ex expcat234 expcat567 expcat89, absorb(art_unit) cluster(examiner) robust
areg us_ex us_ap np_ap expcat234 expcat567 expcat89, absorb(art_unit) cluster(examiner) robust
areg np_ex us_ap np_ap expcat234 expcat567 expcat89, absorb(art_unit) cluster(examiner) robust

************************************************************
**   Table 4: Linear Probability Models Relating Whether An 
**   Application Is Granted and Whether Granted with No 
**   Rejections to Examiner Experience
************************************************************

areg patented expcat234 expcat567 expcat89, absorb(art_unit) robust cluster(examiner)

areg norejection expcat234 expcat567 expcat89 if patented==1, absorb(art_unit) robust cluster(examiner)


************************************************************
**   Table 5: Application Level Characteristics Vs. Examiner 
**   Experience
************************************************************

areg number_of_pages expcat234 expcat567 expcat89, absorb(art_unit) cluster(examiner) robust

areg familysize expcat234 expcat567 expcat89, absorb(art_unit) cluster(examiner) robust


areg us_ap expcat234 expcat567 expcat89, absorb(art_unit) cluster(examiner) robust
areg np_ap expcat234 expcat567 expcat89, absorb(art_unit) cluster(examiner) robust
areg pats2000 expcat234 expcat567 expcat89, absorb(art_unit) cluster(examiner) robust

************************************************************
**   Table 6: US vs. EPO Outcomes
************************************************************

tab epo_short patented


************************************************************
**   Table 7: Linear Probability Model Relating Whether An 
**   Application is Granted to EPO Outcomes, and Experience
************************************************************

areg patented expcat234 expcat567 expcat89 epo_rejected epo_pending if european==1, absorb(art_unit) cluster(examiner) robust
areg patented expcat234 expcat567 expcat89 if european==1 & epo_patented==1, absorb(art_unit) cluster(examiner) robust
areg patented expcat234 expcat567 expcat89 if european==1 & epo_rejected==1, absorb(art_unit) cluster(examiner) robust

************************************************************
**   Table 8: OLS Models Relating Prosecution Characteristics
**   And Outcomes to Whether Examiner Will Leave in Five
**   Yea
************************************************************


areg us_ex will_leave us_ap np_ap expcat234 expcat567 expcat89 , absorb(art_unit) robust cluster(examiner)
areg np_ex will_leave us_ap np_ap expcat234 expcat567 expcat89, absorb(art_unit) robust cluster(examiner)
areg patented will_leave expcat234 expcat567 expcat89, absorb(art_unit) robust cluster(examiner)
areg norejection will_leave expcat234 expcat567 expcat89 if patented==1, absorb(art_unit) robust cluster(examiner)


capture log close
