********************************************************************************
********************************************************************************
**** The Majority-Minority Divide in Attitudes Toward Internal Migration: ******
**** Evidence from Mumbai                  *************************************
**** Nikhar Gaikwad & Gareth Nellis        *************************************
**** American Journal of Political Science *************************************
********************************************************************************
********************************************************************************

clear all
set more off 
version 12.1 

* Set directory path to your own directory
cd "XXXXXX"

use13 "Majority_Minority_AJPS_Replication_Data.dta", clear

*Run these 2 lines of code to define the demographic control variables and store in memory
global controls1 age income female_gender born_mumbai
global controls2 age female_gender born_mumbai

/***************************************************************
**** Replication of results and tables in main paper ***********
***************************************************************/


******************
*Table 2
******************

* Columns 1-3
ttest age, by(religion_treat) une
ttest education_years, by(religion_treat) une
ttest college_education2, by(religion_treat) une
ttest income, by(religion_treat) une
ttest hindu_respondent, by(religion_treat) une
ttest female_gender, by(religion_treat) une
ttest born_mumbai, by(religion_treat) une
ttest marathi_speaking, by(religion_treat) une

* Columns 4-6
ttest age, by(skill_treat) une
ttest education_years, by(skill_treat) une
ttest college_education2, by(skill_treat) une
ttest income, by(skill_treat) une
ttest hindu_respondent, by(skill_treat) une
ttest female_gender, by(skill_treat) une
ttest born_mumbai, by(skill_treat) une
ttest marathi_speaking, by(skill_treat) une

***Randomization checks with F-tests for the joint significance of all covariates in explaining treatment assignment
* The F-tests from the regression are reported at the bottom of Table 2
* F-test, column 3, Table 2:
reg religion_treat college_education2 age education_years income hindu_respondent female_gender born_mumbai marathi_speaking, robust
* F-test, column 6, Table 2:
reg skill_treat college_education2 age education_years income hindu_respondent female_gender born_mumbai marathi_speaking, robust

***Multinomial logistic regression (mentioned in the main text)
* Construct a variable that assigned distinct values for the four main treatment conditions
gen treat_cat = .
replace treat_cat = 1 if religion_treat==1 & skill_treat==1
replace treat_cat = 2 if religion_treat==1 & skill_treat==0
replace treat_cat = 3 if religion_treat==0 & skill_treat==1
replace treat_cat = 4 if religion_treat==0 & skill_treat==0

* Run a multinomial logit model and inspect the LR chi2 test of the regression, and the associated probability
mlogit treat_cat college_education2 age education_years income hindu_respondent female_gender born_mumbai marathi_speaking



******************
*Table 3
******************

*Column 1
reg dv1 skill_treat $controls1, robust

*Column 2
reg dv1 i.skill_treat##i.income_dummy $controls2, robust



******************
*Table 4
******************

*Column 1
reg dv2 skill_treat $controls2 if income_dummy==1, robust

*Column 2
reg dv2 skill_treat $controls2 if income_dummy==0, robust



******************
*Table 5
******************

*Column 1
reg dv1 religion_treat $controls1 if hindu_respondent==0, robust

*Column 2
reg dv1 religion_treat $controls1 if hindu_respondent==1, robust



******************
*Table 6 
******************


*Column 1
reg dv1 skill_treat religion_treat $controls1 if hindu_respondent==1, robust

*Column 2
reg dv1 i.skill_treat##i.religion_treat $controls1 if hindu_respondent==1, robust

*Column 3
reg dv1 skill_treat religion_treat $controls1 if hindu_respondent==0, robust

*Column 4
reg dv1 i.skill_treat##i.religion_treat $controls1 if hindu_respondent==0, robust



******************
*Table 7 
******************

*Column 1
reg dv1 religion_treat $controls1 if hindu_respondent==0 & politically_engaged==1, robust

*Column 2
reg dv1 religion_treat $controls1 if hindu_respondent==0 & politically_engaged==0, robust

*Column 3
reg dv1 religion_treat $controls1 if hindu_respondent==1 & politically_engaged==1, robust

*Column 4
reg dv1 religion_treat $controls1 if hindu_respondent==1 & politically_engaged==0, robust




******************
*Table 8
******************

*Column 1
reg dv3 religion_treat $controls1 if hindu_respondent==0, robust

*Column 2
reg dv3 religion_treat $controls1 if hindu_respondent==1, robust




******************
*Figure 1 
******************

gen incomexskill=skill_treat*income

gen MV=((_n)/1)
replace MV=. if _n>8

* Grab necessary elements of stored matrix
qui reg dv1 skill_treat income incomexskill, robust
matrix drop _all
scalar drop _all
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

gen conb=b1+b3*MV if _n <=8
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n <=8
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a
gen yline=0

