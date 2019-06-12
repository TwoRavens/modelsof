clear all
cd "..."
insheet using sierraleone_dataset.csv
save sierraleone_dataset, replace

xtset id_chief time

*MAIN MODELS (1-5)
*Pre deployment; Model 1 (time==25 is 1/1999)
nbreg f.civilian_deaths ethnic_pol civilian_deaths ln_pop ln_ppp capdist nlights diamp w_civil excl if time<25, clust(id_ch)
est store Model1

*Full Sample
nbreg f.civilian_deaths ethnic_pol lntr civilian_deaths ln_pop ln_ppp capdist nlights diamp w_civil excl w_lntr, clust(id_ch)
est store Model2

*Interaction
nbreg f.civilian_deaths c.ethnic_pol##c.lntr civilian_deaths ln_pop ln_ppp capdist nlights diamp w_civil excl w_lntr, clust(id_ch)
est store Model3

*CEM replications
cem ethnic_pol prior, tr(pko)

nbreg f.civilian_deaths ethnic_pol lntr civil ln_pop ln_ppp capdist nlights diamp prior w_c excl w_lntr [iweight=cem_w], clust(id_ch) 
est store Model4

nbreg f.civilian_deaths c.ethnic_pol##c.lntr civil ln_pop ln_ppp capdist nlights diamp prior w_c excl w_lntr [iweight=cem_w], clust(id_ch) 
est store Model5

*Figure 3
margins, dydx(lntr) at(ethnic_pol=(.1 (.1) 1)) atmeans
replace where=-.4
marginsplot, recastci(rarea) addplot((scatter where ethnic_pol, ms(none) mlab(pipe)))

*Figure 4
margins,  at(ethnic_pol=(.1 (.1) 1) lntr=(4 7) civil=(200) ) atmeans force
marginsplot, noci

*ROBUSTNESS
*CMP
cmp setup
cmp (lncivil= c.l.ethnic_pol c.lntr_lag l.lncivil l.ln_pop l.ln_ppp l.capdist l.nlights l.diamp l.prior l.w_lnciv l.excl l.w_lntr) (lntr =  l.lncivil l.prior l.ln_pop l.cap l.w_lnc l.w_lntr), indicators($cmp_cont $cmp_cont) clust(id_ch)
est store Model6

cmp (lncivil= c.l.ethnic_pol##c.lntr_lag l.lncivil l.ln_pop l.ln_ppp l.capdist l.nlights l.diamp l.prior l.w_lnc l.excl l.w_lntr) (lntr =  l.lncivil l.prior l.ln_pop l.cap l.w_lnc l.w_lntr), indicators($cmp_cont $cmp_cont) clust(id_ch)
est store Model7

*Troop count
nbreg f.civilian_deaths c.ethnic_pol##c.id_tr civilian_d ln_pop ln_ppp capdist nlights diamp prior w_c excl w_lntr, clust(id_ch)
est store Model8

*Robust mission
nbreg f.civilian_deaths c.ethnic_pol##c.lntr robust civilian_d ln_pop ln_ppp capdist nlights diamp prior w_c excl w_lntr, clust(id_ch)
est store Model9

*PK dummy
nbreg f.civilian_deaths c.ethnic_pol##i.pkd civilian_d ln_pop ln_ppp capdist nlights diamp prior w_c excl, clust(id_ch)
est store Model10

*OLS with FE
xtreg f.lnciv_n c.ethnic_pol##c.lntr lnciv_n ln_pop ln_ppp capdist nlights diamp prior w_lnc excl w_lntr, clust(id_ch) fe
est store Model11


*APPENDIX
*HKS Replication, ModelA1
clear
insheet using Polarization_BoveElia_Africa.csv
save Polarization_BoveElia_Africa.dta, replace
clear
use "HKS_AJPS_conflictmonth.dta"
gen ccode=gwn
replace ccode=531 if ccode==530
merge m:1 year ccode using "Polarization_BoveElia_Africa.dta"
drop if _m!=3
sort ccode year mon
by ccode: gen time=_n
collapse (sum) osvAll brv_AllLag troopLag policeLag militaryobserversLag  (mean) iPol epduration lntpop (max) PKOd active osvAllLagDum incomp, by(ccode year location)
drop if location=="Eritrea"
xtset ccode year
gen pipe="|"
gen where=-1.5
nbreg osvAll c.iPol##c.troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop
est store ModelA1

*Figure A1
margins, dydx(troop) at(iPol=(0 (.1) .3)) atmeans force l(90)
marginsplot, recastci(rarea) 

*Figure A2.1
use sierraleone_dataset, replace
twoway (lfit powerparity ethnic_pol if e(sample)) (scatter powerparity ethnic_pol if e(sample)) 

*Model A2
nbreg f.civil c.powerparity##c.lntr civil ln_pop ln_ppp capdist nlights diamp prior w_c excl w_lntr [iweight=cem_w], clust(id_ch) 
est store ModelA2

*Figure A2.2
margins,  dydx(lntr) at(powerparity=(0 (.1) 1)) atmeans force
replace where=-.8
marginsplot, recastci(rarea) addplot((scatter where powerparity, ms(none) mlab(pipe)))

*Figure A3
twoway (scatter ethnic_pol isolation_ch) (lfit ethnic_pol isolation_ch)

*Model A3
gen lntotpk=ln(id_totpk+1)
nbreg f.civil c.ethnic_pol##c.lntot civil ln_pop ln_ppp capdist nlights diamp prior w_c excl w_lntr, clust(id_ch)
est store ModelA3
