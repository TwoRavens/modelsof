/* 						

						NO HARM IN CHECKING: 
USING FACTUAL MANIPULATION CHECKS TO ASSESS ATTENTIVENESS IN EXPERIMENTS

REPLICATION FILES

*List of Variables*

*Study 1:  Student Loans
	*Data = NoHarm_Study1_StudentLoans.dta
dv_S1_Loan = Dependent variable (support for loan forgiveness (higher=greater support))
mcpasser  = Dummy indicator for FMC (either TR or TI) incorrect(=0) or correct(=1)
Conditions_S1_Loans = Experimental conditions (4; labeled)

*Study 2: KKK Demonstration
	*Data = NoHarm_Study2_KKK.dta
dvSupportKKK = Dependent variable (support for allowing demonstration (higher=greater support))
PassMCframe = Dummy indicator for FMC (either TR or TI) incorrect(=0) or correct(=1)
Conditions_S2_KKK = Experimental conditions (6; labeled)
passcuesIMC = Dummy indicator for IMC incorrect(=0) or correct(=1)
answeredbothMCsKKK = Dummy indicator for respondents shown FMC and IMC (0=no;1=yes) 
passBothMCsKKK = Dummy indicator for FMC AND IMC passage (either/both incorrect(=0) or both correct(=1)

*Study 3: Combatting Disease
	*Data = NoHarm_Study3_Disease.dta
dv_S3_Disease = Dependent dummy variable (less risky option=0; riskier option=1)
Conditions_S3_Disease = Experimental conditions (4; labeled)
MCcorrect = Dummy indicator for FMC-TI incorrect(=0) or correct(=1)
IMCcorrect = Dummy indicator for IMC incorrect(=0) or correct(=1)
answeredbothMCsDisease = Dummy indicator for respondents shown FMC and IMC (0=no;1=yes) 
passBothMCsDisease = Dummy indicator for FMC AND IMC passage (either/both incorrect(=0) or both correct(=1)

*Study 4:  Support for Probation
	*Data = NoHarm_Study4a_Probation.dta
fmc_outcome = Dependent variable (support for probation (higher=stronger agreement))
FMCTR_ClosedCorrect = Dummy indicator for closed-ended FMC-TR incorrect(=0) or correct(=1)
FMCTI_ClosedCorrect = Dummy indicator for closed-ended FMC-TI incorrect(=0) or correct(=1)
IMC_S4_correct = Dummy indicator for IMC incorrect(=0) or correct(=1)
Conditions_S4_Probation = Experimental conditions (4; labeled) 
fmcTRo_correct = Dummy indicator for open-ended FMC-TR incorrect(=0) or correct(=1)
fmcTIo_correct = Dummy indicator for open-ended FMC-TI incorrect(=0) or correct(=1)
BothCorrectTR = Dummy indicator for FMC-TR AND IMC passage (either/both incorrect(=0) or both correct(=1) 
BothCorrectTI = Dummy indicator for FMC-TI AND IMC passage (either/both incorrect(=0) or both correct(=1)
fmcTRo_correctCoder1 = Coder 1 indicator for open-ended FMC-TR incorrect (0) or correct (1)
fmcTRo_correctCoder2 = Coder 2 indicator for open-ended FMC-TR incorrect (0) or correct (1)
fmcTIo_correctCoder1 = Coder 1 indicator for open-ended FMC-TI incorrect (0) or correct (1)
fmcTIo_correctCoder2 = Coder 2 indicator for open-ended FMC-TI incorrect (0) or correct (1)
	*Data = NoHarm_Study4b_Probation.dta
FMC_PlaceboGroups5 = Experimental conditions (5; labeled)
fmc_outcome_plac = fmc_outcome = Dependent variable (support for probation (higher=stronger agreement))
FMCTR_ClosedCorrect = Dummy indicator for closed-ended FMC-TR incorrect(=0) or correct(=1) 
FMCTI_ClosedCorrect = Dummy indicator for closed-ended FMC-TI incorrect(=0) or correct(=1)
FMCTRAfterOnly_placebo = Dummy indicating whether placebo did not (=0) or did appear(=1)between treatment and outcome (FMC-TR)
FMCTIAfterOnly_placebo2 =Dummy indicating whether placebo did not (=0) or did (=1) appear between treatment and outcome (FMC-TI)
FMCTIAfterOnly_placebo =Dummy indicating whether placebo did not (=0) or did (=1) appear between treatment and outcome (FMC-TI; treatment conditions only)

*Study 5:  Episodic vs. Thematic Framing
	*Data = NoHarm_Study5_Gross.dta
dvSymp_S5  = Sympathy felt (higher=more)
dvPity_S5 = Pity felt (higher=more)
MC_dv_combined = Combined measure of sympathy and pity
GrossStudyconditions = Experimental conditions (4; labeled)
TRcondition = Dummy indicator for FMC-TR condition (0=no, 1=yes)
TIcondition = Dummy indicator for FMC-TI condition (0=no, 1=yes)
TRMCcorrect = Dummy indicator for FMC-TR incorrect(=0) or correct(=1)
TIMCcorrect = Dummy indicator for FMC-TI incorrect(=0) or correct(=1)
IMCcorrect = Dummy indicator for IMC incorrect(=0) or correct(=1)
TRandIMCCorrect = Dummy indicator for FMC-TR AND IMC passage (either/both incorrect(=0) or both correct(=1) 
TIandIMCCorrect = Dummy indicator for FMC-TI AND IMC passage (either/both incorrect(=0) or both correct(=1)

*/

*Note:  All data sets saved as Stata version 12
clear 
version 12.1
*******************************************************************************
*******************************************************************************

*STUDY 1:  SUPPORT FOR STUDENT LOAN FORGIVENESS

*Data = NoHarm_Study1_StudentLoans.dta
use "NoHarm_Study1_StudentLoans.dta", clear

