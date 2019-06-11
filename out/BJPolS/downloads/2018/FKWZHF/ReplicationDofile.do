/*-----------------------------------------------------------------
Replication do-file for article entitled "The Role of Evidence in Politics: Motivated Reasoning and Persuasion among Politicians"

Authors: Martin Baekgaard, Julian Christensen, Casper Mondrup Dahlmann, Asbjørn Mathiasen, and Niels Bjørn Grund Petersen, Aarhus University
-----------------------------------------------------------------*/

use "ReplicationData1.dta", clear

/***NOTE TO READER***

Replication data1 includes the following variables for both politicians and citizens:

- A dummy variable called "politician" where citizens score 0 and politicians score 1
- Prior item 1 called "prior1" (for question wording, see footnote 26)
- Prior item 2 called "prior2" (for question wording, see footnote 26)
- Prior item 3 called "prior3" (for question wording, see footnote 26)
- Treatment dummy for experiment 1 (the school experiment) called "sectorvisible_schools" where respondents score 0 if they are in the placebo groups (who evaluate "School A" against "School B") and 1 if they are in the treatment groups (who evaluate a "public school" against a "private school")
- A dummy variable called "public_a_best_schools" where respondents score 0 if they are in experiment 1's treatment group 1 (where the private school performs best) or placebo group 1 (where School B performs best) whereas they score 1 if they are in experiment 1's treatment group 2 (where the public school performs best) or placebo group 2 (where School A performs best)
- Treatment dummy for experiment 2 (the road experiment) called "sectorvisible_roads" where respondents score 0 if they are in the placebo groups (who evaluate "Supplier A" against "Supplier B") and 1 if they are in the treatment groups (who evaluate a "public supplier" against a "private supplier")
- A dummy variable called "public_a_best_roads" where respondents score 0 if they are in experiment 2's treatment group 1 (where the private supplier performs best) or placebo group 1 (where Supplier B performs best) whereas they score 1 if they are in experiment 2's treatment group 2 (where the public supplier performs best) or placebo group 2 (where Supplier A performs best)
- A dummy variable called "public_best_rehabilitation" where respondents score 0 if they have seen the private provider of rehabilitation perform best in experiment 3 whereas they score 1 if they have seen the public provider perform best in the experiment
- A dummy variable called "infoload_3" where respondents score 0 if they have been asked to evaluate one or five lines of information in experiment 3 whereas they score 1 if they have been asked to evaluate three lines of information in the experiment
- A dummy variable called "infoload_5" where respondents score 0 if they have been asked to evaluate one or three lines of information in experiment 3 whereas they score 1 if they have been asked to evaluate five lines of information in the experiment
- A dummy variable called "correctinterpretation_schools" where respondents score 1 if they do correctly identify the school in experiment 1 with the highest rate of satisfaction as being the one that performs best, whereas they score 0 if they falsely point at the school with the lowest rate of satisfaction as being the one that performs best
- A dummy variable called "correctinterpretation_roads" where respondents score 1 if they do correctly identify the supplier in experiment 1 with the highest rate of satisfaction as being the one that performs best, whereas they score 0 if they falsely point at the supplier with the lowest rate of satisfaction as being the one that performs best
- A dummy variable called "correctinterpretation_rehab" where respondents score 1 if they do correctly identify the provider in experiment 3 with the highest rehabilitation success rate as being the one that performs best, whereas they score 0 if they falsely point at the provider with the lowest rehabilitation success rate as being the one that performs best

*/

***PRIOR ATTITUDES INDEX (USED AS INDEPENDENT VARIABLE IN ALL ANALYSES, DISTRIBUTIONS REPORTED IN FIGURE 1)***

*Additive index called "pro_public" is coded based on the three prior items. Index runs from 0-1 with higher values corresponding to a stronger preference for public service provision. Index is described in text about Figure 1 and in footnote 26.
recode prior1 prior2 (5=1) (4=2) (3=3) (2=4) (1=5)
recode prior1 prior2 prior3 (6=.)
alpha prior1 prior2 prior3 if politician ==1
alpha prior1 prior2 prior3 if politician ==0
factor prior1 prior2 prior3 if politician ==1
factor prior1 prior2 prior3 if politician ==0
generate pro_public = ((prior1+ prior2+ prior3)-3)/12
tab pro_public if politician ==1
sum pro_public if politician ==1
tab pro_public if politician ==0
sum pro_public if politician ==0
*Figure 1, Panel A:
histogram pro_public if politician==1, discrete percent gap(0) xtitle(Support for public service provision) scheme(s2mono)

