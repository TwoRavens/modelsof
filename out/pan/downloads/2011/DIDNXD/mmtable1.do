clear
clear matrix
log using /users/jjacksn/documents/partisan/pa/mmtable1.log, replace
use /users/jjacksn/documents/partisan/pa/mmtable1
* make Table 1
quietly{
*
* replace  missing values in 1952
*
replace util1 = 0 if[util1 == .]
replace util1t = 0 if[util1t == .]
replace util1ed = 0 if[util1ed == .]
replace util1ed16 = 0 if[util1ed16 == .]
*
* create change in party positions 
*
gen dem1 = dem[_n-1]
gen rep1 = rep[_n-1]
gen dem2 = dem[_n-2]
gen rep2 = rep[_n-2]
gen d1dem = dem - dem1
gen d1rep = rep - rep1
gen d2dem = dem1 - dem2
gen d2rep = rep1 - rep2
replace d2dem = 0 if[year <= 1960]
replace d2rep = 0 if[year <= 1960]
*
* convert four year gaps between 1960, 1964 and 1968 to two year gaps with interpolation of party positions
*
gen xd = d1dem/2
gen xr = d1rep/2
replace d1dem = xd if[year == 1964 | year == 1968]
replace d2dem = xd if[year == 1964 | year == 1968]
replace d1rep = xr if[year == 1964 | year == 1968]
replace d2rep = xr if[year == 1964 | year == 1968] 
*
* rescale income changes and create retrospective variable
*
replace growth1 = 10*growth1
replace growth2 = 10*growth2
gen retro1 = growth1 * (2 * incumb - 1)
*
* create age and exerience interactions
*
gen retro1t = retro1*t
gen retro1ed = retro1*ed 
gen retro1ed16 = retro1*ed16 
*
* create squared changes in party gaps and economy
*
gen gro12 = growth1^2
gen gro22 = growth2^2
gen d1gagg2 = d1dem^2 + d1rep^2
gen d2gagg2 = d2dem^2 + d2rep^2
*
* rescale squared economic changes to match squared changes in party gaps
*
sum d1gagg2 if[year > 1956]
gen r1 = r(max)
sum d2gagg2 if[year > 1956]
gen r2 = r(max)
sum gro12 if[year > 1956]
gen r3 = r(max)
sum gro22 if[year > 1956]
gen r4 = r(max)
replace gro12 = r1*gro12/r3
replace gro22 = r2*gro22/r4
*
* create lagged variables
*
gen pid1 = pid[_n-1]
gen pidt1 = pidt[_n-1]
gen pided1 = pided[_n-1]
gen pided161 = pided16[_n-1]
gen util11 = util1[_n-1]
gen retro11 = retro1[_n-1]
gen t1 = t[_n-1]
gen ed1 = ed[_n-1]
gen ed161 = ed16[_n-1]
gen util1t1 = util1t[_n-1]
gen retro1t1 = retro1t[_n-1]
gen util1ed1 = util1ed[_n-1]
gen retro1ed1 = retro1ed[_n-1]
gen util1ed161 = util1ed16[_n-1]
gen retro1ed161 = retro1ed16[_n-1]

*
* create t-2 lags
*
gen pid2 = pid[_n-2]
gen pidt2 = pidt[_n-2]
gen pided2 = pided[_n-2]
gen pided162 = pided16[_n-2]
gen d3gagg2 = d2gagg2[_n-1]
replace d3gagg2 = 0 if[year < 1960]
gen gro32 = gro22[_n-1]
gen dxt = d1gagg2 + d2gagg2 + gro12 + gro22
gen dxt1 = d2gagg2 + d3gagg2 + gro22 + gro32 
drop if[year <= 1956]
gen e1l = 0
  }
