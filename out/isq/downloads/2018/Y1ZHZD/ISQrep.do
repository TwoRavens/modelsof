use "C:\Users\mattesmc\Documents\Papers\Civil Wars\Civil War I\ISQ\R&R\R&R2\ISQrepdata.dta", clear

*use ISQrepdata.dta

***Descriptive statistics
*polpssum= repex + repcs + repleg
tab polpssum
*milpssum= milldr + milint
tab milpssum
*econpssum= landredist + otherredist
tab econpssum
*terrpssum= autonomy + federalism
tab terrpssum

tab guarantee
tab costinc
tab issue
sum duration
sum costs
tab peacefail
sum peacedur

**Endogeneity Tests
oprobit costinc issue costs duration, robust cluster (ccode)
oprobit polpssum issue costs duration, robust cluster (ccode)
oprobit econpssum issue costs duration, robust cluster (ccode)
probit terrpssum issue costs duration, robust cluster (ccode)
oprobit milpssum issue costs duration, robust cluster (ccode)
probit guarantee issue costs duration, robust cluster (ccode)

***Preparing data for duration analysis
stset peacedur, id(idnumber) failure(peacefail)

**Main Model
stcox polpssum milpssum econpssum terrpssum costinc guarantee issue costs duration, efron cluster(ccode) 

**Baseline Hazard
stcox polpssum milpssum econpssum terrpssum costinc guarantee issue costs duration, efron cluster(ccode) nohr basehc(hazard)
stcurve, hazard
drop hazard

**Proportional Hazard Test stcox polpssum milpssum econpssum terrpssum costinc guarantee issue costs duration, robust efron sch(sch*) sca(sca*) 
stphtest, detail
drop sch* sca*
stcox polpssum milpssum econpssum terrpssum costinc guarantee issue, efron cluster(ccode) sch(sch*) sca(sca*)
stphtest, detail
drop sch* sca*

**Inclusion of individual cost-increasing provisions one at a time
stcox polpssum milpssum econpssum terrpssum guarantee sepforce issue costs duration, efron cluster(ccode) 
stcox polpssum milpssum econpssum terrpssum guarantee peacekeep issue costs duration, efron cluster(ccode) 
stcox polpssum milpssum econpssum terrpssum guarantee sealed issue costs duration, efron cluster(ccode) 
stcox polpssum milpssum econpssum terrpssum guarantee withdfor issue costs duration, efron cluster(ccode) 

**With aggregate power-sharing measure (Hartzell and Hoddie 2003, 2007)
stcox psall costinc guarantee issue costs duration, efron cluster(ccode) 

**With cold war variable
stcox polpssum milpssum econpssum terrpssum costinc guarantee issue costs duration coldwar, efron cluster(ccode) 

**Drop truces and run analysis only with settlementsdrop if idnumber==2drop if idnumber==6drop if idnumber==11drop if idnumber==12drop if idnumber==21drop if idnumber== float(8.1)

stcox polpssum milpssum econpssum terrpssum costinc guarantee issue costs duration, efron cluster(ccode) 

