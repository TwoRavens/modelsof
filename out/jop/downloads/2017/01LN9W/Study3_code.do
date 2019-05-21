****************************************************************************************************
***  PROJECT:  "Language Influences Public Attitudes Toward Gender Equality," Journal of Politics
***  AUTHORS: Efren O. Perez and Margit Tavits
***  DESCRIPTION: Stata code to replicate analyses of Study 3.
***  DATE: October 22, 2017
****************************************************************************************************

*****************************************************
*** NON-DEFAULT PACKAGES:
*** outreg2 ("ssc install outreg2")
*****************************************************

*****************************************************
***Analyses using World Values Survey, Waves 3-6
*****************************************************

*********************************************************************************************
**MAKE SURE YOU ADD YOUR DIRECTORY INFORMATION TO FILE NAMES BEFORE YOUR RUN THIS CODE
*********************************************************************************************

clear
set more off

***Call up the Study3 dataset
***The Study 3 dataset is based on WVS_Longitudinal_1981_2014_stata_v2015_04_18.dta
***Downloaded from http://www.worldvaluessurvey.org/WVSDocumentationWVL.jsp on January 11, 2017
***The Study 3 dataset includes only those variables from the longitudinal data file that are used
***in the paper, and the data on gendered/genderless languages
***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME IN THE CODE BELOW
use "Study3_data.dta", clear

********************************************************************************************
***Code for generating the variables and performing the anaysis using all waves of WVS
********************************************************************************************

***Recode control variables
generate Sex=.
replace Sex =1 if X001==2
replace Sex =0 if X001==1
***1=female
label variable Sex "respondent sex, 1=female"

rename X003 Age
replace Age = . if Age == -1 
replace Age = . if Age == -2
replace Age = . if Age == -3
replace Age = . if Age == -4
replace Age = . if Age == -5
gen AgeCat = 10
replace AgeCat = 20 if Age > 19
replace AgeCat = 30 if Age > 29
replace AgeCat = 40 if Age > 39
replace AgeCat = 50 if Age > 49
replace AgeCat = 60 if Age > 59
replace AgeCat = 70 if Age > 69
replace AgeCat = 80 if Age > 79
replace AgeCat = 90 if Age > 89
label variable AgeCat "age in 10 year bins"

rename X007 MaritalStatus
replace  MaritalStatus = . if  MaritalStatus==-1
replace  MaritalStatus = . if  MaritalStatus==-2
replace  MaritalStatus = . if  MaritalStatus==-4
replace  MaritalStatus = . if  MaritalStatus==-5
replace  MaritalStatus = 0 if  MaritalStatus==2
replace  MaritalStatus = 0 if  MaritalStatus==3
replace  MaritalStatus = 0 if  MaritalStatus==4
replace  MaritalStatus = 0 if  MaritalStatus==5
replace  MaritalStatus = 0 if  MaritalStatus==6
replace  MaritalStatus = 0 if  MaritalStatus==7

rename X025 HighestEdu
replace  HighestEdu = . if  HighestEdu==-1
replace  HighestEdu = . if  HighestEdu==-2
replace  HighestEdu = . if  HighestEdu==-3
replace  HighestEdu = . if  HighestEdu==-4
replace  HighestEdu = . if  HighestEdu==-5

rename X028 EmploymentStat
replace EmploymentStat =. if EmploymentStat==-1
replace EmploymentStat =. if EmploymentStat==-2
replace EmploymentStat =. if EmploymentStat==-3
replace EmploymentStat =. if EmploymentStat==-4
replace EmploymentStat =. if EmploymentStat==-5

gen Unemployed = 0
replace Unemployed = 1 if EmploymentStat == 7
replace Unemployed =. if EmploymentStat ==.
label variable Unemployed "unemployed=1, employed=0"

rename X047 IncomeDecile
replace IncomeDecile = . if IncomeDecile==-1
replace IncomeDecile = . if IncomeDecile==-2
replace IncomeDecile = . if IncomeDecile==-4
replace IncomeDecile = . if IncomeDecile==-5

****Generate dependent variables
generate WomenJobs = C001
replace  WomenJobs = . if C001==-1
replace WomenJobs = . if C001==-2
replace WomenJobs = . if C001==-4
replace WomenJobs = . if C001==-5
replace WomenJobs = 1 if C001==2
replace WomenJobs = 1 if C001==3
replace WomenJobs = 0 if C001==1
***0=agree, 1=disagree or neither agree nor disagree
label variable WomenJobs "When jobs are scarce, men should have more right to a job than women; 1=disagree"


generate WomenPolLeaders = D059
replace WomenPolLeaders = . if D059==-1
replace WomenPolLeaders = . if D059==-2
replace WomenPolLeaders = . if D059==-4
replace WomenPolLeaders = . if D059==-5
***1=strongly agree that men make better political leaders than women do; 4=strongly disagree
label variable WomenPolLeaders "1=strongly agree that men make better political leaders than women do; 4=strongly disagree"

generate UnivGirl = D060
replace UnivGirl = . if D060==-1
replace UnivGirl = . if D060==-2
replace UnivGirl = . if D060==-4
replace UnivGirl = . if D060==-5
***1=strongly agree that university more important for a boy than a girl; 4=strongly disagree
label variable UnivGirl "1=strongly agree that university more important for a boy than a girl; 4=strongly disagree"

