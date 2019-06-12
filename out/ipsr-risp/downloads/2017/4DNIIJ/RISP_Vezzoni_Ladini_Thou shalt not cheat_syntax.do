*******************************************************************************
*** Cristiano Vezzoni and Riccardo Ladini                                   ***
*** Thou Shalt not Cheat:                                                   ***
*** How to Reduce Internet Use in Web Surveys on Political Knowledge        ***
***                                                                         ***
***                      REPLICATION MATERIAL                               ***
***                        January 10, 2017                                 ***
***                                                                         ***
*******************************************************************************


*** The following syntax applies to the dataset:
*** "RISP_Vezzoni_Ladini_Thou shalt not cheat_dataset.dta"
*** The dataset is an extract of the 
*** Italian National Election Study (ITANES) on-line panel 2013-2015
*** The overall panel will be available at itanes.org

*** The English description of the variables is supplied in the following syntax

* Variable available in the dataset:
* Gender
* Age
* Education
* Interest in European Elections
* Frequency talking about politics
* Randomization variable 
* First  knowledge question
* Second knowledge question
* Third  knowledge question


*******************************************************************************

*** ANALYSES

* get the dataset
* use "RISP_Vezzoni_Ladini_Thou shalt not cheat_dataset.dta"

* to run this syntax you need outreg2 routine
* if you do not have it istalled yet, run the following code
* ssc istall outreg2


*** Recoding of the Knowledge items (q_66 q_67 q_68)
* Original Variable q_66: NUMBER OF THE EU COUNTRIES (Correct answer: 28)
* New Variable: KNOWpre1 (Correct answer: 1; Wrong answer: 0)
gen KNOWpre1=0
replace KNOWpre1=1 if (q_66=="28"|q_66=="0028"|q_66=="  28")
replace KNOWpre1=. if (q_66=="")

* Original Variable q_67: 
* NAME OF THE EPP CANDIDATE FOR EU PRESIDENCY  (Correct answer: 5-Juncker)
* New Variable: KNOWpre2 (Correct answer: 1; Wrong answer: 0)
gen KNOWpre2=.
replace KNOWpre2=1 if (q_67==5)
replace KNOWpre2=0 if (q_67>0 & q_67<5)| (q_67==. & s_8_01!=.)

* Original Variable q_68: 
* NAME OF THE PES CANDIDATE FOR EU PRESIDENCY  (Correct answer: 5-Juncker)
* New Variable: KNOWpre2 (Correct answer: 1; Wrong answer: 0)
gen KNOWpre3=.
replace KNOWpre3=1 if (q_68==3)
replace KNOWpre3=0 if ((q_68>0 & q_68<3)|(q_68>3 & q_68<6))

* Additive index of knowledge (0:0 correct answers - 3:3 correct answers)
gen KNOWpre=KNOWpre1+KNOWpre2+KNOWpre3

* Dummy index of knowledge (3 correct answers: 1; Otherwise: 0)
recode KNOWpre (3=1)(2 1 0=0), gen (dumKNOWpre)

*** Recode the experimental condition 
* Original variable: s_8_01 (1:control 2:treatment-no Internet)
* New Variable: RANDOMIZATION (1:control 2:treatment-no Internet)
recode s_8_01 (7=.), gen (RANDOMIZATION)
label define RANDOMIZATION 1"Control" 2"Treatment:No Internet"
label values RANDOMIZATION RANDOMIZATION


**********************************************************************************************
*** TABLE 1: Proportions of correct answers on political knowledge items in the two groups ***
**********************************************************************************************

tab RANDOMIZATION KNOWpre1, chi2 exact row    /* item on EU countries */
tab RANDOMIZATION KNOWpre2, chi2 exact row    /* item on EPP candidate */
tab RANDOMIZATION KNOWpre3, chi2 exact row    /* item on PES candidate */
tab RANDOMIZATION dumKNOWpre, chi2 exact row  /* all 3 items correct */       

*********************************************************************************************
*** TABLE A2: Distributions of the answers to Item B and Item C by experimental condition ***
*********************************************************************************************
tabulate RANDOMIZATION q_67, row  /* item on EPP candidate */
tabulate RANDOMIZATION q_68, row  /* item on PES candidate */

**********************************************************************************************************
*** TABLE 2: Table 2. Item correlations for knowledge questions, Cronbach’s alpha of the additive ///  ***
***                   knowledge scale and Z-test on differences between the two experimental groups    ***
**********************************************************************************************************
* Pairwise correlations by experimental condition 
bysort RANDOMIZATION: corr KNOWpre1-KNOWpre3 

* Extraction of the values of the previous correlation matrices (bysort RANDOMIZATION: corr KNOWpre1-KNOWpre3) ///
* for the calculation of the Fisher R-z transformation

** Fisher R-z transformation for the comparison of item correlations by experimental condition ///
*  Correlations manually inserted   
*  Item on EU countries - Item on EPP candidate 
gen z3= 0.5*log((1+ 0.2303)/(1- 0.2303 ))
gen z4= 0.5*log((1+0.2954)/(1-0.2954))
gen ztest1=(z3-z4)/(sqrt((1/(1631-3))+(1/(1612-3)))) /* Test statistic (see Table 1 row 1) */
sum ztest1
gen pv1=2*(1-normal(abs(ztest1))) /* p-value two-tailed */
sum pv1

