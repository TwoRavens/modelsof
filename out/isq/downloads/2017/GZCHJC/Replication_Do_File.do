
**************************************************************************
*
*	Replication Do File
*	Choosing the Best House in a Bad Neighborhood: 
*	Location Strategies of Human Rights INGOs in the Non-Western World
*	Barry, Bell, Clay, Flynn, and Murdie
*
**************************************************************************


*Table 1

* Model 1
nbreg F.hrosecloc_merge physint con_physint polity20 polity_square orgrights kof_ogi S_all latincarib durable lngdppercap lnpop civilconflict  NGOtargetGTDfilled dictHROngostateviolent  lnreport conhrosecloc lnhrfilled yr12-yr24 if western==0, robust
* Model 2
nbreg F.hrosecloc_merge physint con_physint conphysXphys polity20 polity_square orgrights kof_ogi S_all latincarib durable lngdppercap lnpop civilconflict  NGOtargetGTDfilled dictHROngostateviolent  lnreport conhrosecloc lnhrfilled yr12-yr24 if western==0, robust
* Model 3
nbreg F.numhrfilled physint con_physint polity20 polity_square orgrights kof_ogi S_all latincarib durable lngdppercap lnpop civilconflict  NGOtargetGTDfilled dictHROngostateviolent  lnreport conhrosecloc lnhrfilled yr12-yr24 if western==0, robust
* Model 4
nbreg F.numhrfilled physint con_physint conphysXphys polity20 polity_square orgrights kof_ogi S_all latincarib durable lngdppercap lnpop civilconflict  NGOtargetGTDfilled dictHROngostateviolent  lnreport conlnhrfilled hrosecloc_merge yr11-yr22 if western==0, robust