*EXPERIMENT: Regression Analyses 
reg dv_S1_Loan i.Conditions_S1_Loans // Control as reference group (reported in text & Appendix Table E1)
reg dv_S1_Loan b2.Conditions_S1_Loans // Treatment as reference group (referenced in text)

*DEPENDENT VARIABLE MEANS ACROSS CONDITIONS
mean dv_S1_Loan, over(Conditions_S1_Loans) // obtain means to input

*Figure 1, Left facet
	/*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */
	
input rcapGroupsS1 meanS1 lowS1 highS1 // input means and CIs from above
1. 5.292308   4.835949    5.748666
2. 4.552239   4.126652    4.977825
3. 4.538462   4.113066    4.963857
4. 4.630769   4.202116    5.059422
end

label define rcapGroupsS1 1 "Control" 2 "Treatment" 3 "Treat: TR Before" 4 "Treat: TI Before" 
label values rcapGroupsS1 rcapGroupsS1

ssc install revrs // Install "revrs" package
revrs rcapGroupsS1 // have to reverse order so that Control appears at top of y-axis

twoway rcap highS1 lowS1 revrcapGroupsS1, horizontal ///
msymbol(point) ylabel(, angle(horizontal) valuelabel labsize(small)) ///
xline(4.552239, lpattern(dash) lstyle(foreground)) ///
ylabel(1(1)4) ///
xlabel(3(.5)6) ///
scheme(s1mono) ///
ytitle("") ///
xtitle("Support for Student Loan Forgiveness", size(medium)) ///
graphregion(margin(medsmall)) ///
 legend(on order(1 "95% C.I." 2 "Mean")) ///
 || scatter revrcapGroupsS1 meanS1


*PASSAGE RATES BY CONDITION (0=fail; 1=pass)
	*Overall
tab mcpasser
proportion mcpasser, over(Conditions_S1_Loans) citype(normal) // obtain proportions(=1) and CIs to input
	*FMC-TR:  passage rates
proportion mcpasser if Conditions_S1_Loans==2 | Conditions_S1_Loans==3, over(Conditions_S1_Loans) citype(normal)
	*FMC-TI: passage rates
proportion mcpasser if Conditions_S1_Loans==1 | Conditions_S1_Loans==4, over(Conditions_S1_Loans) citype(normal)

*PLACEMENT (BEFORE OUTCOME VS. AFTER OUTCOME) DIFFERENCE-IN-PROPORTIONS TESTS (reported in text)
	*FMC-TR: diff= -.04 (p=.52)
prtest mcpasser if Conditions_S1_Loans==3 | Conditions_S1_Loans==2, ///
by(Conditions_S1_Loans)
	*FMC-TI: diff= +.03 (p=.72)
prtest mcpasser if Conditions_S1_Loans==4 | Conditions_S1_Loans==1, ///
by(Conditions_S1_Loans)


*Figure 1, Right Facet
/*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */

input rcapGroupsS1b proportionS1b lowS1b highS1b // input proportions(=1) and CIs from previous commands
1. .60        .4794181    .7205819
2. .8208955   .7279578    .9138332
3. .8615385   .7765268    .9465501
4. .5692308    .4473478    .6911138
end	
		
twoway rcap highS1b lowS1b rcapGroupsS1b, horizontal ///
msymbol(diamond) ylabel(, angle(forty_five) valuelabel labsize(small)) ///
ylabel(1(1)4) ///
xlabel(.2(.1)1) ///
scheme(s1mono) ///
ysc(reverse) ///
ytitle("") ///
xtitle("Proportion Passing Manipulation Check", size(medium)) ///
graphregion(margin(medsmall)) ///
 legend(on order(1 "FMC-TR" 2 "FMC-TI") col(2)) ///
 || scatter rcapGroupsS1b proportionS1b	

 
/* Summary:  Variability in proportion answering correctly (reported in text)
	FMC-TR:  .8208955 to .8615385 (range=.040643)
	FMC-TI: .5692308 to .60 (range =.0307692) */

*MEANS OF DV BY CONDITION AMONG MC PASSERS ONLY (Supplemental Appendix, Table F1)
	*Passed FMC
mean dv_S1_Loan if mcpasser==1, over(Conditions_S1_Loans)



*******************************************************************************
*******************************************************************************

*STUDY 2:  SUPPORT FOR KKK DEMONSTRATION
*Data = NoHarm_Study2_KKK.dta
use "NoHarm_Study2_KKK.dta", clear

*EXPERIMENT: Regression Analyses 
reg dvSupportKKK i.Conditions_S2_KKK // FS as reference group (ATE=-.86, p<.01; reported in text)
test 2.Conditions_S2_KKK=3.Conditions_S2_KKK // referenced in Supplemental Appendix Table E2
test 4.Conditions_S2_KKK=5.Conditions_S2_KKK=6.Conditions_S2_KKK // referenced in Supplemental Appendix Table E2

*DEPENDENT VARIABLE MEANS ACROSS CONDITIONS
mean dvSupportKKK, over(Conditions_S2_KKK) // obtain means/CIs to input for graph

*Figure 2, left facet
/*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */
input rcapGroupsS2a meanS2a lowS2a highS2a // input means and CIs from previous command

1.   
2.  3.611111   3.192702     4.02952
3. 
4. 
5.  3.208791   2.797493     3.62009
6. 
7. 
8.  3.37037    2.941481     3.79926
9. 
10.
11. 2.75       2.310831     3.189169
12. 
13. 
14. 2.673077   2.333083     3.013071
15. 
16. 
17. 3.030612   2.658605     3.40262
18.
end

// have to reverse order so that Control appears at top of y-axis
recode rcapGroupsS2a (2=17) (5=14) (8=11) (11=8) (14=5) (17=2),gen(rcapGroupsS2a_rev)