generate WomenBusExec = D078
replace WomenBusExec = . if D078==-1
replace WomenBusExec = . if D078==-2
replace WomenBusExec = . if D078==-4
replace WomenBusExec = . if D078==-5
***1=strongly agree that men make better business leaders; 4==strongly disagree
label variable WomenBusExec "1=strongly agree that men make better business leaders; 4==strongly disagree"

**********************************************
***Analyses
**********************************************

***Set country as the panel variable
iis S003

**********************************************
***Analyses reported in Table 3, main text
**********************************************

***xtreg and FE models, no controls
xtreg WomenPolLeader gpii i.S002, fe cluster (S003)
xtreg UnivGirl gpii i.S002, fe cluster (S003)
xtreg WomenBusExec gpii i.S002, fe cluster (S003)
logit WomenJobs gpii i.S002 i.S003, vce(cluster S003)

***xtreg and FE models, with controls
xtreg WomenPolLeader gpii i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
xtreg UnivGirl gpii i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
xtreg WomenBusExec gpii i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
logit WomenJobs gpii i.S002 i.S003 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, vce(cluster S003)

***Generate output for Table 3
xtreg WomenPolLeader gpii i.S002, fe cluster (S003)
outreg2 using "Table3", word dec(3) se replace keep(gpii) addtext (Country FE, YES, Wave FE, YES)
xtreg WomenPolLeader gpii i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
outreg2 using "Table3", word dec(3) se append keep(gpii Sex Age Unemployed MaritalStatus) addtext (Education, YES, Income, YES, Country FE, YES, Wave FE, YES)
xtreg UnivGirl gpii i.S002, fe cluster (S003)
outreg2 using "Table3", word dec(3) se append keep(gpii) addtext (Country FE, YES, Wave FE, YES)
xtreg UnivGirl gpii i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
outreg2 using "Table3", word dec(3) se append keep(gpii Sex Age Unemployed MaritalStatus) addtext (Education, YES, Income, YES, Country FE, YES, Wave FE, YES)
xtreg WomenBusExec  gpii i.S002, fe cluster (S003)
outreg2 using "Table3", word dec(3) se append keep(gpii) addtext (Country FE, YES, Wave FE, YES)
xtreg WomenBusExec  gpii i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
outreg2 using "Table3", word dec(3) se append keep(gpii Sex Age Unemployed MaritalStatus) addtext (Education, YES, Income, YES, Country FE, YES, Wave FE, YES)
logit WomenJobs gpii i.S002 i.S003, vce(cluster S003)
outreg2 using "Table3", word dec(3) se append keep(gpii) addtext (Country FE, YES, Wave FE, YES)
logit WomenJobs gpii i.S002 i.S003 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, vce(cluster S003)
outreg2 using "Table3", word dec(3) se append keep(gpii Sex Age Unemployed MaritalStatus) addtext (Education, YES, Income, YES, Country FE, YES, Wave FE, YES)


***Predicted probabilities for the logit model, reported in the main text
quietly logit WomenJobs i.gpii i.S002 i.S003 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, vce(cluster S003) nolog
margins gpii, atmeans
margins, dydx(gpii) atmeans

*****************************************************
***Descriptives reported in Table OA.7.2, online appendix
*****************************************************

xi: logit WomenJobs gpii i.S002 i.S003, vce(cluster S003)
predict p
summarize WomenJobs UnivGirl WomenBusExec WomenPolLeaders gpii Sex Age Unemployed IncomeDecile HighestEdu MaritalStatus if p!=.

*****************************************************
***Analyses reported in Table OA.7.2, online appendix
*****************************************************

xtreg WomenPolLeader i.gpii2 i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
xtreg UnivGirl i.gpii2 i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
xtreg WomenBusExec i.gpii2 i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
logit WomenJobs i.gpii2 i.S002 i.S003 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, vce(cluster S003)

***Generate output for Table OA.7.3
xtreg WomenPolLeader i.gpii2 i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
outreg2 using "Table_WVS_SI", word dec(3) se replace keep(i.gpii2 Sex Age Unemployed MaritalStatus) addtext (Education, YES, Income, YES, Country FE, YES, Wave FE, YES)
xtreg UnivGirl i.gpii2 i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
outreg2 using "Table_WVS_SI", word dec(3) se append keep(i.gpii2 Sex Age Unemployed MaritalStatus) addtext (Education, YES, Income, YES, Country FE, YES, Wave FE, YES)
xtreg WomenBusExec i.gpii2 i.S002 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, fe cluster (S003)
outreg2 using "Table_WVS_SI", word dec(3) se append keep(i.gpii2 Sex Age Unemployed MaritalStatus) addtext (Education, YES, Income, YES, Country FE, YES, Wave FE, YES)
logit WomenJobs i.gpii2 i.S002 i.S003 Sex Age Unemployed i.IncomeDecile i.HighestEdu MaritalStatus, vce(cluster S003)
outreg2 using "Table_WVS_SI", word dec(3) se append keep(i.gpii2 Sex Age Unemployed MaritalStatus) addtext (Education, YES, Income, YES, Country FE, YES, Wave FE, YES)



