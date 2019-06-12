************************************************
* Explaining the end of spanish exceptionalism *
* Replication files                            *
* Completed using STATA 15	        		   *
* Data file: cis3236_stata.dta        	           *
************************************************

use cis3236_stata.dta, clear

**generate immigration as MIP variable
gen migration=0
replace migration=1 if p1801==6
replace migration=1 if p1802==6

**generate reduce autonomy variable
gen spain=0
replace spain=1 if p25==1
replace spain=1 if p25==2
replace spain=. if p25>=8

***generate political distrust variable
gen distrust=0
replace distrust=1 if p2801==4
replace distrust=1 if p2802==4

**generate past political protest variable
gen protest=p2601
replace protest=0 if protest==3
replace protest=. if protest==9
replace protest=1 if protest==2


***cleaning missing values
replace rvauto18=. if rvauto18==99
replace estudios=. if estudios==9
replace recuerdo=. if recuerdo>=98
replace recuerdo=. if recuerdo==93
replace recuerdo=97 if recuerdo==95
replace recuerdo=. if recuerdo==77
replace p44=. if p44>11

**generate clean dependent variable
gen vote18=.
replace vote18=1 if rvauto18==1 //psoe
replace vote18=2 if rvauto18==2 //pp
replace vote18=3 if rvauto18==3 //Cs
replace vote18=4 if rvauto18==4 //AA
replace vote18=5 if rvauto18==8 //VOX
replace vote18=6 if rvauto18==97 //abstained

label define VOTE18 1 "PSOE" 2 "PP" 3 "Cs" 4 "AA" 5 "Vox" 6 "Abstained"
label value vote18 VOTE18

replace p30=. if p30>10
rename p30 ideology
rename p33 gender
rename p34 age
rename p44 hincome
rename p45 pincome
rename p36 civil

***generate religiosity variable
gen churchgoer=0
replace churchgoer=1 if p38a==2
replace churchgoer=1 if p38a==3
replace churchgoer=2 if p38a==4
replace churchgoer=2 if p38a==5

**clean gender variable
replace gender=0 if gender==2
label def SEX 0"Female" 1"Male"
label value gender SEX 


**generate employment variable
gen employment=.
replace employment=1 if p40==1
replace employment=2 if p40==2
replace employment=2 if p40==3
replace employment=0 if p40==4
replace employment=0 if p40==5
replace employment=3 if p40==6
replace employment=4 if p40==7

label define EMP 0 "Unemployed" 1 "Working" 2 "Retiree" 3 "Student" 4 "NILM"
label value employment EMP
label var employment "Employment status"

replace pincome=. if pincome==99


**clean dummy for former GE2016 vote choice
label define RECUERDO 1 "PSOE" 2 "PP" 3 "Cs" 4 "UP" 8 "Vox" 9 "Pacma" 13 "Other" 14 "Empty ballot" 97 "Didn't vote" 
label value recuerdo RECUERDO 


**generate education variable
replace estudios=2 if estudios==1
label def EST 2 "Primary or less" 3 "Secondary I" 4 "Secondary II" 5" Professional training" 6"Higher education"
label value estudios EST

gen education=.
replace education=0 if estudios==2
replace education=1 if estudios==3
replace education=1 if estudios==4
replace education=2 if estudios==5
replace education=2 if estudios==6

***generate indicators for assessment of regional and national imcumbents
rename p2203 diaz
replace diaz=. if diaz>10

rename p2210 sanchez
replace sanchez=. if sanchez>10


rename age edad

***create vox vote dummy variable for logit
gen votevox=0
replace votevox=1 if rvauto18==8
replace votevox=. if rvauto18==99
replace votevox=. if rvauto18==77


**create dummy for votechoice in GE2016 for Cs, Vox and PP
gen right16=0
replace right16=1 if recuerdo==2
replace right16=1 if recuerdo==3
replace right16=1 if recuerdo==8
 

*******************
* ANALYSIS        *
*******************

mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad i.gender ib(1).employment [pweight=peso], r base(6) 
margins, dydx(*) predict(outcome(1)) post
estimates store m_psoe
mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso], r base(6) 
margins, dydx(*) predict(outcome(2)) post
estimates store m_pp
mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad i.gender ib(1).employment [pweight=peso], r base(6) 
margins, dydx(*) predict(outcome(3)) post
estimates store m_cs
mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso], r base(6) 
margins, dydx(*) predict(outcome(4)) post
estimates store m_aa
mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso], r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store m_vox

set scheme plottig
coefplot m_psoe m_pp m_cs m_aa m_vox, keep(*.spain) xline(0)
coefplot m_psoe m_pp m_cs m_aa m_vox, keep(*.migration)  xline(0)
coefplot m_psoe m_pp m_cs m_aa m_vox, keep(diaz) xline(0)
coefplot m_psoe m_pp m_cs m_aa m_vox, keep(sanchez) xline(0)


***conditionality of migration on class variables
mlogit vote18 i.migration##c.pincome i.spain ideology diaz sanchez i.distrust i.protest i.churchgoer i.education c.edad i.gender ib(1).employment [pweight=peso], r base(6) 
margins migration, at(pincome=(1(1)11)) predict(outcome(5)) post
marginsplot
mlogit vote18 i.migration##c.pincome i.spain ideology diaz sanchez i.distrust i.protest i.churchgoer i.education c.edad i.gender ib(1).employment [pweight=peso], r base(6) 
margins, dydx(migration) at(pincome=(1(1)11)) predict(outcome(5)) post
marginsplot


***effect of vote for vox amogst right-wing voters
logit votevox i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad i.gender ib(1).employment if right16==1 [pweight=peso], r 
margins, dydx(*) post
estimates store ame_logit
coefplot, keep(*.migration *.spain) vertical yline(0)