*Figure 1, Panel B:
histogram pro_public if politician==0, discrete percent gap(0) xtitle(Support for public service provision) scheme(s2mono)

***EXPERIMENT 1 AND 2: ANALYSIS***

*In the beginning of the section called "Experiment 1 and 2: Analysis" we write that "Between 73 and 77 percent of the politicians in the placebo groups provide correct answers, which is significantly higher than random guessing (p < 0.001 for all placebo groups)". This is based on the tests below:

prtest correctinterpretation_schools == 0.5 if sectorvisible_schools==0 & public_a_best_schools ==1 & politician ==1
prtest correctinterpretation_schools == 0.5 if sectorvisible_schools==0 & public_a_best_schools ==0 & politician ==1
prtest correctinterpretation_roads == 0.5 if sectorvisible_roads ==0 & public_a_best_roads ==0 & politician ==1
prtest correctinterpretation_roads == 0.5 if sectorvisible_roads ==0 & public_a_best_roads ==1 & politician ==1

*Interaction terms are created in order to test for interactions between prior attitudes and our treatment dummy.

gen pro_publicXsectorvisible_schools = pro_public * sectorvisible_schools
gen pro_publicXsectorvisible_roads = pro_public * sectorvisible_roads

*Table 1, Model 1
logit correctinterpretation_schools pro_public sectorvisible_schools pro_publicXsectorvisible_schools if public_a_best_schools==0 & politician==1, robust 

*Table 1, Model 2
logit correctinterpretation_schools pro_public sectorvisible_schools pro_publicXsectorvisible_schools if public_a_best_schools==1 & politician==1, robust

*Table 1, Model 3
logit correctinterpretation_roads pro_public sectorvisible_roads pro_publicXsectorvisible_roads if public_a_best_roads==0 & politician==1, robust

*Table 1, Model 4
logit correctinterpretation_roads pro_public sectorvisible_roads pro_publicXsectorvisible_roads if public_a_best_roads==1 & politician==1, robust

*Table 1, Model 5
logit correctinterpretation_schools pro_public sectorvisible_schools pro_publicXsectorvisible_schools if public_a_best_schools==0 & politician==0, robust 

*Table 1, Model 6
logit correctinterpretation_schools pro_public sectorvisible_schools pro_publicXsectorvisible_schools if public_a_best_schools==1 & politician==0, robust

*Table 1, Model 7
logit correctinterpretation_roads pro_public sectorvisible_roads pro_publicXsectorvisible_roads if public_a_best_roads==0 & politician==0, robust

*Table 1, Model 8
logit correctinterpretation_roads pro_public sectorvisible_roads pro_publicXsectorvisible_roads if public_a_best_roads==1 & politician==0, robust

*Figure 3*

logit correctinterpretation_schools pro_public if sectorvisible_schools==1 & public_a_best_schools==0 & politician == 1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 3a: Private school performs best) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

logit correctinterpretation_schools pro_public if sectorvisible_schools==1 & public_a_best_schools==1 & politician == 1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 3b: Public school performs best) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

logit correctinterpretation_roads pro_public if sectorvisible_roads ==1 & public_a_best_roads==0 & politician==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 3c: Private road maintenance supplier performs best) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

logit correctinterpretation_roads pro_public if sectorvisible_roads ==1 & public_a_best_roads==1 & politician==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 3d: Public road maintenance supplier performs best) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

*We state in the paper (right after the presentation of figure 3) that: "for politicians who receive information in accordance with their prior attitudes, a very high percentage (84–98%) interprets the information correctly. In contrast, politicians who receive information that is most at odds with their prior attitudes only interpret the information correctly 38-61% of the time. The difference in correct interpretations between those who are confirmed and those who are disconfirmed by the information thus amounts to up to 51 percentage points in panels 3a-c."
*This statement can be verified by looking at the numbers created by the four margin commands above.

