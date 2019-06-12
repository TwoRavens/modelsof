
/************/
/* Replication file for JOP Dietrich, Mahmud, and Winters "Foreign Aid, Foreign Policy, and Government Legitimacy: Experimental Evidence from Bangladesh" */
/************/

*********************************
* TABLE 1: Perceived Origins of Health Clinic Financing 

* Overall: Move from 12 to 24 percent (=12 percentage points)
tab money_new branded if money_new!="", col chi2
* Among Previously Used from 26 to 40 (=14 pp)
tab money_new branded if money_new!="" & previous_use==1, col chi2
* Among Previously Aware (Excluding Previous Use) from 19 to 37 (= 18 pp)
tab money_new branded if money_new!="" & previous_aware==1 & previous_use==0, col chi2
* Among High Educated: Move from 21 to 44 percent (=23 percentage points)
tab money_new branded if money_new!="" & edu_31 >= 6, col chi2
**********************************


**********************************
* TABLE 2: Responses to Foreign Policy Questions
* Is U.S. Influence Positive?
ttest influence_us, by(branded)
ranksum influence_us, by(branded)
* Trade More with U.S. or Diversify?
ttest trade_us, by(branded)
ranksum trade_us, by(branded)
* UNPKO
ttest unpko_us, by(branded)
ranksum unpko_us, by(branded)
**********************************


**********************************
* TABLE 3: Heterogeneous Treatment Effects for Perceived Influence of U.S.
* Previous Awareness
ttest influence_us if previous_aware==1, by(branded)
ranksum influence_us if previous_aware==1, by(branded)
ttest influence_us if previous_aware==0, by(branded)
ranksum influence_us if previous_aware==0, by(branded)
* Education
ttest influence_us if edu_31 < 6 , by(branded)		
ranksum influence_us if edu_31 < 6 , by(branded)	
ttest influence_us if edu_31 >= 6 , by(branded)
ranksum influence_us if edu_31 >= 6 , by(branded)
* Note: for RI tests of differences in CATEs, consult .R file "CATEs"
***********************************


***********************************
* TABLE 4: Responses to Domestic Government Legitimacy Questions
*** National Government
ttest govt_17, by(branded)
ranksum govt_17, by(branded)
*** Local Government
ttest local_govt_17, by(branded)
ranksum local_govt_17, by(branded)
*** Index of Confidence in Seven Institutions (Gov't, Local Gov't, Local Leader, Political Party, Judiciary, Military, Police)
ttest conf_index, by(branded)
ranksum conf_index, by(branded)
*** Tax Morale -- No Sig Diff
ttest tax_morale, by(branded) 
ranksum tax_morale, by(branded) 
*** Gov't Corruption
ttest corrupted_35, by(branded)
ranksum corrupted_35, by(branded)
***********************************


***********************************
* TABLE 5: Heterogeneous Treatment Effects for Level of Confidence in Local Government
* Previous use
ttest local_govt_17 if previous_use==1, by(branded)
ranksum local_govt_17 if previous_use==1, by(branded)
ttest local_govt_17 if previous_use==0, by(branded)
ranksum local_govt_17 if previous_use==0, by(branded)
* Politically active 
ttest local_govt_17 if active_politics_45==2 | active_politics_45==3, by(branded)
ranksum local_govt_17 if active_politics_45==2 | active_politics_45==3, by(branded)
ttest local_govt_17 if active_politics_45==1, by(branded)
ranksum local_govt_17 if active_politics_45==1, by(branded)
* Education
ttest local_govt_17 if edu_31 < 6 , by(branded)		
ranksum local_govt_17 if edu_31 < 6 , by(branded)
ttest local_govt_17 if edu_31 >= 6 , by(branded)	
ranksum local_govt_17 if edu_31 >= 6 , by(branded)	

***********************************
***********************************




***********************************

*APPENDIX**************************
***********************************


***********************************
*Table A1 Balance Checks
ttest female, by(branded)
ttest age, by(branded)
ttest edu_31, by(branded)
ttest minority, by(branded)
ttest health_1, by(branded)
ttest previous_use, by(branded)
ttest previous_aware, by(branded)
***********************************


***********************************
*Table A2 Control Group knowledge of U.S. Funding
logit money_us previous_use previous_aware female age edu_31 minority income_32 qualitylife access_tv i.zila_code if branded==0
***********************************


***********************************
*Table A3 Responses to Commercial Questions 
ttest cocacola, by(branded)
ranksum cocacola, by(branded)

ttest apple, by(branded)
ranksum apple, by(branded)

ttest products_us_count, by(branded)
ranksum products_us_count, by(branded)
***********************************


