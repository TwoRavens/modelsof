 
*Elfversson, Emma. Providing security or protecting interests? Government interventions in violent communal conflicts in Africa*



*TABLE I: Descriptive statistics*

summarize intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt prev_int logintensity



*TABLE II: Logit analysis, government intervention* 

*model 1* 
logit intervention posbias negbias logintensity prev_int, cl(country)

*model 2* 
logit intervention landANDauthority gcpcc logintensity prev_int, cl(country)

*model 3* 
logit intervention cinc SBconfl addCCs logintensity prev_int, cl(country)

*model 4* 
logit intervention ttime mnt logintensity prev_int, cl(country)

*model 5* 
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)



*APPENDIX: Logit analysis, government intervention* 

*model 6* 
logit intervention posbias negbias1 landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)

*model 7* 
logit intervention posbias negbias2 landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)

*model 8* 
logit intervention posbias negbias landANDauthority cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)

*model 9* 
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl highCCs ttime mnt logintensity prev_int, cl(country)

*model 10* 
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt highintensity prev_int, cl(country)



*TABLE III: Predicted probabilities*

*posbias* 
estsimp logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
setx cinc median addCCs median SBconfl 0 ttime median mnt median landANDauthority 0 gcpcc median posbias 0 negbias 0 logintensity median prev_int 0 
simqi
setx posbias 1
simqi

*land&authority* 
setx cinc median addCCs median SBconfl 0 ttime median mnt median landANDauthority 0 gcpcc median posbias 0 negbias 0 logintensity median prev_int 0 
simqi
setx landANDauthority 1 
simqi

*posbias + land&authority* 
setx cinc median addCCs median SBconfl 0 ttime median mnt median landANDauthority 1 gcpcc median posbias 0 negbias 0 logintensity median prev_int 0 
simqi
setx posbias 1
simqi

*local income* 
setx cinc median addCCs median SBconfl 0 ttime median mnt median landANDauthority 0 gcpcc p25 posbias 0 negbias 0 logintensity median prev_int 0 
simqi
setx gcpcc median 
simqi
setx gcpcc p75 
simqi
setx gcpcc p99 
simqi

*local income + land&authority* 
setx cinc median addCCs median SBconfl 0 ttime median mnt median landANDauthority 1 gcpcc p25 posbias 0 negbias 0 logintensity median prev_int 0 
simqi
setx gcpcc median 
simqi
setx gcpcc p75 
simqi
setx gcpcc p99 
simqi

*confl* 
setx cinc median addCCs median SBconfl 0 ttime median mnt median landANDauthority 0 gcpcc median posbias 0 negbias 0 logintensity median prev_int 0 
simqi
setx SBconfl 1 
simqi

*cinc: based on appendix, model 8*
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12
estsimp logit intervention posbias negbias landANDauthority cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
setx cinc p25 addCCs median SBconfl 0 ttime median mnt median landANDauthority 0 posbias 0 negbias 0 logintensity median prev_int 0 
simqi
setx cinc median 
simqi
setx cinc p75 
simqi
setx cinc p99 
simqi




*ONLINE APPENDIX - ROBUSTNESS CHECKS*


*BIAS alternatives*

*posbias1*
logit intervention posbias1 negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)

*posbias2*
logit intervention posbias2 negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)

*strongbias*
logit intervention strongbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country) 


*ISSUE alternatives*

*Issue_Terr*
logit intervention posbias negbias Issue_Terr gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)

*Issue_Auth*
logit intervention posbias negbias Issue_Auth gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)


*CINC alternatives*

*GDP/cap*
logit intervention posbias negbias landANDauthority gcpcc GDPcap SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
logit intervention posbias negbias landANDauthority GDPcap SBconfl addCCs ttime mnt logintensity prev_int, cl(country)

*durable*
logit intervention posbias negbias landANDauthority gcpcc durable SBconfl addCCs ttime mnt logintensity prev_int, cl(country)



*DROP COUNTRIES*
drop if countryID==432
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==437
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==438
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==452
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==461
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==471
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==475
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==483
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==490
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==500
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==501
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==520
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==530
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==560
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear

use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if countryID==625
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear



*DROP YEARS*
use "\\filserver.uu.se\ep\home\emmjo215\Desktop\replicationdata.dta"
drop if year<1991
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity prev_int, cl(country)
clear


*TESTING DISTANCE AND ROUGH TERRAIN SEPARATELY*
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime logintensity prev_int, cl(country)
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs mnt logintensity prev_int, cl(country)


*ALTERNATIVE TEMPORAL DEPENDENCE*
*model 1* 
logit intervention posbias negbias logintensity active_t2, cl(country)
*model 2* 
logit intervention landANDauthority gcpcc logintensity active_t2, cl(country)
*model 3* 
logit intervention cinc SBconfl addCCs logintensity active_t2, cl(country)
*model 4* 
logit intervention ttime mnt logintensity active_t2, cl(country)
*model 5* 
logit intervention posbias negbias landANDauthority gcpcc cinc SBconfl addCCs ttime mnt logintensity active_t2, cl(country)

*COUNTRY FIXED EFFECTS*
logit intervention posbias negbias logintensity prev_int i.countryID
logit intervention landANDauthority gcpcc logintensity prev_int i.countryID
logit intervention cinc addCCs SBconfl logintensity prev_int i.countryID
logit intervention ttime mnt logintensity prev_int i.countryID
logit intervention posbias negbias landANDauthority gcpcc cinc addCCs SBconfl ttime mnt logintensity prev_int i.countryID