***EXPERIMENT 3: ANALYSIS***

*Interaction terms are created in order to test for moderating effects of information load on the impact of attitudes on interpretations.

gen infoload_3Xpro_public = infoload_3 * pro_public
gen infoload_5Xpro_public = infoload_5 * pro_public

*Table 2, Model 1
logit correctinterpretation_rehab pro_public infoload_3 infoload_5 infoload_3Xpro_public infoload_5Xpro_public if public_best_rehabilitation == 0 & politician==1, robust

*Table 2, Model 2
logit correctinterpretation_rehab pro_public infoload_3 infoload_5 infoload_3Xpro_public infoload_5Xpro_public if public_best_rehabilitation == 1 & politician==1, robust

*Table 2, Model 3
logit correctinterpretation_rehab pro_public infoload_3 infoload_5 infoload_3Xpro_public infoload_5Xpro_public if public_best_rehabilitation == 0 & politician==0, robust

*Table 2, Model 4
logit correctinterpretation_rehab pro_public infoload_3 infoload_5 infoload_3Xpro_public infoload_5Xpro_public if public_best_rehabilitation == 1 & politician==0, robust

*Figure 5.

logit correctinterpretation_rehab pro_public if infoload_3 ==0 & infoload_5 == 0 & politician == 1 & public_best_rehabilitation ==0, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5a: One piece of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

logit correctinterpretation_rehab pro_public if infoload_3 ==1 & politician == 1 & public_best_rehabilitation ==0, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5b: Three pieces of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

logit correctinterpretation_rehab pro_public if infoload_5 ==1 & politician == 1 & public_best_rehabilitation ==0, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5c: Five pieces of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

logit correctinterpretation_rehab pro_public if infoload_3 ==0 & infoload_5 == 0 & politician == 1 & public_best_rehabilitation ==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5d: One piece of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

logit correctinterpretation_rehab pro_public if infoload_3 ==1 & politician == 1 & public_best_rehabilitation ==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5e: Three pieces of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

logit correctinterpretation_rehab pro_public if infoload_5 ==1 & politician == 1 & public_best_rehabilitation ==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5f: Five pieces of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

*We state in the paper (right after the presentation of Figure 5) that: *Looking first at panels 5a-c where the private provider performs best, the difference in correct answers between politicians whose attitudes are most in accordance and most at odds with their prior attitudes increases from 28 to 50 percentage points when increasing the amount of information from one to five pieces. An increase of roughly the same size can be observed in panels 5d-f where the public provider performs best. Thus, the increases are of substantial magnitude. Moreover, it is clear from Figure 5 that the effect of adding more information is mainly driven by an increase in correct interpretations of the politicians who are presented with information in accordance with their prior attitudes (an increase from an estimated 77% in the group that receives one piece of information to 92% in the group that receives five pieces of information). In contrast, estimated correct interpretations of politicians who face information at odds with their prior attitudes do not change much.
**This statement can be verified by looking at the numbers created by the six margin commands above.


***APPENDIX: TABLE A1***

*Table A1, Panel A, Model 1
logit correctinterpretation_schools pro_public if public_a_best_schools==0 & sectorvisible_schools==1 & politician==1, robust 

*Table A1, Panel A, Model 2
logit correctinterpretation_schools pro_public if public_a_best_schools==1 & sectorvisible_schools==1 & politician==1, robust 

*Table A1, Panel A, Model 3
logit correctinterpretation_schools pro_public if public_a_best_schools==0 & sectorvisible_schools==0 & politician==1, robust 

*Table A1, Panel A, Model 4
logit correctinterpretation_schools pro_public if public_a_best_schools==1 & sectorvisible_schools==0 & politician==1, robust 

*Table A1, Panel A, Model 5
logit correctinterpretation_roads pro_public if public_a_best_roads==0 & sectorvisible_roads==1 & politician==1, robust  

*Table A1, Panel A, Model 6
logit correctinterpretation_roads pro_public if public_a_best_roads==1 & sectorvisible_roads==1 & politician==1, robust 

*Table A1, Panel A, Model 7
logit correctinterpretation_roads pro_public if public_a_best_roads==0 & sectorvisible_roads==0 & politician==1, robust 

