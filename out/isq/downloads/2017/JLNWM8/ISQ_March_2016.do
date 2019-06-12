*Replication commands for De Facto States: Survival and Disappearance (1945-2011), forthcoming in International Studies Quarterly

*Table 2 results

*Forceful reintegration
stset duration, failure(eventtype==1) id(dfscode)
stcox dfspriorind colony intl, tvc(mextsupcat dfsinst frag unr vetop) hr efron nolog r cluster(dfscode)

*Peaceful reintegration
stset duration, failure(eventtype==2) id(dfscode)
stcox dfspriorind colony intl, tvc(mextsupcat dfsinst frag vetop) hr efron nolog r cluster(dfscode)

*Transition to statehood
stset duration, failure(eventtype==3) id(dfscode)
stcox intl, tvc(mextsupcat dfsinst frag vetop) hr efron nolog r cluster(dfscode)

*Figure 1
qui stcox dfspriorind colony intl mextsupcat dfsinst frag unr vetop, hr efron nolog r cluster(dfscode)
stcurve, hazard at0(unr = 0) at1(unr = 1) at2(unr = 5) at3(unr = 10)

*Figure 2
qui stcox dfspriorind colony intl mextsupcat dfsinst frag vetop, hr efron nolog r cluster(dfscode)
stcurve, hazard at0(mextsupcat = 0) at1(mextsupcat = 1) at2(mextsupcat = 2) at3(mextsupcat = 3)
stcurve, hazard at0(dfsinst = 1) at1(dfsinst = 2) at2(dfsinst = 4) at3(dfsinst = 8)
stcurve, hazard at0(frag = 1) at1(frag = 2) at2(frag = 4) at3(frag = 8)
stcurve, hazard at0(vetop = 1) at1(vetop = 2) at2(vetop = 4) at3(vetop = 6)

*Figure 3
qui stcox intl mextsupcat dfsinst frag vetop, hr efron nolog r cluster(dfscode)
stcurve, hazard at0(mextsupcat = 0) at1(mextsupcat = 1) at2(mextsupcat = 2) at3(mextsupcat = 3)
stcurve, hazard at0(dfsinst = 1) at1(dfsinst = 2) at2(dfsinst = 4) at3(dfsinst = 8)
stcurve, hazard at0(frag = 1) at1(frag = 2) at2(frag = 4) at3(frag = 8)
stcurve, hazard at0(vetop = 1) at1(vetop = 2) at2(vetop = 4) at3(vetop = 8)
