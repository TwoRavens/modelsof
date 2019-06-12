

*all IGOs (Table 1, Column A)
probit winnoforce i.supportc10##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)

*Figure 1 (predicted probabilities)
margins supportc10, at(democc==1) 
margins supportc10, at(democc==0)


*Figure 2 (first differences)
margins, dydx(supportc10) at(democc==1)
margins, dydx(supportc10) at(democc==0)


*UN (Table 1, Column B)
probit winnoforce i.unsupportc10##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)

*Figure 1 (predicted probabilities)
margins unsupportc10, at(democc==1) 
margins unsupportc10, at(democc==0)


*Figure 2 (first differences)
margins, dydx(unsupportc10) at(democc==1)
margins, dydx(unsupportc10) at(democc==0)


*regional IGOs (Table 1, Column C)
probit winnoforce i.rsupportc10##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)

*Figure 1 (predicted probabilities)
margins rsupportc10, at(democc==1) 
margins rsupportc10, at(democc==0)


*Figure 2 (first differences)
margins, dydx(rsupportc10) at(democc==1)
margins, dydx(rsupportc10) at(democc==0)



*instrumental variable regression (final models)
*regresion results can be found in SI, Table 2


*First Difference in Figure 3 in main text

*IGOs
qui estsimp probit winnoforce igo1i democc igo2i democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)
setx mean
simqi

*first differences within democracies
simqi, fd(pr) changex(igo1i 0 .35 democc 1 1 igo2i 0 .35)

*first differences wtihin nondemocracies
simqi, fd(pr) changex(igo1i 0 .35 democc 0 0 igo2i 0 0) 


*UN
qui estsimp probit winnoforce unigo1i democc unigo2i democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)
setx mean
simqi

*first differences within democracies
simqi, fd(pr) changex(unigo1i 0 .2 democc 1 1 unigo2i 0 .2)

*first differences wtihin nondemocracies
simqi, fd(pr) changex(unigo1i 0 .2 democc 0 0 unigo2i 0 0) 


*Regional IGOs
qui estsimp probit winnoforce rigo1i democc rigo2i democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)
setx mean
simqi

*first differences within democracies
simqi, fd(pr) changex(rigo1i 0 .15 democc 1 1 rigo2i 0 .15)

*first differences wtihin nondemocracies
simqi, fd(pr) changex(rigo1i 0 .15 democc 0 0 rigo2i 0 0) 

*SI
*Nondemocratic Regimes (Table 1)
*IGO
probit winnoforce i.supportc10##i.democc i.supportc10##i.nodemnow  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)

*UN
probit winnoforce i.unsupportc10##i.democc i.unsupportc10##i.nodemnow  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)

*Regional IGO
probit winnoforce i.rsupportc10##i.democc i.rsupportc10##i.nodemnow  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)


*Major Power capabilities (Table 3)
*igo support
probit winnoforce i.supportc10##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival strongcap, cluster(crisno)

*un support
probit winnoforce i.unsupportc10##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival strongcap, cluster(crisno)

*rigo support
probit winnoforce i.rsupportc10##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival strongcap, cluster(crisno)


*Military Support vs. Diplomatic Support (Table 4)
*use of force 
probit winnoforce i.supportc10f##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)

*diplomacy
probit winnoforce i.supportc10d##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival, cluster(crisno)



*Excluding Military Alliances (Table 5)
*rigo support
 probit winnoforce i.rsupportc10_noa##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival strongcap, cluster(crisno)

*all support
probit winnoforce supportc10_noa##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 cover1a wmd terrorism ideal banksall rival strongcap, cluster(crisno)


*Leader Appeals (Table 6)
probit winnoforce i.asknohelp##i.democc  democt cinc_c cinc_t grvdumc grvdumt mp1 mp2 mpa1 mpa2 wmd terrorism ideal banksall rival, cluster(crisno)


