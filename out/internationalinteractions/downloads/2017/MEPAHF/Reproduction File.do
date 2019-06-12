************************
******** MAIN ANALYSIS**
************************

* Table 1 gives the proportion of riots, coups and civil wars across the different regime types. 


**** Table 1: Distribution of Riots, Coups and Civil Wars across Regime Types

* Full Democracy

tabulate multi_prio_pow_banks if ongoing_prio!=. & coup_5year_pow!=. & riot_numyear!=. & coup_pow!=. & riot_banks_dummy!=. & L.lngdppc!=. & L.lnpop!=. & lmtnest_from_EPR!=. & regchg3_from_EPR!=. & oil_dummy!=. & L.trans_interregnum!=. & L.full_demo==1 & L.full_auto!=. & L.partial_auto!=. & L.partial_faction_demo!=. & L.partial_nonfaction_demo!=. & L.military!=. & exclpop!=. &  sppop!=. & jppop!=. & egipgrps!=. & newlyexcl3!=. & dec50!=. & asia!=. & colbrit!=. & colfra!=.

* Full Autocracy

tabulate multi_prio_pow_banks if ongoing_prio!=. & coup_5year_pow!=. & riot_numyear!=. & coup_pow!=. & riot_banks_dummy!=. & L.lngdppc!=. & L.lnpop!=. & lmtnest_from_EPR!=. & regchg3_from_EPR!=. & oil_dummy!=. & L.trans_interregnum!=. & L.full_demo!=. & L.full_auto==1 & L.partial_auto!=. & L.partial_faction_demo!=. & L.partial_nonfaction_demo!=. & L.military!=. & exclpop!=. &  sppop!=. & jppop!=. & egipgrps!=. & newlyexcl3!=. & dec50!=. & asia!=. & colbrit!=. & colfra!=.

* Partial Autocracy

tabulate multi_prio_pow_banks if ongoing_prio!=. & coup_5year_pow!=. & riot_numyear!=. & coup_pow!=. & riot_banks_dummy!=. & L.lngdppc!=. & L.lnpop!=. & lmtnest_from_EPR!=. & regchg3_from_EPR!=. & oil_dummy!=. & L.trans_interregnum!=. & L.full_demo!=. & L.full_auto!=. & L.partial_auto==1 & L.partial_faction_demo!=. & L.partial_nonfaction_demo!=. & L.military!=. & exclpop!=. &  sppop!=. & jppop!=. & egipgrps!=. & newlyexcl3!=. & dec50!=. & asia!=. & colbrit!=. & colfra!=.

* Partial Democracy (Faction)

tabulate multi_prio_pow_banks if ongoing_prio!=. & coup_5year_pow!=. & riot_numyear!=. & coup_pow!=. & riot_banks_dummy!=. & L.lngdppc!=. & L.lnpop!=. & lmtnest_from_EPR!=. & regchg3_from_EPR!=. & oil_dummy!=. & L.trans_interregnum!=. & L.full_demo!=. & L.full_auto!=. & L.partial_auto!=. & L.partial_faction_demo==1 & L.partial_nonfaction_demo!=. & L.military!=. & exclpop!=. &  sppop!=. & jppop!=. & egipgrps!=. & newlyexcl3!=. & dec50!=. & asia!=. & colbrit!=. & colfra!=.

* Partial Democracy (Non-Faction)

tabulate multi_prio_pow_banks if ongoing_prio!=. & coup_5year_pow!=. & riot_numyear!=. & coup_pow!=. & riot_banks_dummy!=. & L.lngdppc!=. & L.lnpop!=. & lmtnest_from_EPR!=. & regchg3_from_EPR!=. & oil_dummy!=. & L.trans_interregnum!=. & L.full_demo!=. & L.full_auto!=. & L.partial_auto!=. & L.partial_faction_demo!=. & L.partial_nonfaction_demo==1 & L.military!=. & exclpop!=. &  sppop!=. & jppop!=. & egipgrps!=. & newlyexcl3!=. & dec50!=. & asia!=. & colbrit!=. & colfra!=.

