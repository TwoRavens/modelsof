clear all
clear mata
graph drop _all
mata: mata set matastrict off, permanently
program drop _all
macro drop _all
matrix drop _all
set more off
set memory 1G
set type double
set matsize 10000

global tab "se(%9.4f) b(%9.4f) r2(%9.2f) nogaps star(* 0.1 ** 0.05 *** 0.01) mtitles brackets"

********************************************************************************
******************** PUBLIC EMPLOYEES AS POLITICIANS ***************************
********************************************************************************

// This do-file replicates the tables in the main text of "Public Employees
// as Politicians: Evidence from Close Elections" by Hyytinen, Meriläinen, Saarimaa
// Toivanen and Tukiainen.

cd "path"
use "path\public_employees_as_politicians.dta", clear

********************************************************************************

* Table 1: Pre-treatment covariate balance at municipality-level

global pretreat "lagmeanexp lagmeanhealth1_4 lagmeanotherthanhealth lagmeanpopulation lagmeanyoung lagmeanold lagvaltuustoko lagKkuntat lagKhealth lagKotherthanhealth lagincumbents lagwomensh laghighp laguniversitys lagunemployeds"

sum $pretreat if v1munT10>0 & yearofterm==4
sum $pretreat if v1munT10<0 & yearofterm==4

gen treatment1=-1 if v1munT10<0
replace treatment1=1 if v1munT10>0
replace treatment1=. if v1munT10==0

// Test for differences
clttest lagmeanexp if yearofterm==4 & electionyear!=1996, by(treatment1) cluster(Kuntaid)
clttest lagmeanotherthanhealth if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagmeanhealth1_4 if yearofterm==4, by(treatment1) cluster(Kuntaid)	
clttest lagmeanpopulation if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagmeanyoung if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagmiddle if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagmeanold if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagvaltuustoko if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagKkuntat if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagKhealth if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagKotherthanhealth if yearofterm==4, by(treatment1) cluster(Kuntaid)	
clttest lagincumbents if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagwomensh if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest laghighp if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest laguniversitys if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest lagunemployeds if yearofterm==4, by(treatment1) cluster(Kuntaid)

********************************************************************************

* Table 2: Post-treatment council covariate balance

global posttreat "incumbentshare womensh highprofshare universityshare unemployedshare"

// Panel A: All municipal employees
sum $posttreat if v1munT10>0 & yearofterm==4
sum $posttreat if v1munT10<0 & yearofterm==4

clttest incumbentshare if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest womensh if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest highprofshare if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest universityshare if yearofterm==4, by(treatment1) cluster(Kuntaid)
clttest unemployedshare if yearofterm==4, by(treatment1) cluster(Kuntaid)

// Panel B: Health care employees
sum $posttreat if v1healthT10>0 & yearofterm==4
sum $posttreat if v1healthT10<0 & yearofterm==4

gen treatment2=-1 if v1healthT10<0
replace treatment2=1 if treatment2>0
replace treatment2=. if treatment2==0

clttest incumbentshare if yearofterm==4, by(treatment2) cluster(Kuntaid)
clttest womensh if yearofterm==4, by(treatment2) cluster(Kuntaid)
clttest highprofshare if yearofterm==4, by(treatment2) cluster(Kuntaid)
clttest universityshare if yearofterm==4, by(treatment2) cluster(Kuntaid)
clttest unemployedshare if yearofterm==4, by(treatment2) cluster(Kuntaid)

// Panel C: Other than health care employees
sum $posttreat if v1otherthanhealthT10>0 & yearofterm==4
sum $posttreat if v1otherthanhealthT10<0 & yearofterm==4

gen treatment3=-1 if v1otherthanhealthT10<0
replace treatment3=1 if v1otherthanhealthT10>0
replace treatment3=. if v1otherthanhealthT10==0

clttest incumbentshare if yearofterm==4, by(treatment3) cluster(Kuntaid)
clttest womensh if yearofterm==4, by(treatment3) cluster(Kuntaid)
clttest highprofshare if yearofterm==4, by(treatment3) cluster(Kuntaid)
clttest universityshare if yearofterm==4, by(treatment3) cluster(Kuntaid)
clttest unemployedshare if yearofterm==4, by(treatment3) cluster(Kuntaid)

********************************************************************************

* Table 3: Results for total expenditures: OLS and IV analysis with ε = 0

// Panel A: OLS

est clear
reg logmeanexp1_4 Kkuntatyontekija i.year if yearofterm==4 , cluster(Kuntaid)
estimates store model1
reg logmeanexp1_4 Kkuntatyontekija i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest if yearofterm==4, cluster(Kuntaid)
estimates store model2
reg logmeanexp1_4 Kkuntatyontekija i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, cluster(Kuntaid)
estimates store model3
reg logmeanexp1_4 Kkuntatyontekija v v2 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, cluster(Kuntaid)
estimates store model4
esttab model1 model2 model3 model4, $tab keep(Kkuntatyontekija)

// Panel B: IV, ε = 0

