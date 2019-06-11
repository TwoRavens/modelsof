/*============================================================================================================ 
*****************************************
UPDATED: 1/31/18

Stata v.14 SE
*****************************************

Do file replicating "True Believers..."(Oppenheim et al. 2015) from the JCR,
and producing tables/figures used in "A Warning on Separation in Multinomial Logistic Models" 
by Cook, Scott J., John Niehaus, and Samantha Zuhlke
3/10/2018

File does the following: 

1. Generates an rescaled age variable. Detailed in ReadMe.rtf

2. Creates cross tabulations of key variables to demonstrate empty cells -- aka, separation. -- Table 2 in Main Text 

3. Replicates Models 3-5 of Oppenheim et al. using naive multinomial logit -- Table 3 in Main Text

4. Replicates Models 1-2 of Oppenheim et al. using naive multinomial logit  -- Table 1 in Appendix B

4. Replicates Models 3-5 of Oppenheim et al. using naive multinomial logit (reported as relative risk) -- Table 2 in Appendix B 

5. Replicates Models 3-5 of Oppenheim et al. using naive multinomial logit (using original age variable; yrbirth) -- Table 3 in Appendix B 

6. Replicates Models 3-5 of Oppenheim et al. using binary logit  -- Table 4 in Appendix B  


==============================================================================================================*/

capture log close 
clear
set more off 

* cd "..." 

use "replication data.dta", clear

log using "Warning_RAP_Comment_stataLog", text replace

*******************************
* NECESSARY PACKAGES
*******************************
ssc install estout         



** GENERATING NEW AGE VARIABLE*******
gen yrstudy=2008
gen ageys=yrstudy-yrbirth
*************************************


********************************************************************************
************************** Tables from Main Text *******************************
********************************************************************************

						          *Table 2*
/*==============================================================================
=================== CROSS-TABLES TO DEMONSTRATE SEPARATION ISSUE ===============
================================================================================*/

 table DV_cap_inddemob_switcher join_ec_need p409dummy , contents(freq)
 table DV_cap_inddemob_switcher join_ideo p402g , contents(freq)
 table DV_cap_inddemob_switcher join_ec_need p402g , contents(freq)

 
 						          *Table 3*
/*==============================================================================
========Replication of Oppenheim, et al Models 3-5 using MNL====================
================================================================================*/

eststo mn3c: mlogit DV_cap_inddemob_switcher i.join_ec_need##i.p409dummy p104a yrbirth p203 p101, r base(0)  cluster(p504dantes)

eststo mn4c: mlogit DV_cap_inddemob_switcher i.join_ideo##i.p402g p104a yrbirth p203 p101, r base(0) cluster(p504dantes)

eststo mn5c: mlogit DV_cap_inddemob_switcher i.join_ec_need##i.p402g p104a yrbirth p203 p101, r base(0)  cluster(p504dantes) 

esttab mn3c mn4c  mn5c using table3_comment.tex, se starlevels(* 0.1 ** 0.05  *** 0.01 ) /// 
	mtitles unstack nogap constant label b(3) aic title(Main Text Table 3) noomitted nobaselevels replace
 
 
 

 
 
******************************************************************************** 
********************************** APPENDIX ************************************
********************************************************************************	

						          *Table 1*
/*==============================================================================
=================== Replication of Oppenheim, et al Models 1&2 using MNL =======
================================================================================*/

eststo m1c:  mlogit DV_cap_inddemob_switcher join_ideo p104a yrbirth p203 p101, base(0)  cluster(p504dantes) r 


eststo m2d:  mlogit DV_cap_inddemob_switcher join_ec_need p104a yrbirth p203 p101, base(0)  cluster(p504dantes) r


esttab m1c m2d using app_table1_comment.tex, se starlevels(* 0.1 ** 0.05  *** 0.01 ) /// 
	mtitles unstack nogap constant label title("Appendix Table 1: MNL / Firth comparison models 1-2") ///
		b(3) aic nobaselevels noomitted replace
	

	
						          *Table 2*
/*==============================================================================
========Replication of Oppenheim, et al Models 3-5 using MNL (Relative Risk) ===
================================================================================*/	

