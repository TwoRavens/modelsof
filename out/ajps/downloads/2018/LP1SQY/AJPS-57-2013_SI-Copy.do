****AJPS-57-1-2013
use "C:\Users\Adhikari\Desktop\AJPS\COPY\AJPS-57-1-2013_SI-Copy.dta" , clear 
***actual violence
gen actualviolence = 0
recode actualviolence 0 = 1 if  phythreat_self == 1 | abductn_self ==1 | f_mtortre_self ==1 | sxlhrsmnt_self ==1 | thrtqarmy_self == 1| frecruit_self ==1 |fmmurder_cause == 1 
**threat of violence
egen phythreat_impmax = max(phythreat_imp)
egen phythreat_impmin = min(phythreat_imp)
gen pthreat =  (phythreat_imp - phythreat_impmin)/(phythreat_impmax - phythreat_impmin)
egen pcoercion_impmax = max(pcoercion_imp)
egen pcoercion_impmin = min(pcoercion_imp)
gen pcoercion =  (pcoercion_imp - pcoercion_impmin)/(pcoercion_impmax - pcoercion_impmin)
egen frecruit_impmax = max(frecruit_imp)
egen frecruit_impmin = min(frecruit_imp)
gen frecruit =  (frecruit_imp - frecruit_impmin)/(frecruit_impmax - frecruit_impmin)
egen fmmurder_impmax = max(fmmurder_imp)
egen fmmurder_impmin = min(fmmurder_imp)
gen fmmurder =  (fmmurder_imp - fmmurder_impmin)/(fmmurder_impmax - fmmurder_impmin)
egen pmtorture_impmax = max(pmtorture_imp)
egen pmtorture_impmin = min(pmtorture_imp)
gen pmtorture =  (pmtorture_imp - pmtorture_impmin)/(pmtorture_impmax - pmtorture_impmin)
egen sxlhrsmnt_impmax = max(sxlhrsmnt_imp)
egen sxlhrsmnt_impmin = min(sxlhrsmnt_imp)
gen sxlhrsmnt =  (sxlhrsmnt_imp - sxlhrsmnt_impmin)/(sxlhrsmnt_impmax - sxlhrsmnt_impmin)
gen tviolence = pthreat + pcoercion + frecruit + fmmurder +pmtorture + sxlhrsmnt
recode tviolence .=0

gen newlogland = ln(land+1)
recode newlogland .=0

gen crop_cattle_seized = cattleseized_self + cropseized_self

**Social network
gen communityorg =cfugpr +aamapr +sfdppr
recode communityorg (0=0) (1/3 =1) (.=0)

*fixing motor road variable
recode motorroad 3=1

***party
gen NSP = 0
recode NSP 0=1 if party == 1 | party == 2 | party == 8 | party ==  9
gen royalist = 0
recode royalist 0 = 1 if party == 5 | party == 6 | party == 7 
gen nepalicongress = 0
recode nepalicongress 0 = 1 if party == 3
gen UML = 0
recode UML 0 = 1 if party == 4
gen maoists = 0
recode maoists 0 = 1 if party == 11
gen targetedparty =nepalicongress+royalist

***Total Children
gen totalchildren =children_totl
recode totalchildren .=0

***Male
gen newgender =0
recode newgender 0=1 if gender ==2
recode newgender 0=. if gender ==.

recode age 15=18
gen agesq = age*age

gen newdcode =dcode*10000
gen newvcode =vcode*100
gen dvwcode =newdcode+newvcode+ward

/*Table B.4: Probit Analysis of Internal Displacement with Unmatched Data* clustered at the VDC level*/
***Model-1
probit idp  actualviolence tviolence industry income newlogland crop_cattle_seized landseized_self homedestr_cause dstryd_indstry communityorg motorroad maoists, vce(cluster dvwcode)
mfx
***Model-2
probit idp  actualviolence tviolence industry income newlogland crop_cattle_seized landseized_self homedestr_cause dstryd_indstry communityorg motorroad maoists totalchildren education newgender age agesq, vce(cluster dvwcode)
mfx