* Transitional

tabulate multi_prio_pow_banks if ongoing_prio!=. & coup_5year_pow!=. & riot_numyear!=. & coup_pow!=. & riot_banks_dummy!=. & L.lngdppc!=. & L.lnpop!=. & lmtnest_from_EPR!=. & regchg3_from_EPR!=. & oil_dummy!=. & L.trans_interregnum==1 & L.full_demo!=. & L.full_auto!=. & L.partial_auto!=. & L.partial_faction_demo!=. & L.partial_nonfaction_demo!=. & L.military!=. & exclpop!=. &  sppop!=. & jppop!=. & egipgrps!=. & newlyexcl3!=. & dec50!=. & asia!=. & colbrit!=. & colfra!=.


************************************************************************************

* Table 2 estimates the effect of the key independent variables on riots (outcome 1), coups (outcome 2), and civil wars (outcome 3)

**** Table 2: Multinomial Logit: Determinants of Instability - Riots, Coups, and Civil Wars

/// Includes only basic control variables
set more off
#delimit ;
mlogit multi_prio_pow_banks
ongoing_prio coup_5year_pow riot_numyear
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo 
exclpop  sppop jppop egipgrps newlyexcl3
L.lngdppc , robust ;
#delimit  cr 


/// Includes all control variables
set more off
#delimit ;
mlogit multi_prio_pow_banks
ongoing_prio coup_5year_pow riot_numyear
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo 
exclpop  sppop jppop egipgrps newlyexcl3
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy L.military colbrit colfra
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme, robust ;
#delimit  cr 


************************************************************************************

* Table 3 gives the change in the predicted probability of a riot/coup/civil war when we change the value of the explanatory variables (based on model 2 of Table 2). 

**** Table 3: Predicted Probabilities of Instability: Riots, Coups, and Civil Wars

set more off
#delimit ;
mlogit multi_prio_pow_banks
i.ongoing_prio i.coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR i.oil_dummy
i.L.trans_interregnum i.L.full_demo i.L.partial_auto i.L.partial_faction_demo L.partial_nonfaction_demo i.L.military
exclpop  sppop jppop egipgrps i.newlyexcl3
dec50 dec60 dec70 i.dec80 dec90 asia eeurop lamerica ssafrica nafrme  i.colbrit colfra, robust ;
#delimit  cr 

margins ongoing_prio, predict(outcome(2))

margins coup_5year_pow, predict(outcome(1))
margins coup_5year_pow, predict(outcome(2))

margins , at(riot_numyear=0) predict(outcome(1))
margins , at(riot_numyear=3) predict(outcome(1))

margins , at(riot_numyear=0) predict(outcome(2))
margins , at(riot_numyear=3) predict(outcome(2))

margins , at(riot_numyear=0) predict(outcome(3))
margins , at(riot_numyear=3) predict(outcome(3))

margins L.trans_interregnum, predict(outcome(1))
margins L.trans_interregnum, predict(outcome(2))
margins L.trans_interregnum, predict(outcome(3))

margins L.full_demo, predict(outcome(2))

margins L.partial_auto, predict(outcome(1))
margins L.partial_auto, predict(outcome(2))

margins L.partial_faction_demo, predict(outcome(1))
margins L.partial_faction_demo, predict(outcome(2))
margins L.partial_faction_demo, predict(outcome(3))

margins , at(exclpop=.059) predict(outcome(1))
margins , at(exclpop=.518) predict(outcome(1))

margins , at(exclpop=.059) predict(outcome(2))
margins , at(exclpop=.518) predict(outcome(2))

margins , at(exclpop=.059) predict(outcome(3))
margins , at(exclpop=.518) predict(outcome(3))

margins , at(jppop=0) predict(outcome(2))
margins , at(jppop=.44) predict(outcome(2))

margins , at(egipgrps=1) predict(outcome(3))
margins , at(egipgrps=3) predict(outcome(3))

