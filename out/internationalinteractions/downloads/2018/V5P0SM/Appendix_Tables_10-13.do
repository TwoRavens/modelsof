
*******************************************************
***REPLICATES TABLES 10, 11, 12, 13 IN APPENDIX********
***RECOUPING AFTER COUP PROOFING***********************
***BROWN, FARISS, and MCMAHON*********2-16-2015********
***INTERNATIONAL INTERACTIONS**************************
*******************************************************


*****SET WORKING DIRECTORY*****
cd 
*******************************


use "RECOUPING_DATA_FOR_PUBLICATION.dta"
xtset ccode year

drop if year < 1970

gen ln_effective_number = ln(effective_number)
gen coup_proof_interact = min_regime*ln_effective_number


***************************************************************
**************************TABLE 10******************************    
***************************************************************

***********ALLIES TESTS WITH COUNTRY FIXED EFFECTS
tabulate ccode, generate(country_dummies)

nbreg defense_allies ln_effective_number rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally l1.defense_allies country_dummie*

nbreg defense_allies  min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally l1.defense_allies country_dummie*

nbreg defense_allies ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally l1.defense_allies country_dummie*

nbreg defense_allies coup_proof_interact ln_effective_number min_regime rival_threat_level_new polity2 Oil  cinc lmtnest mideast US_ally Great_Britain_ally Russia_ally France_ally China_ally l1.defense_allies country_dummie*





