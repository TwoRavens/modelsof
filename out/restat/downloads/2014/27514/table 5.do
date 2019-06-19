/*****************Table 5****************/
use hightech.dta, clear

xi: poisson innovation L.ipp1 lnrdstock L.logasset L.logage  i.ind , r cluster(province)

xi: poisson innovation L.ipp1 lnrdstock L.logasset L.logage L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind , r cluster(province)

xi: reg  L.ipp1 L.christian L.british lnrdstock  L.logasset L.logage L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind, r cluster(province)
predict ipp1pre
xi: poisson innovation ipp1pre lnrdstock L.logasset L.logage L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind , r cluster(province)

gen lninnovation=log(innovation+1)
xi: xtabond2 lninnovation L.lninnovation L.ipp1 lnrdstock L.incorrupt L.credit L.gdpgrow L.university L.metropolis  L.logasset L.logage i.year, gmm(lninnovation L.ipp1 lnrdstock L.credit  L.incorrupt  L.gdpgrow L.university L.metropolis L.logasset, lag(2 .))  iv( L.logage i.year) twostep robust

xi: xtabond2 lninnovation L.lninnovation L.ipp1 lnrdstock L.incorrupt L.credit L.gdpgrow L.university L.metropolis  L.logasset L.logage i.year, gmm(lninnovation L.ipp1 lnrdstock L.credit  L.incorrupt  L.gdpgrow L.university L.metropolis L.logasset, lag(2 .))  iv(L.christian L.british L.logage i.year) twostep robust

xi: poisson innovation L.ipp2 lnrdstock L.logasset L.logage  i.ind , r cluster(province)

xi: poisson innovation L.ipp2 lnrdstock L.logasset L.logage L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind , r cluster(province)

xi: reg  L.ipp2  L.christian L.british lnrdstock L.logasset L.logage L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind, r cluster(province)
predict ipp2pre
xi: poisson innovation ipp2pre lnrdstock L.logasset L.logage L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind , r cluster(province)

xi: xtabond2 lninnovation L.lninnovation L.ipp2 lnrdstock L.incorrupt L.credit L.gdpgrow L.university L.metropolis  L.logasset L.logage i.year, gmm(lninnovation L.ipp2 lnrdstock L.credit  L.incorrupt  L.gdpgrow L.university L.metropolis L.logasset, lag(2 .))  iv( L.logage i.year) twostep robust

xi: xtabond2 lninnovation L.lninnovation L.ipp2 lnrdstock L.incorrupt L.credit L.gdpgrow L.university L.metropolis  L.logasset L.logage i.year, gmm(lninnovation L.ipp2 lnrdstock L.credit  L.incorrupt  L.gdpgrow L.university L.metropolis L.logasset, lag(2 .))  iv(L.christian L.british L.logage i.year) twostep robust

