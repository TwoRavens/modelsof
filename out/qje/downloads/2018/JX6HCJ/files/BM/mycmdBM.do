
global cluster = ""

use DatBM, clear

renpfix OPtestzOPtreat OPtestztreat

global i = 1
global j = 1

*Table 2
mycmd (OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA) reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtreat1 FTreat4 OPpuzzletypeA) reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtestztreat1 OPtestztreat2 OPtestztreat4 OPtestztreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA) reg ref OPtestztreat1 OPtestztreat2 OPtestztreat4 OPtestztreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6

*Table 3
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) probit ref OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman reftestz OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 4
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) probit ref OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 5
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7





