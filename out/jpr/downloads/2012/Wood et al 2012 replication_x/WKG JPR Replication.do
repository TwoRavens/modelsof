use "WKG JPR Rebels Replication.dta"

**Table 1 (WITH LAGGED DUMMY)

nbreg rebbest2010 lnintv_ratiolag lnratio_scale multreb lnbdbest lnarea age lagpolityalt laggdpper lnlagtpop lngov lagrebdum2010, cl(dyad)

**Table A1 (WITH LAGGED DV)

nbreg rebbest2010 lnintv_ratiolag lnratio_scale multreb lnbdbest lnarea age lagpolityalt laggdpper lnlagtpop lngov lagreb2010, cl(dyad)

**Table A2 (WITH CHANGE DV, RE)

xtreg d.rebbest2010 lnintv_ratiolag lnratio_scale multreb lnbdbest lnarea age lagpolityalt laggdpper lnlagtpop lngov lagreb2010

**Table A3 (WITH CHANGE DV, RE WITH AR1)

xtregar d.rebbest2010 lnintv_ratiolag lnratio_scale multreb lnbdbest lnarea age lagpolityalt laggdpper lnlagtpop lngov lagreb2010






use "WKG JPR Govt Replication.dta"

**Table 1 (WITH LAGGED DUMMY)

nbreg new_gov_best lnintv_ratiolag lnratio maxmult_reb lntotbdeaths lntotarea maxage lagnew_polity new_laggdp new_lnlagtpop lnreb new_laggov_bestdum if rwanda94==0,  cl(ccode)

**Table A1 (WITH LAGGED DV)

nbreg new_gov_best lnintv_ratiolag lnratio maxmult_reb lntotbdeaths lntotarea maxage lagnew_polity new_laggdp new_lnlagtpop lnreb new_laggov_best if rwanda94==0,  cl(ccode)

**Table A2 (WITH CHANGE DV, RE)

xtreg d.new_gov_best lnintv_ratiolag lnratio maxmult_reb lntotbdeaths lntotarea maxage lagnew_polity new_laggdp new_lnlagtpop lnreb new_laggov_best if rwanda94==0

**Table A3 (WITH CHANGE DV, RE WITH AR1)

xtregar d.new_gov_best lnintv_ratiolag lnratio maxmult_reb lntotbdeaths lntotarea maxage lagnew_polity new_laggdp new_lnlagtpop lnreb new_laggov_best if rwanda94==0

**Table A4 (LOGIT, INTERVENTION DV, REBEL ANALYSIS)

logit anyint_rebdum l.lnreb l.lngov lnratio maxage lntotbdeaths anyint_govdum  anylagint_rebdum , cl(ccode)

**Table A4 (LOGIT, INTERVENTION DV, GOVT ANALYSIS)

logit anyint_govdum l.lnreb l.lngov  lnratio maxage lntotbdeaths anylagint_govdum anyint_rebdum , cl(ccode)