est clear	
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT0) i.year if yearofterm==4, first cluster(Kuntaid)
estimates store model1
			
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT0) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest if yearofterm==4, first cluster(Kuntaid)
estimates store model2
		
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT0) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopulation lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, first cluster(Kuntaid)
estimates store model3
			
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT0) v v2 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopulation lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, first cluster(Kuntaid)
estimates store model4
		
esttab model1 model2 model3 model4, $tab keep(Kkuntatyontekija)

// Panel C: Reduced form of IV, ε = 0

est clear	
	
reg logmeanexp1_4 v1munT0 i.year if yearofterm==4 , cluster(Kuntaid)
estimates store model1
			
reg logmeanexp1_4 v1munT0 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest if yearofterm==4, cluster(Kuntaid)
estimates store model2
		
reg logmeanexp1_4 v1munT0 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, cluster(Kuntaid)
estimates store model3	

reg logmeanexp1_4 v1munT0 v v2 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, cluster(Kuntaid)
estimates store model4
		
esttab model1 model2 model3 model4, $tab keep(v1*)

********************************************************************************

* Table 4: Results for total expenditures: IV analysis with ε= 0.4

// Panel A: IV, ε = 0.4

est clear	
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT10) i.year if yearofterm==4, first cluster(Kuntaid)
estimates store model1
			
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT10) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest if yearofterm==4, first cluster(Kuntaid)
estimates store model2
		
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT10) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, first cluster(Kuntaid)
estimates store model3	
			
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT10) v v2 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, first cluster(Kuntaid)
estimates store model4
		
esttab model1 model2 model3 model4, $tab keep(Kkuntatyontekija)

// Panel B: Reduced form of IV, ε = 0.4

est clear	
	
reg logmeanexp1_4 v1munT10 i.year if yearofterm==4 , cluster(Kuntaid)
estimates store model1
			
reg logmeanexp1_4 v1munT10 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest if yearofterm==4, cluster(Kuntaid)
estimates store model2
		
reg logmeanexp1_4 v1munT10 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, cluster(Kuntaid)
estimates store model3	
			
reg logmeanexp1_4 v1munT10 v v2 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4, cluster(Kuntaid)
estimates store model4
		
esttab model1 model2 model3 model4, $tab keep(v1*)

********************************************************************************

* Table 5: Heterogeneity in the total expenditures effect by council and party size

// Panel A: IV, ε= 0.4

est clear	

// Council size <= 27
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT10) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & councilsize<=27, cluster(Kuntaid)
estimates store model1	

// Council size > 27
xi: ivreg2 logmeanexp1_4 (Kkuntatyontekija=v1munT10) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & councilsize>27, cluster(Kuntaid)
estimates store model2

// Largest party
xi: ivreg2 logmeanexp1_4 (maxkuelvl=v1largestpartyT10) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & sumlargest==1, cluster(Kuntaid)
estimates store model3

// Second largest party
xi: ivreg2 logmeanexp1_4 (Kkuntat2=v12largestpartyT10) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & sumsecondlargest==1 & sumlargest==1, cluster(Kuntaid)
estimates store model4	

esttab model1 model2 model3 model4, $tab keep(Kkuntatyontekija maxkuelvl Kkuntat2)

// Panel B: Reduced form of IV, ε= 0.4

est clear	

// Council size <= 27
reg logmeanexp1_4 v1munT10 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & councilsize<=27, cluster(Kuntaid)
estimates store model1	

// Council size > 27
reg logmeanexp1_4 v1munT10 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & councilsize>27, cluster(Kuntaid)
estimates store model2	

// Largest party
reg logmeanexp1_4 v1largestpartyT10 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & sumlargest==1, cluster(Kuntaid)
estimates store model3

// Second largest party
reg logmeanexp1_4 v12largestpartyT10 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & sumsecondlargest==1 & sumlargest==1, cluster(Kuntaid)
estimates store model4

esttab model1 model2 model3 model4, $tab keep(v1*)

********************************************************************************

* Table 6: Results according to occupation and spending category

est clear

// Panel A: IV, ε = 0.4
xi: ivreg2 otherthanhealth (Kotherthanhealth Khealthcare=v1otherthanhealthT10 v1healthT10) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & logmeanhealth!=., first cluster(Kuntaid)
estimates store model1

xi: ivreg2 logmeanhealth1_4 (Kotherthanhealth Khealthcare=v1otherthanhealthT10 v1healthT10) i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & logmeanhealth!=., first cluster(Kuntaid)
estimates store model2

esttab  model1 model2, $tab keep(K*)

est clear	

// Panel B: Reduced form of IV, ε = 0.4
reg otherthanhealth v1otherthanhealthT10 v1healthT10 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & logmeanhealth!=., cluster(Kuntaid)
estimates store model1
	
reg logmeanhealth1_4 v1otherthanhealthT10 v1healthT10 i.year lagKkok lagKsdp lagKvihr lagKvl lagKrkp lagKps lagKkd lagKrest lagmeanpopu lagmeanpop2 lagmeanyoung lagmeanold if yearofterm==4 & logmeanhealth!=., cluster(Kuntaid)
estimates store model2
	
esttab  model1 model2, $tab keep(v1*)
