
*************************************************
* Do File for "Do Sanctions Always Stigmatize?" *
* By Bryan Early and Amira Jadoon				*
* Date: 7.7.15									*
* Do File Written with STATA Version 11.2		*
* Email correspondance: bearly@albany.edu		*
*************************************************


********************************************************************
********************************************************************
****															****
****						Main Analysis						****
****															****
********************************************************************
********************************************************************

use "Do Sanctions Always Stigmatize - Final.dta", clear

**Summary Info. on HSE Sanctions Variables**
summ  US_Sanctions2 UN_Sanct if HSEsample==1
summ  TIES_SevUSSanct TIES_MinUSSanct if  TIESsample==1

**********************************************************************
** Table 1: U.S. Sanctions - Using Constant Year Economic Variables **
**********************************************************************

**Model 1: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M1: xtpcse   realnat  US_Sanctions2  lnrgdppc  	lnrtradeopen polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model 2: FGLS Regression and HSE Sanctions Variables**
eststo M2: xtgls    realnat  US_Sanctions2  lnrgdppc  	lnrtradeopen polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model 3: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M3: xtpcse   realnat  TIES_US_Sanct  lnrgdppc 	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model 4: FGLS Regression and TIES Sanctions Variables**
eststo M4: xtgls    realnat  TIES_US_Sanct  lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model 5: Regression Using Panel Corrected Std. Errors and TIES Foreign Aid Sanctions Variables**
eststo M5: xtpcse   realnat   TIES_US_TFA   lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model 6: FGLS Regression and TIES Foreign Aid Sanctions Variables**
eststo M6: xtgls    realnat   TIES_US_TFA    lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Output for Table 1**
esttab M1 M2 M3 M4 M5 M6, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)




********************************************************************
** Table 2: UN Sanctions - Using Constant Year Economic Variables **
********************************************************************

**Model 7: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M7: xtpcse    realnat  UN_Sanct      lnrgdppc  lnrtradeopen  polity2 communist USAlly  WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model 8: FGLS Regression and HSE Sanctions Variables**
eststo M8: xtgls    realnat  UN_Sanct       lnrgdppc  lnrtradeopen polity2 communist USAlly  WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model 9: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M9: xtpcse   realnat  TIES_UNSanct   lnrgdppc lnrtradeopen  polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model 10: FGLS Regression and TIES Sanctions Variables**
eststo M10: xtgls    realnat  TIES_UNSanct  lnrgdppc lnrtradeopen  polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Output for Table 2**
esttab M7 M8 M9 M10, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)


*************************************************************
** Rerunning Model 1 to generate the Differential Variable **
*************************************************************

eststo MX: xtpcse  realnat  lnrgdppc lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if US_Sanctions2==0, corr(psar1) pairwis 
predict NoSanctAid if US_Sanctions2==1
label var NoSanctAid "Predicted Aid If No Sanctions"
gen Differ_Div = realnat/NoSanctAid if US_Sanctions2==1
label var Differ_Div "Differential of Observed Aid v. Predicted Aid for U.S. Sanctions"

** Output for Table 3 **
sort Differ_Div
edit Differ_Div year recipientiso cowcode US_Sanctions2 UN_Sanct if US_Sanctions2==1

** Code for Creating Figure 1 **
keep if US_Sanctions2==1
collapse (mean)  NoSanctAid realnat, by(year)
sort year
label var  NoSanctAid "Prediction with No Sanctions"
label var realnat "Observed Aid Flows"
graph twoway line NoSanctAid year, clpattern(dash) clwidth(medthick) clcolor(grey) || line realnat year, clwidth(medthick) clpattern(solid) clcolor(black)  xtitle(" " "Year" " ", size(4)  ) ytitle("Constant Foreign Aid $", size(4))





********************************************************************
********************************************************************
****															****
****						Appendix Tables						****
****															****
********************************************************************
********************************************************************

