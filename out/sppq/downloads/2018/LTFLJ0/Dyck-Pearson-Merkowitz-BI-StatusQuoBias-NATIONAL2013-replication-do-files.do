*CODE for data recodes and models on 2013 National Data*
*Dyck and Pearson-Merkowitz SPPQ* 
*"Ballot Initiatives and Status Quo Bias"

use "Dyck-Pearson-Merkowitz-BI-StatusQuoBias-NATIONAL2013-replication-data_v13.dta", clear 

*RECODES*
lab define Q12 1 "very unlikely" 2 "sw unlikely" 3 "don't know" 4 "sw likely" 5 "very likely"

gen Q12all=.
replace Q12all=1 if Q12a==4
replace Q12all=2 if Q12a==3
replace Q12all=3 if Q12a==8
replace Q12all=4 if Q12a==2
replace Q12all=5 if Q12a==1

replace Q12all=1 if Q12b==4
replace Q12all=2 if Q12b==3
replace Q12all=3 if Q12b==8
replace Q12all=4 if Q12b==2
replace Q12all=5 if Q12b==1

replace Q12all=1 if Q12c==4
replace Q12all=2 if Q12c==3
replace Q12all=3 if Q12c==8
replace Q12all=4 if Q12c==2
replace Q12all=5 if Q12c==1

gen Q13all=.
replace Q13all=1 if Q13a==4
replace Q13all=2 if Q13a==3
replace Q13all=3 if Q13a==8
replace Q13all=4 if Q13a==2
replace Q13all=5 if Q13a==1

replace Q13all=1 if Q13b==4
replace Q13all=2 if Q13b==3
replace Q13all=3 if Q13b==8
replace Q13all=4 if Q13b==2
replace Q13all=5 if Q13b==1

replace Q13all=1 if Q13c==4
replace Q13all=2 if Q13c==3
replace Q13all=3 if Q13c==8
replace Q13all=4 if Q13c==2
replace Q13all=5 if Q13c==1

gen Q14all=.
replace Q14all=1 if Q14a==4
replace Q14all=2 if Q14a==3
replace Q14all=3 if Q14a==8
replace Q14all=4 if Q14a==2
replace Q14all=5 if Q14a==1

replace Q14all=1 if Q14b==4
replace Q14all=2 if Q14b==3
replace Q14all=3 if Q14b==8
replace Q14all=4 if Q14b==2
replace Q14all=5 if Q14b==1

replace Q14all=1 if Q14c==4
replace Q14all=2 if Q14c==3
replace Q14all=3 if Q14c==8
replace Q14all=4 if Q14c==2
replace Q14all=5 if Q14c==1

lab var Q12all "Sex Offender Restrictions Experiment"
lab var Q13all "Abortion 2nd Trimester Experiment" 
lab var Q14all "Prop 13 Experiment" 

lab val Q12all Q12
lab val Q13all Q12
lab val Q14all Q12

gen Q12all3=Q12all-1
gen Q13all3=Q13all-1
gen Q14all3=Q14all-1

gen knowhse=0
replace knowhse=1 if Q14==2

gen knowsen=0
replace knowsen=1 if Q15==1

gen knowspeaker=Q16acor

gen knowukpm=Q16bcor

gen knowchief=Q16ccor

gen knowall=knowhse+knowsen+knowspeaker+knowukpm+knowchief

recode pid7 (1=1 "strong dem") (2=2 "weak dem") (3=3 "lean dem") (4 8 = 4 "ind/dk") (5=5 "lean rep") (6=6 "weak rep") (7=7 "strong rep"), gen(party7)

recode ideo5 (1=1 "very liberal") (2=2 "liberal") (3 6=3 "moderate/not sure") (4=4 "conservative") (5=5 "very conservative"), gen(ideology5) 

recode gender (1=0 "male") (2=1 "female"), gen(gender2)

recode pew_prayer (1=1) (2=2) (3=3) (4=4) (5=5) (6/7=6) (8=8), gen(pewprayer)

recode pew_churatd (1=1) (2=2) (3=3) (4=4) (5=5) (6/7=6), gen(pewchurch)

pca pewprayer pewchurch pew_religi
predict religiosity 

***********************************
***ANALYSIS************************
***********************************

*FIGURE 2* 

**CODE USED TO GENERATE FIGURE 1**

graph bar (mean) Q12all3 [pweight=weight], over(form12)
graph bar (mean) Q13all3 [pweight=weight], over(form13)
graph bar (mean) Q14all3 [pweight=weight], over(form14)

**Weighted significance tests calculated through the following code (also Figure 1)**
svyset [pweight=weight]

svy: mean Q12all3, over(form12)
test[Q12all3]Control=[Q12all3]_subpop_2
test[Q12all3]Control=[Q12all3]_subpop_3

svy: mean Q13all3, over(form13)
test[Q13all3]Control=[Q13all3]_subpop_2
test[Q13all3]Control=[Q13all3]_subpop_3

svy: mean Q14all3, over(form14)
test[Q14all3]Control=[Q14all3]_subpop_2
test[Q14all3]Control=[Q14all3]_subpop_3

*TABLE 3 & FIGURE 3* 

*Q12 - Sex Offender Residency Restrictions*
mlogit Q12all party7 ideology5 educ gender2 religiosity knowall form12b form12c, b(5)
margins, at(knowall=(0(1)5)) predict(outcome(1))
marginsplot

margins, at(knowall=(0(1)5)) predict(outcome(3))
marginsplot

margins, at(knowall=(0(1)5)) predict(outcome(5))
marginsplot

*Q13 - 2nd Trimester Abortion*
mlogit Q13all party7 ideology5 educ gender2 religiosity knowall form13b form13c, b(5)
margins, at(knowall=(0(1)5)) predict(outcome(1))
marginsplot

margins, at(knowall=(0(1)5)) predict(outcome(3))
marginsplot

margins, at(knowall=(0(1)5)) predict(outcome(5))
marginsplot

*Q14 - 2/3 Budget Requirement*
mlogit Q14all party7 ideology5 educ gender2 religiosity knowall form14b form14c, b(5)
margins, at(knowall=(0(1)5)) predict(outcome(1))
marginsplot

margins, at(knowall=(0(1)5)) predict(outcome(3))
marginsplot

margins, at(knowall=(0(1)5)) predict(outcome(5))
marginsplot


*APPENDIX TABLE A3*
reg Q12all party7 ideology5 educ gender2 religiosity knowall i.form12, robust
reg Q13all party7 ideology5 educ gender2 religiosity knowall i.form13, robust
reg Q14all party7 ideology5 educ gender2 religiosity knowall i.form14, robust

*APPENDIX TABLE A5*

quietly: reg Q12all party7 ideology5 educ gender2 religiosity knowall i.form12, robust
estat ic

quietly: reg Q12all party7 ideology5 educ gender2 religiosity knowall i.form12##indum, robust
estat ic

quietly: reg Q13all party7 ideology5 educ gender2 religiosity knowall i.form13, robust
estat ic

quietly: reg Q13all party7 ideology5 educ gender2 religiosity knowall i.form13##indum, robust
estat ic

quietly: reg Q14all party7 ideology5 educ gender2 religiosity knowall i.form14, robust
estat ic

quietly: reg Q14all party7 ideology5 educ gender2 religiosity knowall i.form14##indum, robust
estat ic