eststo mncf3: mlogit DV_cap_inddemob_switcher i.join_ec_need##i.p409dummy p104a yrbirth p203 p101, base(0) cluster(p504dantes) r rrr	
eststo mncf4: mlogit DV_cap_inddemob_switcher i.join_ideo##i.p402g p104a yrbirth p203 p101, base(0) cluster(p504dantes) r rrr
eststo mncf5: mlogit DV_cap_inddemob_switcher i.join_ec_need##i.p402g p104a yrbirth p203 p101, base(0)  cluster(p504dantes) r rrr


esttab mncf3 mncf4 mncf5 using app_table2_comment.tex, se starlevels(* 0.1 ** 0.05  *** 0.01 ) /// 
	mtitles  unstack aic b(3) nogap constant label title("Appendix table 2:: MNL models 3-5, Relative Risk") nobaselevels noomitted replace
 
 
 	
						          *Table 3*
/*======================================================================================
========Replication of Oppenheim, et al Models 3-5 using MNL (New Age Variable; ageys) ===
========================================================================================*/	

eststo mn3: mlogit DV_cap_inddemob_switcher i.join_ec_need##i.p409dummy p104a ageys p203 p101, base(0)  cluster(p504dantes) r
	
eststo mn4: mlogit DV_cap_inddemob_switcher i.join_ideo##i.p402g p104a ageys p203 p101, base(0)  cluster(p504dantes)	r

eststo mn5: mlogit DV_cap_inddemob_switcher i.join_ec_need##i.p402g p104a ageys p203 p101, base(0)  cluster(p504dantes) r


esttab mn3 mn4 mn5 using app_table3_comment.tex, se starlevels(* 0.1 ** 0.05  *** 0.01 ) /// 
	mtitles unstack nogap constant label title("Appendix Table 3: Models 3-5 MNL w/ New Age Variable") ///
	 b(3) aic nobaselevels noomitted replace
	
	
	
 	
						          *Table 4*
/*======================================================================================
========Replication of Oppenheim, et al Models 3-5 using Binary Logit ================
========================================================================================*/	

*Creating set of binary indicators from the nominal outcome
tab DV_cap_inddemob_switcher, gen(b) 

gen b12=b1							
replace b12=. if b3==1				
								
gen b13=b1
replace b13=. if b2==1

gen b23=b2
replace b23=. if b1==1

gen b21=1 if b12==0
replace b21=0 if b12==1  

gen b31=1 if b13==0 
replace b31=0 if b13==1  

gen demob1_capture0=b21  
gen switch1_capture0=b31  
gen demob1_switch0=b23

*Model 3
eststo mn3c: mlogit DV_cap_inddemob_switcher i.join_ec_need##i.p409dummy p104a yrbirth p203 p101, base(0) r  cluster(p504dantes)
eststo bn3ac: logit demob1_capture0 i.join_ec_need##i.p409dummy p104a yrbirth p203 p101, r cluster(p504dantes) 
eststo bn3bc: logit switch1_capture0 i.join_ec_need##i.p409dummy p104a yrbirth p203 p101, r cluster(p504dantes)

*Model 4	
eststo mn4c: mlogit DV_cap_inddemob_switcher i.join_ideo##i.p402g p104a yrbirth p203 p101, base(0) r cluster(p504dantes) 
eststo bn4ac: logit demob1_capture0 i.join_ideo##i.p402g p104a yrbirth p203 p101, r cluster(p504dantes)
eststo bn4bc: logit switch1_capture0 i.join_ideo##i.p402g p104a yrbirth p203 p101, r cluster(p504dantes)

*Model 5
eststo mn5c: mlogit DV_cap_inddemob_switcher i.join_ec_need##i.p402g p104a yrbirth p203 p101, base(0) r cluster(p504dantes)
eststo bn5ac: logit demob1_capture0 i.join_ec_need##i.p402g p104a yrbirth p203 p101, r cluster(p504dantes)
eststo bn5bc: logit switch1_capture0 i.join_ec_need##i.p402g p104a yrbirth p203 p101, r cluster(p504dantes)

esttab mn3c bn3ac bn3bc mn4c bn4ac bn4bc mn5c bn5ac bn5bc using app_table4_comment.tex, se starlevels(* 0.1 ** 0.05  *** 0.01 ) /// 
	mtitles unstack nogap constant  label title("Appendix Table 4: MNL / Binary Comparison Models 3-5") b(3) ///
	aic nobaselevels noomitted replace 
   
log close 
						 
