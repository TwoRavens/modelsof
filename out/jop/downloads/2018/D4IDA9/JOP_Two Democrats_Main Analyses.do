***JOP Wronski, Bankert, Amira,  Johnson, and Levitan****
***Maintext Figures and Tables***

************************************Mean Difference in Authoritarianism between Reps and Dems CCES***********************************
*****Figure 1a****


sum RWA if PID > 0.5 & V101 ! = . 
sum RWA if PID < 0.5 & V101 ! = . 

gen RWA_Dems_CCES = RWA if PID < 0.5 & V101 ! = . 
gen RWA_Reps_CCES = RWA if PID > 0.5 & V101 ! = . 

ttest RWA_Dems_CCES = RWA_Reps_CCES, unpaired unequal

graph box RWA, over(PID2)

**statistically sig. difference of 0.14**

************************************Standard Deviation Test Authoritarianism CCES***********************************

sdtest RWA_Dems_CCES = RWA_Reps_CCES 

***stastically signficiant difference in variation, Dems higher than Reps***


***************Mean Difference Authoritarianism between Clinton and Sanders Supporters CCES*************************************
****Figure 1b***

**For Clinton**

sum RWA if PID < 0.5 & Primary_CvS == 1 & V101 ! = . 

**For Sanders**

sum RWA if PID < 0.5 & Primary_CvS == 0 & V101 ! = . 

gen RWA_Dems_Clinton_CCES = RWA if PID < 0.5 & Primary_CvS == 1 & V101 ! = . 
gen RWA_Dems_Sanders_CCES = RWA if PID < 0.5 & Primary_CvS == 0 & V101 ! = . 

ttest RWA_Dems_Clinton_CCES = RWA_Dems_Sanders_CCES, unpaired unequal

**statistically significant difference of 0.22**

univar RWA_Dems_Clinton_CCES 
univar RWA_Dems_Sanders_CCES 

graph box RWA, over(Primary_CvS)

***************Mean Difference Authoritarianism between Cruz and Trump Supporters CCES*************************************
*****Appendix Figure A3a****
 
sum RWA if PID > 0.5 & Primary_Trump == 1 & V101 ! = . 
sum RWA if PID > 0.5 & Primary_Cruz == 1 & V101 ! = . 

gen RWA_Reps_Cruz_CCES = RWA if PID > 0.5 & Primary_Cruz == 1 & V101 ! = . 
gen RWA_Reps_Trump_CCES = RWA if PID > 0.5 & Primary_Trump == 1 & V101 ! = . 

ttest RWA_Reps_Trump_CCES = RWA_Reps_Cruz_CCES, unpaired unequal

***statistically insignificant difference of 0.04***


********MAIN MODELS***********

logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined White_combined  Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined if V101 !=.  & PID < 0.5, robust
estimates store CCESClintonvsSanders
margins, at(RWA_combined=(0(0.25)1) Married_Combined ==1 Gender_combined == 1 White_combined == 1 South_Combined == 0) atmeans post
estimates store CvsS_margins_CCES
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined White_combined   if school !=. & PID01 < 0.5, robust
estimates store SouthernClintonvsSanders
margins, at(RWA_combined=(0(0.25)1) Gender_combined == 1 White_combined ==1) atmeans post
estimates store CvsS_margins_South
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined White_combined  Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined NEED_close SDO Racial  if caseid !=. , robust
estimates store YouGov
margins, at(RWA_combined=(0(0.25)1) Married_Combined ==1 Gender_combined == 1 White_combined == 1 South_Combined == 0) atmeans post
estimates store YouGov_CvsS_margins

***Figure 2***
coefplot CCESClintonvsSanders || YouGov ||  SouthernClintonvsSanders || ,drop(_cons) xline(0) byopts(row(1))


***Figure 3***
coefplot CvsS_margins_CCES YouGov_CvsS_margins CvsS_margins_South, at ytitle(Pr(Primary_ClintonvsSanderscombined=1)) xtitle(Authoritarianism) legend(rows(1))