use "Do Sanctions Always Stigmatize - Final.dta", clear

********************************** 
** Table A1: Summary Statistics **
**********************************
summ realnat  US_Sanctions2 TIES_US_Sanct TIES_US_TFA UN_Sanct  TIES_UNSanct    lnrgdppc  	lnrtradeopen polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted


********************************** 
** Table A2: Correlation Matrix **
**********************************
corr realnat  US_Sanctions2 TIES_US_Sanct TIES_US_TFA UN_Sanct  TIES_UNSanct    lnrgdppc  	lnrtradeopen polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted


**********************************************************************
** Table A3: U.S. Sanctions - Using Current Year Economic Variables **
**********************************************************************

**Model A1: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M1: xtpcse   nat US_Sanctions2 lngdppc  	lntradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) pairwis 

**Model A2: FGLS Regression and HSE Sanctions Variables**
eststo M2: xtgls    nat US_Sanctions2 lngdppc  	lntradeopen polity2 communist USAlly WesternColonizer   PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) force

**Model A3: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M3: xtpcse   nat TIES_US_Sanct 	lngdppc  	lntradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) pairwis 

**Model A4: FGLS Regression and TIES Sanctions Variables**
eststo M4: xtgls    nat TIES_US_Sanct 	lngdppc  	lntradeopen polity2 communist USAlly WesternColonizer   PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) force

**Model A5: Regression Using Panel Corrected Std. Errors and TIES Foreign Aid Sanctions Variables**
eststo M5: xtpcse   nat TIES_US_TFA 	lngdppc  	lntradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) pairwis 

**Model A6: FGLS Regression and TIES Foreign Aid Sanctions Variables**
eststo M6: xtgls    nat TIES_US_TFA 	lngdppc  	lntradeopen polity2 communist USAlly WesternColonizer   PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) force


**Output for Table A3**
esttab M1 M2 M3 M4 M5 M6, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)


********************************************************************
** Table A4: UN Sanctions - Using Current Year Economic Variables **
********************************************************************

**Model A7: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M7: xtpcse   nat  UN_Sanct 		lngdppc  lntradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) pairwis

**Model A8: FGLS Regression and HSE Sanctions Variables**
eststo M8: xtgls    nat  UN_Sanct 		lngdppc  lntradeopen polity2 communist USAlly WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) force

**Model A9: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M9: xtpcse   nat  TIES_UNSanct 	lngdppc  lntradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) pairwis

**Model A10: FGLS Regression and TIES Sanctions Variables**
eststo M10: xtgls    nat  TIES_UNSanct 	lngdppc  lntradeopen polity2 communist USAlly WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) force


**Output for Table A4**

esttab M7 M8 M9 M10, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)



**********************************************************************************
** Table A5: U.S. Sanctions - Using Constant Year Eonomic Variables and Net ODA **
**********************************************************************************

**Model A11: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M11: xtpcse    realnetoda US_Sanctions2   lnrgdppc  	lnrtradeopen polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A12: FGLS Regression and HSE Sanctions Variables**
eststo M12: xtgls     realnetoda US_Sanctions2   lnrgdppc  	lnrtradeopen polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model A13: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M13: xtpcse    realnetoda TIES_US_Sanct  	lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A14: FGLS Regression and TIES Sanctions Variables**
eststo M14: xtgls     realnetoda TIES_US_Sanct   lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model A15: Regression Using Panel Corrected Std. Errors and TIES Foreign Aid Sanctions Variables**
eststo M15: xtpcse    realnetoda TIES_US_TFA   	lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A16: FGLS Regression and TIES Foreign Aid Sanctions Variables**
eststo M16: xtgls     realnetoda TIES_US_TFA   	lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Output for Table A5**

esttab M11 M12 M13 M14 M15 M16, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)


********************************************************************************
** Table A6: UN Sanctions - Using Constant Year Eonomic Variables and Net ODA **
********************************************************************************

