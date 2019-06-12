/*
Replication Code for Appendix 3 in Article:
Does Shared Social Disadvantage Cause Black-Latino Political Commonality?
To Be Published in JEPS
Authors: Mackenzie Israel-Trummel and Ariela Schachter
contact: mackisr@ou.edu or ariela@wustl.edu

URL for replication code & data: 
URL for article: 

Code last updated: 3/6/2018
*/

/* Set your local file path here */


use IsraelTrummel_Schachter_JEPS2018_appendix3.dta, replace

***Format variables used in Appendix 3 Table A3***

**Treatment**
encode treat, gen(treatment)
lab def treat_lbl 1"Placebo" 2"Treatment"
lab val treatment treat_lbl

**code 3 true/false pre-treatment measures**
gen tf_1=0
replace tf_1=1 if tf1=="FALSE"
replace tf_1=. if tf1=="."

gen tf_2=0
replace tf_2=1 if tf2=="FALSE"
replace tf_2=. if tf2=="."

gen tf_3=0
replace tf_3=1 if tf3=="FALSE"
replace tf_3=. if tf3=="."

**Latino Commonality**
gen latcom=.
replace latcom=1 if dv_dv_lat=="Nothing"
replace latcom=2 if dv_dv_lat =="A little"
replace latcom=3 if dv_dv_lat =="Some"
replace latcom=4 if dv_dv_lat =="A lot"

**Attention Check**
encode attention, generate(attend)

gen attentive=0
replace attentive=1 if treatment==1&attend==3
replace attentive=1 if treatment==2&attend==1

********************************************************
***Estimates Reported in Appendix Table A3***
*Full sample, mean latino commonality*
ttest latcom, by(treatment)
*attentive sample, mean latino commonality*
ttest latcom if attentive==1, by(treatment)
*pass attention check*
tab attentive treatment, col chi2

*pre-treatment measures, by treatment*
tab tf1 treatment,  col chi2
tab tf2 treatment,  col chi2
tab tf3 treatment,  col chi2
********************************************************


