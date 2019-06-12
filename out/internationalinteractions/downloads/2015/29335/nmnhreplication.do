*Nemeth, Mitchell, Nyman, and Hensel, "Ruling the Sea: Managing Maritime Conflicts through UNCLOS and Exclusive Economic Zones"

*Table 1
*use table1.dta 
tab UNCLOSc EEZc, row column chi2

*Table 2A
use mardyad.dta 
tab eez midissyr, row column chi2
tab eez attbilat, row column chi2
tab eez att3rd, row column chi2
use unclosyr.dta 
tab eez newclaim, row column chi2 

*Table 2B
use mardyad.dta 
tab unclos midissyr, row column chi2
tab unclos attbilat, row column chi2
tab unclos att3rd, row column chi2
use unclosyr.dta 
tab unclos newclaim, row column chi2 

*Table 3, Logit analyses of Peaceful Settlement Attempts
use marsettle.dta
logit agree eez1 eez2 unclos1 unclos2  nonbind3 binding3 mcmigrate mcrest recmidwt relcaps if extentag>1, cluster(dyad)
*Predicted probabilities
*baseline model
estsimp logit agree eez1 eez2 unclos1 unclos2  nonbind3 binding3 mcmigrate mcrest recmidwt relcaps if extentag>1, cluster(dyad)
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 0 mcmigrate 1 mcrest 6.192225 recmidwt .3358531 relcaps .8110573
simqi, pr
*Set One Declared EEZ to 1
setx unclos1 0 unclos2 0 eez1 1 eez2 0 nonbind3 0 binding3 0 mcmigrate 1 mcrest 6.192225 recmidwt .3358531 relcaps .8110573
simqi, pr
*Set Both Declared EEZ to 1
setx unclos1 0 unclos2 0 eez1 0 eez2 1 nonbind3 0 binding3 0 mcmigrate 1 mcrest 6.192225 recmidwt .3358531 relcaps .8110573
simqi, pr
*Set One UNCLOS Member to 1
setx unclos1 1 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 0 mcmigrate 1 mcrest 6.192225 recmidwt .3358531 relcaps .8110573
simqi, pr
*Set Nonbinding to 1
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 1 binding3 0 mcmigrate 1 mcrest 6.192225 recmidwt .3358531 relcaps .8110573
simqi, pr
*Set Binding to 1
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 1 mcmigrate 1 mcrest 6.192225 recmidwt .3358531 relcaps .8110573
simqi, pr
*Set Migratory Stocks to 0
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 0 mcmigrate 0 mcrest 6.192225 recmidwt .3358531 relcaps .8110573
simqi, pr
*Set MCRest to minimum (0)
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 0 mcmigrate 1 mcrest 0 recmidwt .3358531 relcaps .8110573
simqi, pr
*Set MCRest to maximum (0)
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 0 mcmigrate 1 mcrest 10 recmidwt .3358531 relcaps .8110573
simqi, pr
*Set Recmidwt to minimum (0)
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 0 mcmigrate 1 mcrest 6.192225 recmidwt 0 relcaps .8110573
simqi, pr
*Set Recmidwt to maximum (3.1)
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 0 mcmigrate 1 mcrest 6.192225 recmidwt 3.1 relcaps .8110573
simqi, pr
*Set Capability Imbalance to minimum (0.5053024)
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 0 mcmigrate 1 mcrest 6.192225 recmidwt .3358531 relcaps .5053024
simqi, pr
*Set Capability Imbalance to maximum (0.9998651)
setx unclos1 0 unclos2 0 eez1 0 eez2 0 nonbind3 0 binding3 0 mcmigrate 1 mcrest 6.192225 recmidwt .3358531 relcaps .9998651
simqi, pr

*Table 4, Negative Binomial Models on Claim Dyad Year Data
use mardyad.dta
nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 

