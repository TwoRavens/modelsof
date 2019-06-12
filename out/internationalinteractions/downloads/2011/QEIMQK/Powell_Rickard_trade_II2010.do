 Emilia Justyna Powell and Stephanie Rickard. “International Trade and Domestic 	Legal Systems: Examining the Impact of Islamic law on Bilateral Trade Flows.” 	
	Forthcoming in International Interactions 36(4).

Monadic results 

reg  ltotaltrade civil1 common1 mixed1 lpop gdpm remote3 commonyear civilyear mixedyear year polity2new if year>=1955, robust



dyadic results:

xtpcse ltrade lrgdp  lrgdppc ldist cmcm cvcv cvcm cvI cmI mixeddyad  mid jntd6 rta1 comlang allies comdyad notcomdyad, hetonly
 
 
 *with year interactions:
 xtpcse ltrade lrgdp  lrgdppc ldist cmcm cvcv cvcm cvI cmI mixeddyad cmcmyear cvcvyear cvcmyear cvIyear cmIyear mixeddyadyear IIyear year mid jntd6 rta1  comlang  allies comdyad notcomdyad, hetonly
