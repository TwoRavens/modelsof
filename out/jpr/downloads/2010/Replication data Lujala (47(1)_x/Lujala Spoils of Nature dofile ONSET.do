*				REPLICATION DATA: THE SPOILS OF NATURE (P. LUJALA)

*****************************************************

* This is the do-file to replicate Table III and Appendix 2 for the empirical analysis in the article: 
* 'The Spoils of Nature: Armed Civil Conflict and Rebel Access to Natural Resources' by Päivi Lujala, 
* Journal of Peace Research (2010)

*****************************************************

* DO-FILES
* File 'Lujala Spoils of Nature dofile DURATION' replicates the duration analysis (Table I, Table II, and Appendix 1)
* File 'Lujala Spoils of Nature dofile ONSET' replicates the onset analysis (Table III and Appendix 2)

* DATA-FILES
* File 'Lujala Spoils of Nature data DURATION' is the replication data for the duration analysis (Table I, Table II, and Appendix 1)
* File 'Lujala Spoils of Nature dofile ONSET' is the replication data for the onset analysis (Table III and Appendix 2)

*****************************************************



*				TABLE I: MULTIVARIATE
* Model 9
logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON, nolog cluster(ccode)

* M 10
logistic  onset gdpll popl ALlang polity2l polity2lSQ instab mntn2l SdiaP oilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON, nolog cluster(ccode)

* M 11
logistic  onset gdpll popl ALlang polity2l polity2lSQ instab mntn2l SdiaP onoilp offoilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON, nolog cluster(ccode)

* M 12
logistic  onset  nafrme gdpll popl ALlang polity2l polity2lSQ ///
instab mntn2l SdiaP oilp ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON, nolog cluster(ccode)

* M 13
logistic  onset  nafrme gdpll popl ALlang polity2l polity2lSQ ///
instab mntn2l SdiaP onoilp offoilp ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON, nolog cluster(ccode)


*				APPENDIX 2

*Base models (10 & 11 in Table III)
logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP oilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON, nolog cluster(ccode)

logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP  onoilp offoilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON, nolog cluster(ccode)


*Models with various hydrocarbon dummies
logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP  oild ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON , nolog cluster(ccode)

logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP  onoild offoild ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON , nolog cluster(ccode)

logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP  petp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON , nolog cluster(ccode)

logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP  onpetp offpetp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON , nolog cluster(ccode)

* Models for the time period 1984-2003
logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP  oilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON if year >1983, nolog cluster(ccode)

logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP  onoilp offoilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON if year > 1983, nolog cluster(ccode)

*Models 10-13 without the five outliers
logistic  onset popl gdpll polity2l polity2lSQ instab ALlang mntn2l SdiaP oilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON if res<10, nolog cluster(ccode)

logistic  onset gdpll popl ALlang polity2l polity2lSQ instab mntn2l SdiaP onoilp offoilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON if res<10, nolog cluster(ccode)

logistic  onset gdpll popl ALlang polity2l polity2lSQ instab mntn2l SdiaP oilp nafrme ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON if res<10, nolog cluster(ccode)

logistic  onset gdpll popl ALlang polity2l polity2lSQ instab mntn2l SdiaP onoilp offoilp nafrme ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON if res<10, nolog cluster(ccode)

*Reduced models
logistic  onset gdpll  polity2l polity2lSQ  instab SdiaP oilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON, nolog cluster(ccode)

logistic  onset gdpll  polity2l polity2lSQ  instab SdiaP onoilp offoilp ///
ongoingwar peaceyrsON _spline1ON _spline2ON _spline3ON, nolog cluster(ccode)


