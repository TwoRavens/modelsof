/************Table 2**************/
use hightech.dta, clear
gen l_ipp1=L.ipp1
gen l_ipp2=L.ipp2
gen l_patentdumy=L.patentdummy
gen l_rdasset=L.rdasset
gen l_salegrow=L.salegrow
gen l_intangible=L.intangible
gen l_roa=L.roa
gen l_leverage=L.leverage
gen l_logasset=L.logasset
gen l_logage=L.logage
gen l_incorrupt=L.incorrupt
gen l_credit=L.credit
gen l_gdpgrow=L.gdpgrow
gen l_university=L.university
gen l_metropolis=L.metropolis

/**Column 1**/
xi: probit   pnewdebt l_ipp1 l_patentdummy l_rdasset l_salegrow l_intangible l_roa l_leverage l_logasset l_logage i.ind, cluster(province)
mfx, predict(p)

/**Column 2**/
xi: probit   pnewdebt l_ipp1 l_incorrupt l_credit l_gdpgrow l_university l_metropolis l_patentdummy l_rdasset l_salegrow l_intangible l_roa l_leverage l_logasset l_logage i.ind, cluster(province)
mfx, predict(p)

/**Column 3****/
xi: ivreg2  pnewdebt (L.ipp1=L.christian L.british) L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset L.logage i.ind, cluster(province) first 

/*Column 4*/
xi: xtabond2 pnewdebt L.pnewdebt  L.ipp1 L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy  L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset  L.logage i.year, gmm(L.pnewdebt  L.ipp1 L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy  L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset, lag(2 .)) iv(L.logage  i.year) twostep robust 

/*Column 5***/
xi: xtabond2 pnewdebt L.pnewdebt  L.ipp1 L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy  L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset  L.logage i.year, gmm(L.pnewdebt  L.ipp1 L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy  L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset, lag(2 .)) iv(L.christian L.british L.logage  i.year) twostep robust 

/**Column 6****/
xi: probit   pnewdebt l_ipp2 l_patentdummy l_rdasset l_salegrow l_intangible l_roa l_leverage l_logasset l_logage i.ind, cluster(province)
mfx, predict(p)

/**Column 7**/
xi: probit   pnewdebt l_ipp2 l_incorrupt l_credit l_gdpgrow l_university l_metropolis l_patentdummy l_rdasset l_salegrow l_intangible l_roa l_leverage l_logasset l_logage i.ind, cluster(province)
mfx, predict(p)

/**Column 8***/
xi: ivreg2  pnewdebt (L.ipp2=L.christian L.british) L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset L.logage i.ind, cluster(province) first 

/***column 9****/
xi: xtabond2 pnewdebt L.pnewdebt  L.ipp2 L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy  L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset  L.logage i.year, gmm(L.pnewdebt  L.ipp2 L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy  L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset, lag(2 .)) iv(L.logage  i.year) twostep robust 

/***column 10***/
xi: xtabond2 pnewdebt L.pnewdebt  L.ipp2 L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy  L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset  L.logage i.year, gmm(L.pnewdebt  L.ipp2 L.incorrupt L.credit L.gdpgrow L.university L.metropolis L.patentdummy  L.rdasset L.salegrow L.intangible L.roa L.leverage L.logasset, lag(2 .)) iv(L.christian L.british L.logage  i.year) twostep robust 


