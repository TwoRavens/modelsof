**** Contentious Federalism Replication Files ********

******************************************************
**** Table 3: Where does Political Violence Occur?  **
**** Use crosssectional.dta                         **
*******************************************************

** Where has it happened? (DV = dummy)
logit dummydepvar billspassed sheriff hateperpop turnout sqthousandmiles pctFederal blmoffices percentpoprural collegecompletion hhincome, vce(boot, cluster(State) reps(1000) seed(10101))
** Get predicted probabilities
margins,  at(sheriff =( 0 1)) atmeans contrast(atcontrast(r._at))
margins,  at(turnout =( 68 77)) atmeans contrast(atcontrast(r._at))
margins,  at(sqthousandmiles =( 2.1 4.8)) atmeans contrast(atcontrast(r._at))
margins,  at(pctFederal =( 39 67)) atmeans contrast(atcontrast(r._at))
margins,  at(blmoffices =(0 1)) atmeans contrast(atcontrast(r._at))
margins,  at(percentpoprural =(49 82)) atmeans contrast(atcontrast(r._at))

** Where has it happened a lot? (DV = count)
nbreg Total billspassed sheriff hateperpop turnout sqthousandmiles pctFederal blmoffices percentpoprural collegecompletion hhincome, vce(boot, cluster(State) reps(1000) seed(10101))


*******************************************************
***** Table 4: When does Political Violence Occur?   **
***** Use panel.dta                                  **
*******************************************************

** When has it happened? (DV = dummy)
xtset FIPS Year
bootstrap, cluster(state) idcluster(newid) group (FIPS) reps(1000) seed(1234): xtlogit dummydepvar sheriff hateperpop turnout lagpasseddummy  unemployment Clinton Obama statedem, i(FIPS) fe
** Get predicted probabilities
margins,  at(Clinton =(0 1)) atmeans contrast(atcontrast(r._at))
margins,  at(lagpasseddummy =(0 1)) atmeans contrast(atcontrast(r._at))
margins,  at(turnout =( 68 77)) atmeans contrast(atcontrast(r._at))

** When has it happened a lot? (DV = count)
xtset FIPS Year
bootstrap, cluster(state) idcluster(newid) group (FIPS) reps(1000) seed(1234): xtnbreg Total  sheriff hateperpop turnout lagpasseddummy  unemployment Clinton Obama statedem, i(FIPS) fe

