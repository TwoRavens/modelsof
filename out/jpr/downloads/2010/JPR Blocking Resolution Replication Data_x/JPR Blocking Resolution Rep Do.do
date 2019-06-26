*This file will replicate the analyses presented in "Blocking Resolution: How External States can Prolong Civil Wars"

*Set up data for survival analysis
stset endnd, id(stsetid) failure(status2==1)


*Test effect of intervention on duration (core model)(Table 1 models 1-3)
stcox clearlyindependent lootable logbattledeaths demdum, nohr robust
stcox quasiindependent lootable logbattledeaths demdum, nohr robust
stcox nonindependent lootable logbattledeaths demdum, nohr robust

*Test effect of intervention on duration (controlled model)(Table 1 models 4-7)
stcox clearlyindependent lootable logbattledeaths demdum logpop incompatibility loggdp elf pnbdem coldwardum, nohr robust
stcox quasiindependent lootable logbattledeaths demdum logpop incompatibility loggdp elf pnbdem coldwardum, nohr robust
stcox nonindependent lootable logbattledeaths demdum logpop incompatibility loggdp elf pnbdem coldwardum, nohr robust
stcox intervention lootable logbattledeaths demdum logpop incompatibility loggdp elf pnbdem coldwardum, nohr robust

*Analysis with curvilinear measure of ethnicity (footnote 23)
stcox clearlyindependent lootable logbattledeaths demdum logpop incompatibility loggdp elf elfsquare pnbdem coldwardum, nohr robust
stcox quasiindependent logbattledeaths bdeadbest demdum logpop incompatibility loggdp elf elfsquare pnbdem coldwardum, nohr robust
stcox nonindependent lootable logbattledeaths demdum logpop incompatibility loggdp elf elfsquare pnbdem coldwardum, nohr robust

*Graph difference between conflicts with and without independent interventions (Figure 1)

stcox clearlyindependent lootable logbattledeaths demdum logpop incompatibility loggdp elf pnbdem coldwardum, nohr robust basesurv(base)
stcurve, surv at1(clearlyindependent=1) at2(clearlyindependent=0)

drop base
stcox quasiindependent lootable logbattledeaths demdum logpop incompatibility loggdp elf pnbdem coldwardum, nohr robust basesurv(base)
stcurve, surv at1(quasiindependent=1) at2(quasiindependent=0)

drop base
stcox nonindependent lootable logbattledeaths demdum logpop incompatibility loggdp elf pnbdem coldwardum, nohr robust basesurv(base)
stcurve, surv at1(nonindependent=1) at2(nonindependent=0)

drop base
stcox intervention lootable logbattledeaths demdum logpop incompatibility loggdp elf pnbdem coldwardum, nohr robust basesurv(base)
stcurve, surv at1(intervention=1) at2(intervention=0)






