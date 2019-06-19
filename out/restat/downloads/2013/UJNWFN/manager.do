clear
clear matrix
set memory 200m
set matsize 800
set more off

use managerdata, clear


***Variable generation

ge age2=age*age
ge logbonus2=log(1+bonus2)
ge logwage2=log(wage2)
ge logsize=log(asset)

***Define scope of job responsibilities
ge jobscope=sell+technical+office+finance+personnel

****Define aggregate decision rights
ge contscope=cright1+cright2+cright3+cright4

***Define interaction terms between family manager and firm performance and divisions
ge familyint1=family*roa
ge familyint2=family*ros
ge familyint3=family*profitpc

ge famsell=family*sell
ge famtechnical=family*technical
ge famoffice=family*office
ge famfinance=family*finance
ge fampersonnel=family*personnel


***Define interaction terms between relatives manager and firm performance 
ge noncoreint1=noncore*roa
ge noncoreint2=noncore*ros
ge noncoreint3=noncore*profitpc

***Define interaction terms between divisions and firm performance 
ge sellint1=sell*roa
ge sellint2=sell*ros
ge sellint3=sell*profitpc

ge technicalint1=technical*roa
ge technicalint2=technical*ros
ge technicalint3=technical*profitpc

ge officeint1=office*roa
ge officeint2=office*ros
ge officeint3=office*profitpc

ge financeint1=finance*roa
ge financeint2=finance*ros
ge financeint3=finance*profitpc

ge personnelint1=personnel*roa
ge personnelint2=personnel*ros
ge personnelint3=personnel*profitpc

ge shareint1=share*roa
ge shareint2=share*ros
ge shareint3=share*profitpc

ge levelint1=level*roa
ge levelint2=level*ros
ge levelint3=level*profitpc

ge jobint1=jobscope*roa
ge jobint2=jobscope*ros
ge jobint3=jobscope*profitpc

ge contint1=contscope*roa
ge contint2=contscope*ros
ge contint3=contscope*profitpc

ge sexint1=sex*roa
ge ageint1=age*roa
ge age2int1=age2*roa
ge collegeint1=college*roa
ge exp4int1=exp4*roa

ge sexint2=sex*ros
ge ageint2=age*ros
ge age2int2=age2*ros
ge collegeint2=college*ros
ge exp4int2=exp4*ros

ge sexint3=sex*profitpc
ge ageint3=age*profitpc
ge age2int3=age2*profitpc
ge collegeint3=college*profitpc
ge exp4int3=exp4*profitpc

***Define interactions between firm size and manager's characteristics 
ge famsize=family*logsize
ge sexsize=sex*logsize
ge agesize=age*logsize
ge age2size=age2*logsize
ge collegesize=college*logsize
ge exp4size=exp4*logsize
ge levelsize=level*logsize

****Herfindal index times 1000
replace hhi=hhi*1000

****Interactions of family manager dummy with H-index and firm performance
ge familyind=family*hhi
ge familyintd1=familyint1*hhi
ge familyintd2=familyint2*hhi
ge familyintd3=familyint3*hhi

capture log close
capture log using output_manager, replace

********************************************
***Table 1 descriptive Statistics

**Manager information

***General
su sex age college exp4 family noncore

***Compensation
su pay2 wage2 bonus2 share

***Position level
su level

***Decision rights
su cright1 cright2 cright3 cright4 contscope

***Job responsibilities

su personnel sell technical office finance jobscope


************Table 2
sort family

ttest sex, by(family) unequal
ttest age, by(family) unequal
ttest college, by(family) unequal
ttest exp4, by(family) unequal

ttest pay2, by(family) unequal
ttest wage2, by(family) unequal
ttest bonus2, by(family) unequal
ttest share, by(family) unequal

ttest level, by(family) unequal
ttest contscope, by(family) unequal
ttest jobscope, by(family) unequal

*******Table 3
******Note: familyint1==interactions of the family dummy with ROA
**********famiyint2==interaction with ROS, familyint3 == interaction with profits per employee 

xtreg logbonus2 family familyint1 sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint2 sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint3 sex age age2 college exp4 level, fe robust

xtreg logwage2 family familyint1 sex age age2 college exp4 level, fe robust
xtreg logwage2 family familyint2 sex age age2 college exp4 level, fe robust
xtreg logwage2 family familyint3 sex age age2 college exp4 level, fe robust


***Robustness check I: Controlling for the effect of shares on pay for performance

xtreg logbonus2 family familyint1 share sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint2 share sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint3 share sex age age2 college exp4 level, fe robust

xtreg logbonus2 family familyint1 share shareint1 sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint2 share shareint2 sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint3 share shareint3 sex age age2 college exp4 level, fe robust

**********Robustness check II: Interaction between managerial characteristics and performance

