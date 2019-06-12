**** Physiology of Framing Effects Replication Code *****
*use "PhysFraming_ReplicationData.dta"


**** Creating the dichotmous variable for threat sensitivity ****
** Finding the median of our threat variable **
summarize threat, detail

** median of threat = .0271799 **
** generating the binary variable for threat **
gen bithreat = .
replace bithreat = 0 if threat < .0271799
replace bithreat = 1 if threat > .0271799


********** Results ********** 

****  Page 6, in text analysis of difference between participants who took the survey portion first and the physiological portion first ****
ttest kkktoleran, by(survey)

**** Figure 1  (Replication of Nelson, Clawson, and Oxley) ****
ttest kkktoleran, by(condition)

**** Figure 2 (Difference between Low and High Threat Sensitivity by Frames) ****
**** Figure 2A: Free Speech ****
ttest kkktoleran if condition == 0, by(bithreat)

**** Figure 2B: Public Order ****
ttest kkktoleran if condition == 1, by(bithreat)


********** Appendix ********** 

**** Appendix A ****
** Gender **
tab female

** Age **
tab age

** Class Standing **
tab class
 
** Race **
tab race

** Ideology **
tab ideo

** Party Identification **
tab pid7

** SCL Change from Threat Stimuli **
summarize threat, detail


**** Appendix D ****
** Balance Checks **
pstest bithreat female hispanic asian white ideo pid7, treat(condition) raw


**** Appendix E ****

**** Table 1 ****
** Model 1 **
ologit kkktoleran condition

** Model 2 **
ologit kkktoleran condition bithreat

** Create interaction variable **
gen framebithreat = condition*bithreat

** Model 3 **
ologit kkktoleran condition bithreat framebithreat

** Creating dummy variables for conditions ** 
* Free Speech - Low Threat *
gen FSL = 0
replace FSL = 1 if condition == 0 & bithreat == 0 
* Free Speech - High Threat *
gen FSH = 0
replace FSH = 1 if condition == 0 & bithreat == 1
* Public Order - Low Threat *
gen POL = 0
replace POL = 1 if condition == 1 & bithreat == 0
* Public Order - High Threat *
gen POH = 0
replace POH = 1 if condition == 1 & bithreat == 1

**** Table 2 ****
** Model 1 **
ologit kkktoleran POL POH FSL

** Model 2 **
ologit kkktoleran POL POH FSL female age hispanic asian white pid7 ideo



**** Table 3 ****
** Model 1 **
ologit kkktoleran condition bithreat

** Model 2 **
ologit kkktoleran condition bithreat female age hispanic asian white pid7 ideo

** Model 3 **
ologit kkktoleran condition bithreat framebithreat

** Model 4 **
ologit kkktoleran condition bithreat framebithreat female age hispanic asian white pid7 ideo


**** Appendix F *****
** Correlations with threat sensitivity and demographic variables **

corr bithreat age
corr bithreat female
corr bithreat pid7
corr bithreat ideo
corr bithreat Extraversion
corr bithreat Agreeableness
corr bithreat Conscientiousness
corr bithreat EmotionalStability
corr bithreat OpentoExp


**** Appendix G ****
** Female **
ttest kkktoleran if female == 1, by(condition)

** Male **
ttest kkktoleran if female == 0, by(condition)

** Female High Threat Sensitivity **
ttest kkktoleran if female == 1 & bithreat == 1, by(condition)

** Female Low Threat Sensitivity **
ttest kkktoleran if female == 1 & bithreat == 0, by(condition)

** Male High Threat Sensitivity **
ttest kkktoleran if female == 0 & bithreat == 1, by(condition)

** Male Low Threat Sensitivity **
ttest kkktoleran if female == 0 & bithreat == 0, by(condition)

