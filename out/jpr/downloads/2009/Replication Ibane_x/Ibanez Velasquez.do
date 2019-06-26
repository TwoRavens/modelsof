**Regressions JPR**


use "F:\Andrea Backup\desplazados\datos\municipales\ibanez & velasquez", clear

gen order=cond(consur==0,1,0)
replace order=2 if consur==1
replace order=3 if decl==1
replace order=4 if inscsur==1

***************
*Order Probit *
***************
***********************
* All variables       *
***********************

 ***Individuales Con controles***
xi: oprobit order genjefe mujaband  edad edadcuadrado anos_esc_jefe hindig agricultura_jefe_or dependencia   hlider_rec  tfam enfhogar ptieraban duradesp duradesp2 reactivo intramun definitivo   nbicabecera  chumano_5_24 presion gandina goriental gpacifica gcaribe if barryotver==0 & beneficiario==0, robust 
mfx compute, predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))
mfx compute, predict(outcome(4))

 ***Individuales sin controles***
oprobit order genjefe mujaband  edad edadcuadrado anos_esc_jefe hindig agricultura_jefe_or dependencia   hlider_rec  tfam  enfhogar ptieraban  vivpropia_ori  duradesp duradesp2 reactivo intramun definitivo  nbicabecera  chumano_5_24 presion if barryotver==0 & beneficiario==0, robust 
mfx compute, predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))
mfx compute, predict(outcome(4))

******************
* Vulnerability  *
******************

 ***Individuales Con controles***
xi: oprobit order genjefe mujaband  edad edadcuadrado anos_esc_jefe hindig agricultura_jefe_or dependencia   gandina goriental gpacifica gcaribe if barryotver==0 & beneficiario==0, robust 
mfx compute, predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))
mfx compute, predict(outcome(4))

 ***Individuales sin controles***
oprobit order genjefe mujaband  edad edadcuadrado anos_esc_jefe hindig agricultura_jefe_or dependencia   if barryotver==0 & beneficiario==0, robust 
mfx compute, predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))
mfx compute, predict(outcome(4))

*******************************
* Socioeconomic conditions    *
*******************************

 ***With controls*****
xi: oprobit order hlider_rec  tfam enfhogar ptieraban  gandina goriental gpacifica gcaribe if barryotver==0 & beneficiario==0, robust 
mfx compute, predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))
mfx compute, predict(outcome(4))

 ***No controls***
oprobit order hlider_rec  tfam enfhogar  ptieraban if barryotver==0 & beneficiario==0, robust  
mfx compute, predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))
mfx compute, predict(outcome(4))

******************************
* Displacement conditions    *
******************************

 ***With controls*****
xi: oprobit order duradesp duradesp2 reactivo intramun definitivo gandina goriental gpacifica gcaribe if barryotver==0 & beneficiario==0, robust 
mfx compute, predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))
mfx compute, predict(outcome(4))

 ***No controls***
oprobit order duradesp duradesp2 reactivo intramun definitivo if barryotver==0 & beneficiario==0, robust 
mfx compute, predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))
mfx compute, predict(outcome(4))
 
**************************
**************************


