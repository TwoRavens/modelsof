*****************************************************************
***REPLICATES TABLES 2,3,4 FOR RECOUPING AFTER COUP PROOFING*****
***BROWN, FARISS, and MCMAHON*********2-16-2015******************
***INTERNATIONAL INTERACTIONS************************************
*****************************************************************


*****SET WORKING DIRECTORY*****
cd 
*******************************


use "RECOUPING_DATA_FOR_PUBLICATION.dta"
xtset ccode year

drop if year < 1970

gen ln_effective_number = ln(effective_number)
gen coup_proof_interact = min_regime*ln_effective_number


***************************************************************
**************************TABLE 2******************************    
***************************************************************

************************
***PURSUIT NUKE TESTS
************************

replace pursuitnuk = . if acquirenuk == 1

*Model 1, Table 2
xtgee pursuitnuk ln_effective_number rival_threat_level_new polity2 Oil cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally pursuityears pursuityearssquared pursuityearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 2, Table 2
xtgee pursuitnuk min_regime  rival_threat_level_new polity2 Oil cinc lmtnest  mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally pursuityears pursuityearssquared pursuityearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 3, Table 2
xtgee pursuitnuk ln_effective_number min_regime  rival_threat_level_new polity2 Oil cinc lmtnest  mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally  pursuityears pursuityearssquared pursuityearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 4, Table 2
xtgee pursuitnuk coup_proof_interact ln_effective_number min_regime  rival_threat_level_new polity2 Oil cinc lmtnest  mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally pursuityears pursuityearssquared pursuityearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus


***********************
**ACQUIRE NUKE TESTS
***********************

*Model 5, Table 2
xtgee acquirenuk ln_effective_number rival_threat_level_new polity2 Oil cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally  acquirenukyears acquirenukyearsquared acquirenukyearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 6, Table 2
xtgee acquirenuk min_regime rival_threat_level_new polity2 Oil cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally  acquirenukyears acquirenukyearsquared acquirenukyearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 7, Table 2
xtgee acquirenuk   ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally acquirenukyears acquirenukyearsquared acquirenukyearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 8, Table 2
xtgee acquirenuk coup_proof_interact  ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally acquirenukyears acquirenukyearsquared acquirenukyearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus



***************************************************************
**************************TABLE 3******************************    
***************************************************************

****************************
**PURSUIT CB WEAPONS TESTS
****************************

replace CBWpursuit = . if CBWpossess == 1

*Model 1, Table 3
xtgee CBWpursuit ln_effective_number rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally CBWpursuityears CBWpursuityearssquared CBWpursuityearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 2, Table 3
xtgee CBWpursuit min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally  CBWpursuityears CBWpursuityearssquared CBWpursuityearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 3, Table 3
xtgee CBWpursuit ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally  CBWpursuityears CBWpursuityearssquared CBWpursuityearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 4, Table 3
xtgee CBWpursuit   coup_proof_interact ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally CBWpursuityears CBWpursuityearssquared CBWpursuityearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

***************************
**ACQUIRE CB WEAPONS TESTS
***************************

*Model 5, Table 3
xtgee CBWpossess ln_effective_number rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally CBWpossessyears CBWpossessyearssquared CBWpossessyearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 6, Table 3
xtgee CBWpossess min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally CBWpossessyears CBWpossessyearssquared CBWpossessyearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 7, Table 3
xtgee CBWpossess ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally    CBWpossessyears CBWpossessyearssquared CBWpossessyearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus

*Model 8, Table 3
xtgee CBWpossess coup_proof_interact ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally  CBWpossessyears CBWpossessyearssquared CBWpossessyearscubed, i(ccode) fam(bin) link(logit) corr(ind) robus


***************************************************************
**************************TABLE 4******************************    
***************************************************************

*****************
**ALLIES TESTS
*****************

nbreg defense_allies ln_effective_number rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally l1.defense_allies, robust

nbreg defense_allies  min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally l1.defense_allies, robust

nbreg defense_allies ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally l1.defense_allies, robust

nbreg defense_allies coup_proof_interact ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally l1.defense_allies, robust



********************************END**************************************

    