*Table A1, Panel A, Model 8
logit correctinterpretation_roads pro_public if public_a_best_roads==1 & sectorvisible_roads==0 & politician==1, robust 

*Table A1, Panel B, Model 1
logit correctinterpretation_schools pro_public if public_a_best_schools==0 & sectorvisible_schools==1 & politician==0, robust 

*Table A1, Panel B, Model 2
logit correctinterpretation_schools pro_public if public_a_best_schools==1 & sectorvisible_schools==1 & politician==0, robust 

*Table A1, Panel B, Model 3
logit correctinterpretation_schools pro_public if public_a_best_schools==0 & sectorvisible_schools==0 & politician==0, robust 

*Table A1, Panel B, Model 4
logit correctinterpretation_schools pro_public if public_a_best_schools==1 & sectorvisible_schools==0 & politician==0, robust 

*Table A1, Panel B, Model 5
logit correctinterpretation_roads pro_public if public_a_best_roads==0 & sectorvisible_roads==1 & politician==0, robust  

*Table A1, Panel B, Model 6
logit correctinterpretation_roads pro_public if public_a_best_roads==1 & sectorvisible_roads==1 & politician==0, robust 

*Table A1, Panel B, Model 7
logit correctinterpretation_roads pro_public if public_a_best_roads==0 & sectorvisible_roads==0 & politician==0, robust 

*Table A1, Panel B, Model 8
logit correctinterpretation_roads pro_public if public_a_best_roads==1 & sectorvisible_roads==0 & politician==0, robust 

***APPENDIX: TABLE A2***

*Interaction terms are coded in order to test for differences between politicians' and citizens' reasoning.

gen pro_publicXpolitician = pro_public * politician
gen politicianXsectorvisible_schools = sectorvisible_schools * politician
gen politicianXsectorvisible_roads = sectorvisible_roads * politician 
gen pro_pubXtreatment_schoolsXpol = pro_public * sectorvisible_schools * politician
gen pro_pubXtreatment_roadsXpol = pro_public * sectorvisible_roads * politician

*Table A2, Model 1
logit correctinterpretation_schools pro_public politician sectorvisible_schools pro_publicXpolitician pro_publicXsectorvisible_schools politicianXsectorvisible_schools pro_pubXtreatment_schoolsXpol if public_a_best_schools==0, robust 

*Table A2, Model 2
logit correctinterpretation_schools pro_public politician sectorvisible_schools pro_publicXpolitician pro_publicXsectorvisible_schools politicianXsectorvisible_schools pro_pubXtreatment_schoolsXpol if public_a_best_schools==1, robust 

*Table A2, Model 3
logit correctinterpretation_roads pro_public politician sectorvisible_roads pro_publicXpolitician pro_publicXsectorvisible_roads politicianXsectorvisible_roads pro_pubXtreatment_roadsXpol if public_a_best_roads==0, robust 

*Table A2, Model 4
logit correctinterpretation_roads pro_public politician sectorvisible_roads pro_publicXpolitician pro_publicXsectorvisible_roads politicianXsectorvisible_roads pro_pubXtreatment_roadsXpol if public_a_best_roads==1, robust 

*Table A2, Model 5
logit correctinterpretation_schools pro_public politician pro_publicXpolitician if sectorvisible_schools ==1 & public_a_best_schools==0, robust 

*Table A2, Model 6
logit correctinterpretation_schools pro_public politician pro_publicXpolitician if sectorvisible_schools ==1 & public_a_best_schools==1, robust 

*Table A2, Model 7
logit correctinterpretation_roads pro_public politician pro_publicXpolitician if sectorvisible_roads ==1 & public_a_best_roads==0, robust 

*Table A2, Model 8
logit correctinterpretation_roads pro_public politician pro_publicXpolitician if sectorvisible_roads ==1 & public_a_best_roads==1, robust 

***APPENDIX: TABLE A3***

*Interaction terms are coded in order to test for differences between politicians' and citizens' reasoning.

gen infoload_3Xpolitician = infoload_3 * politician
gen infoload_5Xpolitician = infoload_5 * politician
gen pro_pubXinfoload_3Xpol = pro_public * infoload_3 * politician
gen pro_pubXinfoload_5Xpol = pro_public * infoload_5 * politician

