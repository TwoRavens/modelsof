clear all
version 9
set mem 500m
set more off

cd "C:\Users\alixgarcia\Documents\progresa\data oportunidades\Replication Files\Replication Files\Household Analysis-Tables 6-8\povdefTables_6-8\povdefTables_6-8\"

use ecological_footprint_household_analysis.dta, replace


label variable treat "Village chosen to receive Progresa"
label variable per "Post treatment year"
label variable te "Treatment effect"
label variable roadlength "Inverse of road density"
label variable treatrd "Village x inverse road density"
label variable perrd "Post treatment x inverse road density"
label variable terd "Treatment x inverse road density"

est clear

/* Table 6 */
reg ncuartos treat per te if pobre == 1, cl(claveofi)
est2vec consumption, replace e(F r2_a) vars(te terd treat per roadlength treatrd perrd)
reg ncuartos treat per roadlength treatrd perrd te terd if pobre == 1, cl(claveofi)
est2vec consumption, addto(consumption) name(roomsrd)

reg d_res te treat per if pobre == 1, cl(claveofi)
est2vec consumption, addto(consumption) name(beef)
reg d_res te terd treat per roadlength treatrd perrd if pobre == 1, cl(claveofi)
est2vec consumption, addto(consumption) name(beefrd)

reg d_leche te treat per if pobre == 1, cl(claveofi)
est2vec consumption, addto(consumption) name(milk)
reg d_leche te terd treat per roadlength treatrd perrd if pobre == 1, cl(claveofi)
est2vec consumption, addto(consumption) name(milkrd)

est2tex consumption, replace mark(stars) fancy preserve levels(90 95 99) label


/* Table 7 */
reg plots te treat per if pobre == 1, cl(claveofi)
est2vec production, replace e(F r2_a) vars(te terd treat per roadlength treatrd perrd)
reg plots te terd treat per roadlength treatrd perrd if pobre == 1, cl(claveofi)
est2vec production, addto(production) name(plotsrd)

reg lnland te treat per if pobre == 1, cl(claveofi)
est2vec production, addto(production) name(land)
reg lnland te terd treat per roadlength treatrd perrd if pobre == 1, cl(claveofi)
est2vec production, addto(production) name(landrd)

reg vacas te treat per if pobre == 1, cl(claveofi)
est2vec production, addto(production) name(vacas)
reg vacas te terd treat per roadlength treatrd perrd if pobre == 1, cl(claveofi)
est2vec production, addto(production) name(vacasrd)

est2tex production, replace mark(stars) fancy preserve levels(90 95 99) label


/* Table 8 */
reg plots te treat per if pobre == 0, cl(claveofi)
est2vec spillover, replace e(F r2_a) vars(te terd treat per roadlength treatrd perrd)
reg plots te terd treat per roadlength treatrd perrd if pobre == 0, cl(claveofi)
est2vec spillover, addto(spillover) name(plotsrd)

reg lnland te treat per if pobre == 0, cl(claveofi)
est2vec spillover, addto(spillover) name(land)
reg lnland te terd treat per roadlength treatrd perrd if pobre == 0, cl(claveofi)
est2vec spillover, addto(spillover) name(landrd)

reg vacas te treat per if pobre == 0, cl(claveofi)
est2vec spillover, addto(spillover) name(vacas)
reg vacas te terd treat per roadlength treatrd perrd if pobre == 0, cl(claveofi)
est2vec spillover, addto(spillover) name(vacasrd)

est2tex spillover, replace mark(stars) fancy preserve levels(90 95 99) label
