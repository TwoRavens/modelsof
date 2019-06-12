/*****************************************************
**02_PerformBalancetests.do
**This performs balance tests on pretreatment covariates, which appear in the 
**Supplemental Appendix for
**"Institutional Sources of Legitimate Authority: An Experimental Investigation"
**Dickson, Gordon, Huber. AJPS, 2014.
**Input: sourcedata\subject_pretreatment_data.csv
**Output: output\AppendixTable01_Balance
**Last Updated: February 26, 2014
******************************************************/


clear
insheet using "sourcedata\subject_pretreatment_data.csv", comma names

gen salary = substr(treatment,1,3)=="Sal"
gen loinfo = treatment == "AppropNoInfo"  | treatment == "SalaryNoInfo"
gen fiveormore = minexperience>=5&minexperience!=.
gen male = sex=="M"

matrix results =J(12,3,.)

ttest male if loinfo==0, by(salary) unequal
matrix results[1,1] = r(mu_1)
matrix results[1,2] = r(mu_2)
matrix results[1,3] = r(p)

ttest age if loinfo==0, by(salary) unequal
matrix results[2,1] = r(mu_1)
matrix results[2,2] = r(mu_2)
matrix results[2,3] = r(p)

ttest fiveormore if loinfo==0, by(salary) unequal
matrix results[3,1] = r(mu_1)
matrix results[3,2] = r(mu_2)
matrix results[3,3] = r(p)

ttest male if loinfo==1, by(salary) unequal
matrix results[4,1] = r(mu_1)
matrix results[4,2] = r(mu_2)
matrix results[4,3] = r(p)

ttest age if loinfo==1, by(salary) unequal
matrix results[5,1] = r(mu_1)
matrix results[5,2] = r(mu_2)
matrix results[5,3] = r(p)

ttest fiveormore if loinfo==1, by(salary) unequal
matrix results[6,1] = r(mu_1)
matrix results[6,2] = r(mu_2)
matrix results[6,3] = r(p)

ttest male if salary==1, by(loinfo) unequal
matrix results[7,1] = r(mu_1)
matrix results[7,2] = r(mu_2)
matrix results[7,3] = r(p)

ttest age if salary==1, by(loinfo) unequal
matrix results[8,1] = r(mu_1)
matrix results[8,2] = r(mu_2)
matrix results[8,3] = r(p)

ttest fiveormore if salary==1, by(loinfo) unequal
matrix results[9,1] = r(mu_1)
matrix results[9,2] = r(mu_2)
matrix results[9,3] = r(p)

ttest male if salary==0, by(loinfo) unequal
matrix results[10,1] = r(mu_1)
matrix results[10,2] = r(mu_2)
matrix results[10,3] = r(p)

ttest age if salary==0, by(loinfo) unequal
matrix results[11,1] = r(mu_1)
matrix results[11,2] = r(mu_2)
matrix results[11,3] = r(p)

ttest fiveormore if salary==0, by(loinfo) unequal
matrix results[12,1] = r(mu_1)
matrix results[12,2] = r(mu_2)
matrix results[12,3] = r(p)

outtable using output\AppendixTable01_Balance, mat(results) format(%9.2g) nobox replace