*Table A3, Model 1
logit correctinterpretation_rehab pro_public politician infoload_3 infoload_5 pro_publicXpolitician if public_best_rehabilitation ==0, robust

*Table A3, Model 2
logit correctinterpretation_rehab pro_public politician infoload_3 infoload_5 pro_publicXpolitician infoload_3Xpro_public infoload_5Xpro_public infoload_3Xpolitician infoload_5Xpolitician pro_pubXinfoload_3Xpol pro_pubXinfoload_5Xpol if public_best_rehabilitation ==0, robust

*Table A3, Model 3
logit correctinterpretation_rehab pro_public politician infoload_3 infoload_5 pro_publicXpolitician if public_best_rehabilitation ==1, robust

*Table A3, Model 4
logit correctinterpretation_rehab pro_public politician infoload_3 infoload_5 pro_publicXpolitician infoload_3Xpro_public infoload_5Xpro_public infoload_3Xpolitician infoload_5Xpolitician pro_pubXinfoload_3Xpol pro_pubXinfoload_5Xpol if public_best_rehabilitation ==1, robust

***SUPPLEMENTARY MATERIAL***

/***NOTE TO READER***

A replication dataset with background variables has been constructed for the citizen sample. This is relevant for the supplementary material.

Background variables are excluded for our politician sample as respondents were promised full anonymity and combining background characteristics would make it possible to identify respondents.
As a consequence, Table S1, S3, S4, and S5, Model 1-4 in S9, and Model 1-2 in S10 are not included in the replication material.

*/

use "ReplicationData2", clear

*Table S1
*This table is excluded due to anonymity promises to respondents, see note to reader above.

*Table S2
sum pro_public
sum correctinterpretation_schools
sum correctinterpretation_roads
sum correctinterpretation_rehab
sum woman
sum age
sum higher_education
sum household_income_600Kplus
sum leftwingvoter

*Tables S3-S5
*These tables are excluded due to anonymity promises to respondents, see note to reader above.

*Table S6
*Group dummies are constructed in order to make ttests and prtests
gen P1_Exp1 =.
replace P1_Exp1 = 1 if sectorvisible_schools ==0 & public_a_best_schools ==0
gen P2_Exp1 =.
replace P2_Exp1 = 1 if sectorvisible_schools ==0 & public_a_best_schools ==1
gen T1_Exp1 =.
replace T1_Exp1 = 1 if sectorvisible_schools ==1 & public_a_best_schools ==0
gen T2_Exp1 =.
replace T2_Exp1 = 1 if sectorvisible_schools ==1 & public_a_best_schools ==1
replace P1_Exp1 = 0 if P2_Exp1==1 | T1_Exp1==1 | T2_Exp1==1
replace P2_Exp1 = 0 if P1_Exp1==1 | T1_Exp1==1 | T2_Exp1==1
replace T1_Exp1 = 0 if P1_Exp1==1 | P2_Exp1==1 | T2_Exp1==1
replace T2_Exp1 = 0 if P1_Exp1==1 | P2_Exp1==1 | T1_Exp1==1
*Table S6, Model 1 (P1: B best)
prtest woman, by(P1_Exp1)
ttest age, by(P1_Exp1)
ttest pro_public, by(P1_Exp1)
prtest higher_education, by(P1_Exp1)
ttest household_income, by(P1_Exp1)
*Table S6, Model 2 (P2: A best)
prtest woman, by(P2_Exp1)
ttest age, by(P2_Exp1)
ttest pro_public, by(P2_Exp1)
prtest higher_education, by(P2_Exp1)
ttest household_income, by(P2_Exp1)
*Table S6, Model 3 (T1: Private best)
prtest woman, by(T1_Exp1)
ttest age, by(T1_Exp1)
ttest pro_public, by(T1_Exp1)
prtest higher_education, by(T1_Exp1)
ttest household_income, by(T1_Exp1)
*Table S6, Model 4 (T2: Public best)
prtest woman, by(T2_Exp1)
ttest age, by(T2_Exp1)
ttest pro_public, by(T2_Exp1)
prtest higher_education, by(T2_Exp1)
ttest household_income, by(T2_Exp1)

