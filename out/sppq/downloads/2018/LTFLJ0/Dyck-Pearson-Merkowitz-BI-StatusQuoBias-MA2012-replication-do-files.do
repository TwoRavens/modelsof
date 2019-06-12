*CODE for data recodes and models on 2012 MA Data*
*Dyck and Pearson-Merkowitz SPPQ* 
*"Ballot Initiatives and Status Quo Bias"

use "Dyck-Pearson-Merkowitz-BI-StatusQuoBias-MA2012-replication-data_v13.dta", clear 

lab define yesno 0 "no" 1 "yes" 

***QUESTION 1***
gen prop1v1=. 
replace prop1v1=0 if bal1v1==2
replace prop1v1=1 if bal1v1==1
lab var prop1v1 "Question 1 Right to Repair Control" 
lab val prop1v1 yesno

gen prop1v2=. 
replace prop1v2=0 if bal1v2==2
replace prop1v2=1 if bal1v2==1
lab var prop1v2 "Question 1 Right to Repair Yes Cue" 
lab val prop1v2 yesno

gen prop1v3=. 
replace prop1v3=0 if bal1v3==2
replace prop1v3=1 if bal1v3==1
lab var prop1v3 "Question 1 Right to Repair No Cue" 
lab val prop1v3 yesno


***QUESTION 2***
gen prop2v1=. 
replace prop2v1=0 if bal2v1==2
replace prop2v1=1 if bal2v1==1
lab var prop2v1 "Question 2 Assisted Suicide" 
lab val prop2v1 yesno

gen prop2v2=. 
replace prop2v2=0 if bal2v2==2
replace prop2v2=1 if bal2v2==1
lab var prop2v2 "Question 2 Assisted Suicide Yes Cue" 
lab val prop2v2 yesno

gen prop2v3=. 
replace prop2v3=0 if bal2v3==2
replace prop2v3=1 if bal2v3==1
lab var prop2v3 "Question 2 Assisted Suicide No Cue" 
lab val prop2v3 yesno


***QUESTION 3***
gen prop3v1=. 
replace prop3v1=0 if bal3v1==2
replace prop3v1=1 if bal3v1==1
lab var prop3v1 "Question 3 Medical Marijuana" 
lab val prop3v1 yesno

gen prop3v2=. 
replace prop3v2=0 if bal3v2==2
replace prop3v2=1 if bal3v2==1
lab var prop3v2 "Question 3 Medical Marijuana Yes Cue" 
lab val prop3v2 yesno

gen prop3v3=. 
replace prop3v3=0 if bal3v3==2
replace prop3v3=1 if bal3v3==1
lab var prop3v3 "Question 3 Medical Marijuana No Cue" 
lab val prop3v3 yesno

gen prop1all=.
replace prop1all=prop1v1 if prop1all==.
replace prop1all=prop1v2 if prop1all==.
replace prop1all=prop1v3 if prop1all==.

gen prop2all=.
replace prop2all=prop2v1 if prop2all==.
replace prop2all=prop2v2 if prop2all==.
replace prop2all=prop2v3 if prop2all==.

gen prop3all=.
replace prop3all=prop3v1 if prop3all==.
replace prop3all=prop3v2 if prop3all==.
replace prop3all=prop3v3 if prop3all==.

lab define yesnodk 0 "no" 1 "don't know" 2 "yes" 

*PROP1*
gen prop1dk=.
replace prop1dk=2 if bal1v1==1
replace prop1dk=2 if bal1v2==1
replace prop1dk=2 if bal1v3==1

replace prop1dk=1 if bal1v1==8
replace prop1dk=1 if bal1v2==8
replace prop1dk=1 if bal1v3==8

replace prop1dk=1 if bal1v1==9
replace prop1dk=1 if bal1v2==9
replace prop1dk=1 if bal1v3==9

replace prop1dk=0 if bal1v1==2
replace prop1dk=0 if bal1v2==2
replace prop1dk=0 if bal1v3==2

*PROP2*
gen prop2dk=.
replace prop2dk=2 if bal2v1==1
replace prop2dk=2 if bal2v2==1
replace prop2dk=2 if bal2v3==1

replace prop2dk=1 if bal2v1==8
replace prop2dk=1 if bal2v2==8
replace prop2dk=1 if bal2v3==8

replace prop2dk=1 if bal2v1==9
replace prop2dk=1 if bal2v2==9
replace prop2dk=1 if bal2v3==9

replace prop2dk=0 if bal2v1==2
replace prop2dk=0 if bal2v2==2
replace prop2dk=0 if bal2v3==2

*PROP3*
gen prop3dk=.
replace prop3dk=2 if bal3v1==1
replace prop3dk=2 if bal3v2==1
replace prop3dk=2 if bal3v3==1

replace prop3dk=1 if bal3v1==8
replace prop3dk=1 if bal3v2==8
replace prop3dk=1 if bal3v3==8

replace prop3dk=1 if bal3v1==9
replace prop3dk=1 if bal3v2==9
replace prop3dk=1 if bal3v3==9

replace prop3dk=0 if bal3v1==2
replace prop3dk=0 if bal3v2==2
replace prop3dk=0 if bal3v3==2

lab values prop1dk yesnodk
lab values prop2dk yesnodk
lab values prop2dk yesnodk

***CONTROL VARIABLE RECODES***