**Model A17: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M17: xtpcse    realnetoda UN_Sanct       lnrgdppc  lnrtradeopen  polity2 communist USAlly  WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A18: FGLS Regression and HSE Sanctions Variables**
eststo M18: xtgls     realnetoda UN_Sanct       lnrgdppc  lnrtradeopen polity2 communist USAlly  WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model A19: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M19: xtpcse    realnetoda  TIES_UNSanct  lnrgdppc lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A20: FGLS Regression and TIES Sanctions Variables**
eststo M20: xtgls    realnetoda  TIES_UNSanct  lnrgdppc lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Output for Table A6**
esttab M17 M18 M19 M20, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)


*********************************************************************************************************************************************
** Table A7: U.S. Sanctions - Using Constant Year Economic Variables and Only States That Were Sanctioned by the U.S. During Sample Period **
*********************************************************************************************************************************************

**Model A21: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M21: xtpcse   realnat US_Sanctions2   lnrgdppc  lnrtradeopen  polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if   sanctionedsample==1 , corr(psar1) pairwis

**Model A22: FGLS Regression and HSE Sanctions Variables**
eststo M22: xtgls    realnat US_Sanctions2   lnrgdppc  lnrtradeopen  polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if  sanctionedsample==1, corr(psar1) force

**Model A23: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M23: xtpcse   realnat TIES_US_Sanct  	lnrgdppc lnrtradeopen  polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if sanctionedsample==1, corr(psar1) pairwis

**Model A24: FGLS Regression and TIES Sanctions Variables**
eststo M24: xtgls    realnat TIES_US_Sanct  	lnrgdppc lnrtradeopen  polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if sanctionedsample==1, corr(psar1) force

**Model A25: Regression Using Panel Corrected Std. Errors and TIES Foreign Aid Sanctions Variables**
eststo M25: xtpcse   realnat TIES_US_TFA  	lnrgdppc lnrtradeopen  polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if sanctionedsample==1, corr(psar1) pairwis

**Model A26: FGLS Regression and TIES Foreign Aid Sanctions Variables**
eststo M26: xtgls    realnat TIES_US_TFA   	lnrgdppc lnrtradeopen  polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if sanctionedsample==1, corr(psar1) force

**Output for Table A7**

esttab M21 M22 M23 M24 M25 M26, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)



*****************************************************************************************************************************************
** Table A8: UN Sanctions - Using Constant Year Economic Variables and Only States That Were Sanctioned by the UN During Sample Period **
*****************************************************************************************************************************************


**Model A27: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M27: xtpcse    realnat UN_Sanct       lnrgdppc  lnrtradeopen  polity2 communist USAlly  WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted if sanctionedUNsample==1, corr(psar1) pairwis

**Model A28: FGLS Regression and HSE Sanctions Variables**
eststo M28: xtgls    realnat UN_Sanct       	lnrgdppc  lnrtradeopen polity2 communist USAlly  WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted if sanctionedUNsample==1, corr(psar1) force

**Model A29: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M29: xtpcse   realnat  TIES_UNSanct   lnrgdppc lnrtradeopen   polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if sanctionedUNsample==1, corr(psar1) pairwis

**Model A30: FGLS Regression and TIES Sanctions Variables**
eststo M30: xtgls    realnat  TIES_UNSanct  lnrgdppc lnrtradeopen  polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if sanctionedUNsample==1 , corr(psar1) force

**Output for Table A8**
esttab M27 M28 M29 M30, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)


*************************************************************************************************
** Table A9: Running TIES U.S. Sanctions Episodes Disaggregated by Minor and Substantial Costs **
*************************************************************************************************