margins newlyexcl3, predict(outcome(2))

margins , at(L.lngdppc=7.951911) predict(outcome(2))
margins , at(L.lngdppc=9.499641) predict(outcome(2))

margins , at(L.lngdppc=7.951911) predict(outcome(3))
margins , at(L.lngdppc=9.499641) predict(outcome(3))

margins , at(L.lnpop=16.01617) predict(outcome(1))
margins , at(L.lnpop=17.85079) predict(outcome(1))

margins , at(L.lnpop=16.01617) predict(outcome(3))
margins , at(L.lnpop=17.85079) predict(outcome(3))

margins , at(lmtnest_from_EPR=2.424803) predict(outcome(3))
margins , at(lmtnest_from_EPR=3.985273) predict(outcome(3))

margins oil_dummy, predict(outcome(3))

margins L.military, predict(outcome(2))
margins L.military, predict(outcome(3))

margins colbrit, predict(outcome(1))


**************************************************************************************************************************
**************************************************************************************************************************
**************************************************************************************************************************

*************************
****** ONLINE APPENDIX **
*************************

**** Table A1: Summary Statistics

set more off

sum riot_banks_dummy coup_pow onset_prio if ongoing_prio!=. & coup_5year_pow!=. & riot_numyear!=. & coup_pow!=. & riot_banks_dummy!=. & L.lngdppc!=. & L.lnpop!=. & lmtnest_from_EPR!=. & regchg3_from_EPR!=. & oil_dummy!=. & L.trans_interregnum!=. & L.full_demo!=. & L.full_auto!=. & L.partial_auto!=. & L.partial_faction_demo!=. & L.partial_nonfaction_demo!=. & L.military!=. & exclpop!=. &  sppop!=. & jppop!=. & egipgrps!=. & newlyexcl3!=. & dec50!=. & asia!=. & colbrit!=. & colfra!=.

sum ongoing_prio coup_5year_pow riot_numyear if ongoing_prio!=. & coup_5year_pow!=. & riot_numyear!=. & coup_pow!=. & riot_banks_dummy!=. & L.lngdppc!=. & L.lnpop!=. & lmtnest_from_EPR!=. & regchg3_from_EPR!=. & oil_dummy!=. & L.trans_interregnum!=. & L.full_demo!=. & L.full_auto!=. & L.partial_auto!=. & L.partial_faction_demo!=. & L.partial_nonfaction_demo!=. & L.military!=. & exclpop!=. &  sppop!=. & jppop!=. & egipgrps!=. & newlyexcl3!=. & dec50!=. & asia!=. & colbrit!=. & colfra!=.

sum lngdppc  lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy  trans_interregnum full_demo  full_auto  partial_auto partial_faction_demo partial_nonfaction_demo military exclpop  sppop jppop egipgrps newlyexcl3 colbrit colfra if ongoing_prio!=. & coup_5year_pow!=. & riot_numyear!=. & coup_pow!=. & riot_banks_dummy!=. & L.lngdppc!=. & L.lnpop!=. & lmtnest_from_EPR!=. & regchg3_from_EPR!=. & oil_dummy!=. & L.trans_interregnum!=. & L.full_demo!=. & L.full_auto!=. & L.partial_auto!=. & L.partial_faction_demo!=. & L.partial_nonfaction_demo!=. & L.military!=. & exclpop!=. &  sppop!=. & jppop!=. & egipgrps!=. & newlyexcl3!=. & dec50!=. & asia!=. & colbrit!=. & colfra!=.



**********************************************************************

* Table A2 runs three individual logit models (one for each form of instability) with the same reference category ("peace").  
* For example, in the riot model, the dependent variable takes the value 1 if the country has experienced a riot – no matter if it has also endured a coup/civil war or not – and 0 if it has been free from riots, coups and civil wars  (“peace”). 
* Cases in which a country has experienced either a coup or a civil war but not a riot are omitted from the riot model, which is similar to the way multinomial models are estimated. 
* The dependent variables for the coup and civil war models are constructed in the same way. 
* In all three models the reference category is the absence of any form of instability. 