label define rcapGroupsS2a_rev 17 "Free Speech (FS)" 14 "FS: TR Before" 11 "FS: TI Before" ///
8 "Public Order (PO)" 5 "PO: TR Before" 2 "PO: TI Before"
label values rcapGroupsS2a_rev rcapGroupsS2a_rev

twoway rcap highS2a lowS2a rcapGroupsS2a_rev, horizontal ///
msymbol(point) ylabel(, angle(forty_five) valuelabel labsize(small)) ///
xline(2.75, lpattern(dash) lstyle(foreground)) ///
ylabel(1(1)18) ///
xlabel(2.3(.1)4.1) ///
scheme(s1mono) ///
ytitle("") ///
xtitle("Support for Allowing KKK Demonstration", size(medium)) ///
graphregion(margin(medsmall)) ///
 legend(on order(1 "Mean" 2 "95% C.I.")) ///
 || scatter rcapGroupsS2a_rev meanS2a


*Regression analyses:  FS vs. PO (FMC-TR)
reg dvSupportKKK i.Conditions_S2_KKK if Conditions_S2_KKK==2 | Conditions_S2_KKK==5 // (ATE=-.54, p=.05; reported in text)

*Regression analyses:  FS vs. PO (FMC-TI)
reg dvSupportKKK i.Conditions_S2_KKK if Conditions_S2_KKK==3 | Conditions_S2_KKK==6 // (ATE=-.34, p=.24; reported in text)
 
 
*PASSAGE RATES BY CONDITION (0=fail; 1=pass) // obtain proportions (=1) and CIs to input
	*FMC-TR
proportion PassMCframe if Conditions_S2_KKK==2 | Conditions_S2_KKK==5, over(Conditions_S2_KKK) citype(normal) 
	*FMC-TI
proportion PassMCframe if Conditions_S2_KKK==3 | Conditions_S2_KKK==6, over(Conditions_S2_KKK) citype(normal)
	*IMCs
proportion passcuesIMC, over(Conditions_S2_KKK) citype(normal)
	*Both FMC-TR & IMC  
proportion passBothMCsKKK if answeredbothMCsKKK==1 & Conditions_S2_KKK==2 | ///
answeredbothMCsKKK==1 & Conditions_S2_KKK==5, over(Conditions_S2_KKK) citype(normal)
	*Both FMC-TI & IMC 
proportion passBothMCsKKK if answeredbothMCsKKK==1 & Conditions_S2_KKK==3 | ///
answeredbothMCsKKK==1 & Conditions_S2_KKK==6, over(Conditions_S2_KKK) citype(normal)

*Figure 2, Right Facet
/*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */
input rcapGroupsS2b_rev proportionS2b lowS2b highS2b // input proportions and CIs from previous commands

1.  .6486486   .4872825    .8100148  
2.  .8378378   .7132454    .9624302  
3.  .8571429  .7866262    .9276595   
4.  .8333333   .7054486   .9612181   
5.  .8611111    .7424391   .9797832  
6.  .847619   .7777347    .9175034   
7. 
8.  .900  .7860631    1.013937      
9. 
10. .5757576   .397795    .7537202   
11. .7575758   .6032626    .9118889  
12. .8292683   .746083    .9124536   
13. .7567568   .6117343    .9017793  
14. .8648649   .7493082    .9804216  
15. .9010989   .8385827    .9636151  
16. 
17. .7647059   .6144759    .9149359  
18.
end

twoway rcap highS2b lowS2b rcapGroupsS2b_rev, horizontal ///
msymbol(point) ylabel(, angle(forty_five) valuelabel labsize(small)) ///
ylabel(1(1)18) ///
xlabel(.2(.1)1) ///
scheme(s1mono) ///
ytitle("") ///
xtitle("Proportion Passing Manipulation Check", size(medium)) ///
graphregion(margin(medsmall)) ///
 legend(on order(1 "FMC" 2 "IMC" 3 "FMC & IMC")  col(3)) ///
 || scatter rcapGroupsS2b_rev proportionS2b

*CORRELATION BETWEEN FMC AND IMC PASSAGE (reported in text)
	*FMC-TR and IMC
pwcorr PassMCframe passcuesIMC if Conditions_S2_KKK==2 | Conditions_S2_KKK==5, /// 
sig obs // r=.34 (p=.004)
	*FMC-TI and IMC
pwcorr PassMCframe passcuesIMC if Conditions_S2_KKK==3 | Conditions_S2_KKK==6, /// 
sig obs // r=.18 (p=.14)

	*Cross-tab of overall relationship between FMC and IMC passage (reported in text)
tab PassMCframe passcuesIMC, column

/* Summary:  Variability in proportion answering correctly (reported in text)
	IMC:  .7575758 to .900 (range= .1424242)
	FMC-TR:  .847619 to .9010989 (range=.0534799)
	FMC-TI: .8292683 to .8571429 (range=.0278746) */

	
*MEANS OF DV BY CONDITION AMONG MC PASSERS ONLY (Supplemental Appendix F)
	*Passed FMC
mean dvSupportKKK if PassMCframe==1, over(Conditions_S2_KKK)
	*Passed IMC
mean dvSupportKKK if passcuesIMC==1, over(Conditions_S2_KKK)
	*Passed FMC & IMC
mean dvSupportKKK if PassMCframe==1 & passcuesIMC==1, over(Conditions_S2_KKK)


*DID ANALYSES AMONG MC PASSERS ONLY (Supplemental Appendix F)
*Difference in differences TR conditions (whole sample compared to "FMC passers only" analyses in supplemental appendix)
ttest dvSupportKKK if Conditions_S2_KKK==2 | Conditions_S2_KKK==5, by(Conditions_S2_KKK)  // diff for all= .5357 
ttest dvSupportKKK if PassMCframe==1 & Conditions_S2_KKK==2 | PassMCframe==1 & Conditions_S2_KKK==5, by(Conditions_S2_KKK) // diff for passers=.697 
ttesti 195 .5357143 1.891171 170 .6978936 1.928779 // DID analysis, non-significant
	