/*Figure B.2; B.3; B.4*/
*motor road, Figure B.2
probit idp  actualviolence tviolence industry income newlogland crop_cattle_seized landseized_self homedestr_cause dstryd_indstry communityorg motorroad maoists, vce(cluster dvwcode)
prgen tviolence, from(0) to(6) generate(motor1) x(motorroad=1 actualviolence=0 landseized_self=0) rest(mean) n(7)
label var motor1p1 "Motorable Road"
prgen tviolence, from(0) to(6) generate(motor0) x(motorroad=0 actualviolence=0 landseized_self=0) rest(mean) n(7)
label var motor0p1 "No Motorable Road"
list motor1p1 motor0p1 motor1x in 1/7
graph twoway connected motor1p1 motor0p1  motor1x, ytitle("Pr(Being Displaced)") ylabel(0(.25)1) xtitle("Violence")xlabel(0(1)6)  title("Actual Violence =0") saving(Motorroad1, replace)
drop motor1x motor1p0 motor1p1 motor0x motor0p0 motor0p1
prgen tviolence, from(0) to(6) generate(motor1) x(motorroad=1 actualviolence=1 landseized_self=0)  rest(mean) n(7)
label var motor1p1 "Motorable Road"
prgen tviolence, from(0) to(6) generate(motor0) x(motorroad=0 actualviolence=1 landseized_self=0) rest(mean) n(7)
label var motor0p1 "No Motorable Road"
list motor1p1 motor0p1 motor1x in 1/7
graph twoway connected motor1p1 motor0p1  motor1x, ytitle("Pr(Being Displaced)") ylabel(0(.25)1) xtitle("Violence")xlabel(0(1)6) title("Actual Violence =1") saving(Motorroad2, replace)
graph combine Motorroad1.gph Motorroad2.gph, title("Role of Road Without & With Actual Violence")
drop motor1x motor1p0 motor1p1 motor0x motor0p0 motor0p1

**elevation, Figure B.3
probit idp  actualviolence tviolence industry income newlogland crop_cattle_seized landseized_self homedestr_cause dstryd_indstry communityorg elev maoists, vce(cluster dvwcode)

prgen tviolence, from(0) to(6) generate(elev3) x(elev=3 actualviolence=0 landseized_self=0) rest(mean) n(7)
label var elev3p1 "Plains"
prgen tviolence, from(0) to(6) generate(elev2) x(elev=2 actualviolence=0 landseized_self=0) rest(mean) n(7)
label var elev2p1 "Hills"
prgen tviolence, from(0) to(6) generate(elev1) x(elev=1 actualviolence=0 landseized_self=0) rest(mean) n(7)
label var elev1p1 "Mountains"
list elev3p1 elev2p1 elev1p1  in 1/7
graph twoway connected elev3p1 elev2p1 elev1p1 elev1x, ytitle("Pr(Being Displaced)") ylabel(0(.25)1) xtitle("Threat of Violence")xlabel(0(1)6) title("Actual Violence =0") saving(Noviolence, replace)
drop elev3x elev3p0 elev3p1 elev2x elev2p0 elev2p1 elev1x elev1p0 elev1p1 
prgen tviolence, from(0) to(6) generate(elev3) x(elev=3 actualviolence=1 landseized_self=0) rest(mean) n(7)
label var elev3p1 "Plains"
prgen tviolence, from(0) to(6) generate(elev2) x(elev=2 actualviolence=1 landseized_self=0) rest(mean) n(7)
label var elev2p1 "Hills"
prgen tviolence, from(0) to(6) generate(elev1) x(elev=1 actualviolence=1 landseized_self=0) rest(mean) n(7)
label var elev1p1 "Mountains"
list elev3p1 elev2p1 elev1p1  in 1/7
graph twoway connected elev3p1 elev2p1 elev1p1 elev1x, ytitle("Pr(Being Displaced)") ylabel(0(.25)1) xtitle("Threat of Violence")xlabel(0(1)6) title("Actual Violence =1") saving(Violence, replace)
graph combine Noviolence.gph Violence.gph, title("Elevation: Without & With Actual Violence Experienced")
drop elev3x elev3p0 elev3p1 elev2x elev2p0 elev2p1 elev1x elev1p0 elev1p1 
 
**Social network, figure B.4
probit idp actualviolence tviolence industry income newlogland crop_cattle_seized landseized_self homedestr_cause dstryd_indstry communityorg motorroad maoists, vce(cluster dvwcode)