*
* Stochastic ECM
*
nl (pid = ({a0=.2} - {g=.4})*pid1 + {d=1}*{a0=.2}*{g=.4}*pid2 + (1 - {a0=.2})*({b0=.4} + {b1=.6}*util1 + {b2=2}*retro1) + {g=.4}*(1- {a0=.2}*{d=1})*({b0=.4} + {b1=.6}*util11 + {b2=2}*retro11)), nolog  
display e(ll)
*
* stochastic ecm with individual heterogeneity
*
nl (pid = ({a0=.2} - {g=.4})*pid1 + {d=1}*{g=.4}*{a0=.2}*pid2 + (1 - {a0=.2})*({b0=.4} + {b1=.6}*util1 + {b2=2}*retro1) + {g=.4}*(1- {d=1}*{a0=.2}*1)*({b0=.4} + {b1=.6}*util11 + {b2=2}*retro11)  /*
*/  + {a1}*(pidt1   - ({b0=.4}*t   +{b1=.6}*util1t  +{b2=2}*retro1t) /*
*/            + {d=1}*{g=.4}*(pidt2 - ({b0=.4}*t1 +{b1=.6}*util1t1 +{b2=2}*retro1t1))) /*
*/  + {a2=.2}*(pided1  - ({b0=.4}*ed  +{b1=.6}*util1ed  +{b2=2}*retro1ed) /*
*/            + {d=1}*{g=.4}*(pided2 - ({b0=.4}*ed1 +{b1=.6}*util1ed1 +{b2=2}*retro1ed1))) /*
*/  + {a3=-.3}*(pided161  -  ({b0=.4}*ed16  +{b1=.6}*util1ed16  +{b2=2}*retro1ed16) /*
*/            + {d=1}*{g=.4}*(pided162 - ({b0=.4}*ed161 +{b1=.6}*util1ed161 +{b2=2}*retro1ed161)))  ), nolog 
display e(ll)
*
* stochastic ecm with temporal heterogeneity
*
nl (pid = ({a0=.2}*exp({c=-.1}*dxt) - {g=.4})*pid1 + {d=1}*{g=.4}*{a0=.2}*exp({c=-.1}*dxt1)*pid2 + (1 - {a0=.2}*exp({c=-.1}*dxt))*({b0=.4} + {b1=.6}*util1 + {b2=2}*retro1) + {g=.4}*(1- {d=1}*{a0=.2}*exp({c=-.1}*dxt1))*({b0=.4} + {b1=.6}*util11 + {b2=2}*retro11)), nolog
display e(ll)
*
* stochastic ecm with individual and temporal heterogeneity
*
nl (pid = ({a0=.2}*exp({c=-.1}*dxt) - {g=.4})*pid1 + {d=1}*{g=.4}*{a0=.2}*exp({c=-.1}*dxt1)*pid2 + (1 - {a0=.2}*exp({c=-.1}*dxt))*({b0=.4} + {b1=.6}*util1 + {b2=2}*retro1) + {g=.4}*(1- {d=1}*{a0=.2}*exp({c=-.1}*dxt1))*({b0=.4} + {b1=.6}*util11 + {b2=2}*retro11)  /*
*/  + {a1}*(exp({c=-.1}*dxt)*pidt1   - exp({c=-.1}*dxt)*({b0=.4}*t   +{b1=.6}*util1t  +{b2=2}*retro1t) /*
*/            + {d=1}*{g=.4}*(exp({c=-.1}*dxt1)*pidt2 - exp({c=-.1}*dxt1)*({b0=.4}*t1 +{b1=.6}*util1t1 +{b2=2}*retro1t1))) /*
*/  + {a2=.2}*(exp({c=-.1}*dxt)*pided1  - exp({c=-.1}*dxt)*({b0=.4}*ed  +{b1=.6}*util1ed  +{b2=2}*retro1ed) /*
*/            + {d=1}*{g=.4}*(exp({c=-.1}*dxt1)*pided2 - exp({c=-.1}*dxt1)*({b0=.4}*ed1 +{b1=.6}*util1ed1 +{b2=2}*retro1ed1))) /*
*/  + {a3=-.3}*(exp({c=-.1}*dxt)*pided161  -  exp({c=-.1}*dxt)*({b0=.4}*ed16  +{b1=.6}*util1ed16  +{b2=2}*retro1ed16) /*
*/            + {d=1}*{g=.4}*(exp({c=-.1}*dxt1)*pided162 - exp({c=-.1}*dxt1)*({b0=.4}*ed161 +{b1=.6}*util1ed161 +{b2=2}*retro1ed161)))  ), nolog 
display e(ll)
nl (pid = ({a0=.2}*exp({c=-.1}*dxt) - {g=.4})*pid1 + {g=.4}*{a0=.2}*exp({c=-.1}*dxt1)*pid2 + (1 - {a0=.2}*exp({c=-.1}*dxt))*({b0=.4} + {b1=.6}*util1 + {b2=2}*retro1) + {g=.4}*(1- {a0=.2}*exp({c=-.1}*dxt1))*({b0=.4} + {b1=.6}*util11 + {b2=2}*retro11)  /*
*/  + {a1}*(exp({c=-.1}*dxt)*pidt1   - exp({c=-.1}*dxt)*({b0=.4}*t   +{b1=.6}*util1t  +{b2=2}*retro1t) /*
*/            + {g=.4}*(exp({c=-.1}*dxt1)*pidt2 - exp({c=-.1}*dxt1)*({b0=.4}*t1 +{b1=.6}*util1t1 +{b2=2}*retro1t1))) /*
*/  + {a2=.2}*(exp({c=-.1}*dxt)*pided1  - exp({c=-.1}*dxt)*({b0=.4}*ed  +{b1=.6}*util1ed  +{b2=2}*retro1ed) /*
*/            + {g=.4}*(exp({c=-.1}*dxt1)*pided2 - exp({c=-.1}*dxt1)*({b0=.4}*ed1 +{b1=.6}*util1ed1 +{b2=2}*retro1ed1))) /*
*/  + {a3=-.3}*(exp({c=-.1}*dxt)*pided161  -  exp({c=-.1}*dxt)*({b0=.4}*ed16  +{b1=.6}*util1ed16  +{b2=2}*retro1ed16) /*
*/            + {g=.4}*(exp({c=-.1}*dxt1)*pided162 - exp({c=-.1}*dxt1)*({b0=.4}*ed161 +{b1=.6}*util1ed161 +{b2=2}*retro1ed161)))  ), nolog 
display e(ll)
gen gammajt = exp(-.129*dxt)
sum util1 retro1 gammajt t
log close


