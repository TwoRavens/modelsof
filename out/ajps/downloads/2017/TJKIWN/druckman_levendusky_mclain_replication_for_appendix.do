/* Stata Replication Commands for: "No Need to Watch: How the Effects of Partisan Media Can Spread Via Inter-Personal Discussions" */ 
/* by James Druckman, Matt Levendusky, and Audrey McLain */ 
/* This File: November 2016 */  

/* This file replicates the analysis in the appendix to Druckman et al. */ 
/* Before running this file, you need to run "druckman_levendusky_mclain_ajps_replication.do */ 
/* If you do not run that file first, this file will fail */ 

/* Start a log file to save the Stata output */ 
log using druckman_levendusky_mclain_replication_for_appendix.smcl, replace 

/* Analyses below were run in Stata 14, set to version 14 */ 
version 14 

/* Set more off to avoid it interrupting the code */ 
set more off 

*********************************************
** Additional Analysis of Choice Condition **
*********************************************

/* CHOICE RESULTS */
/* In the choice condition, how many videos did people watch? */ 
gen valid1 = 0 
replace valid1 = . if choice == 0  
replace valid1 = 1 if VideoWatch1 != "" 

gen valid2 = 0  
replace valid2 = . if choice == 0 
replace valid2 = 1 if VideoWatch2 != "" 

gen valid3 = 0  
replace valid3 = . if choice == 0 
replace valid3 = 1 if VideoWatch3 != "" 

egen numb_videos = rsum(valid1 valid2 valid3) 
replace numb_videos = . if choice == 0 /* only look at cases in the choice condition */ 
tabulate numb_videos /* 14% of people watch only 1 video, 55% watch 2 videos, and 31% report watching 3 videos. Thus median is 2 videos*/ 

tab numb_videos
sum numb_videos

/* How many people report only LM content? */ 
gen lm1 = 0 
replace lm1 = . if choice  == 0 /* don't look at people who don't get to choose */  
replace lm1 = 1 if VideoWatch1 == "A" & dem == 1 | VideoWatch1 == "B" & dem == 1 
replace lm1 = 1 if VideoWatch1 == "C" & rep == 1 

gen lm2 = 0 
replace lm2 = . if choice  == 0 /* don't look at people who don't get to choose */  
replace lm2 = . if VideoWatch2 == ""   
replace lm2 = 1 if VideoWatch2 == "A" & dem == 1 | VideoWatch2 == "B" & dem == 1 
replace lm2 = 1 if VideoWatch2 == "C" & rep == 1 

gen lm3 = 0 
replace lm3 = . if choice  == 0 /* don't look at people who don't get to choose */  
replace lm3 = . if VideoWatch3 == ""   
replace lm3 = 1 if (VideoWatch3 == "A" & dem == 1) | (VideoWatch3 == "B" & dem == 1) 
replace lm3 = 1 if (VideoWatch3 == "C" & rep == 1)  

egen numb_lm = rsum(lm1 lm2 lm3) 
replace numb_lm = . if choice == 0 

gen only_lm = 0 
replace only_lm = . if choice == 0 
replace only_lm = 1 if numb_videos == numb_lm & choice == 1 

/* 19% watch only same party content */ 
tab only_lm
sum only_lm

/* How many people chose at least 1 entertainment video? */ 
gen ent1 = 0 
replace ent1 = . if choice  == 0 /* don't look at people who don't get to choose */  
replace ent1 = 1 if VideoWatch1 == "E" | VideoWatch1 == "F"

gen ent2 = 0 
replace ent2 = . if choice  == 0 /* don't look at people who don't get to choose */  
replace ent2 = 1 if VideoWatch2 == "E" | VideoWatch2 == "F"

gen ent3 = 0 
replace ent3 = . if choice  == 0 /* don't look at people who don't get to choose */  
replace ent3 = 1 if VideoWatch3 == "E" | VideoWatch3 == "F"

egen numb_ent = rsum(ent1 ent2 ent3) 
replace numb_ent = . if choice == 0 

/* 60% watch only at least one entertainment option */ 

tab numb_ent
sum numb_ent

/* How many people watch cross-cutting media? */ 

