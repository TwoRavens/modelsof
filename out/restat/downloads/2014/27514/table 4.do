/***********Table 4***************/
use hightech.dta, clear
gen ipp1newdebt=L.ipp1*newdebtasset
gen ipp1newexternal=L.ipp1*newexternalasset
gen ipp1internal=L.ipp1*newinternalasset

gen ipp2newdebt=L.ipp2*newdebtasset
gen ipp2newexternal=L.ipp2*newexternalasset
gen ipp2internal=L.ipp2*newinternalasset

gen christiannewdebt=L.christian*newdebtasset
gen christiannewexternal=L.christian*newexternalasset
gen christiannewinternal=L.christian*newinternalasset

gen britishnewdebt=L.british*newdebtasset
gen britishnewexternal=L.british*newexternalasset
gen britishnewinternal=L.british*newinternalasset

/**column 1**/
xi: reg   rdasset newdebtasset newexternalasset  newinternalasset ipp1newdebt ipp1newexternal ipp1internal  L.ipp1  i.ind , cluster(province)

/**column 2**/
xi: reg   rdasset newdebtasset newexternalasset  newinternalasset ipp1newdebt ipp1newexternal ipp1internal  L.ipp1 L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind, cluster(province)  

/**column 3**/
xi: ivreg2   rdasset (L.ipp1 ipp1newdebt ipp1newexternal ipp1internal = L.christian L.british christiannewdebt britishnewdebt christiannewexternal britishnewexternal christiannewinternal britishnewinternal) newdebtasset newexternalasset newinternalasset L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind , cluster(province) first 

/****column 4***/
xi: xtabond2  rdasset L.rdasset L.ipp1 newdebtasset newexternalasset newinternalasset  ipp1newdebt ipp1newexternal ipp1internal L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.year, gmm(rdasset  newdebtasset newexternalasset newinternalasset ipp1newdebt ipp1newexternal ipp1internal L.incorrupt L.credit L.gdpgrow L.university L.metropolis, lag(2 .))  iv(i.year ) twostep  robust

/****column 5**/
xi: xtabond2  rdasset L.rdasset L.ipp1 newdebtasset newexternalasset newinternalasset  ipp1newdebt ipp1newexternal ipp1internal L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.year, gmm(rdasset  newdebtasset newexternalasset newinternalasset ipp1newdebt ipp1newexternal ipp1internal L.incorrupt L.credit L.gdpgrow L.university L.metropolis, lag(2 .))  iv(L.christian L.british christiannewdebt britishnewdebt christiannewexternal britishnewexternal christiannewinternal britishnewinternal i.year ) twostep  robust

/**column 6**/
xi: reg   rdasset newdebtasset newexternalasset newinternalasset ipp2newdebt ipp2newexternal ipp2internal  L.ipp2  i.ind , cluster(province)

/**column 7**/
xi: reg   rdasset newdebtasset newexternalasset newinternalasset ipp2newdebt ipp2newexternal ipp2internal  L.ipp2  L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind, cluster(province)  

/**column 8***/
xi: ivreg2   rdasset  (L.ipp2 ipp2newdebt ipp2newexternal ipp2internal = L.christian L.british christiannewdebt britishnewdebt christiannewexternal britishnewexternal christiannewinternal britishnewinternal) newdebtasset newexternalasset  newinternalasset  L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.ind , cluster(province) first 

/****column 9***/
xi: xtabond2  rdasset L.rdasset L.ipp2 newdebtasset newexternalasset newinternalasset  ipp2newdebt ipp2newexternal ipp2internal L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.year, gmm(rdasset L.ipp2 newdebtasset newexternalasset newinternalasset ipp2newdebt ipp2newexternal ipp2internal L.incorrupt L.credit L.gdpgrow L.university L.metropolis, lag(2 .))  iv(i.year ) twostep  robust

/****column 10**/
xi: xtabond2  rdasset L.rdasset L.ipp2 newdebtasset newexternalasset newinternalasset  ipp2newdebt ipp2newexternal ipp2internal L.incorrupt L.credit L.gdpgrow L.university L.metropolis i.year, gmm(rdasset L.ipp2 newdebtasset newexternalasset newinternalasset ipp2newdebt ipp2newexternal ipp2internal L.incorrupt L.credit L.gdpgrow L.university L.metropolis, lag(2 .))  iv(L.christian L.british christiannewdebt britishnewdebt christiannewexternal britishnewexternal christiannewinternal britishnewinternal i.year ) twostep  robust