*Difference in differences TR (whole sample compared to "FMC & IMC passers only" analyses in supplemental appendix)
ttest dvSupportKKK if Conditions_S2_KKK==2 | Conditions_S2_KKK==5, by(Conditions_S2_KKK)  // all
ttest dvSupportKKK if PassMCframe==1 & Conditions_S2_KKK==2 & passcuesIMC==1 | PassMCframe==1 & Conditions_S2_KKK==5 & passcuesIMC==1, by(Conditions_S2_KKK) // passers
ttesti 195 .5357143 1.891171 58 .6738095 1.699436 // DID analysis, non-significant 

*Difference in differences TI conditions (whole sample compared to "FMC passers only" analyses in supplemental appendix)
ttest dvSupportKKK if Conditions_S2_KKK==3 | Conditions_S2_KKK==6, by(Conditions_S2_KKK)  // all
ttest dvSupportKKK if PassMCframe==1 & Conditions_S2_KKK==3 | PassMCframe==1 & Conditions_S2_KKK==6, by(Conditions_S2_KKK) // passers
ttesti 179 .3397581 1.918151 151 .4124023 1.924881  // DID analysis, non-significant 
	
*Difference in differences TI (whole sample compared to "FMC & IMC passers only" analyses in supplemental appendix)
ttest dvSupportKKK if Conditions_S2_KKK==3 | Conditions_S2_KKK==6, by(Conditions_S2_KKK)  // diff for all= -.597
ttest dvSupportKKK if PassMCframe==1 & Conditions_S2_KKK==3 & passcuesIMC==1 | PassMCframe==1 & Conditions_S2_KKK==6 & passcuesIMC==1, by(Conditions_S2_KKK) // passers
ttesti 179 .3397581 1.918151 42 -.5972222 1.928001  // DID analysis, significant difference in differences (p<.01)


*******************************************************************************
*******************************************************************************

*STUDY 3:  COMBATTING DISEASE

*Data = NoHarm_Study3_Disease.dta
use "NoHarm_Study3_Disease.dta", clear

*EXPERIMENT:  Regression results  
reg dv_S3_Disease i.Conditions_S3_Disease // Saved as excluded group (ATE=.26, p<.01; see text and Table E3 in Supp. Appendix)
reg dv_S3_Disease b3.Conditions_S3_Disease // Die as excluded group 

	*Tests of differences in proportions selecting riskier option (=1)
		
		*DIE vs. DIE-TI (reported in text; diff=.08, p=.23)
	prtest dv_S3_Disease if Conditions_S3_Disease==3 | Conditions_S3_Disease==4, by(Conditions_S3_Disease) 
		
		*SAVED vs. SAVED-TI (reported in text; diff=.02, p=.75)
	prtest dv_S3_Disease if Conditions_S3_Disease==1 | Conditions_S3_Disease==2, by(Conditions_S3_Disease)
	
		*Difference-in-Differences [(Saved vs. Die) - (Saved-TI vs. Die-TI)]
			*Reported in text
	prtest dv_S3_Disease if Conditions_S3_Disease==1 | ///
	Conditions_S3_Disease==3, by(Conditions_S3_Disease) // Saved vs. Die (diff=.26)
	
	prtest dv_S3_Disease if Conditions_S3_Disease==2 | ///
	Conditions_S3_Disease==4, by(Conditions_S3_Disease) // Saved-TI vs. Die-TI (diff=.32)
	
	prtesti 325 .2612664 159 .3209877 // |DID|= .06 (p=.17)
	

*PROPORTIONS SELECTING RISKIER OPTION (=1) ACROSS CONDITIONS
proportion dv_S3_Disease, over(Conditions_S3_Disease) citype(normal) // note: DV is dichotomous

	
*Figure 3, Left Facet
/*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */
input rcapGroupsS3 meanS3 lowS3 highS3 // input proportions(=1) and CIs from previous command
1.
2. .3251534   .2528386    .3974681
3.
4.
5. .345679   .2412011     .450157
6.
7.
8. .5864198   .5101576    .6626819
9.
10.
11 .6666667   .5611099    .7722234
12. 
end

label define rcapGroupsS3 2 "Saved"  5 "Saved-TI " 8 "Die" 11 "Die-TI" 
label values rcapGroupsS3 rcapGroupsS3

twoway rcap highS3 lowS3 rcapGroupsS3, horizontal ///
msymbol(point) ylabel(, angle(forty_five) valuelabel labsize(small)) ///
ysc(reverse) ///
xline(.5864198, lpattern(dash) lstyle(foreground)) ///
ylabel(1(1)12) ///
xlabel(.2(.1).8) ///
scheme(s1mono) ///
ytitle("") ///
xtitle("Proportion Selecting Riskier Option", size(medium)) ///
graphregion(margin(medsmall)) ///
 legend(on order(1 "Proportion" 2 "95% C.I.")) ///
 || scatter rcapGroupsS3 meanS3



*PASSAGE RATES BY CONDITION (0=fail; 1=pass)
	*FMC-TI
proportion MCcorrect, over(Conditions_S3_Disease) citype(normal) // obtain proportions/CIs to input
	*IMCs
tab IMCcorrect // overall IMC passage rate (90.67%; reported in text))
proportion IMCcorrect, over(Conditions_S3_Disease) citype(normal) // obtain proportions/CIs to input
	*Both FMC-TI and IMC
proportion passBothMCsDisease if answeredbothMCsDisease==1, over(Conditions_S3_Disease) citype(normal) // obtain proportions/CIs to input
	
*PLACEMENT (BEFORE OUTCOME VS. AFTER OUTCOME) TESTS (reported in text) 
	*Saved vs. Saved-TI
prtest MCcorrect if Conditions_S3_Disease==1 | Conditions_S3_Disease==2, ///
by(Conditions_S3_Disease) // diff=+.05 (p=.47)
	*Die vs. Die-TI