*plot graph 
graph twoway hist income, width(1) percent color(gs14) yaxis(2)	///
		||	 line conb   MV, clpattern(solid) clwidth(medium) clcolor(blue) clcolor(black) yaxis(1)	///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   line yline  MV,  clwidth(thin) clcolor(black) clpattern(solid) ///
        ||   ,  ///
             xlabel(1 "< 5" 2 "5 - 10" 3 "10 - 20" 4 "20 - 30" 5 "30 - 40" 6 "40 - 50" 7 "50 - 10" 8 "> 100", valuelabel labsize(2.5)) ///
             ylabel(-0.25 0 0.25, axis(1) labsize(2.5)) ///
             ylabel(0 25 50, axis(2) nogrid labsize(2.5)) ///
             yscale(noline alt) ///
             yscale(noline alt axis(2))	///
             xscale(noline)	///
             legend(off) ///										
             yline(0, lcolor(black)) ///
             xtitle("Respondent income (000s Rupees/month)", size(3))	///
             xsca(titlegap(2)) ///
             ysca(titlegap(2)) ///
             ytitle("Marginal effect of migrant skill level (percentage points)", size(3)) ///
             ytitle("Percentage of observations (gray bars)", axis(2) size(3))	///
             scheme(scheme-tufte) graphregion(fcolor(white))










/**************************************************************************
**** Replication of results and tables in Supplementary Appendix ***********
**************************************************************************/


******************
*Table A3
******************

sum dv1
sum dv2
sum dv3
sum age
sum education_years
sum college_education2
sum income
sum hindu_respondent
sum female
sum born_mumbai
sum marathi_speaking 
sum ethnically_marathi
sum religious_strength_praying
sum prejudice_index
sum native_party_supporters



******************
*Table A4
******************

*Column 1
reg dv1 skill_treat, robust

*Column 2
reg dv1 skill_treat if hindu_respondent==0, robust

*Column 3
reg dv1 skill_treat if hindu_respondent==1, robust

*Column 4
reg dv1 skill_treat if income_dummy==0, robust

*Column 5
reg dv1 skill_treat if income_dummy==1, robust




******************
*Table A5
******************

*Column 1
reg dv1 religion_treat if hindu_respondent==0, robust

*Column 2
reg dv1 religion_treat if hindu_respondent==1, robust



******************
*Table A6
******************

*Column 1
probit dv1 skill_treat $controls1, robust
margins, dydx(*) atmeans

*Column 2
probit dv1 skill_treat $controls1 if hindu_respondent==0, robust
margins, dydx(*) atmeans

*Column 3
probit dv1 skill_treat $controls1 if hindu_respondent==1, robust
margins, dydx(*) atmeans

*Column 4
probit dv1 skill_treat $controls2 if income_dummy==0, robust
margins, dydx(*) atmeans

*Column 5
probit dv1 skill_treat $controls2 if income_dummy==1, robust
margins, dydx(*) atmeans


******************
*Table A7
******************

*Column 1
probit dv1 religion_treat $controls1 if hindu_respondent==0, robust
margins, dydx(*) atmeans

*Column 2
probit dv1 religion_treat $controls1 if hindu_respondent==1, robust
margins, dydx(*) atmeans



******************
*Table A8
******************

*Column 1
reg dv1 i.religion_treat##c.religious_strength_praying $controls1 if hindu_respondent==0

*Column 2
reg dv1 i.religion_treat##c.religious_strength_praying $controls1 if hindu_respondent==1


******************
*Table A9
******************

sum dv1 if native_party_supporters==0 & hindu_respondent==1
sum dv1 if native_party_supporters==1 & hindu_respondent==1
sum dv1 if native_party_supporters==0 & hindu_respondent==0
sum dv1 if native_party_supporters==1 & hindu_respondent==0


******************
*Table A10
******************

*NOTE: PLEASE SEE THE SECOND DO FILE, "Majority Minority Divide_AJPS_CATI.do"


******************
*Table A11
******************

*NOTE: PLEASE SEE THE SECOND DO FILE, "Majority Minority Divide_AJPS_CATI.do"


******************
*Table A12
******************

ttest how_secure, by(hindu_respondent) une
ttest wage_vary, by(hindu_respondent) une
ttest job_competition, by(hindu_respondent) une
ttest future_jobs, by(hindu_respondent) une



******************
*Table A14
******************

*Column 1
reg dv1 high_caste_hindu_treat if hindu_respondent==1

*Column 2
reg dv1 caste_match if hindu_respondent==1 & religion_treat==1

*Column 3
reg dv1 high_caste_muslim_treat if hindu_respondent==0

*Column 4
reg dv1 caste_match if hindu_respondent==0 & religion_treat==0



******************
*Table A15: Correlates of Nativism
******************

reg dv1 public_goods_av $controls1, robust















