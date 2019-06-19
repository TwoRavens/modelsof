/*=========================================
Title:  olinerdat.do
Author: Mitchell Hoffman
Purpose: Analysis of Oliner individual data
=========================================*/


clear
clear matrix
set more off

set memory 200m

global logpath = "C:\Users\Mitch\"
cd "$logpath"

capture log close
log using OlinerLog.log, append

global datapath = "C:\Users\Mitch\"
cd "$datapath"
use oliner_data.dta

**************************************************************************************** 
***************************   Rescue and Demograpic variables

* Righteous rescuer
gen righteous = .
replace righteous = 1 if rescue==1
replace righteous = 0 if rescue==5

*** Age in 1940
gen age1940 = 1940 - va1a

*** Education qualification
gen elem = .
replace elem=1 if vc1==1
replace elem=0 if vc1==5

gen gym = .
replace gym=1 if vc3==1
replace gym=0 if vc3==5

gen apprent = .
replace apprent=1 if vc7==1
replace apprent=0 if vc7==5

*** Religiosity
gen relig = .
replace relig = 4 if vd14==1
replace relig = 3 if vd14==2
replace relig = 2 if vd14==4
replace relig = 1 if vd14==5


*** Gender
gen male = mod(sex,2)

*** Education status, single variable
* vc1 = attend elementary, vc3 = attend high school / gymnasium
* vc4 = graduate from high school, vc5 = attend university, vc6 = graduate from university 

* 1 means yes, 5 means no
* Curiously, all people who didn't attend elementary school (vc1==5)
* then when on to attend some high school/gymnasium: count if vc1==5 & vc3==1 -> 23; count if vc1==5 ->23

* Scored from 1-5: 1=did not attend high school; 2=attend high school, but do not graduate
* 3=graduate high school,  but no university;  4=attend university, but not graduate; 5=graduate university;
* Thus 1-5.  Elementary, some high school, graduate high school, some university, graduate university.

gen educ=.
replace educ = 5 if vc6==1
replace educ = 4 if vc5==1 & vc6!=1
replace educ = 3 if vc4==1 & vc5!=1 & vc6!=1
replace educ = 2 if vc3==1 & vc4!=1 & vc5!=1 & vc6!=1
replace educ = 1 if vc3==5 & vc4!=1 & vc5!=1 & vc6!=1

*** Religious denomination
* Protestant=1, Catholic=2, No Religion=5, Other=7 
gen prot = (vc8==1) if vc8!=.
gen cath = (vc8==2) if vc8!=.
 
**************************************************************************************** 
***************************   Geographic location during war

* ve3(N=403)= country lived in when war broke out, 
* ve61(N=491)= country lived in longest during war
* Main Countries: Poland, France, Netherlands, and Germany

* All people with ve61 missing have non-missing ve3.
gen cntywar = ve61 
replace cntywar = ve3 if cntywar==. 

* Use indicator functions because no missing values in cntywar
gen pold = (cntywar==13) if cntywar!=0
gen france = (cntywar==6) if cntywar!=0
gen nether= (cntywar==9) if cntywar!=0
gen germ= (cntywar==7) if cntywar!=0

**************************************************************************************** 
*************************** Economic variables

*************** Self-perceived economic status
gen childinc = 6 - va15
gen prewarinc = 6 - vd13
gen warinc = 6 - ve70

***************  Wartime Job SE / Occupational Status ranking: 

* ve1b is occupational status during the war. 
* ve1 is whether doing the same work during the war as before it.  
* vd11a is occupational status before the war. 

* ve1b, vd11a: 0=?, 1=Professional, 2=Business, 3=Admin, 
* 4=Clerical, 5=Skilled, 6=semiskilled, 7=unskilled, 
* 8=commune-relig order, 9=crazy,dead,no work
* ve1: 1=Same job as before war, 2=Different.
* Drop subjects who said had same job during war, 
* but their jobs before and during war don't agree.

gen hijob = .
replace hijob =1 if (ve1b==1 | ve1b==2 | ve1b==3)
replace hijob =0 if (ve1b==4 | ve1b==5 | ve1b==6 | ve1b==7)
replace hijob =1 if (vd11a==1 | vd11a==2 | vd11a==3) & ve1==1 & hijob==.
replace hijob =0 if (vd11a==4 | vd11a==5 | vd11a==6 | vd11a==7) & ve1==1 & hijob==.
replace hijob =. if ( vd11a!=ve1b & ve1==1 & vd11a!=. & ve1b!=.)

* Variable for different wartime occupations / Non-binary version of hijob.
gen warocp = .
forvalues x = 1/7{
  replace warocp = 8-`x' if ve1b==`x'
}
* Replace with prewar ocp. if missing warocp and should have same job
forvalues x = 1/7{
  replace warocp = 8-`x' if vd11a==`x' & ve1==1 & warocp==.
}
replace warocp = . if (ve1b!=vd11a) & ve1==1 & vd11a!=. & ve1b!=. 

