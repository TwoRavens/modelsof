/* Replication codes for 
Violence Exposure and Support for State Use of Force in a Non-Democracy
Yue Hou, Kai Quek
Journal of Experimental Political Science
This Version: July 31, 2018
*/


*********************
* Loading the Dataset
*********************

*cd /Users/yuehou/Dropbox/Yue-Kai/ReplicationFiles
log using replication_violence.txt, replace text
clear 
set more off

use HouQuek_JEPS_final.dta, clear
* We recruited 1,357 respondents. We dropped those who spent too long to finish the survey and who gave inconsistent answers about their ethnicity. 
* After these adjustments, the dataset has 1322 observations.


tab group,gen(groupnum)
tab ethnicity
* 93.5% are Han Chinese, 2.5% are Muslim Chinese, 4% comes from other groups.
tab execution if groupnum1==1
* public support for execution in the control group. 9.44% strongly agree and 28.76% somewhat agree with the policy.

*********************
* Analysis
*********************

* Group0: Control 
* Group1: Ethnicity prime
* Group2: Kunming (Violence-Uyghur)
* Group3: Chengdu (Violence-Han1)
* Group4: Changsha (Violence-Han2)

* TABLE 1: Main Effects
gen violence_pool=1
replace violence_pool=. if ethnic_prime==1
replace violence_pool=0 if ethnic_prime==0
ttest execution if ethnicity==1,by(violence_pool) une
ttest execution if ethnicity==1,by(kunming_event) une
ttest execution if ethnicity==1,by(chengdu_event) une
ttest execution if ethnicity==1,by(changsha_event) une
ttest execution if ethnicity==1,by(ethnic_prime) une

* TABLE 2: Paired Group Comparisons
gen KC_Kunming=0
replace KC_Kunming=1 if groupnum3==1
* Diff-in-means: Uyghur vs. Han1
ttest execution if ethnicity==1&(groupnum3==1|groupnum4==1),by(KC_Kunming) une
* Uyghur vs. Han2
ttest execution if ethnicity==1&(groupnum3==1|groupnum5==1),by(KC_Kunming) une



**********************
* Analysis in Appendix
**********************

* Table A1: Summary Stats, Column 2.
sum male age edu income CCP married college postgrad
tab ethnicity
 
* Table A2: Randomization Checks 
reg groupnum2 male age  married CCP i.edu i.region i.income 
testparm male age i(1/34).region i(1/15).income married i(1/7).edu CCP
*outreg2 using terror_balance.xls,replace
reg groupnum3 male age  married CCP i.edu i.region i.income 
testparm male age i(1/34).region i(1/15).income married i(1/7).edu CCP
*outreg2
reg groupnum4 male age  married CCP i.edu i.region i.income 
testparm male age i(1/34).region i(1/15).income married i(1/7).edu CCP
*outreg2
reg groupnum5 male age  married CCP i.edu i.region i.income 
testparm male age i(1/34).region i(1/15).income married i(1/7).edu CCP
*outreg2

* Table A3: OLS (Robustness Checks)
reg execution violence_pool male age college married CCP income_high i.region if ethnicity==1,r
*outreg2 using terror_kunming.xls,replace
reg execution kunming_event male age college married CCP income_high i.region if ethnicity==1,r
*outreg2
reg execution chengdu_event male age college married CCP income_high i.region if ethnicity==1,r
*outreg2
reg execution changsha_event male age college married CCP income_high i.region if ethnicity==1,r
*outreg2
reg execution ethnic_prime male age college married CCP income_high i.region if ethnicity==1,r
*outreg2

* Table A4: Ordered Logit (Robustness Check)
ologit execution violence_pool male age college married CCP income_high i.region if ethnicity==1,r
*outreg2 using terror_ologit.xls,replace
ologit execution kunming_event male age college married CCP income_high i.region if ethnicity==1,r
*outreg2
ologit execution chengdu_event male age college married CCP income_high i.region if ethnicity==1,r
*outreg2
ologit execution changsha_event male age college married CCP income_high i.region if ethnicity==1,r
*outreg2
ologit execution ethnic_prime male age college married CCP income_high i.region if ethnicity==1,r
*outreg2

* Table A5: CATE
ttest execution if ethnicity==1&income_high==1,by(violence_pool) une
ttest execution if ethnicity==1&income_high==0,by(violence_pool) une
ttest execution if ethnicity==1&CCP==1,by(violence_pool) une
ttest execution if ethnicity==1&CCP==0,by(violence_pool) une
ttest execution if ethnicity==1&college==1,by(violence_pool) une
ttest execution if ethnicity==1&college==0,by(violence_pool) une
ttest execution if ethnicity==1&male==1,by(violence_pool) une
ttest execution if ethnicity==1&male==0,by(violence_pool) une

log close