*Table S7
*Group dummies are constructed in order to make ttests and prtests
gen P1_Exp2 =.
replace P1_Exp2 = 1 if sectorvisible_roads ==0 & public_a_best_roads ==0
gen P2_Exp2 =.
replace P2_Exp2 = 1 if sectorvisible_roads ==0 & public_a_best_roads ==1
gen T1_Exp2 =.
replace T1_Exp2 = 1 if sectorvisible_roads ==1 & public_a_best_roads ==0
gen T2_Exp2 =.
replace T2_Exp2 = 1 if sectorvisible_roads ==1 & public_a_best_roads ==1
replace P1_Exp2 = 0 if P2_Exp2==1 | T1_Exp2==1 | T2_Exp2==1
replace P2_Exp2 = 0 if P1_Exp2==1 | T1_Exp2==1 | T2_Exp2==1
replace T1_Exp2 = 0 if P1_Exp2==1 | P2_Exp2==1 | T2_Exp2==1
replace T2_Exp2 = 0 if P1_Exp2==1 | P2_Exp2==1 | T1_Exp2==1
*Table S7, Model 1 (P1: B best)
prtest woman, by(P1_Exp2)
ttest age, by(P1_Exp2)
ttest pro_public, by(P1_Exp2)
prtest higher_education, by(P1_Exp2)
ttest household_income, by(P1_Exp2)
*Table S7, Model 2 (P2: A best)
prtest woman, by(P2_Exp2)
ttest age, by(P2_Exp2)
ttest pro_public, by(P2_Exp2)
prtest higher_education, by(P2_Exp2)
ttest household_income, by(P2_Exp2)
*Table S7, Model 3 (T1: Private best)
prtest woman, by(T1_Exp2)
ttest age, by(T1_Exp2)
ttest pro_public, by(T1_Exp2)
prtest higher_education, by(T1_Exp2)
ttest household_income, by(T1_Exp2)
*Table S7, Model 4 (T2: Public best)
prtest woman, by(T2_Exp2)
ttest age, by(T2_Exp2)
ttest pro_public, by(T2_Exp2)
prtest higher_education, by(T2_Exp2)
ttest household_income, by(T2_Exp2)

*Table S8
*Group dummies are constructed in order to make ttests and prtests
gen PubBest1 =.
replace PubBest1 = 1 if public_best_rehabilitation ==1 & infoload_3 !=1 & infoload_5 !=1
gen PubBest3 =.
replace PubBest3 = 1 if public_best_rehabilitation ==1 & infoload_3 ==1
gen PubBest5 =.
replace PubBest5 = 1 if public_best_rehabilitation ==1 & infoload_5 ==1
gen PrivBest1 =.
replace PrivBest1 = 1 if public_best_rehabilitation ==0 & infoload_3 !=1 & infoload_5 !=1
gen PrivBest3 =.
replace PrivBest3 = 1 if public_best_rehabilitation ==0 & infoload_3 ==1
gen PrivBest5 =.
replace PrivBest5 = 1 if public_best_rehabilitation ==0 & infoload_5 ==1
replace PubBest1 = 0 if PubBest3==1 | PubBest5==1 | PrivBest1==1 | PrivBest3==1| PrivBest5==1
replace PubBest3 = 0 if PubBest1==1 | PubBest5==1 | PrivBest1==1 | PrivBest3==1| PrivBest5==1
replace PubBest5 = 0 if PubBest1==1 | PubBest3==1 | PrivBest1==1 | PrivBest3==1| PrivBest5==1
replace PrivBest1 = 0 if PubBest1==1 | PubBest3==1 | PubBest5==1 | PrivBest3==1| PrivBest5==1
replace PrivBest3 = 0 if PubBest1==1 | PubBest3==1 | PubBest5==1 | PrivBest1==1| PrivBest5==1
replace PrivBest5 = 0 if PubBest1==1 | PubBest3==1 | PubBest5==1 | PrivBest1==1| PrivBest3==1
*Table S8, Model 1 (Public best, 1 info)
prtest woman, by(PubBest1)
ttest age, by(PubBest1)
ttest pro_public, by(PubBest1)
prtest higher_education, by(PubBest1)
ttest household_income, by(PubBest1)
*Table S8, Model 2 (Public best, 3 info)
prtest woman, by(PubBest3)
ttest age, by(PubBest3)
ttest pro_public, by(PubBest3)
prtest higher_education, by(PubBest3)
ttest household_income, by(PubBest3)
*Table S8, Model 3 (Public best, 5 info)
prtest woman, by(PubBest5)
ttest age, by(PubBest5)
ttest pro_public, by(PubBest5)
prtest higher_education, by(PubBest5)
ttest household_income, by(PubBest5)
*Table S8, Model 4 (Private best, 1 info)
prtest woman, by(PrivBest1)
ttest age, by(PrivBest1)
ttest pro_public, by(PrivBest1)
prtest higher_education, by(PrivBest1)
ttest household_income, by(PrivBest1)
*Table S8, Model 5 (Private best, 3 info)
prtest woman, by(PrivBest3)
ttest age, by(PrivBest3)
ttest pro_public, by(PrivBest3)
prtest higher_education, by(PrivBest3)
ttest household_income, by(PrivBest3)
*Table S8, Model 6 (Private best, 5 info)
prtest woman, by(PrivBest5)
ttest age, by(PrivBest5)
ttest pro_public, by(PrivBest5)
prtest higher_education, by(PrivBest5)
ttest household_income, by(PrivBest5)

