
*use ISQ FINAL DATA 

*main model (Table 1)

stcox victimd amnestyd  trial_griev trial_deter exilefu purged pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Endogeneity 

*Table 2 and Table 3 (Motivation IV Regression)
ivprobit recur2 opportunitydsumv1 pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2   nstate5 lnmilper cw  ethnic2  _t _spline* (grievancedsumv1  = grievr  grievi) if  type2==1,first

*Table 4 and Table 5 (Opportunity IV Regression)
ivprobit recur2 grievancedsumv1 pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2   nstate5 lnmilper cw  ethnic2  _t _spline* (opportunitydsumv1  = oppfui  oppfurr) if  type2==1, first


*Supplementary Information


*Table SI1-SI2 (IV Regression)

*motivation
bootstrap: stcox griev1 opportunitydsumv1  pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, robust

*opportunity
bootstrap: stcox opppb1 grievancedsumv1  pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, robust


*Table S13 (matching)

*collapsing data set

collapse lgdpgrowth lrgdpch lrgdpgrowth lnmilper milper  (max) ldemdum2 btldeath  begin end  ethnic ethnic2 external ethnic3  victimd amnestyd  trial_deter recur2 pws  nstate5  grievdum oppdum trial_griev exilefu purged pko victory  btpop lndur  grievancedsumv1 opportunitydsumv1  counter counter1 year /// 
(first) cw pagreement type2 ccode acdid  , by(epid)

gen pcj3g=0
replace pcj3g=1 if grievdum==1
replace pcj3g=2 if oppdum==1
replace pcj3g=1 if grievdum==1

gen pcj3o=0
replace pcj3o=1 if grievdum==1
replace pcj3o=2 if oppdum==1

gen pcjdum=0
replace pcjdum=1 if grievdum==1 | oppdum==1

gen pcj4=0 
replace pcj4=1 if grievdum==1
replace pcj4=2 if oppdum==1
replace pcj4=3 if oppdum==1 & grievdum==1

gen pcj3=. 
replace pcj3=0 if grievdum==1
replace pcj3=1 if oppdum==1
replace pcj3=2 if oppdum==1 & grievdum==1


*matching
*have to drop cw due to lack of variation

stset counter1, id(epid) failure(recur2)

stcox grievdum oppdum  pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5  lnmilper  ethnic2 cw if type2==1, robust
estimates store a4

probit recur2 grievdum oppdum  pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5  lnmilper  ethnic2  cw if type2==1, robust
estimates store a5

*grievance
cem lrgdpch (#5) lrgdpgrowth (#3) lnmilper (#2) victory cw pko pagreement  btpop (#2) lndur (#3) pws ethnic2, tr(grievdum)
probit recur2 grievdum oppdum  pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 lnmilper  ethnic2 cw if type2==1 [iweight=cem_weights], robust
estimates store a6

*opportunity
cem lrgdpch (#5) lrgdpgrowth (#3) lnmilper (#2) victory cw pko pagreement  btpop (#2) lndur (#3) pws ethnic2, tr(oppdum)
probit recur2 grievdum oppdum  pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 lnmilper  ethnic2 cw if type2==1 [iweight=cem_weights], robust
estimates store a7
clear


*Table SI4 (Determinants of PCJ)
**use ISQ COLLAPSED FINAL DATA



*Motivation PCJ
logit grievdum pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if type2==1, cluster(ccode)

*Opportunity PCJ
logit oppdum pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if type2==1, cluster(ccode)



**use ISQ FINAL DATA 

*Tabel SI5 (Alternatiev PCJ Coding Rules)
*All PCJ Types
stcox victim amnesty  trial exilefu purge pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Disaggregated PCJ Variables
stcox victimd amnestyd amnestytg trial_griev trial_deter exilefu purged pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Table SI6 (additional controls)
stcox victimd amnestyd  trial_griev trial_deter exilefu purged pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 patype4  external ddr imr if  type2==1 & year>1974, cluster(ccode)

*Table SI7-SI8 (PCJ Combinations)
*alternative PCJ combinations

*binary
stcox grievdum oppdum pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*count variables
stcox grievancedsumv1 opportunitydsumv1 pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*combine motivation/opportunity
*grievdumm + oppdum
stcox grievdumoppdum pko  victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*grievancedum + trial
stcox grievancedumtrial pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*grievancedum + purge
stcox grievancedumpurge pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*grievance + exile
stcox grievancedumexile pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)


*Table SI9 (Sequencing)
stcox gfirsto glasto gsameo pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)


*Table SI10
*Reparations-Victory
stcox i.victimd##i.victory amnestyd trial_griev trial_deter exilefu purged pko  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Amnesty-Victory
stcox victimd i.amnestyd##i.victory trial_griev trial_deter exilefu purged pko  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Comprehensive TrialsVictory
stcox i.victimd amnestyd i.trial_griev##i.victory trial_deter exilefu purged pko  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)


*Table SI11

*Trial-Victory
stcox i.victimd amnestyd trial_griev i.trial_deter##i.victory exilefu purged pko  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Exile Victory
stcox i.victimd amnestyd trial_griev trial_deter i.exilefu##i.victory  purged pko  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Purged Victory
stcox i.victimd amnestyd trial_griev trial_deter exilefu i.purged##i.victory pko  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Table SI12 (PKO Interactions)

*Reparations - PKO
stcox i.victimd##i.pko amnestyd trial_griev trial_deter exilefu purged victory  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Amnesty - PKO
stcox victimd i.amnestyd##i.pko trial_griev trial_deter exilefu purged victory  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Comprehensive Trials - PKO
stcox i.victimd amnestyd i.trial_griev##i.pko trial_deter exilefu purged victory  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)


*Table SI13 (PKO Interactions

*Trials
stcox i.victimd amnestyd trial_griev i.trial_deter##i.pko exilefu purged victory  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Exile
stcox i.victimd amnestyd trial_griev trial_deter i.exilefu##i.pko  purged victory  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Purged
stcox i.victimd amnestyd trial_griev trial_deter exilefu i.purged##i.pko victory  pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)


*Table SI15 - Scope
stcox victimdb amnestydb trial_grievb trial_deter exilefub purgedb pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)


*Table SI16 Difficult Wars
*PCJ and Time
stcox victimd amnestyd  trial_griev trial_deter exilefu purged  purgelnt exilelnt trialdeterdlnt trialgrievdlnt amnestydlnt victimdlnt  pko victory pagreement pws btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Trial, Time, and Military
stcox victimd  amnestyd  trial_griev   trial_deter trialdmilpert  exilefu   purged  pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Exile, Time, and Military
stcox victimd  amnestyd  trial_griev  trial_deter  exilefu exilemilpert   purged  pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)

*Purge, Time, and Military
stcox victimd  amnestyd  trial_griev  trial_deter  exilefu   purged purgemilpert  pko victory pagreement pws  btpop lndur lrgdpch lgdpgrowth  ldemdum2  nstate5 cw  lnmilper  ethnic2 if  type2==1, cluster(ccode)


