************************************************************************
*STATA code for Schricker (2017) The Search for Rebel Interdependence
*REPRODUCES results from manuscript
*RUN with schricker_taliban_data.dta
*SEE appendix for additional discussion
*CONTACT schricker.2@osu.edu for additional questions
************************************************************************

***********************************
*VARIABLES
*comb2 - Afghan Taliban
*pak_security - Pakistani Taliban
*oper2 - Pakistani Military
*sintime - sine seasonality term
*costime - cosine seasonality term
*isaf - ISAF forces
*surge2 - Surge operationalization
*hm - Mehsud leadership change
***********************************

**********
*ts graphs
**********

twoway tsline comb2 if tin(2008m1, 2013m2), name(graph1,replace) 
twoway tsline pak_security if tin(2008m1, 2013m2), name(graph2,replace) 
twoway tsline oper2 if tin(2008m1, 2013m2), name(graph3,replace) 
graph combine graph1 graph2 graph3, col(1)


************
*main model
************

var comb2 pak_security oper2 if tin(2008m1, 2013m2),exog(sintime costime isaf surge2 hm) lags(1)

varsoc, maxlag(12)
varnorm
varstable
varlmar, mlag(12)
vargranger
varwle

*****************
*irf construction
*****************

irf create order3, set(result) replace step(12)

irf graph oirf, irf(order3) impulse(comb2) response(pak_security) level(68) scheme(tufte)
irf graph oirf, irf(order3) impulse(comb2) response(oper2) level(68) scheme(tufte)
irf graph oirf, irf(order3) impulse(oper2) response(comb2) level(68) scheme(tufte)
irf graph oirf, irf(order3) impulse(oper2) response(pak_security) level(68) scheme(tufte)
irf graph oirf, irf(order3) impulse(pak_security) response(oper2) level(68) scheme(tufte)
irf graph oirf, irf(order3) impulse(pak_security) response(comb2) level(68) scheme(tufte)

********************
*dynamic multipliers
********************

quietly:var comb2 oper2 pak_security if tin(2008m1, 2013m2),exog(sintime costime isaf surge2 hm) lags(1)

irf create dm, step(12) replace
irf table cdm, impulse(surge2) irf(dm) level(68)
irf table cdm, impulse(hm) irf(dm) level(68)
irf table cdm, impulse(isaf) irf(dm) level(68)

irf table cdm, impulse(surge2) irf(dm) level(68)
irf table cdm, impulse(hm) irf(dm) level(68)
irf table cdm, impulse(isaf) irf(dm) level(68)

irf table cdm, impulse(surge2) irf(dm)  level(68)
irf table cdm, impulse(hm) irf(dm)  level(68)
irf table cdm, impulse(isaf) irf(dm)  level(68)


****************************
*toda and yamamoto procedure
****************************

quietly:var comb2  oper2 pak_security if tin(2008m1, 2013m2),exog(sintime costime isaf surge2 hm) lags(1 2)

vargranger

test [comb2]L1.pak_security
test [comb2]L1.oper2
test [pak_security]L1.comb2
test [pak_security]L1.oper2
test [oper2]L1.comb2
test [oper2]L1.pak_security

*****************
*diagnostic tests
*****************

*findit zandrews
zandrews pak_security if tin(2008m1, 2013m2), break(both) graph lagmethod(BIC) 
zandrews comb2 if tin(2008m1, 2013m2), break(both) graph lagmethod(BIC)
zandrews oper2 if tin(2008m1, 2013m2), break(both) graph lagmethod(BIC)
zandrews isaf if tin(2008m1,2013m2),break(both) graph lagmethod(BIC)

*findit roblpr
roblpr comb2 if tin(2008m1, 2013m2)
roblpr oper2 if tin(2008m1, 2013m2)
roblpr pak_security if tin(2008m1, 2013m2)

*findit dfgls
dfgls comb2 if tin(2008m1, 2013m2),maxlag(4)
dfgls pak_security if tin(2008m1, 2013m2),maxlag(4)
dfgls oper2 if tin(2008m1, 2013m2),maxlag(4)

*findit kpss
kpss pak_security if tin(2008m1, 2013m2)
kpss comb2 if tin(2008m1, 2013m2)
kpss oper2 if tin(2008m1, 2013m2)

*pperron
pperron comb2 if tin(2008m1, 2013m2)
pperron oper2 if tin(2008m1, 2013m2)
pperron pak_security if tin(2008m1, 2013m2)

*******************************************************************************
