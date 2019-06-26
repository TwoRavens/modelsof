* REPLICATIN DO FILE FOR TAYDAS/PEKSEN, JPR, "Can States Buy Peace? Social Welfare Spending and Civil Conflicts"

**** TABLE 1 ****
***** PRIO CIVIL CONFLICTS - Multivariate
logit onset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.decayonset10 if year>1974, robust cluster(ccode)

*GDP GROWTH
* PRIO CIVIL CONFLICTS - Multivariate
logit onset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.gdppcgrowth l.decayonset10 if year>1974, robust cluster(ccode)

*OIL
*PRIO CIVIL CONFLICTS - Multivariate
logit onset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 oil l.decayonset10 if year>1974, robust cluster(ccode)

*ETHFRAC
*PRIO CIVIL CONFLICTS - Multivariate
logit onset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 ethfrac  l.decayonset10 if year>1974, robust cluster(ccode)

***** PRIO CIVIL WARS - Multivariate
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.decaywarprio10 if year>1974, robust cluster(ccode)

* GDP GROWTH
* PRIO CIVIL WARS - Multivariate
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1  l.gdppcgrowth l.decaywarprio10 if year>1974, robust cluster(ccode)

* OIL
* PRIO CIVIL WARS - Multivariate
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 oil l.decaywarprio10 if year>1974, robust cluster(ccode)

* ETHFRAC
* PRIO CIVIL WARS - Multivariate
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 ethfrac l.decaywarprio10 if year>1974, robust cluster(ccode)

**** TABLE III *****
**** PRIO CIVIL CONFLICTS - Multivariate
* GENERAL PUBLIC SPENDING   
logit onset2 l.totpubspending l.gdplog l.poplog l.democracy1 l.anocracy1 l.decayonset10 if year>1974, robust cluster(ccode)

* MILITARY SPENDING
logit onset2 l.logmilexp l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.decayonset10 if year>1974, robust cluster(ccode)

*  PRIO CIVIL WAR - Multivariate
*GENERAL PUBLIC SPENDING  
logit priowaronset2 l.totpubspending l.gdplog l.poplog l.democracy1 l.anocracy1 l.decaywarprio10 if year>1974, robust cluster(ccode)

*MILITARY SPENDING
logit priowaronset2 l.logmilexp l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.decaywarprio10 if year>1974, robust cluster(ccode)


**** TABLE 2 **** /PREDICTED PROBS USING TABLE 1 (CIVIL CONFLICTS) 1 and 2 Std. Deviations/

* Welfare spending +1 and +2 std. dev.
logit onset2 limputedwelfspend lgdplog lpoplog ldemocracy1 lanocracy1 oil ethfrac  ldecayonset10 if year>1974, robust cluster(ccode)
sum limputedwelfspend lgdplog lpoplog oil ethfrac  if e(sample)

prchange, x(limputedwelfspend==10) rest(mean)

prchange, x(limputedwelfspend==15) rest(mean)

prchange, x(limputedwelfspend==20) rest(mean)


* GDP per capita +1 and +2 std. dev.
logit onset2 limputedwelfspend lgdplog lpoplog ldemocracy1 lanocracy1 oil ethfrac  ldecayonset10 if year>1974, robust cluster(ccode)

prchange, x(lgdplog==7.4) rest(mean)

prchange, x(lgdplog==9) rest(mean)

prchange, x(lgdplog==10.6) rest(mean)


* Population +1 and +2 std. dev.
logit onset2 limputedwelfspend lgdplog lpoplog ldemocracy1 lanocracy1 oil ethfrac  ldecayonset10 if year>1974, robust cluster(ccode)

prchange, x(lgdplog==16) rest(mean)

prchange, x(lgdplog==17.5) rest(mean)

prchange, x(lgdplog==19) rest(mean)


*Oil Exporter from 0 to 1

logit onset2 limputedwelfspend lgdplog lpoplog ldemocracy1 lanocracy1 oil ethfrac  ldecayonset10 if year>1974, robust cluster(ccode)

prchange, x(oil==0) rest(mean)

prchange, x(oil==1) rest(mean)


* Ethnic Fractionalization +1 and +2 std. dev.
logit onset2 limputedwelfspend lgdplog lpoplog ldemocracy1 lanocracy1 oil ethfrac  ldecayonset10 if year>1974, robust cluster(ccode)

prchange, x(ethfrac==0.42) rest(mean)

