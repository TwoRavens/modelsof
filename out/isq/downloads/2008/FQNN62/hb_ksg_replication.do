
* REPLICATION DATA FOR HALVARD BUHAUG & KRISTIAN SKREDE GLEDITSCH
* CONTAGION OR CONFUSION? WHY CONFLICTS CLUSTER IN SPACE
* INTERNATIONAL STUCIES QUARTERLY



*** figure 2
twoway (scatter lgdp96l neighlgdp), ytitle(Ln GDP per capita, size(large)) ///
xtitle(Mean ln GDP capita in neighborhood, size(large)) scheme(s1mono)

twoway (scatter polity2l neighpol), ytitle(Polity score, size(large)) ///
xtitle(Mean polity score in neighborhood, size(large)) scheme(s1mono)



*** table 1, full sample
* model 1
logit allons3 neighall neighpol neighpolsq neighlgdp post peaceall, nolog robust

* model 2
logit allons3 ncivwar neighpol neighpolsq neighlgdp post peaceall, nolog robust

* model 3
logit allons3 neighall neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall, nolog robust

* model 4
logit allons3 ncivwar neighpol neighpolsq neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall, nolog robust



*** table 2, conflict neighbors only
* model 5
logit allons3 lnblength lndist ethlink2 lneighbref pop_nc nterr lbd_cum polity2l polity2sq lgdp96l lnpop ///
post peaceall if ncivwar==1, nolog robust

* model 6
logit allons3 lnblength confbord ethlink2 lneighbref pop_nc nterr lbd_cum polity2l polity2sq lgdp96l lnpop ///
post peaceall if ncivwar==1, nolog robust

* model 7, multinomial logit of terr and gov conflicts
mlogit mons3 ethlink2 lneighbref nterr polity2l polity2sq lgdp96l lnpop post peaceall if ncivwar==1, nolog robust