prtest MCcorrect if Conditions_S3_Disease==3 | Conditions_S3_Disease==4, ///
by(Conditions_S3_Disease) // diff=+.11 (p=.17)
		
*Figure 3, Right Facet
/*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */
input rcapGroupsS3b_rev proportionS3b lowS3b highS3b // input proportions(=1) and CIs from previous commands 

1. .6829268   .5812065    .7846472  	
2. .8676471   .7859897    .9493044  	
3. .6363636   .4680635    .8046637	 	
4. .6296296   .5234114    .7358479  	
5. .8275862   .6867845    .9683879  	
6. .5517241   .3657178    .7377305	 	
7. .6707317   .5680033    .7734601  	
8. .953125    .9005996     1.00565  	
9. .71875     .5589314    .8785686	 	
10. .5641026   .4530666    .6751385	 	
11. .96875     .9071126    1.030387  	
12. .59375   .419765     .767735	 	
end


twoway rcap highS3b lowS3b rcapGroupsS3b_rev, horizontal ///
msymbol(point) ylabel(, angle(forty_five) valuelabel labsize(small)) ///
ylabel(1(1)12) ///
xlabel(.2(.1)1) ///
scheme(s1mono) ///
ysc(reverse) ///
ytitle("") ///
xtitle("Proportion Passing Manipulation Check", size(medium)) ///
graphregion(margin(medsmall)) ///
 legend(on order(1 "FMC" 2 "IMC" 3 "FMC & IMC") col(3)) ///
 || scatter rcapGroupsS3b proportionS3b

 
*CORRELATION BETWEEN FMC AND IMC PASSAGE (reported in text)
pwcorr MCcorrect IMCcorrect, sig // r=.14 (p=.12)

/* Summary:  Variability in proportion answering correctly (reported in text)
	IMC:  .8275862 to .96875 (range=.1411638)
	FMC-TI:  .5641026 to .6829268 (range=.1188242) */


*PROPORTIONS SELECTING RISKIER OPTION BY CONDITION AMONG MC PASSERS ONLY (Supplemental Appendix, TABLE F1)
	*Passed FMC
proportion dv_S3_Disease if MCcorrect==1, over(Conditions_S3_Disease)
	*Passed IMC
proportion dv_S3_Disease if IMCcorrect==1, over(Conditions_S3_Disease)
	*Passed FMC & IMC
proportion dv_S3_Disease if MCcorrect==1 & IMCcorrect==1, over(Conditions_S3_Disease)

*DID ANALYSES AMONG MC PASSERS ONLY (Supplemental Appendix F)
	*FMC passers
prtest dv_S3_Disease if MCcorrect==1 & Conditions_S3_Disease==1 | MCcorrect==1 & Conditions_S3_Disease==3 , by(Conditions_S3_Disease) // 111 obs, (absolute) diff~ .21
prtest dv_S3_Disease if MCcorrect==1 & Conditions_S3_Disease==2 | MCcorrect==1 & Conditions_S3_Disease==4 , by(Conditions_S3_Disease) // 95 obs, (absolute) diff~ .42
prtesti 111 .2061688 95 .4206774  // significant difference (~.21, p<.001)

	*IMC passers
prtest dv_S3_Disease if IMCcorrect==1 & Conditions_S3_Disease==1 | IMCcorrect==1 & Conditions_S3_Disease==3 , by(Conditions_S3_Disease) // 120 obs, (absolute) diff~ .35
prtest dv_S3_Disease if IMCcorrect==1 & Conditions_S3_Disease==2 | IMCcorrect==1 & Conditions_S3_Disease==4 , by(Conditions_S3_Disease) // 55 obs, (absolute) diff~ .34
prtesti 120 .3523201 55 .344086 // no significant difference (~.01, p=.90)

*FMC AND IMC passers
prtest dv_S3_Disease if MCcorrect==1 & IMCcorrect==1 & Conditions_S3_Disease==1 | MCcorrect==1 & IMCcorrect==1 & Conditions_S3_Disease==3 , by(Conditions_S3_Disease) // 44 obs, (absolute) diff~ .33
prtest dv_S3_Disease if MCcorrect==1 & IMCcorrect==1 & Conditions_S3_Disease==2 | MCcorrect==1 & IMCcorrect==1 & Conditions_S3_Disease==4 , by(Conditions_S3_Disease) // 35 obs, (absolute) diff~ .45
prtesti 44 .378882 35 .4539474 // no significant difference (~.08, p=.50)


*******************************************************************************
*******************************************************************************

*STUDY 4:  SUPPORT FOR PROBATION

*Data = NoHarm_Study4a_Probation.dta
use "NoHarm_Study4a_Probation.dta", clear

*EXPERIMENT: Regression Analyses 
reg fmc_outcome i.Conditions_S4_Probation // Control as excluded group (discussed in text and Appendix Table E4)
test 2.Conditions_S4_Probation=3.Conditions_S4_Probation=4.Conditions_S4_Probation // Wald test (p=.34) referenced in text
reg fmc_outcome b2.Conditions_S4_Probation // Treatment as excluded group 

*DEPENDENT VARIABLE MEANS ACROSS CONDITIONS
mean fmc_outcome, over(Conditions_S4_Probation) // obtain means/CIs to input for graph


*Figure 4, Left Facet
/*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */
input rcapgroupS4 meanS4 lowS4 highS4

1. 	
2.
3.	3.573964   3.481602    3.666327
4.
5.
6. 	
7. 
8.	3.808383   3.676568    3.940198
9.
10.
11. 
12.	3.963855   3.777219    4.150491
13.
14. 
15. 3.923754   3.749652    4.097856
16.
end  

label define rcapgroupS4 3 "Control"  ///
8 "Treat(TR/TI after)" 12 "Treat(TR before)" 15 "Treat(TI before)"
label values rcapgroupS4 rcapgroupS4