prgen tviolence, from(0) to(6) generate(com1) x(communityorg=1 actualviolence=0)  rest(mean) n(7)
label var com1p1 "Social Network"
prgen tviolence, from(0) to(6) generate(com0) x(communityorg=0 actualviolence=0) rest(mean) n(7)
label var com0p1 "No Social Network"
list com1p1 com0p1 com1x in 1/7
graph twoway connected com1p1 com0p1  com1x, ytitle("Pr(Being Displaced)") ylabel(0(.1)1) xtitle("Threat of Violence")xlabel(0(1)6)  title("Actual Violence =0") saving(comm1, replace)
drop  com1p0 com1p1 com1x com0x com0p0 com0p1
prgen tviolence, from(0) to(6) generate(com1) x(communityorg=1 actualviolence=1)  rest(mean) n(7)
label var com1p1 "Social Network"
prgen tviolence, from(0) to(6) generate(com0) x(communityorg=0 actualviolence=1) rest(mean) n(7)
label var com0p1 "No Social Network"
list com1p1 com0p1 com1x in 1/7
graph twoway connected com1p1 com0p1  com1x, ytitle("Pr(Being Displaced)") ylabel(0(.1)1) xtitle("Threat of Violence")xlabel(0(1)6) title("Actual Violence =1") saving(comm2, replace)
graph combine comm1.gph comm2.gph, title("Role of Social Networks: Without & With Actual Violence")
drop  com1p0 com1p1 com1x com0x com0p0 com0p1

/*********************/
*
/********************/

**Table B.2: DIFFERENCES OF MEANS BEFORE MATCHING
ttest actualviolence, by(idp)
ttest tviolence, by(idp)
ttest industry, by(idp)
ttest income, by(idp)
ttest newlogland, by(idp)
ttest crop_cattle_seized, by(idp)
ttest landseized_self, by(idp)
ttest homedestr_cause, by(idp)
ttest dstryd_indstry, by(idp)
ttest communityorg, by(idp)
ttest motorroad, by(idp)
ttest maoists, by(idp)
ttest totalchildren, by(idp)
ttest education, by(idp)
ttest newgender, by(idp)
ttest age, by(idp)
ttest agesq, by(idp)

***
pscore idp education newgender totalchildren  age agesq, pscore(probit1)
psmatch2 idp education newgender totalchildren  age agesq

**Table B.3
pstest education newgender totalchildren  age agesq, treated(idp)

clear 

/*********************/
/*********************/
*MATCHED SAMPLE
/********************/

use "C:\Users\Adhikari\Desktop\AJPS\COPY\AJPS_matched-Copy.dta", clear
***AJPS BODY OF THE ARTICLE WITH MATCHED SAMPLE
psmatch2 idp education newgender totalchildren  age agesq

**Table B.3
pstest education newgender totalchildren  age agesq, treated(idp)

*Graph B.1 
psgraph, treated(idp)

*FULL MODEL AFTER MATCHING

probit idp  actualviolence tviolence industry income newlogland crop_cattle_seized landseized_self ///
homedestr_cause dstryd_indstry communityorg motorroad maoists, vce(cluster dvwcode)
mfx
probit idp  actualviolence tviolence industry income newlogland crop_cattle_seized landseized_self ///
homedestr_cause dstryd_indstry communityorg motorroad maoists totalchildren education newgender age agesq, vce(cluster dvwcode)
mfx

*Table B.2: DIFFERENCES OF MEANS AFTER MATCHING 
ttest actualviolence, by(idp)
ttest tviolence, by(idp)
ttest industry, by(idp)
ttest income, by(idp)
ttest newlogland, by(idp)
ttest crop_cattle_seized, by(idp)
ttest landseized_self, by(idp)
ttest homedestr_cause, by(idp)
ttest dstryd_indstry, by(idp)
ttest communityorg, by(idp)
ttest motorroad, by(idp)
ttest maoists, by(idp)
ttest totalchildren, by(idp)
ttest education, by(idp)
ttest newgender, by(idp)
ttest age, by(idp)
ttest agesq, by(idp)

***TO CREATE A MATCHED DATASET 
/*
sort _id
gen control=id[_n1]
gen treat=id if _nn==1
drop if _weight==.
sort _id
sum control treat
tab idp
*/
