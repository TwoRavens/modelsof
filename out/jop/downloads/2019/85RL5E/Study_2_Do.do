* Setting the working directory <to be changed in one's own WD> * 
cd "C:\Users\теош\Desktop"

* Loading the dataset *
use "Institutions_corruption_JOP_Study_2_Data.dta", replace

drop if city==8 /* dropping respondents not from the study's 7 cities*/	

*************************
** Main text (Table 3) **
*************************
** satisfaction with the mayor **

* Model 1 - Basic model
reg satis i.allegations##i.treatment
outreg2 using Table_3.doc, replace se dec(3) alpha (.002, .02, .10, .2)  ///
symbol (***, **, *, +) addtext(City Fixed-effects, "NO", Matching on Observables, "NO") 

* Calculating the difference in the treatment condition
gen allegations_treatment=1 if allegations==1 & treatment==1
recode allegations_treatment (.=0)
reg satis allegations treatment allegations_treatment
lincom allegations + allegations_treatment

* Model 2 - City FEs without the Ebalance Matching procedure (Hainmueller 2012) 
reg satis i.allegations##i.treatment i.city
outreg2 using Table_3.doc, append se dec(3) alpha (.002, .02, .10, .2)  ///
symbol (***, **, *, +) keep(i.allegations##i.treatment) ///
addtext(City Fixed-effects, "YES", Matching on Observables, "NO") 

* Model 3 - City FEs with the Ebalance Matching procedure (Hainmueller 2012) 
ebalance allegations age gender relig ideology polit_inter, targets(1)
svyset [pweight=_webal]
svy: reg satis i.allegations##i.treatment i.city
outreg2 using Table_3.doc, append se dec(3) alpha (.002, .02, .10, .2)  ///
symbol (***, **, *, +) keep(i.allegations##i.treatment) ///
addtext(City Fixed-effects, "YES", Matching on Observables, "YES") 


*********************
** Online Appendix **
*********************

* checking for covariate balance across conditions
tab treatment gender, chi col /* p-value = 0.138 */
ttest age, by (treatment) /* p-value = 0.138 */  
ttest relig, by (treatment) /* p-value = 0.265 */  
ttest ideology, by (treatment) /* p-value = 0.608 */  
ttest polit_interest, by (treatment) /* p-value = 0.393 */  
tab treatment allegations, chi col /* p-value = 0.823 */

* Randomization test
logit treatment age gender relig ideology polit_interest allegations /* Model's p-value = 0.378 */
outreg2 using Table_A10.doc, replace se dec(3) alpha (.001, .01, .05, .1) ///
symbol (***, **, *, +) addstat(Model's Chi-Square, (e(chi2)), Model's Significance, (e(p))) 

* Difference b/w respondents from "corruption" and "clean" cities
sum age 
sum age if allegations==0 
sum age if allegations==1
ttest age, by (allegations) 

tab gender 
tab gender if allegations==0
tab gender if allegations==1
tab gender allegations, chi col

sum relig 
sum relig if allegations==0
sum relig if allegations==1
ttest relig, by (allegations) 

sum ideology 
sum ideology if allegations==0
sum ideology if allegations==1
ttest ideology, by (allegations) 

sum polit_interest 
sum polit_interest if allegations==0
sum polit_interest if allegations==1
ttest polit_interest, by (allegations)


************************
*** Robustness tests ***
************************

*** Matching procedure - CEM (Iacus et al. 2012) ***
*drop if city==8

* * with age "groups" (decades), ideological groups, and political interest groups 
* Age
gen age_group=0 if age>=18 & age<=29
replace age_group=1 if age>=30 & age<=39
replace age_group=2 if age>=40 & age<=49
replace age_group=3 if age>=50 & age<=59
replace age_group=4 if age>=60 & age<=69
replace age_group=5 if age>=70 & age<=99
* Ideology
gen ideo_group=0 if ideology>=1 & ideology<=3
replace ideo_group=1 if ideology==4
replace ideo_group=2 if ideology>=5 & ideology<=7
* Political Interest
gen polit_int_group=0 if polit_interest==1 | polit_interest==2
replace polit_int_group=1 if polit_interest==3
replace polit_int_group=2 if polit_interest==4 | polit_interest==5

imb age_group gender relig ideo_group polit_int_group, treatment (allegations) 
cem age_group gender relig ideo_group polit_int_group, treatment (allegations) 
reg satis i.allegations##i.treatment i.city [iweight=cem_weights]
outreg2 using Table_A11.doc, replace se dec(3) alpha (.002, .02, .10, .2)  ///
symbol (***, **, *, +) keep(i.allegations##i.treatment) addstat(Model's F statistic, (e(F))) ///
addtext(City Fixed-effects, "YES", Matching on Observables, "YES") 


** Matching with CEM - without any coarsening of variables
imb age gender relig ideology polit_interest, treatment (allegations) 
cem age gender relig ideology polit_interest, treatment (allegations) 
reg satis i.allegations##i.treatment i.city [iweight=cem_weights]


*** Randomization inference (RI) tests ***
gen treat_all=treatment*allegations
* Model 1:
ritest treat_all  _b[treat_all], rep(10000) strata(allegations) left seed(19145): reg satis allegations treatment treat_all 
* Model 2:
ritest treat_all  _b[treat_all], rep(10000) strata(allegations) left seed(19145): reg satis allegations treatment treat_all i.city
* Model 3:
ebalance allegations age gender relig ideology polit_inter, targets(1)
svyset [pweight=_webal]
ritest treat_all  _b[treat_all], rep(10000) strata(allegations) left seed(19145): svy: reg satis allegations treatment treat_all  i.city

drop treat_all

**************************
** Mayor vote intention  **
**************************

* Model 1 - Basic model
logit mayor_vote i.allegations##i.treatment
outreg2 using Table_A13.doc, replace se dec(3) alpha (.002, .02, .10, .2) ///
symbol (***, **, *, +)  ///
addtext(City Fixed-effects, "NO", Matching on Observables, "NO") 

* Model 2 - with City FEs
logit mayor_vote i.allegations##i.treatment i.city
outreg2 using Table_A13.doc, append se dec(3) alpha (.002, .02, .10, .2)  ///
symbol (***, **, *, +) keep(i.allegations##i.treatment) ///
addtext(City Fixed-effects, "YES", Matching on Observables, "NO") 

* Model 3 - with the Ebalance Matching procedure (Hainmueller 2012) & City FEs
ebalance allegations age gender relig ideology polit_inter, targets(1)
svyset [pweight=_webal]
svy: logit mayor_vote i.allegations##i.treatment i.city
outreg2 using Table_A13.doc, append se dec(3) alpha (.002, .02, .10, .2) ///
symbol (***, **, *, +) keep(i.allegations##i.treatment) ///
addtext(City Fixed-effects, "YES", Matching on Observables, "YES") 