gen party7=.
replace party7=1 if (pid==1 & pidstr==1)
replace party7=2 if (pid==1 & pidstr==2)
replace party7=2 if (pid==1 & pidstr==8)
replace party7=2 if (pid==1 & pidstr==9)
replace party7=3 if (pid==3 & pidln==1)
replace party7=4 if (pid==3 & pidln==3)
replace party7=4 if (pid==3 & pidln==8)
replace party7=4 if (pid==3 & pidln==9)
replace party7=5 if (pid==3 & pidln==2)
replace party7=6 if (pid==2 & pidstr==2)
replace party7=6 if (pid==2 & pidstr==8)
replace party7=6 if (pid==2 & pidstr==9)
replace party7=7 if (pid==2 & pidstr==1)

rename party7 party7_4a
lab define pid7 1 "Str Dem" 2 "Weak Dem" 3 "Ind Lean D" 4 "Pure Ind" 5 "Ind Lean R" 6 "Weak Rep" 7 "Str Rep"
lab val party7_4a pid7

gen ideos_4a=ideos-1
replace ideos_4a=. if ideos==8
replace ideos_4a=. if ideos==9

gen ideof_4a=ideof-1
replace ideof_4a=. if ideof==8
replace ideof_4a=. if ideof==9

lab define ideology 0 "Liberal" 1 "Moderate" 2 "Conservative" 
lab val ideos_4a ideology
lab val ideof_4a ideology

gen educ_4a=educ2
replace educ_4a=. if educ_4a==9

gen income_4a=income
replace income_4a=. if income==8
replace income_4a=. if income==9

gen gender_4a=sex
replace gender_4a=0 if gender_4a==1
replace gender_4a=1 if gender_4a==2

recode q4a (1=0 "certain of senate choice") (2 9 . = 1 "uncertain of senate choice"), gen(senuncertain)
replace senuncertain=. if reg~=1

***********************************
***ANALYSIS************************
***********************************

**CODE USED TO GENERATE FIGURE 1**

graph bar (mean) prop1all [pweight = formweight], over(form)
graph bar (mean) prop2all [pweight = formweight], over(form)
graph bar (mean) prop3all [pweight = formweight], over(form)

**Weighted significance tests calculated through the following code (also Figure 1)**

svyset [pweight=formweight]
svy: mean prop1all, over(form)
test[prop1all]_subpop_1=[prop1all]_subpop_2
test[prop1all]_subpop_1=[prop1all]_subpop_3

svy: mean prop2all, over(form)
test[prop2all]_subpop_1=[prop2all]_subpop_2
test[prop2all]_subpop_1=[prop2all]_subpop_3

svy: mean prop3all, over(form)
test[prop3all]_subpop_1=[prop3all]_subpop_2
test[prop3all]_subpop_1=[prop3all]_subpop_3

**CODE USED TO GENERATE TABLE 4 AND FIGURE 4**

svyset [pweight=formweight]
svy: mlogit prop1dk senuncertain party7_4a ideos_4a ideof_4a educ_4a gender_4a formb formc, b(2)

margins, at(senuncertain=(0 1)) predict(outcome(0))
marginsplot, recast(scatter)

margins, at(senuncertain=(0 1)) predict(outcome(1))
marginsplot, recast(scatter)

margins, at(senuncertain=(0 1)) predict(outcome(2))
marginsplot, recast(scatter)

svy: mlogit prop2dk senuncertain party7_4a ideos_4a ideof_4a educ_4a gender_4a formb formc, b(2) 

margins, at(senuncertain=(0 1)) predict(outcome(0))
marginsplot, recast(scatter)

margins, at(senuncertain=(0 1)) predict(outcome(1))
marginsplot, recast(scatter)

margins, at(senuncertain=(0 1)) predict(outcome(2))
marginsplot, recast(scatter)

svy: mlogit prop3dk senuncertain party7_4a ideos_4a ideof_4a educ_4a gender_4a formb formc, b(2)

margins, at(senuncertain=(0 1)) predict(outcome(0))
marginsplot, recast(scatter)

margins, at(senuncertain=(0 1)) predict(outcome(1))
marginsplot, recast(scatter)

margins, at(senuncertain=(0 1)) predict(outcome(2))
marginsplot, recast(scatter)

**CODE USED TO GENERATE APPENDIX TABLE A2**

svyset [pweight=formweight]
svy: logit prop1all party7_4a ideos_4a ideof_4a educ_4a gender_4a formb formc
margins, at(educ_4a=(1 8))
margins, at(formb=(0 1))
margins, at(formc=(0 1))


svy: logit prop2all party7_4a ideos_4a ideof_4a educ_4a gender_4a formb formc
margins, at(ideos_4a=(0 2))
margins, at(ideof_4a=(0 2))
margins, at(educ_4a=(1 8))
margins, at(gender_4a=(0 1))
margins, at(formc=(0 1))


svy: logit prop3all party7_4a ideos_4a ideof_4a educ_4a gender_4a formb formc
margins, at(ideos_4a=(0 2))
margins, at(formc=(0 1))

**CODE USED TO GENERATE APPENDIX TABLE A4**

svyset [pweight=formweight]
svy: logit prop1all senuncertain party7_4a ideos_4a ideof_4a educ_4a gender_4a formb formc
svy: logit prop2all senuncertain party7_4a ideos_4a ideof_4a educ_4a gender_4a formb formc
svy: logit prop3all senuncertain party7_4a ideos_4a ideof_4a educ_4a gender_4a formb formc