xtreg logbonus2 family familyint1 famsize sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint1 sex age age2 college exp4 level sexint1 ageint1 age2int1 collegeint1 exp4int1 levelint1, fe robust
xtreg logbonus2 family familyint1 famsize sex age age2 college exp4 level sexint1 ageint1 age2int1 collegeint1 exp4int1 levelint1, fe robust
xtreg logbonus2 family familyint1 famsize sex age age2 college exp4 level sexint1 ageint1 age2int1 collegeint1 exp4int1 levelint1 sexsize agesize age2size collegesize exp4size levelsize, fe robust

xtreg logbonus2 family familyint2 famsize sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint2 sex age age2 college exp4 level sexint2 ageint2 age2int2 collegeint2 exp4int2 levelint2, fe robust
xtreg logbonus2 family familyint2 famsize sex age age2 college exp4 level sexint2 ageint2 age2int2 collegeint2 exp4int2 levelint2, fe robust
xtreg logbonus2 family familyint2 famsize sex age age2 college exp4 level sexint2 ageint2 age2int2 collegeint2 exp4int2 levelint2 sexsize agesize age2size collegesize exp4size levelsize, fe robust
xtreg logbonus2 family familyint2 famsize sex age age2 college exp4 level sexsize agesize age2size collegesize exp4size levelsize, fe robust

xtreg logbonus2 family familyint3 famsize sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint3 sex age age2 college exp4 level sexint3 ageint3 age2int3 collegeint3 exp4int3 levelint3, fe robust
xtreg logbonus2 family familyint3 famsize sex age age2 college exp4 level sexint3 ageint3 age2int3 collegeint3 exp4int3 levelint3, fe robust
xtreg logbonus2 family familyint3 famsize sex age age2 college exp4 level sexint3 ageint3 age2int3 collegeint3 exp4int3 levelint3 sexsize agesize age2size collegesize exp4size levelsize, fe robust

xtreg logbonus2 family familyint2 famsize sex age age2 college exp4 level sexint2 ageint2 age2int2 collegeint2 exp4int2 levelint2, fe robust

*********Robustness check III: Interactions of job characteristics with firm performance

xtreg logbonus2 family familyint1  levelint1 sex age age2 college exp4 level, fe robust

xtreg logbonus2 family familyint2  levelint2 sex age age2 college exp4 level, fe robust

xtreg logbonus2 family familyint3  levelint3 sex age age2 college exp4 level, fe robust

xtreg logbonus2 family familyint1  jobint1 sex age age2 college exp4 jobscope, fe robust

xtreg logbonus2 family familyint2  jobint2 sex age age2 college exp4 jobscope, fe robust

xtreg logbonus2 family familyint3  jobint3 sex age age2 college exp4 jobscope, fe robust

xtreg logbonus2 family familyint1  contint1 sex age age2 college exp4 contscope, fe robust

xtreg logbonus2 family familyint2  contint2 sex age age2 college exp4 contscope, fe robust
xtreg logbonus2 family familyint2  contint3 sex age age2 college exp4 contscope, fe robust

xtreg logbonus2 family familyint1  contint1 jobint1 levelint1 sex age age2 college exp4 contscope jobscope level, fe robust

xtreg logbonus2 family familyint2  contint2 jobint2 levelint2 sex age age2 college exp4 contscope jobscope level, fe robust
xtreg logbonus2 family familyint3  contint3 jobint3 levelint3 sex age age2 college exp4 contscope jobscope level, fe robust

*********Robustness check IV: Control for departments and their interaction with family manager

xtreg logbonus2 family familyint1 sex age age2 college exp4 level technical sell personnel office finance, fe robust
xtreg logbonus2 family familyint2 sex age age2 college exp4 level technical sell personnel office finance, fe robust
xtreg logbonus2 family familyint3 sex age age2 college exp4 level technical sell personnel office finance, fe robust

xtreg logbonus2 family familyint1 sellint1 technicalint1 officeint1 financeint1 personnelint1 sex age age2 college exp4 level technical sell personnel office finance, fe robust
xtreg logbonus2 family familyint2 sellint2 technicalint2 officeint2 financeint2 personnelint2 sex age age2 college exp4 level technical sell personnel office finance, fe robust
xtreg logbonus2 family familyint3 sellint3 technicalint3 officeint3 financeint3 personnelint3 sex age age2 college exp4 level technical sell personnel office finance, fe robust


********Table 4 

xtreg logwage2 family sex age age2 college exp4 level, fe robust
xtreg logbonus2 family sex age age2 college exp4 level, fe robust

xtreg logwage2 family sex age age2 college exp4 level technical sell personnel office finance, fe robust
xtreg logbonus2 family sex age age2 college exp4 level technical sell personnel office finance, fe robust


********Table 5

xi: xtreg contscope family sex age age2 college exp4, fe robust
xi: xtreg jobscope family sex age age2 college exp4, fe robust
xi: xtreg level family sex age age2 college exp4, fe robust

xi: xtreg contscope family sex age age2 college exp4 level jobscope, fe robust
xi: xtreg jobscope family sex age age2 college exp4 level contscope, fe robust
xi: xtreg level family sex age age2 college exp4 jobscope contscope, fe robust

