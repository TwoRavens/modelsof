use "C:\Synchronization Files\Research\peacekeeping\enduring rivalry full agreement-isq.dta"
*This file replicates the probit with selection analysis of full agreements found in Greig and Diehl (2005).  All models estimated in STATA 8.0
*The replication for the ordered probit with selection analysis is conducted using LIMDEP

*Full agreement model for enduring rivalries - Mediation
heckprob fullagreementm hongdis prevneg smdem hecksev hperstal hecktime polity24 prevmed dispinme prevsmem complexm tangiblem peacekee prevattm medrankm, select(mediat3 = heckwar hongdis smdem hecksev hperstal major2 hecktime polity24 prevmed prevneg peacekee)


*Full agreement model for enduring rivalries - Negotiation
heckprob fullagreementn hongdis prevneg smdem hecksev hperstal hecktime polity24 prevmed tangiblen bothinne complexn leadnego peacekee, select(negotia3 = heckwar hongdis smdem hecksev hperstal major2 hecktime polity24 prevmed prevneg peacekee)


*Probit model with selection for civil wars - Mediation
use "C:\Synchronization Files\Research\peacekeeping\civil war mediation data-isq.dta", clear
heckprob agreemen avemnthlntime avemnth lntime tangible bothinitiate complex medlead numneg nummed prevsame peacekeep prevagre ethnoreligious, select(mediated = avemnthlntime avemnth lntime nummed numneg peacekeep sumagre avefrac ethnoreligious)

*Probit model with selection for civil wars - Negotiation
use "C:\Synchronization Files\Research\peacekeeping\civil war negotiation data-isq.dta", clear
heckprob agreemen avemnthlntime avemnth lntime tangible bothini leadnego complex numneg nummed peacekee prevagre ethnoreligious, select(negotiat = avemnthlntime avemnth lntime nummed numneg peacekee sumagre avefrac ethnoreligious)