**** Table A2: Logit: Determinants of Instability - Riots, Coups, and Civil Wars (Each Regression Uses the Same Reference Category)

/// Riot model
set more off
#delimit ;
logit riot_banks_sameref
ongoing_prio coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo L.military
exclpop  sppop jppop egipgrps newlyexcl3
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme  colbrit colfra, robust ;
#delimit  cr 

/// Coup model
set more off
#delimit ;
logit coup_pow_sameref
ongoing_prio coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo L.military
exclpop  sppop jppop egipgrps newlyexcl3
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme  colbrit colfra, robust ;
#delimit  cr 


/// Civil war model
set more off
#delimit ;
logit onset_prio_sameref
ongoing_prio coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo L.military
exclpop  sppop jppop egipgrps newlyexcl3
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme  colbrit colfra, robust ;
#delimit  cr 




***********************************************************************************

* Table A3 runs three 'regular' logic models (i.e. logit models with different reference categories). 
* Now, in the coup model, for example, the dependent variable takes the value 1 if a coup was staged and 0 otherwise, no matter if a riot or a civil war occurred or not.


**** Table A3: Logit: Determinants of Instability - Riots, Coups, and Civil Wars (Each Regression Uses Different Reference Categories)

/// Riot model 
set more off
#delimit ;
logit riot_banks_dummy
ongoing_prio coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo L.military
exclpop  sppop jppop egipgrps newlyexcl3
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme  colbrit colfra, robust ;
#delimit  cr 


/// Coup model 
set more off
#delimit ;
logit coup_pow
ongoing_prio coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo L.military
exclpop  sppop jppop egipgrps newlyexcl3
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme  colbrit colfra, robust ;
#delimit  cr 


/// Civil war model
set more off
#delimit ;
logit onset_prio
ongoing_prio coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo L.military
exclpop  sppop jppop egipgrps newlyexcl3
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme  colbrit colfra, robust ;
#delimit  cr 


***********************************************************************************

* Like Table A3, Table A4 runs three 'regular' logit models but unlike Table A3 controls for whether the country also experiences the two other forms of instability. 
* For example, in the riot model, we include control variables for whether there is a civil war onset or a coup during the same year.  

* Table A4: Logit: Determinants of Instability - Riots, Coups, and Civil Wars (Controls for Other Forms of Instability)

/// Riot model 
set more off
#delimit ;
logit riot_banks_dummy
onset_prio coup_pow
ongoing_prio coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo L.military
exclpop  sppop jppop egipgrps newlyexcl3
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme  colbrit colfra, robust ;
#delimit  cr 


/// Coup model 
set more off
#delimit ;
logit coup_pow
onset_prio riot_banks_dummy
ongoing_prio coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo L.military
exclpop  sppop jppop egipgrps newlyexcl3
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme  colbrit colfra, robust ;
#delimit  cr 


/// Civil war model 
set more off
#delimit ;
logit onset_prio
coup_pow riot_banks_dummy
ongoing_prio coup_5year_pow riot_numyear
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo L.military
exclpop  sppop jppop egipgrps newlyexcl3
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme  colbrit colfra, robust ;
#delimit  cr 


***********************************************************************************

* Table A5 redoes the main model (model 2 of Table 2) with the indicator of civil wars of the Correlates of War rather than that of the PRIO.

**** Table A5: Multinomial Logit: Determinants of Instability - Riots, Coups, and Civil Wars (COW Indicator of Civil War)

set more off
#delimit ;
mlogit multi_cow_pow_banks
ongoingcow coup_5year_pow riot_numyear
exclpop  sppop jppop egipgrps newlyexcl3
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo 
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy L.military colbrit colfra
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme, robust ;
#delimit  cr 

**************************************************************************************

* Table A6 redoes the main model (model 2 of Table 2) with the indicator of coups of the Center for Systemic Peace (CSP) rather than that of Powell and Thyne.