twoway rcap highS4 lowS4 rcapgroupS4, horizontal ///
msymbol(circle) ylabel(, angle(forty_five) valuelabel labsize(small)) ///
xline(3.808383, lpattern(dash) lstyle(foreground)) ///
ylabel(1(1)16) ///
ysc(reverse) ///
xlabel(3.2(.2)4.4) ///
scheme(s1mono) ///
ytitle("") ///
xtitle("Support for Probation", size(medium)) ///
graphregion(margin(medsmall)) ///
 legend(on order(1 "95% C.I." 2 "Mean")) ///
 || scatter rcapgroupS4 meanS4


*PASSAGE RATES BY CONDITION (0=fail; 1=pass) 
	*FMC-TR
proportion FMCTR_ClosedCorrect, over(Conditions_S4_Probation) citype(normal)
	*FMC-TI
proportion FMCTI_ClosedCorrect, over(Conditions_S4_Probation) citype(normal)
	*IMC
proportion IMC_S4_correct, over(Conditions_S4_Probation) citype(normal)
	*Both FMC-TR and IMC
proportion BothCorrectTR, over(Conditions_S4_Probation) citype(normal)
	*Both FMC-TI and IMC
proportion BothCorrectTI, over(Conditions_S4_Probation) citype(normal)
		
*Figure 4, Right Facet
/*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */

input rcapGroups4b proportionS4b lowS4b highS4b

1. .209713   .1721316    .2472944
2. .6391982   .5946691    .6837273
3. .3683432   .3426107    .3940757
4. .0728477   .0488565    .0968388
5. .3363029   .2924961    .3801097
6. .2850679  .2253324    .3448033
7. .8533333   .8069426    .8997241
8. .4026946   .3654583    .4399309
9. .1357466   .0904244    .1810688
10. .3777778   .3142011    .4413544
11. .2954545  .2349463    .3559628
12. .3644578   .3125868    .4163289
13. .0909091   .052783    .1290352
14. .8086957   .7576842    .8597071
15. .3665689   .3153263    .4178115
16. .3608696   .2985847    .4231545
end	
	

twoway rcap highS4b lowS4b rcapGroups4b, horizontal ///
msymbol(diamond) ylabel(, angle(horizontal) valuelabel labsize(small)) ///
ylabel(1(1)16) ///
xlabel(0(.1)1) ///
scheme(s1mono) ///
ysc(reverse) ///
ytitle("") ///
xtitle("Proportion Passing Manipulation Check", size(medium)) ///
graphregion(margin(medsmall)) ///
legend(on order(1 "FMC-TR" 2 "FMC-TI" 3 "IMC" 4 "FMC-TR_IMC" 5 "FMC-TI_IMC") col(3)) ///
 || scatter rcapGroups4b proportionS4b	


*PLACEMENT (BEFORE OUTCOME VS. AFTER OUTCOME) TESTS (referenced in text)  
*Note: Restricted to treatment conditions (i.e., conditions 2 and 3) only for both FMC-TR and FMC-TI
	
	*FMC-TR (closed-ended) Before vs. After: diff= -.01, p=.81
prtest FMCTR_ClosedCorrect if Conditions_S4_Probation==3 | ///
Conditions_S4_Probation==2, by(Conditions_S4_Probation)
	**FMC-TR (open-ended) Before vs. After: diff= +.07, p=.15
prtest fmcTRo_correct if Conditions_S4_Probation==3 | ///
Conditions_S4_Probation==2, by(Conditions_S4_Probation)
	*FMC-TI (closed-ended) Before vs. After: diff=+.04, p=.20
prtest FMCTI_ClosedCorrect if Conditions_S4_Probation==4 | ///
Conditions_S4_Probation==2, by(Conditions_S4_Probation)
	**FMC-TI (open-ended) Before vs. After: diff=+.04, p=.20
prtest fmcTIo_correct if Conditions_S4_Probation==4 | ///
Conditions_S4_Probation==2, by(Conditions_S4_Probation)


*CORRELATION BETWEEN FMC AND IMC PASSAGE (reported in text and Appendix G)
	*FMC-TR (closed-ended) and IMC
pwcorr IMC_S4_correct FMCTR_ClosedCorrect if Conditions_S4_Probation==3 | ///
Conditions_S4_Probation==2, sig obs // r=.02 (p=.60)
	*FMC-TI (closed-ended) and IMC
pwcorr IMC_S4_correct FMCTI_ClosedCorrect, sig obs // r=.30 (p<.001)
	*FMC-TR (open-ended) and IMC
pwcorr IMC_S4_correct fmcTRo_correct if Conditions_S4_Probation==3 | ///
Conditions_S4_Probation==2, sig obs // r=.04 (p=.57)
	*FMC-TI (open-ended) and IMC
pwcorr IMC_S4_correct fmcTIo_correct, sig obs // r=.24 (p<.001)

*Cross-tabs for FMC-TR (control condition) and IMC passage (referenced in text)
tab IMC_S4_correct FMCTR_ClosedCorrect if Conditions_S4_Probation==2 | Conditions_S4_Probation==3, column // 60.94% who answered FMC-TR correct got IMC wrong 
tab IMC_S4_correct FMCTR_ClosedCorrect if Conditions_S4_Probation==2 | Conditions_S4_Probation==3, row // 69.51% who answered IMC correct got IMC2 wrong 

*INTER-CODER AGREEMENT FOR OPEN-ENDED FMCs (agreement exceeds 99%; reported in text)
kap fmcTRo_correctCoder1 fmcTRo_correctCoder2 // FMC-TR
kap fmcTIo_correctCoder1 fmcTIo_correctCoder2 // FMC-TI

/* Summary:  Variability in proportion answering correctly (reported in text)
	IMC:  .3644578 to .4026946 (range=.0382368)
	FMC-TR (treatment conditions only):  .2850679 to .2954545 (range=.0103866)
	FMC-TI: .6391982 to .8533333 (range=.2141351) */