*********** Table 6

xtprobit cright1 family sex age age2 college exp4 level
margins, dydx(family) at((mean)_all)

xtprobit cright2 family sex age age2 college exp4 level
margins, dydx(family) at((mean)_all)

xtprobit cright3 family sex age age2 college exp4 level
margins, dydx(family) at((mean)_all)

xtprobit cright4 family sex age age2 college exp4 level 
margins, dydx(family) at((mean)_all)


xtprobit sell family sex age age2 college exp4 level 
margins, dydx(family) at((mean)_all)

xtprobit finance family sex age age2 college exp4 level
margins, dydx(family) at((mean)_all)

xtprobit technical family sex age age2 college exp4 level
margins, dydx(family) at((mean)_all)

xtprobit office family sex age age2 college exp4 level
margins, dydx(family) at((mean)_all)

xtprobit personnel family sex age age2 college exp4 level
margins, dydx(family) at((mean)_all)


*********Table 7

xtreg logbonus2 family familyint1 noncore noncoreint1 sex age age2 college exp4 level, fe robust
xtreg logbonus2 family noncore sex age age2 college exp4 level, fe robust
xtreg logwage2 family noncore sex age age2 college exp4 level, fe robust
xi: xtreg share family noncore sex age age2 college exp4 level, fe robust
xi: xtreg level family noncore sex age age2 college exp4, fe robust
xi: xtreg contscope family noncore sex age age2 college exp4 level, fe robust
xi: xtreg jobscope family noncore sex age age2 college exp4 level, fe robust


*************Table 8

xtreg logbonus2 family familyint1 familyind familyintd1 sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint2 familyind familyintd2 sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyint3 familyind familyintd3 sex age age2 college exp4 level, fe robust

xtreg logwage2 family familyind sex age age2 college exp4 level, fe robust
xtreg logbonus2 family familyind sex age age2 college exp4 level, fe robust
xi: xtreg share family familyind sex age age2 college exp4 level, fe robust

xi: xtreg contscope family familyind sex age age2 college exp4 level, fe robust
xi: xtreg jobscope family familyind sex age age2 college exp4 level, fe robust
xi: xtreg level family familyind sex age age2 college exp4, fe robust

xtreg logwage2 family familyind sex age age2 college exp4 level technical sell personnel office finance, fe robust
xtreg logbonus2 family familyind sex age age2 college exp4 level technical sell personnel office finance, fe robust
xtreg share family familyind sex age age2 college exp4 level technical sell personnel office finance, fe robust

**********The code for Table 9 is contained in the other do-file running on the firm-level data

**********Table 10: Subsample: family-firms vs. non-family-firms

xtreg logwage2 family sex age age2 college exp4 level if succeed2==1, fe robust
xtreg logwage2 family sex age age2 college exp4 level if succeed2==0, fe robust

xtreg logbonus2 family sex age age2 college exp4 level if succeed2==1, fe robust
xtreg logbonus2 family sex age age2 college exp4 level if succeed2==0, fe robust

xtreg share family sex age age2 college exp4 level if succeed2==1, fe robust
xtreg share family sex age age2 college exp4 level if succeed2==0, fe robust

xtreg level family sex age age2 college exp4 if succeed2==1, fe robust
xtreg level family sex age age2 college exp4 if succeed2==0, fe robust

xtreg contscope family sex age age2 college exp4 level if succeed2==1, fe robust
xtreg contscope family sex age age2 college exp4 level if succeed2==0, fe robust

xtreg jobscope family sex age age2 college exp4 level if succeed2==1, fe robust
xtreg jobscope family sex age age2 college exp4 level if succeed2==0, fe robust


*********Table 11

xtreg logbonus2 family familyint1 sex age age2 college exp4 level if succeed2==1, fe robust

xtreg logbonus2 family familyint1 sex age age2 college exp4 level if succeed2==0, fe robust

xtreg logbonus2 family familyint2 sex age age2 college exp4 level if succeed2==1, fe robust

xtreg logbonus2 family familyint2 sex age age2 college exp4 level if succeed2==0, fe robust

xtreg logbonus2 family familyint3 sex age age2 college exp4 level if succeed2==1, fe robust

xtreg logbonus2 family familyint3 sex age age2 college exp4 level if succeed2==0, fe robust

*********Table A1

drop if family==1
sort noncore

ttest sex, by(noncore) unequal
ttest age, by(noncore) unequal
ttest college, by(noncore) unequal
ttest exp4, by(noncore) unequal

ttest pay2, by(noncore) unequal
ttest wage2, by(noncore) unequal
ttest bonus2, by(noncore) unequal
ttest share, by(noncore) unequal

ttest level, by(noncore) unequal
ttest jobscope, by(noncore) unequal
ttest contscope, by(noncore) unequal



log close
translate output_manager.smcl output_manager.log, replace



