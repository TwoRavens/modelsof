clear
cd "C:\Dropbox\AJPS replication files"
use "desante_experimental_data.dta"

gen NAMES = .
replace NAMES=0 if treatment== 1 | treatment == 5 | treatment ==9
replace NAMES=1 if treatment== 2 | treatment == 6 | treatment ==10
replace NAMES=2 if treatment== 3 | treatment == 7 | treatment ==11
replace NAMES=3 if treatment== 4 | treatment == 8 | treatment ==12

gen WORK = .
replace WORK = 0 if treatment== 1 | treatment == 2 | treatment ==3 | treatment ==4
replace WORK = 1 if treatment== 5 | treatment == 6 | treatment ==7 | treatment ==8
replace WORK = 2 if treatment== 9 | treatment == 10 | treatment ==11 | treatment ==12

anova app1 NAMES WORK NAMES#WORK

*test 1:
gen t12=0 if treatment==1
replace t12=1 if treatment==2
ttest app1, by(t12)
***************************
* test 2:
ttest app2, by(t12)
***********************

*Test Three - AJPS
gen t710 = 0 if treatment==7
replace t710=1 if treatment==10
ttest app1, by(t710)
* Nonsignificant

*Test 4 - AJPS
gen t47=0 if treatment==4
replace t47=1 if treatment==7
ttest app2, by(t47)
*Nonsignificant

*Test 5 - AJPS
gen t46 = 0 if treatment==4
replace t46 = 1 if treatment==6
ttest app2, by(t46)

*Test 6 - AJPS
gen t79 = 0 if treatment==7
replace t79 = 1 if treatment==9
ttest app2, by(t79)

*Test 7 - AJPS
gen t69 = 0 if treatment==6
replace t69 = 1 if treatment==9
ttest app2, by(t69)

*More conservative approach:
*ttesti n1 m1 sd1 n2 m2 sd2
*sds = apprx: sqrt(n) * se
*sd1 = 477 = sqrt(167)* 36.88
*sd2 = 542 = sqrt(203)* 38.07
*m1, n1 = -123, 167, 
*m2, n2 = -7, 203

ttesti 167 -123.42 477 203 -7 542

*********************************

*Test 8 - AJPS
gen t45 = 0 if treatment==4
replace t45 = 1 if treatment==5
ttest app2, by(t45)

********************************


*Test 9 - AJPS
gen t78 = 0 if treatment==7
replace t78 = 1 if treatment==8
ttest app2, by(t78)

*Test 10 - AJPS
gen t58=0 if treatment==5
replace t58 = 1 if treatment==8
ttest app2, by(t58)
*MORE CONSERVATIVE TEST BELOW:
*ttesti n1 m1 sd1 n2 m2 sd2
*sds = apprx: sqrt(n) * se
*sd1 = 461.7 = sqrt(176)* 34.8
*sd2 = 571.7 = sqrt(188)* 41.7
ttesti 176 -21 461.7 188 -114 571.7

**************************************
*Test 11 - AJPS
gen fiscal=0 if treatment==4 | treatment == 5 | treatment==6
replace fiscal=1 if treatment>9

ttest app3, by(fiscal)
*************************************************************

****Demographic Variables***
*regression table, Table 3 in AJPS:
tab  V212d
tab  V212d, nolab

gen pid7 = V212d-1 if V212d<8
tab pid7

tab v243
tab v243, nolab
gen ideology = v243-1 if v243<6
tab ideology
tab  v246
tab  v246, nolab
gen income = v246-1 if v246<15
tab income

tab  v213, nolab
gen educ=v213-1

tab v208
tab v208, nolab
gen female = v208-1
tab female

tab  v207
tab  v207, nolab
gen age = 2010- v207

*Coding Racial Resentment:
gen RR=.
tab dkd321
gen rr1=(5-dkd321)/4
tab rr1
tab dkd322
gen rr2=(dkd322-1)/4
tab dkd323
gen rr3=(5-dkd323)/4
gen rr4=(dkd324-1)/4
gen RR4=.
replace RR4=(rr1+rr2+rr3+rr4)/4
gen racres= RR4
recode01 racres

sum pid7 ideology income educ female age racres01

*Pair level variables:

gen WW=0
replace WW=1 if treatment== 4 | treatment == 5 | treatment ==6

gen WB = 0
replace WB =1 if treatment== 7 | treatment == 8 | treatment == 9

gen BB = 0
replace BB =1 if treatment>9

tab WW
tab WB
tab BB

sum WW WB BB

*Generate interactions:
gen WWrr= WW * racres01
gen WBrr= WB * racres01
gen BBrr= BB * racres01


sum app3

gen deficit=app3

* v211=1 constrains model estimation to white respondents only.
*model 1:
reg deficit ideology pid7 income educ age female racres01 if v211==1

*model 2:
reg deficit ideology pid7 income educ age female racres01 WW WB BB if v211==1

*model 3:
reg deficit ideology pid7 income educ age female racres01 WW WB BB WWrr WBrr BBrr if v211==1

reg deficit racres01 WW WB BB WWrr WBrr BBrr if v211==1
*keep if v211==1
*keep deficit ideology pid7 income educ age female racres01 WW WB BB WWrr WBrr BBrr
*model 3 was estimated in R, put into TeX using the APSRtable package



** Brady Bunch type graphic, figure 6: **
tab racres01
sum racres01 if v211==1, detail
tab racres01

gen highRR=0
replace highRR =1 if racres01>.62


*************Reshape the Data*********
gen applicant1=app1
gen applicant2=app2
gen applicant3=app3

gen subject=_n
reshape long applicant, i(subject) j(target)
drop if target==3
*drop  white black HW LAZY HWW HWB LAZYw LAZYb baseline


tab target

gen white=0
replace white=1 if target== 1 & (treatment>3 & treatment<10)
replace white=1 if target== 2 & (treatment== 4 | treatment == 5 | treatment ==6)

tab white


gen black = 0
replace black = 1 if target== 1 & treatment>9
replace black = 1 if  target== 2 & treatment>6 
tab black

gen HW = 0

replace HW = 1 if target==1 & (treatment == 2 | treatment == 5 |treatment == 8 | treatment == 11)
replace HW = 1 if target==2 & (treatment == 3 | treatment == 6 |treatment == 9 | treatment == 12)
tab HW

gen LAZY=0

replace LAZY = 1 if target==2 & (treatment == 2 | treatment == 5 |treatment == 8 | treatment == 11)
replace LAZY = 1 if target==1 & (treatment == 3 | treatment == 6 |treatment == 9 | treatment == 12)
tab LAZY
tab HW LAZY
tab HW target

gen HWW = HW * white
gen HWB = HW * black

gen LAZYw = LAZY * white
gen LAZYb = LAZY * black

gen baseline=0
replace baseline=1 if target<3 & treatment==1

sum applicant if target==3
tab deficit

ttest applicant if LAZYb==1 & target!=3, by(highRR)
ttest applicant if LAZYw==1 & target!=3, by(highRR)
ttest applicant if LAZY==1 & treatment<4 & target!=3, by(highRR)

ttest applicant if black==1 & ( treatment==7 | treatment==10) , by(highRR)
ttest applicant if baseline==1, by(highRR)
ttest applicant if HW==1 & treatment<4, by(highRR)

ttest applicant if white==1 & ( treatment==7 | treatment==4), by(highRR)
ttest applicant if HWB==1 & target!=3 , by(highRR)
ttest applicant if HWW==1 & target!=3, by(highRR)