*MEANS OF DV BY CONDITION AMONG MC PASSERS ONLY (Supplemental Appendix)
	*Passed FMC
mean fmc_outcome if FMCTR_ClosedCorrect==1 | FMCTI_ClosedCorrect==1 | ///
fmcTRo_correct==1 | fmcTIo_correct==1, over(Conditions_S4_Probation)
	*Passed IMC
mean fmc_outcome if IMC_S4_correct==1, over(Conditions_S4_Probation)
	*Passed FMC & IMC
mean fmc_outcome if IMC_S4_correct==1 & FMCTR_ClosedCorrect==1 | ///
	IMC_S4_correct==1 & FMCTI_ClosedCorrect==1 | ///
	IMC_S4_correct==1 & fmcTRo_correct==1 | ///
	IMC_S4_correct==1 & fmcTIo_correct==1, over(Conditions_S4_Probation)


*PLACEBO ANALYSES (SUPPLEMENTAL APPENDIX H)
*Data = NoHarm_Study4b_Probation.dta
use "NoHarm_Study4b_Probation.dta", clear

	*Effects of placebo on outcome
reg fmc_outcome_plac b2.FMC_PlaceboGroups5  // Table H1
test 3.FMC_PlaceboGroups5=4.FMC_PlaceboGroups5=5.FMC_PlaceboGroups5 // Wald test

	*Effects of placebo on passage rates (Appendix H)
prtest FMCTR_ClosedCorrect, by (FMCTRAfterOnly_placebo) // FMC-TR; non-significant (p=.78)
prtest FMCTI_ClosedCorrect, by (FMCTIAfterOnly_placebo2) // FMC-TI; non-significant (p=.44)
prtest FMCTI_ClosedCorrect, by (FMCTIAfterOnly_placebo) // FMC-TI (Treatment conditions only) (p=.67)


	
********************************************************************************
********************************************************************************

*STUDY 5:  THEMATIC VS. EPISODIC FRAMING (see APPENDIX K)

*Data = NoHarm_Study5_Gross.dta
use "NoHarm_Study5_Gross.dta", clear

pwcorr dvSymp_S5 dvPity_S5, sig obs // correlation between two outcome measures (.73, p<.001)

*Experimental Results: Regression Analyses
reg MC_dv_combined i.GrossStudyconditions // control is excluded category

*Means and 95% CIs across conditions
mean MC_dv_combined, over(GrossStudyconditions)


***FIGURE K1 (LEFT FACET)
/*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */

input rcapgroup_gross2 mean_gross2 low_gross2 high_gross2 // input means and CIs

1. 
2. .5383772   .4894849    .5872694
3.
4.
5. .5326577   .4816001    .5837152
6.
7.
8. .5721983   .5232179    .6211786
9.
10.
11. .5860849   .5391234    .6330464
12.
end  

label define rcapgroup_gross2 2 "CONTROL"  ///
5 "TREAT" 8 "TREAT-TR" 11 "TREAT-TI"
label values rcapgroup_gross2 rcapgroup_gross2

twoway rcap high_gross2 low_gross2 rcapgroup_gross2, horizontal ///
msymbol(circle) ylabel(, angle(horizontal) valuelabel labsize(small)) ///
xline(.5326577, lpattern(dash) lstyle(foreground)) ///
ylabel(1(1)12) ///
ysc(reverse) ///
xlabel(.2(.1).8) ///
scheme(s1mono) ///
ytitle("") ///
xtitle("Reported Amount of Pity/Sympathy Felt", size(medium)) ///
graphregion(margin(medsmall)) ///
 legend(on order(1 "95% C.I." 2 "Mean")) ///
 || scatter rcapgroup_gross2 mean_gross2
 
 
**PASSAGE RATES (0=fail; 1=pass)
	*Overall
proportion TRMCcorrect //  64.31% answered FMC-TR correctly
proportion TIMCcorrect // 79.54% answered FMC-TI correctly

	*FMC-TR correct by condition
proportion TRMCcorrect, over(GrossStudyconditions) citype(normal) // proportions/CIs to input
*TR before
.6293103   .5405603    .7180604
*TR after (treatment)
.6576577   .5685092    .7468061

	*FMC-TI correct by condition
proportion TIMCcorrect, over(GrossStudyconditions) citype(normal) // proportions/CIs to input
*TI Before
.7924528   .7144509    .8704547
*TI after (control)
.7982456   .7238418    .8726494

	*IMC correct by condition
proportion IMCcorrect, over(GrossStudyconditions) citype(normal) // proportions/CIs to input

Control |   .6403509   .5516276    .7290741
Treatment | .5225225   .4289258    .6161193
TR before | .5862069   .4959467    .6764671
TI After |  .5754717   .4806738    .6702696

	*FMC-TR and IMC correct by condition
proportion TRandIMCCorrect, over(GrossStudyconditions) citype(normal) // proportions/CIs to input
   TR after  |   .3873874   .2958604    .4789144
   TR before |   .4310345   .3400369    .5220321
   
   *FMC-TI and IMC correct by condition
proportion TIandIMCCorrect, over(GrossStudyconditions) citype(normal) // proportions/CIs to input
     TI After  |   .5350877   .442615    .6275604
     TI before |   .490566   .3944153    .5867168


 *Figure K1 (RIGHT FACET)
 /*Note:  The following code produces the basic graph, but "Graph Editor" was 
	used to improve the presentation  */
 
 input rcapgroup_grossPass prop_grossPass low_grossPass high_grossPass // input proportions(=1) and CIs from above
 
1. .6403509   .5516276    .7290741
2. .7982456   .7238418    .8726494
3. .5350877   .442615    .6275604
4. .5225225   .4289258    .6161193
5. .6576577   .5685092    .7468061
6. .3873874   .2958604    .4789144
7. .5862069   .4959467    .6764671
8. .6293103   .5405603    .7180604
9. .4310345   .3400369    .5220321
10. .5754717  .4806738    .6702696
11. .7924528  .7144509    .8704547
12. .490566   .3944153    .5867168
end
   
