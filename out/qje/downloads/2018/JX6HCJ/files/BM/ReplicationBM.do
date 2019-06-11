

use Kolkata, clear
tab wkid, gen(WKID)
tab OPagegrp, gen(OPAGEGRP)


*Table 2 - All okay

global ifconditions="missingscore~=1"
global controls="i.OPagegrp OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest i.wkid weekend "
global treatvar_1="OPtreat1 OPtreat2 OPtreat4 OPtreat5"
global treatvar_2="OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPtestz"

global numcorrect="(numcorrect==4 | numcorrect==3)"
ge FTreat4=1 if OPtreat4==1 & $numcorrect
replace FTreat4=0 if FTreat4~=1 & OPtreat~=.
ge excludedgroup=1 if OPtreat1==0 & FTreat4==0 & OPtreat2==0 & OPtreat5==0
replace excludedgroup=0 if excludedgroup~=1 & OPtreat<6

xi: reg ref $treatvar_1 $controls if $ifconditions & OPtestz<6
xi: reg ref OPtreat1 FTreat4 $controls if $ifconditions & OPtestz<6  
xi: reg ref $treatvar_2 $controls if $ifconditions & OPtestz<6

*Same regressions without xi (will run faster)

reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
reg ref OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6

*Table 3 - 1st two regressions reported observations off because stata dropped observations
*Covariance matrices in heckmans are all singular because some variables predict success perfectly
*These are dropped (and change in observations) when probit run separately, but retained when run heckman

global treatvar_1="OPtreat1 OPtreat2 "
global treatvar_2="OPtestzOPtreat1 OPtestzOPtreat2  OPtestz  OPtreat1 OPtreat2 "
global ifconditions="missingscore~=1"
global controls="i.OPagegrp OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest i.wkid weekend "

xi: dprobit ref sumrefrain anyrain $treatvar_1 $controls if OP==1 & OPtreat<4 & $ifconditions
xi: dprobit ref sumrefrain anyrain $treatvar_2 $controls if OP==1 & OPtreat<4 & $ifconditions

foreach var in OP_coworkers_REFrep OP_relative_REFrep {
	xi: heckman `var' $treatvar_1 $controls if (OP==1 &  OPtreat<4) & $ifconditions, select (sumrefrain anyrain $treatvar_1 $controls) twostep
	xi: heckman `var' $treatvar_2 $controls if (OP==1 &  OPtreat<4 ) & $ifconditions, select (sumrefrain anyrain $treatvar_2 $controls) twostep
	}

xi: heckman reftestz $treatvar_2 $controls if (OP==1 &  OPtreat<4 ) & $ifconditions, select (sumrefrain anyrain $treatvar_2 $controls) twostep

*Setting up identical regressions without xi

dprobit ref sumrefrain anyrain OPtreat1 OPtreat2 OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 

dprobit ref sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtestz OPtreat1 OPtreat2 OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
probit ref OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 

heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman OP_coworkers_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman OP_relative_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman reftestz OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep

*Table 4 - Same problem as Table 3 above, observations dropped so reported obserations incorrect, heckmans all singular

global treatvar_1="OPtreat4 OPtreat5"
global treatvar_2="OPtestzOPtreat4 OPtestzOPtreat5 OPtestz  OPtreat4 OPtreat5"
global ifconditions="missingscore~=1"
global controls="i.OPagegrp OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest i.wkid weekend "

xi: dprobit ref sumrefrain anyrain $treatvar_1 $controls if OP==1 & OPtreat~=6 & OPtreat~=7 & $ifconditions
xi: dprobit ref sumrefrain anyrain $treatvar_2 $controls if OP==1 & OPtreat~=6 & OPtreat~=7 & $ifconditions

foreach var in OP_coworkers_REFrep OP_relative_REFrep {
	xi: heckman `var' $treatvar_1 $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7 ) & $ifconditions, select (sumrefrain anyrain $treatvar_1 $controls) twostep
	xi: heckman `var' $treatvar_2 $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7 ) & $ifconditions, select (sumrefrain anyrain $treatvar_2 $controls) twostep
	}

*Setting up identical regressions without xi

dprobit ref sumrefrain anyrain OPtreat4 OPtreat5 OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 

dprobit ref sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtestz OPtreat4 OPtreat5 OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
probit ref OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 

heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman OP_coworkers_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman OP_relative_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep


*Table 5 - Again, each heckman regression has a variable completely determining first stage, making V (effectively) singular

global ifconditions="OPtestz~=. & missingscore~=1"
global controls="i.OPagegrp OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest i.wkid weekend "
global treatvar_1="OPtreat4 OPtreat5"
global treatvar_2="OPtestz  OPtreat4 OPtreat5"
global treatvar_3="OPtestzOPtreat4 OPtestzOPtreat5 OPtestz  OPtreat4 OPtreat5"

xi: heckman reftestz $treatvar_1 $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7) & $ifconditions, select (sumrefrain anyrain $treatvar_1 $controls) twostep
xi: heckman reftestz $treatvar_2 $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7) & $ifconditions, select (sumrefrain anyrain $treatvar_2 $controls) twostep
xi: heckman reftestz $treatvar_3 $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7) & $ifconditions, select (sumrefrain anyrain $treatvar_3 $controls) twostep
ge reftestz_e=reftestz
replace reftestz_e=-2.033682 if reftestz==.
xi: reg reftestz_e $treatvar_1 $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7) & $ifconditions
xi: reg reftestz_e $treatvar_2 $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7) & $ifconditions
xi: reg reftestz_e $treatvar_3 $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7) & $ifconditions

*Setting up identical regressions without xi

heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman reftestz OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) twostep
reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
reg reftestz_e OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7


*Table 6 - All okay - Puzzletype is in the controls

global ifconditions="OPtestz~=. & missingscore~=1"
global controls="i.OPagegrp OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest i.wkid weekend "

xi: heckman reftestz antperf_puzzle  $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7) & $ifconditions & OPtestz>0, select (sumrefrain anyrain $controls) twostep
xi: heckman reftestz antperf_puzzle  $controls if (OP==1 &  OPtreat~=6 & OPtreat~=7) & $ifconditions & OPtestz<0, select (sumrefrain anyrain $controls) twostep

*Same without xi

heckman reftestz antperf_puzzle OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest WKID2-WKID18 weekend if (OP==1 &  OPtreat~=6 & OPtreat~=7) & OPtestz~=. & OPtestz>0, select (sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest WKID2-WKID18 weekend) twostep
heckman reftestz antperf_puzzle OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest WKID2-WKID18 weekend if (OP==1 &  OPtreat~=6 & OPtreat~=7) & OPtestz~=. & OPtestz<0, select (sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPpuzzletypeA OPravtest OPdigtest WKID2-WKID18 weekend) twostep

drop if OPtreat > 5
*Do not have OPtestz and hence do not appear in any regression
save DatBM, replace



