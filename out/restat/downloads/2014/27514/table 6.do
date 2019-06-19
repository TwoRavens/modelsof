/**************Table 6*****************/
use hightech.dta, clear

/***Column 1***/
xi: reg   newsalep  L.ipp1  lnrdstock  L.logasset L.logage   i.ind , r cluster(province)

/***Column 2***/
xi: reg   newsalep  L.ipp1  lnrdstock  L.logasset L.logage  L.incorrupt L.credit L.gdpgrow L.university L.metropolis   i.ind, r  cluster(province)

/***Column 3***/
xi: ivreg2  newsalep  (L.ipp1= L.christian L.british) lnrdstock  L.logasset L.logage  L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind, r first cluster(province)

/**Column 4***/
xi: xtabond2 newsalep L.newsalep  L.ipp1 lnrdstock L.incorrupt  L.credit  L.gdpgrow L.university L.metropolis L.logasset L.logage i.year, gmm(newsalep  L.ipp1 lnrdstock L.credit  L.incorrupt  L.gdpgrow L.university L.metropolis L.logasset , lag(2 .)) iv(L.logage i.year ) twostep robust

/**Column 5***/
xi: xtabond2 newsalep L.newsalep  L.ipp1 lnrdstock L.incorrupt  L.credit  L.gdpgrow L.university L.metropolis L.logasset L.logage i.year, gmm(newsalep  L.ipp1 lnrdstock L.credit  L.incorrupt  L.gdpgrow L.university L.metropolis L.logasset , lag(2 .)) iv(L.christian L.british L.logage i.year) twostep robust

/***Column 6***/
xi: reg   newsalep L.ipp2 lnrdstock L.logasset L.logage  i.ind,  r cluster(province)

/***Column 7***/
xi: reg   newsalep  L.ipp2  lnrdstock  L.logasset L.logage L.incorrupt L.credit L.gdpgrow L.university L.metropolis  i.ind,  r  cluster(province)

/***Column 8***/
xi: ivreg2   newsalep  (L.ipp2= L.christian L.british) lnrdstock  L.logasset L.logage  L.incorrupt L.credit L.gdpgrow L.university L.metropolis   i.ind, r first cluster(province)

/**Column 9***/
xi: xtabond2 newsalep L.newsalep  L.ipp2 lnrdstock L.incorrupt  L.credit  L.gdpgrow L.university L.metropolis L.logasset L.logage i.year , gmm(newsalep  L.ipp2 lnrdstock L.credit  L.incorrupt  L.gdpgrow L.university L.metropolis L.logasset , lag(2 .)) iv(L.logage i.year ) twostep robust

/**Column 10***/
xi: xtabond2 newsalep L.newsalep  L.ipp2 lnrdstock L.incorrupt  L.credit  L.gdpgrow L.university L.metropolis L.logasset L.logage i.year , gmm(newsalep  L.ipp2 lnrdstock L.credit  L.incorrupt  L.gdpgrow L.university L.metropolis L.logasset , lag(2 .)) iv(L.christian L.british L.logage i.year ) twostep robust