twoway rcap high_grossPass low_grossPass rcapgroup_grossPass, horizontal ///
msymbol(diamond) ylabel(, angle(horizontal) valuelabel labsize(small)) ///
ylabel(1(1)12) ///
xlabel(.2(.1)1) ///
scheme(s1mono) ///
ysc(reverse) ///
ytitle("") ///
xtitle("Proportion Passing Manipulation Check", size(medium)) ///
graphregion(margin(medsmall)) ///
legend(on order(1 "FMC-TR" 2 "FMC-TI" 3 "IMC" 4 "FMC-TR_IMC" 5 "FMC-TI_IMC") col(3)) ///
 || scatter rcapgroup_grossPass prop_grossPass	


*CORRELATIONS BETWEEN IMC AND FMC PASSAGE (reported in text of manuscript)
pwcorr  IMCcorrect TRMCcorrect, sig obs // .22, p<.001
pwcorr  IMCcorrect TIMCcorrect, sig obs // .15, p<.05
 
/* Summary:  Variability in proportion answering correctly (reported in text and Appendix K)
		IMC:  .5225225 to .6403509 (range=.1178284)
		FMC-TR: .6293103 to .6576577 (range=.0283474)
		FMC-TI:  .7924528 to .7982456 (range=.0057928) */
		

********************************************************************************

/*SUMMARY (ALL STUDIES):  AVERAGE RANGE IN PROPORTION ANSWERING EACH TYPE OF MC CORRECTLY 
	*Reported in text of manuscript ("Summary of Empirical Results" section)

	1. IMC: di(.1424242+.1411638+.0382368+.1178284)/4 
		.1099133

	2. FMC-TR: di(.040643+.0534799+.0103866+.0283474)/4
		.03321423

	3. FMC-TI:  di(.0307692+.0278746+.1188242+.2141351+.0057928)/5
		.07947918
*/


********************************************************************************
********************************************************************************

*CONTENT ANALYSES (Appendix A)

*Data = "NoHarm_ContentAnalysis_Articles.dta"
use "NoHarm_ContentAnalysis_Articles.dta", clear

/* Variables:
ARTICLESAuthorNamesLastn // Article name
Yearofpublication // year of publication
APSR // 1=published in American Political Science Review
AJPS  // 1=published in American Journal of Political Science
JOP // 1=published in Journal of Politics
POQ // 1=published in Public Opinion Quarterly
POLCOMM // 1=published in Political Communication
POLPSYCH // 1=published in Political Psychology
MCIMCScreenerAttentionCheck // Manipulation Check mentioned
PgNumberifmentioned // page number(s) on which MC is mentioned
FieldExperimentOnly1Yes // 1=study’s experiment was a field experiment
NaturalExperimentonlyYes1 // 1= study’s experiment was a natural experiment
FactualMC // 1=Factual MC
SubjectiveMC // 1=Subjective MC
InstructionalMC // 1=Instructional MC
OtherMC // 1=Other type of MC
TypeCantBeDetermined // 1=Type cannot be determined (insufficient information provided)
Coder1_coding // MC type codings (Coder 1)
Coder2_coding // MC type codings (Coder 2)
MCtype  // categorical variable indicating type of MC
MCtype2 // recoded version of MCtype (different ordering)
*/

*Overall frequency of reporting MCs
tab MCIMCScreenerAttentionCheck // 62 articles out of 338 feature a manipulation check
proportion MCIMCScreenerAttentionCheck // proportion of articles featuring a manipulation check (18.34%)

*Types of MCs identified
	*Subjective
tab SubjectiveMC // 36 out of 62 articles feature an SMC
di 36/62 // 58.06%

	*Factual
tab FactualMC // 13 out of 62 articles feature an FMC
di 13/62 // 20.96% (21%)

	*Instructional
tab InstructionalMC // 6 out of 62 articles feature an IMC
di 6/62 // 9.68%

	*Other
tab OtherMC // 2 out of 62 articles feature another type of MC (though arguably FMC-TI)
di 2/62 // 3.22%

	*Undetermined
tab TypeCantBeDetermined // 7 out of 62 articles feature an MC that cannot be determined
di 7/62 // 11.29%

*Figure A1
graph bar, over(MCtype2,  label(labcolor(black) labsize(medium))) bar(1, fcolor(black)) ///
ytitle(Percent of Articles, size(medlarge)) scheme(s1mono) ///
ylabel(0(10)60, labsize(medsmall)) ///
graphregion(margin(medsmall))

*Inter-coder reliability (coding types of MCs)
kap Coder1_coding Coder2_coding // 85.94% agreement; kappa=.77 (p<.001)


*ANALYSES OF SUPPLEMENTAL APPENDICES (see footnote #6 in Supplemental Appendix)

*Data = "NoHarm_ContentAnalysis_Supplemental Appendices.dta"
use "NoHarm_ContentAnalysis_Supplemental Appendices.dta", clear

/* Variables
ARTICLESAuthorNamesLastn // Article name
Yearofpublication // year of publication
APSR // 1=published in American Political Science Review
AJPS  // 1=published in American Journal of Political Science
JOP // 1=published in Journal of Politics
POQ // 1=published in Public Opinion Quarterly
POLCOMM // 1=published in Political Communication
POLPSYCH // 1=published in Political Psychology
SuppAppendAvail // Supplemental Appendix was available for article
CheckInSuppAppend // MC featured in Supplemental Appendix (if Appendix was available)
*/


tab SuppAppendAvail // 30 out of 81 randomly selected articles had a supplemental appendix available
tab CheckInSuppAppend if SuppAppendAvail==1 // 1 out of these 30 articles discussed a manipulation check

********************************************************************************