prchange, x(ethfrac==0.7) rest(mean)

prchange, x(ethfrac==0.98) rest(mean)



** GRAPH: Welfare Spending Graph ---
logit onset2 limputedwelfspend lgdplog lpoplog ldemocracy1 lanocracy1 oil ethfrac  ldecayonset10 if year>1974, robust cluster(ccode)

prgen limputedwelfspend, from (2) to (25) generate(durat) rest(mean) ci 

label variable duratp1 "Probability of Civil Conflict Onset " 

label variable duratx "Welfare Spending (% of GDP)"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(non)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)), ylabel (.01 .015 .02 .025 .03 .035 .040) 

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub



                                         ***APPENDIX: ADDITION MODELS FOR ROBUSTNESS*****

* FEARON AND LAITIN CIVIL WARS - Multivariate
logit flonset l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.decayfearon10 if year>1974, robust cluster(ccode)

* FEARON AND LAITIN CIVIL WARS - GENERAL PUBLIC SPENDING
logit flonset l.totpubspending l.gdplog l.poplog l.democracy1 l.anocracy1 l.decayfearon10 if year>1974, robust cluster(ccode)

* FEARON AND LAITIN CIVIL WARS - WELFARE AND MILITARY SPENDING TOGETHER
logit flonset l.logmilexp l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.decayfearon10 if year>1974, robust cluster(ccode)


***MODELS INCLUDING ONLY FOR DEVELOPING COUNTRIES*** 
*PRIO CIVIL CONFLICTS - Multivariate
logit onset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.decayonset10 if year>1974 &  developedIMF==0, robust cluster(ccode)

* PRIO CIVIL WARS - Multivariate
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.decaywarprio10 if year>1974 &  developedIMF==0, robust cluster(ccode)


***CONTROLS FOR REGIONAL VARIATION*****
*PRIO CIVIL CONFLICTS - Multivariate
logit onset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 eeurop lamerica ssafrica asia nafrme l.decayonset10  if year>1974, robust cluster(ccode)

* PRIO CIVIL WARS - Multivariate
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1  eeurop lamerica ssafrica asia nafrme l.decaywarprio10 if year>1974, robust cluster(ccode)


***INCOME INEQUALITY***
*PRIO CIVIL CONFLICTS - Multivariate without spending
logit onset2 l.gdplog l.poplog l.democracy1 l.anocracy1 l.ipolategini l.decayonset10 if year>1974, robust cluster(ccode)

*PRIO CIVIL CONFLICTS - Multivariate with spending
logit onset2 l.imputedwelfspend  l.gdplog l.poplog l.democracy1 l.anocracy1 l.ipolategini l.decayonset10 if year>1974, robust cluster(ccode)

* PRIO CIVIL WARS - Multivariate without spending
logit priowaronset2 l.gdplog l.poplog l.democracy1 l.anocracy1 l.ipolategini  l.decaywarprio10 if year>1974, robust cluster(ccode)

* PRIO CIVIL WARS - Multivariate with spending
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.ipolategini l.decaywarprio10 if year>1974, robust cluster(ccode)


***UNPACKING ANOCRACY/DEMOCRACY***
*PRIO CIVIL CONFLICTS - Multivariate
logit onset2 l.imputedwelfspend l.gdplog l.poplog  l.xrcomp l.xropen l.xconst l.decayonset10 if year>1974, robust cluster(ccode)

* PRIO CIVIL WARS - Multivariate
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog  l.xrcomp l.xropen l.xconst l.decaywarprio10 if year>1974, robust cluster(ccode)


***CONTROLLING FOR TRADE***
*PRIO CIVIL CONFLICTS - Multivariate
logit onset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.tradelog l.decayonset10 if year>1974, robust cluster(ccode)

*PRIO CIVIL WARS - Multivariate
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.tradelog l.decaywarprio10 if year>1974, robust cluster(ccode)
*outreg2 using cwar4, r2 se bracket excel


***LAGGED DV FOR TEMPORAL DEPENDENCE***
*PRIO CIVIL CONFLICTS - Multivariate
logit onset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1 l.incidence if year>1974, robust cluster(ccode)

*PRIO CIVIL WARS - Multivariate
logit priowaronset2 l.imputedwelfspend l.gdplog l.poplog l.democracy1 l.anocracy1  l.incidence if year>1974, robust cluster(ccode)



