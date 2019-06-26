Stata code for "Sooner or later: The timing of ethnic conflict onsets after independence," Journal of Peace Research, Vol 53(6), 800-814
stset peaceyear, failure( TEthnFail) id(id)
Global test for non-proportionality: 
quietly stcox excluded downgraded heavily_underrepresented  heavily_overrepresented lnethnprop regional_base lnpcincome  lnpopulation, schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
Model 1: stcox heavily_overrepresented heavily_underrepresented excluded downgraded regional_base lnpcincome lnpopulation lnethnprop, tvc(lnpcincome) texp(ln(_t))  cluster(ccode )
Model 2: relogit TEthnFail heavily_overrepresented heavily_underrepresented excluded downgraded regional_base  lnpcincome lnpopulation lnethnprop peaceyear peaceyear2 peaceyear3,  cluster(ccode)
Model 3: stcox heavily_overrepresented heavily_underrepresented excluded downgraded regional_base lnpcincome lnpopulation lnethnprop war_of_independence lnrugged, tvc(lnpcincome) texp(ln(_t)) cluster(ccode )
Model 4: stcox heavily_overrepresented heavily_underrepresented excluded downgraded regional_base lnpcincome lnpopulation lnethnprop africa, tvc(lnpcincome) texp(ln(_t))  cluster(ccode )
Model 5: stcox heavily_overrepresented heavily_underrepresented excluded downgraded regional_base lnpcincome lnpopulation lnethnprop, tvc(lnpcincome) texp(ln(_t))  shared(ccode )
stset peaceyr, failure( TEthnWar) id(id)
Model 6: stcox heavily_overrepresented heavily_underrepresented excluded downgraded regional_base lnpcincome lnpopulation lnethnprop, tvc(lnpcincome) texp(ln(_t))  cluster(ccode )
stset peaceyear, failure( TEthnFail) id(id)
rc_spline lnratio,nknots(3)
Model 7: stcox _S1_lnpolice_ethnic_imbalance _S2_lnpolice_ethnic_imbalance excluded downgraded regional_base lnpcincome lnpopulation lnethnprop, tvc(lnpcincome) texp(ln(_t))  cluster(ccode )
Additional models not reported in the text:
Model 8:  stcox heavily_overrepresented heavily_underrepresented excluded downgraded regional_base lnpcincome lnpopulation lnethnprop bureaucracy, tvc(lnpcincome) texp(ln(_t))  cluster(ccode )
Model 9: stcox heavily_overrepresented heavily_underrepresented excluded downgraded regional_base lnpcincome lnpopulation lnethnprop elf, tvc(lnpcincome) texp(ln(_t))  cluster(ccode )
Model 10: stcox heavily_overrepresented heavily_underrepresented excluded downgraded regional_base lnpcincome lnpopulation b b2, tvc(lnpcincome) texp(ln(_t))  cluster(ccode )
Model 11: stcox heavily_overrepresented heavily_underrepresented excluded downgraded regional_base lnpcincome lnpopulation lnethnprop elapsed, tvc(lnpcincome) texp(ln(_t))  cluster(ccode )
