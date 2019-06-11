



***** Emilia Justyna Powell*****
*****"Two courts two roads? Domestic Rule of law and Legitimacy of International Courts."*****Foreign Policy Analysis 2012



***1) ICC MODELS ***

* with ICRG rule of law measure


estsimp logit ratification civil common mixed laworder demdum2 militexpend laganytorture pacsett if lagratification==0, robust



* with CIM (contract intensive money) Souva (too few observations for the markov transition logit model)

logit ratification civil common mixed cimup demdum2 militexpend laganytorture pacsett, robust


*with Henish measure of judicial independence

estsimp logit ratification civil common mixed hen demdum2 militexpend laganytorture pacsett if lagratification==0, robust







***************************************************************
*ICJ MODELS



*with ICRG rule of law (1984-2002)
logit icjacc civil islamic mixed demdum cinc laworder llength pacsett  terall if icjacclag==0, robust

*in the below models islamic law variable was not included because it was immediately dropped from the model. If it is left in the model, results are highly similar.
*with contract intensive money measure (Souva) (1984-2000) 

logit icjacc civil  mixed demdum cinc  cimup llength pacsett  terall if icjacclag==0, robust
logit icjacc civil islamic mixed demdum cinc  cimup llength pacsett  terall if icjacclag==0, robust


*with Henish measure of judicial independence (1984-2002)

 logit icjacc civil mixed demdum cinc hen llength pacsett  terall if icjacclag==0, robust
 logit icjacc civil islamic mixed demdum cinc hen llength pacsett  terall if icjacclag==0, robust
