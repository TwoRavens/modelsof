* Replication Do File for Peksen and Olson Lounsbery "Beyond the Target State....."[International Interactions]

									*** TABLE 1 ***
*MODEL 1 
logit onset2 lagneighhostile lagneighsupportive lagneighneutral laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb lagincidence decayonset10yeni, robust cluster(ccode)

*MODEL 2 
logit onset2 lagneighhostile lagneighsupportive lagneighneutral laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

*MODEL 3 
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighhumsocialprotection lneighnonhumsocialprotection laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

*MODEL 4 
logit onset2 lagneighhostile lagneighsupportive lagneighneutral laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb lagincidence decayonset10yeni if developed==0, robust cluster(ccode)

*MODEL 5 
logit onset2 lagneighhostile lagneighsupportive lagneighneutral laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)

*MODEL 6 
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighhumsocialprotection lneighnonhumsocialprotection laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)


									*** TABLE 3 ****
*MODEL 1 
logit onset2 laglnneighhostdur laglnneighsuppdur laglnneighneutraldur laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb lagincidence decayonset10yeni, robust cluster(ccode)

*MODEL 2 
logit onset2 laglnneighhostdur laglnneighsuppdur laglnneighneutraldur laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

*MODEL 3
logit onset2 laglnneighhostdur laglnneighsuppdur laglnneighneutraldur lneighhumsocialprotection lneighnonhumsocialprotection laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

*MODEL 4
logit onset2 laglnneighhostdur laglnneighsuppdur laglnneighneutraldur laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb lagincidence decayonset10yeni if developed==0, robust cluster(ccode)

*MODEL 5 
logit onset2 laglnneighhostdur laglnneighsuppdur laglnneighneutraldur laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)

*MODEL 6
logit onset2 laglnneighhostdur laglnneighsuppdur laglnneighneutraldur lneighhumsocialprotection lneighnonhumsocialprotection laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)



									*** TABLE 2 - Substantive Impact - PR Changes ****

logit onset2 lagneighhostile lagneighsupportive lagneighneutral laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

*
prchange, x(lagneighhostile==0 lagneighsupportive==0 lagneighneutral==0 lagoil==0 lagdemocracy1==0 laganocracy==0  lagsalehcivwarneigh==0 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)

*PR Changes
*  0 to 1 for hostile intv in nb
prchange, x(lagneighhostile==1 lagneighsupportive==0 lagneighneutral==0 lagoil==0 lagdemocracy1==0 laganocracy==0  lagsalehcivwarneigh==0 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)

* 0 to 1 for supportive intv in nb
prchange, x(lagneighhostile==0 lagneighsupportive==1 lagneighneutral==0 lagoil==0 lagdemocracy1==0 laganocracy==0  lagsalehcivwarneigh==0 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)

* Mean + 1 std. dv for GDP per capita
prchange, x(laggledgdplog==9.25 lagneighhostile==0 lagneighsupportive==0 lagneighneutral==0 lagoil==0  lagdemocracy1==0 laganocracy==0  lagsalehcivwarneigh==0 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)

* Mean + 1 std. dv for population
prchange, x(laggledpoplog==10.5 lagneighhostile==0 lagneighsupportive==0 lagneighneutral==0 lagoil==0 lagdemocracy1==0 laganocracy==0   lagsalehcivwarneigh==0 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)

* 0 to 1 for oil producer
prchange, x(lagneighhostile==0 lagneighsupportive==0 lagneighneutral==0 lagoil==1 lagdemocracy1==0 laganocracy==0   lagsalehcivwarneigh==0 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)

* Mean + 1 std. dv for ethfrac
prchange, x(ethfrac==.68 lagneighhostile==0 lagneighsupportive==0 lagneighneutral==0 lagoil==0 lagdemocracy1==0 laganocracy==0   lagsalehcivwarneigh==0 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)

* 0 to 1 for anocracy
prchange, x(lagneighhostile==0 lagneighsupportive==0 lagneighneutral==0 lagoil==0 lagdemocracy1==0 laganocracy==1   lagsalehcivwarneigh==0 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)

* 0 to 1 for civil war in nb
prchange, x(lagneighhostile==0 lagneighsupportive==0 lagneighneutral==0 lagoil==0 lagdemocracy1==0 laganocracy==0   lagsalehcivwarneigh==1 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)

* Mean + 1 std. dv for refugees in nb
prchange, x(lagrefugenb== 6.04 lagneighhostile==0 lagneighsupportive==0 lagneighneutral==0 lagoil==0 lagdemocracy1==0 laganocracy==0   lagsalehcivwarneigh==0 lagrivalnb==0 asia==0 eeurop==0 lamerica==0 nafrme==0 ssafrica==0 lagincidence==0) rest(mean)




* APPENDIX - ROBUSTNESS TESTS [See footnote # 4 in the manuscript]

* Revision # 1a Global Model - Global Model - Different Goals of Interventionvs (HumanSocProtec; Strategicintv ; Economicintv ; Milatarterintv ) 
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighhumsocialprotection lneighstrategicintv lneigheconomicintv lneighmilatarterintv laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

* Revision # 1b Developing Countries Only - Different Goal of Intvs (HumanSocProtec; Strategicintv ; Economicintv ; Milatarterintv ) 
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighhumsocialprotection lneighstrategicintv lneigheconomicintv lneighmilatarterintv laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)


* Revision # 2a Global Model - Intv by Neighboring Countries and Intv. by Great Powers Together
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighgpintv lintvbyneighbor laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

* Revision # 2b Developing Countries Only- Intv by Neighboring Countries and Intv. by Great Powers Together
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighgpintv lintvbyneighbor laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)


* Revision # 3a Global Model - Intv. by US controlled
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighuspresence laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

* Revision # 3b Developing Countries Only - Intv. by US controlled
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighuspresence laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)


* Revision # 4a Global Model - Intv by IGOs vs. Unilateral Intv
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighiopresence lneighunilateral laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

* Revision # 4b Developing Countries Only - Intv by IGOs vs. Unilateral Intv
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lneighiopresence lneighunilateral laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)


* Revision # 10a  Global Model - COLD WAR INTERACTION TERMS
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lagnghostile_coldwar coldwar laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

logit onset2 lagneighhostile lagneighsupportive lagneighneutral lagnghsupport_coldwar coldwar laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

logit onset2 lagneighhostile lagneighsupportive lagneighneutral lagnghneutral_coldwar coldwar laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

* Revision # 10b Developing Countries Only - COLD WAR INTERACTION TERMS
logit onset2 lagneighhostile lagneighsupportive lagneighneutral lagnghostile_coldwar coldwar laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)

logit onset2 lagneighhostile lagneighsupportive lagneighneutral lagnghsupport_coldwar coldwar laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)

logit onset2 lagneighhostile lagneighsupportive lagneighneutral lagnghneutral_coldwar coldwar laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)

*Revision # 11a Global Model - Intervention cases by a Neighboring Intervener Omitted
logit onset2  laghostilealt lagsuppalt lagneutralt laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia eeurop lamerica nafrme ssafrica lagincidence decayonset10yeni, robust cluster(ccode)

*Revision # 11b Develpoing Countries Only - Intervention cases by a Neighboring Intervener Omitted
logit onset2  laghostilealt lagsuppalt lagneutralt laggledgdplog laggledpoplog lagoil ethfrac lagdemocracy1 laganocracy laggrowth  bordercountries lagsalehcivwarneigh lagrivalnb lagrefugenb asia lamerica nafrme ssafrica lagincidence decayonset10yeni if developed==0, robust cluster(ccode)