**** Table A6: Multinomial Logit: Determinants of Instability - Riots, Coups, and Civil Wars (CSP Indicator of Coup)

set more off
#delimit ;
mlogit multi_prio_csp_banks
ongoing_prio coup_5year_csp riot_numyear
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo 
exclpop  sppop jppop egipgrps newlyexcl3
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy L.military colbrit colfra
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme, robust ;
#delimit  cr 

**************************************************************************************

* Table A7 redoes the main model (model 2 of Table 2) with the indicator of coups of the Center for Systemic Peace (CSP) rather than that of Powell and Thyne, and with the indicator of civil wars of the Correlates of War rather than that of the PRIO.

**** Table A7: Multinomial Logit: Determinants of Instability - Riots, Coups, and Civil Wars (COW Indicator of Civil War and CSP Indicator of Coup)

set more off
#delimit ;
mlogit multi_cow_csp_banks
ongoingcow coup_5year_csp riot_numyear
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo 
exclpop  sppop jppop egipgrps newlyexcl3
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy L.military colbrit colfra
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme, robust ;
#delimit  cr 



**************************************************************************************
**************************************************************************************
**************************************************************************************

*************************************
**** RESULTS AVAILABLE UPON REQUEST**
*************************************

* on pages 30-31 we write: "Among the control variables, our most surprising result is that we do not find that countries that have recently experienced institutional instability 
* – measured as a three point change in the Polity score over the last three years – are more likely to experience civil wars. 
* However, when we exclude our key institution dummy variables and the controls for recent coups and riots, instability does foster civil war and the relationship is significant at the 5% level (available upon request)."

* Below we show that this is indeed the case. 

set more off
#delimit ;
mlogit multi_prio_pow_banks
ongoing_prio
exclpop  sppop jppop egipgrps newlyexcl3
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy L.military colbrit colfra
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme, robust ;
#delimit  cr 


*******************************************************************************

* on page 32 we write: "multinomial probit models give similar results (available upon request)."

** Below we run the model using multinomial probit.

set more off
#delimit ;
mprobit multi_prio_pow_banks
ongoing_prio coup_5year_pow riot_numyear
ltrans_interregnum lfull_demo lpartial_auto lpartial_faction_demo lpartial_nonfaction_demo 
exclpop  sppop jppop egipgrps newlyexcl3
llngdppc llnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy lmilitary colbrit colfra
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme, robust ;
#delimit  cr 


*********************************************************************************

* on page 32 we write: "In addition, we have included other control variables: The one year lagged rate of income growth is statistically significant across the models and positive growth reduces the risk of riot and coup d’etat. 
* The share of the Muslim population in each country increases the risk of coup d’etat. 
* The inclusion of these variables has little effect on our findings (available upon request)."

** Below we run the model with control variables for 'Muslim' and 'Growth.'

set more off
#delimit ;
mlogit multi_prio_pow_banks
ongoing_prio coup_5year_pow riot_numyear
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo 
exclpop  sppop jppop egipgrps newlyexcl3
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy L.military colbrit colfra L.growth muslim
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme, robust ;
#delimit  cr 


*********************************************************************************

* Below we show that our results are unchanged when we control for different forms of instability: assassinations, strikes, guerilla, government crises, purges, revolutions, and demonstrations (Taken from the data of Banks). 

set more off
#delimit ;
mlogit multi_prio_pow_banks
ongoing_prio coup_5year_pow riot_numyear
L.trans_interregnum L.full_demo L.partial_auto L.partial_faction_demo L.partial_nonfaction_demo 
exclpop  sppop jppop egipgrps newlyexcl3
L.lngdppc L.lnpop lmtnest_from_EPR regchg3_from_EPR oil_dummy L.military colbrit colfra
L.assassinations L.strikes L.guerilla L.govcrises L.purges L.revolutions L.demonstrations
dec50 dec60 dec70 dec80 dec90 asia eeurop lamerica ssafrica nafrme, robust ;
#delimit  cr 
