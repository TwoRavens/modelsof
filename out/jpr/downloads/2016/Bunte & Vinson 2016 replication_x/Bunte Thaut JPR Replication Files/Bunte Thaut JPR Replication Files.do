// ***************************************************************************************
*     Replication Files for 																*
*        Jonas Bunte and Laura Thaut Vinson
*
*        Local Power-Sharing Institutions and Inter-Religious Violence in Nigeria
*
*        Journal of Peace Research															*																							*
// ***************************************************************************************


clear all
set maxvar 32767
capture noisily estimates drop _all
capture noisily scalar drop _all 

cd "~/Desktop/Bunte Thaut JPR Replication Files"
use "Bunte Thaut JPR Replication Files.dta", clear


// *--------+---------+---------+---------+---------+---------+---------+
// Table I) Overall level of violence
// *--------+---------+---------+---------+---------+---------+---------+

// Authors' data
capture drop temp
gen temp = (Bb_7_thaut > 0)
logit temp BH03 BH07 pop_total, iter(30)  
predict pscore_thaut
nbreg Bb_7_thaut i.AA_power i.AD03 pop_total pscore_thaut , iter(30)
nbreg Bb_7_thaut i.AA_power##AD03 pop_total pscore_thaut , iter(30)
nbreg Bb_7_thaut i.AA_power##AD03 pop_total pscore_thaut AD07 AD05 AD04 BP02a BP02b BP02c BP02d BP02e  , iter(30)

// ACLED data
capture drop temp
gen temp = (Bb_7_acled > 0)
logit temp BH03 BH07 pop_total, iter(30)  
predict pscore_acled
nbreg Bb_7_acled i.AA_power i.AD03 pop_total pscore_acled , iter(30)
nbreg Bb_7_acled i.AA_power##AD03 pop_total pscore_acled , iter(30)
nbreg Bb_7_acled i.AA_power##AD03 pop_total pscore_acled AD07 AD05 AD04 BP02a BP02b BP02c BP02d BP02e  , iter(30)

// GDELT data
capture drop temp
gen temp = (Bb_7_gdelt > 0)
logit temp BH03 BH07 pop_total, iter(30)  
predict pscore_gdelt
nbreg Bb_7_gdelt i.AA_power i.AD03 pop_total pscore_gdelt , iter(30)
nbreg Bb_7_gdelt i.AA_power##AD03 pop_total pscore_gdelt , iter(30)
nbreg Bb_7_gdelt i.AA_power##AD03 pop_total pscore_gdelt AD07 AD05 AD04 BP02a BP02b BP02c BP02d BP02e  , iter(30)




// *--------+---------+---------+---------+---------+---------+---------+
// Table II) Elite Rhetoric
// *--------+---------+---------+---------+---------+---------+---------+

// Express intent to cooperate
capture noisily drop pscore
capture noisily drop temp
gen temp = (Cb_13 > 0) 
logit temp BH03 BH07 pop_total, iter(30)  
predict pscore

nbreg Cb_13 i.AA_power i.AD03 pop_total pscore , iter(30)
nbreg Cb_13 i.AA_power##AD03 pop_total pscore , iter(30)
nbreg Cb_13 i.AA_power##AD03 pop_total pscore BP02e BC09 AD07 AD04 AD05 AD02a, iter(30)


// Appeal to others to settle dispute
capture noisily drop pscore
capture noisily drop temp
gen temp = (Cb_12 > 0) 
logit temp BH03 BH07 pop_total, iter(30)  
predict pscore

nbreg Cb_12 i.AA_power i.AD03 pop_total pscore , iter(30)
nbreg Cb_12 i.AA_power##AD03 pop_total pscore , iter(30)
nbreg Cb_12 i.AA_power##AD03 pop_total pscore BP02e BC09 AD07 AD04 AD05 AD02a, iter(30)


// Express intent to meet or negotiate
capture noisily drop pscore
capture noisily drop temp
gen temp = (Cb_16 > 0) 
logit temp BH03 BH07 pop_total, iter(30)  
predict pscore

nbreg Cb_16 i.AA_power i.AD03 pop_total pscore , iter(30)
nbreg Cb_16 i.AA_power##AD03 pop_total pscore , iter(30)
nbreg Cb_16 i.AA_power##AD03 pop_total pscore BP02e BC09 AD07 AD04 AD05 AD02a, iter(30)


// Make a visit
capture noisily drop pscore
capture noisily drop temp
gen temp = (Cb_20 > 0) 
logit temp BH03 BH07 pop_total, iter(30)  
predict pscore

nbreg Cb_20 i.AA_power i.AD03 pop_total pscore , iter(30)
nbreg Cb_20 i.AA_power##AD03 pop_total pscore , iter(30)
nbreg Cb_20 i.AA_power##AD03 pop_total pscore BP02e BC09 AD07 AD04 AD05 AD02a, iter(30)


// Engage in Diplomatic Cooperation
capture noisily drop pscore
capture noisily drop temp
gen temp = (Cb_24 > 0) 
logit temp BH03 BH07 pop_total, iter(30)  
predict pscore

nbreg Cb_24 i.AA_power i.AD03 pop_total pscore , iter(30)
nbreg Cb_24 i.AA_power##AD03 pop_total pscore , iter(30)
nbreg Cb_24 i.AA_power##AD03 pop_total pscore BP02e BC09 AD07 AD04 AD05 AD02a, iter(30)



// *--------+---------+---------+---------+---------+---------+---------+
// Table III) Perception of the general population
// *--------+---------+---------+---------+---------+---------+---------+

gen pop_total2 = pop_total/100 // re-scale so that the coefficients are not 0.000*

// COMPETITION
capture noisily drop pscore1
logit BP02d BH03 BH07 pop_total2, iter(30)  
predict pscore1

logit BP02d i.AA_power i.AD03  pop_total2 pscore1 , iter(30)
logit BP02d i.AA_power##i.AD03  pop_total2 pscore1 , iter(30)
logit BP02d i.AA_power##i.AD03 pop_total2 pscore1 i.AD04 AD05 i.AD06a AD07 i.AD02a i.BD01a i.BC04 i.BC07 i.BC09 i.BC16 i.BC17 i.BA01a, iter(30)

// POLICE
recode BI20 (1=1) (2=0)
capture noisily drop pscore2
logit BI20 BH03 BH07 pop_total2, iter(30)  
predict pscore2

logit BI20 i.AA_power i.AD03  pop_total2 pscore2 , iter(30)
logit BI20 i.AA_power##i.AD03  pop_total2 pscore2 , iter(30)
logit BI20 i.AA_power##i.AD03 pop_total2 pscore2 i.AD04 AD05 i.AD06a AD07 i.AD02a i.BD01a i.BC04 i.BC07 i.BC09 i.BC16 i.BC17 i.BA01a, iter(30)