*  Item on EU countries - Item on PES candidate 
gen z5= 0.5*log((1+0.1596)/(1-0.1596))
gen z6= 0.5*log((1+0.2577)/(1-0.2577))
gen ztest2=(z5-z6)/(sqrt((1/(1631-3))+(1/(1612-3)))) /* Test statistic (see Table 1 row 2) */
sum ztest2
gen pv2=2*(1-normal(abs(ztest2))) /* p-value two-tailed */
sum pv2

* Item on EPP candidate - Item on PES candidate
gen z7= 0.5*log((1+0.3654)/(1-0.3654))
gen z8= 0.5*log((1+0.3933)/(1-0.3933))
* Statistica test
gen ztest3=(z7-z8)/(sqrt((1/(1631-3))+(1/(1612-3)))) 
sum ztest3
gen pv3=2*(1-normal(abs(ztest3))) /* p-value two-tailed */
sum pv3

* Cronbach's alpha by experimental condition
bysort RANDOMIZATION: alpha KNOWpre1-KNOWpre3 if RANDOMIZATION!=., item std

* Calculation of Feldt test through the following web page: www.bgu.ac.il/~baranany/Feldt.xls 


*** Syntax for Figure 1 and Table A4

* Level of education recoded
recode q176 (1/3=1 "Low")(4/6=2 "Medium")(7/11=3 "High"), gen(titstu) 

* Gender renamed (Male=1; Female=2)
rename q002 sex

* Age recoded in 3 categories
rename q003 age6
recode age6 (1 2=1 "18-34")(3 4=2 "35-54")(5 6=3 ">54"), gen(age3)


******************************************************************************
*** Table A4: Linear regression with knowledge scale as dependent variable ***
******************************************************************************
reg KNOWpre i.sex i.age3 RANDOMIZATION##i.titstu
outreg2 using reg_12.doc,word dec(2)


***********************************************************************************
*** Figure 1: Predicted means of knowledge scores by experimental condition /// ***
*              and level of education from the previous regression analysis     ***
***********************************************************************************
margins RANDOMIZATION#i.titstu
marginsplot  /* figure edited in Stata Data Editor (labels, colors, ecc.) */


*** Calculations for Figure A1
* Recode of the original item on the number of EU countries
gen KNOWpre1num=32 /* arbitrary value = other number */
replace KNOWpre1num=25 if q_66=="25"
replace KNOWpre1num=26 if q_66=="26"
replace KNOWpre1num=27 if q_66=="27"|q_66==",27"
replace KNOWpre1num=28 if (q_66=="28"|q_66=="0028"|q_66=="  28")
replace KNOWpre1num=29 if q_66=="29"
replace KNOWpre1num=30 if q_66=="30"
replace KNOWpre1num=33 if q_66=="9999"  /* arbitrary value = DK */
replace KNOWpre1num=. if (q_66=="")

**********************************************************************************
*** Figure A1: Distribution of the answers to Item A by experimental condition ***
**********************************************************************************
hist KNOWpre1num if RANDOMIZATION!=., by(RANDOMIZATION) disc /* figure edited in Stata Data Editor (labels, colors, ecc.) */


*********************************************************************************************************
*** Table A3: Correlations between knowledge scale and other related variables and  two-sided Z-tests ***
*** on the differences of the correlations between the experimental groups                            ***
*******************************************************************************************************
* Correlation between knowledge index and Interest in the electoral outcome (q_46: 1-11 scale)
gen inter= q_46-1 /* interest recoded in 0(no interest)-10(much interest) scale */
bysort RANDOMIZATION: pwcorr KNOWpre inter if inter<11
** Fisher R-z transformation for the comparison of item correlations by experimental condition ///
*  Correlations manually inserted  
gen z9= 0.5*log((1+0.2063)/(1-0.2063))
gen z10= 0.5*log((1+0.1513)/(1-0.1513)) 
gen ztest4=(z9-z10)/(sqrt((1/(1525-3))+(1/(1535-3))))   /* Test statistic */
sum ztest4
gen pv4=2*(1-normal(abs(ztest4))) /* p-value two-tailed */
sum pv4

* Correlation between knowledge index and frequency of political discussion in the last month (q_51: 1-5 scale)
gen discuss= q_51-1 /* freq. of pol. discussion recoded in 0(never)- 4(every day) scale */
bysort s_8_01: pwcorr KNOWpre discuss if discuss<5 
** Fisher R-z transformation for the comparison of item correlations by experimental condition ///
*  Correlations manually inserted 
gen z11= 0.5*log((1+0.1997)/(1-0.1997))
gen z12= 0.5*log((1+0.1892 )/(1-0.1892)) 
gen ztest5=(z11-z12)/(sqrt((1/(1563-3))+(1/(1587-3))))    /* Test statistic */
sum ztest5
gen pv5=2*(1-normal(abs(ztest5))) /* p-value two-tailed */
sum pv5