*Figure S1, Panel 3a
logit correctinterpretation_schools pro_public if sectorvisible_schools==1 & public_a_best_schools==0, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 3a: Private school performs best) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)
*Figure S1, Panel 3b
logit correctinterpretation_schools pro_public if sectorvisible_schools==1 & public_a_best_schools==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 3b: Public school performs best) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)
*Figure S1, Panel 3c
logit correctinterpretation_roads pro_public if sectorvisible_roads ==1 & public_a_best_roads==0, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 3c: Private road maintenance supplier performs best) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)
*Figure S1, Panel 3d
logit correctinterpretation_roads pro_public if sectorvisible_roads ==1 & public_a_best_roads==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 3d: Public road maintenance supplier performs best) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

*Figure S2, Panel 5a
logit correctinterpretation_rehab pro_public if infoload_3 ==0 & infoload_5 == 0 & public_best_rehabilitation ==0, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5a: One piece of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)
*Figure S2, Panel 5b
logit correctinterpretation_rehab pro_public if infoload_3 ==1 & public_best_rehabilitation ==0, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5b: Three pieces of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)
*Figure S2, Panel 5c
logit correctinterpretation_rehab pro_public if infoload_5 ==1 & public_best_rehabilitation ==0, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5c: Five pieces of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)
*Figure S2, Panel 5d
logit correctinterpretation_rehab pro_public if infoload_3 ==0 & infoload_5 == 0 & public_best_rehabilitation ==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5d: One piece of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)
*Figure S2, Panel 5e
logit correctinterpretation_rehab pro_public if infoload_3 ==1 & public_best_rehabilitation ==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5e: Three pieces of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)
*Figure S2, Panel 5f
logit correctinterpretation_rehab pro_public if infoload_5 ==1 & public_best_rehabilitation ==1, robust
margins, at(pro_public=(0(0.1)1)) vsquish
marginsplot, ytitle("Likelihood of correct interpretation") xtitle("") legend(off) title(Panel 5f: Five pieces of information received) xtitle("") graphregion(fcolor(white) lcolor(white)) recast(line) plotopts(lcolor(black)) recastci(rline) ciopts(lpattern(dash)) scheme(s2mono)