gen cc1 = 0 
replace cc1 = . if choice  == 0 /* don't look at people who don't get to choose */  
replace cc1 = 1 if VideoWatch1 == "A" & rep == 1 | VideoWatch1 == "B" & rep == 1 
replace cc1 = 1 if VideoWatch1 == "C" & dem == 1 

gen cc2 = 0 
replace cc2 = . if choice  == 0 /* don't look at people who don't get to choose */  
replace cc2 = 1 if VideoWatch2 == "A" & rep == 1 | VideoWatch2 == "B" & rep == 1 
replace cc2 = 1 if VideoWatch2 == "C" & dem == 1 

gen cc3 = 0 
replace cc3 = . if choice  == 0 /* don't look at people who don't get to choose */  
replace cc3 = 1 if VideoWatch3 == "A" & rep == 1 | VideoWatch3 == "B" & rep == 1 
replace cc3 = 1 if VideoWatch3 == "C" & dem == 1 

egen numb_cc = rsum (cc1 cc2 cc3) 
replace numb_cc = . if choice == 0

/* 11% watch only opposite party content */ 
tab numb_cc
sum numb_cc

***********************************************************
** Table A1: Two-Stage Communication Flows by Media Type ** 
***********************************************************

/* Table A1, Media Type and With Controls. See codebook for mapping of condition numbers onto actual conditions*/
reg folded_support_oil i.assigned if Pid != 4 & dw == 0, cluster(Group_Number)  

/* Create knowledge item */ 
egen quiz = rsum(Veto OilExport Renewable HouseMajority LawCons SecState GulfBan ConsParty MEOil) 
summarize quiz, detail 

reg folded_support_oil i.assigned ProtectEnviro PolInterest quiz Income minority Age Female if dw == 0 & Pid !=4, cluster(Group_Number) 

***********************************************
** Table A2: Discussion/Exposure Interaction **
***********************************************
reg folded_support_oil watch_lm##homog_delib watch_lm##heterog_delib watch_cc##homog_delib watch_cc##heterog_delib choice##homog_delib choice##heterog_delib if Pid != 4, cluster(Group_Number) 

*********************************************
** Table A3: Results for Pure Independents **
*********************************************

/* does partisan media polarize Independents? */  
reg support_oil watch_lm watch_cc choice if no_delib == 1 & Pid == 4 

/* For two-stage effects, need to just run on those who just deliberate but don’t watch video */ 
/* need to differentiate homogeneous Dem/Rep groups */ 
bysort Group_Number: egen avg_pid = mean(Pid) 
gen ind_homog_dem = 0 
replace ind_homog_dem = 1 if IndepDelib == 1 & avg_pid < 4 
gen ind_homog_rep = 0 
replace ind_homog_rep = 1 if IndepDelib == 1 & avg_pid > 4 
 
reg support_oil video ind_homog_dem ind_homog_rep heterog_delib if dw ==0 & Pid == 4, cluster(Group_Number) 
reg support_oil video##ind_homog_dem video##ind_homog_rep video##heterog_delib if Pid == 4, cluster(Group_Number)  

**********************************************
** Table A4: Moderating Effect of Education **
**********************************************

gen baplus = 0 
replace baplus = 1 if Educ > 2  
reg folded_support_oil watch_lm##baplus watch_cc##baplus choice##baplus if Pid!=4 & no_delib == 1  
reg folded_support_oil video##baplus homog_delib##baplus heterog_delib##baplus if Pid!=4 & dw == 0, cluster(Group_Number) 
reg folded_support_oil video##baplus##homog_delib video##heterog_delib##baplus if Pid!=4, cluster(Group_Number) 

*****************************************************
** Table A5: Distribution of Party ID by Condition **
*****************************************************

tab figure_cond if dem == 1
tab figure_cond if Pid > 4
tab figure_cond if Pid == 4

****************************************
** Table A6: Results Sepated by Party **
****************************************

reg folded_support_oil watch_lm##dem watch_cc##dem choice##dem if Pid !=4 & no_delib == 1
reg folded_support_oil video##dem homog_delib##dem heterog_delib##dem if dw==0 & Pid !=4, cluster(Group_Number)
reg folded_support_oil dem##video##homog_delib dem##video##heterog_delib if Pid != 4, cluster(Group_Number)

/* This concludes the analysis for appendix, close the log file */ 
log close 
