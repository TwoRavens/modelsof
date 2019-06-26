*****************JPR R&R Rivals and MK*******************

********In Manuscript*********
****Figure 1= dynamics of rivalry and MK
****Table 1= Cross tabs of raw data
tab wtrivalry mk, chi
****Table 2: Main model and robustness check
tsset ccode year
*Model 1: base 
logit mk l.wtrivalry  mkyear mkyear2 mkyear3, cluster(ccode)

*Model 2: Controls -- no conflict
logit mk l.wtrivalry l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy mkyear mkyear2 mkyear3, cluster(ccode)

*Model 3: RELOGIT
relogit mk lagwtrivalry laglnrgdppc lagpolity2 lagexclid laglnpop lagcoupdummy mkyear mkyear2 mkyear3, cluster(ccode)

*Model 4: Jackknife
logit mk l.wtrivalry l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy mkyear mkyear2 mkyear3, cluster(ccode) vce(jackknife)

*Model 5: Country FE 
xtset ccode year
xtlogit mk l.wtrivalry l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy mkyear mkyear2 mkyear3

*Model 6: full controls
logit mk l.wtrivalry l.civwarmem l.intermem l.lnrgdppc  l.polity2 l.exclid l.lnpopWB l.coupdummy  mkyear mkyear2 mkyear3, cluster(ccode)
corr wtrivalry intermem

*Model 7: Guerrilla Warfare
logit mk l.wtrivalry l.guerdummy l.intermem l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy  mkyear mkyear2 mkyear3, cluster(ccode)
*****Table 5: Additional Analysis
*Model 8: Military Power
logit mk i.lagwtrivalry##c.laglncinc l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy mkyear mkyear2 mkyear3, cluster(ccode)
margins, dydx(lagwtrivalry) at(laglncinc=(-11 (1) 1)) vsquish
marginsplot, recast(line) recastci(rline)

*Model 9: New State
logit mk l.wtrivalry l.newstate l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy mkyear mkyear2 mkyear3, cluster(ccode)

*Model 10: Genocide vs Politicide
biprobit (genocide l.wtrivalry l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy genyr genyr2 genyr3) (politicide l.wtrivalry l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy polyr polyr2 polyr3), cluster(ccode)
*****Table 4: Probing the Rivalry Mechanism
*Model 8: Rivalry Age
logit mk l.totalmids l.totalmidssq l.totalmidscu l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy  mkyear mkyear2 mkyear3, cluster(ccode)

*Model 9: MID Count Rivals only
logit mk l.totalmids l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy  mkyear mkyear2 mkyear3 if wtrivalry==1, cluster(ccode)

*Model 10:Klein Goertz Deihl data Enduring vs Proto rivals only
logit mk l.enduring  l.lnrgdppc l.polity2 l.exclid l.lnpopWB l.coupdummy  mkyear mkyear2 mkyear3 if rival==1, cluster(ccode)
******Table 4: Mediation Analysis
*Mediation Analysis
binary_mediation, dv(mk) mv(lagintermem lagcivwarmem) iv(lagwtrival)
set seed 123456789
bootstrap r(indir_1) r(indir_2) r(tot_ind) r(dir_eff) r(tot_eff),  reps(500): binary_mediation, dv(mk) mv(lagintermem lagcivwarmem) iv(lagwtrival)

*********COMPARING RIVALRY'S TOTAL EFFECT TO THOSE OF CIVIL WAR AND INTERSTATE WAR****
*Civil War
binary_mediation, dv(mk) mv(lagintermem lagwtrival) iv(lagcivwarmem)
set seed 123456789
bootstrap r(indir_1) r(indir_2) r(tot_ind) r(dir_eff) r(tot_eff),  reps(500): binary_mediation, dv(mk) mv(lagintermem lagwtrival) iv(lagcivwarmem)

*Interstate war
binary_mediation, dv(mk) mv(lagwtrival lagcivwarmem) iv(lagintermem)
set seed 123456789
bootstrap r(indir_1) r(indir_2) r(tot_ind) r(dir_eff) r(tot_eff),  reps(500): binary_mediation, dv(mk) mv(lagwtrival lagcivwarmem) iv(lagintermem)




