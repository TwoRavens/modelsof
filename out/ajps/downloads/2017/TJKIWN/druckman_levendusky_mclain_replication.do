/* Stata Replication Commands for: "No Need to Watch: How the Effects of Partisan Media Can Spread Via Inter-Personal Discussions" */ 
/* by James Druckman, Matt Levendusky, and Audrey McLain */ 
/* This File: November 2016 */  

/* Start a log file to save the Stata output */ 
log using druckman_levendusky_mclain_replication.smcl, replace 

/* Analyses below were run in Stata 14, set to version 14 */ 
version 14 

/* Set more off to avoid it interrupting the code */ 
set more off 

/* Read in the data */ 
use "druckman_levendusky_mclain_ajps_replication_data.dta"

********************************************************************************
** First, We Create Variables that Record Subjects' Partisan Meida Exposure & **
** Exposure to Deliberation. This comes from the condition to which they were ** 
** Randomly Assigned. This is the defintion of the treatment for this study.  ** 
********************************************************************************

/* Code Up the Type of Video Content Subjects were assigned to see  */ 
gen watch_lm = 0 
replace watch_lm = 1 if Condition == "2" | Condition == "5B" | Condition == "8B" 

gen watch_cc = 0 
replace watch_cc = 1 if Condition == "3" | Condition == "6B" | Condition == "9B" 

gen choice = 0 
replace choice = 1 if Condition == "4" | Condition == "7B" | Condition == "10B"  

gen no_video = 0 
replace no_video = 1 if Condition == "1" | Condition=="5A" | Condition=="6A" | Condition=="7A" | Condition=="8A" | Condition=="9A" | Condition == "10A"

/* watch anything */ 
gen video = 0 
replace video = 1 if watch_lm ==1 | watch_cc == 1 | choice == 1 

/* Did Subjects Engage in Deliberation? */ 
gen no_delib = 0 
replace no_delib = 1 if Condition == "1" | Condition == "2" | Condition == "3" | Condition == "4" 

gen homog_delib = 0 
replace homog_delib = 1 if Condition == "5A" | Condition == "5B" | Condition == "6A" | Condition == "6B" | Condition == "7A" | Condition == "7B" 

gen heterog_delib = 0 
replace heterog_delib = 1 if Condition == "8A" | Condition =="8B" | Condition == "9A" | Condition == "9B" | Condition == "10A" | Condition == "10B" 

/* Create a numeric variable that gives your initial condition */ 
encode Condition, generate(assigned) 

/* Create dummies for party */ 
gen dem = 0 
replace dem = 1 if Pid < 4 

gen rep = 0 
replace rep = 1 if Pid > 4 

/* minority status */
gen minority = Race
recode minority 0/0 = 0  1/4 = 1 5/5 = .

**************************
** Sample Demographics  ** 
**************************

mean dem 
mean rep 
mean Female 
mean minority 
mean Age 
tabulate Income 

***********************************
** Sample Breakdown by Condition **
*********************************** 

/* First, create a single variable that maps subjects into Groups 0-5 */
/* This will be used for the sample breakdown, and Figure 2 below     */  
/* 0: Control (Group 0)                                               */ 
/* 1: Video Only (Group 1)                                            */  
/* 2: Homogeneous Discussion Only (Group 2)                           */ 
/* 3: Heterogeneous Discussion Only (Group 3)                         */ 
/* 4: Homog. Disc & Exposure (Group 4)                                */ 
/* 5: Heterog. Disc & Exposure (Group 5)                              */ 

gen figure_cond = . 
replace figure_cond = 0 if assigned == 1  
replace figure_cond = 1 if video == 1 
replace figure_cond = 2 if homog_delib == 1 & video == 0 
replace figure_cond = 3 if heterog_delib == 1 & video == 0 
replace figure_cond = 4 if homog_delib == 1 & video == 1 
replace figure_cond = 5 if heterog_delib == 1 & video == 1 
table figure_cond assigned  		

label define figlab 0 "Control (0)" 1 "Exposure Only (1) " 2 "HO Disc. Only (2)" 3 "HE Disc. Only (3)" 4 "HO Disc & Exposure (4)" 5 "HE Disc & Exposure (5)" 
label values figure_cond figlab 

tabulate figure_cond 

*****************************************************************
** Now Code the Dependent Variable                             **
** This is attitudes towards the Keystone XL Pipeline/Drilling **
***************************************************************** 

/* Post-test Attitudes */ 
alpha SupportCoastal SupportFederal SupportKeystone /* alpha = 0.92 */ 
egen support_oil = rmean(SupportCoastal SupportFederal SupportKeystone) 