/*
* Check that did things correctly.
gen hijob1 =.
replace hijob1 =1 if warocp==5 | warocp==6 | warocp==7
replace hijob1 =0 if warocp==1 | warocp==2 | warocp==3 | warocp==4
tab hijob hijob1 
gen diff = (hijob!=hijob1)
sum diff
*/


**************************************************************************************** 
*************************** Ease of Rescue Variables

*** Rooms in house: 98=don't know
gen rooms =ve66 if ve66!=98

*** Type of residence (house or something else): 1=house, 2 = apartment, 7 = other

gen house = .
replace house = 1 if ve65==1
replace house = 0 if (ve65==2 | ve65==7)

*** Type of locality:  1 = large city, 2 = med city, 3 = small city, 4 = village, 5 = farm
gen city = .
replace city = 1 if (ve62==1 | ve62==2 | ve62==3)
replace city = 0 if ve62==4 | ve62==5

***************************************************************************
*************************** Amount of rescue

**** Number of people helped directly
* Don't Know (dk) coded as 998
gen dhlp = .
replace dhlp = ve17 if ve17!=998 
gen ldhlp = log(dhlp)

**************************************************************************************** 
*************************** Eliminate weird observations

drop if age==0 | age==-1  


****************************************************************************************
*************************** Manski-Lerman Weights  

*** Weights equal proportion in population divided by proportion in sample

*** Proportions in sample

gen rsamp = 346/510

*** Proportions in population: Rescuer prop. in poulation is Rescuers per Jew killed

* Number of rescuers
gen rcount = 22550

* Adjust for undercounting by Yad Vashem of true number of rescuers.
* 1 means no undercounting.  >1 means undercounting.
gen yvmul = 2

* Number of Jews killed
gen rkild = 5925638

* Share of rescuers in the population, assuming 1 potential rescuer per Jew killed
gen rpop = rcount * yvmul / rkild

*** Make the Manski-Lerman weights
gen ml_wt = .
replace ml_wt = rpop / rsamp if righteous==1
replace ml_wt = (1-rpop) / (1-rsamp) if righteous==0


**************************************************************************************** 
*************************** Regressions

* Adjusted critical values, with df = # of clusters - 2

scalar sig_11_10 = invttail(11,.05)
scalar sig_11_5 = invttail(11,.025)
scalar sig_11_1 = invttail(11,.005)

scalar sig_13_10 = invttail(13,.05)
scalar sig_13_5 = invttail(13,.025)
scalar sig_13_1 = invttail(13,.005)

scalar sig_10_10 = invttail(10,.05)
scalar sig_10_5 = invttail(10,.025)
scalar sig_10_1 = invttail(10,.005)

di sig_11_10
di sig_11_5
di sig_11_1

di sig_13_10
di sig_13_5
di sig_13_1

di sig_10_10 
di sig_10_5 
di sig_10_1 

* Logit models

version 9.0
dlogit2 righteous hijob, robust cluster (cntywar) 
outreg using OlinerRegs, se 3aster bdec(4) rdec(2) replace
dlogit2 righteous warinc, robust cluster (cntywar) 
outreg using OlinerRegs, se 3aster bdec(4) rdec(2) append
dlogit2 righteous hijob warinc cath prot rooms city house , robust cluster (cntywar) 
outreg using OlinerRegs, se 3aster bdec(4) rdec(2) append
dlogit2 righteous hijob warinc cath prot rooms city house age sex educ pold france germ neth, robust cluster (cntywar) 
outreg using OlinerRegs, se 3aster bdec(4) rdec(2) append
dlogit2 righteous hijob [aw=ml_wt], robust cluster (cntywar) 
outreg using OlinerRegs, se 3aster bdec(4) rdec(2) append
dlogit2 righteous warinc [aw=ml_wt], robust cluster (cntywar) 
outreg using OlinerRegs, se 3aster bdec(4) rdec(2) append
dlogit2 righteous hijob warinc cath prot rooms city house  [aw=ml_wt], robust cluster (cntywar) 
outreg using OlinerRegs, se 3aster bdec(4) rdec(2) append
dlogit2 righteous hijob warinc cath prot rooms city house age sex educ pold france germ neth  [aw=ml_wt], robust cluster (cntywar) 
outreg using OlinerRegs, se 3aster bdec(4) rdec(2) append

* Get mean of dependent variable

* For regressions 1-4
sum righteous if hijob!=.
sum righteous if warinc!=.
sum righteous if hijob!=. & warinc!=. & cath!=. & prot!=. & rooms!=. & city!=. & house!=. 
sum righteous if hijob!=. & warinc!=. & cath!=. & prot!=. & rooms!=. & city!=. & house!=. & age!=. & sex!=. & educ!=. & pold!=. & france!=. & germ!=. & neth!=. 

* For regressions 5-8
sum rpop


