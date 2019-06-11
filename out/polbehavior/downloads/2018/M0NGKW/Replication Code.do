*Logistic Regression- Odds Ratios 
by TransIDDummy, sort: logistic registered out qualitylife2 hardship IDReverse income pass cohort white Latino BA South StrictID StateIDRegLooseDummy StateIDChangeHard, vce (cluster stateFIPS) 
by TransIDDummy, sort: logistic registered out qualitylife2 hardship IDReverse income pass cohort white Latino BA South StrictID StateIDRegLooseDummy StateIDChangeHard StateRegIDxIDChange, vce (cluster stateFIPS) 

*Logistic Regression- Coefficients 
by TransIDDummy, sort: logit registered out qualitylife2 hardship IDReverse pass income cohort BA white Latino  South StrictID StateIDRegLooseDummy StateIDChangeHard, vce (cluster stateFIPS) 


*Testing for colinearity using "collin" program
findit collinby TransIDDummy, sort: logit registered out qualitylife2 hardship IDReverse pass income  cohort BA white Latino South StrictID StateIDRegLooseDummy StateIDChangeHard StateRegIDxIDChange, vce (cluster stateFIPS) 
collin registered out qualitylife2 hardship IDReverse income pass cohort white Latino BA South StrictID StateIDRegLooseDummy StateIDChangeHard