/* fold attitudes so that higher values mean you're more consistent with your party */ 
gen folded_support_oil = . 
replace folded_support_oil = support_oil if rep == 1 
replace folded_support_oil = (-1*support_oil) + 8 if dem == 1  

*********************************************************************
** In the Choice Condition, What Percent of People Watch LM Video? ** 
*********************************************************************  

gen choose_lm = 0 
replace choose_lm = . if choice  == 0 /* don't look at people who don't get to choose */  
replace choose_lm = 1 if VideoWatch1 == "A" & dem == 1 /* Maddow for Dems */ 
replace choose_lm = 1 if VideoWatch1 == "B" & dem == 1 /* Chris Hayes for Dems */ 
replace choose_lm = 1 if VideoWatch2 == "A" & dem == 1 
replace choose_lm = 1 if VideoWatch2 == "B" & dem == 1 
replace choose_lm = 1 if VideoWatch3 == "A" & dem == 1 
replace choose_lm = 1 if VideoWatch3 == "B" & dem == 1 
replace choose_lm = 1 if VideoWatch1 == "C" & rep == 1 
replace choose_lm = 1 if VideoWatch2 == "C" & rep == 1 
replace choose_lm = 1 if VideoWatch3 == "C" & rep == 1 

mean choose_lm /* 79.1% choose at least some LM content */ 


***************************************************************
** Materials to Replicate Table 3 (Main Analysis)            ** 
** Tables 1 & 2 are text-only, and created in Microsoft Word **
***************************************************************

/* First, create a variable that indicates whether you watched video & deliberated  */ 
/* You need this for column 2: want to remove those who both deliberated & watched video */ 
/* This lets us actually test for two-stage effects */ 
gen dw = 0 
replace dw = 1 if video == 1 & homog_delib == 1 
replace dw = 1 if video == 1 & heterog_delib ==1 
table assigned dw 

/* column 1: does media exposure alone polarize? */ 
reg folded_support_oil watch_lm watch_cc choice if Pid !=4 & no_delib == 1 
test watch_lm = watch_cc /* test for differences across types of media exposure */ 
test watch_lm = choice 
test watch_cc = choice 

/* In the control condition, what percentage of subjects are within 1-point of the scale mean? */ 
gen within_one = . 
replace within_one = 0 if figure_cond == 0 /* just look at control subjects */ 
replace within_one = 1 if folded_support_oil > 2.99 & folded_support_oil < 5.01 & figure_cond == 0 
mean within_one /* 62% */ 

/* column 2: do two-step effects occur? */ 
reg folded_support_oil video homog_delib heterog_delib if dw==0 & Pid !=4, cluster(Group_Number) 
test video = homog_delib /* effects of homog delib bigger than direct video exposure? */ 
test video = heterog_delib /* effect of video larger than heterog delib? */ 
test homog_delib = heterog_delib /* effect of homog delib larger than heterog delib? */ 

/* Beliefs about deliberation group participants (reported in-line) */
reg TrustOther homog_delib if no_delib == 0 & Pid !=4, cluster(Group_Number) 
reg KnowOther homog_delib if no_delib == 0 & Pid != 4, cluster(Group_Number) 

/* column: 3 effects of both deliberation and exposure */ 
reg folded_support_oil video##homog_delib video##heterog_delib if Pid != 4, cluster(Group_Number) 
test 1.homog_delib + 1.video#1.homog_delib = 0 /* does homog delib + video polarize more than video? */
test 1.heterog_delib + 1.video#1.heterog_delib = 0 /* does heterog delib + video moderate relative to video alone? */ 
test 1.video + 1.video#1.homog_delib = 0 /* diff between discussion only and media + discussion? */ 
test 1.video + 1.video#1.heterog_delib = 0 


************************************************
** Replication Code for Figure 2              ** 
** Figure 1 is text-only and done in MS Word  ** 
************************************************ 



mean folded_support_oil, over(figure_cond) 

/* If you have already install coefplot from SSC, you can comment out this line*/ 
ssc install coefplot  

coefplot, xlabel(3.5(0.5)6.5) xtitle("Attitude") ytitle("Assigned Condition") title("Effects of Media, Discussion, & Interaction") plotregion(fcolor(white)) graphregion(fcolor(white)) ///
          coeflabels(_subpop_1 = `""Control" "(Group 0)""'             ///
                     _subpop_2 = `""Exposure Only" "(Group 1)""'       ///
				     _subpop_3 = `""HO Disc. Only" "(Group 2)""'       /// 
				     _subpop_4 = `""HE Disc Only" "(Group 3)""'       /// 
				     _subpop_5 = `""HO Disc & Exposure" "(Group 4)""'  ///
				     _subpop_6 = `""HE Disc & Exposure" "(Group 5)""') 
	       

/* This concludes the main analysis, so close the log file */  
log close 