*Table 5, Predicted Counts
*Note: after each estimation, you have to drop the simulation parameters b1-b10
*Predicted probabilities for Table 4, Model 1
*Baseline for EEZ1 or EEZ2 = 0
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, evestsimp nbreg nmidiss unclos1 unclos2 eez1 eez2 mcmigrate mcrest recmidwt relcaps 
*Set One Declared EEZ to 1
setx unclos1 0 unclos2 0 eez1 1 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Both Declared EEZ to 1
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 1 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Baseline for UNCLOS1 or UNCLOS2 = 0
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set One UNCLOS Member to 1
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 1 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Both UNCLOS Members to 1
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 1 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Migratory Fish Stocks to 0
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 0 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Other Issue Salience to minimum (0)
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 0 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Other Issue Salience to maximum (10)
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 10 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Recent MIDs to minimum (0)
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0 relcaps 0.8439487
simqi, ev
*Set Recent MIDs to maximum (3.5)
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 3.5 relcaps 0.8439487
simqi, ev
*Set Capability Imbalance to minimum (0.5007647)
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.5007647
simqi, ev
*Set Capability Imbalance to maximum (0.9998785)
estsimp nbreg nmidiss eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.9998785
simqi, ev 

*Predicted probabilities for Table 4, Model 2
*Baseline model
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set One Declared EEZ to 1
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 1 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Both Declared EEZ to 1
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 1 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set One UNCLOS Member to 1
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 1 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Both UNCLOS Members to 1
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 1 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Migratory Fish Stocks to 0
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 0 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Other Issue Salience to minimum (0)
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 0 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Other Issue Salience to maximum (10)
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 10 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Recent MIDs to minimum (0)
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0 relcaps 0.8439487
simqi, ev
*Set Recent MIDs to maximum (3.5)
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 3.5 relcaps 0.8439487
simqi, ev
*Set Capability Imbalance to minimum (0.5007647)
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.5007647
simqi, ev
*Set Capability Imbalance to maximum (0.9998785)
estsimp nbreg nbilat eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.9998785
simqi, ev 

*Predicted probabilities for Table 4, Model 3
*Baseline model
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set One Declared EEZ to 1
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 1 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Both Declared EEZ to 1
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 1 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set One UNCLOS Member to 1
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 1 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Both UNCLOS Members to 1
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 1 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Migratory Fish Stocks to 0
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 0 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Other Issue Salience to minimum (0)
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 0 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Other Issue Salience to maximum (10)
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 10 recmidwt 0.1235767 relcaps 0.8439487
simqi, ev
*Set Recent MIDs to minimum (0)
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0 relcaps 0.8439487
simqi, ev
*Set Recent MIDs to maximum (3.5)
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 3.5 relcaps 0.8439487
simqi, ev
*Set Capability Imbalance to minimum (0.5007647)
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.5007647
simqi, ev
*Set Capability Imbalance to maximum (0.9998785)
estsimp nbreg n3rd eez1 eez2 unclos1 unclos2 mcmigrate mcrest recmidwt relcaps 
setx unclos1 0 unclos2 0 eez1 0 eez2 0 mcmigrate 1 mcrest 6.025371 recmidwt 0.1235767 relcaps 0.9998785
simqi, ev 

*Table 6, new claim onset
use unclosyr.dta
logit newclaim eez1 eez2 unclos1 unclos2 democ6 relcaps, cluster (dyad)
*Predicted probabilities
estsimp logit newclaim unclos1 unclos2 eez1 eez2 democ6 relcaps, cluster (dyad)
setx unclos1 0 unclos2 0 eez1 0 eez2 0 democ6 0 relcaps .8562694
simqi, pr
setx unclos1 1 unclos2 0 eez1 0 eez2 0 democ6 0 relcaps .8562694
simqi, pr
setx unclos1 0 unclos2 1 eez1 0 eez2 0 democ6 0 relcaps .8562694
simqi, pr
setx unclos1 0 unclos2 0 eez1 1 eez2 0 democ6 0 relcaps .8562694
simqi, pr
setx unclos1 0 unclos2 0 eez1 0 eez2 1 democ6 0 relcaps .8562694
simqi, pr
setx unclos1 0 unclos2 0 eez1 0 eez2 0 democ6 1 relcaps .8562694
simqi, pr
setx unclos1 0 unclos2 0 eez1 0 eez2 0 democ6 0 relcaps .5
simqi, pr
setx unclos1 0 unclos2 0 eez1 0 eez2 0 democ6 0 relcaps .9999897
simqi, pr

*Table 7, interactive effects
*Calculated with same commands for Table 5 by changing the values of EEZ and UNCLOS together