*Table S9
gen pro_publicXsectorvisible_schools = pro_public * sectorvisible_schools
gen pro_publicXsectorvisible_roads = pro_public * sectorvisible_roads
*Table S9, Model 1 (politicians, experiment 1; T1/P1) is excluded due to anonymity promises to respondents, see note to reader above.
*Table S9, Model 2 (politicians, experiment 1; T2/P2) is excluded due to anonymity promises to respondents, see note to reader above.
*Table S9, Model 3 (politicians, experiment 2; T1/P1) is excluded due to anonymity promises to respondents, see note to reader above.
*Table S9, Model 4 (politicians, experiment 2; T2/P2) is excluded due to anonymity promises to respondents, see note to reader above.
*Table S9, Model 5 (citizens, experiment 1; T1/P1)
logit correctinterpretation_schools pro_public sectorvisible_schools pro_publicXsectorvisible_schools woman age higher_education household_income if public_a_best_schools==0, robust 
*Table S9, Model 6 (citizens, experiment 1; T2/P2)
logit correctinterpretation_schools pro_public sectorvisible_schools pro_publicXsectorvisible_schools woman age higher_education household_income if public_a_best_schools==1, robust 
*Table S9, Model 7 (citizens, experiment 2; T1/P1)
logit correctinterpretation_roads pro_public sectorvisible_roads pro_publicXsectorvisible_roads woman age higher_education household_income if public_a_best_roads==0, robust 
*Table S9, Model 8 (citizens, experiment 2; T2/P2)
logit correctinterpretation_roads pro_public sectorvisible_roads pro_publicXsectorvisible_roads woman age higher_education household_income if public_a_best_roads==1, robust 

*Table S10
gen infoload_3Xpro_public = infoload_3 * pro_public
gen infoload_5Xpro_public = infoload_5 * pro_public
*Table S10, Model 1 (politicians, experiment 3; private best) is excluded due to anonymity promises to respondents, see note to reader above.
*Table S10, Model 2 (politicians, experiment 3; public best) is excluded due to anonymity promises to respondents, see note to reader above.
*Table S10, Model 3 (citizens, experiment 3; private best)
logit correctinterpretation_rehab pro_public infoload_3 infoload_5 infoload_3Xpro_public infoload_5Xpro_public woman age higher_education household_income if public_best_rehabilitation == 0, robust
*Table S10, Model 4 (citizens, experiment 3; public best) 
logit correctinterpretation_rehab pro_public infoload_3 infoload_5 infoload_3Xpro_public infoload_5Xpro_public woman age higher_education household_income if public_best_rehabilitation == 1, robust

*Table S11, Model 1 (politicians, experiment 1; T1/T2)
use "ReplicationData1", clear
recode prior1 prior2 (5=1) (4=2) (3=3) (2=4) (1=5)
recode prior1 prior2 prior3 (6=.)
generate pro_public = ((prior1+ prior2+ prior3)-3)/12
histogram pro_public if politician ==1
recode prior1 prior2 prior3 (5=1) (4=2) (3=3) (2=4) (1=5)
generate pro_private = ((prior1+ prior2+ prior3)-3)/12
histogram pro_private if politician ==1
gen reinforces_schools = .
replace reinforces_schools = pro_public if public_a_best_schools ==1
replace reinforces_schools = pro_private if public_a_best_schools ==0
logit correctinterpretation_schools reinforces_schools if politician==1 & sectorvisible_schools==1, robust 
*Table S11, Model 2 (politicians, experiment 2; T1/T2)
gen reinforces_roads = .
replace reinforces_roads = pro_public if public_a_best_roads ==1
replace reinforces_roads = pro_private if public_a_best_roads ==0
logit correctinterpretation_roads reinforces_roads if politician==1 & sectorvisible_roads==1, robust 
*Table S11, Model 3 (citizens, experiment 1; T1/T2)
logit correctinterpretation_schools reinforces_schools if politician==0 & sectorvisible_schools==1, robust 
*Table S11, Model 4 (citizens, experiment 2; T1/T2)
logit correctinterpretation_roads reinforces_roads if politician==0 & sectorvisible_roads==1, robust 

*Table S12, Model 1 (Politician sample)
gen reinforces_rehab = .
replace reinforces_rehab = pro_public if public_best_rehabilitation ==1
replace reinforces_rehab = pro_private if public_best_rehabilitation ==0
gen infoload_3Xreinforces = infoload_3 * reinforces_rehab
gen infoload_5Xreinforces = infoload_5 * reinforces_rehab
logit correctinterpretation_rehab reinforces_rehab infoload_3 infoload_5 infoload_3Xreinforces infoload_5Xreinforces if politician==1, robust
*Table S12, Model 2 (Citizen sample)
logit correctinterpretation_rehab reinforces_rehab infoload_3 infoload_5 infoload_3Xreinforces infoload_5Xreinforces if politician==0, robust