**Model A31: Regression Using Panel Corrected Std. Errors, Constant Year Economic Variables, and TIES Minor and Substantial Costs Sanctions Variables**
eststo M31: xtpcse   realnat    	TIES_SevUSSanct TIES_MinUSSanct  lnrgdppc 	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A32: FGLS Regression Using Panel Corrected Std. Errors, Constant Year Economic Variables, and TIES Minor and Substantial Costs Sanctions Variables**
eststo M32: xtgls    realnat    	TIES_SevUSSanct TIES_MinUSSanct  lnrgdppc 	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model A33: Regression Using Panel Corrected Std. Errors, Current Year Economic Variables, and TIES Minor and Substantial Costs Sanctions Variables**
eststo M33: xtpcse   nat 		TIES_SevUSSanct TIES_MinUSSanct  lngdppc  	lntradeopen  polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) pairwis 

**Model A34: FGLS Regression Using Panel Corrected Std. Errors, Constant Year Economic Variables, and TIES Minor and Substantial Costs Sanctions Variables**
eststo M34: xtgls    nat 		TIES_SevUSSanct TIES_MinUSSanct  lngdppc  	lntradeopen  polity2 communist USAlly WesternColonizer   PostCW  IntraConflict InterConflict lnNDAfflicted, corr(psar1) force

**Output for Table A9**
esttab M31 M32 M33 M34, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)


**************************************************************************************
** Table 10: U.S. Sanctions - Using Constant Year Economic Variables and Lagged Term **
**************************************************************************************

**Model A35: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M35: xtpcse   realnat lagrealnat  US_Sanctions2  lnrgdppc lnrtradeopen polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A36: FGLS Regression and HSE Sanctions Variables**
eststo M36: xtgls    realnat lagrealnat 	US_Sanctions2  lnrgdppc lnrtradeopen polity2 communist USAlly  WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model A37: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M37: xtpcse   realnat lagrealnat 	TIES_US_Sanct  lnrgdppc lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A38: FGLS Regression and TIES Sanctions Variables**
eststo M38: xtgls    realnat lagrealnat 	TIES_US_Sanct  lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model A39: Regression Using Panel Corrected Std. Errors and TIES Foreign Aid Sanctions Variables**
eststo M39: xtpcse   realnat lagrealnat  TIES_US_TFA   lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A40: FGLS Regression and TIES Foreign Aid Sanctions Variables**
eststo M40: xtgls    realnat lagrealnat  TIES_US_TFA    lnrgdppc	lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Output for Table A10**
esttab M35 M36 M37 M38 M39 M40, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)



***************************************************************************************
** Table 11: UN Sanctions - Using Constant Year Economic Variables and a Lagged Term **
***************************************************************************************

**Model A41: Regression Using Panel Corrected Std. Errors and HSE Sanctions Variables**
eststo M41: xtpcse    realnat lagrealnat UN_Sanct       lnrgdppc lnrtradeopen polity2 communist USAlly  WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A42: FGLS Regression and HSE Sanctions Variables**
eststo M42: xtgls    realnat lagrealnat 	UN_Sanct       lnrgdppc lnrtradeopen polity2 communist USAlly  WesternColonizer PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Model A43: Regression Using Panel Corrected Std. Errors and TIES Sanctions Variables**
eststo M43: xtpcse   realnat lagrealnat 	TIES_UNSanct   lnrgdppc lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) pairwis

**Model A44: FGLS Regression and TIES Sanctions Variables**
eststo M44: xtgls    realnat lagrealnat TIES_UNSanct   lnrgdppc lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted , corr(psar1) force

**Output for Table 2**
esttab M41 M42 M43 M44, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)


************************************************************************************************************
** Table A12: Running the Model with Non-Sanctioned Observations - Using Constant Year Economic Variables **
************************************************************************************************************

eststo MX: xtpcse  realnat lnrgdppc lnrtradeopen polity2 communist USAlly WesternColonizer  PostCW  IntraConflict InterConflict lnNDAfflicted if US_Sanctions2==0, corr(psar1) pairwis 

** Output for Appendix Table A12**
esttab MX, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)