***********************************
*Table A4 Regression-based Analysis

*use do file titled "RegressionBasedTests.R."
***********************************

***********************************
*Table A5b Cross-Tabs of US Influence Variable and Treatment
tab influence_us branded, col chi2


*Table A5b Cross-Tabs of Local Government Confidence Variable and Treatment
tab local_govt_17 branded, col chi2
***********************************


***********************************
*Table A6: CACEs for Perceived Influence of U.S.
* MC = Everyone Who Received Treatment; CT = Treated Members of Control Group
gen mc = 1
gen ct = branded==0 & money_us==1
replace mc = 0 if ct==0 & branded==0

* Generate Random Numbers 
set seed 1400000
gen n = uniform()

* Create a Local Variable with the Total N of Units Assigned to Treatment
qui tab branded if branded==1 
local n = `r(N)'

* Sort by Assignment to Treatment and Random Number
 * For One-Tenth of Units Assigned to Treatment, Reasssign Them to Control (MC=0)
sort branded n
by branded : replace mc = 0 if _n<`n'*0.1 & branded==1

ivregress 2sls influence_us (mc=branded) , robust

 *Redo for .15, 0.20 etc.
***********************************


***********************************
*Table A8: Replication of Table 1 for Women Only
tab money_new branded if money_new!="" & female==1, col chi2
tab money_new branded if money_new!="" & previous_use==1 & female==1, col chi2
tab money_new branded if money_new!="" & previous_aware==1 & previous_use==0 & female==1, col chi2
tab money_new branded if money_new!="" & edu_31 >= 6 & female==1, col chi2
***********************************


***********************************
*Table A9: Replication of Table 2 for Women Only
ttest influence_us if female==1, by(branded)
ranksum influence_us if female==1, by(branded)

ttest trade_us if female==1, by(branded)
ranksum trade_us if female==1, by(branded)

ttest unpko_us if female==1, by(branded)
ranksum unpko_us if female==1, by(branded)
***********************************


***********************************
*Table A10: Replication of Table A3 for Women Only
ttest cocacola if female==1, by(branded)
ranksum cocacola if female==1, by(branded)

ttest apple if female==1, by(branded)
ranksum apple if female==1, by(branded)

ttest products_us_count if female==1, by(branded)
ranksum products_us_count if female==1, by(branded)
***********************************



***********************************
*Table A11: Replication of Table 4 for Women Only
*** National Government
ttest govt_17 if female==1, by(branded)
ranksum govt_17 if female==1, by(branded)

*** Local Government
ttest local_govt_17 if female==1, by(branded)
ranksum local_govt_17 if female==1, by(branded)

*** Index of Confidence in Seven Institutions (Gov't, Local Gov't, Local Leader, Political Party, Judiciary, Military, Police)
ttest conf_index if female==1, by(branded)
ranksum conf_index if female==1, by(branded)

*** Tax Morale -- No Sig Diff
ttest tax_morale if female==1, by(branded) 
ranksum tax_morale if female==1, by(branded) 

*** Gov't Corruption
ttest corrupted_35 if female==1, by(branded)
ranksum corrupted_35 if female==1, by(branded)
***********************************



***********************************
*Table A12a: Treatment Effects on U.S. Influence for "Likely-to-be-Anti American Respondents"
*Profiles based on Asiabarometer data
gen predict_ABage = age>=40 & age <=59
gen predict_ABinc = income_32 >2 & income_32 <6
gen predict_ABsex = female==0
gen predict_ABeduc = edu_31==6
egen predict_AB = rowtotal(predict_AB*)

gen anti_us2=(predict_AB==3 | predict_AB==4)
ttest influence_us if anti_us2==0, by(branded)
ttest influence_us if anti_us2==1, by(branded)

*Profiles based on Pew data
gen predictage = age>=35 & age<=60
gen predictinc = income_32 >2 & income_32 <6
gen predictsex = female==0
gen prediceduc = edu_31>5
egen predict = rowtotal(predictage predictinc predictsex prediceduc)
gen anti_us=(predict==3 | predict==4)

*"Not-Likely-to-be-Anti American Respondents"
ttest influence_us if anti_us==0, by(branded)

*"Likely-to-be-Anti American Respondents"
ttest influence_us if anti_us==1, by(branded)

*Table A12b Explaining Attitudes towards the United States based on interaction of treatment and "predicted Anti-Americanism"
regress influence_us i.branded##c.predict_AB
***********************************



***********************************
*Figure A1 Treatment Effects on U.S. Influence Across Levels of "predicted anti-Americanism"
margins , dydx(branded) at(predict_AB=(0/4))
marginsplot

***********************************



