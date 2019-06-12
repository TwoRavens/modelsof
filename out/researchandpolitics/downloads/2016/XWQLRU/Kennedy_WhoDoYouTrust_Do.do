gen distdecmakers=distance*decmakers
logit delegation distdecmakers distance decmakers prespop divided adv blanket treas ghwb wjc gwb bho, cluster(agcynum)
logit delegation distdecmakers distance decmakers prespop divided adv blanket treas ghwb wjc gwb bho if named==1, cluster(agcynum)

***Model 1 and Figure 1***
logit delegation c.distance c.decmakers c.distance#c.decmakers c.prespop c.divided c.adv c.blanket c.treas c.ghwb c.wjc c.gwb c.bho, cluster(agcynum)
margins, dydx(distance) at(decmakers=(-0.781(0.1)1.815))
marginsplot, xtitle("Insulation") title("") yline(0)
***

margins, dydx(adv) 
margins, dydx(blanket) 
margins, dydx(treas) 


***Model 2 and Figure 2***
logit delegation c.distance c.decmakers c.distance#c.decmakers c.prespop c.divided c.adv c.blanket c.treas c.ghwb c.wjc c.gwb c.bho if named==1, cluster(agcynum)
margins, dydx(distance) at(decmakers=(-0.781(0.1)1.815))
marginsplot, xtitle("Insulation") title("") yline(0)

margins, dydx(distance) at(decmakers=-0.721)
margins, dydx(distance) at(decmakers=-0.164)
margins, dydx(distance) at(decmakers=0.393)



***

margins, dydx(decmakers) at(distance=(0(1)2))
marginsplot, xtitle("Ideological Distance") title("") yline(0)

margins, dydx(decmakers) at (distance=0)
